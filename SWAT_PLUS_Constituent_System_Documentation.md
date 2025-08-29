# SWAT+ Constituent System Architecture and New Logic Documentation

## Overview

The SWAT+ model has implemented an advanced constituent system that tracks the fate and transport of environmental constituents (currently selenium species and boron) through the watershed system. This document describes the current constituent system architecture, fertilizer-constituent linking mechanisms, manure organic matter allocation, and identifies areas for improvement.

## Current Constituent System Architecture

### Core Components

The constituent system is built around several key modules and data structures:

#### 1. **Constituent Mass Module (`constituent_mass_module.f90`)**
- **Purpose**: Defines fundamental data structures for tracking constituent mass across all watershed compartments
- **Key Types**:
  - `constituent_mass`: Core type containing arrays for pesticides, pathogens, heavy metals, salts, and constituents
  - `soil_constituent_mass`: Manages constituent mass by soil layer
  - `plant_constituent_mass`: Tracks constituents in plants (internal, on-surface, uptake)
  - `all_constituent_hydrograph`: Handles constituent routing through the watershed

#### 2. **Constituent System Module (`cs_module.f90`)**
- **Purpose**: Manages constituent balance calculations and tracking
- **Current Constituents**: 
  - SEO4 (Selenium dioxide)
  - SEO3 (Selenium trioxide) 
  - Boron
- **Key Features**:
  - Comprehensive mass balance tracking (soil, runoff, leaching, uptake, etc.)
  - `cs_balance` type with 29 different flux components
  - Daily, monthly, yearly, and average annual output capabilities

#### 3. **Constituent Database Structure**
```fortran
type constituents
  integer :: num_tot = 0                    ! Total number of constituents
  integer :: num_cs = 0                     ! Number of general constituents  
  character(len=16), allocatable :: cs(:)   ! Constituent names
  integer, allocatable :: cs_num(:)         ! Database indices
end type
```

### Compartmental Organization

The system tracks constituents across multiple compartments:

1. **Soil System**: Multi-layer tracking with dissolved and sorbed phases
2. **Plant System**: Internal, surface, and uptake pools
3. **Aquifer System**: Groundwater constituent storage and transport
4. **Surface Water**: Channel and reservoir constituent pools
5. **Irrigation Water**: External constituent inputs

## Fertilizer-Constituent Linking System

### Database Structure

#### 1. **Fertilizer Constituent Database (`fert_db_cs`)**
```fortran
type fert_db_cs
  character(len=16) :: fertnm = " "         ! Fertilizer name
  real :: seo4 = 0.                         ! SEO4 loading (kg/ha)
  real :: seo3 = 0.                         ! SEO3 loading (kg/ha) 
  real :: boron = 0.                        ! Boron loading (kg/ha)
end type
```

#### 2. **Reading Mechanism (`cs_fert_read.f90`)**
- Reads from `fertilizer.frt_cs` file
- Links fertilizer types to constituent loading rates
- Sets `fert_cs_flag = 1` when constituent data is available

#### 3. **Application Logic (`cs_fert.f90`)**
```fortran
! Application splits between surface and subsurface layers
do l=1,2
  if (l == 1) then
    xx = chemapp_db(fertop)%surf_frac        ! Surface fraction
  else
    xx = 1. - chemapp_db(fertop)%surf_frac   ! Subsurface fraction
  endif
  
  ! Add constituent mass to soil layer
  cs_soil(jj)%ly(l)%cs(ics) = cs_soil(jj)%ly(l)%cs(ics) + 
                              (xx * frt_kg * fert_cs(ifrt)%constituent_loading)
enddo
```

### Integration with Main Fertilizer System

The constituent system operates parallel to the main nutrient fertilizer system but uses:
- Same fertilizer IDs (`ifrt`) from `fertilizer_data_module`
- Same application methods (`fertop`) and surface fraction parameters
- Same timing and application rates (`frt_kg`)

## Extended Fertilizer Database Format

### Current Structure (`fertilizer_data_module.f90`)

```fortran
type fertilizer_db
  character(len=16) :: fertnm = " "         ! Fertilizer name
  real :: fminn = 0.                        ! Mineral N fraction
  real :: fminp = 0.                        ! Mineral P fraction  
  real :: forgn = 0.                        ! Organic N fraction
  real :: forgp = 0.                        ! Organic P fraction
  real :: fnh3n = 0.                        ! NH3-N fraction of mineral N
end type
```

### Fertilizer Categories in Database

#### 1. **Synthetic Fertilizers**
- Numeric codes (e.g., `46_00_00`, `18_46_00`, `urea`)
- High mineral N/P content, zero organic fractions
- Low or zero NH3-N fractions
- `pathogens = "null"`

#### 2. **Fresh Manures**
- Animal-specific codes (e.g., `dairy_fr`, `beef_fr`, `swine_fr`)
- Balanced mineral and organic N/P content
- High NH3-N fractions (typically 0.99)
- `pathogens = "fresh_manure"`

#### 3. **Specialized Formulations**
- CEAP manure formulations for pasture and hay applications
- Separate N and P formulations
- `pathogens = "ceap_manure"`

### Manure Data Structure
```fortran
type manure_data
  character(len=16) :: fertnm = " "
  ! Additional manure-specific properties (currently minimal)
end type
```

## Constituent Loading into Manures

### Current Implementation Gaps

The current system has **incomplete integration** between constituent loading and manure organic matter allocation. Key issues:

1. **Separate Application Pathways**: 
   - Nutrient/organic matter: `pl_fert.f90` and `pl_manure.f90`
   - Constituents: `cs_fert.f90`

2. **No Organic Matter Binding**: Constituents are applied as simple additions without considering:
   - Binding to organic carbon fractions
   - Allocation to metabolic vs. structural litter pools
   - Release patterns tied to organic matter decomposition

### Carbon Cycling Integration (`pl_manure.f90`)

The manure application logic includes sophisticated carbon cycling for SWAT-C model:

```fortran
! Carbon allocation calculation
orgc_f = 0.42                                    ! Organic C fraction
RLN = .175 * orgc_f / (fminn + forgn + 1.e-5)  ! Lignin ratio
X10 = .85 - .018 * RLN                          ! Metabolic fraction

! Allocation to SOM pools
! Metabolic litter pool
XXX = X8 * X10                                   ! Metabolic C
soil1(j)%meta(l)%c = soil1(j)%meta(l)%c + XXX

! Structural litter pool  
XZ = X1 * orgc_f - XXX                          ! Structural C
soil1(j)%str(l)%c = soil1(j)%str(l)%c + XZ

! Lignin pool (17.5% of structural C)
soil1(j)%lig(l)%c = soil1(j)%lig(l)%c + XZ * .175
```

This allocation system could serve as a template for constituent binding to organic matter fractions.

## Manure Allocation System

### Architecture (`manure_allocation_module.f90`)

The system provides comprehensive manure management through:

#### 1. **Source Objects**
```fortran
type manure_source_objects
  integer :: num = 0                           ! Source ID
  character(len=3) :: mois_typ = ""           ! Wet/dry status
  character(len=25) :: manure_typ = ""        ! Links to fertilizer.frt
  real :: stor_init = 0.                      ! Initial storage (tons)
  real :: stor_max = 0.                       ! Maximum storage (tons)
  real, dimension(12) :: prod_mon = 0.        ! Monthly production (tons/month)
  integer :: fertdb = 0                       ! Fertilizer database index
end type
```

#### 2. **Demand Objects**
```fortran
type manure_demand_objects
  integer :: num = 0                           ! Demand ID
  character(len=10) :: ob_typ = ""            ! Object type (hru, muni, divert)
  integer :: ob_num = 0                       ! Object number
  character(len=25) :: dtbl = ""              ! Decision table name
  character(len=2) :: right = ""              ! Priority rights (sr/jr)
end type
```

#### 3. **Allocation Logic**
- Links to main fertilizer database through `fertdb` field
- Supports multiple allocation rules
- Tracks storage, production, and withdrawal
- Provides detailed mass balance reporting

### Integration Potential

The manure allocation system provides infrastructure for:
- Spatially distributed constituent sources
- Time-variable constituent loading rates
- Priority-based allocation of constituent-rich manures
- Detailed tracking of constituent sources and destinations

## Issues, Suggestions, and TODO Items

### Critical Issues

#### 1. **Incomplete System Integration**
**Issue**: Constituent application (`cs_fert.f90`) operates independently from organic matter allocation (`pl_fert.f90`, `pl_manure.f90`)

**Impact**: 
- Constituents applied as simple additions without considering organic matter binding
- No linkage between constituent release and organic matter decomposition
- Inconsistent treatment of synthetic vs. organic fertilizer constituents

**Suggestion**: Integrate constituent application into the main fertilizer application routines

#### 2. **Missing Organic Matter Binding**
**Issue**: No mechanism for binding constituents to organic carbon fractions

**Impact**:
- Unrealistic immediate availability of all applied constituents
- No consideration of slow-release from organic matter decomposition
- Limited ability to model long-term constituent behavior

**Suggestion**: Implement constituent binding to:
- Metabolic litter pool (rapid release)
- Structural litter pool (moderate release)
- Lignin pool (slow release)
- Humus pools (very slow release)

#### 3. **Limited Constituent Database**
**Issue**: Only 3 constituents currently supported (SEO4, SEO3, Boron)

**Impact**: 
- Cannot model other important constituents (heavy metals, trace elements)
- Hardcoded constituent handling limits extensibility

**Suggestion**: Implement dynamic constituent database system

### Enhancement Opportunities

#### 1. **Enhanced Fertilizer-Constituent Database Format**

**Current Limitation**: Separate `fertilizer.frt_cs` file creates maintenance burden

**Proposed Solution**: Extend main `fertilizer.frt` format:
```
name        min_n    min_p    org_n    org_p    nh3_n    pathogens    seo4    seo3    boron    description
dairy_fr    0.007    0.005    0.031    0.003    0.99     null         0.12    0.03    0.05     Dairy_FreshManure
```

#### 2. **Constituent-Organic Matter Coupling**

**Implementation Strategy**:
```fortran
! Extend constituent application to match organic matter allocation
do l = 1, 2
  ! Calculate organic matter fractions (existing logic)
  meta_fr = .85 - .018 * c_n_rto
  
  ! Allocate constituents proportionally
  ! Fast-release fraction (dissolved)
  cs_soil(j)%ly(l)%cs(ics) += fr_ly * cs_loading * (1.0 - org_binding_frac)
  
  ! Slow-release fraction (bound to organic matter)
  ! Metabolic pool binding
  cs_meta_bound(j,l,ics) += fr_ly * cs_loading * org_binding_frac * meta_fr
  
  ! Structural pool binding  
  cs_struct_bound(j,l,ics) += fr_ly * cs_loading * org_binding_frac * (1.0 - meta_fr)
end do
```

#### 3. **Dynamic Constituent Release Model**

**Concept**: Link constituent release to organic matter decomposition rates
```fortran
! Daily constituent release from decomposing organic matter
cs_release_rate = decomp_rate * cs_bound_concentration
cs_soil(j)%ly(l)%cs(ics) += cs_release_rate
cs_bound(j,l,ics) -= cs_release_rate
```

### TODO List

#### High Priority
1. **Integrate constituent application with main fertilizer routines**
   - Modify `pl_fert.f90` to handle constituent application
   - Merge `cs_fert.f90` functionality into main application logic
   - Ensure consistent treatment of application fractions and timing

2. **Implement constituent-organic matter binding**
   - Add constituent binding fractions to fertilizer database
   - Create constituent pools bound to different organic matter fractions
   - Link constituent release to organic matter decomposition rates

3. **Extend fertilizer database format**
   - Add constituent columns to main `fertilizer.frt` file
   - Eliminate need for separate `fertilizer.frt_cs` file
   - Update reading routines to handle extended format

#### Medium Priority
4. **Enhance constituent database flexibility**
   - Replace hardcoded constituent handling with dynamic system
   - Allow user-defined constituent sets
   - Implement constituent-specific parameters (sorption, decay, etc.)

5. **Improve manure allocation integration**
   - Link manure allocation system to constituent loading
   - Implement spatial optimization of constituent-rich manure placement
   - Add constituent tracking to manure storage and transport

6. **Add constituent transformation processes**
   - Implement constituent speciation changes (e.g., SEO4 ↔ SEO3)
   - Add pH-dependent transformation rates
   - Include microbial mediated transformations

#### Low Priority
7. **Enhanced reporting and visualization**
   - Add constituent mass balance reporting
   - Implement constituent concentration mapping
   - Create constituent fate tracking reports

8. **Validation and calibration tools**
   - Develop constituent parameter sensitivity analysis
   - Create constituent calibration datasets
   - Implement uncertainty quantification for constituent predictions

## Conclusion

The SWAT+ constituent system provides a solid foundation for tracking environmental constituents through watershed systems. However, significant enhancements are needed to fully integrate constituent fate with organic matter dynamics and create a more realistic representation of constituent behavior in agricultural systems. The proposed improvements would create a more robust, flexible, and scientifically sound constituent modeling capability.