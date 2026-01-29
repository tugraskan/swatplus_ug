# Comparison: Old vs Current res_control.f90

## Summary
This document compares an older version of `res_control.f90` with the current version, highlighting all differences and explaining their significance.

## Major Differences

### 1. **External Declarations (NEW in Current Version)**

**Location:** Line 15 (current version)

**Change:**
```fortran
! OLD: (not present)

! CURRENT:
external :: conditions, res_cs, res_hydro, res_nutrient, res_pest, res_rel_conds, res_salt, res_sediment, cli_lapse
```

**Explanation:** 
- Added explicit `external` declaration for subroutines called from this module
- This is a modern Fortran best practice that makes dependencies more explicit
- Helps compilers better optimize and check for interface mismatches
- No functional change to the code behavior

---

### 2. **Variable Initialization (Changed)**

**Location:** Lines 17-29 (current version)

**Old Version:**
```fortran
integer :: ii                   !none          |counter 
integer :: jres                 !none          |reservoir number
integer :: idat                 !              |
integer :: irel                 !              |
integer :: iob                  !none          |counter
integer :: ictbl
integer :: icon                  !! nbs
real :: pvol_m3
real :: evol_m3
real :: dep
real :: weir_hgt
real :: alpha_up
real :: alpha_down
```

**Current Version:**
```fortran
integer :: ii = 0               !none          |counter 
integer :: jres                 !none          |reservoir number
integer :: idat = 0             !              |
integer :: irel = 0             !              |
integer :: iob = 0              !none          |counter
integer :: ictbl = 0
integer :: icon = 0              !! nbs
real :: pvol_m3 = 0.
real :: evol_m3 = 0.
real :: dep = 0.
real :: weir_hgt = 0.
real :: alpha_up = 0.
real :: alpha_down = 0.
```

**Explanation:**
- All local variables are now explicitly initialized to zero
- Prevents undefined behavior from uninitialized variables
- Improves code reliability and reproducibility
- Good defensive programming practice

---

### 3. **Constituent Initialization (NEW)**

**Location:** Line 33 (current version)

**Change:**
```fortran
! OLD:
ht1 = ob(icmd)%hin    !! set incoming flow
ht2 = resz            !! zero outgoing flow

! CURRENT:
ht1 = ob(icmd)%hin    !! set incoming flow
ht2 = resz            !! zero outgoing flow, sediment and nutrients
hcs2 = hin_csz        !! zero outgoing constituents
```

**Explanation:**
- Added initialization of `hcs2` variable for constituent handling
- `hin_csz` appears to be a zero/initialization value for constituents
- Comment on `ht2` clarified to mention sediment and nutrients
- Ensures proper initialization of constituent mass tracking
- Critical for models with water quality components

---

### 4. **THE CRITICAL CHANGE: 0.5 Factor for Volume Calculations** ⚠️

**Location:** Lines 59-60 (current version)

**Old Version:**
```fortran
pvol_m3 = res_ob(jres)%pvol
evol_m3 = res_ob(jres)%evol
```

**Current Version:**
```fortran
pvol_m3 = 0.5 * res_ob(jres)%pvol
evol_m3 = 0.5 * res_ob(jres)%evol
```

**Explanation:**
- **This is the most significant functional change**
- Principal volume (`pvol`) and emergency volume (`evol`) are now multiplied by 0.5
- These values are passed to `res_hydro()` for release calculations
- **Impact:** Changes ALL reservoir release calculations that depend on these volumes
  - Percentage-based releases will use 50% of volumes as reference
  - Emergency thresholds trigger at 50% of nominal emergency volume
  - Drawdown calculations use 50% as base levels
- **Effect:** More conservative reservoir operations, earlier releases, lower operating levels
- **Rationale:** Likely provides safety margin and better flood control capacity
- See `INVESTIGATION_res_control_0.5_factor.md` for detailed analysis

---

### 5. **Lag Smoothing Moved Inside Decision Table Branch** 🔄

**Location:** Lines 70-79 (current version)

**Old Version:**
```fortran
! Inside if(res_ob(jres)%rel_tbl == "d") block:
call conditions (jres, irel)
call res_hydro (jres, irel, pvol_m3, evol_m3)
call res_sediment

! ... then LATER, after water balance calculations:

!! new lag to smooth condition jumps (volume or month conditions)
alpha_up = Exp(-res_ob(jres)%lag_up)
alpha_down = Exp(-res_ob(jres)%lag_down)
!! lag outflow when flows are receeding
if (res_ob(jres)%prev_flo < ht2%flo) then
  ht2%flo = ht2%flo * alpha_up + res_ob(jres)%prev_flo * (1. - alpha_up)
else
  ht2%flo = ht2%flo * alpha_down + res_ob(jres)%prev_flo * (1. - alpha_down)
end if
res_ob(jres)%prev_flo = ht2%flo
```

**Current Version:**
```fortran
! Inside if(res_ob(jres)%rel_tbl == "d") block:
call conditions (jres, irel)
call res_hydro (jres, irel, pvol_m3, evol_m3)

!! new lag to smooth condition jumps (volume or month conditions)
alpha_up = Exp(-res_ob(jres)%lag_up)
alpha_down = Exp(-res_ob(jres)%lag_down)
!! lag outflow when flows are receding
if (res_ob(jres)%prev_flo < ht2%flo) then
  ht2%flo = ht2%flo * alpha_up + res_ob(jres)%prev_flo * (1. - alpha_up)
else
  ht2%flo = ht2%flo * alpha_down + res_ob(jres)%prev_flo * (1. - alpha_down)
end if
res_ob(jres)%prev_flo = ht2%flo
  
call res_sediment
```

**Explanation:**
- Lag smoothing code block was **moved EARLIER** in the execution sequence
- **Old:** Lag applied AFTER water balance (outflow, evap, seepage) calculations
- **Current:** Lag applied IMMEDIATELY after `res_hydro()` and BEFORE water balance
- **Critical Impact:** Changes the order of operations significantly
  - Old: Calculate release → Apply water balance → Smooth the result
  - New: Calculate release → Smooth immediately → Then apply water balance
- **Why this matters:**
  - The smoothed outflow is now used in the water balance calculations
  - Prevents oscillations caused by condition changes in decision tables
  - More stable reservoir operations with gradual transitions
  - Better matches expected physical behavior
- **Code comment fix:** "receeding" → "receding" (spelling error fixed in code comment from old version)

---

### 6. **Indentation Fix in else Branch**

**Location:** Lines 82-84 (current version)

**Old Version:**
```fortran
else
      ictbl = res_dat(idat)%release                              !! Osvaldo
      call res_rel_conds (ictbl, res(jres)%flo, ht1%flo, 0.)
```

**Current Version:**
```fortran
else
  ictbl = res_dat(idat)%release                              !! Osvaldo
  call res_rel_conds (ictbl, res(jres)%flo, ht1%flo, 0.)
```

**Explanation:**
- Fixed inconsistent indentation (tabs vs spaces)
- Improves code readability
- No functional change

---

### 7. **Sediment Calculations Commented Out**

**Location:** Lines 127-129 (current version)

**Old Version:**
```fortran
!! subtract sediment leaving from reservoir
res(jres)%sed = max (0., res(jres)%sed - ht2%sed)
res(jres)%sil = max (0., res(jres)%sil - ht2%sil)
res(jres)%cla = max (0., res(jres)%cla - ht2%cla)
```

**Current Version:**
```fortran
!! subtract sediment leaving from reservoir
!res(jres)%sed = max (0., res(jres)%sed - ht2%sed)
!res(jres)%sil = max (0., res(jres)%sil - ht2%sil)
!res(jres)%cla = max (0., res(jres)%cla - ht2%cla)
```

**Explanation:**
- Sediment mass balance calculations are now commented out (disabled)
- **Impact:** Sediment is no longer subtracted from reservoir storage in this routine
- **Likely reason:** Sediment balance may now be handled in `res_sediment` subroutine
- Prevents double-counting of sediment leaving the reservoir
- This is a significant change in sediment tracking methodology

---

### 8. **Constituent Handling When Reservoir Not Constructed**

**Location:** Lines 183-184 (current version)

**Old Version:**
```fortran
else
  !! reservoir has not been constructed yet
  ob(icmd)%hd(1) = ob(icmd)%hin
end if
```

**Current Version:**
```fortran
else
  !! reservoir has not been constructed yet
  ob(icmd)%hd(1) = ob(icmd)%hin
  if (cs_db%num_tot > 0) obcs(icmd)%hd(1) = obcs(icmd)%hin(1)
end if
```

**Explanation:**
- Added handling for constituents when reservoir hasn't been constructed yet
- Passes incoming constituent mass through unchanged (bypass)
- Ensures consistent constituent tracking throughout simulation period
- Important for models with water quality components

---

### 9. **Debug Code Removed**

**Location:** End of file (removed from current version)

**Old Version:**
```fortran
!!!! for Luis only    
  !if (jres == 1) then
  !  write (7777,*) time%day, time%yrc, jres, res(jres)%flo, ht1%flo, ht2%flo, res_wat_d(jres)%precip,   &
  !                    res_wat_d(jres)%evap, res_wat_d(jres)%area_ha
  !end if
!!!! for Luis only
```

**Current Version:**
- (completely removed)

**Explanation:**
- Removed developer-specific debug code
- Cleaner, more production-ready code
- No functional impact as it was already commented out

---

## Summary of Functional Changes

### Critical Changes (affect model behavior):

1. **0.5 multiplier for pvol/evol** - Most significant change
   - All release calculations now use 50% of volumes as reference
   - More conservative reservoir operations
   
2. **Lag smoothing moved earlier** - Changes order of operations
   - Outflow smoothed before water balance instead of after
   - More stable operations, prevents oscillations
   
3. **Sediment calculations disabled** - Sediment handling changed
   - No longer subtracting sediment in this routine
   - Likely handled elsewhere to prevent double-counting

### Important Improvements (quality/reliability):

4. **Variable initialization** - All variables now initialized to zero
5. **Constituent handling** - Better support for water quality modeling
6. **External declarations** - More explicit interface definitions

### Minor Improvements:

7. **Code cleanup** - Removed debug code, fixed indentation, fixed spelling

## Behavioral Impact

The current version produces **different results** than the old version due to:

1. **Lower average reservoir storage** (0.5 factor effect)
2. **Smoother outflow hydrographs** (lag applied earlier)
3. **Different sediment dynamics** (commented out calculations)
4. **Better constituent tracking** (new initialization and bypass handling)

These changes appear to be intentional improvements to make reservoir operations more conservative, stable, and physically realistic.

## Reference Documents

- See `INVESTIGATION_res_control_0.5_factor.md` for detailed analysis of the 0.5 factor
- Related files: `res_hydro.f90`, `res_sediment.f90`, `wetland_control.f90`
