# Merge Analysis: tugraskan/swatplus_ug vs arnoldjjms/swatplus_ug

## Executive Summary

- **Current Branch**: `copilot/check-diff-and-conflicts`
- **Target Branch**: `arnoldjjms/main`
- **Commits Ahead**: 2
- **Commits Behind**: 789
- **Status**: Unrelated histories - requires `--allow-unrelated-histories` flag
- **Merge Conflicts**: 102+ files (both source code and reference data)

## Branch Relationship

The two branches have **unrelated histories**, meaning they don't share a common ancestor in the Git history. This indicates that the repositories diverged at some point or were initialized separately.

### Commits Ahead (2)
1. `fa106e8` - Initial plan
2. `7a7e391` - Merge pull request #156 from tugraskan/Jaehak_02042026

### Commits Behind (789 total)

The arnoldjjms/main branch contains 789 commits that are not in the current branch. Here are the most recent ones categorized by functionality:

#### Recent Commits by Category

##### Bug Fixes
- `83b1dee` (2026-02-12) - fixed no3 and nh4 blopup in cbn_zhang2
- `0af2e22` (2026-01-14) - added chack for required columns in utils.f90
- `0d74307` (2026-01-07) - Fixed Warnings, removed unused variable declarations and update external function references

##### Water Allocation Features
- `52ab1cd` (2026-02-10) - Residue pool updates. Added canals to water allocation and can have multiple channels within a water allocation object
- `423ab74` (2026-01-21) - split water_allocation_read
- `3a44d93` (2026-01-21) - water_allo updates
- `72206bc` (2026-01-06) - Enhance water allocation with recall support and update soil cover calculations
- `815ec79` (2025-11-19) - water allocation updates

##### Build System / CMake Improvements
- `25455d2` (2026-01-14) - Remove static linking condition for ifx compiler Fedora in CMake configuration
- `96d19e3` (2025-12-31) - Updated CMakeList.txt to check for ifx build on unix to not set the .static link_libraries setting
- `3e103a8` (2025-12-31) - Updated CMakeList.txt configuration to include Fedora in static link check
- `5de3eb9` (2025-12-30) - Enable static linking for winlibs GNU Fortran compiler on windows
- `baad8a7` (2025-12-29) - Update CMake configuration for improved OS detection and static linking

##### Utility Functions / Infrastructure
- `7218654` (2026-01-14) - Add table_reader type to utils.f90 and associated methods for file data handling
- `059bc50` (2025-12-19) - update launch.json with new data path

##### Documentation
- `7f44392` (2026-01-09) - Modify build instructions to direct users to make github issue
- `1e02118` (2026-01-05) - Add instructions on compiling with dynamic lib + fix floating error

##### Wetland & Residue Management
- `10fc6ab` (2026-01-06) - wetland issues resolved and residue stored by plant type
- `fd3d90f` (2025-12-08) - made changes to include residue partition fractions

##### Output Management
- `9299ca5` (2025-12-04) - allow specifying output directory
- `406df33` (2025-12-04) - fix creation of empty file when daily channel output is disabled
- `374c54c` (2025-12-04) - make crop_yld output to respect print.prt option

##### Merge Commits
Multiple merge commits from contributors:
- Atreyagaurav
- odav
- fgeter
- celray
- crazyzlj
- Nbsammons

## Merge Conflicts

When attempting to merge with `--allow-unrelated-histories`, the following types of conflicts occur:

### Conflict Categories

#### 1. Source Code Files (48+ conflicts)
Key conflicted source files:
- `src/actions.f90`
- `src/carbon_coef_read.f90`
- `src/carbon_module.f90`
- `src/cbn_rsd_decomp.f90`
- `src/cbn_zhang2.f90`
- `src/command.f90`
- `src/ero_cfactor.f90`
- `src/fcgd.f90`
- `src/gwflow_*.f90` (multiple files)
- `src/hru_*.f90` (multiple files)
- `src/mgt_*.f90` (multiple files)
- `src/nut_*.f90` (multiple files)
- `src/pl_*.f90` (multiple files)
- `src/plant_*.f90` (multiple files)
- `src/recall_*.f90` (multiple files)
- `src/soil_*.f90` (multiple files)
- `src/wallo_*.f90` (multiple files)
- `src/water_*.f90` (multiple files)
- `src/wetland_control.f90`
- `src/utils.f90`

#### 2. Build Configuration (1 conflict)
- `CMakeLists.txt`

#### 3. Reference Data Files (50+ conflicts in refdata/Ames_sub1/)
- Weather data: `ames.pcp`, `ames.tem`
- Configuration files: Various `.lum`, `.ops`, `.hru`, `.sol`, `.plt`, etc.
- All conflicts are "add/add" type, meaning both branches have different versions of the same files

## Key Differences Analysis

### Major Functional Areas Changed

1. **Water Allocation System**: Significant updates including:
   - Canal support
   - Multiple channel support
   - Recall integration
   - Split reading functionality

2. **Carbon and Nutrient Cycling**:
   - NO3 and NH4 bug fixes
   - Residue decomposition updates
   - Carbon coefficient reading changes

3. **Soil and Plant Management**:
   - Plant residue partitioning
   - Root growth calculations
   - Soil cover calculations
   - Wetland management

4. **Build System**:
   - Cross-platform compiler support (gfortran, ifx, winlibs)
   - Static vs dynamic linking improvements
   - OS-specific configurations

5. **Utilities and Infrastructure**:
   - Table reader functionality
   - File data handling
   - Output directory configuration

## Recommended Merge Strategy

Given the complexity and number of conflicts, here are recommended approaches:

### Option 1: Accept Their Changes (Recommended for most cases)
```bash
git merge --allow-unrelated-histories -X theirs arnoldjjms/main
```
This accepts all changes from arnoldjjms/main where there are conflicts.

### Option 2: Manual Conflict Resolution
For critical files where local changes must be preserved:
1. Merge with conflicts
2. Review each conflict manually
3. Keep necessary local changes
4. Accept upstream improvements

### Option 3: Cherry-pick Specific Commits
For a more controlled integration:
1. Identify specific commit ranges by functionality
2. Cherry-pick commits in logical groups
3. Resolve conflicts incrementally

## Suggested Commit Reorganization by Functionality

If reorganizing the 789 commits into logical groups:

### Group 1: Build System & Infrastructure (50-60 commits)
- CMake configuration updates
- Compiler compatibility fixes
- Cross-platform support

### Group 2: Water Allocation Module (40-50 commits)
- Core water allocation features
- Canal and channel support
- Recall integration
- Reading/parsing updates

### Group 3: Carbon & Nutrient Cycling (30-40 commits)
- Residue decomposition
- Carbon coefficient updates
- NO3/NH4 fixes
- Organic matter processing

### Group 4: Plant & Soil Management (40-50 commits)
- Root growth updates
- Plant initialization
- Soil cover calculations
- Wetland management

### Group 5: Output & Reporting (20-30 commits)
- Output directory configuration
- Print option respect
- Diagnostic improvements

### Group 6: Bug Fixes & Warnings (30-40 commits)
- Compiler warning fixes
- Unused variable cleanup
- Edge case fixes

### Group 7: Documentation (10-20 commits)
- Build instructions
- Compilation guides
- README updates

### Group 8: Utility Functions (20-30 commits)
- Table reader
- File handling
- Helper functions

### Group 9: Testing & Validation (30-40 commits)
- Test data updates
- Reference data changes
- Validation improvements

### Group 10: Merge Commits & Integration (remaining)
- Various merge commits from contributors

## Next Steps

1. **Decision Required**: Choose merge strategy based on:
   - How much of the local changes need to be preserved
   - Whether reference data should come from upstream
   - Critical local modifications that can't be lost

2. **Prepare for Merge**:
   - Backup current branch
   - Create a detailed conflict resolution plan
   - Test merged code thoroughly

3. **Post-Merge Validation**:
   - Run all tests
   - Verify critical functionality
   - Review all resolved conflicts

4. **Commit Reorganization** (if desired):
   - Use interactive rebase on the merged result
   - Group related changes together
   - Create clean, logical commit history

## Files Summary

Total files with differences: 100+
- Source files (.f90): 48+
- Reference data files: 50+
- Build files: 1
- Other: Various configuration and output files
