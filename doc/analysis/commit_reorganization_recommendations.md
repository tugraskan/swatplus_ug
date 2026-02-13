# Recommendations for Logical Commit Reorganization

## Current State
The arnoldjjms/main branch has 7 commits (including 1 merge commit) that represent several distinct functional areas. Some commits combine multiple unrelated changes.

## Suggested Commit Structure

### Group 1: Water Allocation Infrastructure (Foundation)
**Recommended Commits:**
1. **Add water allocation module extensions**
   - water_allocation_module.f90 (add canal-related structures)
   - constituent_mass_module.f90
   - tiles_data_module.f90
   - hydrograph_module.f90

2. **Add new water allocation files**
   - wallo_canal.f90 (new)
   - water_canal_read.f90 (new)
   - water_orcv_read.f90 (new)

3. **Update water allocation control and demand logic**
   - wallo_control.f90
   - wallo_demand.f90
   - wallo_withdraw.f90
   - wallo_transfer.f90
   - wallo_treatment.f90

4. **Refactor water_allocation_read**
   - water_allocation_read.f90 (split into functions)
   - om_osrc_read.f90
   - om_treat_read.f90
   - om_use_read.f90
   - water_osrc_read.f90

5. **Integrate water allocation with system**
   - recall_module.f90
   - recall_read.f90
   - actions.f90
   - hyd_read_connect.f90
   - water_pipe_read.f90
   - water_tower_read.f90

### Group 2: Residue Management by Plant Type
**Recommended Commits:**
1. **Add residue storage by plant type data structures**
   - plant_module.f90
   - soil_module.f90
   - organic_mineral_mass_module.f90

2. **Update residue initialization and tracking**
   - plant_init.f90
   - soil_nutcarb_init.f90
   - soils_init.f90

3. **Modify residue operations**
   - rsd_decomp.f90
   - pl_mortality.f90
   - pl_root_gro.f90
   - pl_rootfr.f90

4. **Update management operations for plant-specific residue**
   - mgt_harvbiomass.f90
   - mgt_harvresidue.f90
   - mgt_harvtuber.f90
   - mgt_killop.f90
   - mgt_newtillmix.f90
   - mgt_sched.f90

### Group 3: Carbon and Nutrient Cycling Fixes
**Recommended Commits:**
1. **Fix NO3/NH4 blowup in carbon decomposition**
   - cbn_rsd_decomp.f90 (move guards before calculation)
   - cbn_zhang2.f90

2. **Add surface residue decomposition**
   - cbn_surfres_decomp.f90 (new)
   - hru_control.f90 (add call to new routine)

3. **Update nutrient cycling**
   - nut_nminrl.f90
   - nut_orgnc.f90
   - nut_orgnc2.f90

### Group 4: Root Distribution Improvements
**Recommended Commits:**
1. **Improve root fraction calculations**
   - pl_rootfr.f90
   - pl_biomass_gro.f90

2. **Integrate root distribution in HRU control**
   - hru_control.f90 (add pl_rootfr call)

### Group 5: Wetland Fixes
**Recommended Commits:**
1. **Resolve wetland issues**
   - wetland_control.f90
   - wetland_output.f90
   - res_control.f90
   - sd_channel_control3.f90

### Group 6: Supporting Changes
**Recommended Commits:**
1. **Update plant and soil processes**
   - pl_burnop.f90
   - pl_dormant.f90
   - pl_fert.f90
   - pl_leaf_senes.f90
   - pl_manure.f90
   - albedo.f90
   - et_act.f90
   - stmp_solt.f90

2. **Update erosion calculations**
   - ero_cfactor.f90
   - ero_ovrsed.f90
   - wind_ero_veg.f90

3. **Update control and flow**
   - hru_control.f90 (remaining changes)
   - hru_module.f90
   - hyd_connect.f90
   - mallo_control.f90
   - time_control.f90
   - command.f90

4. **Update data modules and utilities**
   - maximum_data_module.f90
   - allocate_parms.f90
   - soil_db_read.f90
   - res_nutrient.f90
   - obj_output.f90

## Notes on merge_213

The user mentioned merge_213, but no branch or commit with that exact name was found. However:
- A commit `bf213cf` exists from 2025-11-21: "Merge branch 'swatplus_fg_dev' of https://github.com/fgeter/swatplus_fg_fork"
- Previous arnoldjjms integration was PR #145 (merged Jan 16, 2026) with 3 commits

The commits in arnoldjjms/main dated after Jan 16, 2026 are truly new:
1. 3a44d93 (2026-01-21): water_allo updates
2. 423ab74 (2026-01-21): split water_allocation_read  
3. 52ab1cd (2026-02-10): Residue pool updates + canals
4. 83b1dee (2026-02-12): fixed no3 and nh4 blopup

## Integration Strategy

### Option A: Cherry-pick by Functional Group (Recommended)
1. Create separate feature branches for each group
2. Cherry-pick and squash related commits into logical units
3. Test each feature branch independently
4. Merge in order of dependencies

### Option B: Rebase and Split
1. Create integration branch from current main
2. Rebase arnoldjjms/main onto it
3. Use interactive rebase to split and reorganize commits
4. Force push to clean feature branch

### Option C: Fresh Commits
1. Manually apply changes in logical order
2. Create new commits with clear messages
3. Better commit history but loses original attribution
