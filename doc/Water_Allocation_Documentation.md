# SWAT+ Water Allocation System Documentation

## Overview

The SWAT+ Water Allocation System provides a comprehensive framework for simulating water transfers and allocations within a watershed. This system allows for sophisticated water management scenarios including irrigation demands, municipal water supply, industrial uses, and inter-basin water transfers.

## System Architecture

### Core Components

The water allocation system consists of eight main Fortran source files and associated modules:

1. **`water_allocation_module.f90`** - Data structures and type definitions
2. **`water_allocation_read.f90`** - Input file reading and initialization
3. **`wallo_control.f90`** - Main control subroutine (orchestrates the allocation process)
4. **`wallo_demand.f90`** - Demand calculation and assessment
5. **`wallo_withdraw.f90`** - Water withdrawal from various sources
6. **`wallo_treatment.f90`** - Water treatment processes
7. **`wallo_transfer.f90`** - Water transfer between objects
8. **`water_allocation_output.f90`** - Output file generation and reporting

### Integration Points

The water allocation system is integrated into the main SWAT+ simulation loop through:
- **`time_control.f90`** - Daily time step management
- **`command.f90`** - Object processing sequence
- **`sd_channel_control.f90`** - Stream/drainage channel processing

## Water Allocation Types and Data Structures

### Primary Data Types

#### `water_source_objects`
Defines water source characteristics:
```fortran
type water_source_objects
  integer :: num = 0                      ! demand object number
  character (len=3) :: ob_typ = ""        ! channel(cha), reservoir(res), aquifer(aqu), unlimited source(unl)
  integer :: ob_num = 0                   ! number of the object type
  real, dimension (12) :: limit_mon = 0.  ! min chan flow(m3/s), min res level(frac principal), max aqu depth(m)
  character (len=25) :: div_rec = ""
  integer :: rec_num = 0
  real :: div_vol = 0.
end type water_source_objects
```

#### `water_demand_objects`
Defines water demand characteristics:
```fortran
type water_demand_objects
  integer :: num = 0                      ! demand object number
  character (len=3) :: ob_typ = ""        ! hru, res, aqu, etc.
  integer :: ob_num = 0                   ! object number
  character (len=25) :: name = ""         ! name
  character (len=25) :: treat_typ = ""    ! treatment type
  character (len=25) :: treatment = ""    ! pointer to recall or dr file
  character (len=10) :: rcv_ob = ""       ! receiving object (channel, reservoir, aquifer)
  integer :: rcv_num = 0                  ! receiving object number
  character (len=10) :: rcv_dtl = ""      ! receiving object decision table
  integer :: rec_num = 0                  ! recall number for muni or divert demands
  integer :: trt_num = 0                  ! treatment database number
  integer :: dmd_src_obs = 0              ! number of source objects available
  real :: unmet_m3 = 0.                   ! unmet demand for the object (m3)
  real :: withdr_tot = 0.                 ! total withdrawal from all sources (m3)
  real :: irr_eff = 0.                    ! irrigation in-field efficiency
  real :: surq = 0.                       ! surface runoff ratio
  type (hyd_output) :: hd                 ! hydrograph data
  type (hyd_output) :: trt                ! treated water hydrograph
end type water_demand_objects
```

#### `water_allocation`
Main allocation object structure:
```fortran
type water_allocation
  character (len=25) :: name = ""         ! name of the water allocation object
  character (len=25) :: rule_typ = ""     ! rule type to allocate water
  integer :: src_obs = 0                  ! number of source objects
  integer :: dmd_obs = 0                  ! number of demand objects
  character (len=1) :: cha_ob = ""        ! y-yes there is channel object; n-no channel object
  integer :: cha = 0                      ! channel number
  type (source_output) :: tot             ! total demand, withdrawal and unmet
  type (water_source_objects), dimension(:), allocatable :: src    ! source objects
  type (water_demand_objects), dimension(:), allocatable :: dmd    ! demand objects
end type water_allocation
```

## Subroutine Details

### 1. `wallo_control(iwallo)`

**Purpose**: Main control subroutine that orchestrates the entire water allocation process for a given allocation object.

**Input Parameters**:
- `iwallo` (integer, inout): Water allocation object number

**Key Variables**:
- `itrn`: Water transfer/demand object number (note: different versions may use `idmd`)
- `isrc`: Source object number
- `j`: HRU number
- `irr_mm`: Irrigation applied (mm)
- `div_total`: Cumulative available diversion water (m3)

**Process Flow**:
1. Initialize totals for entire allocation object
2. Loop through each demand object (`itrn`)
3. Compute flow from outside sources
4. Calculate demand for each object via `wallo_demand()`
5. If demand exists, withdraw water via `wallo_withdraw()`
6. Check for compensation from other sources if allowed
7. Transfer water to receiving object via `wallo_transfer()`
8. Apply water based on receiving object type (HRU irrigation, reservoir, aquifer, etc.)
9. Sum demand, withdrawal, and unmet amounts

**Modules Used**:
- `water_allocation_module`
- `hydrograph_module`
- `hru_module`
- `basin_module`
- `time_module`
- `plant_module`
- `soil_module` 
- `organic_mineral_mass_module`
- `constituent_mass_module`

### 2. `wallo_demand(iwallo, itrn, isrc)`

**Purpose**: Calculates water demand for specific demand objects based on various demand types and decision rules.

**Input Parameters**:
- `iwallo` (integer, in): Water allocation object number
- `itrn` (integer, in): Water demand object number  
- `isrc` (integer, in): Source object number

**Key Variables**:
- `j`: HRU number
- `id`: Flow condition decision table number
- `irec`: Recall database number
- `trans_m3`: Transfer amount (m3)

**Demand Types Supported**:
1. **`outflo`**: Outflow from source object (out-of-basin, water treatment plant, water use)
2. **`ave_day`**: Average daily transfer (m3/s converted to m3/day)
3. **`rec`**: Recall object transfer (daily, monthly, or annual)
4. **`dtbl_con`**: Decision table conditions
5. **`dtbl_lum`**: HRU irrigation based on land use management

**Modules Used**:
- `water_allocation_module`
- `hru_module`
- `hydrograph_module`
- `conditional_module`

### 3. `wallo_withdraw(iwallo, itrn, isrc)`

**Purpose**: Withdraws water from various source types while respecting minimum flow/level constraints.

**Input Parameters**:
- `iwallo` (integer, in): Water allocation object number
- `itrn` (integer, in): Water demand object number
- `isrc` (integer, in): Source object number

**Key Variables**:
- `res_min`: Minimum reservoir volume for withdrawal (m3)
- `cha_min`: Minimum allowable channel flow after withdrawal (m3)
- `cha_div`: Maximum amount that can be diverted (m3)
- `rto`: Ratio of withdrawal to determine hydrograph removal
- `avail`: Water available from aquifer (m3)
- `extracted`: Water extracted from aquifer (gwflow) (m3)

**Source Types Supported**:
1. **`cha`** (Channel): Divert flowing water while maintaining minimum flow
2. **`res`** (Reservoir): Extract water while maintaining minimum pool level
3. **`aqu`** (Aquifer): Pump groundwater with depth constraints (includes gwflow integration)
4. **`unl`** (Unlimited): Unlimited water source

**Modules Used**:
- `water_allocation_module`
- `hydrograph_module`
- `aquifer_module`
- `reservoir_module`
- `time_module`
- `basin_module`

### 4. `wallo_treatment(iwallo, itrt)`

**Purpose**: Processes water through treatment facilities to modify concentrations and flow rates.

**Input Parameters**:
- `iwallo` (integer, in): Water allocation object number
- `itrt` (integer, in): Water treatment plant object number

**Key Variables**:
- `iom`: Number of organic-mineral data concentrations

**Process**:
1. Apply treatment efficiency to withdrawn water flow
2. Convert concentrations to mass for organic-mineral components
3. Process constituents through treatment
4. Generate treated water output

**Modules Used**:
- `water_allocation_module`
- `hydrograph_module`
- `constituent_mass_module`

### 5. `wallo_transfer(iwallo, itrn)`

**Purpose**: Handles conveyance losses during water transfer from sources to receiving objects.

**Input Parameters**:
- `iwallo` (integer, in): Water allocation object number
- `itrn` (integer, in): Water demand object number

**Key Variables**:
- `isrc`: Source object number
- `iconv`: Conveyance object number (pipe or pump)

**Conveyance Types**:
1. **`pipe`**: Apply pipe loss fraction
2. **`pump`**: Apply pump losses (placeholder for future implementation)

**Modules Used**:
- `water_allocation_module`
- `hydrograph_module`
- `constituent_mass_module`
- `sd_channel_module`
- `aquifer_module`
- `reservoir_module`
- `time_module`

### 6. `water_allocation_read()`

**Purpose**: Reads water allocation input files and initializes data structures.

**Input Files Read**:
- Water allocation configuration file
- Treatment files
- Decision table files
- Recall files

**Key Processes**:
1. Read allocation object definitions
2. Read source object specifications
3. Read demand object specifications
4. Cross-reference with irrigation demand decision tables for HRUs
5. Allocate memory for output arrays

**Modules Used**:
- `input_file_module`
- `water_allocation_module`
- `mgt_operations_module`
- `maximum_data_module`
- `hydrograph_module`
- `sd_channel_module`
- `conditional_module`
- `hru_module`

### 7. `water_allocation_output(iwallo)`

**Purpose**: Generates output files for water allocation results.

**Input Parameters**:
- `iwallo` (integer, in): Water allocation object number

**Output Formats**:
1. **Daily**: `water_allo_day.txt`, `water_allo_day.csv`
2. **Monthly**: `water_allo_mon.txt`, `water_allo_mon.csv`
3. **Yearly**: `water_allo_yr.txt`, `water_allo_yr.csv`
4. **Average Annual**: `water_allo_aa.txt`, `water_allo_aa.csv`

**Output Variables**:
- Demand amounts by source (m3)
- Withdrawal amounts by source (m3)
- Unmet demand by source (m3)
- Source object types and numbers
- Receiving object information

**Modules Used**:
- `time_module`
- `hydrograph_module`
- `water_allocation_module`

## Input/Output Specifications

### Input Files

#### Water Allocation File Format
```
allocation_name  rule_type  num_sources  num_demands  channel_object
source_objects...
demand_objects...
```

**Key Input Parameters**:
- **Source objects**: Type (cha/res/aqu/unl), number, monthly limits
- **Demand objects**: Type (hru/res/aqu), number, demand type, treatment, receiving object
- **Allocation rules**: Priority-based, proportional, or conditional
- **Constraints**: Minimum flows, reservoir levels, aquifer depths

### Output Files

#### Daily/Monthly/Yearly/Average Annual Output Format
```
day  mon  day_mo  year  demand_id  demand_type  demand_num  num_sources  
receiving_type  receiving_num  source1_type  source1_num  demand1  withdrawal1  unmet1  
source2_type  source2_num  demand2  withdrawal2  unmet2  ...
```

**Key Output Variables**:
- **Flow values**: All in cubic meters (m3)
- **Demand**: Total water demand for each object
- **Withdrawal**: Actual water withdrawn from each source
- **Unmet**: Unmet demand remaining after withdrawal attempts
- **Source information**: Object type and number for each source
- **Receiving information**: Destination object details

### Integration with Other SWAT+ Components

#### HRU Integration
- Irrigation demand calculation based on crop water stress
- Application of irrigation water with efficiency factors
- Surface runoff from irrigation
- Salt and constituent mass tracking in irrigation water

#### Channel Integration  
- Minimum flow maintenance during diversions
- Hydrograph partitioning for withdrawals
- Return flow routing

#### Reservoir Integration
- Minimum pool level constraints
- Water balance updates
- Mass balance for constituents

#### Aquifer Integration
- Drawdown calculations
- Pumping capacity limits
- Integration with MODFLOW-based gwflow module
- Groundwater-surface water interactions

## Program Flow Summary

```
time_control() [Daily loop]
  ├── Initialize daily conditions
  ├── For each water allocation object:
  │   └── wallo_control(iwallo)
  │       ├── Initialize allocation object totals
  │       ├── For each demand object:
  │       │   ├── wallo_demand() - Calculate demands
  │       │   ├── If demand > 0:
  │       │   │   ├── For each source:
  │       │   │   │   └── wallo_withdraw() - Withdraw available water
  │       │   │   ├── Check compensation sources
  │       │   │   ├── wallo_transfer() - Apply conveyance losses
  │       │   │   └── Apply water to receiving object
  │       │   └── wallo_treatment() - Process through treatment (if applicable)
  │       └── Sum totals for allocation object
  └── water_allocation_output() - Generate output files
```

## Call Hierarchy

1. **Main Program** (`main.f90.in`)
   - Initializes system
   - Calls `water_allocation_read()` during setup
   - Calls `time_control()` for simulation

2. **Time Control** (`time_control.f90`)
   - Daily simulation loop
   - Calls `wallo_control()` for each allocation object

3. **Water Allocation Control** (`wallo_control.f90`)
   - Orchestrates allocation process
   - Calls subsidiary subroutines:
     - `wallo_demand()`
     - `wallo_withdraw()`
     - `wallo_transfer()`
     - `wallo_treatment()`

4. **Output Generation** (`water_allocation_output.f90`)
   - Called from time control loops
   - Generates periodic output files

This comprehensive system provides flexible water management capabilities while maintaining water balance and honoring physical and regulatory constraints throughout the watershed system.