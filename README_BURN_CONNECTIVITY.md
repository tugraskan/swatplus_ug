# SWAT+ HRU Burn Connectivity Analysis

## Overview

This repository now includes comprehensive documentation and tools for understanding how burn operations in one Hydrologic Response Unit (HRU) can affect water yield downstream in other HRUs within the SWAT+ hydrological model.

## Documentation Files

### 1. [HRU_BURN_CONNECTIVITY_GUIDE.md](HRU_BURN_CONNECTIVITY_GUIDE.md)
**Main comprehensive guide** explaining:
- HRU connectivity framework and spatial organization
- How burn operations affect hydrologic processes
- Detailed flow routing mechanisms (surface, lateral, aquifer)
- Key code locations and implementation details
- Step-by-step example of burn effect propagation

### 2. [EXAMPLE_BURN_TRACING.md](EXAMPLE_BURN_TRACING.md)
**Practical example** showing:
- How to examine real SWAT+ model files
- Step-by-step analysis of connectivity using example datasets
- Code snippets showing actual flow routing
- Output file interpretation for monitoring burn effects

### 3. [QUICK_REFERENCE_CONNECTIVITY_FILES.md](QUICK_REFERENCE_CONNECTIVITY_FILES.md)
**Quick reference** providing:
- Table of all important connectivity files
- File format examples
- Key variables and concepts
- Summary of tracing steps

## Analysis Tool

### [analyze_connectivity.py](analyze_connectivity.py)
Python script that automatically analyzes SWAT+ configuration files to:
- Parse HRU connections and routing units
- Identify downstream flow paths
- Simulate burn impact analysis
- Generate connectivity summary reports

**Usage:**
```bash
# Analyze current directory
python analyze_connectivity.py

# Analyze specific SWAT+ project
python analyze_connectivity.py data/Osu_1hru

# Get help
python analyze_connectivity.py --help
```

## How Burns Affect Downstream Water Yield

### The Process

1. **Burn Operation** (`pl_burnop.f90`)
   - Increases curve number (CN2) → reduced infiltration
   - Removes vegetation → less interception and transpiration
   - Burns surface litter → reduced surface protection

2. **Increased Surface Runoff**
   - Higher CN2 generates more runoff from same rainfall
   - Less infiltration means less groundwater recharge

3. **Flow Routing** (`hru_control.f90`, `ru_control.f90`)
   - Increased runoff routed through connectivity network
   - Routing units aggregate flows from multiple HRUs
   - Flows distributed to downstream channels, aquifers, and HRUs

4. **Downstream Effects**
   - Receiving HRUs get increased surface inflow
   - Additional water contributes to their effective precipitation
   - Can trigger increased runoff generation downstream
   - Effects cascade through entire watershed network

## Key Files to Check

### Input/Configuration Files
- `object.cnt` - Model structure overview
- `hru.con` - HRU properties and basic connections
- `rout_unit.con` - Routing unit outlet connections
- `rout_unit.def` - HRU groupings within routing units
- `ls_unit.ele` - Landscape element definitions

### Source Code Files
- `src/hyd_connect.f90` - Main connectivity setup
- `src/hru_control.f90` - HRU simulation and flow routing
- `src/ru_control.f90` - Routing unit flow aggregation
- `src/pl_burnop.f90` - Burn operation implementation
- `src/rls_routesurf.f90` - Surface flow routing between HRUs

### Output Files for Monitoring
- `hru_wb_aa.txt` - HRU water balance (watch SURQ, WYLD changes)
- `ru_aa.txt` - Routing unit aggregated flows
- `hydout_aa.txt` - Outlet hydrographs
- `basin_wb_aa.txt` - Basin-wide water balance

## Example Analysis

Using the provided tool on the Osu_1hru test dataset:

```bash
python analyze_connectivity.py data/Osu_1hru
```

Results show:
- 1 HRU feeding into 1 routing unit
- Routing unit connects to both a channel (for surface flow) and aquifer (for groundwater)
- Any burn in the HRU would affect both surface water and groundwater systems

## Getting Started

1. **Understand your model structure:**
   ```bash
   cat object.cnt  # See counts of each object type
   ```

2. **Check HRU connections:**
   ```bash
   cat rout_unit.def  # See HRU groupings
   cat rout_unit.con  # See routing outlets
   ```

3. **Run connectivity analysis:**
   ```bash
   python analyze_connectivity.py .
   ```

4. **Read the guides:**
   - Start with `HRU_BURN_CONNECTIVITY_GUIDE.md` for concepts
   - Use `EXAMPLE_BURN_TRACING.md` for hands-on analysis
   - Reference `QUICK_REFERENCE_CONNECTIVITY_FILES.md` as needed

## Implementation Details

The SWAT+ model uses a hierarchical approach:
- **HRUs** generate water, sediment, and nutrient fluxes
- **Routing Units** collect and aggregate fluxes from multiple HRUs
- **Channels and Aquifers** transport fluxes downstream
- **Connectivity files** define the network topology

Burns increase curve numbers, which increases surface runoff generation. This additional runoff is routed through the network using the connectivity defined in the `.con` and `.def` files, potentially affecting water yield in all downstream units.

The documentation and tools provided here give you everything needed to understand, trace, and analyze these connectivity relationships in your SWAT+ models.