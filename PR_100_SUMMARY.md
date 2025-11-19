# Summary of Pull Request #100: "Main copy"

**PR Number:** 100  
**Status:** Merged  
**Merged Date:** 2025-11-19T23:01:25Z  
**Author:** tugraskan  
**Title:** Main copy  
**Branch:** main_copy → NAM_Copy  

## Overview
This pull request contains significant updates to the SWAT+ model repository, primarily focusing on model configuration improvements, data enhancements, and build system updates. The PR includes **123 changed files** with **9,459 additions** and **3,286 deletions** across **300 commits**.

---

## Major Changes

### 1. **Data and Configuration Updates (Ames_sub1 Dataset)**

#### Carbon Modeling Improvements
- **Added:** `carb_coefs.cbn` - A comprehensive carbon coefficients file with expanded parameters
- **Removed:** `carbon_coef.cbn` - Replaced with the more detailed version
- **Impact:** Improved carbon modeling capabilities with more granular control over:
  - Carbon database coefficients (hp_rate, hs_rate, microb_rate, etc.)
  - Organic allocation coefficients (a1co2, asco2, apco2, abco2)
  - Carbon water partitioning (prmt_21, prmt_44)
  - Tillage effectiveness parameters
  - Manure carbon coefficients
  - Soil test values with depth-specific parameters

#### Decision Table for Irrigation Management
- **Added:** `lum.dtl` - New decision table file enabling conditional irrigation management
- **Features:**
  - Yearly irrigation limits (500 mm threshold)
  - Conditional irrigation triggers based on:
    - Water stress levels
    - Plant heat units (PHU)
    - Leaf area index
  - Multiple decision scenarios (irr_year_irr and irr_year_irr2)
- **Updated:** `file.cio` to reference the new decision table

#### Irrigation Operations
- **Added:** `sprinkler_ilm` operation to `irr.ops`
- **Purpose:** Support for irrigation limit management scenarios
- **Parameters:** 25mm application, 85% efficiency

#### Land Use Management
- **Added:** `cosy_lum2` management scenario
- **Modified:** `cosy_lum` to reference new management practices
- **Updated:** `management.sch` with 305 operations (from 304)
  - Added irrigation monitoring operations (irrm)
  - Integrated decision table references for automated irrigation
  - Expanded management schedules for multiple scenarios (mgt_01, mgt_01A, mgt_02)

#### Soil Configuration
- **Added:** Two new soil profiles with high-resolution sampling:
  - `soil_01-h1`: 4-layer profile with 150mm top layer characterization
  - `soil_03-h3`: 4-layer profile with 150mm top layer characterization
- **Modified:** `hru-data.hru` to use specific soil layers for precise parameter mapping
- **Added:** 150mm depth layer in `soil_lyr_depths.sol`
- **Purpose:** Enable carbon coefficient soil test calibration at 150mm depth

#### Tillage Operations
- **Added:** `biomix` (biological mixing) operation to `tillage.til`

#### Print Configuration
- **Modified:** `print.prt`:
  - Changed `dbout` (database output) to `use_obj_lbls` (use object labels)
  - Removed `hru_cb` and `hru_cb_vars` carbon balance outputs
  - Optimized output settings for performance

---

### 2. **Build System Improvements (CMakeLists.txt)**

#### Fortran Preprocessing Support
- **Intel Compilers (ifo/ifx):** Added `-fpp` (UNIX) and `/fpp` (Windows) flags
- **GNU Compilers (gfortran):** Added `-cpp` flag for both UNIX and Windows
- **Impact:** Consistent preprocessing across all supported compilers and platforms

#### Python Detection
- **Changed:** `find_package(Python3 REQUIRED)` → `find_package(Python3 QUIET)`
- **Benefit:** More flexible build process, doesn't fail if Python3 is unavailable

#### Windows Build Optimization
- **Modified:** Commented out static linking for IntelLLVM on Windows
- **Reason:** Improve build portability and compatibility

---

### 3. **Source Code Enhancements**

#### Irrigation Management (`src/actions.f90`)
- **Enhanced:** Irrigation demand tracking with yearly accumulation
- **Added:** `hru(j)%irr_yr` variable to track yearly irrigation totals
- **Purpose:** Support decision table conditioning based on annual irrigation limits

#### Carbon Coefficient Reading (`src/carbon_coef_read.f90`)
- **Major Refactor:** Complete rewrite of carbon coefficient file reading
- **New Features:**
  - Flexible, name-based variable reading (not position-dependent)
  - Support for comment lines (lines starting with #)
  - Soil test data reading with validation
  - Comprehensive error handling and validation
- **New Variables Supported:**
  - `prmt_21`, `prmt_44`: Carbon water partitioning
  - `till_eff_days`: Tillage effectiveness duration
  - `rtof`, `man_to_c`: Manure conversion coefficients
  - `meta_frac`, `str_frac`, `lig_frac`: Residue partitioning fractions
  - `nmbr_soil_tests` and `soil_test`: Soil test data arrays

#### Print Code Management (`src/basin_print_codes_read.f90`)
- **Added:** Label-based print object reading
- **Feature:** 450+ lines of case-select logic for flexible output configuration
- **Benefits:**
  - Order-independent object specification
  - Duplicate detection
  - Better error reporting

#### Carbon Module (`src/carbon_module.f90`)
- **Added:** `manure_coef` type for manure-specific coefficients
- **Added:** `carbon_water_coef` type for water/sediment carbon loss parameters
- **Reorganized:** Organic allocation structure for better clarity

#### Residue Decomposition (`src/cbn_rsd_decomp.f90`)
- **Cleaned:** Removed 59 lines of commented legacy code
- **Added:** Underflow error prevention for gfortran compatibility
- **Updated:** Residue partitioning to use configurable fractions (meta_frac, str_frac, lig_frac)

#### Harvest Operations (`src/actions.f90`)
- **Updated:** `mgt_harvresidue` function signature to include harvest operation parameter
- **Added:** Plant index reset after burn operations for correct output
- **Fixed:** Variable naming consistency (dmd → trn for transfer operations)

#### Aquifer Pesticide Decay (`src/aqu_1d_control.f90`)
- **Fixed:** Threshold check changed from `> 1.e-12` to `> 0.`
- **Impact:** More robust pesticide decay calculations

#### Basin Parameters (`src/basin_prm_default.f90`)
- **Added:** Import of utils module
- **Changed:** `exp(-bsn_prm%p_updis)` to `exp_w(-bsn_prm%p_updis)`
- **Purpose:** Use wrapped exponential function for numerical stability

---

### 4. **Osu_1hru Dataset Updates**

#### Irrigation
- **Added:** `sprinkler_ilm` operation to `irr.ops`

#### Decision Table
- **Added:** `irr_year_limit` decision scenario in `lum.dtl`
- **Features:** 
  - Yearly irrigation cap (500mm)
  - PHU-based irrigation cutoff (70% heat units)
  - Demand-based irrigation with sprinkler_ilm operation

---

### 5. **New Files Added to Data Directory**

- **`data/hru-data.hru`:** 14-entry HRU data file with references to new land use management scenarios (cosy_lum, cosy_lum2, cosy_lum3)
- **`data/landuse.lum`:** 24-entry land use management file with complete management scenario definitions
- **`data/management.sch`:** 4,321-line comprehensive management schedule file

---

### 6. **Miscellaneous Improvements**

#### Git Configuration
- **Updated:** `.gitignore` to exclude `[Tt]mp/` directories

#### Source Code Cleanup
- **Removed:** Obsolete comments and legacy code sections
- **Added:** Blank lines for improved code readability (`src/cal_conditions.f90`)
- **Removed:** Outdated comment in `src/allocate_parms.f90`

#### Fortran File
- **Added:** `basin_print_codes_read copy.f90` - Appears to be a backup/development copy of the print codes reader

---

## Statistics

- **Total Files Changed:** 123
- **Total Commits:** 300
- **Lines Added:** 9,459
- **Lines Deleted:** 3,286
- **Net Change:** +6,173 lines
- **Comments:** 2 PR comments, 1 review comment

---

## Impact Assessment

### High Impact Changes:
1. **Carbon Modeling:** Significantly enhanced flexibility and precision
2. **Irrigation Management:** New decision-based automation capabilities
3. **Build System:** Improved cross-platform and cross-compiler support
4. **Data Structure:** Better soil characterization with depth-specific parameters

### Medium Impact Changes:
1. **Code Organization:** Improved readability and maintainability
2. **Error Handling:** Better validation and user feedback
3. **Numerical Stability:** Underflow protection and wrapped functions

### Low Impact Changes:
1. **File Organization:** Additional data files for reference
2. **Code Cleanup:** Removal of commented legacy code
3. **Git Configuration:** Improved ignore patterns

---

## Technical Debt and Considerations

1. **Duplicate File:** `basin_print_codes_read copy.f90` should be reviewed - appears to be a development artifact
2. **Large Management Schedule:** 4,321-line `management.sch` file may benefit from modularization
3. **Breaking Changes:** Carbon coefficient file format change (`carbon_coef.cbn` → `carb_coefs.cbn`) requires user intervention for existing projects

---

## Recommendations for Users

1. **Update Carbon Files:** Replace `carbon_coef.cbn` with new `carb_coefs.cbn` format
2. **Review Irrigation:** Check decision table logic if using automated irrigation
3. **Rebuild Project:** Clean build recommended due to compiler flag changes
4. **Soil Parameters:** Consider using new depth-specific soil profiles for improved accuracy
5. **Print Configuration:** Update `print.prt` if using custom print settings (note removed variables)

---

## Summary

PR #100 represents a comprehensive update to the SWAT+ model, focusing on enhanced carbon modeling, automated irrigation management, and improved build system portability. The changes span model configuration, source code, and data files, providing users with more flexibility and precision in modeling agricultural and hydrological systems. The addition of decision tables and enhanced carbon coefficients are particularly notable improvements that expand the model's capabilities for scenario analysis and calibration.
