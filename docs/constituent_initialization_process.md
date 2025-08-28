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

The reading phase is orchestrated by the `proc_read` subroutine, which calls constituent reading subroutines in a specific sequence. Here's the exact calling sequence for constituent-related subroutines:

```fortran
subroutine proc_read
  call constit_db_read          ! Line 9:  Read master constituent database
  call soil_plant_init          ! Line 11: Create HRU linkage to initialization data
  call pest_hru_aqu_read        ! Line 13: Read pesticide initial concentrations
  call path_hru_aqu_read        ! Line 14: Read pathogen initial concentrations
  call cs_hru_read              ! Line 29: Read constituent initial concentrations
end subroutine proc_read
```

### 1.1 Constituent Database Reading - `constit_db_read`

**File**: `src/constit_db_read.f90`  
**Input File**: Specified by `in_sim%cs_db` (typically `constituents.cs`)  
**Called from**: `proc_read.f90` (line 9)

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

### 1.2 Soil-Plant Initialization Reading - `soil_plant_init`

**File**: `src/soil_plant_init.f90`  
**Input File**: Specified by `in_init%soil_plant_ini`  
**Called from**: `proc_read.f90` (line 11)

This critical subroutine creates the linkage structure between HRUs and their constituent initialization data:

```fortran
call soil_plant_init
```

**Key Process in `soil_plant_init`**:
1. **Reads the soil-plant initialization file** (lines 21-50)
2. **Stores character name references** for each constituent type (lines 47-51)  
3. **Allocates the `sol_plt_ini()` array** to hold linkage data (line 38)

```fortran
! Lines 47-48 in soil_plant_init.f90
read (107,*,iostat=eof) sol_plt_ini(ii)%name, sol_plt_ini(ii)%sw_frac, sol_plt_ini(ii)%nutc,  &
  sol_plt_ini(ii)%pestc, sol_plt_ini(ii)%pathc, sol_plt_ini(ii)%saltc, sol_plt_ini(ii)%hmetc
```

**Critical**: At this stage, constituent references (`pestc`, `pathc`, `csc`) are stored as **character strings**, not indices. The crosswalk to numerical indices happens later in `hru_read.f90`.

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

### 1.3 Pesticide Initial Concentrations Reading - `pest_hru_aqu_read`

**File**: `src/pest_hru_aqu_read.f90`  
**Input File**: Specified by `in_init%pest_soil`  
**Called from**: `proc_read.f90` (line 13)

Reads initial pesticide concentrations in soil and plant into the `pest_soil_ini()` array:

```fortran
call pest_hru_aqu_read
```

**Key Process in `pest_hru_aqu_read`**:
1. **Determines number of pesticide initialization sets** 
2. **Allocates the `pest_soil_ini()` array** 
3. **Reads pesticide concentrations by name** for each initialization set
4. **Stores data in indexed array** for later crosswalk resolution

**Data stored in**: `pest_soil_ini()` array containing:
- `name`: Identifier for the pesticide initialization set (character string)
- `soil()`: Array of soil concentrations for each pesticide (mg/kg)
- `plt()`: Array of plant concentrations for each pesticide (mg/kg)

### 1.4 Pathogen Initial Concentrations Reading - `path_hru_aqu_read`

**File**: `src/path_hru_aqu_read.f90`  
**Input File**: Specified by `in_init%path_soil`  
**Called from**: `proc_read.f90` (line 14)

Reads initial pathogen concentrations in soil and plant into the `path_soil_ini()` array:

```fortran
call path_hru_aqu_read
```

**Key Process in `path_hru_aqu_read`**:
1. **Determines number of pathogen initialization sets**
2. **Allocates the `path_soil_ini()` array**
3. **Reads pathogen concentrations by name** for each initialization set  
4. **Stores data in indexed array** for later crosswalk resolution

**Data stored in**: `path_soil_ini()` array containing:
- `name`: Identifier for the pathogen initialization set (character string)
- `soil()`: Array of soil concentrations for each pathogen
- `plt()`: Array of plant concentrations for each pathogen

### 1.5 Constituent Initial Concentrations Reading - `cs_hru_read`

**File**: `src/cs_hru_read.f90`  
**Input File**: `cs_hru.ini`  
**Called from**: `proc_read.f90` (line 29)

Reads initial concentrations for other constituents into the `cs_soil_ini()` array:

```fortran
call cs_hru_read
```

**Key Process in `cs_hru_read`**:
1. **Determines number of constituent initialization sets**
2. **Allocates the `cs_soil_ini()` array** 
3. **Reads constituent concentrations by name** (both dissolved and sorbed)
4. **Stores data in indexed array** for later crosswalk resolution

**Data stored in**: `cs_soil_ini()` array containing:
- `name`: Identifier for the constituent initialization set (character string)
- `soil()`: Array of soil concentrations (both dissolved and sorbed phases)
- `plt()`: Array of plant concentrations

## Crosswalk Mechanism: Character Name Resolution in `hru_read.f90`

**File**: `src/hru_read.f90` (lines 78-130)  
**Called from**: `proc_hru.f90` (line 19)  
**Purpose**: Transforms character name references into efficient integer indices

The crosswalk mechanism is **THE CRITICAL LINK** between the character-based input files and the integer-indexed runtime arrays. This complex process occurs within the `hru_read` subroutine and involves **systematic name matching** to resolve all character references to numerical indices.

### Crosswalk Process Overview

**Input State**: After Phase 1, we have:
- HRUs with character name references to soil_plant_init entries
- soil_plant_init entries with character name references to constituent data  
- Constituent data arrays indexed by position but referenced by character names

**Output State**: After crosswalk, we have:
- HRUs with integer indices pointing to soil_plant_init entries
- soil_plant_init entries with integer indices pointing to constituent data arrays
- Fast integer-based lookups for runtime constituent initialization

### Detailed Crosswalk Steps in `hru_read.f90`

### Step 1: HRU → Soil-Plant Linkage Resolution (lines 79-83)

**Subroutine**: `hru_read` (lines 79-83)  
**Purpose**: Each HRU finds its soil_plant_init entry by character name matching

```fortran
! From hru_read.f90 lines 79-83
do isp_ini = 1, db_mx%sol_plt_ini
  if (hru_db(i)%dbsc%soil_plant_init == sol_plt_ini(isp_ini)%name) then
    hru_db(i)%dbs%soil_plant_init = isp_ini  ! CHARACTER → INTEGER conversion
    exit
  end if
end do
```

**What happens**: 
- `hru_db(i)%dbsc%soil_plant_init` contains the CHARACTER name from hru.con file
- Loop searches through `sol_plt_ini()` array for matching character name
- `hru_db(i)%dbs%soil_plant_init` gets set to the INTEGER index (isp_ini)
- This creates the first level of indirection: **HRU → soil_plant_init index**

### Step 2: Soil-Plant → Constituent Data Linkage Resolution (lines 85-126)

For each soil_plant_init entry found in Step 1, the constituent character names are resolved to integer indices:

#### Step 2a: Pesticide Crosswalk (lines 92-98)

**Subroutine**: `hru_read` (lines 92-98)  
**Purpose**: Resolve pesticide character names to indices in `pest_soil_ini()` array

```fortran
! From hru_read.f90 lines 92-98  
do ics = 1, db_mx%pest_ini
  if (sol_plt_ini(isp_ini)%pestc == pest_soil_ini(ics)%name) then
    sol_plt_ini(isp_ini)%pest = ics  ! CHARACTER → INTEGER conversion
    exit
  end if
end do
```

**What happens**:
- `sol_plt_ini(isp_ini)%pestc` contains the CHARACTER name from soil_plant_ini file
- Loop searches through `pest_soil_ini()` array for matching character name
- `sol_plt_ini(isp_ini)%pest` gets set to the INTEGER index (ics)
- Creates second level: **soil_plant_init → pesticide data index**

#### Step 2b: Pathogen Crosswalk (lines 99-105)

**Subroutine**: `hru_read` (lines 99-105)  
**Purpose**: Resolve pathogen character names to indices in `path_soil_ini()` array

```fortran
! From hru_read.f90 lines 99-105
do ics = 1, db_mx%path_ini
  if (sol_plt_ini(isp_ini)%pathc == path_soil_ini(ics)%name) then
    sol_plt_ini(isp_ini)%path = ics  ! CHARACTER → INTEGER conversion
    exit
  end if
end do
```

**What happens**:
- `sol_plt_ini(isp_ini)%pathc` contains the CHARACTER name from soil_plant_ini file  
- Loop searches through `path_soil_ini()` array for matching character name
- `sol_plt_ini(isp_ini)%path` gets set to the INTEGER index (ics)
- Creates second level: **soil_plant_init → pathogen data index**

#### Step 2c: Constituent Crosswalk (lines 120-126)

**Subroutine**: `hru_read` (lines 120-126)  
**Purpose**: Resolve constituent character names to indices in `cs_soil_ini()` array

```fortran
! From hru_read.f90 lines 120-126
do ics = 1, db_mx%cs_ini
  if (sol_plt_ini(isp_ini)%csc == cs_soil_ini(ics)%name) then
    sol_plt_ini(isp_ini)%cs = ics  ! CHARACTER → INTEGER conversion
    exit
  end if
end do
```

**What happens**:
- `sol_plt_ini(isp_ini)%csc` contains the CHARACTER name from soil_plant_ini file
- Loop searches through `cs_soil_ini()` array for matching character name  
- `sol_plt_ini(isp_ini)%cs` gets set to the INTEGER index (ics)
- Creates second level: **soil_plant_init → constituent data index**

### Complete Three-Level Crosswalk Resolution

After `hru_read.f90` completes, the complete indirection system is established:

```fortran
! Level 1: HRU → soil_plant_init entry (integer index)
hru_index = hru(ihru)%dbs%soil_plant_init

! Level 2: soil_plant_init → constituent data (integer indices)  
pest_index = sol_plt_ini(hru_index)%pest
path_index = sol_plt_ini(hru_index)%path
cs_index = sol_plt_ini(hru_index)%cs

! Level 3: constituent data → actual values (direct array access)
pest_soil_conc = pest_soil_ini(pest_index)%soil(ipest)
path_soil_conc = path_soil_ini(path_index)%soil(ipath)  
cs_soil_conc = cs_soil_ini(cs_index)%soil(ics)
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

## Phase 2: HRU Initialization Using Crosswalked Indices (`proc_hru.f90`)

**Prerequisites**: The crosswalk mechanism in `hru_read.f90` must be completed first, so that all character name references have been resolved to integer indices.

The HRU initialization phase is orchestrated by `proc_hru` which calls constituent initialization subroutines conditionally:

```fortran
subroutine proc_hru
  call hru_read                              ! Line 19: Perform crosswalk resolution first
  ! ... other initialization ...
  if (cs_db%num_pests > 0) call pesticide_init ! Line 39: Initialize pesticides using indices
  if (cs_db%num_paths > 0) call pathogen_init  ! Line 40: Initialize pathogens using indices
  if (cs_db%num_cs > 0) call cs_hru_init       ! Line 42: Initialize constituents using indices
end subroutine proc_hru
```

### 2.1 Pesticide Initialization - `pesticide_init`

**File**: `src/pesticide_init.f90`  
**Called from**: `proc_hru.f90` (line 39)  
**Purpose**: Uses crosswalked indices to initialize pesticides in HRU soil and plant structures

**Critical Index Resolution in `pesticide_init` (lines 57-58)**:
```fortran
! From pesticide_init.f90 lines 57-58
isp_ini = hru(ihru)%dbs%soil_plant_init    ! Get soil_plant_init index (from crosswalk)
ipest_db = sol_plt_ini(isp_ini)%pest       ! Get pesticide data index (from crosswalk)
```

**Key Process in `pesticide_init`**:
1. **Allocates pesticide arrays** for soil layers and plants (lines 30-55)
2. **Uses crosswalked indices** to access correct initialization data (lines 57-58)
3. **Distributes plant pesticides** across multiple plant communities (lines 61-69)
4. **Calculates soil pesticide mass** from concentration and soil properties (lines 71-85)

**Index-Based Data Access**:
```fortran
! Lines 60, 68 in pesticide_init.f90
hpestb_d(ihru)%pest(ipest)%plant = pest_soil_ini(ipest_db)%plt(ipest)
cs_pl(ihru)%pl_on(ipl)%pest(ipest) = pl_frac * pest_soil_ini(ipest_db)%plt(ipest)
```

**Where data goes**: Initialized pesticide data is stored in:
- `cs_soil(ihru)%ly(ly)%pest(ipest)` - soil pesticide mass by layer (kg/ha)
- `cs_pl(ihru)%pl_on(ipl)%pest(ipest)` - plant pesticide mass by plant community (kg/ha)
- `cs_irr(ihru)%pest(ipest)` - irrigation water pesticide concentrations

### 2.2 Pathogen Initialization - `pathogen_init`

**File**: `src/pathogen_init.f90`  
**Called from**: `proc_hru.f90` (line 40)  
**Purpose**: Uses crosswalked indices to initialize pathogens in HRU soil and plant structures

**Critical Index Resolution in `pathogen_init`**:
```fortran
! From pathogen_init.f90
isp_ini = hru(ihru)%dbs%soil_plant_init     ! Get soil_plant_init index (from crosswalk)
ipath_db = sol_plt_ini(isp_ini)%path        ! Get pathogen data index (from crosswalk)
```

**Key Process in `pathogen_init`**:
1. **Allocates pathogen arrays** for soil layers and plants
2. **Uses crosswalked indices** to access correct initialization data
3. **Initializes only the top soil layer** with pathogen concentrations 
4. **Sets plant pathogen mass** in balance arrays

**Index-Based Data Access**:
```fortran
! From pathogen_init.f90
if (ly == 1) then
  cs_soil(ihru)%ly(1)%path(ipath) = path_soil_ini(ipath_db)%soil(ipath)
end if
hpath_bal(ihru)%path(ipath)%plant = path_soil_ini(ipath_db)%plt(ipath)
```

**Where data goes**: Initialized pathogen data is stored in:
- `cs_soil(ihru)%ly(1)%path(ipath)` - pathogen concentrations in top soil layer only
- `hpath_bal(ihru)%path(ipath)%plant` - plant pathogen balance

### 2.3 Constituent Initialization - `cs_hru_init`

**File**: `src/cs_hru_init.f90`  
**Called from**: `proc_hru.f90` (line 42)  
**Purpose**: Uses crosswalked indices to initialize constituents in HRU soil structures with mass conversion

**Critical Index Resolution in `cs_hru_init` (lines 49-50)**:
```fortran
! From cs_hru_init.f90 lines 49-50
isp_ini = hru(ihru)%dbs%soil_plant_init     ! Get soil_plant_init index (from crosswalk)
ics_db = sol_plt_ini(isp_ini)%cs            ! Get constituent data index (from crosswalk)
```

**Key Process in `cs_hru_init`**:
1. **Allocates constituent arrays** for soil layers (lines 25-40)
2. **Uses crosswalked indices** to access correct initialization data (lines 49-50)
3. **Calculates dissolved constituent masses** from concentrations (lines 57-60)
4. **Calculates sorbed constituent masses** from concentrations (lines 62-67)
5. **Converts all concentrations to mass units** (kg/ha) using soil properties

**Index-Based Data Access with Mass Conversion**:
```fortran
! From cs_hru_init.f90 lines 57-67
cs_soil(ihru)%ly(ly)%csc(ics) = cs_soil_ini(ics_db)%soil(ics) ! Concentration
water_volume = (soil(ihru)%phys(ly)%st/1000.) * hru_area_m2
cs_soil(ihru)%ly(ly)%cs(ics) = (cs_soil_ini(ics_db)%soil(ics)/1000.) * water_volume / hru(ihru)%area_ha

cs_soil(ihru)%ly(ly)%csc_sorb(ics) = cs_soil_ini(ics_db)%soil(ics+cs_db%num_cs)
soil_mass = soil_volume * (soil(ihru)%phys(ly)%bd*1000.)
mass_sorbed = (cs_soil_ini(ics_db)%soil(ics+cs_db%num_cs)*soil_mass) / 1.e6
cs_soil(ihru)%ly(ly)%cs_sorb(ics) = mass_sorbed / hru(ihru)%area_ha
```

**Where data goes**: Initialized constituent data is stored in:
- `cs_soil(ihru)%ly(ly)%cs(ics)` - dissolved constituent mass by layer (kg/ha)
- `cs_soil(ihru)%ly(ly)%cs_sorb(ics)` - sorbed constituent mass by layer (kg/ha)  
- `cs_soil(ihru)%ly(ly)%csc(ics)` - dissolved constituent concentration (g/m³)
- `cs_soil(ihru)%ly(ly)%csc_sorb(ics)` - sorbed constituent concentration (mg/kg)

## Complete Data Loading and Crosswalk Flow: From Input Files to HRU Arrays

This section provides a comprehensive view of **where constituents are read and loaded** and **how they are crosswalked into the soil and HRU structures**.

### Step-by-Step Loading Process with Specific Subroutines

#### Phase 1: Input File Loading → Memory Arrays (Character-Based)

```
Input Files                    Subroutine              Output Memory Structure
═════════════════════════════════════════════════════════════════════════════════
constituents.cs         →      constit_db_read     →   cs_db%pests(), cs_db%paths(), cs_db%cs()
soil_plant_ini          →      soil_plant_init     →   sol_plt_ini()%pestc, %pathc, %csc (CHARACTERS)
pest_hru.ini            →      pest_hru_aqu_read   →   pest_soil_ini()%name, %soil(), %plt()
path_hru.ini            →      path_hru_aqu_read   →   path_soil_ini()%name, %soil(), %plt()
cs_hru.ini              →      cs_hru_read         →   cs_soil_ini()%name, %soil(), %plt()
```

#### Phase 2: Character Name Resolution → Integer Indices (Crosswalk)

```
Memory Structure (Characters)   Subroutine              Output Memory Structure (Indices)
═══════════════════════════════════════════════════════════════════════════════════════
hru.con + sol_plt_ini()     →   hru_read            →   hru()%dbs%soil_plant_init (INTEGER)
sol_plt_ini()%pestc         →   hru_read (92-98)    →   sol_plt_ini()%pest (INTEGER)
sol_plt_ini()%pathc         →   hru_read (99-105)   →   sol_plt_ini()%path (INTEGER)  
sol_plt_ini()%csc           →   hru_read (120-126)  →   sol_plt_ini()%cs (INTEGER)
```

#### Phase 3: Index-Based Initialization → HRU Constituent Arrays (Runtime)

```
Index Access                    Subroutine              Final HRU Storage Structure
═══════════════════════════════════════════════════════════════════════════════════
pest_soil_ini[index]%soil() →   pesticide_init      →   cs_soil(ihru)%ly(ly)%pest()
pest_soil_ini[index]%plt()  →   pesticide_init      →   cs_pl(ihru)%pl_on(ipl)%pest()
path_soil_ini[index]%soil() →   pathogen_init       →   cs_soil(ihru)%ly(1)%path()
path_soil_ini[index]%plt()  →   pathogen_init       →   hpath_bal(ihru)%path()%plant
cs_soil_ini[index]%soil()   →   cs_hru_init         →   cs_soil(ihru)%ly(ly)%cs()
cs_soil_ini[index]%soil()   →   cs_hru_init         →   cs_soil(ihru)%ly(ly)%cs_sorb()
```

### Detailed Subroutine Call Sequence for Constituent Loading

**Main Program Flow**:
```fortran
main.f90.in:
  call proc_read                    ! Phase 1: Load all input files
    call constit_db_read            !   Read master constituent database
    call soil_plant_init            !   Read soil-plant linkage data (CHARACTER names)
    call pest_hru_aqu_read          !   Read pesticide initial concentrations
    call path_hru_aqu_read          !   Read pathogen initial concentrations  
    call cs_hru_read                !   Read constituent initial concentrations
  
  call proc_hru                     ! Phase 2: Initialize HRUs
    call hru_read                   !   Perform CHARACTER → INTEGER crosswalk
    call pesticide_init             !   Initialize pesticides using INTEGER indices
    call pathogen_init              !   Initialize pathogens using INTEGER indices
    call cs_hru_init                !   Initialize constituents using INTEGER indices
```

### How Crosswalk Resolves the "soil_plant_init → HRU" Connection

The crosswalk mechanism establishes the connection between:
1. **HRUs** (spatial units) 
2. **soil_plant_init entries** (linkage/configuration data)
3. **Constituent initialization arrays** (concentration data)

**The Three-Level Indirection System**:

```fortran
! Example for HRU 1 accessing pesticide data:

! Level 1: HRU → soil_plant_init index
hru_sp_index = hru(1)%dbs%soil_plant_init          ! → 2 (points to sol_plt_ini[2])

! Level 2: soil_plant_init → pesticide data index  
pest_data_index = sol_plt_ini(hru_sp_index)%pest   ! → 1 (points to pest_soil_ini[1])

! Level 3: pesticide data → actual concentration values
atrazine_soil_conc = pest_soil_ini(pest_data_index)%soil(1)  ! → 15.0 mg/kg
atrazine_plant_conc = pest_soil_ini(pest_data_index)%plt(1)  ! → 2.5 mg/kg
```

### Where Data Finally Resides in HRU Structures

After the complete loading and crosswalk process, constituent data is stored in these final HRU arrays:

**Pesticide Storage**:
- `cs_soil(ihru)%ly(layer)%pest(ipest)` - Soil pesticide mass (kg/ha) by layer
- `cs_pl(ihru)%pl_on(ipl)%pest(ipest)` - Plant pesticide mass (kg/ha) by plant community
- `cs_irr(ihru)%pest(ipest)` - Irrigation water pesticide concentrations

**Pathogen Storage**:
- `cs_soil(ihru)%ly(1)%path(ipath)` - Pathogen concentrations in top soil layer only
- `hpath_bal(ihru)%path(ipath)%plant` - Plant pathogen balance

**Constituent Storage**:  
- `cs_soil(ihru)%ly(layer)%cs(ics)` - Dissolved constituent mass (kg/ha) by layer
- `cs_soil(ihru)%ly(layer)%cs_sorb(ics)` - Sorbed constituent mass (kg/ha) by layer
- `cs_soil(ihru)%ly(layer)%csc(ics)` - Dissolved constituent concentration (g/m³)
- `cs_soil(ihru)%ly(layer)%csc_sorb(ics)` - Sorbed constituent concentration (mg/kg)

### Critical Benefits of This Loading and Crosswalk Architecture

1. **Flexible Spatial Assignment**: Multiple HRUs can share the same soil_plant_init entry, allowing efficient grouping of similar areas

2. **Modular Constituent Sources**: Different constituent types (pesticides, pathogens, CS) can reference completely different initialization datasets

3. **Performance Optimization**: Character matching occurs once during setup; all runtime access uses fast integer indexing

4. **Human-Readable Input**: Input files use meaningful character names rather than cryptic integer codes

5. **Robust Error Checking**: Unresolved character names are detected and reported during the crosswalk phase

6. **Memory Efficiency**: Initialization data is shared across HRUs rather than duplicated

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

## Summary: Constituent Loading and Crosswalk Process

The constituent initialization process in SWAT+ follows a sophisticated **three-phase loading and crosswalk system** involving multiple specialized subroutines:

### Phase 1: Input File Reading (Character-Based Loading)
**Orchestrated by**: `proc_read.f90`

- **`constit_db_read`**: Defines which constituents will be simulated → `cs_db` structure
- **`soil_plant_init`**: Creates HRU linkage structure → `sol_plt_ini()` array with CHARACTER names
- **`pest_hru_aqu_read`**: Loads pesticide concentrations → `pest_soil_ini()` array 
- **`path_hru_aqu_read`**: Loads pathogen concentrations → `path_soil_ini()` array
- **`cs_hru_read`**: Loads constituent concentrations → `cs_soil_ini()` array

### Phase 2: Character Name Resolution (Crosswalk)
**Performed by**: `hru_read.f90` (lines 78-130)

- **Lines 79-83**: HRU → soil_plant_init entry resolution (CHARACTER → INTEGER)
- **Lines 92-98**: soil_plant_init → pesticide data resolution (CHARACTER → INTEGER)  
- **Lines 99-105**: soil_plant_init → pathogen data resolution (CHARACTER → INTEGER)
- **Lines 120-126**: soil_plant_init → constituent data resolution (CHARACTER → INTEGER)

### Phase 3: HRU Initialization (Index-Based Loading)
**Orchestrated by**: `proc_hru.f90`

- **`pesticide_init`**: Uses crosswalked indices → populates `cs_soil()%pest()` and `cs_pl()%pest()` arrays
- **`pathogen_init`**: Uses crosswalked indices → populates `cs_soil()%path()` and `hpath_bal()%path()` arrays  
- **`cs_hru_init`**: Uses crosswalked indices → populates `cs_soil()%cs()` and `cs_soil()%cs_sorb()` arrays

### Key Architectural Benefits

**Flexible Spatial Heterogeneity**: The crosswalk system allows:
- Multiple HRUs to share initialization sets (efficiency)
- Different areas to have completely different constituent distributions (realism)
- Independent configuration of different constituent types (modularity)

**Performance Optimization**: 
- Character name matching occurs once during setup
- Runtime simulation uses fast integer array indexing
- Initialization data is shared rather than duplicated

**Maintainable Configuration**:
- Input files use human-readable character names
- Robust error checking for unresolved references  
- Modular structure allows independent constituent configuration

This sophisticated loading and crosswalk architecture enables SWAT+ to efficiently handle complex, spatially heterogeneous constituent initialization scenarios while maintaining readable input files and optimal runtime performance.