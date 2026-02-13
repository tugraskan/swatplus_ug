# Analysis of arnoldjjms/swatplus_dev .f90 Changes

## Summary
- **Commits Ahead**: 7 commits (including 1 merge commit)
- **Total .f90 Files Changed**: 22 files (comparing against current branch)
- **Net Changes**: +351 lines, -274 lines

## Commits Grouped by Functionality

### 1. Water Allocation Features (5 commits)
**Commits:**
- 7e82c5d (2025-11-19): "water allocation updates"
- 3a44d93 (2026-01-21): "water_allo updates"
- 423ab74 (2026-01-21): "split water_allocation_read"
- 52ab1cd (2026-02-10): "Residue pool updates. Added canals to water allocation..."
- 83b1dee (2026-02-12): "fixed no3 and nh4 blopup in cbn_zhang2"

**Key Changes:**
- Added canal support to water allocation
- Split water_allocation_read for better modularity
- Multiple channels within water allocation objects
- Recall support for water allocation
- New files: wallo_canal.f90, water_canal_read.f90, water_orcv_read.f90

**Files Modified:**
- Water allocation: wallo_*.f90, water_allocation_*.f90
- Hydrograph: hydrograph_module.f90
- Modules: constituent_mass_module.f90, recall_module.f90, tiles_data_module.f90

### 2. Residue and Carbon Management (3 commits)
**Commits:**
- 10fc6ab (2026-01-06): "weland issues resoloved and residue stored by plant type"
- 52ab1cd (2026-02-10): "Residue pool updates..."
- 83b1dee (2026-02-12): "fixed no3 and nh4 blopup in cbn_zhang2"

**Key Changes:**
- Residue stored by plant type
- Fixed NO3 and NH4 blowup in carbon decomposition
- New surface residue decomposition file
- Residue pool management improvements

**Files Modified:**
- Carbon: cbn_rsd_decomp.f90, cbn_zhang2.f90, cbn_surfres_decomp.f90 (new)
- Residue: rsd_decomp.f90
- Plant: plant_init.f90, pl_mortality.f90, pl_rootfr.f90
- Organic matter: organic_mineral_mass_module.f90
- Nutrients: nut_nminrl.f90, nut_orgnc.f90, nut_orgnc2.f90

### 3. Wetland Issues Resolution (1 commit)
**Commits:**
- 10fc6ab (2026-01-06): "weland issues resoloved and residue stored by plant type"

**Files Modified:**
- wetland_control.f90, wetland_output.f90

### 4. Management Operations Updates (2 commits)
**Commits:**
- 10fc6ab (2026-01-06): Main management updates
- 52ab1cd (2026-02-10): Additional harvest/kill operations

**Files Modified:**
- mgt_*.f90: harvbiomass, harvresidue, harvtuber, killop, newtillmix, sched
- actions.f90

### 5. Plant and Soil Updates (2 commits)
**Commits:**
- 10fc6ab (2026-01-06): Root distribution and plant updates
- 52ab1cd (2026-02-10): Root growth and mortality updates

**Files Modified:**
- Plant: pl_*.f90 (biomass_gro, burnop, dormant, fert, leaf_senes, manure, mortality, root_gro, rootfr)
- Soil: soil_*.f90, soils_*.f90
- Erosion: ero_cfactor.f90, ero_ovrsed.f90

### 6. Merge Commit
- 9f02b7b (2026-01-21): "merge" - No file changes
