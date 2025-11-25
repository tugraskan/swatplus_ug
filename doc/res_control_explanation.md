# Explanation of res_control.f90

## Overview

The `res_control` subroutine is the main control routine for simulating reservoir water balance and constituent dynamics in SWAT+. It manages the daily simulation of reservoir processes including hydrology, sediment, nutrients, pesticides, salts, and other constituents.

## When is res_control called?

`res_control` is called from `command.f90` (line ~313) during the main simulation routing loop:

```fortran
case ("res")   ! reservoir
  ires = ob(icmd)%num
  if (ob(icmd)%rcv_tot > 0) then
    call res_control (ires)
  end if
```

It is invoked for each reservoir object (`"res"`) in the simulation command sequence when there are incoming flows (`rcv_tot > 0`).

## What does res_control do?

The subroutine performs the following key operations in sequence:

### 1. Initialize Flow Variables
- Sets incoming flow (`ht1`) from the upstream objects
- Zeros outgoing flow, sediment, and nutrient variables (`ht2`)
- Zeros outgoing constituents (`hcs2`)

### 2. Check Reservoir Construction Status
The reservoir simulation only proceeds if the reservoir has been constructed (based on `iyres` and `mores` parameters in `res_hyd`).

### 3. Climate Adjustments
- Adjusts precipitation and temperature for elevation using lapse rates if enabled

### 4. Add Incoming Flow
- Adds incoming flow (`ht1`) to reservoir storage

### 5. Determine Release Decision
Two methods are supported based on `res_ob(jres)%rel_tbl`:
- **Decision Table ("d")**: Uses `res_hydro` subroutine with decision tables
- **Conditions Table ("c")**: Uses `res_rel_conds` subroutine

### 6. Calculate Water Balance
- Evaporation: `evap = 10 * evrsv * PET * area_ha`
- Precipitation: `precip = 10 * precip * area_ha`
- Seepage: `seep = 240 * k * area_ha` (if gwflow not active)

### 7. Update Reservoir Storage
- Add precipitation
- Subtract outflow
- Subtract evaporation
- Subtract seepage
- Update surface area using volume-area relationship

### 8. Process Constituents
- Nutrients via `res_nutrient`
- Pesticides via `res_pest`
- Salts via `res_salt`
- Constituents via `res_cs`

### 9. Set Output Variables
- Sets outflow hydrograph (`ob(icmd)%hd(1)`)
- Records input/output for reporting

## Why are pvol and evol multiplied by 0.5?

In `res_control.f90` at lines 59-60:

```fortran
pvol_m3 = 0.5 * res_ob(jres)%pvol
evol_m3 = 0.5 * res_ob(jres)%evol
```

### Current Implementation Issue

**This appears to be a potential bug or inconsistency in the code.** Here's why:

1. **Comparison with wetland_control.f90**: In the wetland control subroutine (lines 176-177), the same values are passed without the 0.5 multiplier:
   ```fortran
   pvol_m3 = wet_ob(j)%pvol
   evol_m3 = wet_ob(j)%evol
   ```

2. **Definition of pvol and evol**: According to `reservoir_module.f90`:
   - `pvol`: Volume of water needed to fill the reservoir to the **principal spillway** (in m³)
   - `evol`: Volume of water needed to fill the reservoir to the **emergency spillway** (in m³)

3. **Impact on Release Decisions**: In `res_hydro`, these values are used for:
   - `"rate_pct"`: Release as percentage of principal volume
   - `"ab_emer"`: Release volume above emergency level
   - `"days"` and `"dyrt"`: Drawdown calculations using pvol/evol as base

4. **Condition Checking Discrepancy**: In `conditions.f90`, the full `res_ob(ires)%pvol` and `res_ob(ires)%evol` values are used for volume condition checks (lines 740-767). This means:
   - Conditions are evaluated using **100% of pvol/evol**
   - But release actions use **50% of pvol/evol**
   
   This creates an inconsistency where a condition might be triggered at one volume threshold, but the release action uses a different (halved) threshold.

### Possible Explanations

1. **Historical Averaging**: The 0.5 factor might have been intended to represent some form of averaging (e.g., between beginning and end of day storage), but this is not documented.

2. **Conservative Release**: It could be a conservative approach to prevent over-release, but this would typically be handled through the decision table parameters, not by halving the reference volumes.

3. **Coding Error**: Given the inconsistency with `wetland_control.f90` and the condition checking in `conditions.f90`, this may be an unintentional error.

### Recommendation

The 0.5 multiplier should be reviewed and either:
1. **Removed** to be consistent with `wetland_control.f90` and the condition checking logic
2. **Documented** with clear rationale if it serves a specific purpose

## Key Data Structures

- `res_ob(jres)`: Reservoir object containing pvol, evol, and other physical properties
- `res(jres)`: Reservoir state variables (flo, sed, nutrients, etc.)
- `res_hyd(jres)`: Reservoir hydrological parameters
- `res_wat_d(jres)`: Daily reservoir water balance outputs
- `d_tbl` / `dtbl_res(irel)`: Decision table for release rules

## File Dependencies

- `reservoir_module.f90`: Module definitions
- `reservoir_data_module.f90`: Data structures
- `conditional_module.f90`: Decision table structures
- `res_hydro.f90`: Hydrology release calculations
- `conditions.f90`: Condition evaluation
- `res_nutrient.f90`, `res_pest.f90`, `res_salt.f90`, `res_cs.f90`: Constituent processes
