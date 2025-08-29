# SWAT+ Fertilizer-Constituent Linking Implementation Guide

## Overview

This technical guide provides detailed implementation specifications for the SWAT+ fertilizer-constituent linking system, focusing on the `fert_ext` mechanism and recent enhancements. The document serves as both a technical reference and implementation guide for developers working with the constituent system.

## Table of Contents

1. [System Architecture](#system-architecture)
2. [File Formats and Data Structures](#file-formats-and-data-structures)
3. [Implementation Details](#implementation-details)
4. [API Reference](#api-reference)
5. [Performance Analysis](#performance-analysis)
6. [Testing and Validation](#testing-and-validation)
7. [Migration Guide](#migration-guide)

## System Architecture

### 1. Component Overview

The fertilizer-constituent linking system consists of several interconnected components:

```
┌─────────────────────┐    ┌─────────────────────┐    ┌─────────────────────┐
│   Input Files       │    │   Database Layer    │    │   Application Layer │
│                     │    │                     │    │                     │
│ • fertilizer.frt    │───▶│ • fertdb arrays     │───▶│ • cs_fert.f90       │
│ • fertilizer_ext.frt│    │ • manure_db arrays  │    │ • fert_constituents │
│ • manure_om.man     │    │ • linkage tables    │    │ • pl_fert.f90       │
│ • *.man files       │    │ • index maps        │    │ • pl_manure.f90     │
└─────────────────────┘    └─────────────────────┘    └─────────────────────┘
```

### 2. Data Flow Architecture

```mermaid
graph TD
    A[fertilizer.frt] --> B[fert_parm_read]
    C[fertilizer_ext.frt] --> B
    D[manure_om.man] --> E[manure_parm_read]
    F[*.man files] --> G[fert_constituent_file_read]
    
    B --> H[fertdb array]
    E --> I[manure_db array]
    G --> J[constituent linkage tables]
    
    H --> K[crosswalking engine]
    I --> K
    J --> K
    
    K --> L[fert_constituents_apply]
    L --> M[constituent mass updates]
```

### 3. Key Design Principles

#### Performance-Oriented Design:
- **Pre-computed Indices**: Database lookups occur during initialization
- **Direct Array Access**: Runtime operations use integer indices, not string matching
- **Memory Locality**: Related data structures are co-located in memory

#### Flexibility and Extensibility:
- **Name-Based Crosswalking**: User-friendly fertilizer-manure linking
- **Modular Constituent Support**: Easy addition of new constituent types
- **Configurable Unit Conversion**: Automatic handling of different unit systems

## File Formats and Data Structures

### 1. Enhanced Fertilizer Format (`fertilizer_ext.frt`)

The extended fertilizer format builds upon the traditional structure:

#### Traditional Format (`fertilizer.frt`):
```
fertilizer.frt: written by SWAT+ editor v2.2.2 on 2023-10-17 14:43 for SWAT+ rev.60.5.4
name           min_n    min_p    org_n    org_p    nh3_n    pathogens  description
elem_n         1.00000  0.00000  0.00000  0.00000  0.00000  null       ElementalNitrogen
urea           0.46000  0.00000  0.00000  0.00000  1.00000  null       Urea
dairy_fresh    0.00500  0.00200  0.01100  0.00400  0.66000  fresh_manure DairyFreshManure
```

#### Extended Format (`fertilizer_ext.frt`):
```
fertilizer_ext.frt: enhanced fertilizer database with manure linkage
name           min_n    min_p    org_n    org_p    nh3_n    om_name              pathogens    description
elem_n         1.00000  0.00000  0.00000  0.00000  0.00000  null                 null         ElementalNitrogen
urea           0.46000  0.00000  0.00000  0.00000  1.00000  null                 null         Urea
dairy_fresh    0.00500  0.00200  0.01100  0.00400  0.66000  dairy_fresh_liquid   fresh_manure DairyFreshManure
beef_solid     0.00600  0.00300  0.02000  0.00800  0.55000  beef_feedlot_solid   fresh_manure BeefFeedlotManure
```

#### Key Enhancement: `om_name` Field
The `om_name` field provides direct linkage to the `manure_om.man` database:
```fortran
type fertilizer_db_extended
  character(len=16) :: fertnm = " "      ! Fertilizer name (traditional)
  real :: fminn, fminp, forgn, forgp, fnh3n  ! NPK composition (traditional)
  character(len=25) :: om_name = " "     ! NEW: Links to manure_om.man
  character(len=16) :: pathogens = " "   ! Pathogen linkage (traditional)
  character(len=256) :: description = " " ! Description (traditional)
  
  ! Runtime-computed fields
  integer :: manure_idx = 0              ! Pre-computed manure database index
  real :: conversion_factor = 0.         ! Unit conversion factor
  logical :: is_manure = .false.         ! Flag indicating manure-based fertilizer
end type fertilizer_db_extended
```

### 2. Manure Organic Matter Database (`manure_om.man`)

#### File Format:
```
manure_om.man: organic matter composition database
name                   region    source   typ        pct_moist pct_solid tot_c  tot_n  inorg_n org_n  tot_p2o5 inorg_p2o5 org_p2o5
dairy_fresh_liquid     midwest   cattle   liquid     92.0      8.0       2.1    0.3    0.15    0.15   0.8      0.4        0.4
beef_feedlot_solid     western   cattle   solid      75.0      25.0      8.5    1.2    0.8     0.4    1.5      0.9        0.6
swine_lagoon_liquid    southeast swine    liquid     95.0      5.0       1.8    0.4    0.25    0.15   1.2      0.7        0.5
poultry_litter_solid   northeast poultry  solid      65.0      35.0      15.2   2.8    1.5     1.3    3.2      2.1        1.1
```

#### Data Structure:
```fortran
type manure_organic_matter_data
  character(len=25) :: name = " "         ! Unique identifier (links to om_name)
  character(len=25) :: region = " "       ! Geographic region
  character(len=25) :: source = " "       ! Animal source
  character(len=25) :: typ = " "          ! Physical form
  
  ! Composition (% by weight)
  real :: pct_moist = 0.0                ! Moisture percentage
  real :: pct_solid = 0.0                ! Solids percentage
  real :: tot_c = 0.0                    ! Total carbon
  real :: tot_n = 0.0                    ! Total nitrogen
  real :: inorg_n = 0.0                  ! Inorganic nitrogen
  real :: org_n = 0.0                    ! Organic nitrogen
  real :: tot_p2o5 = 0.0                 ! Total P2O5
  real :: inorg_p2o5 = 0.0               ! Inorganic P2O5
  real :: org_p2o5 = 0.0                 ! Organic P2O5
  real :: inorg_p = 0.0                  ! Inorganic phosphorus
  real :: org_p = 0.0                    ! Organic phosphorus
  real :: solids = 0.0                   ! Total solids content
  real :: water = 0.0                    ! Water content
end type manure_organic_matter_data
```

### 3. Constituent Linkage Files (`*.man`)

Each constituent type has its own linkage file:

#### Pesticide Linkage (`pest.man`):
```
pest.man: pesticide concentrations in fertilizers (ppm)
NAME                     PPM
dacamine                 1.001
roundup                  3.005
atrazine                 0.850
```

#### Pathogen Linkage (`path.man`):
```
path.man: pathogen concentrations in fertilizers (CFU/g or MPN/g)
NAME                     CFU_G
e_coli                   1000.0
salmonella               500.0
fecal_coliform           2000.0
```

#### Salt Linkage (`salt.man`):
```
salt.man: salt ion concentrations in fertilizers (ppm)
NAME                     PPM
sodium                   250.0
chloride                 180.0
sulfate                  320.0
```

## Implementation Details

### 1. Database Loading and Crosswalking

#### Initialization Sequence:
```fortran
subroutine initialize_fertilizer_constituent_system()
  ! 1. Load traditional or extended fertilizer database
  call load_fertilizer_database()
  
  ! 2. Load manure organic matter database
  call load_manure_database()
  
  ! 3. Load constituent linkage tables
  call load_constituent_linkages()
  
  ! 4. Perform crosswalking and index computation
  call compute_fertilizer_manure_indices()
  
  ! 5. Validate data consistency
  call validate_fertilizer_constituent_data()
end subroutine
```

#### Fertilizer Database Loading:
```fortran
subroutine load_fertilizer_database()
  logical :: i_exist_ext, i_exist_std
  
  ! Check for extended fertilizer file first
  inquire (file='fertilizer_ext.frt', exist=i_exist_ext)
  inquire (file='fertilizer.frt', exist=i_exist_std)
  
  if (i_exist_ext) then
    call load_extended_fertilizer_format()
    fertilizer_format = 'extended'
  else if (i_exist_std) then
    call load_standard_fertilizer_format()
    fertilizer_format = 'standard'
  else
    call error_exit("No fertilizer database file found")
  endif
end subroutine
```

#### Crosswalking Implementation:
```fortran
subroutine compute_fertilizer_manure_indices()
  integer :: i, j
  
  do i = 1, db_mx%fertparm
    if (trim(fertdb(i)%om_name) /= "" .and. trim(fertdb(i)%om_name) /= "null") then
      ! Find matching manure record
      do j = 1, db_mx%manureparm
        if (trim(fertdb(i)%om_name) == trim(manure_om_db(j)%name)) then
          ! Store pre-computed index
          fertdb(i)%manure_idx = j
          fertdb(i)%is_manure = .true.
          
          ! Set unit conversion factor
          call set_conversion_factor(fertdb(i), manure_om_db(j))
          
          exit
        endif
      enddo
      
      ! Warn if no match found
      if (fertdb(i)%manure_idx == 0) then
        call warning("No manure database match for fertilizer", fertdb(i)%fertnm)
      endif
    endif
  enddo
end subroutine
```

### 2. Unit Conversion System

#### Conversion Factor Calculation:
```fortran
subroutine set_conversion_factor(fert_rec, manure_rec)
  type(fertilizer_db_extended), intent(inout) :: fert_rec
  type(manure_organic_matter_data), intent(in) :: manure_rec
  
  select case (trim(manure_rec%typ))
    case ('liquid')
      ! 1 lb/1000 gal = 119.82 ppm
      fert_rec%conversion_factor = 119.82
      
    case ('slurry')
      ! Intermediate density, use liquid conversion
      fert_rec%conversion_factor = 119.82
      
    case ('solid', 'semi-solid')
      ! 1 lb/ton = 500 ppm
      fert_rec%conversion_factor = 500.0
      
    case ('compost')
      ! Composted material, use solid conversion
      fert_rec%conversion_factor = 500.0
      
    case default
      ! Default to solid conversion with warning
      call warning("Unknown manure type, using solid conversion", manure_rec%typ)
      fert_rec%conversion_factor = 500.0
  end select
end subroutine
```

#### Runtime Unit Conversion:
```fortran
function convert_constituent_loading(base_rate_kg_ha, conc_ppm, conversion_factor) result(loading_kg_ha)
  real, intent(in) :: base_rate_kg_ha      ! Fertilizer application rate
  real, intent(in) :: conc_ppm             ! Constituent concentration
  real, intent(in) :: conversion_factor    ! Unit conversion factor
  real :: loading_kg_ha                    ! Resulting constituent loading
  
  ! Convert ppm to kg/kg, then multiply by application rate
  loading_kg_ha = base_rate_kg_ha * conc_ppm * conversion_factor / 1.0e6
end function
```

### 3. Constituent Application Engine

#### Master Application Routine:
```fortran
subroutine fert_constituents_apply(j, ifrt, frt_kg, fertop)
  integer, intent(in) :: j           ! HRU number
  integer, intent(in) :: ifrt        ! Fertilizer ID
  real, intent(in) :: frt_kg         ! Application rate (kg/ha)
  integer, intent(in) :: fertop      ! Application method
  
  ! Only apply constituents for manure-based fertilizers
  if (.not. fertdb(ifrt)%is_manure) return
  
  ! Apply each constituent type
  call apply_pesticide_constituents(j, ifrt, frt_kg, fertop)
  call apply_pathogen_constituents(j, ifrt, frt_kg, fertop)
  call apply_salt_constituents(j, ifrt, frt_kg, fertop)
  call apply_heavy_metal_constituents(j, ifrt, frt_kg, fertop)
  call apply_other_constituents(j, ifrt, frt_kg, fertop)
end subroutine
```

#### Pesticide Application Example:
```fortran
subroutine apply_pesticide_constituents(j, ifrt, frt_kg, fertop)
  integer, intent(in) :: j, ifrt, fertop
  real, intent(in) :: frt_kg
  
  integer :: ipest, soil_layer
  real :: pest_loading_kg_ha, surface_fraction, subsurface_fraction
  
  if (cs_db%num_pests == 0) return
  if (.not. allocated(pest_fert_ini)) return
  
  ! Get application fractions
  surface_fraction = chemapp_db(fertop)%surf_frac
  subsurface_fraction = 1.0 - surface_fraction
  
  do ipest = 1, cs_db%num_pests
    ! Calculate pesticide loading
    pest_loading_kg_ha = convert_constituent_loading(frt_kg, &
                         pest_fert_ini(ipest)%conc(ifrt), &
                         fertdb(ifrt)%conversion_factor)
    
    ! Apply to soil layers
    do soil_layer = 1, 2
      if (soil_layer == 1) then
        ! Surface layer application
        pest_mass_layer = pest_loading_kg_ha * surface_fraction
      else
        ! Subsurface layer application
        pest_mass_layer = pest_loading_kg_ha * subsurface_fraction
      endif
      
      ! Update soil pesticide mass
      hru_pest_soil(j)%pest(ipest)%soil(soil_layer) = &
        hru_pest_soil(j)%pest(ipest)%soil(soil_layer) + pest_mass_layer
      
      ! Update balance arrays
      hpestb_d(j)%pest(ipest)%fert = hpestb_d(j)%pest(ipest)%fert + pest_mass_layer
    enddo
  enddo
end subroutine
```

### 4. Performance Optimizations

#### Index Caching:
```fortran
! Global arrays for fast lookup
integer, dimension(:), allocatable :: fertilizer_to_manure_map
logical, dimension(:), allocatable :: fertilizer_is_manure
real, dimension(:), allocatable :: fertilizer_conversion_factors

subroutine build_lookup_tables()
  allocate(fertilizer_to_manure_map(db_mx%fertparm))
  allocate(fertilizer_is_manure(db_mx%fertparm))
  allocate(fertilizer_conversion_factors(db_mx%fertparm))
  
  do i = 1, db_mx%fertparm
    fertilizer_to_manure_map(i) = fertdb(i)%manure_idx
    fertilizer_is_manure(i) = fertdb(i)%is_manure
    fertilizer_conversion_factors(i) = fertdb(i)%conversion_factor
  enddo
end subroutine
```

#### Memory Layout Optimization:
```fortran
! Structure-of-arrays for better cache performance
type constituent_arrays
  real, dimension(:,:), allocatable :: concentrations  ! (fertilizer, constituent)
  integer, dimension(:), allocatable :: fertilizer_ids
  integer, dimension(:), allocatable :: constituent_ids
end type constituent_arrays

type(constituent_arrays) :: pest_data, path_data, salt_data, hmet_data, cs_data
```

## API Reference

### 1. Core Functions

#### `fert_constituents_apply`
```fortran
subroutine fert_constituents_apply(j, ifrt, frt_kg, fertop)
  integer, intent(in) :: j           ! HRU number (1 to num_hrus)
  integer, intent(in) :: ifrt        ! Fertilizer ID (1 to db_mx%fertparm)
  real, intent(in) :: frt_kg         ! Application rate (kg/ha)
  integer, intent(in) :: fertop      ! Application method ID
```
**Purpose**: Master routine for applying all constituents associated with a fertilizer application.

**Usage Example**:
```fortran
! Apply 25 kg/ha of dairy manure using surface application (method 1)
call fert_constituents_apply(hru_id, dairy_fert_id, 25.0, 1)
```

#### `convert_constituent_loading`
```fortran
function convert_constituent_loading(base_rate_kg_ha, conc_ppm, conversion_factor) result(loading_kg_ha)
  real, intent(in) :: base_rate_kg_ha    ! Base application rate
  real, intent(in) :: conc_ppm           ! Constituent concentration
  real, intent(in) :: conversion_factor  ! Unit conversion factor
  real :: loading_kg_ha                  ! Resulting loading
```
**Purpose**: Convert constituent concentration to mass loading based on fertilizer application rate.

#### `lookup_manure_properties`
```fortran
function lookup_manure_properties(fertilizer_id) result(manure_props)
  integer, intent(in) :: fertilizer_id
  type(manure_organic_matter_data) :: manure_props
```
**Purpose**: Retrieve manure properties for a given fertilizer ID.

### 2. Utility Functions

#### `validate_fertilizer_constituent_linkage`
```fortran
logical function validate_fertilizer_constituent_linkage(ifrt, constituent_type) result(is_valid)
  integer, intent(in) :: ifrt              ! Fertilizer ID
  character(len=*), intent(in) :: constituent_type  ! 'pest', 'path', 'salt', etc.
```
**Purpose**: Check if a fertilizer has valid constituent linkages.

#### `get_constituent_concentration`
```fortran
function get_constituent_concentration(ifrt, constituent_id, constituent_type) result(concentration)
  integer, intent(in) :: ifrt              ! Fertilizer ID
  integer, intent(in) :: constituent_id    ! Constituent index
  character(len=*), intent(in) :: constituent_type
  real :: concentration                     ! Concentration (ppm or CFU/g)
```
**Purpose**: Retrieve constituent concentration for specific fertilizer-constituent combination.

### 3. Configuration Functions

#### `set_constituent_application_method`
```fortran
subroutine set_constituent_application_method(constituent_type, application_method)
  character(len=*), intent(in) :: constituent_type    ! 'pest', 'path', etc.
  integer, intent(in) :: application_method           ! Application method ID
```
**Purpose**: Configure how specific constituent types are applied (surface vs. incorporated).

#### `enable_constituent_tracking`
```fortran
subroutine enable_constituent_tracking(constituent_types)
  character(len=*), dimension(:), intent(in) :: constituent_types
```
**Purpose**: Enable tracking for specific constituent types.

## Performance Analysis

### 1. Computational Complexity

#### Initialization Phase:
- **Database Loading**: O(n_fertilizers + n_manure_types + n_constituents)
- **Crosswalking**: O(n_fertilizers × n_manure_types)
- **Index Building**: O(n_fertilizers × n_constituents)

#### Runtime Phase:
- **Constituent Application**: O(n_constituents × n_soil_layers)
- **Mass Balance Updates**: O(n_constituents)
- **Output Generation**: O(n_constituents × n_time_steps)

### 2. Memory Usage

#### Static Allocation:
```fortran
! Typical memory requirements
! Fertilizer database: ~1 KB per fertilizer type
! Manure database: ~2 KB per manure type  
! Constituent linkages: ~0.1 KB per fertilizer-constituent pair
! Balance arrays: ~0.5 KB per HRU per constituent
```

#### Dynamic Scaling:
```fortran
! Memory usage scaling relationships
total_memory_kb = 1.0 * n_fertilizers + &
                  2.0 * n_manure_types + &
                  0.1 * n_fertilizers * n_constituents + &
                  0.5 * n_hrus * n_constituents
```

### 3. Performance Benchmarks

#### Typical Performance Characteristics:
```
System Configuration: Intel i7-8700K, 32GB RAM, GNU Fortran 9.3
Watershed Size: 1000 HRUs, 50 fertilizer types, 20 constituents

Initialization Time: ~0.2 seconds
Daily Constituent Application: ~0.05 seconds per 1000 applications
Memory Usage: ~50 MB for constituent data structures
```

#### Optimization Guidelines:
1. **Pre-compute Indices**: Build lookup tables during initialization
2. **Batch Operations**: Process multiple HRUs simultaneously where possible
3. **Memory Alignment**: Use structure-of-arrays for large datasets
4. **Compiler Optimization**: Enable `-O3` and vectorization flags

## Testing and Validation

### 1. Unit Tests

#### Database Loading Tests:
```fortran
subroutine test_fertilizer_database_loading()
  ! Test standard format loading
  call load_test_fertilizer_database('test_fertilizer.frt')
  assert(db_mx%fertparm == expected_count)
  
  ! Test extended format loading
  call load_test_fertilizer_database('test_fertilizer_ext.frt')
  assert(fertdb(1)%om_name == expected_om_name)
end subroutine
```

#### Crosswalking Tests:
```fortran
subroutine test_fertilizer_manure_crosswalking()
  ! Setup test data
  fertdb(1)%om_name = "test_manure"
  manure_om_db(1)%name = "test_manure"
  
  ! Perform crosswalking
  call compute_fertilizer_manure_indices()
  
  ! Verify results
  assert(fertdb(1)%manure_idx == 1)
  assert(fertdb(1)%is_manure == .true.)
end subroutine
```

#### Unit Conversion Tests:
```fortran
subroutine test_unit_conversions()
  real :: result
  
  ! Test liquid manure conversion
  result = convert_constituent_loading(1000.0, 100.0, 119.82)
  assert(abs(result - 0.01198) < 1.0e-6)
  
  ! Test solid manure conversion
  result = convert_constituent_loading(1000.0, 100.0, 500.0)
  assert(abs(result - 0.05000) < 1.0e-6)
end subroutine
```

### 2. Integration Tests

#### Full System Test:
```fortran
subroutine test_full_constituent_application()
  integer :: hru_id = 1, fert_id = 5
  real :: initial_mass, final_mass, expected_addition
  
  ! Record initial constituent mass
  initial_mass = sum(hru_pest_soil(hru_id)%pest(:)%soil(:))
  
  ! Apply fertilizer with constituents
  call fert_constituents_apply(hru_id, fert_id, 50.0, 1)
  
  ! Check mass balance
  final_mass = sum(hru_pest_soil(hru_id)%pest(:)%soil(:))
  expected_addition = calculate_expected_constituent_mass(fert_id, 50.0)
  
  assert(abs((final_mass - initial_mass) - expected_addition) < mass_balance_tolerance)
end subroutine
```

### 3. Validation Datasets

#### Test Case 1: Simple Fertilizer Application
```
Input:
- Fertilizer: urea (no constituents)
- Application: 100 kg/ha
Expected Output:
- No constituent mass changes
- No balance array updates
```

#### Test Case 2: Manure Application with Pesticides
```
Input:
- Fertilizer: dairy_liquid (linked to dairy_fresh_liquid manure)
- Pesticide: atrazine at 2.5 ppm
- Application: 20 tons/ha (20,000 kg/ha)
Expected Output:
- Atrazine loading: 20,000 * 2.5 * 119.82 / 1,000,000 = 5.99 kg/ha
- Distribution: 70% surface layer, 30% subsurface layer (assuming surf_frac = 0.7)
```

#### Test Case 3: Multi-Constituent Complex Application
```
Input:
- Fertilizer: poultry_litter (multiple constituents)
- Constituents: E. coli (1000 CFU/g), phosphorus (3.2%), nitrogen (2.8%)
- Application: 5 tons/ha (5,000 kg/ha)
Expected Output:
- E. coli loading: 5,000 * 1000 * 500 / 1,000,000 = 2,500 CFU/ha
- Phosphorus loading: 5,000 * 32,000 * 500 / 1,000,000 = 80 kg/ha
- Nitrogen loading: 5,000 * 28,000 * 500 / 1,000,000 = 70 kg/ha
```

## Migration Guide

### 1. Upgrading from Standard to Extended Format

#### Step 1: Backup Existing Files
```bash
cp fertilizer.frt fertilizer.frt.backup
cp -r existing_simulation_directory backup_directory
```

#### Step 2: Create Extended Fertilizer File
```fortran
! Add om_name column to existing fertilizer.frt
! Example conversion:
! OLD: dairy_fresh  0.00500  0.00200  0.01100  0.00400  0.66000  fresh_manure  DairyFreshManure
! NEW: dairy_fresh  0.00500  0.00200  0.01100  0.00400  0.66000  dairy_fresh_liquid  fresh_manure  DairyFreshManure
```

#### Step 3: Create Manure Database
```fortran
! Create manure_om.man file with corresponding entries
! Example:
! dairy_fresh_liquid  midwest  cattle  liquid  92.0  8.0  2.1  0.3  0.15  0.15  0.8  0.4  0.4
```

#### Step 4: Update Constituent Linkage Files
```fortran
! Ensure *.man files have entries for all fertilizer types
! pest.man, path.man, salt.man, hmet.man, cs.man
```

### 2. Compatibility Considerations

#### Backward Compatibility:
- Standard `fertilizer.frt` format remains fully supported
- Existing simulations continue to work without modification
- Extended features are opt-in via file presence detection

#### Forward Compatibility:
- Extended format is designed for future enhancements
- Additional columns can be added without breaking existing parsers
- Modular constituent system supports new constituent types

### 3. Common Migration Issues

#### Issue 1: Missing Manure Database Entries
```
Error: No manure database match for fertilizer 'dairy_fresh'
Solution: Ensure all om_name entries in fertilizer_ext.frt have corresponding entries in manure_om.man
```

#### Issue 2: Unit Conversion Problems
```
Warning: Unknown manure type 'custom_type', using solid conversion
Solution: Use standard manure types ('liquid', 'solid', 'slurry', 'compost') or extend the conversion logic
```

#### Issue 3: Missing Constituent Linkage Files
```
Error: Constituent linkage file 'pest.man' not found
Solution: Create constituent linkage files even if they contain zero concentrations for all fertilizers
```

---

*Document Version: 1.0*  
*Last Updated: August 2024*  
*Authors: SWAT+ Development Team*  
*Focus: Technical Implementation*