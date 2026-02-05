# CLARIFICATION: Is lab_P Only Set for the First Layer?

## Question
**"So is lab_P ever just set for the first layer?"**

---

## Answer: NO - lab_P is Set for ALL Layers

**lab_P is applied to EVERY soil layer**, not just the first layer. The concentration decreases with depth using an exponential decay function.

---

## Code Evidence

### Source File: `src/soil_nutcarb_init.f90`

#### The Loop (Lines 55-113)
```fortran
!! calculate initial nutrient contents of layers, profile and
!! average in soil for the entire watershed

do ly = 1, nly    ! ← LOOPS THROUGH ALL LAYERS (1 to nly)
  soil(ihru)%phys(ly)%conv_wt = soil(ihru)%phys(ly)%bd * soil(ihru)%phys(ly)%thick / 100.
  wt1 = soil(ihru)%phys(ly)%conv_wt
  
  !! Calculate depth fraction for THIS LAYER
  dep_frac = Exp(-solt_db(isolt)%exp_co * soil(ihru)%phys(ly)%d)
  
  !! Set initial labile P pool FOR THIS LAYER
  if (solt_db(isolt)%lab_p > 1.e-9) then
    soil1(ihru)%mp(ly)%lab = solt_db(isolt)%lab_p * dep_frac  ← APPLIED TO LAYER ly
  else
    !! assume initial concentration of 5 mg/kg
    soil1(ihru)%mp(ly)%lab = 5. * dep_frac                   ← APPLIED TO LAYER ly
  end if
  
  !! Convert to kg/ha FOR THIS LAYER
  soil1(ihru)%mp(ly)%lab = soil1(ihru)%mp(ly)%lab * wt1      ← STORED IN LAYER ly
  
  !! set active mineral P pool based on dynamic PSP MJW
  if (bsn_cc%sol_P_model == 1) then 
    !! Dynamic PSP calculation FOR THIS LAYER
    ...
  end if
  
  soil1(ihru)%mp(ly)%act = soil1(ihru)%mp(ly)%lab * (1. - psp) / psp  ← LAYER ly
  
  !! Set Stable pool FOR THIS LAYER
  if (bsn_cc%sol_P_model == 1) then
    ...
    soil1(ihru)%mp(ly)%sta = ssp * (soil1(ihru)%mp(ly)%act + soil1(ihru)%mp(ly)%lab)
  else
    soil1(ihru)%mp(ly)%sta = 4. * soil1(ihru)%mp(ly)%act
  end if
end do  ! ← END OF LOOP - ALL LAYERS PROCESSED
```

---

## Key Points

### 1. **Loop Structure**
```fortran
do ly = 1, nly
```
- `ly` = layer number counter
- `nly` = total number of layers in the soil profile
- The loop executes for **EVERY layer** from 1 (surface) to nly (deepest)

### 2. **Layer-Specific Assignment**
```fortran
soil1(ihru)%mp(ly)%lab = ...
```
- The subscript `(ly)` means this value is stored **separately for each layer**
- Each layer gets its own labile P value

### 3. **Depth Attenuation Applied to Each Layer**
```fortran
dep_frac = Exp(-solt_db(isolt)%exp_co * soil(ihru)%phys(ly)%d)
```
- `soil(ihru)%phys(ly)%d` = depth to center of layer `ly`
- Each layer has a **different depth**, so each gets a **different dep_frac**
- Deeper layers have smaller dep_frac → less labile P

---

## Example Calculation

### Scenario:
- Input lab_p = 5.0 ppm
- exp_co = 0.001
- Soil profile with 5 layers

### What Happens:

| Layer | Depth (mm) | dep_frac | lab_p (ppm) | Result |
|-------|------------|----------|-------------|--------|
| **1** (Surface) | 0 | exp(-0.001 × 0) = 1.000 | 5.0 × 1.000 | **5.00 ppm** |
| **2** | 100 | exp(-0.001 × 100) = 0.905 | 5.0 × 0.905 | **4.52 ppm** |
| **3** | 300 | exp(-0.001 × 300) = 0.741 | 5.0 × 0.741 | **3.70 ppm** |
| **4** | 600 | exp(-0.001 × 600) = 0.549 | 5.0 × 0.549 | **2.74 ppm** |
| **5** (Deep) | 1000 | exp(-0.001 × 1000) = 0.368 | 5.0 × 0.368 | **1.84 ppm** |

**Each layer gets a value!** The concentration decreases with depth, but **all layers are initialized**.

---

## Common Misconception

### ❌ **WRONG:** "lab_P is only set for layer 1"
This would look like:
```fortran
soil1(ihru)%mp(1)%lab = solt_db(isolt)%lab_p  ! Only layer 1
! Other layers uninitialized or zero
```

### ✅ **CORRECT:** "lab_P is set for all layers with depth decay"
This is what actually happens:
```fortran
do ly = 1, nly  ! All layers
  dep_frac = Exp(-exp_co * depth(ly))
  soil1(ihru)%mp(ly)%lab = lab_p * dep_frac  ! Each layer
end do
```

---

## Where Confusion Might Come From

### 1. **"Surface" in Documentation**
The comment in `soil_data_module.f90` says:
```fortran
real :: lab_p = 5.  !ppm  |labile P in soil surface
```

**"soil surface"** here means the **surface concentration** (the reference value at depth=0), not that it's ONLY applied to the surface layer. It's the starting point for the exponential decay function.

### 2. **Single Input Value**
The `nutrients.sol` file has one `lab_p` value:
```
name      exp_co    lab_p    nitrate  ...
soilnut1  0.00050   5.00000  7.00000  ...
```

This **single value** represents the surface concentration, which is then **distributed to all layers** using the exponential decay formula.

---

## Verification in Other Code Files

### During Daily Calculations
When labile P is used in transformations, additions, or removals, it's **always in a layer loop**:

**Example from `nut_pminrl.f90`:**
```fortran
do l = 1, soil(j)%nly  ! ← Loop through all layers
  rmp1 = (soil1(j)%mp(l)%lab - soil1(j)%mp(l)%act * rto)
  ...
  soil1(j)%mp(l)%lab = soil1(j)%mp(l)%lab - rmp1  ← Update layer l
  soil1(j)%mp(l)%act = soil1(j)%mp(l)%act + rmp1  ← Update layer l
end do
```

**Example from `nut_solp.f90`:**
```fortran
do ly = 1, soil(j)%nly  ! ← Loop through all layers
  ...
  soil1(j)%mp(ly)%lab = soil1(j)%mp(ly)%lab - plch  ← Layer-specific
  soil1(j)%mp(ly+1)%lab = soil1(j)%mp(ly+1)%lab + plch  ← Next layer
end do
```

**Example from `pl_pup.f90` (Plant Uptake):**
```fortran
do l = 1, soil(j)%nly  ! ← Loop through all layers
  uapl = Min(upmx - pplnt(j), soil1(j)%mp(l)%lab)
  soil1(j)%mp(l)%lab = soil1(j)%mp(l)%lab - uapl  ← Each layer
end do
```

**ALL operations on labile P work with ALL layers**, not just the first one.

---

## Summary

| Statement | True/False |
|-----------|------------|
| lab_P is only set for the first layer | ❌ **FALSE** |
| lab_P is set for all soil layers | ✅ **TRUE** |
| lab_P decreases with depth | ✅ **TRUE** |
| Each layer stores its own lab_P value | ✅ **TRUE** |
| The surface has the highest lab_P concentration | ✅ **TRUE** |
| Deeper layers have progressively less lab_P | ✅ **TRUE** |

---

## Mathematical Formula

For any layer `ly` in the soil profile:

```
lab_P(ly) = lab_p_surface × exp(-exp_co × depth_to_layer_center)
```

Where:
- `lab_p_surface` = input value from nutrients.sol (e.g., 5.0 ppm)
- `exp_co` = exponential decay coefficient (e.g., 0.001)
- `depth_to_layer_center` = depth from surface to center of layer ly (mm)

This formula is applied to **every layer** during initialization.

---

## Conclusion

**NO, lab_P is NOT "ever just set for the first layer."**

It is **always** set for **ALL layers** in the soil profile, with the concentration decreasing exponentially with depth. The loop `do ly = 1, nly` ensures that every layer from surface to bottom receives an initial labile P value based on the input surface concentration and depth decay function.

---

## Related Documentation

For more details, see:
- **SOIL_LAB_P_DOCUMENTATION.md** - Section "Is lab_p hardcoded to a specific layer?"
- **LAB_P_COMPLETE_REFERENCE.md** - Line-by-line code references
- **PHOSPHORUS_DOCUMENTATION_INDEX.md** - Master index of all P documentation
