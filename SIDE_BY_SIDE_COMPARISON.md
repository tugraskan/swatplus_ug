# Side-by-Side Code Comparison: Key Differences

## Change 1: Volume Calculations (THE CRITICAL CHANGE)

### Old Version (Lines 55-56)
```fortran
pvol_m3 = res_ob(jres)%pvol
evol_m3 = res_ob(jres)%evol
```

### Current Version (Lines 59-60)
```fortran
pvol_m3 = 0.5 * res_ob(jres)%pvol
evol_m3 = 0.5 * res_ob(jres)%evol
```

**Impact:** 50% reduction in reference volumes for ALL release calculations

---

## Change 2: Order of Operations (LAG SMOOTHING)

### Old Version - Execution Order
```
1. call res_hydro (jres, irel, pvol_m3, evol_m3)
2. call res_sediment
3. [water balance calculations - outflow, evap, seepage]
4. [LAG SMOOTHING applied here] ← LATE
5. [rest of calculations]
```

### Current Version - Execution Order
```
1. call res_hydro (jres, irel, pvol_m3, evol_m3)
2. [LAG SMOOTHING applied here] ← EARLY
3. call res_sediment
4. [water balance calculations - outflow, evap, seepage]
5. [rest of calculations]
```

**Impact:** Smoothed outflow is now used in water balance calculations

---

## Change 3: Sediment Balance

### Old Version (Lines 120-122)
```fortran
!! subtract sediment leaving from reservoir
res(jres)%sed = max (0., res(jres)%sed - ht2%sed)
res(jres)%sil = max (0., res(jres)%sil - ht2%sil)
res(jres)%cla = max (0., res(jres)%cla - ht2%cla)
```

### Current Version (Lines 127-129)
```fortran
!! subtract sediment leaving from reservoir
!res(jres)%sed = max (0., res(jres)%sed - ht2%sed)
!res(jres)%sil = max (0., res(jres)%sil - ht2%sil)
!res(jres)%cla = max (0., res(jres)%cla - ht2%cla)
```

**Impact:** Sediment mass balance now handled elsewhere (likely in res_sediment)

---

## Detailed Line-by-Line Diff Summary

| Line Range | Change Type | Description |
|:-----------|:------------|:------------|
| 15 | **Addition** | External declarations added |
| 17-29 | **Modification** | All variables initialized to 0 |
| 33 | **Addition** | hcs2 constituent initialization added |
| 59-60 | **CRITICAL** | 0.5 multiplier added to pvol_m3 and evol_m3 |
| 70-79 | **Moved** | Lag smoothing relocated earlier in code |
| 82-84 | **Format** | Indentation fixed (tabs → spaces) |
| 127-129 | **Commented** | Sediment calculations disabled |
| 184 | **Addition** | Constituent bypass when reservoir not built |
| 187-193 | **Removal** | Debug code removed |

---

## Quick Reference: What Changed and Why

| What Changed | Why It Matters | Effect on Results |
|:-------------|:---------------|:------------------|
| **0.5 factor on volumes** | Changes all release thresholds | ✓ Lower reservoir levels<br>✓ Earlier releases<br>✓ More flood buffer |
| **Lag moved earlier** | Changes when smoothing applied | ✓ Smoother operations<br>✓ Less oscillation |
| **Variables initialized** | Prevents undefined behavior | ✓ More reliable<br>✓ Reproducible |
| **Sediment disabled** | Avoid double-counting | ✓ Different sediment dynamics |
| **Constituent handling** | Better water quality support | ✓ Complete mass tracking |
| **External declarations** | Modern Fortran practice | ✓ Better optimization<br>✓ Interface checking |

---

## Testing Recommendations

To verify these changes don't introduce errors:

1. **Compare reservoir volumes** between old and new versions
   - Expect ~50% lower average volumes in new version
   
2. **Check outflow patterns**
   - New version should have smoother hydrographs
   - Less sudden jumps in flow rates
   
3. **Verify sediment balance**
   - Ensure sediment is properly tracked (not lost or double-counted)
   
4. **Test with constituents**
   - Check that water quality components work correctly
   
5. **Validate edge cases**
   - Reservoir not yet constructed
   - Empty reservoir conditions
   - High flow events

---

## Migration Notes

If updating from old to new version:

⚠️ **WARNING:** Results WILL be different due to the 0.5 factor and operation reordering.

- Recalibration may be needed if the old version was calibrated to observations
- Decision table parameters may need adjustment (they now operate on 50% volumes)
- Previous model runs are NOT directly comparable to new runs
- Document the version change in model metadata

---

## References

- Full analysis: `INVESTIGATION_res_control_0.5_factor.md`
- Detailed comparison: `COMPARISON_res_control_old_vs_current.md`
- Related code: `res_hydro.f90`, `res_sediment.f90`
