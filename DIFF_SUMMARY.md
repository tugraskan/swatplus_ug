# Diff Summary: main vs Nam_Branch_1119

## Branch Information
- **Base Branch**: main (commit: a4e85d8e3172ce809a459b27361148644a81fa6b)
- **Compare Branch**: Nam_Branch_1119 (commit: c531fab8c8aea8b3bf47ac1246385e7c325f40dc)
- **Generated**: $(date -u +"%Y-%m-%d %H:%M:%S UTC")

## Overview
This document provides a comprehensive comparison between the `main` branch and `Nam_Branch_1119` branch.

## Summary Statistics
- **Total Files Changed**: 136 files
- **Lines Added**: 3,542
- **Lines Deleted**: 9,597
- **Net Change**: -6,055 lines

## Files Changed Summary

### Major Changes (>100 lines changed)

 data/Ames_sub1/management.sch               |  312 +-
 data/management.sch                         | 4321 ---------------------------
 src/basin_print_codes_read.f90              |  691 +----
 src/carbon_coef_read.f90                    |  137 +-
 src/cs_divert.f90                           |  164 +-
 src/lsu_output.f90                          |  530 ++--
 src/mgt_newtillmix.f90                      |  214 +-
 src/mgt_sched.f90                           |  289 +-
 src/output_landscape_module.f90             |  179 +-
 src/sd_channel_control.f90                  |  845 +++++-
 src/sd_channel_sediment3.f90                |  114 +-
 src/soil_nutcarb_write.f90                  |  506 ++--
 src/soil_test_adjust.f90                    |  128 -
 src/soils_init.f90                          |  277 +-
 src/sq_greenampt.f90                        |  146 +-
 src/wallo_control.f90                       |  199 +-
 src/wallo_demand.f90                        |  146 +-
 src/wallo_withdraw.f90                      |  179 +-
 src/water_allocation_module.f90             |  199 +-
 src/water_allocation_output.f90             |  411 +--
 src/water_allocation_read.f90               |  609 +---

### All Files Changed

```
 .gitignore                                  |    1 -
 CMakeLists.txt                              |   16 +-
 basin_print_codes_read copy.f90             |  517 ----
 data/Ames_sub1/carb_coefs.cbn               |   42 -
 data/Ames_sub1/carbon_coef.cbn              |    4 +
 data/Ames_sub1/file.cio                     |    2 +-
 data/Ames_sub1/hru-data.hru                 |    4 +-
 data/Ames_sub1/irr.ops                      |    5 +-
 data/Ames_sub1/landuse.lum                  |    4 +-
 data/Ames_sub1/lum.dtl                      |   20 -
 data/Ames_sub1/management.sch               |  312 +-
 data/Ames_sub1/print.prt                    |    6 +-
 data/Ames_sub1/soil_lyr_depths.sol          |    1 -
 data/Ames_sub1/soils.sol                    |   10 -
 data/Ames_sub1/tillage.til                  |    1 -
 data/Osu_1hru/irr.ops                       |    1 -
 data/Osu_1hru/lum.dtl                       |    7 -
 data/hru-data.hru                           |   14 -
 data/landuse.lum                            |   24 -
 data/management.sch                         | 4321 ---------------------------
 src/actions.f90                             |   43 +-
 src/allocate_parms.f90                      |    1 +
 src/aqu_1d_control.f90                      |    2 +-
 src/basin_module.f90                        |    7 +-
 src/basin_output.f90                        |    6 +-
 src/basin_print_codes_read.f90              |  691 +----
 src/basin_prm_default.f90                   |    3 +-
 src/basin_reservoir_output.f90              |    2 +-
 src/cal_conditions.f90                      |    8 +-
 src/carbon_coef_read.f90                    |  137 +-
 src/carbon_module.f90                       |   18 +-
 src/cbn_rsd_decomp.f90                      |   67 +-
 src/cbn_zhang2.f90                          |   58 +-
 src/ch_read_orders_cal.f90                  |    2 +-
 src/ch_rtmusk.f90                           |    6 +-
 src/ch_rtpest.f90                           |   72 +-
 src/ch_temp.f90                             |    4 +-
 src/ch_watqual4.f90                         |    5 +-
 src/ch_watqual_semi_analitical_function.f90 |    6 +-
 src/channel_module.f90                      |   72 +
 src/command.f90                             |   24 +-
 src/conditions.f90                          |   11 +-
 src/constituent_mass_module.f90             |   58 -
 src/cs_divert.f90                           |  164 +-
 src/cs_irrig.f90                            |   12 +-
 src/curno.f90                               |    2 +-
 src/ero_cfactor.f90                         |    3 +-
 src/fertilizer_data_module.f90              |    2 +-
 src/gwflow_ppag.f90                         |    8 +-
 src/header_channel.f90                      |   16 +
 src/header_water_allocation.f90             |    2 +-
 src/hru_control.f90                         |   20 +-
 src/hru_dtbl_actions_init.f90               |   18 +-
 src/hru_module.f90                          |   10 +-
 src/hru_output.f90                          |   44 +-
 src/hru_read.f90                            |    2 +-
 src/hyd_connect.f90                         |    2 -
 src/hydrograph_module.f90                   |   71 +-
 src/lsu_output.f90                          |  530 ++--
 src/main.f90.in                             |    7 +-
 src/mallo_control.f90                       |   28 +-
 src/manure_allocation_module.f90            |   28 +-
 src/manure_allocation_read.f90              |   36 +-
 src/manure_demand_output.f90                |   74 +-
 src/manure_source_output.f90                |   20 +-
 src/maximum_data_module.f90                 |    4 -
 src/mgt_harvresidue.f90                     |   24 +-
 src/mgt_newtillmix.f90                      |  214 +-
 src/mgt_sched.f90                           |  289 +-
 src/mgt_tillfactor.f90                      |   33 +-
 src/nut_nminrl.f90                          |    7 -
 src/nut_orgnc2.f90                          |    7 +-
 src/organic_mineral_mass_module.f90         |    4 -
 src/output_landscape_init.f90               |   76 +-
 src/output_landscape_module.f90             |  179 +-
 src/pest_apply.f90                          |   20 +
 src/pest_decay.f90                          |   13 +-
 src/pest_enrsb.f90                          |   14 +
 src/pest_lch.f90                            |   20 +
 src/pest_parm_read.f90                      |    9 +-
 src/pest_pesty.f90                          |    9 +
 src/pest_washp.f90                          |    2 +-
 src/pl_biomass_gro.f90                      |    3 -
 src/pl_burnop.f90                           |    5 +-
 src/pl_dormant.f90                          |   11 +-
 src/pl_fert.f90                             |    6 +-
 src/pl_graze.f90                            |    2 +-
 src/pl_grow.f90                             |   13 +-
 src/pl_leaf_gro.f90                         |   12 +-
 src/pl_leaf_senes.f90                       |    6 +-
 src/pl_mortality.f90                        |   55 +-
 src/pl_pup.f90                              |    6 +-
 src/pl_pupd.f90                             |    6 +
 src/pl_root_gro.f90                         |    5 +-
 src/plant_init.f90                          |    2 +-
 src/res_control.f90                         |    4 +-
 src/res_hydro.f90                           |    4 +-
 src/ru_control.f90                          |    3 +-
 src/salt_irrig.f90                          |   12 +-
 src/sd_channel_control.f90                  |  845 +++++-
 src/sd_channel_control3.f90                 |    9 +-
 src/sd_channel_module.f90                   |    5 +-
 src/sd_channel_sediment3.f90                |  114 +-
 src/sd_hydsed_init.f90                      |    3 +-
 src/sim_initday.f90                         |    2 +
 src/soil_carbvar_write.f90                  |   20 +-
 src/soil_module.f90                         |   16 +-
 src/soil_nutcarb_init.f90                   |   40 +-
 src/soil_nutcarb_write.f90                  |  506 ++--
 src/soil_phys_init.f90                      |   16 +-
 src/soil_test_adjust.f90                    |  128 -
 src/soils_init.f90                          |  277 +-
 src/sq_greenampt.f90                        |  146 +-
 src/sq_surfst.f90                           |    4 +-
 src/stor_surfstor.f90                       |    6 +-
 src/swift_output.f90                        |   78 +-
 src/swr_subwq.f90                           |    1 -
 src/tiles_data_module.f90                   |    4 +-
 src/till_parm_read.f90                      |   60 +-
 src/tillage_data_module.f90                 |    8 -
 src/time_control.f90                        |   42 +-
 src/treat_read_om.f90                       |   41 +-
 src/utils.f90                               |   44 -
 src/wallo_control.f90                       |  199 +-
 src/wallo_demand.f90                        |  146 +-
 src/wallo_transfer.f90                      |   44 +-
 src/wallo_treatment.f90                     |   89 +-
 src/wallo_withdraw.f90                      |  179 +-
 src/water_allocation_module.f90             |  199 +-
 src/water_allocation_output.f90             |  411 +--
 src/water_allocation_read.f90               |  609 +---
 src/water_body_module.f90                   |   15 +-
 src/wb_check.f90                            |   27 -
 src/wet_all_initial.f90                     |    5 +-
 src/wet_initial.f90                         |    6 +-
 src/zero0.f90                               |    2 +
 136 files changed, 3542 insertions(+), 9597 deletions(-)
```

## Key Categories of Changes

### 1. Build & Configuration Files
- `.gitignore` - Modified
- `CMakeLists.txt` - 16 lines changed

### 2. Data Files
- `data/management.sch` - 4,321 lines deleted (major cleanup)
- `data/Ames_sub1/*` - Multiple files modified/removed
- `data/Osu_1hru/*` - Multiple files modified

### 3. Source Code Files (src/)

#### Removed Files
- `basin_print_codes_read copy.f90` - 517 lines removed
- `soil_test_adjust.f90` - 128 lines removed

#### Major Modifications (>100 lines changed)
- `basin_print_codes_read.f90` - Significant refactoring
- `carbon_coef_read.f90` - 137 lines changed
- `lsu_output.f90` - 530 lines modified
- `sd_channel_control.f90` - 845 lines added
- `sd_channel_sediment3.f90` - 114 lines modified
- `soil_nutcarb_write.f90` - 506 lines changed
- `soils_init.f90` - 277 lines modified
- `sq_greenampt.f90` - 146 lines changed
- `water_allocation_output.f90` - 411 lines removed
- `water_allocation_read.f90` - 609 lines removed
- `water_allocation_module.f90` - 199 lines changed
- `wallo_control.f90` - 199 lines changed
- `wallo_demand.f90` - 146 lines changed
- `wallo_withdraw.f90` - 179 lines changed
- `mgt_newtillmix.f90` - 214 lines changed
- `mgt_sched.f90` - 289 lines changed
- `mgt_tillfactor.f90` - Several changes

### 4. Module Files
- `basin_module.f90` - Minor updates
- `carbon_module.f90` - 18 lines changed
- `channel_module.f90` - 72 lines added
- `constituent_mass_module.f90` - 58 lines removed
- `fertilizer_data_module.f90` - Minor changes
- `hydrograph_module.f90` - 71 lines changed
- `manure_allocation_module.f90` - 28 lines changed
- `maximum_data_module.f90` - 4 lines removed
- `organic_mineral_mass_module.f90` - 4 lines removed
- `output_landscape_module.f90` - 179 lines changed
- `soil_module.f90` - 16 lines changed
- `tillage_data_module.f90` - 8 lines removed
- `water_allocation_module.f90` - 199 lines changed
- `water_body_module.f90` - 15 lines changed

## Notable Pattern Changes

### Water Allocation System
The Nam_Branch_1119 branch contains significant refactoring of the water allocation system:
- Simplified `water_allocation_read.f90` (609 lines removed)
- Simplified `water_allocation_output.f90` (411 lines removed)
- Modified control and transfer logic in multiple `wallo_*.f90` files

### Channel Control
- Major expansion of `sd_channel_control.f90` (845 lines added)
- Updates to channel sediment handling

### Soil and Carbon Processing
- Refactored `soils_init.f90` (277 lines changed)
- Updated `soil_nutcarb_write.f90` (506 lines changed)
- Modified carbon decomposition routines

### Management and Tillage
- Significant updates to tillage mixing (`mgt_newtillmix.f90`, 214 lines)
- Modified management scheduling (`mgt_sched.f90`, 289 lines)
- Updated tillage factor calculations

### Data Cleanup
- Massive cleanup in `data/management.sch` (4,321 lines deleted)
- Removal of duplicate/obsolete files

## How to View Full Diff

To see the complete diff with all changes:
```bash
git diff main..Nam_Branch_1119
```

To see diff for a specific file:
```bash
git diff main..Nam_Branch_1119 -- path/to/file
```

To see only changed file names:
```bash
git diff --name-only main..Nam_Branch_1119
```

## Summary

The Nam_Branch_1119 branch represents a significant refactoring effort with:
- **Net reduction** of ~6,000 lines of code
- **Major cleanup** of data files
- **Refactoring** of water allocation, soil processing, and channel control systems
- **Code simplification** in multiple modules
- **Removal** of obsolete/duplicate files

The changes appear to focus on code cleanup, simplification, and improvements to the water allocation and soil/carbon processing systems.
