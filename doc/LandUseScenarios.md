# Land Use Scenario Files in SWAT+

This document describes the land use scenario files used in SWAT+ for managing dynamic land use changes and decision tables.

## Overview

SWAT+ supports dynamic land use scenarios through three related files:
- `scen_lu.dtl` - Land use scenario decision tables
- `scen_dtl.upd` - Scenario decision table updates/controls
- `lu_change_out.txt` - Land use change output (generated during simulation)

## scen_lu.dtl - Land Use Scenario Decision Tables

### Purpose
The `scen_lu.dtl` file defines decision tables for land use scenarios. It allows users to specify conditions and actions that control land use changes during the simulation based on various environmental, temporal, or management conditions.

### File Format
The file follows a structured format similar to other decision table files in SWAT+:

```
Title line describing the decision tables
Number_of_decision_tables

name                     conds      alts      acts
<decision_table_name>    <n_conds>  <n_alts>  <n_acts>

var                      obj   obj_num    lim_var    lim_op  lim_const    alt1  alt2  ...
<variable>               <obj> <ob_num>   <lim_var>  <op>    <const>      <val> <val> ...

act_typ                  obj   obj_num    name       option  const        const2  fp        outcome
<action_type>            <obj> <ob_num>   <name>     <opt>   <const>      <c2>    <file_ptr> <y/n>
```

### File Location
By default, the file is named `scen_lu.dtl` as defined in `src/input_file_module.f90`:
```fortran
character(len=25) :: dtbl_scen = "scen_lu.dtl"
```

### Components

#### Conditions
Conditions define the criteria that must be met for actions to be triggered. Common condition variables include:
- Time-based conditions (year, month, day)
- Environmental conditions (precipitation, temperature, soil moisture)
- Management conditions (crop growth stage, days since last operation)
- Object-specific conditions (HRU, reservoir, channel properties)

#### Alternatives
Alternatives represent different scenarios or rules that can be evaluated. Each condition can have multiple alternative values, and actions are triggered when specific combinations of alternatives are met.

#### Actions
Actions specify what should happen when conditions are met. For land use scenarios, the primary action type is:
- `lu_change` - Changes the land use of an HRU to a different land use type

### Field: FILE_POINTER

#### Purpose
The `FILE_POINTER` field (abbreviated as `fp` in the input file) is a critical component of the action specification. It serves as a cross-reference to link the action with specific database entries or parameter sets.

#### Definition
In the source code (`src/conditional_module.f90`), `file_pointer` is defined as:
```fortran
character(len=25) :: file_pointer = ""  ! pointer for option (ie weir equation pointer)
```

#### Usage for Land Use Changes
For `lu_change` actions, the `FILE_POINTER` field contains the name of the land use type from the land use database (`landuse.lum`). The code cross-references this name to find the corresponding land use configuration:

```fortran
! From dtbl_scen_read.f90
case ("lu_change")
  do ilum = 1, db_mx%landuse
    if (dtbl_scen(i)%act(iac)%file_pointer == lum(ilum)%name) then
      dtbl_scen(i)%act_typ(iac) = ilum
      exit
    end if
  end do
```

#### Other Uses
The `file_pointer` field has different meanings depending on the action type:
- For irrigation: Can be "unlim" for unlimited water source, or a specific water source name
- For fertilizer/pesticide: Points to the application method in `chem_app.ops`
- For harvest: Points to harvest operation type in `harv.ops`
- For reservoir operations: Points to weir equations, measurement data, etc.
- For wetland changes: Points to wetland parameter sets in `wetland.wet`

### Reading Process
The file is read by the `dtbl_scen_read` subroutine in `src/dtbl_scen_read.f90` during model initialization. The subroutine:
1. Checks if the file exists
2. Reads the number of decision tables
3. For each table, reads conditions, alternatives, and actions
4. Cross-references `file_pointer` values with appropriate databases

## scen_dtl.upd - Scenario Decision Table Updates

### Purpose
The `scen_dtl.upd` file controls which decision tables from `scen_lu.dtl` are active during the simulation and how many times each action can be executed.

### File Format
```
Title line
Number_of_updates

max_hits    typ         dtbl
<number>    <type>      <decision_table_name>
...
```

### Fields
- `max_hits`: Maximum number of times the action can be triggered
- `typ`: Type of update (typically "scen" for scenario updates)
- `dtbl`: Name of the decision table from `scen_lu.dtl` to activate

### Reading Process
The file is read by the `cal_cond_read` subroutine in `src/cal_cond_read.f90`:

```fortran
inquire (file="scen_dtl.upd", exist=i_exist)
if (.not. i_exist .or. "scen_dtl.upd" == "null") then
  allocate (upd_cond(0:0))
else
  ! Read the file and populate upd_cond array
  ! Cross-reference with dtbl_scen to find matching decision tables
end if
```

### Usage
During each time step, the model checks `upd_cond` to determine which scenario decision tables should be evaluated. This allows for:
- Limiting the number of times a land use change can occur
- Activating/deactivating specific scenarios
- Managing multiple competing or sequential land use scenarios

## lu_change_out.txt - Land Use Change Output

### Purpose
The `lu_change_out.txt` file is an **output file** (not an input file) that records all land use changes that occur during the simulation. It provides a detailed log for tracking when, where, and how land uses changed.

### When Created
The file is created during model initialization by the `header_lu_change` subroutine in `src/header_lu_change.f90`, which is called from `proc_open` in `src/proc_open.f90`.

**Creation sequence:**
1. Model starts and calls `proc_open`
2. `proc_open` calls `header_lu_change`
3. `header_lu_change` creates the file and writes the header:

```fortran
subroutine header_lu_change
  use basin_module
  
  implicit none 
  !! open lu_change output file 
  open (3612,file="lu_change_out.txt",recl=800)
  write (3612,*) bsn%name, prog
  write (3612,100) 
100 format (1x,'         hru','       year','         mon','         day','     operation', &
      '   lu_before','         lu_after')  
  write (9000,*) "DTBL                      lu_change_out.txt"
  
  return
end subroutine header_lu_change
```

The file is created **before the simulation begins**, during the initialization phase. The header is written immediately, and the file remains open throughout the simulation to record land use changes as they occur.

### File Format
The output file has the following columns:
- `hru`: HRU number where the change occurred
- `year`: Year of the change
- `mon`: Month of the change
- `day`: Day of the month
- `operation`: Type of operation (e.g., "LU_CHANGE", "HRU_FRACTION_CHANGE", "P_FACTOR", etc.)
- `lu_before`: Land use type before the change
- `lu_after`: Land use type after the change (or other values depending on operation type)

### When Written
Data is written to `lu_change_out.txt` whenever a land use change occurs during the simulation. This happens in the `actions` subroutine (`src/actions.f90`) when decision table conditions are met:

```fortran
! Example from actions.f90
write (3612,*) j, time%yrc, time%mo, time%day_mo,  "    LU_CHANGE ",        &
    lu_prev, hru(j)%land_use_mgt_c, "   0   0"
```

Other operations that write to this file include:
- HRU fraction changes
- P-factor (erosion control practice) changes
- Contour farming implementation
- Strip cropping implementation
- Terrace installation
- Tile drain installation

### File Unit
The file uses Fortran unit number 3612 throughout the code.

## Workflow Summary

1. **Setup Phase (before simulation):**
   - User creates `scen_lu.dtl` with decision tables defining land use scenarios
   - User creates `scen_dtl.upd` to control which scenarios are active
   - Model reads both files during initialization
   - Model creates `lu_change_out.txt` and writes header

2. **Simulation Phase (each time step):**
   - Model evaluates active decision tables from `scen_dtl.upd`
   - For each active table, checks conditions from `scen_lu.dtl`
   - If conditions are met, executes actions (e.g., land use change)
   - Records changes in `lu_change_out.txt`

3. **Post-Processing:**
   - User analyzes `lu_change_out.txt` to understand when and where land use changes occurred
   - Output can be used for validation, calibration, or scenario analysis

## Code References

### Key Source Files
- `src/input_file_module.f90` - Defines input file names
- `src/conditional_module.f90` - Defines decision table data structures
- `src/dtbl_scen_read.f90` - Reads `scen_lu.dtl`
- `src/cal_cond_read.f90` - Reads `scen_dtl.upd`
- `src/header_lu_change.f90` - Creates `lu_change_out.txt`
- `src/actions.f90` - Executes actions and writes to output
- `src/time_control.f90` - Controls when decision tables are evaluated
- `src/proc_open.f90` - Initializes output files

### Key Data Structures
- `type (decision_table) :: dtbl_scen(:)` - Array of scenario decision tables
- `type (actions_var)` - Contains action specifications including `file_pointer`
- `type (update_cond) :: upd_cond(:)` - Array of scenario updates from `scen_dtl.upd`

## Example Use Case

### Example 1: Converting All HRUs to Bluestem-Switchgrass on a Specific Date

This real-world example shows how to change all HRUs to a specific land use (bsvg_lum - bluestem-switchgrass) on January 1, 2005:

**scen_lu.dtl:**
```
scen_lu.dtl
1

        DBTL_NAME                CONDS      ALTS      ACTS       
   all_to_bsvg                    2          1         1  
  COND_VAR           OBJ        OBJ_NUMB        LIM_VAR        LIM_OP        LIM_CONST   ALT1 
   jday              null       0               null           -             1           =       
   year_cal          null       0               null           -             2005        =       
   ACT_TYP            OBJ       OBJ_NUMB        ALT_NAME         ALT_OPTION  CONST       CONST2     FILE_POINTER   out1         
   lu_change         hru        0               lulc_chg_1       null        0           0          bsvg_lum       y   
```

**scen_dtl.upd:**
```
scen_dtl.upd
1
   MAX_HITS      NAME              DTABLE
   1             lulc_chg_1        all_to_bsvg
```

**Explanation:**

**scen_lu.dtl components:**
- **DBTL_NAME**: `all_to_bsvg` - Name of the decision table
- **CONDS**: `2` - Two conditions must be met
- **ALTS**: `1` - One alternative (rule set)
- **ACTS**: `1` - One action to perform

**Conditions:**
1. `jday = 1` - Julian day equals 1 (January 1st)
2. `year_cal = 2005` - Calendar year equals 2005

**Action:**
- **ACT_TYP**: `lu_change` - Perform a land use change
- **OBJ**: `hru` - Apply to HRU objects
- **OBJ_NUMB**: `0` - Apply to all HRUs (0 means all matching HRUs)
- **ALT_NAME**: `lulc_chg_1` - Name/identifier for this action (matches NAME in scen_dtl.upd)
- **ALT_OPTION**: `null` - No additional option needed for lu_change
- **CONST**: `0` - Not used for lu_change
- **CONST2**: `0` - Not used for lu_change
- **FILE_POINTER**: `bsvg_lum` - Name of the land use from landuse.lum database to change to
- **out1**: `y` - Perform this action when alternative 1 is met

**scen_dtl.upd components:**
- **MAX_HITS**: `1` - Each HRU can only be changed once
- **NAME**: `lulc_chg_1` - Identifier that matches ALT_NAME in scen_lu.dtl
- **DTABLE**: `all_to_bsvg` - Name of the decision table to activate from scen_lu.dtl

**Result:** On January 1, 2005, all HRUs in the watershed will be converted to bluestem-switchgrass land use (bsvg_lum), but only once (MAX_HITS = 1 prevents repeated changes).

### Example 2: Conditional Land Use Change Based on Area

Converting agricultural land to forest when certain conditions are met:

**scen_lu.dtl:**
```
Land use scenario example
1

name                     conds      alts      acts
ag_to_forest            2          1         1
var                      obj   obj_num    lim_var    lim_op  lim_const    alt1
year                     null       0       null         -    2030         >
hru_area                 hru        0       null         -    10.0         >
act_typ                  obj   obj_num    name       option  const    const2    fp          outcome
lu_change                hru        0       forest_scen  null    0.0      0.0       forest      y
```

**scen_dtl.upd:**
```
Scenario updates
1

max_hits    typ         dtbl
1           scen        ag_to_forest
```

This would change HRUs larger than 10 hectares to forest land use after year 2030, but only once per HRU (max_hits = 1).

### Field Descriptions

**In scen_lu.dtl:**
- **DBTL_NAME/name**: Unique identifier for the decision table
- **COND_VAR/var**: The condition variable to check (jday, year_cal, hru_area, etc.)
- **OBJ**: The object type (hru, res, null for time-based conditions)
- **OBJ_NUMB**: Specific object number (0 = all objects of that type)
- **LIM_VAR**: Limit variable (used for some conditions)
- **LIM_OP**: Limit operator (-, *, +)
- **LIM_CONST**: Limit constant value
- **ALT1, ALT2, ...**: Alternative values (=, <, >, <=, >=, or specific values)
- **ACT_TYP**: Type of action (lu_change, irrigate, fertilize, etc.)
- **ALT_NAME/name**: Name/identifier for the action (can be used to track or reference the action)
- **ALT_OPTION/option**: Additional option specific to action type
- **CONST**: First constant (usage depends on action type)
- **CONST2**: Second constant (usage depends on action type)
- **FILE_POINTER**: Cross-reference to database entry (e.g., land use name for lu_change)
- **out1, out2, ...**: Outcome for each alternative (y = perform action, n = don't perform)

**In scen_dtl.upd:**
- **MAX_HITS**: Maximum number of times the action can be executed (1 = once, 999 = unlimited)
- **NAME**: Identifier that can match ALT_NAME from scen_lu.dtl (for tracking purposes)
- **DTABLE**: Name of the decision table from scen_lu.dtl to activate

## Warm-Up Period in SWAT+

### Overview
The warm-up period (also called the "spin-up" period) is a critical phase in SWAT+ modeling where the model runs for a specified number of years without saving output. This allows the model to stabilize initial conditions such as soil moisture, nutrient pools, and other state variables before meaningful output is collected.

### Purpose
The warm-up period serves several important functions:
- **Stabilizes initial conditions**: Allows soil water, nutrients, and other state variables to reach realistic levels
- **Reduces initialization bias**: Minimizes the impact of arbitrary initial values on simulation results
- **Improves model accuracy**: Ensures the model reaches a dynamic equilibrium before output is analyzed
- **Prevents misleading results**: Avoids including unrealistic transition states in calibration and analysis

### Where Specified
The warm-up period is specified in the **`print.prt`** file using the `nyskip` parameter.

**File location**: Defined in `src/input_file_module.f90`:
```fortran
character(len=25) :: prt = "print.prt"
```

### File Format: print.prt

The first data line in `print.prt` contains the warm-up period specification:

```
print.prt: 
nyskip      day_start  yrc_start  day_end   yrc_end   interval  
0           0          1975       0         2020      1         
```

**Parameters:**
- **`nyskip`**: Number of years to skip before writing output (the warm-up period)
  - `0` = No warm-up, output starts from the first year
  - `1` = Skip the first year, output starts from year 2
  - `3` = Skip the first 3 years, output starts from year 4
  - etc.

- **`day_start`**: Julian day to start printing output (0 = default to day 1)
- **`yrc_start`**: Year to start printing output (if 0, uses the first year from `time.sim`)
- **`day_end`**: Julian day to end printing output (0 = default to last day of year)
- **`yrc_end`**: Year to end printing output (if 0, uses the last year from `time.sim`)
- **`interval`**: Interval (in days) for printing output

### How It Works

The warm-up period is implemented in the code through several key checks:

**Data Structure** (`src/basin_module.f90`):
```fortran
integer :: nyskip = 0              ! number of years to skip output summarization
character (len=1) :: sw_init = "n" ! n=sw not initialized, y=sw initialized for output
```

**Usage in Time Control** (`src/time_control.f90`):
```fortran
!! sum years of printing for average annual writes
if (time%yrs > pco%nyskip) then
  time%yrs_prt = time%yrs_prt + float(time%day_end_yr - time%day_start + 1)
  time%days_prt = time%days_prt + float(time%day_end_yr - time%day_start + 1)
else
  ! In warm-up period, don't accumulate output
end if

!! set initial soil water for hru, basin and lsu - for checking water balance
if (pco%sw_init == "n") then
  if (time%yrs > pco%nyskip) then
    call basin_sw_init
    call aqu_pest_output_init
    pco%sw_init = "y"  ! won't reset again
  end if
end if
```

**Output Control** (`src/command.f90`):
```fortran
! print all outflow hydrographs
if (time%yrs > pco%nyskip) then
  ! Write output
end if
```

### Relationship with time.sim

The `time.sim` file specifies the overall simulation period:

```
time.sim: 
day_start  yrc_start   day_end   yrc_end      step  
0          1975        0         2020         0  
```

The interaction between `time.sim` and `nyskip` in `print.prt`:
- **Simulation runs** from `yrc_start` to `yrc_end` (1975-2020 in example = 46 years total)
- **Output is saved** starting after `nyskip` years
- **Example**: If `nyskip = 3`, simulation runs 46 years but only saves output for the last 43 years

### Best Practices

**Recommended warm-up periods:**
- **Minimum**: 1-3 years for most applications
- **Standard**: 3-5 years for calibration and validation
- **Extended**: 5-10+ years for:
  - Long-term nutrient cycling studies
  - Deep aquifer simulations
  - Watersheds with large reservoirs
  - Studies involving soil carbon dynamics

**Important considerations:**
1. **Climate data**: Ensure you have sufficient climate data to cover both the warm-up period and the analysis period
2. **Initial conditions**: Even with a warm-up period, reasonable initial conditions (soil moisture, nutrient levels) improve convergence
3. **Calibration**: Exclude the warm-up period from calibration statistics
4. **Output files**: The `lu_change_out.txt` and other output files are still created during warm-up, but summary statistics exclude this period

### Reading Process

The warm-up period is read by `basin_print_codes_read` subroutine in `src/basin_print_codes_read.f90`:

```fortran
inquire (file=in_sim%prt, exist=i_exist)
if (i_exist .or. in_sim%prt /= "null") then
  open (107,file=in_sim%prt)
  read (107,*,iostat=eof) titldum
  read (107,*,iostat=eof) header
  read (107,*,iostat=eof) pco%nyskip, pco%day_start, pco%yrc_start, &
                          pco%day_end, pco%yrc_end, pco%int_day
  ! ... continue reading output options
end if
```

### Example Scenarios

**Example 1: No warm-up**
```
nyskip = 0
```
- All years included in output
- Use when: initial conditions are well-known or using a warm-start from previous simulation

**Example 2: Standard warm-up**
```
nyskip = 3
```
- First 3 years excluded from output
- Use when: typical calibration/validation study

**Example 3: Extended warm-up with partial year**
```
nyskip = 5
day_start = 274  (October 1)
```
- First 5 years excluded from output
- After year 5, only October 1 onwards is included
- Use when: analyzing water year (Oct 1 - Sep 30) and need extended stabilization

## Important Notes About Land Use Changes During Warm-Up

### Land Use Changes Execute During Warm-Up Period

**Critical behavior**: Land use changes specified in `scen_lu.dtl` **DO execute during the warm-up period** (`nyskip` years). This is because:

1. **Evaluation happens before output check**: In `src/time_control.f90`, the conditional land use scenario evaluation (lines 222-230) occurs BEFORE the simulation checks whether to write output based on `nyskip`

2. **lu_change_out.txt is written during warm-up**: The `lu_change_out.txt` file records ALL land use changes, including those that occur during warm-up years, because the write statements in `src/actions.f90` are NOT guarded by `nyskip` checks

3. **HRU output files (hru_ls, hru_nb, etc.) exclude warm-up period**: These output files only contain data AFTER the warm-up period because the calls to `hru_output()` in `src/command.f90` (line 446) are inside the `if (time%yrs > pco%nyskip)` block (line 423)

### Practical Implications

**Example scenario from user:**
```
time.sim: simulation runs 2005-2018 (14 years)
print.prt: nyskip = 3 (3-year warm-up)
scen_lu.dtl: land use change on jday=1, year_cal=2005
```

**What happens:**
- **2005 (Year 1, Day 1)**: Land use change executes, all HRUs change to bsvg_lum
- **2005-2007**: Warm-up period - model runs with changed land use, but hru_ls and hru_nb outputs are NOT written
- **2008-2018**: Normal output period - hru_ls and hru_nb outputs ARE written with the changed land use already in effect
- **lu_change_out.txt**: Contains the 2005 land use change record, even though it occurred during warm-up

**Result**: The hru_ls and hru_nb output files will reflect the changed land use (bsvg_lum) for ALL records because:
1. The change happened on day 1 of year 1 (2005)
2. The warm-up allowed the system to stabilize with the new land use (2005-2007)
3. Output only started in year 4 (2008), by which time the land use was already changed

### Recommendations

1. **If land use change should occur AFTER warm-up**: Set the year condition in `scen_lu.dtl` to trigger after the warm-up period ends
   - For `nyskip=3` starting in 2005, set `year_cal = 2008` or later

2. **If land use change during warm-up is intentional**: This is useful for:
   - Testing scenarios where you want the model to stabilize with the new land use before collecting output
   - Scenarios where the land use change is a baseline condition, not an event to analyze

3. **Always check lu_change_out.txt**: This file shows EXACTLY when land use changes occurred, including during warm-up

## General Notes

- If `scen_lu.dtl` does not exist or is set to "null", no scenario decision tables are loaded
- If `scen_dtl.upd` does not exist, no scenario updates are active even if `scen_lu.dtl` exists
- The `lu_change_out.txt` file is always created even if no land use changes occur
- File unit 3612 is reserved for land use change output throughout the simulation
- The `file_pointer` field is essential for cross-referencing actions with the appropriate database entries
