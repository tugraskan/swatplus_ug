# SWAT+ Manure-Focused Constituent System Architecture

## Executive Summary

The SWAT+ Manure-Focused Constituent System represents a specialized implementation within the broader constituent framework, designed to address the unique challenges of simulating constituent transport through manure application and organic matter cycling. This document provides detailed analysis of the manure constituent architecture, focusing on recent enhancements and implementation specifics.

## Table of Contents

1. [System Overview](#system-overview)
2. [Manure Database Architecture](#manure-database-architecture)
3. [Source-Demand Allocation Framework](#source-demand-allocation-framework)
4. [Constituent Linkage Mechanisms](#constituent-linkage-mechanisms)
5. [Organic Matter Integration](#organic-matter-integration)
6. [Implementation Analysis](#implementation-analysis)
7. [Recent Enhancements](#recent-enhancements)
8. [Performance Considerations](#performance-considerations)

## System Overview

### 1. Design Philosophy

The manure constituent system addresses several critical challenges in agricultural watershed modeling:

- **Spatial Heterogeneity**: Manure sources are point-based while application is distributed
- **Temporal Dynamics**: Storage, production, and application occur on different time scales
- **Chemical Complexity**: Manure contains multiple constituent types with varying behaviors
- **Organic Matter Coupling**: Constituents are bound to organic matrices that transform over time

### 2. Architectural Components

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│  Manure Sources │────│ Allocation Engine │────│ Application     │
│  - Feedlots     │    │ - Transport      │    │ - HRU Level     │
│  - Dairies      │    │ - Storage        │    │ - Timing        │
│  - Poultry      │    │ - Economics      │    │ - Methods       │
└─────────────────┘    └──────────────────┘    └─────────────────┘
         │                        │                        │
         ▼                        ▼                        ▼
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│ Composition     │    │ Manure Database  │    │ Constituent     │
│ Database        │    │ - manure_om.man  │    │ Transport       │
│ - NPK Content   │    │ - Properties     │    │ - Soil Pools    │
│ - Constituents  │    │ - Unit Conv.     │    │ - Water Quality │
└─────────────────┘    └──────────────────┘    └─────────────────┘
```

### 3. Key Features

#### Advanced Characteristics:
- **Name-Based Crosswalking**: Direct linking between fertilizer and manure databases
- **Dynamic Unit Conversion**: Automatic handling of liquid vs. solid manure units
- **Integrated Organic Matter**: Coupling with SWAT-C soil organic matter pools
- **Multi-Constituent Support**: Simultaneous tracking of multiple constituent types
- **Spatial Allocation**: Economically-driven transport and application decisions

## Manure Database Architecture

### 1. Core Data Structure

The manure organic matter database (`manure_om.man`) provides the foundation:

```fortran
type manure_organic_matter_data
  character(len=25) :: name = " "        ! Unique identifier
  character(len=25) :: region = " "      ! Geographic region
  character(len=25) :: source = " "      ! Animal source (cattle/swine/poultry)
  character(len=25) :: typ = " "         ! Physical form (liquid/slurry/solid/semi-solid)
  
  ! Composition data (% by weight)
  real :: pct_moist = 0.0               ! Moisture content
  real :: pct_solid = 0.0               ! Solid content
  real :: tot_c = 0.0                   ! Total carbon
  real :: tot_n = 0.0                   ! Total nitrogen
  real :: inorg_n = 0.0                 ! Inorganic nitrogen
  real :: org_n = 0.0                   ! Organic nitrogen
  real :: tot_p2o5 = 0.0                ! Total P2O5
  real :: inorg_p2o5 = 0.0              ! Inorganic P2O5
  real :: org_p2o5 = 0.0                ! Organic P2O5
  real :: inorg_p = 0.0                 ! Inorganic phosphorus
  real :: org_p = 0.0                   ! Organic phosphorus
  real :: solids = 0.0                  ! Total solids
  real :: water = 0.0                   ! Water content
end type manure_organic_matter_data
```

### 2. Enhanced Fertilizer Integration

The system implements sophisticated crosswalking between manure and fertilizer databases:

#### Extended Fertilizer Structure:
```fortran
type fertilizer_db_extended
  character(len=16) :: fertnm = " "      ! Fertilizer name
  character(len=25) :: om_name = " "     ! Links to manure_om.man
  integer :: manure_idx = 0              ! Pre-computed manure database index
  
  ! Traditional NPK data
  real :: fminn = 0.                     ! Mineral nitrogen fraction
  real :: fminp = 0.                     ! Mineral phosphorus fraction
  real :: forgn = 0.                     ! Organic nitrogen fraction
  real :: forgp = 0.                     ! Organic phosphorus fraction
  real :: fnh3n = 0.                     ! Ammonia nitrogen fraction
  
  ! Enhanced manure properties (copied from manure_om.man)
  real :: carbon_content = 0.            ! Total carbon (%)
  real :: organic_matter = 0.            ! Total organic matter (%)
  character(len=25) :: manure_type = " " ! Physical form
  real :: conversion_factor = 0.         ! Unit conversion factor
end type fertilizer_db_extended
```

#### Crosswalking Logic:
```fortran
subroutine link_fertilizer_manure_databases()
  do i = 1, db_mx%fertparm
    if (fertdb(i)%om_name /= "") then
      ! Find matching manure record by name
      do j = 1, db_mx%manureparm
        if (trim(fertdb(i)%om_name) == trim(manure_om_db(j)%name)) then
          ! Store index for fast access
          fertdb(i)%manure_idx = j
          
          ! Copy relevant properties
          fertdb(i)%carbon_content = manure_om_db(j)%tot_c
          fertdb(i)%manure_type = manure_om_db(j)%typ
          
          ! Determine conversion factor based on manure type
          call set_unit_conversion_factor(fertdb(i), manure_om_db(j))
          exit
        endif
      enddo
    endif
  enddo
end subroutine
```

### 3. Unit Conversion System

The system handles different manure types with appropriate unit conversions:

#### Conversion Logic:
```fortran
subroutine set_unit_conversion_factor(fert_rec, manure_rec)
  select case (trim(manure_rec%typ))
    case ('liquid', 'slurry')
      ! 1 lb/1000 gal = 119.82 ppm
      fert_rec%conversion_factor = 119.82
      
    case ('solid', 'semi-solid', 'compost')
      ! 1 lb/ton = 500 ppm
      fert_rec%conversion_factor = 500.0
      
    case default
      ! Default to solid conversion
      fert_rec%conversion_factor = 500.0
  end select
end subroutine
```

#### Application in Practice:
```fortran
! Convert manure application rate to constituent loading
constituent_loading_kg_ha = manure_rate_kg_ha * &
                           constituent_conc_ppm * &
                           conversion_factor / 1000000.0
```

## Source-Demand Allocation Framework

### 1. Source Object Definition

Manure sources represent point locations where manure is produced and stored:

```fortran
type manure_source_objects
  integer :: num = 0                      ! Source object number
  character(len=3) :: mois_typ = ""       ! Moisture type (wet/dry)
  character(len=25) :: manure_typ = ""    ! Manure type (links to fertilizer.frt)
  real :: lat = 0.                        ! Latitude (decimal degrees)
  real :: long = 0.                       ! Longitude (decimal degrees)
  real :: stor_init = 0.                  ! Initial storage (tons)
  real :: stor_max = 0.                   ! Maximum storage capacity (tons)
  real, dimension(12) :: prod_mon = 0.    ! Monthly production (tons/month)
  integer :: fertdb = 0                   ! Fertilizer database index
  
  ! Balance tracking
  type(source_manure_output) :: bal_d     ! Daily balance
  type(source_manure_output) :: bal_m     ! Monthly balance
  type(source_manure_output) :: bal_y     ! Yearly balance
  type(source_manure_output) :: bal_a     ! Average annual balance
end type manure_source_objects
```

#### Balance Tracking Structure:
```fortran
type source_manure_output
  real :: stor = 0.                       ! Current storage (tons)
  real :: prod = 0.                       ! Production (tons)
  real :: withdr = 0.                     ! Withdrawal for applications (tons)
end type source_manure_output
```

### 2. Demand Object Framework

Demand objects represent locations where manure is applied:

```fortran
type manure_demand_objects
  integer :: num = 0                      ! Demand object number
  character(len=10) :: ob_typ = ""        ! Object type (hru/muni/divert)
  integer :: ob_num = 0                   ! Object number within type
  character(len=25) :: dtbl = ""          ! Decision table name
  character(len=2) :: right = ""          ! Manure right (sr=senior, jr=junior)
  integer :: dtbl_num = 0                 ! Decision table index
  
  type(manure_demand_amount) :: manure_amt ! Demand specifics
  real, dimension(:), allocatable :: withdr ! Daily withdrawal from each source
end type manure_demand_objects
```

#### Demand Specification:
```fortran
type manure_demand_amount
  integer :: mallo_obj = 0                ! Allocation object number
  integer :: src_obj = 0                  ! Source object number
  real :: app_t_ha = 0.                   ! Application rate (tons/ha)
  integer :: app_method = 0               ! Application method
end type manure_demand_amount
```

### 3. Allocation Algorithm

The allocation system implements a priority-based distribution mechanism:

#### Priority-Based Allocation:
```fortran
subroutine manure_allocation_daily()
  ! 1. Update source production and storage
  call update_source_production()
  
  ! 2. Sort demands by priority (senior rights first)
  call sort_demands_by_priority()
  
  ! 3. Allocate available manure to demands
  do i = 1, num_demands
    if (demand(i)%right == 'sr') then  ! Senior rights first
      call allocate_to_demand(demand(i))
    endif
  enddo
  
  do i = 1, num_demands
    if (demand(i)%right == 'jr') then  ! Junior rights second
      call allocate_to_demand(demand(i))
    endif
  enddo
  
  ! 4. Update storage and balance arrays
  call update_source_balances()
end subroutine
```

#### Distance-Based Cost Function:
```fortran
function transport_cost(source_id, demand_id) result(cost)
  real :: distance, cost
  
  ! Calculate haversine distance
  distance = haversine_distance(source(source_id)%lat, source(source_id)%long, &
                               demand(demand_id)%lat, demand(demand_id)%long)
  
  ! Simple linear cost model (can be enhanced)
  cost = distance * transport_cost_per_km + fixed_cost
end function
```

## Constituent Linkage Mechanisms

### 1. Linkage Table Structure

The system maintains constituent concentration tables for each fertilizer type:

#### File Structure (e.g., `pest.man`):
```
# Pesticide concentrations in manure (ppm)
# NAME              PPM
dacamine            1.001
roundup             3.005
```

#### Data Structure:
```fortran
type cs_fert_init_concentrations
  character(len=16) :: name = ""          ! Constituent name
  real, dimension(:), allocatable :: conc ! Concentration for each fertilizer (ppm)
end type cs_fert_init_concentrations
```

### 2. Loading Mechanism

Constituent concentrations are loaded during initialization:

```fortran
subroutine load_constituent_linkages()
  ! Load pesticide linkages
  if (cs_db%num_pests > 0) then
    call fert_constituent_file_read('pest.man', cs_db%num_pests)
  endif
  
  ! Load pathogen linkages
  if (cs_db%num_paths > 0) then
    call fert_constituent_file_read('path.man', cs_db%num_paths)
  endif
  
  ! Load salt linkages
  if (cs_db%num_salts > 0) then
    call fert_constituent_file_read('salt.man', cs_db%num_salts)
  endif
  
  ! Load heavy metal linkages
  if (cs_db%num_metals > 0) then
    call fert_constituent_file_read('hmet.man', cs_db%num_metals)
  endif
  
  ! Load other constituent linkages
  if (cs_db%num_cs > 0) then
    call fert_constituent_file_read('cs.man', cs_db%num_cs)
  endif
end subroutine
```

### 3. Application Logic

Constituents are applied proportionally to manure application:

```fortran
subroutine apply_manure_constituents(j, ifrt, frt_kg, fertop)
  integer :: j        ! HRU number
  integer :: ifrt     ! Fertilizer ID
  real :: frt_kg      ! Manure application rate (kg/ha)
  integer :: fertop   ! Application method
  
  ! Apply each constituent type
  if (cs_man_db%num_pests > 0) call apply_pesticides(j, ifrt, frt_kg, fertop)
  if (cs_man_db%num_paths > 0) call apply_pathogens(j, ifrt, frt_kg, fertop)
  if (cs_man_db%num_salts > 0) call apply_salts(j, ifrt, frt_kg, fertop)
  if (cs_man_db%num_metals > 0) call apply_heavy_metals(j, ifrt, frt_kg, fertop)
  if (cs_man_db%num_cs > 0) call apply_other_constituents(j, ifrt, frt_kg, fertop)
end subroutine
```

#### Example Pesticide Application:
```fortran
subroutine apply_pesticides(j, ifrt, frt_kg, fertop)
  integer :: ipest, idx
  real :: pest_loading_kg_ha
  
  do ipest = 1, cs_man_db%num_pests
    if (allocated(pest_fert_ini)) then
      ! Get pesticide concentration for this fertilizer
      pest_conc_ppm = pest_fert_ini(ipest)%conc(ifrt)
      
      ! Calculate loading (kg/ha)
      pest_loading_kg_ha = frt_kg * pest_conc_ppm * 1.0e-6
      
      ! Apply to soil and plant pools based on application method
      call distribute_pesticide_loading(j, ipest, pest_loading_kg_ha, fertop)
    endif
  enddo
end subroutine
```

## Organic Matter Integration

### 1. Carbon-Nitrogen Cycling

The manure system integrates with SWAT-C soil organic matter pools:

#### Pool Allocation Logic:
```fortran
subroutine allocate_manure_to_som_pools(j, l, frt_kg, ifrt)
  real :: orgc_f = 0.42    ! Organic carbon fraction (42%)
  real :: X1, X8, X10, XXX, YY, ZZ, XZ, YZ, RLN
  
  ! Total fertilizer applied to layer
  X1 = xx * frt_kg
  
  ! Organic carbon applied
  X8 = X1 * orgc_f
  
  ! Calculate C:N ratio
  RLN = 0.175 * orgc_f / (fertdb(ifrt)%fminn + fertdb(ifrt)%forgn + 1.e-5)
  
  ! Metabolic fraction calculation
  X10 = 0.85 - 0.018 * RLN
  X10 = max(0.01, min(0.7, X10))  ! Constrain to reasonable range
  
  ! Metabolic litter allocation
  XXX = X8 * X10  ! Metabolic litter carbon
  YY = X1 * X10   ! Metabolic litter mass
  
  soil1(j)%meta(l)%c = soil1(j)%meta(l)%c + XXX
  soil1(j)%meta(l)%m = soil1(j)%meta(l)%m + YY
  
  ! Nitrogen allocation to metabolic pool
  ZZ = X1 * rtof * fertdb(ifrt)%forgn * X10
  soil1(j)%meta(l)%n = soil1(j)%meta(l)%n + ZZ
  
  ! Structural litter allocation
  YZ = X1 - YY  ! Remaining mass to structural pool
  XZ = X1 * orgc_f - XXX  ! Remaining carbon to structural pool
  
  soil1(j)%str(l)%m = soil1(j)%str(l)%m + YZ
  soil1(j)%str(l)%c = soil1(j)%str(l)%c + XZ
  soil1(j)%str(l)%n = soil1(j)%str(l)%n + X1 * fertdb(ifrt)%forgn - ZZ
  
  ! Lignin allocation (17.5% of structural carbon)
  soil1(j)%lig(l)%c = soil1(j)%lig(l)%c + XZ * 0.175
  soil1(j)%lig(l)%m = soil1(j)%lig(l)%m + YZ * 0.175
  soil1(j)%lig(l)%n = soil1(j)%lig(l)%n + (X1 * fertdb(ifrt)%forgn - ZZ) * 0.175
end subroutine
```

### 2. Constituent Binding to Organic Matter

Constituents are tracked in association with organic matter pools:

#### Binding Fractions:
```fortran
type constituent_om_binding
  real :: dissolved_fraction = 0.5        ! Fraction in soil solution
  real :: organic_bound_fraction = 0.3    ! Fraction bound to organic matter
  real :: mineral_bound_fraction = 0.2    ! Fraction bound to mineral surfaces
end type constituent_om_binding
```

#### Transformation Coupling:
```fortran
subroutine couple_constituent_om_transformation(j, l, ics)
  real :: om_decomp_rate, constituent_release
  
  ! Get organic matter decomposition rate
  om_decomp_rate = calculate_om_decomposition_rate(j, l)
  
  ! Release constituents proportionally to OM decomposition
  constituent_release = cs_soil(j)%ly(l)%cs_organic(ics) * om_decomp_rate
  
  ! Transfer from organic-bound to dissolved pool
  cs_soil(j)%ly(l)%cs_dissolved(ics) = cs_soil(j)%ly(l)%cs_dissolved(ics) + constituent_release
  cs_soil(j)%ly(l)%cs_organic(ics) = cs_soil(j)%ly(l)%cs_organic(ics) - constituent_release
end subroutine
```

## Implementation Analysis

### 1. Performance Characteristics

#### Memory Usage:
- **Source Objects**: ~50 bytes per source
- **Demand Objects**: ~100 bytes per demand  
- **Constituent Linkages**: ~20 bytes per fertilizer × constituent combination
- **Balance Arrays**: ~200 bytes per HRU × constituent

#### Computational Complexity:
- **Daily Allocation**: O(n_sources × n_demands) for priority-based allocation
- **Constituent Application**: O(n_fertilizers × n_constituents) for linkage lookup
- **Mass Balance**: O(n_hrus × n_constituents × n_layers) for soil updates

### 2. Scalability Analysis

#### Current Limitations:
- **Maximum Sources**: Limited by array allocation (~1000 sources practical)
- **Constituent Types**: Current implementation supports ~50 constituents
- **Spatial Resolution**: Performance degrades with >10,000 HRUs

#### Optimization Opportunities:
1. **Sparse Storage**: Only allocate memory for active constituent-fertilizer combinations
2. **Index Optimization**: Pre-compute and cache frequently-used indices
3. **Parallel Processing**: Parallelize HRU-level constituent calculations

### 3. Error Handling and Validation

#### Input Validation:
```fortran
subroutine validate_manure_inputs()
  ! Check source storage capacity
  do i = 1, num_sources
    if (source(i)%stor_max <= 0) then
      call error_exit("Invalid storage capacity for source", i)
    endif
  enddo
  
  ! Validate constituent concentrations
  do i = 1, num_fertilizers
    do j = 1, num_constituents
      if (constituent_conc(i,j) < 0) then
        call warning("Negative constituent concentration", i, j)
        constituent_conc(i,j) = 0.0
      endif
    enddo
  enddo
end subroutine
```

#### Mass Balance Verification:
```fortran
subroutine verify_manure_mass_balance()
  real :: total_input, total_output, balance_error
  
  total_input = sum(source_production) + sum(initial_storage)
  total_output = sum(manure_applied) + sum(final_storage)
  balance_error = abs(total_input - total_output)
  
  if (balance_error > mass_balance_tolerance) then
    call warning("Manure mass balance error", balance_error)
  endif
end subroutine
```

## Recent Enhancements

### 1. Name-Based Crosswalking (Version 60.5.4+)

Recent updates replace index-based crosswalking with name-based linking:

#### Previous Approach:
```fortran
! Old method required manual index management
fertilizer_id = 15
manure_id = lookup_manure_index(fertilizer_id)
```

#### Enhanced Approach:
```fortran
! New method uses direct name matching
fertilizer_name = "dairy_liquid"
do i = 1, num_manure_types
  if (trim(manure_db(i)%name) == trim(fertilizer_name)) then
    manure_idx = i
    exit
  endif
enddo
```

### 2. Automatic Unit Conversion

The system now handles unit conversions automatically:

#### Implementation:
```fortran
function convert_manure_units(amount, from_units, to_units, manure_type) result(converted_amount)
  real :: amount, converted_amount
  character(len=*) :: from_units, to_units, manure_type
  
  select case (trim(from_units) // " to " // trim(to_units))
    case ("tons to kg")
      converted_amount = amount * 1000.0
      
    case ("gal to L")
      converted_amount = amount * 3.78541
      
    case ("lb/1000gal to ppm")
      if (trim(manure_type) == "liquid") then
        converted_amount = amount * 119.82
      else
        call error_exit("Invalid unit conversion for manure type")
      endif
      
    case ("lb/ton to ppm")
      if (trim(manure_type) == "solid") then
        converted_amount = amount * 500.0
      else
        call error_exit("Invalid unit conversion for manure type")
      endif
  end select
end function
```

### 3. Enhanced Decision Table Integration

New decision table functionality provides flexible manure application timing:

#### Decision Table Structure:
```fortran
type manure_decision_table
  character(len=25) :: name = ""          ! Table name
  integer :: num_conditions = 0           ! Number of conditions
  integer :: num_actions = 0              ! Number of actions
  
  ! Conditions (when to apply manure)
  type(condition), dimension(:), allocatable :: conditions
  
  ! Actions (how much and what type)
  type(action), dimension(:), allocatable :: actions
end type manure_decision_table
```

#### Example Decision Logic:
```fortran
! Apply dairy manure when soil temperature > 5°C and soil moisture < field capacity
if (soil_temp > 5.0 .and. soil_moisture < field_capacity) then
  call apply_manure("dairy_liquid", 20.0, "surface")  ! 20 tons/ha surface application
endif
```

## Performance Considerations

### 1. Memory Optimization

#### Efficient Data Structures:
```fortran
! Use packed data structures for large arrays
type, bind(C) :: packed_constituent_data
  real(c_float) :: concentration
  integer(c_int16_t) :: fertilizer_id
  integer(c_int16_t) :: constituent_id
end type packed_constituent_data
```

#### Memory Pooling:
```fortran
! Pre-allocate memory pools for frequently-used temporary arrays
type memory_pool
  real, dimension(:), allocatable :: temp_real_array
  integer, dimension(:), allocatable :: temp_int_array
  logical :: in_use = .false.
end type memory_pool
```

### 2. Computational Optimization

#### Vectorization:
```fortran
! Use array operations instead of loops where possible
cs_soil(:)%ly(1)%cs(1) = cs_soil(:)%ly(1)%cs(1) + &
                         frt_kg * fert_cs(:)%seo4 * surface_fraction(:)
```

#### Lookup Table Optimization:
```fortran
! Pre-compute frequently-used values
type lookup_table
  integer, dimension(:), allocatable :: fertilizer_to_manure_idx
  real, dimension(:,:), allocatable :: constituent_concentrations
  real, dimension(:), allocatable :: unit_conversion_factors
end type lookup_table
```

### 3. I/O Optimization

#### Buffered Output:
```fortran
! Buffer output data to reduce file I/O overhead
type output_buffer
  real, dimension(:,:), allocatable :: data_buffer
  integer :: buffer_size = 1000
  integer :: current_size = 0
  character(len=256) :: filename
end type output_buffer
```

#### Binary Format Support:
```fortran
! Support binary output for large datasets
subroutine write_binary_output(filename, data)
  character(len=*) :: filename
  real, dimension(:,:) :: data
  
  open(unit=100, file=filename, form='unformatted', access='stream')
  write(100) data
  close(100)
end subroutine
```

---

*Document Version: 1.0*  
*Last Updated: August 2024*  
*Authors: SWAT+ Development Team*  
*Specialization: Manure Constituent Systems*