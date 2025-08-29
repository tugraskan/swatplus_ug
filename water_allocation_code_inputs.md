# SWAT+ Water Allocation System: Code Structure and Input Files

## Overview

The SWAT+ water allocation system is implemented through a comprehensive set of Fortran modules and input files that enable sophisticated water resource management modeling. This document provides a technical overview of the code structure and input file formats.

## Core Code Modules

### Main Control Modules

- **`water_allocation_module.f90`** - Defines data structures for water sources, demand objects, and allocation tracking
- **`wallo_control.f90`** - Main control subroutine that orchestrates the water allocation process
- **`water_allocation_read.f90`** - Reads and parses all water allocation input files
- **`water_allocation_output.f90`** - Handles output generation for allocation results

### Process Modules

- **`wallo_demand.f90`** - Calculates water demand for different object types (HRUs, municipal, industrial)
- **`wallo_withdraw.f90`** - Manages water withdrawal from sources (channels, reservoirs, aquifers, unlimited sources)
- **`wallo_treatment.f90`** - Processes water treatment and water use operations
- **`wallo_transfer.f90`** - Handles water transfers between objects through conveyance systems

### Object-Specific Allocation Modules

- **`hru_allo.f90`** - HRU-specific water allocation for irrigation systems
- **`channel_allo.f90`** - Channel-based water allocation and routing
- **`res_allo.f90`** - Reservoir water allocation and release management

### Supporting Modules

- **`header_water_allocation.f90`** - Generates output file headers for daily, monthly, yearly, and average annual reports
- **`allocate_parms.f90`** - Parameter allocation and initialization

## Input File Structure

### Primary Configuration Files

#### `water_allocation.wro` - Water Allocation Objects
- **Purpose**: Main configuration file defining water sources and demand objects
- **Key Sections**:
  - Water source objects with availability constraints (minimum flows, reservoir levels, aquifer depths)
  - Demand objects with withdrawal patterns and water rights (senior/junior)
  - Source-demand connections with conveyance specifications

#### `water_use.wal` - Water Use Definitions
- **Purpose**: Defines water use characteristics and treatment parameters
- **Contains**: Storage capacity, lag times, loss fractions, and constituent concentrations for different use types

#### `water_treat.wal` - Water Treatment Specifications
- **Purpose**: Specifies water treatment plant parameters and effluent characteristics
- **Contains**: Treatment capacity, lag times, loss fractions, and treatment efficiency parameters

#### `water_pipe.wal` - Conveyance System (Pipes)
- **Purpose**: Defines pipe network characteristics for water transport
- **Contains**: Flow capacity, lag times, loss fractions, and aquifer connection parameters

#### `water_tower.wal` - Storage Infrastructure
- **Purpose**: Specifies water storage tower/tank parameters
- **Contains**: Storage capacity, operational characteristics, and aquifer connections

## Key Data Structures

### Water Source Objects
```fortran
type water_source_objects
  integer :: num                          ! Source object number
  character(len=3) :: ob_typ             ! Object type (cha/res/aqu/unl)
  integer :: ob_num                      ! Object number
  character(len=6) :: avail_typ          ! Availability method (dtbl/rec/mon)
  real, dimension(12) :: limit_mon       ! Monthly limits/constraints
end type
```

### Demand Source Objects
```fortran
type demand_source_objects
  character(len=25) :: dtbl              ! Decision table name
  character(len=10) :: src_typ           ! Source type
  character(len=10) :: conv_typ          ! Conveyance type (pipe/pump)
  real :: frac                           ! Fraction of demand from source
  character(len=1) :: comp               ! Compensation flag (y/n)
end type
```

## Allocation Logic

### Demand Calculation Methods
1. **Average Daily**: Fixed daily demand amounts
2. **Recall Files**: Time-varying demands from historical data
3. **Irrigation Demand**: Dynamic calculation based on soil water and crop needs

### Source Availability Methods
1. **Decision Tables**: Rule-based availability using conditional logic
2. **Monthly Limits**: Seasonal constraints on source availability
3. **Recall Files**: Historical availability patterns

### Water Rights System
- **Senior Rights**: Priority access to water sources
- **Junior Rights**: Secondary access when senior demands are met
- **Compensation**: Automatic sourcing from alternative supplies when primary sources are limiting

## Output Files

The system generates comprehensive tracking outputs:
- **Daily/Monthly/Yearly/Average Annual**: `water_allo_*.txt/csv`
- **Demand Tracking**: Total demand, withdrawals, and unmet requirements
- **Source Performance**: Availability and utilization by source type
- **System Efficiency**: Overall allocation performance metrics

## Integration Points

The water allocation system integrates with:
- **HRU Module**: For irrigation demand calculation and application
- **Channel Module**: For streamflow diversions and minimum flow maintenance
- **Reservoir Module**: For storage-based allocation and releases
- **Aquifer Module**: For groundwater extraction and sustainable yield management
- **Constituent Modules**: For water quality tracking through allocation processes

This modular design enables flexible configuration of complex multi-source, multi-demand water management scenarios while maintaining computational efficiency and robust water balance tracking.