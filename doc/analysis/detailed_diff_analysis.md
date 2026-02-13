# Detailed Diff Analysis: arnoldjjms/main vs Current Branch

## New .f90 Files in arnoldjjms/main (Not in Current Branch)

These files will need to be added:
1. **src/cbn_surfres_decomp.f90** - Surface residue decomposition subroutine
2. **src/wallo_canal.f90** - Water allocation canal control
3. **src/water_canal_read.f90** - Read canal configuration
4. **src/water_orcv_read.f90** - Read water orcv configuration

## Modified .f90 Files (22 files with conflicts to review)

### High Priority - Core Functionality Changes

#### 1. Carbon/Nutrient Cycling
- **cbn_rsd_decomp.f90** - Fixed NO3/NH4 blowup issue
- **nut_nminrl.f90** - Nutrient mineralization updates
- **organic_mineral_mass_module.f90** - Module structure changes

#### 2. Water Allocation System  
- **wallo_control.f90** - Major updates for canal support
- **wallo_demand.f90** - Demand calculation updates
- **wallo_withdraw.f90** - Withdrawal logic changes
- **water_allocation_module.f90** - Module additions for canals
- **water_allocation_read.f90** - Split and reorganized

#### 3. Plant/Residue Management
- **pl_rootfr.f90** - Root fraction calculations
- **mgt_killop.f90** - Kill operation updates
- **soil_nutcarb_write.f90** - Output format changes

### Medium Priority - Supporting Changes

#### 4. Control/Flow
- **hru_control.f90** - HRU control logic updates
- **ru_control.f90** - Routing unit control updates

#### 5. Soil/Hydrology
- **gwflow_read.f90** - Groundwater flow reading
- **gwflow_simulate.f90** - Groundwater simulation
- **gwflow_soil.f90** - Groundwater-soil interaction
- **hru_hyds.f90** - HRU hydraulics
- **soils_test_adjust.f90** - Soil test adjustments
- **soils_init.f90** - Soil initialization

#### 6. Other Modules
- **utils.f90** - Utility functions
- **carbon_coef_read.f90** - Carbon coefficient reading
- **carbon_module.f90** - Carbon module updates
- **ero_cfactor.f90** - Erosion C-factor
- **fcgd.f90** - Field capacity calculations
- **hru_output.f90** - HRU output formatting
- **output_landscape_module.f90** - Landscape output
- **soil_module.f90** - Soil module updates
