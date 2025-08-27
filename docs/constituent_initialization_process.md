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
- `pestc`: Reference to pesticide initialization data
- `pathc`: Reference to pathogen initialization data  
- `csc`: Reference to constituent initialization data

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

## Phase 2: HRU Initialization (`proc_hru.f90`)

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
2. Links HRU to its pesticide initialization data via `sol_plt_ini()`
3. Distributes plant pesticides across multiple plant communities
4. Calculates soil pesticide mass from concentration and soil properties

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
2. Links HRU to its pathogen initialization data
3. Initializes only the top soil layer with pathogen concentrations
4. Sets plant pathogen mass in balance arrays

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
2. Links HRU to its constituent initialization data
3. Calculates both dissolved and sorbed constituent masses
4. Converts concentrations to mass units (kg/ha)

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

## Data Structure Hierarchy

```
HRU Level:
├── hru(ihru)%dbs%soil_plant_init → points to sol_plt_ini() element
├── sol_plt_ini()%pest → points to pest_soil_ini() element  
├── sol_plt_ini()%path → points to path_soil_ini() element
└── sol_plt_ini()%cs → points to cs_soil_ini() element

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

The initialization process ensures that each HRU receives appropriate initial constituent concentrations based on its soil and plant characteristics. The system is flexible, allowing different HRUs to have different initial conditions through the soil_plant_init linkage system. The constituent masses are properly converted from concentrations to mass units (kg/ha) using soil physical properties like bulk density, thickness, and water content.