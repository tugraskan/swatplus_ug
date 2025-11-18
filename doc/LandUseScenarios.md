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

A typical land use scenario might involve converting agricultural land to forest when certain conditions are met:

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
lu_change                hru        0       null       null    0.0      0.0       forest      y
```

**scen_dtl.upd:**
```
Scenario updates
1

max_hits    typ         dtbl
1           scen        ag_to_forest
```

This would change HRUs larger than 10 hectares to forest land use after year 2030, but only once per HRU (max_hits = 1).

## Notes

- If `scen_lu.dtl` does not exist or is set to "null", no scenario decision tables are loaded
- If `scen_dtl.upd` does not exist, no scenario updates are active even if `scen_lu.dtl` exists
- The `lu_change_out.txt` file is always created even if no land use changes occur
- File unit 3612 is reserved for land use change output throughout the simulation
- The `file_pointer` field is essential for cross-referencing actions with the appropriate database entries
