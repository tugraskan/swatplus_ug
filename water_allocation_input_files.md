# SWAT+ Water Allocation Input Files Documentation

## Overview

The SWAT+ water allocation system utilizes several specialized input files to configure and manage complex water transfer and treatment operations. These files define water sources, demands, infrastructure components, and allocation rules that govern how water moves through the system. This document provides comprehensive documentation of the input file formats and their purposes.

## Main Input Files

### 1. Water Allocation Object File (`.wro`)
**File:** `water_allocation.wro` (or custom name specified in `file.cio`)

This is the primary configuration file that defines water allocation objects and their relationships. It contains:

- **Header information** specifying the number of water allocation objects
- **Source objects** (reservoirs, aquifers, channels, outside sources)
- **Transfer objects** (demand and routing definitions)
- **Infrastructure counts** (treatment plants, storage facilities, pipes, pumps)
- **Allocation rules** and priorities

**Key sections:**
- Source object definitions with monthly limits
- Transfer/demand object specifications with source-receiver relationships
- Water rights and priority assignments
- Decision table linkages for dynamic allocation

### 2. Infrastructure Component Files (`.wal`)

#### **Water Pipe File** - `water_pipe.wal`
Defines pipe network for water conveyance with specifications including:
- **Flow capacity** (maximum cms)
- **Lag time** (transport delay in days)
- **Loss fraction** (conveyance losses)
- **Aquifer interactions** (seepage losses to specific aquifers)

#### **Water Treatment File** - `water_treat.wal`
Specifies water treatment plant parameters:
- **Storage capacity** (maximum m³)
- **Treatment time** (lag days for processing)
- **Water loss** during treatment
- **Removal efficiencies** for various constituents:
  - Organic matter and nutrients
  - Pesticides (concentrations in ppm)
  - Pathogens (cfu per ml)
  - Salts and other constituents

#### **Water Use File** - `water_use.wal`
Defines municipal, industrial, and commercial water use facilities with:
- Usage patterns and demands
- Return flow characteristics
- Water quality impacts

#### **Water Tower/Storage File** - `water_tower.wal`
Configures urban water storage systems:
- Storage capacity and operational levels
- Distribution rules and priorities
- Connection to pipe network

### 3. Supporting Input Files

#### **Organic Matter Treatment** - `om_treat.wal`
Specifies organic matter removal efficiencies and treatment processes for different facility types.

#### **Organic Matter Use** - `om_use.wal` 
Defines organic matter impacts from various water use activities.

## File Format Details

### Water Allocation Object Structure
The `.wro` file follows this general structure:

```
Title Line
Number_of_Objects
Object Definition: name rule_type src_count trn_count out_src out_rcv wtp uses stor pipe canal pump channel_flag
Source Objects: type number limits monthly_limits(12)
Transfer Objects: number type name amount priority source_count dtbl_name source_definitions receiver_definition
```

### Infrastructure File Patterns
Most `.wal` files follow a consistent format:
```
Description Header
Number_of_Objects
Column Headers
Object_ID  Name  Parameter1  Parameter2  ...  ParameterN  Description
```

## Water Allocation Components

### **Source Types**
- **`res`** - Reservoirs with level-based limits
- **`aqu`** - Aquifers with depth constraints  
- **`cha`** - Channels with minimum flow requirements
- **`osrc`** - Outside sources (external supplies)

### **Transfer Types**
- **`outflo`** - Direct outflow transfer
- **`ave_day`** - Average daily demand (m³/day)
- **`dtbl_irr`** - Decision table-based irrigation
- **`dtbl_con`** - Decision table-based conditional transfer

### **Infrastructure Components**
- **Pipes** - Conveyance with losses and lag time
- **Pumps** - Active water movement with energy costs
- **Treatment Plants** - Quality improvement facilities
- **Storage Towers** - Urban water storage and distribution
- **Canals** - Open channel conveyance systems

### **Receiving Objects**
- **`hru`** - Hydrologic Response Units (irrigation)
- **`res`** - Reservoirs (storage augmentation)
- **`cha`** - Channels (return flows)
- **`wtp`** - Water treatment plants
- **`use`** - Municipal/industrial use facilities
- **`stor`** - Storage facilities

## Key Features

### **Water Rights and Priorities**
- **`sr`** - Senior rights (higher priority)
- **`jr`** - Junior rights (lower priority)
- Numerical priority systems for complex allocation rules

### **Decision Table Integration** 
- Dynamic allocation based on system conditions
- Links to existing SWAT+ decision table framework
- Conditional triggers for demand and supply management

### **Quality Tracking**
- Constituent transport through infrastructure
- Treatment efficiency specifications
- Water quality impacts from various uses

### **Loss Accounting**
- Conveyance losses in pipes and canals
- Treatment plant process losses
- Seepage to aquifers during transport

## Usage in Simulation

These input files are read during model initialization by the `water_allocation_read()` subroutine, which:

1. **Parses the main `.wro` file** to establish allocation objects and relationships
2. **Reads infrastructure files** (`.wal` files) to configure system components
3. **Cross-references with decision tables** for dynamic allocation rules
4. **Allocates memory structures** for tracking water movements and quality
5. **Validates configurations** and reports any inconsistencies

The parsed information is then used throughout the simulation by the water allocation control system to manage water transfers, apply treatment processes, and track system performance according to the specified rules and constraints.