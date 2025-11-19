# PR #100 Source Code Changes - Detailed Breakdown by .f90 File

This document provides a detailed breakdown of each source code change in PR #100 "Main copy", focusing exclusively on the Fortran (.f90) files.

---

## 1. actions.f90

**Purpose**: Main action execution for decision table operations

**Changes**:
- Renamed variable `idmd` → `itrn` (transaction/transfer naming for manure allocation)
- Updated manure demand logic: `mallo(imallo)%dmd(idmd)` → `mallo(imallo)%trn(itrn)`
- Changed irrigation demand output label: `"IRRIG_DMD"` → `"IRRIG_trn"`
- **Added yearly irrigation tracking**: New line after irrigation actions:
  ```fortran
  hru(j)%irr_yr = hru(j)%irr_yr + irrig(j)%applied
  ```
  This accumulates irrigation amounts for decision table conditioning
- Updated harvest residue calls to include harvest operation parameter:
  - `call mgt_harvresidue (j, harveff)` → `call mgt_harvresidue (j, harveff, iharvop)`
- Modified reservoir storage demand calculations:
  - Changed variable names: `dmd_m3` → `trn_m3` for consistency
- **Added plant index reset after burn operation**: Ensures correct output after burning by setting `ipl = 1`

**Impact**: Enables yearly irrigation limits in decision tables, improves naming consistency

---

## 2. allocate_parms.f90

**Purpose**: Memory allocation for model parameters

**Changes**:
- Removed outdated comment line:
  ```fortran
  - !!  added per JGA for Srini by gsm 9/8/2011
  ```

**Impact**: Code cleanup, no functional change

---

## 3. aqu_1d_control.f90

**Purpose**: 1D aquifer control and pesticide decay

**Changes**:
- Modified pesticide decay threshold check:
  ```fortran
  - if (cs_aqu(iaq)%pest(ipest) > 1.e-12) then
  + if (cs_aqu(iaq)%pest(ipest) > 0.) then
  ```

**Impact**: Simplified numerical threshold, prevents unnecessary precision checks

---

## 4. basin_module.f90

**Purpose**: Basin-level data structures and print control

**Changes**:
- Added `already_read_in` logical flag to `print_interval` type
- Renamed print control variable:
  ```fortran
  - character(len=1) :: carbout = "n"   ! carbon output code
  + character(len=1) :: use_obj_labels = "n"  ! use object labels from print.prt
  ```
- Added explanatory comment for `use_obj_labels`: enables label-based print object identification from first column in print.prt file

**Impact**: Enables flexible print configuration via object name labels instead of fixed row positions

---

## 5. basin_print_codes_read.f90

**Purpose**: Read printing codes from print.prt file

**Changes**: **MAJOR REFACTORING (~450 lines added)**

- Modified CSV/database output reading:
  ```fortran
  - read (107,*) pco%csvout, pco%carbout, pco%cdfout
  + read (107,*) pco%csvout, pco%use_obj_labels, pco%cdfout
  ```

- **Added label-based reading mode**: When `use_obj_labels == "y"`, reads print objects using case-select on object names rather than fixed row positions
  
- Implemented 450+ line `select case` structure with 50+ output object types:
  - `basin_wb`, `basin_nb`, `basin_ls`, `basin_pw`, `basin_aqu`, `basin_res`, `basin_cha`
  - `region_*` variants for all basin outputs
  - `lsunit_*` landscape unit outputs
  - `hru_*` HRU-level outputs including new `hru_cb` and `hru_cb_vars` (carbon balance)
  - `channel`, `channel_sd`, `aquifer`, `reservoir`, `recall`
  - Salt outputs: `basin_salt`, `hru_salt`, `ru_salt`, `aqu_salt`, `channel_salt`, `res_salt`, `wetland_salt`
  - Constituent outputs: `basin_cs`, `hru_cs`, `ru_cs`, `aqu_cs`, `channel_cs`, `res_cs`, `wetland_cs`

- Each case checks `already_read_in` flag to prevent duplicate reading
- Added `print_prt_error()` function calls for validation
- Comprehensive error messages for invalid object names

**Impact**: Allows flexible print.prt file organization, prevents duplicate object definitions, improves error handling

---

## 6. basin_prm_default.f90

**Purpose**: Set default basin parameters

**Changes**:
- Added `use utils` module import
- Modified phosphorus uptake normalization calculation:
  ```fortran
  - uptake%p_norm = 1. - exp(-bsn_prm%p_updis)
  + uptake%p_norm = 1. - exp_w(-bsn_prm%p_updis)
  ```
  Uses wrapped exponential function `exp_w()` to prevent underflow errors

**Impact**: Improved numerical stability

---

## 7. cal_conditions.f90

**Purpose**: Calibration condition checking

**Changes**:
- Added blank line after loop declaration for code formatting

**Impact**: Code formatting only, no functional change

---

## 8. carbon_coef_read.f90

**Purpose**: Read carbon coefficient parameters

**Changes**: **MAJOR REFACTORING (~110 lines added)**

- Changed input filename:
  ```fortran
  - inquire (file='carbon_coef.cbn', exist=i_exist)
  + inquire (file='carb_coefs.cbn', exist=i_exist)
  ```

- **Replaced fixed-format reading with name-based reading**: Uses `select case` on variable names
  
- Supported variables (with validation):
  - **Core carbon rates**: `hp_rate`, `hs_rate`, `microb_rate`, `meta_rate`, `str_rate`, `microb_top_rate`, `hs_hp`
  - **CO2 allocation**: `a1co2`, `asco2`, `apco2`, `abco2`
  - **Water partitioning**: `prmt_21` (KOC for carbon loss), `prmt_44` (soluble C ratio)
  - **Tillage**: `till_eff_days` (days tillage event remains effective)
  - **Manure**: `rtof` (organic N/P partitioning), `man_to_c` (manure solids to carbon conversion = 0.42)
  - **Residue fractions**: `meta_frac` (0.85), `str_frac` (0.15), `lig_frac` (0.12)
  - **Soil test data**: `nmbr_soil_tests`, `soil_test` entries with name, depth, BD, carbon%, sand%, silt%, clay%

- Allows comment lines starting with `#`

- **Soil test validation**:
  - Allocates `sol_test` array based on `nmbr_soil_tests`
  - Validates count matches declared number
  - Checks sand+silt+clay = 100% (if not zero)
  - Stores depth (150mm typical), bulk density, carbon %, texture

- Comprehensive error messages for:
  - Missing `nmbr_soil_tests` before `soil_test` entries
  - Exceeding declared test count
  - Count mismatch
  - Unrecognized variable names

**Impact**: **BREAKING CHANGE** - New file format with 40+ configurable parameters vs. 2-line old format. Enables fine-tuned carbon modeling with soil test data.

---

## 9. carbon_module.f90

**Purpose**: Carbon cycling data structures

**Changes**:
- Moved `abco2` field in `organic_allocations` type from first position to last (after `apco2`)
  
- Added `manure_coef` type with:
  ```fortran
  real :: rtof = 0.5       ! organic N/P partitioning factor
  real :: man_to_c = 0.42  ! manure solids to carbon conversion
  ```
  Instance: `man_coef`

- Added `carbon_water_coef` type with:
  ```fortran
  real :: prmt_21 = 1000.  ! KOC for carbon loss (500-1500)
  real :: prmt_44 = 0.5    ! soluble C ratio runoff:percolate (0.1-1.0)
  ```
  Instance: `cb_wtr_coef`

- Fixed spacing/indentation in `org_flux` declaration

**Impact**: New configurable parameters for manure carbon and water-phase carbon loss

---

## 10. cbn_rsd_decomp.f90

**Purpose**: Carbon residue decomposition

**Changes**:
- Removed 60+ lines of commented-out legacy code for:
  - Old layer indexing (`kk` variable)
  - Active/stable pool flow computations
  - Direct mineralization to NO3/P pools
  - Old denitrification calculations

- **Added underflow protection** after residue decomposition:
  ```fortran
  if (soil1(j)%rsd(k)%m < 1.e-10) soil1(j)%rsd(k)%m = 0.0
  if (soil1(j)%rsd(k)%c < 1.e-10) soil1(j)%rsd(k)%c = 0.0
  if (soil1(j)%rsd(k)%n < 1.e-10) soil1(j)%rsd(k)%n = 0.0
  if (soil1(j)%rsd(k)%p < 1.e-10) soil1(j)%rsd(k)%p = 0.0
  ```
  Prevents gfortran runtime underflow errors

- **Replaced hardcoded fractions** with configurable variables:
  ```fortran
  - soil1(j)%meta(k) = soil1(j)%meta(k) + 0.85 * decomp
  - soil1(j)%str(k) = soil1(j)%str(k) + 0.15 * decomp
  - soil1(j)%lig(k) = soil1(j)%lig(k) + 0.12 * decomp
  + soil1(j)%meta(k) = soil1(j)%meta(k) + meta_frac * decomp
  + soil1(j)%str(k) = soil1(j)%str(k) + str_frac * decomp
  + soil1(j)%lig(k) = soil1(j)%lig(k) + lig_frac * decomp
  ```

**Impact**: Code cleanup, numerical stability, configurable partitioning fractions

---

## Summary Statistics

**Modified .f90 Files**: 10 files shown (45+ total in PR)

**Key Themes**:
1. **Carbon modeling precision**: New file format with 40+ parameters, soil test data, configurable fractions
2. **Decision table irrigation**: Yearly tracking (`irr_yr`) enables annual limits
3. **Print system flexibility**: Label-based configuration with 450+ lines of case-select logic
4. **Numerical stability**: Underflow protection, wrapped exponentials
5. **Code cleanup**: Removed legacy comments, improved naming (dmd→trn)
6. **Error handling**: Comprehensive validation with detailed error messages

**Technical Debt**: Breaking change in carbon coefficient file format requires dataset updates

