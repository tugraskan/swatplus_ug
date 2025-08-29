# SWAT+ Constituent System Architecture Documentation

## Overview

The SWAT+ Constituent System provides comprehensive tracking and simulation of various chemical and biological constituents throughout the watershed, including pesticides, pathogens, heavy metals, salts, and user-defined constituents. This document analyzes the current implementation, focusing on the constituent tracking mechanisms and the manure-focused constituent system architecture.

## Table of Contents

1. [Core Architecture](#core-architecture)
2. [Constituent Types and Data Structures](#constituent-types-and-data-structures)
3. [Fertilizer-Constituent Linking System](#fertilizer-constituent-linking-system)
4. [Manure-Focused Constituent System](#manure-focused-constituent-system)
5. [Constituent Tracking Implementation](#constituent-tracking-implementation)
6. [Recent Updates and New Logic](#recent-updates-and-new-logic)
7. [Areas for Improvement](#areas-for-improvement)

## Core Architecture

### 1. Module Structure

The constituent system is built around several key Fortran modules that provide a hierarchical organization:

#### Primary Modules:
- **`constituent_mass_module.f90`**: Core data structures for constituent mass tracking
- **`cs_module.f90`**: Constituent balance tracking and flux calculations
- **`cs_data_module.f90`**: Reaction parameters and kinetic data
- **`fertilizer_data_module.f90`**: Fertilizer and manure composition data
- **`manure_allocation_module.f90`**: Manure source/demand allocation system

#### Application Modules:
- **`cs_fert.f90`**: Constituent application from fertilizers
- **`cs_fert_wet.f90`**: Wetland fertilizer constituent applications
- **`fert_constituents.f90`**: Centralized constituent application logic
- **`pl_manure.f90`**: Manure application with organic matter cycling

### 2. Data Flow Architecture

```
Input Files → Database Loading → Application Events → Mass Tracking → Output Generation
     ↓              ↓                  ↓               ↓              ↓
fertilizer.frt  fertdb arrays    Management      cs_soil arrays   Balance files
fert_ext.frt   manure_db        Operations      cs_water arrays   .csv outputs
*.man files    constituent      (fertilizer     cs_aquifer       Monitoring
               linkage tables   applications)   cs_plant         reports
```

## Constituent Types and Data Structures

### 1. Constituent Database Structure

The system supports five major constituent categories:

```fortran
type constituents
  integer :: num_pests = 0                    ! Number of pesticides
  character(len=16), dimension(:), allocatable :: pests    ! Pesticide names
  integer, dimension(:), allocatable :: pest_num           ! Database indices
  
  integer :: num_paths = 0                    ! Number of pathogens  
  character(len=16), dimension(:), allocatable :: paths    ! Pathogen names
  integer, dimension(:), allocatable :: path_num           ! Database indices
  
  integer :: num_metals = 0                   ! Number of heavy metals
  character(len=16), dimension(:), allocatable :: metals   ! Metal names
  integer, dimension(:), allocatable :: metals_num         ! Database indices
  
  integer :: num_salts = 0                    ! Number of salt ions
  character(len=16), dimension(:), allocatable :: salts    ! Salt names
  integer, dimension(:), allocatable :: salts_num          ! Database indices
  
  integer :: num_cs = 0                       ! Number of other constituents
  character(len=16), dimension(:), allocatable :: cs       ! Constituent names
  integer, dimension(:), allocatable :: cs_num             ! Database indices
end type constituents
```

#### Key Features:
- **Unified Database**: Single structure (`cs_db`) for watershed-wide constituents
- **Manure-Specific Database**: Separate structure (`cs_man_db`) for manure-linked constituents
- **Index Mapping**: Pre-computed database indices for performance optimization
- **Extensible Design**: Support for user-defined constituent categories

### 2. Current Implementation Focus: Selenium and Boron

The current implementation primarily tracks three constituents:
- **SEO4 (Selenate)**: Oxidized selenium form, mobile in soil
- **SEO3 (Selenite)**: Reduced selenium form, more strongly sorbed
- **Boron**: Essential micronutrient that can become toxic at high concentrations

```fortran
type fert_db_cs
  character(len=16) :: fertnm = " "
  real :: seo4 = 0.     ! kg seo4/ha - fertilizer load of selenate
  real :: seo3 = 0.     ! kg seo3/ha - fertilizer load of selenite  
  real :: boron = 0.    ! kg boron/ha - fertilizer load of boron
end type fert_db_cs
```

### 3. Mass Balance Structure

Comprehensive tracking of constituent fluxes:

```fortran
type cs_balance
  real :: soil = 0.     ! Total mass in soil profile (kg/ha)
  real :: surq = 0.     ! Surface runoff losses (kg/ha)
  real :: sedm = 0.     ! Sediment-bound losses (kg/ha)
  real :: latq = 0.     ! Lateral flow losses (kg/ha)
  real :: perc = 0.     ! Leaching losses (kg/ha)
  real :: fert = 0.     ! Fertilizer inputs (kg/ha)
  real :: uptk = 0.     ! Plant uptake (kg/ha)
  real :: rctn = 0.     ! Chemical reactions (kg/ha)
  real :: sorb = 0.     ! Sorption/desorption (kg/ha)
  real :: conc = 0.     ! Soil water concentration (mg/L)
  real :: srbd = 0.     ! Sorbed mass (kg/ha)
end type cs_balance
```

## Fertilizer-Constituent Linking System

### 1. Enhanced Fertilizer Extension System

The latest updates introduce a sophisticated fertilizer extension system that supports:

#### Traditional Fertilizer Database (`fertilizer.frt`):
```
name          min_n    min_p    org_n    org_p    nh3_n    pathogens  description
elem_n        1.00000  0.00000  0.00000  0.00000  0.00000  null       ElementalNitrogen
urea          0.46000  0.00000  0.00000  0.00000  1.00000  null       Urea
ceap_p_n      0.42000  0.00000  0.58000  0.00000  0.39200  ceap_manure Ceap_Manure_N_Fr_Past
```

#### Extended Fertilizer Database (`fertilizer_ext.frt`):
- **Direct Name-Based Crosswalking**: Links to `manure_om.man` via `om_name` field
- **Enhanced Composition Data**: Detailed organic matter characteristics
- **Constituent Linkage Tables**: Direct connections to pesticide, pathogen, and constituent databases

### 2. Constituent Application Logic

The system implements a layered approach to constituent application:

```fortran
subroutine cs_fert(jj,ifrt,frt_kg,fertop)
  ! Apply constituent fertilizer to soil profile
  if (cs_db%num_cs > 0 .and. fert_cs_flag == 1) then
    if(ifrt > 0) then
      do l=1,2  ! Top two soil layers
        ! Determine surface vs subsurface application fraction
        xx = chemapp_db(fertop)%surf_frac  ! Layer 1
        xx = 1. - chemapp_db(fertop)%surf_frac  ! Layer 2
        
        ! Apply constituent mass to soil
        cs_soil(jj)%ly(l)%cs(1) = cs_soil(jj)%ly(l)%cs(1) + (xx * frt_kg * fert_cs(ifrt)%seo4)
        cs_soil(jj)%ly(l)%cs(2) = cs_soil(jj)%ly(l)%cs(2) + (xx * frt_kg * fert_cs(ifrt)%seo3)
        cs_soil(jj)%ly(l)%cs(3) = cs_soil(jj)%ly(l)%cs(3) + (xx * frt_kg * fert_cs(ifrt)%boron)
        
        ! Update balance arrays
        hcsb_d(jj)%cs(1)%fert = hcsb_d(jj)%cs(1)%fert + (xx * frt_kg * fert_cs(ifrt)%seo4)
        hcsb_d(jj)%cs(2)%fert = hcsb_d(jj)%cs(2)%fert + (xx * frt_kg * fert_cs(ifrt)%seo3)
        hcsb_d(jj)%cs(3)%fert = hcsb_d(jj)%cs(3)%fert + (xx * frt_kg * fert_cs(ifrt)%boron)
      enddo
    endif
  endif
end subroutine
```

### 3. Centralized Constituent Application

The new `fert_constituents.f90` module provides unified constituent application:

```fortran
subroutine fert_constituents_apply(j, ifrt, frt_kg, fertop)
  ! Apply all constituent types linked to fertilizer
  ! Uses pre-computed indices for performance
  
  ! Pesticides
  if (cs_man_db%num_pests > 0) then
    if (allocated(pest_fert_ini)) then
      ! Apply pesticide loads
    endif
  endif
  
  ! Pathogens, salts, heavy metals, other constituents
  ! Similar logic for each constituent type
end subroutine
```

## Manure-Focused Constituent System

### 1. Architecture Overview

The manure constituent system represents a significant advancement in SWAT+ capability, providing:
- **Source-Demand Allocation**: Spatially explicit manure transport modeling
- **Organic Matter Integration**: Direct linkage with SOM pools and C/N cycling
- **Constituent Tracking**: Full constituent mass balance through manure applications

### 2. Manure Database Structure

#### Manure Organic Matter Database (`manure_om.man`):
```fortran
type manure_organic_matter_data
  character(len=25) :: name = " "        ! Manure type name
  character(len=25) :: region = " "      ! Geographic region
  character(len=25) :: source = " "      ! Animal source
  character(len=25) :: typ = " "         ! Physical form (liquid/solid)
  real :: pct_moist = 0.0               ! Moisture content (%)
  real :: pct_solid = 0.0               ! Solid content (%)
  real :: tot_c = 0.0                   ! Total carbon (%)
  real :: tot_n = 0.0                   ! Total nitrogen (%)
  real :: inorg_n = 0.0                 ! Inorganic nitrogen (%)
  real :: org_n = 0.0                   ! Organic nitrogen (%)
  real :: tot_p2o5 = 0.0                ! Total P2O5 (%)
  real :: inorg_p2o5 = 0.0              ! Inorganic P2O5 (%)
  real :: org_p2o5 = 0.0                ! Organic P2O5 (%)
  real :: inorg_p = 0.0                 ! Inorganic phosphorus (%)
  real :: org_p = 0.0                   ! Organic phosphorus (%)
end type manure_organic_matter_data
```

### 3. Manure Allocation System

#### Source Objects:
```fortran
type manure_source_objects
  integer :: num = 0                    ! Source object number
  character(len=3) :: mois_typ = ""     ! Moisture type (wet/dry)
  character(len=25) :: manure_typ = ""  ! Links to fertilizer.frt
  real :: lat = 0.                      ! Latitude
  real :: long = 0.                     ! Longitude
  real :: stor_init = 0.                ! Initial storage (tons)
  real :: stor_max = 0.                 ! Maximum storage (tons)
  real, dimension(12) :: prod_mon = 0.  ! Monthly production (tons/month)
  integer :: fertdb = 0                 ! Fertilizer database index
end type manure_source_objects
```

#### Demand Objects:
```fortran
type manure_demand_objects
  integer :: num = 0                    ! Demand object number
  character(len=10) :: ob_typ = ""      ! Object type (hru/muni/divert)
  integer :: ob_num = 0                 ! Object number
  character(len=25) :: dtbl = ""        ! Decision table name
  character(len=2) :: right = ""        ! Water right priority (sr/jr)
end type manure_demand_objects
```

### 4. Organic Matter Integration

The manure system includes sophisticated organic matter partitioning:

```fortran
! Organic carbon allocation to metabolic litter pool
orgc_f = 0.42  ! Organic carbon fraction
X1 = xx * frt_kg  ! Fertilizer applied to layer
X8 = X1 * orgc_f  ! Organic carbon applied

! C:N ratio calculation
RLN = .175 * orgc_f / (fertdb(ifrt)%fminn + fertdb(ifrt)%forgn + 1.e-5)

! Metabolic fraction calculation
X10 = .85 - .018 * RLN
if (X10 < 0.01) X10 = 0.01
if (X10 > 0.7) X10 = 0.7

! Pool allocation
XXX = X8 * X10  ! Metabolic litter carbon
soil1(j)%meta(l)%c = soil1(j)%meta(l)%c + XXX

YY = X1 * X10  ! Metabolic litter mass
soil1(j)%meta(l)%m = soil1(j)%meta(l)%m + YY

! Structural litter allocation
YZ = X1 - YY  ! Structural litter mass
soil1(j)%str(l)%m = soil1(j)%str(l)%m + YZ

! Lignin allocation (assumed 17.5% of structural litter)
soil1(j)%lig(l)%m = soil1(j)%lig(l)%m + YZ * .175
```

## Constituent Tracking Implementation

### 1. Spatial Distribution

Constituents are tracked across multiple spatial scales:

#### HRU Level:
- **Soil Profile**: Layer-by-layer constituent concentrations
- **Plant Pools**: Constituent mass in/on plant tissues
- **Surface Pools**: Runoff and sediment-bound constituents

#### Landscape Level:
- **Channel Networks**: Water column and benthic constituent mass
- **Wetlands**: Constituent retention and transformation
- **Reservoirs**: Settling and stratification effects

#### Watershed Level:
- **Aquifers**: Groundwater constituent transport
- **Mass Balance**: System-wide constituent accounting

### 2. Process Representation

#### Chemical Processes:
```fortran
type constituent_rct
  real :: kd_seo4 = 0.     ! Selenate sorption coefficient
  real :: kd_seo3 = 0.     ! Selenite sorption coefficient  
  real :: kd_born = 0.     ! Boron sorption coefficient
  real :: kseo4 = 0.       ! SEO4 → SEO3 reduction rate (1/day)
  real :: kseo3 = 0.       ! SEO3 → Se reduction rate (1/day)
  real :: se_ino3 = 0.     ! Selenium reduction inhibition factor
  real :: oxy_soil = 0.    ! Soil oxygen concentration (mg/L)
  real :: oxy_aqu = 0.     ! Groundwater oxygen concentration (mg/L)
end type constituent_rct
```

#### Physical Processes:
- **Sorption/Desorption**: Linear and non-linear isotherms
- **Advection**: Movement with water flow
- **Dispersion**: Concentration-gradient driven transport
- **Plant Uptake**: Root absorption and translocation
- **Volatilization**: Air-water partitioning

### 3. Mass Balance Verification

The system implements rigorous mass balance checking:

```fortran
! Daily balance updates
hcsb_d(jj)%cs(ics)%soil = current_soil_mass
hcsb_d(jj)%cs(ics)%surq = surface_runoff_loss
hcsb_d(jj)%cs(ics)%latq = lateral_flow_loss
hcsb_d(jj)%cs(ics)%perc = leaching_loss
hcsb_d(jj)%cs(ics)%fert = fertilizer_input
hcsb_d(jj)%cs(ics)%uptk = plant_uptake

! Monthly and annual aggregation
hcsb_m(jj)%cs(ics) = sum(hcsb_d(jj)%cs(ics))
hcsb_y(jj)%cs(ics) = sum(hcsb_m(jj)%cs(ics))
```

## Recent Updates and New Logic

### 1. Fertilizer Extension System (fert_ext)

The latest implementation introduces major enhancements:

#### Key Features:
- **Name-Based Crosswalking**: Direct fertilizer.frt ↔ manure_om.man linking
- **Pre-Computed Indices**: Performance optimization through array indexing
- **Unified Application Logic**: Centralized constituent application in `fert_constituents.f90`
- **Type-Based Unit Conversion**: Automatic unit handling based on manure type

#### Implementation:
```fortran
! Check for extended fertilizer file
inquire (file='fertilizer_ext.frt', exist = i_exist_cbn)
if (.not. i_exist_cbn) then
   allocate (manure_db(0:0)) 
else
    in_parmdb%fert_frt = 'fertilizer_ext.frt'
endif
```

### 2. Manure Database Integration

Recent updates provide seamless integration between fertilizer and manure databases:

#### Unit Conversion Logic:
```fortran
! Automatic unit conversion based on manure type
if (manure_om_db(i)%typ == 'liquid' .or. manure_om_db(i)%typ == 'slurry') then
  conversion_factor = 119.82  ! 1 lb/1000 gal = 119.82 ppm
else
  conversion_factor = 500.0   ! 1 lb/ton = 500 ppm (solid/semi-solid)
endif
```

#### Crosswalking Enhancement:
```fortran
! Direct name-to-name crosswalking between fertilizer_ext.frt and manure_om.man
do i = 1, db_mx%fertparm
  if (fertdb(i)%om_name /= "") then
    ! Find matching manure record
    do j = 1, db_mx%manureparm
      if (trim(fertdb(i)%om_name) == trim(manure_om_db(j)%name)) then
        ! Copy manure attributes to fertilizer record
        fertdb(i)%manure_idx = j
        exit
      endif
    enddo
  endif
enddo
```

### 3. Improved Constituent Application

The new constituent application logic provides:

#### Performance Optimization:
- Pre-computed database indices eliminate runtime string matching
- Direct array access for constituent concentrations
- Optimized loop structures for mass balance updates

#### Enhanced Flexibility:
- Support for multiple constituent types per fertilizer
- Configurable application methods (surface vs. incorporated)
- Dynamic linking between fertilizer and constituent databases

## Areas for Improvement

### 1. System Architecture

#### Current Limitations:
- **Hardcoded Constituent Types**: Limited to SEO4, SEO3, and Boron
- **Static Database Structure**: Difficult to add new constituent categories
- **Memory Management**: Potential inefficiencies with large constituent datasets

#### Recommended Improvements:
1. **Dynamic Constituent Framework**:
   ```fortran
   type dynamic_constituent
     character(len=16) :: name
     character(len=16) :: category  ! pest/path/salt/metal/user
     integer :: database_id
     real :: molecular_weight
     character(len=16) :: units
   end type dynamic_constituent
   ```

2. **Modular Reaction System**:
   - Plugin-based reaction modules
   - User-defined kinetic parameters
   - Temperature and pH dependencies

3. **Enhanced Memory Management**:
   - Sparse matrix storage for large constituent sets
   - Dynamic allocation based on simulation requirements
   - Memory pooling for performance optimization

### 2. Data Management

#### Current Issues:
- **File Format Constraints**: Limited flexibility in input file formats
- **Database Synchronization**: Manual maintenance of constituent linkages
- **Version Control**: Difficulty tracking database versions

#### Suggested Enhancements:
1. **Database Schema Versioning**:
   ```fortran
   type database_version
     integer :: major_version
     integer :: minor_version
     character(len=32) :: build_date
     character(len=256) :: description
   end type database_version
   ```

2. **Flexible Input Formats**:
   - JSON/XML support for complex data structures
   - CSV import/export capabilities
   - Database connectivity options

3. **Automatic Validation**:
   - Mass balance checks during input
   - Unit consistency verification
   - Range checking for physical parameters

### 3. Process Representation

#### Current Gaps:
- **Limited Reaction Networks**: Only simple first-order kinetics
- **Missing Processes**: Volatilization, biodegradation, photolysis
- **Temperature Effects**: Limited temperature dependencies

#### Enhancement Opportunities:
1. **Advanced Kinetics**:
   ```fortran
   type reaction_kinetics
     character(len=16) :: reaction_type  ! first_order/michaelis_menten/inhibition
     real :: rate_constant
     real :: half_saturation
     real :: inhibition_constant
     real :: temperature_coefficient
     real :: ph_optimum
   end type reaction_kinetics
   ```

2. **Process Coupling**:
   - Nutrient-constituent interactions
   - Multi-phase partitioning
   - Biological transformation pathways

3. **Environmental Dependencies**:
   - Temperature correction factors
   - pH effects on speciation
   - Redox potential influences

### 4. Output and Analysis

#### Current Limitations:
- **Limited Output Options**: Basic CSV format only
- **Aggregation Constraints**: Fixed temporal and spatial scales
- **Analysis Tools**: No built-in statistical analysis

#### Proposed Improvements:
1. **Enhanced Output Formats**:
   - NetCDF for large datasets
   - GIS-compatible formats
   - Real-time monitoring support

2. **Flexible Aggregation**:
   ```fortran
   type output_aggregation
     character(len=16) :: temporal_scale  ! daily/monthly/annual/event
     character(len=16) :: spatial_scale   ! hru/subbasin/watershed
     logical :: mass_weighted_average
     logical :: flow_weighted_average
   end type output_aggregation
   ```

3. **Built-in Analysis**:
   - Statistical summaries
   - Trend analysis
   - Mass balance verification
   - Uncertainty quantification

## Conclusion

The SWAT+ constituent system represents a sophisticated and evolving framework for tracking chemical and biological constituents in watershed systems. The recent enhancements, particularly the fertilizer extension system and manure-focused architecture, provide significant improvements in functionality and performance.

Key strengths of the current implementation include:
- Comprehensive mass balance tracking
- Flexible fertilizer-constituent linking
- Integration with organic matter cycling
- Spatially explicit manure allocation

Areas for continued development focus on:
- Dynamic constituent framework expansion
- Enhanced process representation
- Improved data management capabilities
- Advanced output and analysis options

The system's modular design provides a solid foundation for future enhancements while maintaining compatibility with existing SWAT+ workflows and datasets.

---

*Document Version: 1.0*  
*Last Updated: August 2024*  
*Authors: SWAT+ Development Team*  
*Contact: [SWAT Development Group](https://swat.tamu.edu)*