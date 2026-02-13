# File-by-File Conflict Analysis

## Summary of Changes Between Branches
- **arnoldjjms/main is 7 commits ahead** of current branch
- **Current branch is 37 commits behind** arnoldjjms/main
- **22 .f90 files modified** in both branches
- **4 new .f90 files** in arnoldjjms/main only

## Critical Changes with Potential Conflicts

### 1. cbn_rsd_decomp.f90
**arnoldjjms changes:**
- Moved underflow prevention checks BEFORE decomposition calculation
- Added guard against division by zero when meta carbon is very small
- Added nitrogen and phosphorus handling in decomposition with proper guards

**Current branch changes:**
- Added underflow checks AFTER decomposition
- Guard for N/P partitioning logic

**CONFLICT RISK**: HIGH - Both branches modified the same function
**Resolution needed**: arnoldjjms version has better logic (prevents issues before they occur)

### 2. hru_control.f90
**arnoldjjms changes:**
- Added pl_rootfr call to distribute roots
- Added cswat guard around rsd_decomp call
- Fixed typo in comment ("aoil" -> "soil")

**Current branch changes:**
- Time step adjustments for flow conversions (from commits in current branch)

**CONFLICT RISK**: MEDIUM - Different sections modified
**Resolution**: Can likely merge both sets of changes

### 3. Water Allocation Files (wallo_*.f90, water_allocation_*.f90)
**arnoldjjms changes:**
- Added canal support (wallo_canal.f90, water_canal_read.f90)
- Added water_orcv_read.f90
- Significant refactoring of water allocation logic
- Split water_allocation_read into multiple functions

**Current branch changes:**
- Not significantly modified in recent commits

**CONFLICT RISK**: LOW - arnoldjjms has major new features
**Resolution**: Accept arnoldjjms changes (new functionality)

### 4. pl_rootfr.f90
**arnoldjjms changes:**
- Major restructuring of root fraction calculations
- Better handling of root distribution

**Current branch changes:**
- Root distribution and tracking features

**CONFLICT RISK**: MEDIUM-HIGH - Both have modifications
**Resolution**: Need detailed review

### 5. Soil and Groundwater Files
**Files:** gwflow_read.f90, gwflow_simulate.f90, gwflow_soil.f90, soils_test_adjust.f90

**Current branch changes:**
- Bug fixes for gwflow module (accumulate solute mass, reset hru_soil)
- Clarify comment in gwflow.input
- Soil test insertion and adjustment logic

**arnoldjjms changes:**
- Not significantly modified

**CONFLICT RISK**: LOW - Current branch has newer fixes
**Resolution**: Keep current branch changes, no conflict with arnoldjjms

### 6. utils.f90
**arnoldjjms changes:**
- Better backwards compatibility for table reading
- Handling description columns and unit rows

**Current branch changes:**
- Added table_reader type and methods

**CONFLICT RISK**: MEDIUM - Both modified utility functions
**Resolution**: Need to merge both improvements

### 7. Output Files (hru_output.f90, output_landscape_module.f90)
**Current branch changes:**
- Corrected units line for hru_ls files
- Increased field width for output losses

**arnoldjjms changes:**
- Different output formatting changes

**CONFLICT RISK**: MEDIUM
**Resolution**: Review to ensure both formatting improvements are included

## New Files in arnoldjjms/main (Must be Added)

1. **src/cbn_surfres_decomp.f90** - New surface residue decomposition routine
2. **src/wallo_canal.f90** - Canal control for water allocation
3. **src/water_canal_read.f90** - Read canal configurations
4. **src/water_orcv_read.f90** - Read water orcv configurations

## Files with No Conflicts (Low Risk)

These files are modified in arnoldjjms but not significantly changed in current branch:
- carbon_coef_read.f90
- carbon_module.f90
- ero_cfactor.f90
- fcgd.f90
- mgt_killop.f90
- nut_nminrl.f90
- organic_mineral_mass_module.f90
- ru_control.f90
- soil_module.f90
- soil_nutcarb_write.f90
- soils_init.f90
