# SWAT+ Water Allocation Types and Objects

## Overview

The SWAT+ water allocation system introduces several new Fortran derived types and objects to manage complex water transfer, treatment, and distribution operations. These data structures provide the framework for configuring and tracking water movements through various infrastructure components and allocation rules.

## Core Data Types

### **`water_allocation`**
The main object containing complete allocation system configuration:
- **Identification**: Name and rule type for the allocation system
- **Component counts**: Numbers of sources, transfers, treatment plants, pipes, pumps, storage facilities
- **Object arrays**: Collections of source objects (`osrc`) and transfer objects (`trn`)
- **Totals tracking**: Aggregated demand, withdrawal, and unmet amounts

### **`water_source_objects`** 
Defines available water sources with constraints:
- **Source types**: Channels (`cha`), reservoirs (`res`), aquifers (`aqu`), unlimited sources (`unl`)
- **Limits**: Monthly constraints, decision table references, or recall file specifications
- **Constraints**: Minimum flow rates, reservoir levels, aquifer depths

### **`water_transfer_objects`**
Specifies water demands and transfer operations:
- **Transfer types**: Direct outflow, average daily amounts, decision table-based allocation
- **Water rights**: Senior (`sr`) or junior (`jr`) priority classifications
- **Source management**: Multiple source objects with compensation rules
- **Receiving objects**: Target destinations for transferred water

### **`transfer_source_objects`**
Individual source components within transfers:
- **Conveyance**: Pipe or pump specifications with efficiency factors
- **Allocation**: Fraction of demand supplied by each source
- **Compensation**: Backup source activation when primary sources are constrained

## Infrastructure Types

### **`water_treatment_use_data`**
Treatment plant and water use facility specifications:
- **Capacity**: Maximum storage and processing rates
- **Processing**: Treatment lag time and water loss fractions
- **Quality**: Removal efficiencies for organic matter, pesticides, pathogens, salts

### **`water_transfer_data`** 
Conveyance infrastructure for pipes, canals, and storage towers:
- **Hydraulics**: Maximum flow capacity and transport lag time
- **Losses**: Conveyance losses and aquifer seepage specifications
- **Routing**: Multiple aquifer interaction with loss distribution

### **`aquifer_loss`**
Seepage loss distribution to groundwater:
- **Target aquifer**: Specific aquifer number receiving losses
- **Loss fraction**: Proportion of conveyance losses directed to each aquifer

## Output and Tracking Types

### **`source_output`**
Performance tracking for individual sources:
- **Demand**: Water requirement for the source (ha-m)
- **Withdrawal**: Actual amount extracted (ha-m) 
- **Unmet**: Unfulfilled demand (ha-m)

### **`water_allocation_output`**
Aggregated system performance at multiple time scales:
- **Daily**: `wallod_out` - Daily performance metrics
- **Monthly**: `wallom_out` - Monthly aggregated results
- **Yearly**: `walloy_out` - Annual summary statistics  
- **Average Annual**: `walloa_out` - Long-term average performance

### **`wallo_header`** and **`wallo_header_units`**
Output file formatting and column specifications for reporting results with appropriate units and descriptions.

## Key Object Arrays

- **`wallo(:)`** - Main allocation objects array (dimensioned by number of allocation systems)
- **`osrc(:)`** - Outside source objects for external water supplies
- **`pipe(:)`, `canal(:)`, `wtow(:)`** - Infrastructure component arrays
- **`wtp(:)`, `wuse(:)`** - Treatment plant and water use facility arrays

These types and objects work together to create a comprehensive framework for modeling complex water allocation scenarios with multiple sources, demands, infrastructure components, and allocation rules while maintaining detailed performance tracking and reporting capabilities.