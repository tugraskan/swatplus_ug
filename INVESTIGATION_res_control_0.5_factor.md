# Investigation Report: 0.5 Factor in res_control.f90

## Summary
This report investigates the use of a 0.5 multiplier for `pvol_m3` and `evol_m3` variables in `res_control.f90`, specifically at lines 59-60.

## Location of the Code
**File:** `src/res_control.f90`  
**Lines:** 59-60

```fortran
pvol_m3 = 0.5 * res_ob(jres)%pvol
evol_m3 = 0.5 * res_ob(jres)%evol
```

## Variable Definitions

### pvol (Principal Volume)
- **Type:** Real
- **Units:** ha-m (read in), converted to m³ in code
- **Description:** Volume of water needed to fill the reservoir to the principal spillway
- **Location in module:** `reservoir_module.f90`, line 20 (for reservoir type)
- **Conversion:** `res_ob(ires)%pvol = res_hyd(ires)%pvol * 10000.` (ha-m => m³) in `res_initial.f90`

### evol (Emergency Volume)
- **Type:** Real
- **Units:** ha-m (read in), converted to m³ in code
- **Description:** Volume of water needed to fill the reservoir to the emergency spillway
- **Location in module:** `reservoir_module.f90`, line 22 (for reservoir type)
- **Conversion:** `res_ob(ires)%evol = res_hyd(ires)%evol * 10000.` (ha-m => m³) in `res_initial.f90`

## Git History Analysis

### Current Status
- **Last commit affecting this file:** `8f6717a7d0eff653cde90a18ab5350a07e717b13`
- **Author:** Olaf David
- **Date:** Wed Jan 21 14:54:11 2026 -0700
- **Commit message:** "Merge pull request #149 from odav/main - reverting missing static link, it got lost earlier."
- **Note:** This commit is grafted (indicated by `^` in git blame), meaning the full history before this point is not available in this repository

### History Limitation
The repository appears to have been grafted at commit `8f6717a`, which means:
- The file was introduced at this grafted commit with the 0.5 factor already present
- No earlier history is available to determine when or why the 0.5 factor was originally added
- The full evolutionary history of this calculation is not preserved in the current repository

## Usage of pvol_m3 and evol_m3

The calculated values are passed to `res_hydro` subroutine:
```fortran
call res_hydro (jres, irel, pvol_m3, evol_m3)
```

### How These Values Are Used in res_hydro.f90

1. **rate_pct** (line 74): Release at percentage of principal volume
   ```fortran
   ht2%flo = ht2%flo + d_tbl%act(iac)%const * pvol_m3 / 100.
   ```

2. **ab_emer** (line 86): Release all volume above emergency
   ```fortran
   if (wbody%flo > evol_m3) ht2%flo = ht2%flo + (wbody%flo - evol_m3)
   ```

3. **days** (lines 93-99): Release based on drawdown days
   ```fortran
   case ("pvol")
     b_lo = pvol_m3 * d_tbl%act(iac)%const2
   case ("evol")
     b_lo = evol_m3 * d_tbl%act(iac)%const2
   ```

4. **dyrt** (lines 108-116): Release based on drawdown days + percentage of principal volume
   ```fortran
   case ("pvol")
     b_lo = pvol_m3
   case ("evol")
     b_lo = evol_m3
   ```

5. **dyrt1** (lines 131-144): Complex calculation using both volumes
   ```fortran
   b_lo = pvol_m3 + (evol_m3 - pvol_m3) * d_tbl%cond(ic)%lim_const
   b_lo = (evol_m3 - pvol_m3) * d_tbl%cond(ic)%lim_const
   # ... other operations
   ```

6. **inflo_targ** (lines 147-152): Release inflow + all volume over target
   ```fortran
   b_lo = pvol_m3 * d_tbl%cond(ic)%lim_const
   ```

## Key Finding: Inconsistency with Wetland Implementation

**IMPORTANT:** In `wetland_control.f90` (lines 176-177), the **full** values are used without the 0.5 factor:
```fortran
pvol_m3 = wet_ob(j)%pvol
evol_m3 = wet_ob(j)%evol
```

Then calls the same subroutine:
```fortran
call res_hydro (j, irel, pvol_m3, evol_m3)
```

### Comparison Table

| Feature | Reservoir (res_control.f90) | Wetland (wetland_control.f90) |
|---------|----------------------------|-------------------------------|
| pvol_m3 calculation | `0.5 * res_ob(jres)%pvol` | `wet_ob(j)%pvol` |
| evol_m3 calculation | `0.5 * res_ob(jres)%evol` | `wet_ob(j)%evol` |
| Multiplier | **0.5** | **1.0** (no multiplier) |
| Called subroutine | `res_hydro()` | `res_hydro()` (same) |

This suggests that:
1. The 0.5 factor is **specific to reservoirs** and not used for wetlands
2. There is an intentional difference in how reservoir and wetland releases are calculated
3. The 0.5 factor likely serves a specific hydraulic or operational purpose for reservoir management
4. Both use the same `res_hydro()` function but with different reference volumes

## Potential Reasons for the 0.5 Factor

Based on the analysis, here are the most likely explanations for the 0.5 multiplier:

### 1. **Conservation Buffer (Most Likely)**
The 0.5 factor may represent a conservative approach to reservoir management:
- Using 50% of principal/emergency volumes as reference points prevents over-release
- Provides a safety margin for reservoir operations
- Ensures more water is retained in the reservoir during release calculations

### 2. **Effective Storage Volume**
The factor might represent the "effective" or "active" storage volume:
- Total volume vs. usable volume distinction
- Dead storage or sediment accumulation considerations
- Only half of the nominal volume is actively available for release decisions

### 3. **Operational Pool Concept**
Could represent different operational zones:
- Full volume represents physical capacity
- 0.5 × volume represents normal operating pool
- Difference represents flood control or buffer storage

### 4. **Hydraulic Averaging**
May be related to average hydraulic conditions:
- Average water level during operations
- Mean operating depth considerations
- Transition zone between different release strategies

### 5. **Empirical Calibration**
The factor might be based on:
- Empirical observations from reservoir operations
- Calibration to match observed reservoir behavior
- Historical performance data suggesting 50% is optimal

## Recommendations for Further Investigation

1. **Check Upstream SWAT+ Repository**: 
   - This is a fork of https://github.com/swat-model/swatplus
   - Check the official repository for full git history
   - The file may have more commits and documentation there
   - Contact: USDA Agricultural Research Service and Texas A&M AgriLife Research

2. **Check Original SWAT+ Documentation**: 
   - Review SWAT+ theoretical documentation at https://swatplus.gitbook.io/docs
   - Check SWAT+ Source Documentation at https://swat-model.github.io/swatplus
   - Look for reservoir operation algorithms and decision table documentation

3. **Search Older Versions**:
   - Check older SWAT+ versions on Bitbucket: https://bitbucket.org/blacklandgrasslandmodels/modular_swatplus/src/master
   - May have commit history or documentation explaining the change

4. **Consult Development Team**: 
   - Contact Olaf David (commit author) or other developers
   - SWAT team at TAMU: https://swat.tamu.edu
   - May have internal documentation or design decisions

5. **Test Sensitivity**: 
   - Run model simulations with different factors (0.25, 0.5, 0.75, 1.0)
   - Compare with observed reservoir behavior
   - Understand impact on release decisions and water balance

6. **Review Scientific Literature**: 
   - Check published papers using SWAT+ reservoir module
   - Look for validation studies discussing reservoir operations
   - Search for any discussion of the parameter

7. **Compare with SWAT2012**: 
   - Compare with older SWAT versions to see when it was introduced
   - Check if this is a new SWAT+ feature or existed in earlier versions

8. **Consider Making it Configurable**: 
   - If the 0.5 factor is empirical or site-specific, consider making it a user-configurable parameter
   - Add to reservoir input files (e.g., `reservoir.res` or decision table files)
   - Would allow users to calibrate for their specific conditions

## Conclusion

The 0.5 factor in `res_control.f90` was present from the earliest available commit in this repository (grafted commit `8f6717a` from Jan 21, 2026). The factor is applied specifically to reservoirs but NOT to wetlands, suggesting it serves a specific purpose in reservoir management. The most likely explanation is that it provides a conservative approach to reservoir operations, using 50% of the nominal volumes as reference points for release decisions.

Without access to the full git history or original documentation, the exact reason remains somewhat speculative, but the consistent application and the difference from wetland handling suggests this is an intentional design choice rather than an error.

## Impact Analysis: What Would Change Without the 0.5 Factor?

If the 0.5 multiplier were removed (changed to 1.0), the following release calculations in `res_hydro()` would be affected:

### 1. **Percentage-based releases (rate_pct)** 
**Current:** `ht2%flo = ht2%flo + d_tbl%act(iac)%const * (0.5 * pvol) / 100.`  
**Without 0.5:** `ht2%flo = ht2%flo + d_tbl%act(iac)%const * pvol / 100.`  
**Impact:** Release rates would **double** for percentage-based releases

### 2. **Emergency volume threshold (ab_emer)**
**Current:** Releases when `wbody%flo > (0.5 * evol)`  
**Without 0.5:** Releases when `wbody%flo > evol`  
**Impact:** Emergency releases would trigger **less frequently** (only at higher water levels)

### 3. **Drawdown calculations (days, dyrt, dyrt1)**
**Current:** Uses 50% of volumes as base levels  
**Without 0.5:** Uses 100% of volumes as base levels  
**Impact:** More aggressive drawdown since base level would be higher

### 4. **Target-based releases (inflo_targ)**
**Current:** Target = `0.5 * pvol * const`  
**Without 0.5:** Target = `pvol * const`  
**Impact:** Higher target volumes, potentially more conservative operations

### Summary of Potential Impacts
- **With 0.5 factor** (current): More conservative reservoir operations, releases happen sooner/easier
- **Without 0.5 factor** (like wetlands): Less conservative, higher thresholds, releases happen later
- **Effect on water balance**: Current approach keeps reservoirs at lower levels on average
- **Effect on flood control**: Current approach provides more buffer capacity for flood events

## Investigation Date
January 29, 2026

## Files Examined
- `src/res_control.f90` (primary file of interest)
- `src/res_hydro.f90` (where pvol_m3 and evol_m3 are used)
- `src/wetland_control.f90` (comparison - no 0.5 factor)
- `src/reservoir_module.f90` (type definitions)
- `src/res_initial.f90` (initialization and unit conversion)
