# CS, PEST, and PATH Initialization in SWAT+ HRUs

This document explains how constituents (CS), pesticides (PEST), and pathogens (PATH) are read from input files and initialized into Hydrologic Response Units (HRUs) in the SWAT+ model.

## Overview

The initialization process follows a two-phase approach:
1. **Reading Phase**: Input files are read to define constituents and their initial concentrations
2. **Initialization Phase**: HRUs are populated with constituent data based on the input files

## Main Program Flow

The process is orchestrated by `main.f90.in`:

```fortran
call proc_read    ! Phase 1: Read input files
call proc_hru     ! Phase 2: Initialize HRUs
```

## Phase 1: Reading Input Files (`proc_read.f90`)

### 1.1 Constituent Database Reading

**File**: `src/constit_db_read.f90`  
**Input File**: Specified by `in_sim%cs_db` (typically `constituents.cs`)

This subroutine reads the master database that defines which constituents will be simulated:

```fortran
call constit_db_read
```

**Input file format**:
```
Title line
num_pests
pest1 pest2 pest3 ...
num_paths  
path1 path2 path3 ...
num_metals
metal1 metal2 metal3 ...
num_salts
salt1 salt2 salt3 ...
num_cs
cs1 cs2 cs3 ...
```

**Data stored in**: `cs_db` structure containing:
- `cs_db%num_pests`: Number of pesticides to simulate
- `cs_db%pests()`: Array of pesticide names
- `cs_db%num_paths`: Number of pathogens to simulate  
- `cs_db%paths()`: Array of pathogen names
- `cs_db%num_cs`: Number of other constituents to simulate
- `cs_db%cs()`: Array of constituent names

### 1.2 Soil-Plant Initialization Reading

**File**: `src/soil_plant_init.f90`  
**Input File**: Specified by `in_init%soil_plant_ini`

This creates the linkage between HRUs and their constituent initialization data:

```fortran
call soil_plant_init
```

**Input file format**:
```
Title line
Header line
name1 sw_frac nutc pestc pathc saltc hmetc csc
name2 sw_frac nutc pestc pathc saltc hmetc csc
...
```

**Data stored in**: `sol_plt_ini()` array where each element contains:
- `name`: Identifier for the soil-plant initialization set
- `pestc`: **Character name** reference to pesticide initialization data
- `pathc`: **Character name** reference to pathogen initialization data  
- `csc`: **Character name** reference to constituent initialization data

**Key insight**: At this stage, constituent references are stored as **character names**, not indices. The crosswalk to actual constituent data happens later during HRU reading.

### 1.3 Pesticide Initial Concentrations Reading

**File**: `src/pest_hru_aqu_read.f90`  
**Input File**: Specified by `in_init%pest_soil`

Reads initial pesticide concentrations in soil and plant:

```fortran
call pest_hru_aqu_read
```

**Input file format**:
```
Title line
Header line
name1
pest1_name pest1_soil_conc pest1_plant_conc
pest2_name pest2_soil_conc pest2_plant_conc
...
name2
pest1_name pest1_soil_conc pest1_plant_conc
...
```

**Data stored in**: `pest_soil_ini()` array containing:
- `name`: Identifier for the pesticide initialization set
- `soil()`: Array of soil concentrations for each pesticide
- `plt()`: Array of plant concentrations for each pesticide

### 1.4 Pathogen Initial Concentrations Reading

**File**: `src/path_hru_aqu_read.f90`  
**Input File**: Specified by `in_init%path_soil`

Reads initial pathogen concentrations in soil and plant:

```fortran
call path_hru_aqu_read
```

**Input file format**:
```
Title line
Header line
name1 
path_data_line (contains soil and plant concentrations)
name2
path_data_line
...
```

**Data stored in**: `path_soil_ini()` array containing:
- `name`: Identifier for the pathogen initialization set
- `soil()`: Array of soil concentrations for each pathogen
- `plt()`: Array of plant concentrations for each pathogen

### 1.5 Constituent Initial Concentrations Reading

**File**: `src/cs_hru_read.f90`  
**Input File**: `cs_hru.ini`

Reads initial concentrations for other constituents:

```fortran
call cs_hru_read
```

**Input file format**:
```
Title line
Header line
Header line  
Header line
Header line
name1
soil_concentration_data
plant_concentration_data
name2
soil_concentration_data
plant_concentration_data
...
```

**Data stored in**: `cs_soil_ini()` array containing:
- `name`: Identifier for the constituent initialization set
- `soil()`: Array of soil concentrations (both dissolved and sorbed)
- `plt()`: Array of plant concentrations

## Crosswalk Mechanism: Linking HRUs to Constituent Data

**File**: `src/hru_read.f90` (lines 78-130)  
**Purpose**: Resolves character name references to integer indices

This critical step transforms the character-based references from `soil_plant_init` into numeric indices that can be used efficiently during simulation. The process occurs in three phases:

### Crosswalk Phase 1: HRU to Soil-Plant Linkage

Each HRU in the `hru.con` file specifies which `soil_plant_init` entry it uses:

```fortran
! For each HRU, find its soil_plant_init entry by name matching
do isp_ini = 1, db_mx%sol_plt_ini
  if (hru_db(i)%dbsc%soil_plant_init == sol_plt_ini(isp_ini)%name) then
    hru_db(i)%dbs%soil_plant_init = isp_ini  ! Store the INDEX
    exit
  end if
end do
```

**Result**: `hru(ihru)%dbs%soil_plant_init` contains the **integer index** pointing to the correct `sol_plt_ini()` entry.

### Crosswalk Phase 2: Soil-Plant to Constituent Data Linkage

For each constituent type, the character names are resolved to integer indices:

#### Pesticide Crosswalk
```fortran
! Match pesticide initialization set name
do ics = 1, db_mx%pest_ini
  if (sol_plt_ini(isp_ini)%pestc == pest_soil_ini(ics)%name) then
    sol_plt_ini(isp_ini)%pest = ics  ! Store the INDEX
    exit
  end if
end do
```

#### Pathogen Crosswalk
```fortran
! Match pathogen initialization set name
do ics = 1, db_mx%path_ini
  if (sol_plt_ini(isp_ini)%pathc == path_soil_ini(ics)%name) then
    sol_plt_ini(isp_ini)%path = ics  ! Store the INDEX
    exit
  end if
end do
```

#### Constituent Crosswalk
```fortran
! Match constituent initialization set name
do ics = 1, db_mx%cs_ini
  if (sol_plt_ini(isp_ini)%csc == cs_soil_ini(ics)%name) then
    sol_plt_ini(isp_ini)%cs = ics  ! Store the INDEX
    exit
  end if
end do
```

### Crosswalk Phase 3: Runtime Resolution During Initialization

During constituent initialization, the three-level indirection is resolved:

```fortran
! Example from pesticide_init.f90 (lines 57-58)
isp_ini = hru(ihru)%dbs%soil_plant_init    ! Level 1: HRU → soil_plant_init
ipest_db = sol_plt_ini(isp_ini)%pest       ! Level 2: soil_plant_init → pest data
! Level 3: pest data → actual concentrations
solpst = pest_soil_ini(ipest_db)%soil(ipest)
```

### Complete Crosswalk Example

Consider this setup:

**hru.con file**:
```
hru1  ...  init_set_agricultural  ...
hru2  ...  init_set_forest       ...
```

**soil_plant_ini file**:
```
init_set_agricultural  0.5  nuts1  pest_ag    path1  salts1  metals1  cs_ag
init_set_forest        0.3  nuts1  pest_forest path1  salts1  metals1  cs_forest
```

**pest_hru.ini file**:
```
pest_ag
atrazine     15.0  2.5
metolachlor  8.0   1.2

pest_forest  
atrazine     1.0   0.1
metolachlor  0.5   0.05
```

**Crosswalk Resolution**:
1. **HRU1** → `init_set_agricultural` (index 1 in sol_plt_ini)
2. `init_set_agricultural` → `pest_ag` (index 1 in pest_soil_ini)  
3. `pest_ag` → atrazine: 15.0 mg/kg soil, 2.5 mg/kg plant

1. **HRU2** → `init_set_forest` (index 2 in sol_plt_ini)
2. `init_set_forest` → `pest_forest` (index 2 in pest_soil_ini)
3. `pest_forest` → atrazine: 1.0 mg/kg soil, 0.1 mg/kg plant

### Benefits of the Crosswalk System

1. **Flexibility**: Multiple HRUs can share the same soil_plant_init entry
2. **Modularity**: Different constituent types can reference different initialization sets
3. **Efficiency**: Character name matching occurs once during setup; runtime uses fast integer indices
4. **Maintainability**: Initialization data is centralized in separate files
5. **Spatial Heterogeneity**: Different areas can have vastly different initial conditions

### Error Handling

The crosswalk includes validation to ensure all references are resolved:
```fortran
if (hru_db(i)%dbs%soil_plant_init == 0) then
  write (9001,*) hru_db(i)%dbsc%soil_plant_init, "not found (plant.ini)"
end if
```

Unresolved references result in error messages identifying the missing initialization set names.

## Phase 2: HRU Initialization (`proc_hru.f90`)

**Prerequisites**: The crosswalk mechanism (described above) must be completed before this phase, so that all character name references have been resolved to integer indices.

The HRU initialization is conditional based on the number of constituents defined:

```fortran
if (cs_db%num_pests > 0) call pesticide_init
if (cs_db%num_paths > 0) call pathogen_init  
if (cs_db%num_cs > 0) call cs_hru_init
```

### 2.1 Pesticide Initialization

**File**: `src/pesticide_init.f90`

For each HRU:
1. Allocates pesticide arrays for soil layers and plants
2. **Uses the crosswalk indices** to link HRU to its pesticide initialization data
3. Distributes plant pesticides across multiple plant communities
4. Calculates soil pesticide mass from concentration and soil properties

**Crosswalk Resolution in Action**:
```fortran
isp_ini = hru(ihru)%dbs%soil_plant_init    ! Get soil_plant_init index (from crosswalk)
ipest_db = sol_plt_ini(isp_ini)%pest       ! Get pesticide data index (from crosswalk)
```

**Key calculations**:
```fortran
! Plant pesticide distribution by LAI fraction
pl_frac = pcom(ihru)%plg(ipl)%lai / pcom(ihru)%lai_sum
cs_pl(ihru)%pl_on(ipl)%pest(ipest) = pl_frac * pest_soil_ini(ipest_db)%plt(ipest)

! Soil pesticide mass calculation  
wt1 = soil(ihru)%phys(ly)%bd * soil(ihru)%phys(ly)%thick / 100.0  ! mg/kg => kg/ha
cs_soil(ihru)%ly(ly)%pest(ipest) = solpst * wt1
```

### 2.2 Pathogen Initialization

**File**: `src/pathogen_init.f90`

For each HRU:
1. Allocates pathogen arrays for soil layers and plants
2. **Uses crosswalk indices** to link HRU to its pathogen initialization data
3. Initializes only the top soil layer with pathogen concentrations
4. Sets plant pathogen mass in balance arrays

**Crosswalk Resolution**:
```fortran
isp_ini = hru(ihru)%dbs%soil_plant_init     ! Get soil_plant_init index (from crosswalk)
ipath_db = sol_plt_ini(isp_ini)%path        ! Get pathogen data index (from crosswalk)
```

**Key assignments**:
```fortran
! Only top soil layer gets pathogens
if (ly == 1) then
  cs_soil(ihru)%ly(1)%path(ipath) = path_soil_ini(ipath_db)%soil(ipath)
else
  cs_soil(ihru)%ly(1)%path(ipath) = 0.
end if

! Plant pathogen balance
hpath_bal(ihru)%path(ipath)%plant = path_soil_ini(ipath_db)%plt(ipath)
```

### 2.3 Constituent Initialization

**File**: `src/cs_hru_init.f90`

For each HRU:
1. Allocates constituent arrays for soil layers
2. **Uses crosswalk indices** to link HRU to its constituent initialization data
3. Calculates both dissolved and sorbed constituent masses
4. Converts concentrations to mass units (kg/ha)

**Crosswalk Resolution**:
```fortran
isp_ini = hru(ihru)%dbs%soil_plant_init     ! Get soil_plant_init index (from crosswalk)
ics_db = sol_plt_ini(isp_ini)%cs            ! Get constituent data index (from crosswalk)
```

**Key calculations**:
```fortran
! Dissolved constituent mass
water_volume = (soil(ihru)%phys(ly)%st/1000.) * hru_area_m2
cs_soil(ihru)%ly(ly)%cs(ics) = (cs_soil_ini(ics_db)%soil(ics)/1000.) * water_volume / hru(ihru)%area_ha

! Sorbed constituent mass  
soil_volume = hru_area_m2 * (soil(ihru)%phys(ly)%thick/1000.)
soil_mass = soil_volume * (soil(ihru)%phys(ly)%bd*1000.)
mass_sorbed = (cs_soil_ini(ics_db)%soil(ics+cs_db%num_cs)*soil_mass) / 1.e6
cs_soil(ihru)%ly(ly)%cs_sorb(ics) = mass_sorbed / hru(ihru)%area_ha
```

## Data Structure Hierarchy and Crosswalk Flow

```
Input Phase (Character Names):
hru.con: hru1 → "init_set_agricultural"
soil_plant_ini: "init_set_agricultural" → pestc="pest_ag", pathc="path1", csc="cs_ag"

Crosswalk Phase (Name → Index Resolution):
hru.con: hru1 → sol_plt_ini[1] (index for "init_set_agricultural")
sol_plt_ini[1]: pestc="pest_ag" → pest_soil_ini[1] (index for "pest_ag")
sol_plt_ini[1]: pathc="path1" → path_soil_ini[1] (index for "path1")  
sol_plt_ini[1]: csc="cs_ag" → cs_soil_ini[1] (index for "cs_ag")

Runtime Phase (Index-Based Access):
HRU Level:
├── hru(ihru)%dbs%soil_plant_init → INTEGER index to sol_plt_ini() element
├── sol_plt_ini()%pest → INTEGER index to pest_soil_ini() element  
├── sol_plt_ini()%path → INTEGER index to path_soil_ini() element
└── sol_plt_ini()%cs → INTEGER index to cs_soil_ini() element

Constituent Storage:
├── cs_soil(ihru)%ly(layer)%pest() → pesticide mass by layer
├── cs_soil(ihru)%ly(layer)%path() → pathogen concentrations by layer  
├── cs_soil(ihru)%ly(layer)%cs() → constituent mass by layer
├── cs_pl(ihru)%pl_on(plant)%pest() → pesticide mass on plants
└── cs_irr(ihru)%pest() → pesticide concentrations in irrigation water
```

## File Dependencies

1. **HRU Definition**: `hru.con` defines which soil_plant_init each HRU uses
2. **Constituent Database**: `constituents.cs` defines which constituents to simulate  
3. **Soil-Plant Links**: `soil_plant_ini` links HRUs to initialization data
4. **Initial Concentrations**: Separate files for each constituent type
   - Pesticides: Defined by `in_init%pest_soil`
   - Pathogens: Defined by `in_init%path_soil`  
   - Other constituents: `cs_hru.ini`

## Summary

The constituent initialization process follows a sophisticated three-phase approach:

1. **Input Reading Phase**: Constituent databases and initialization data are read, with references stored as character names for human readability and maintainability.

2. **Crosswalk Phase**: Character name references are resolved to integer indices through systematic name matching, creating an efficient lookup system for runtime operations.

3. **HRU Initialization Phase**: Integer indices are used to rapidly access initialization data and populate HRU constituent arrays with converted mass units.

**Key Benefits of the Crosswalk System**:
- **Flexibility**: Multiple HRUs can share initialization sets; different constituents can use different initialization sources
- **Performance**: Character matching occurs once during setup; runtime uses fast integer indexing  
- **Maintainability**: Human-readable names in input files; robust error checking for missing references
- **Spatial Heterogeneity**: Different areas can have completely different initial constituent distributions

The constituent masses are properly converted from concentrations to mass units (kg/ha) using soil physical properties like bulk density, thickness, and water content, ensuring accurate representation in the SWAT+ simulation framework.