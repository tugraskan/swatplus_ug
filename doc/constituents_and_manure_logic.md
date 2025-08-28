# SWAT+ Constituents and Manure Logic Documentation

## Overview

SWAT+ includes a sophisticated constituent management system that handles pesticides, pathogens, heavy metals, salts, and other chemical constituents. This system has specialized logic for managing constituents in both regular fertilizers and manure applications, with complex carbon and nitrogen cycling processes.

## Table of Contents

1. [Constituent System Architecture](#constituent-system-architecture)
2. [Constituent Loading into Manures](#constituent-loading-into-manures)
3. [Manure and Organic Matter Mixing](#manure-and-organic-matter-mixing)
4. [Regular vs Manure Constituent Logic](#regular-vs-manure-constituent-logic)
5. [Carbon/Nitrogen Cycling Models](#carbonnitrogen-cycling-models)
6. [Database Files and Formats](#database-files-and-formats)
7. [Code Flow and Examples](#code-flow-and-examples)

## Constituent System Architecture

SWAT+ manages constituents through several key modules:

### Core Data Structures

The constituent system is built around the `constituent_mass` type defined in `constituent_mass_module.f90`:

```fortran
type constituent_mass
  real, dimension (:), allocatable :: pest        ! pesticide (kg/ha)
  real, dimension (:), allocatable :: path        ! pathogen (cfu)
  real, dimension (:), allocatable :: hmet        ! heavy metal (kg/ha) 
  real, dimension (:), allocatable :: salt        ! salt ion mass (kg/ha)
  real, dimension (:), allocatable :: cs          ! constituent mass (kg/ha)
  real, dimension (:), allocatable :: csc         ! constituent concentration (mg/L)
  real, dimension (:), allocatable :: cs_sorb     ! sorbed constituent mass (kg/ha)
  real, dimension (:), allocatable :: csc_sorb    ! sorbed constituent concentration (mg/kg)
end type constituent_mass
```

### Constituent Databases

SWAT+ maintains two separate constituent databases:

1. **General Constituents Database** (`cs_db`) - Used for general applications
2. **Manure-Specific Database** (`cs_man_db`) - Used specifically for fertilizer/manure applications

```fortran
type constituents
  integer :: num_tot = 0                                      ! total constituents
  integer :: num_pests = 0                                    ! pesticides
  character (len=16), dimension(:), allocatable :: pests     ! pesticide names
  integer :: num_paths = 0                                    ! pathogens
  character (len=16), dimension(:), allocatable :: paths     ! pathogen names
  integer :: num_metals = 0                                   ! heavy metals
  character (len=16), dimension(:), allocatable :: metals    ! metal names
  integer :: num_salts = 0                                    ! salt ions
  character (len=16), dimension(:), allocatable :: salts     ! salt names
  integer :: num_cs = 0                                       ! other constituents
  character (len=16), dimension(:), allocatable :: cs        ! constituent names
end type constituents

type (constituents) :: cs_db        ! General database
type (constituents) :: cs_man_db    ! Manure-specific database
```

## Constituent Loading into Manures

### 1. Database Initialization

The manure constituent loading process begins with reading the manure-specific constituent database from `constituents_man.cs`:

```fortran
subroutine constit_man_db_read
  ! Reads constituents_man.cs file
  read (106,*) cs_man_db%num_pests      ! Number of pesticides
  read (106,*) (cs_man_db%pests(i), i = 1, cs_man_db%num_pests)
  read (106,*) cs_man_db%num_paths      ! Number of pathogens  
  read (106,*) (cs_man_db%paths(i), i = 1, cs_man_db%num_paths)
  read (106,*) cs_man_db%num_metals     ! Number of heavy metals
  read (106,*) (cs_man_db%metals(i), i = 1, cs_man_db%num_metals)
  read (106,*) cs_man_db%num_salts      ! Number of salt ions
  read (106,*) (cs_man_db%salts(i), i = 1, cs_man_db%num_salts)
  read (106,*) cs_man_db%num_cs         ! Number of other constituents
  read (106,*) (cs_man_db%cs(i), i = 1, cs_man_db%num_cs)
end subroutine
```

### 2. Concentration Data Loading

For each constituent type, SWAT+ reads concentration files (*.man files):

- `pest.man` - Pesticide concentrations in manures
- `path.man` - Pathogen concentrations in manures  
- `salt.man` - Salt concentrations in manures
- `hmet.man` - Heavy metal concentrations in manures
- `cs.man` - Other constituent concentrations in manures

**File Format Example (pest.man):**
```
# Pesticide concentrations in manures
# NAME           PPM
low_pest_manure
  atrazine       1.001
  glyphosate     3.005
high_pest_manure  
  atrazine       5.500
  glyphosate     8.250
```

### 3. Fertilizer-Constituent Crosswalking

The system performs crosswalking to link fertilizer records with constituent concentration data:

```fortran
subroutine fert_constituent_crosswalk
  do ifrt = 1, size(manure_db)
    ! Pesticide crosswalk
    if (manure_db(ifrt)%pest /= '') then
      do i = 1, size(pest_fert_ini)
        if (trim(manure_db(ifrt)%pest) == trim(pest_fert_ini(i)%name)) then
          manure_db(ifrt)%pest_idx = i  ! Store index for direct access
          exit
        end if
      end do
    end if
    ! Similar crosswalking for path, salt, hmet, cs...
  end do
end subroutine
```

### 4. Constituent Application During Manure Application

When manure is applied, constituents are distributed based on pre-computed indices:

```fortran
subroutine fert_constituents_apply(j, ifrt, frt_kg, fertop)
  ! Apply pesticides
  if (cs_man_db%num_pests > 0 .and. manure_db(ifrt)%pest_idx > 0) then
    do ipest = 1, cs_man_db%num_pests
      pest_kg = frt_kg * pest_fert_ini(manure_db(ifrt)%pest_idx)%ppm(ipest)
      ! call pest_apply(j, ipest, pest_kg, fertop)
    end do
  end if
  
  ! Apply pathogens, salts, heavy metals, other constituents similarly...
end subroutine
```

## Manure and Organic Matter Mixing

SWAT+ uses three different carbon cycling models, each with distinct approaches to manure and organic matter mixing:

### Model Selection (bsn_cc%cswat parameter)

- **cswat = 0**: Original SWAT static carbon model
- **cswat = 1**: C-FARM model  
- **cswat = 2**: SWAT-C (CENTURY-based) model

### Organic Matter Pool Structure

The organic matter system uses the `organic_mass` type for all pools:

```fortran
type organic_mass
  real :: m = 0.   ! kg/ha - total object mass
  real :: c = 0.   ! kg/ha - carbon mass  
  real :: n = 0.   ! kg/ha - organic nitrogen mass
  real :: p = 0.   ! kg/ha - organic phosphorus mass
end type organic_mass
```

### Pool Types in SWAT-C Model (cswat = 2)

1. **Fresh Residue Pools:**
   - `meta` - Metabolic litter pool (easily decomposable)
   - `str` - Structural litter pool (resistant, contains lignin)
   - `lig` - Lignin pool (very resistant)

2. **Soil Organic Matter Pools:**
   - `hs` - Slow humus pool (intermediate decomposition)
   - `hp` - Passive humus pool (very slow decomposition)
   - `microb` - Microbial biomass pool

3. **Manure Pool:**
   - `man` - Specific manure pool for C-FARM model

## Regular vs Manure Constituent Logic

### Regular Fertilizer Application (`pl_fert.f90`)

**Characteristics:**
- Uses general constituent database (`cs_db`)
- Simple nutrient addition to soil pools
- Linear allocation between surface and subsurface layers
- Calls `fert_constituents_apply` for associated constituents

**Code Flow:**
```fortran
subroutine pl_fert(ifrt, frt_kg, fertop)
  ! Add mineral nutrients
  soil1(j)%mn(l)%no3 = soil1(j)%mn(l)%no3 + fr_ly * frt_kg * fertdb(ifrt)%fminn
  soil1(j)%mn(l)%nh4 = soil1(j)%mn(l)%nh4 + fr_ly * frt_kg * fertdb(ifrt)%fnh3n
  
  ! Add organic nutrients based on carbon model
  if (bsn_cc%cswat == 0) then
    ! Static carbon model
    soil1(j)%hact(l)%n = soil1(j)%hact(l)%n + (1. - rtof) * fr_ly * frt_kg * fertdb(ifrt)%forgn
  else if (bsn_cc%cswat == 1) then  
    ! C-FARM model
    soil1(j)%man(l)%c = soil1(j)%man(l)%c + fr_ly * frt_kg * fertdb(ifrt)%forgn * 10.
    soil1(j)%man(l)%n = soil1(j)%man(l)%n + fr_ly * frt_kg * fertdb(ifrt)%forgn
  else if (bsn_cc%cswat == 2) then
    ! SWAT-C model - complex allocation to multiple pools
    soil1(j)%meta(l) = soil1(j)%meta(l) + pool_fr * org_frt
    soil1(j)%str(l) = soil1(j)%str(l) + pool_fr * org_frt  
  end if
  
  ! Apply associated constituents
  call fert_constituents_apply(j, ifrt, frt_kg, fertop)
end subroutine
```

### Manure Application (`pl_manure.f90`)

**Characteristics:**
- Uses manure-specific database (`cs_man_db`)
- Complex carbon/nitrogen cycling calculations
- Dynamic allocation based on C:N ratios and lignin content
- Temperature and moisture controls
- Detailed partitioning between metabolic and structural pools

**Key Differences:**

1. **Carbon Allocation Logic:**
```fortran
! Calculate organic carbon fraction (assumed 0.42)
orgc_f = 0.42
X1 = xx * frt_kg  ! Fertilizer applied to layer
X8 = X1 * orgc_f  ! Organic carbon applied

! Calculate lignin fraction based on C:N ratio
RLN = .175 * orgc_f / (fertdb(ifrt)%fminn + fertdb(ifrt)%forgn + 1.e-5)

! Determine metabolic fraction
X10 = .85 - .018 * RLN
if (X10 < 0.01) X10 = 0.01
if (X10 > .7) X10 = .7
```

2. **Pool Allocation:**
```fortran
! Metabolic litter allocation
XXX = X8 * X10  ! Carbon to metabolic pool
soil1(j)%meta(l)%c = soil1(j)%meta(l)%c + XXX
YY = X1 * X10   ! Total mass to metabolic pool
soil1(j)%meta(l)%m = soil1(j)%meta(l)%m + YY

! Structural litter allocation  
XZ = X1 * orgc_f - XXX  ! Remaining carbon to structural pool
soil1(j)%str(l)%c = soil1(j)%str(l)%c + XZ
YZ = X1 - YY    ! Remaining mass to structural pool
soil1(j)%str(l)%m = soil1(j)%str(l)%m + YZ

! Lignin allocation (17.5% of structural carbon)
soil1(j)%lig(l)%c = soil1(j)%lig(l)%c + XZ * .175
soil1(j)%lig(l)%m = soil1(j)%lig(l)%m + YZ * .175
```

3. **Nitrogen Distribution:**
```fortran
! Nitrogen to metabolic pool
ZZ = X1 * rtof * fertdb(ifrt)%forgn * X10
soil1(j)%meta(l)%n = soil1(j)%meta(l)%n + ZZ

! Remaining nitrogen to structural pool
soil1(j)%str(l)%n = soil1(j)%str(l)%n + X1 * fertdb(ifrt)%forgn - ZZ
```

## Carbon/Nitrogen Cycling Models

### Static Carbon Model (cswat = 0)

**Pool Structure:**
- `tot` - Total organic pool
- `hact` - Active humus pool
- `hsta` - Stable humus pool
- `rsd` - Fresh residue pool

**Characteristics:**
- Simple two-pool system (active/stable)
- Fixed allocation ratios
- No detailed C:N ratio controls

### C-FARM Model (cswat = 1)

**Pool Structure:**
- `man` - Dedicated manure pool
- Assumes fixed C:N ratio of 10:1 for manure

**Application Logic:**
```fortran
if (bsn_cc%cswat == 1) then
  soil1(j)%man(l)%c = soil1(j)%man(l)%c + xx * frt_kg * fertdb(ifrt)%forgn * 10.
  soil1(j)%man(l)%n = soil1(j)%man(l)%n + xx * frt_kg * fertdb(ifrt)%forgn
  soil1(j)%man(l)%p = soil1(j)%man(l)%p + xx * frt_kg * fertdb(ifrt)%forgp
end if
```

### SWAT-C Model (cswat = 2)

**Pool Structure:**
- `meta` - Metabolic litter (fast decomposition)
- `str` - Structural litter (slow decomposition)  
- `lig` - Lignin (very slow decomposition)
- `hs` - Slow humus
- `hp` - Passive humus
- `microb` - Microbial biomass

**Key Features:**
- Dynamic allocation based on lignin content
- C:N ratio controls on decomposition
- Temperature and moisture effects
- Detailed transformation pathways

**Allocation Calculations:**
```fortran
! Fraction allocated to metabolic pool depends on lignin content
X10 = .85 - .018 * RLN
where RLN = .175 * orgc_f / (total_N + 1.e-5)

! Metabolic fraction ranges from 0.01 to 0.7
! Remaining goes to structural pool
! 17.5% of structural carbon becomes lignin
```

## Database Files and Formats

### 1. Constituent Database (constituents_man.cs)

```
# Manure constituent database
# Number of pesticides
2
atrazine glyphosate
# Number of pathogens  
1
ecoli
# Number of heavy metals
2
cadmium lead
# Number of salt ions
8
so4 ca mg na k cl co3 hco3
# Number of other constituents
3
selenium boron nitrate
```

### 2. Fertilizer Database (fertilizer.frt)

```
# Standard fertilizer database
# NAME           FMINN  FMINP  FORGN  FORGP  FNH3N
manure01         0.010  0.008  0.025  0.012  0.500
manure02         0.015  0.010  0.030  0.015  0.600
```

### 3. Extended Fertilizer Database (fertilizer_ext.frt)

```
# Extended fertilizer with constituent linkages
# NAME     OM_NAME              PEST     PATH    SALT      HMET     CS
manure01   Midwest_Beef_Liquid  low_pest ecoli   low_salt  low_hmet low_cs
manure02   Dairy_Solid          hi_pest  salm    hi_salt   hi_hmet  hi_cs
```

### 4. Constituent Concentration Files

**pest.man:**
```
# Pesticide concentrations in manures (ppm)
# NAME           PPM
low_pest
  atrazine       0.001
  glyphosate     0.005
hi_pest
  atrazine       0.050
  glyphosate     0.100
```

**path.man:**
```
# Pathogen concentrations in manures (cfu/g)
# NAME           CFU/G  
ecoli_low
  ecoli          1000
salm_hi
  salmonella     5000
```

## Code Flow and Examples

### Complete Application Sequence

1. **Initialization Phase:**
   ```fortran
   call constit_man_db_read          ! Read constituent database
   call fert_constituent_crosswalk   ! Link fertilizers to constituents
   ```

2. **Daily Application Phase:**
   ```fortran
   ! In management operations
   call pl_manure(ifrt, frt_kg, fertop)  ! Apply manure with complex cycling
   ! OR
   call pl_fert(ifrt, frt_kg, fertop)    ! Apply regular fertilizer
   ```

3. **Constituent Distribution:**
   ```fortran
   call fert_constituents_apply(j, ifrt, frt_kg, fertop)
   ! Distributes pesticides, pathogens, salts, etc. to soil/plant pools
   ```

### Example: Complete Manure Application

```fortran
! Apply 1000 kg/ha of manure01 to HRU 1
j = 1           ! HRU number  
ifrt = 1        ! manure01 from fertilizer database
frt_kg = 1000.  ! kg/ha
fertop = 1      ! Application method

! This triggers:
! 1. Nutrient additions (N, P) to mineral pools
! 2. Organic matter allocation to metabolic/structural/lignin pools  
! 3. Constituent loading (pesticides, pathogens, etc.)
! 4. Carbon/nitrogen transformations based on model selection

call pl_manure(ifrt, frt_kg, fertop)
```

### Performance Optimizations

The system uses several optimizations:

1. **Pre-computed Indices:** Eliminates string matching during application
2. **Direct Array Access:** Uses indices stored in `manure_db` structure
3. **Batch Loading:** Reads all constituent files during initialization
4. **Memory Allocation:** Uses `MOVE_ALLOC` for efficient memory management

## Summary

SWAT+ provides a comprehensive constituent management system with distinct handling for regular fertilizers versus manure applications. The key differences are:

1. **Database Separation:** Manure constituents use specialized database
2. **Complex Cycling:** Manure applications include detailed C/N cycling
3. **Dynamic Allocation:** Pool allocation depends on organic matter characteristics
4. **Model Integration:** Different behavior based on carbon cycling model selection

The system is designed for performance and flexibility, allowing detailed tracking of multiple constituent types while maintaining computational efficiency through pre-computed indices and optimized data structures.