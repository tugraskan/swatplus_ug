# SWAT+ Subroutine Categorization

This document provides a comprehensive categorization of subroutines in SWAT+. The model contains approximately 643 Fortran source files (*.f90), each typically containing one or more subroutines or functions. These have been organized into functional categories to help understand the model structure and facilitate development.

## Overview

SWAT+ subroutines can be categorized based on two main organizational principles:

1. **Functional Purpose** - What role the subroutine plays in the model execution
2. **Spatial/Component Domain** - Which landscape or water body component it operates on

## Category 1: Model Control and Orchestration

**Purpose:** High-level control flow, simulation sequencing, and coordination between model components.

**Count:** ~19 subroutines

**Examples:**
- `time_control.f90` - Master time loop controller
- `hru_control.f90` - HRU simulation control
- `channel_control.f90` - Channel routing control
- `wetland_control.f90` - Wetland simulation control
- `res_control.f90` - Reservoir simulation control
- `ru_control.f90` - Routing unit control
- `calhard_control.f90` - Hard calibration control
- `calsoft_control.f90` - Soft calibration control
- `climate_control.f90` - Climate data control
- `cli_precip_control.f90` - Precipitation control
- `wallo_control.f90` - Water allocation control
- `mallo_control.f90` - Manure allocation control
- `sd_channel_control.f90` - Swat-deg channel control
- `aqu_1d_control.f90` - 1D aquifer control
- `wind_ero_control.f90` - Wind erosion control

## Category 2: Input/Data Reading

**Purpose:** Read configuration files, parameters, and input data from external files.

**Count:** ~151 subroutines

**Examples:**
- `*_read.f90` - Generic read subroutines
- `*_read_*.f90` - Specific data readers
- `basin_read_objs.f90` - Basin objects configuration
- `hru_read.f90` - HRU parameters
- `plant_parm_read.f90` - Plant parameters
- `soil_db_read.f90` - Soil database
- `ch_read_hyd.f90` - Channel hydraulics
- `res_read_hyd.f90` - Reservoir hydraulics
- `cli_staread.f90` - Climate station data
- `aqu_read.f90` - Aquifer parameters
- `gwflow_read.f90` - Groundwater flow parameters
- `pest_parm_read.f90` - Pesticide parameters
- `fert_parm_read.f90` - Fertilizer parameters
- `mgt_read_mgtops.f90` - Management operations

**Subcategories:**
- Configuration readers (`*_read.f90`)
- Database readers (`*_db_read.f90`)
- Parameter readers (`*_parm_read.f90`)
- Initial condition readers (`*_read_init*.f90`)
- Element/object readers (`*_read_elements.f90`)

## Category 3: Initialization

**Purpose:** Initialize model components, allocate memory, set initial conditions.

**Count:** ~44 subroutines

**Examples:**
- `*_init.f90` - Component initialization
- `*_initial.f90` - Initial conditions
- `varinit.f90` - Variable initialization
- `zeroini.f90`, `zero0.f90`, `zero1.f90`, `zero2.f90` - Zero initialization
- `soil_phys_init.f90` - Soil physics initialization
- `plant_init.f90` - Plant initialization
- `ch_initial.f90` - Channel initial conditions
- `res_initial.f90` - Reservoir initial conditions
- `wet_initial.f90` - Wetland initial conditions
- `aqu_initial.f90` - Aquifer initial conditions
- `allocate_parms.f90` - Parameter memory allocation
- `hrudb_init.f90` - HRU database initialization
- `topohyd_init.f90` - Topographic hydrology initialization

## Category 4: Output/Reporting

**Purpose:** Write simulation results to output files.

**Count:** ~67 subroutines

**Examples:**
- `*_output.f90` - Component output writers
- `basin_output.f90` - Basin-level outputs
- `hru_output.f90` - HRU outputs
- `channel_output.f90` - Channel outputs
- `aquifer_output.f90` - Aquifer outputs
- `reservoir_output.f90` - Reservoir outputs
- `wetland_output.f90` - Wetland outputs
- `hru_pesticide_output.f90` - HRU pesticide outputs
- `res_pesticide_output.f90` - Reservoir pesticide outputs
- `hru_salt_output.f90` - HRU salt outputs
- `hru_cs_output.f90` - HRU constituent outputs

**Subcategories:**
- Water balance outputs
- Nutrient/sediment outputs
- Pesticide outputs
- Pathogen outputs
- Salt outputs
- Constituent outputs
- Budget outputs

## Category 5: Data Modules

**Purpose:** Define data structures, types, and shared variables.

**Count:** ~64 subroutines

**Examples:**
- `*_module.f90` - Module definitions
- `basin_module.f90` - Basin-level data structures
- `hru_module.f90` - HRU data structures
- `channel_module.f90` - Channel data structures
- `aquifer_module.f90` - Aquifer data structures
- `plant_module.f90` - Plant growth data
- `soil_module.f90` - Soil property data
- `climate_module.f90` - Climate data
- `time_module.f90` - Time tracking data
- `organic_mineral_mass_module.f90` - OM and mineral mass
- `hydrograph_module.f90` - Hydrograph data structures

## Category 6: Hydrologic Processes

**Purpose:** Simulate water movement and storage in the watershed.

**Count:** ~40 subroutines

### 6.1 Surface Hydrology
**Examples:**
- `sq_*.f90` - Surface runoff calculations
- `sq_surfst.f90` - Surface storage
- `sq_volq.f90` - Volume of runoff
- `sq_greenampt.f90` - Green-Ampt infiltration
- `sq_dailycn.f90` - Daily curve number
- `sq_snom.f90` - Snowmelt
- `sq_canopyint.f90` - Canopy interception
- `stor_surfstor.f90` - Surface storage

### 6.2 Subsurface Hydrology
**Examples:**
- `swr_*.f90` - Subsurface water routing
- `swr_percmain.f90` - Main percolation
- `swr_percmicro.f90` - Micropore percolation
- `swr_percmacro.f90` - Macropore percolation
- `swr_latsed.f90` - Lateral sediment
- `swr_substor.f90` - Subsurface storage
- `swr_satexcess.f90` - Saturation excess flow
- `swr_drains.f90` - Tile drainage
- `swr_origtile.f90` - Original tile drainage

### 6.3 Evapotranspiration
**Examples:**
- `et_pot.f90` - Potential ET
- `et_act.f90` - Actual ET

### 6.4 Channel Routing
**Examples:**
- `ch_rtday.f90` - Daily channel routing
- `ch_rthr.f90` - Hourly channel routing
- `ch_rtmusk.f90` - Muskingum routing
- `sd_channel_control*.f90` - SWAT-DEG channel processes

### 6.5 Groundwater
**Examples:**
- `gwflow_*.f90` - Groundwater flow module
- `gwflow_simulate.f90` - Main groundwater simulation
- `gwflow_rech.f90` - Groundwater recharge
- `gwflow_gwsw.f90` - Groundwater-surface water exchange
- `gwflow_tile.f90` - Tile drainage interaction
- `aqu_hyds.f90` - Aquifer hydraulics

## Category 7: Sediment and Erosion Processes

**Purpose:** Simulate soil erosion, sediment transport, and deposition.

**Count:** ~15 subroutines

**Examples:**
- `ero_*.f90` - Erosion calculations
- `ero_ysed.f90` - Sediment yield
- `ero_pkq.f90` - Peak runoff rate
- `ero_ovrsed.f90` - Overland sediment
- `ero_cfactor.f90` - Cover factor
- `ero_eiusle.f90` - MUSLE erosion
- `wind_ero_*.f90` - Wind erosion
- `wind_ero_bare.f90` - Bare soil wind erosion
- `wind_ero_veg.f90` - Vegetated surface wind erosion
- `res_sediment.f90` - Reservoir sediment
- `sd_channel_sediment.f90` - Channel sediment

## Category 8: Nutrient Cycling

**Purpose:** Simulate nitrogen and phosphorus transformations and transport.

**Count:** ~13 subroutines

**Examples:**
- `nut_*.f90` - Nutrient process subroutines
- `nut_nminrl.f90` - Nitrogen mineralization
- `nut_pminrl.f90` - Phosphorus mineralization
- `nut_pminrl2.f90` - Alternative P mineralization
- `nut_denit.f90` - Denitrification
- `nut_nitvol.f90` - Nitrogen volatilization
- `nut_nlch.f90` - Nitrogen leaching
- `nut_psed.f90` - Phosphorus in sediment
- `nut_solp.f90` - Soluble phosphorus
- `nut_orgn.f90` - Organic nitrogen
- `nut_orgnc.f90` - Organic nitrogen cycling
- `nut_np_flow.f90` - N and P in flow

## Category 9: Carbon Cycling

**Purpose:** Simulate carbon transformations in soil and vegetation.

**Count:** ~5 subroutines

**Examples:**
- `cbn_*.f90` - Carbon cycling
- `cbn_zhang2.f90` - Zhang carbon model
- `cbn_rsd_decomp.f90` - Residue decomposition
- `rsd_decomp.f90` - General residue decomposition
- `gcycl.f90` - General carbon cycling

## Category 10: Plant Growth

**Purpose:** Simulate crop and vegetation growth dynamics.

**Count:** ~27 subroutines

**Examples:**
- `pl_*.f90` - Plant process subroutines
- `pl_grow.f90` - General plant growth
- `pl_biomass_gro.f90` - Biomass growth
- `pl_leaf_gro.f90` - Leaf growth
- `pl_root_gro.f90` - Root growth
- `pl_seed_gro.f90` - Seed growth
- `pl_leaf_senes.f90` - Leaf senescence
- `pl_partition.f90` - Biomass partitioning
- `pl_nup.f90` - Nitrogen uptake
- `pl_pup.f90` - Phosphorus uptake
- `pl_waterup.f90` - Water uptake
- `pl_nut_demand.f90` - Nutrient demand
- `pl_nfix.f90` - Nitrogen fixation
- `pl_dormant.f90` - Dormancy
- `pl_mortality.f90` - Plant mortality

## Category 11: Management Operations

**Purpose:** Simulate agricultural management practices.

**Count:** ~21 subroutines

**Examples:**
- `mgt_*.f90` - Management operation subroutines
- `mgt_operatn.f90` - Operation scheduler
- `mgt_plantop.f90` - Planting operation
- `mgt_killop.f90` - Kill/harvest kill operation
- `mgt_harvbiomass.f90` - Biomass harvest
- `mgt_harvgrain.f90` - Grain harvest
- `mgt_newtillmix.f90` - Tillage mixing
- `mgt_tillfactor.f90` - Tillage factor calculation
- `pl_graze.f90` - Grazing
- `pl_burnop.f90` - Burning operation
- `hru_sweep.f90` - Street sweeping
- `hru_urb_bmp.f90` - Urban BMPs

## Category 12: Pesticides

**Purpose:** Simulate pesticide fate and transport.

**Count:** ~12 subroutines

**Examples:**
- `pest_*.f90` - Pesticide process subroutines
- `pest_apply.f90` - Pesticide application
- `pest_pesty.f90` - Pesticide processes
- `pest_decay.f90` - Pesticide decay
- `pest_lch.f90` - Pesticide leaching
- `pest_washp.f90` - Pesticide washoff
- `pest_enrsb.f90` - Pesticide enrichment
- `pest_pl_up.f90` - Plant uptake
- `ch_rtpest.f90` - Channel pesticide routing
- `res_pest.f90` - Reservoir pesticides

## Category 13: Pathogens

**Purpose:** Simulate pathogen fate and transport.

**Count:** ~7 subroutines

**Examples:**
- `path_*.f90` - Pathogen process subroutines
- `path_apply.f90` - Pathogen application
- `path_ls_process.f90` - Land surface pathogen processes
- `path_ls_runoff.f90` - Pathogen in runoff
- `path_ls_swrouting.f90` - Pathogen surface water routing
- `ch_rtpath.f90` - Channel pathogen routing

## Category 14: Salts and Constituents

**Purpose:** Simulate salt and general constituent fate and transport.

**Count:** ~52 subroutines

### 14.1 Salts
**Examples:**
- `salt_*.f90` - Salt process subroutines (~25)
- `salt_lch.f90` - Salt leaching
- `salt_irrig.f90` - Salt in irrigation water
- `salt_chem_hru.f90` - Salt chemistry in HRU
- `salt_chem_aqu.f90` - Salt chemistry in aquifer
- `salt_balance.f90` - Salt mass balance
- `salt_uptake.f90` - Salt plant uptake
- `salt_roadsalt.f90` - Road salt application

### 14.2 Constituents (CS)
**Examples:**
- `cs_*.f90` - Constituent process subroutines (~27)
- `cs_lch.f90` - Constituent leaching
- `cs_rain.f90` - Constituent in rainfall
- `cs_sorb_hru.f90` - Constituent sorption in HRU
- `cs_rctn_hru.f90` - Constituent reactions in HRU
- `cs_balance.f90` - Constituent mass balance
- `cs_uptake.f90` - Constituent plant uptake

## Category 15: Water Quality in Water Bodies

**Purpose:** Simulate in-stream and in-reservoir water quality processes.

**Count:** ~8 subroutines

**Examples:**
- `ch_watqual4.f90` - QUAL2E in-stream water quality
- `ch_temp.f90` - Stream temperature
- `res_nutrient.f90` - Reservoir nutrient cycling
- `wet_cs.f90` - Wetland constituents
- `wet_salt.f90` - Wetland salts
- `res_cs.f90` - Reservoir constituents
- `res_salt.f90` - Reservoir salts
- `swr_subwq.f90` - Subsurface water quality

## Category 16: Climate and Weather

**Purpose:** Generate or read climate data and atmospheric deposition.

**Count:** ~34 subroutines

**Examples:**
- `cli_*.f90` - Climate process subroutines
- `cli_weatgn.f90` - Weather generator
- `cli_pgen.f90` - Precipitation generator
- `cli_tgen.f90` - Temperature generator
- `cli_rhgen.f90` - Relative humidity generator
- `cli_slrgen.f90` - Solar radiation generator
- `cli_wndgen.f90` - Wind generator
- `cli_pmeas.f90` - Measured precipitation
- `cli_tmeas.f90` - Measured temperature
- `cli_smeas.f90` - Measured solar radiation
- `cli_atmodep_time_control.f90` - Atmospheric deposition

## Category 17: Urban and BMPs

**Purpose:** Simulate urban hydrology and best management practices.

**Count:** ~10 subroutines

**Examples:**
- `hru_urban.f90` - Urban HRU daily simulation
- `hru_urbanhr.f90` - Urban HRU hourly simulation
- `sep_biozone.f90` - Septic biozone
- `smp_*.f90` - Structural practice simulations
- `smp_buffer.f90` - Buffer strips
- `smp_filter.f90` - Filter strips
- `smp_grass_wway.f90` - Grassed waterways
- `smp_bmpfixed.f90` - Fixed removal BMPs

## Category 18: Calibration

**Purpose:** Auto-calibration routines and parameter adjustment.

**Count:** ~23 subroutines

**Examples:**
- `cal_*.f90` - Calibration subroutines
- `calsoft_*.f90` - Soft calibration (~13)
- `calhard_control.f90` - Hard calibration
- `cal_parm_read.f90` - Calibration parameter reading
- `cal_conditions.f90` - Calibration conditions
- `chg_par.f90` - Change parameters
- `calsoft_hyd.f90` - Hydrology calibration
- `calsoft_sed.f90` - Sediment calibration
- `calsoft_plant.f90` - Plant calibration

## Category 19: Water Allocation and Transfers

**Purpose:** Simulate water management, allocation, and transfers.

**Count:** ~13 subroutines

**Examples:**
- `wallo_*.f90` - Water allocation (~5)
- `wallo_demand.f90` - Water demand
- `wallo_withdraw.f90` - Water withdrawal
- `wallo_transfer.f90` - Water transfer
- `wallo_treatment.f90` - Water treatment
- `recall_*.f90` - Point source inputs (~8)
- `recall_nut.f90` - Nutrient recall
- `recall_salt.f90` - Salt recall

## Category 20: Routing and Aggregation

**Purpose:** Route water and constituents between spatial units; aggregate outputs.

**Count:** ~25 subroutines

**Examples:**
- `basin_*.f90` - Basin aggregation (~19)
- `ru_*.f90` - Routing unit operations (~7)
- `rls_route*.f90` - Release routing
- `rls_routesurf.f90` - Surface routing
- `rls_routesoil.f90` - Soil routing
- `unit_hyd.f90` - Unit hydrograph
- `flow_dur_curve.f90` - Flow duration curves
- `hyd_connect.f90` - Hydrologic connectivity

## Category 21: Reservoir Operations

**Purpose:** Simulate reservoir hydraulics and operations.

**Count:** ~20 subroutines

**Examples:**
- `res_*.f90` - Reservoir subroutines
- `res_hydro.f90` - Reservoir hydraulics
- `res_control.f90` - Reservoir control
- `res_weir_release.f90` - Weir releases
- `res_rel_ctbl.f90` - Release control table
- `est_weirdim.f90` - Estimate weir dimensions

## Category 22: Soil Properties and Processes

**Purpose:** Initialize and update soil physical and chemical properties.

**Count:** ~13 subroutines

**Examples:**
- `soil_*.f90` - Soil subroutines
- `soil_phys_init.f90` - Soil physics initialization
- `soil_nutcarb_init.f90` - Soil nutrient/carbon initialization
- `soil_awc_init.f90` - Available water capacity
- `soil_text_init.f90` - Soil texture initialization
- `layersplit.f90` - Split soil layers
- `stmp_solt.f90` - Soil temperature

## Category 23: Utility and Helper Functions

**Purpose:** Mathematical, statistical, and general utility functions.

**Count:** ~30 subroutines

**Examples:**
- `ran.f90`, `ran1.f90` - Random number generators
- `aunif.f90` - Uniform random numbers
- `atri.f90` - Triangular distribution
- `ascrv.f90` - S-curve parameters
- `ee.f90` - Exponential function
- `erfc.f90` - Error function complement
- `theta.f90` - Theta function
- `caps.f90` - Capitalize string
- `icl.f90` - Integer compare and limit
- `search.f90` - Search algorithm
- `regres.f90` - Regression
- `jdt.f90` - Julian date
- `xmon.f90` - Month crossing
- `curno.f90` - Curve number lookup
- `qman.f90` - Manning's equation
- `fcgd.f90` - Function
- `cond_*.f90` - Conditional logic

## Category 24: Headers and Formatting

**Purpose:** Write formatted headers for output files.

**Count:** ~15 subroutines

**Examples:**
- `header_*.f90` - Header writing subroutines
- `header_write.f90` - General header writer
- `header_hyd.f90` - Hydrology headers
- `header_channel.f90` - Channel headers
- `header_aquifer.f90` - Aquifer headers
- `header_pest.f90` - Pesticide headers
- `header_salt.f90` - Salt headers

## Category 25: External Sources and Diversions

**Purpose:** Handle external water, nutrient, and constituent sources.

**Count:** ~17 subroutines

**Examples:**
- `dr_*.f90` - Delivery ratio/drain tile (~9)
- `exco_*.f90` - Export coefficient (~8)
- `dr_ru.f90` - Drain tile in routing unit
- `cs_divert.f90` - Constituent diversion

## Summary Statistics

| Category | Count | Percentage |
|----------|-------|------------|
| Input/Data Reading | ~151 | 23.5% |
| Output/Reporting | ~67 | 10.4% |
| Data Modules | ~64 | 10.0% |
| Salts and Constituents | ~52 | 8.1% |
| Initialization | ~44 | 6.8% |
| Hydrologic Processes | ~40 | 6.2% |
| Climate and Weather | ~34 | 5.3% |
| Utility Functions | ~30 | 4.7% |
| Plant Growth | ~27 | 4.2% |
| Routing and Aggregation | ~25 | 3.9% |
| Calibration | ~23 | 3.6% |
| Management Operations | ~21 | 3.3% |
| Reservoir Operations | ~20 | 3.1% |
| Model Control | ~19 | 3.0% |
| External Sources | ~17 | 2.6% |
| Headers and Formatting | ~15 | 2.3% |
| Sediment and Erosion | ~15 | 2.3% |
| Nutrient Cycling | ~13 | 2.0% |
| Water Allocation | ~13 | 2.0% |
| Soil Properties | ~13 | 2.0% |
| Pesticides | ~12 | 1.9% |
| Urban and BMPs | ~10 | 1.6% |
| Water Quality (Water Bodies) | ~8 | 1.2% |
| Pathogens | ~7 | 1.1% |
| Carbon Cycling | ~5 | 0.8% |
| **Total** | **~643** | **100%** |

## Notes on Categorization

1. **Overlapping Categories:** Some subroutines could fit into multiple categories. For example, `gwflow_simulate.f90` is both a groundwater process and a control routine.

2. **Naming Conventions:** SWAT+ uses consistent prefixes to indicate spatial components:
   - `hru_` - Hydrologic Response Unit
   - `ch_` - Channel
   - `sd_` - SWAT-DEG channel
   - `res_` - Reservoir
   - `aqu_` - Aquifer
   - `wet_` - Wetland
   - `ru_` - Routing Unit
   - `basin_` - Basin-wide

3. **Process Prefixes:**
   - `cli_` - Climate
   - `pl_` - Plant
   - `mgt_` - Management
   - `nut_` - Nutrients
   - `pest_` - Pesticides
   - `path_` - Pathogens
   - `salt_` - Salts
   - `cs_` - Constituents
   - `swr_` - Subsurface water routing
   - `sq_` - Surface runoff
   - `ero_` - Erosion
   - `gwflow_` - Groundwater flow

4. **Functional Suffixes:**
   - `_read` - Input reading
   - `_output` - Output writing
   - `_init` - Initialization
   - `_control` - Control/orchestration
   - `_module` - Data structure definitions

This categorization helps developers and users understand the model structure and locate specific functionality within the large SWAT+ codebase.
