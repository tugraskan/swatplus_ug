# Visual Guide: How lab_P is Applied to ALL Soil Layers

## The Question: "Is lab_P ever just set for the first layer?"

### Answer: NO - Here's the Visual Proof

---

## Code Structure Visualization

```
┌─────────────────────────────────────────────────────────────────┐
│  subroutine soil_nutcarb_init                                   │
│                                                                  │
│  Input from nutrients.sol:                                      │
│  ├─ lab_p = 5.0 ppm (surface concentration)                     │
│  └─ exp_co = 0.001 (depth decay coefficient)                    │
│                                                                  │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │  do ly = 1, nly  ← LOOP THROUGH ALL LAYERS                │ │
│  │                                                            │ │
│  │    Layer ly = 1 (Surface, 0-150mm)                        │ │
│  │    ├─ depth = 0 mm                                        │ │
│  │    ├─ dep_frac = exp(-0.001 × 0) = 1.000                  │ │
│  │    └─ soil1%mp(1)%lab = 5.0 × 1.000 = 5.00 ppm ✓         │ │
│  │                                                            │ │
│  │    Layer ly = 2 (150-300mm)                               │ │
│  │    ├─ depth = 225 mm                                      │ │
│  │    ├─ dep_frac = exp(-0.001 × 225) = 0.799                │ │
│  │    └─ soil1%mp(2)%lab = 5.0 × 0.799 = 3.99 ppm ✓         │ │
│  │                                                            │ │
│  │    Layer ly = 3 (300-600mm)                               │ │
│  │    ├─ depth = 450 mm                                      │ │
│  │    ├─ dep_frac = exp(-0.001 × 450) = 0.638                │ │
│  │    └─ soil1%mp(3)%lab = 5.0 × 0.638 = 3.19 ppm ✓         │ │
│  │                                                            │ │
│  │    Layer ly = 4 (600-900mm)                               │ │
│  │    ├─ depth = 750 mm                                      │ │
│  │    ├─ dep_frac = exp(-0.001 × 750) = 0.472                │ │
│  │    └─ soil1%mp(4)%lab = 5.0 × 0.472 = 2.36 ppm ✓         │ │
│  │                                                            │ │
│  │    Layer ly = 5 (900-1500mm)                              │ │
│  │    ├─ depth = 1200 mm                                     │ │
│  │    ├─ dep_frac = exp(-0.001 × 1200) = 0.301               │ │
│  │    └─ soil1%mp(5)%lab = 5.0 × 0.301 = 1.50 ppm ✓         │ │
│  │                                                            │ │
│  │  end do  ← ALL LAYERS PROCESSED                           │ │
│  └────────────────────────────────────────────────────────────┘ │
│                                                                  │
│  Result: ALL 5 layers have labile P initialized! ✓              │
└─────────────────────────────────────────────────────────────────┘
```

---

## Soil Profile Diagram

```
        lab_P Concentration (ppm)
        0     1     2     3     4     5
        │─────│─────│─────│─────│─────│
    0mm ┌─────────────────────────────┐ 
        │█████████████████████████████│ Layer 1: 5.00 ppm
  150mm ├─────────────────────────────┤
        │████████████████████         │ Layer 2: 3.99 ppm
  300mm ├─────────────────────────────┤
        │███████████████              │ Layer 3: 3.19 ppm
  600mm ├─────────────────────────────┤
        │███████████                  │ Layer 4: 2.36 ppm
  900mm ├─────────────────────────────┤
        │███████                      │ Layer 5: 1.50 ppm
 1500mm └─────────────────────────────┘

        ▲
        └── Each layer has lab_P initialized!
            Concentration decreases with depth.
```

---

## What the Code Does vs What It Doesn't Do

### ❌ If lab_P Were ONLY Set for First Layer:
```fortran
! THIS IS NOT WHAT HAPPENS!
soil1(ihru)%mp(1)%lab = solt_db(isolt)%lab_p  ! Layer 1 only
! Layers 2, 3, 4, 5... would be 0 or uninitialized

Result:
Layer 1: 5.0 ppm  ← Only this one set
Layer 2: 0.0 ppm  ← Not set
Layer 3: 0.0 ppm  ← Not set
Layer 4: 0.0 ppm  ← Not set
Layer 5: 0.0 ppm  ← Not set
```

### ✅ What Actually Happens (ALL Layers):
```fortran
! THIS IS THE ACTUAL CODE!
do ly = 1, nly                                      ! Loop all layers
  dep_frac = Exp(-exp_co * soil%phys(ly)%d)        ! Each layer's depth
  soil1(ihru)%mp(ly)%lab = lab_p * dep_frac        ! Each layer set
end do

Result:
Layer 1: 5.00 ppm  ← Set with depth decay
Layer 2: 3.99 ppm  ← Set with depth decay
Layer 3: 3.19 ppm  ← Set with depth decay
Layer 4: 2.36 ppm  ← Set with depth decay
Layer 5: 1.50 ppm  ← Set with depth decay
```

---

## Exponential Decay Visualization

```
Concentration Profile
 
5.0 │●                      ← Surface (Layer 1)
    │ ●
4.0 │  ●                    ← Layer 2
    │   ●
3.0 │    ●                  ← Layer 3
    │     ●●
2.0 │       ●●              ← Layer 4
    │         ●●
1.0 │           ●●●         ← Layer 5
    │              ●●●●
0.0 └──────────────────────●●●●●●──
    0   200  400  600  800  1000  1200  1400  1600
              Depth (mm)

Formula: lab_P(depth) = 5.0 × exp(-0.001 × depth)

ALL LAYERS on this curve get a value!
```

---

## Storage Structure in Memory

```
soil1(ihru)%mp() Array Structure:
┌──────────────────────────────────────────┐
│ Layer 1: %mp(1)                          │
│   ├─ %lab = 5.00 kg/ha  ✓ INITIALIZED  │
│   ├─ %act = 4.23 kg/ha                  │
│   └─ %sta = 16.9 kg/ha                  │
├──────────────────────────────────────────┤
│ Layer 2: %mp(2)                          │
│   ├─ %lab = 3.99 kg/ha  ✓ INITIALIZED  │
│   ├─ %act = 3.38 kg/ha                  │
│   └─ %sta = 13.5 kg/ha                  │
├──────────────────────────────────────────┤
│ Layer 3: %mp(3)                          │
│   ├─ %lab = 3.19 kg/ha  ✓ INITIALIZED  │
│   ├─ %act = 2.70 kg/ha                  │
│   └─ %sta = 10.8 kg/ha                  │
├──────────────────────────────────────────┤
│ Layer 4: %mp(4)                          │
│   ├─ %lab = 2.36 kg/ha  ✓ INITIALIZED  │
│   ├─ %act = 2.00 kg/ha                  │
│   └─ %sta = 8.00 kg/ha                  │
├──────────────────────────────────────────┤
│ Layer 5: %mp(5)                          │
│   ├─ %lab = 1.50 kg/ha  ✓ INITIALIZED  │
│   ├─ %act = 1.27 kg/ha                  │
│   └─ %sta = 5.08 kg/ha                  │
└──────────────────────────────────────────┘

All layers have lab_P values stored!
```

---

## Loop Flow Diagram

```
┌─────────────────────────────────┐
│  START: soil_nutcarb_init       │
└────────────┬────────────────────┘
             │
             ▼
      ┌──────────────┐
      │ ly = 1       │ ← First iteration
      └──────┬───────┘
             │
             ▼
      ┌─────────────────────────┐
      │ Calculate dep_frac      │
      │ Set soil1%mp(1)%lab ✓   │
      └──────┬──────────────────┘
             │
             ▼
      ┌──────────────┐
      │ ly = 2       │ ← Second iteration
      └──────┬───────┘
             │
             ▼
      ┌─────────────────────────┐
      │ Calculate dep_frac      │
      │ Set soil1%mp(2)%lab ✓   │
      └──────┬──────────────────┘
             │
             ▼
      ┌──────────────┐
      │ ly = 3       │ ← Third iteration
      └──────┬───────┘
             │
             ▼
      ┌─────────────────────────┐
      │ Calculate dep_frac      │
      │ Set soil1%mp(3)%lab ✓   │
      └──────┬──────────────────┘
             │
             ▼
         (continues for all layers...)
             │
             ▼
      ┌──────────────┐
      │ ly = nly     │ ← Last iteration
      └──────┬───────┘
             │
             ▼
      ┌─────────────────────────┐
      │ Calculate dep_frac      │
      │ Set soil1%mp(nly)%lab ✓ │
      └──────┬──────────────────┘
             │
             ▼
      ┌──────────────┐
      │ END LOOP     │
      └──────┬───────┘
             │
             ▼
    ALL LAYERS INITIALIZED! ✓
```

---

## Comparison Table

| Scenario | Layer 1 | Layer 2 | Layer 3 | Layer 4 | Layer 5 |
|----------|---------|---------|---------|---------|---------|
| **If only first layer** | 5.0 ppm | 0.0 | 0.0 | 0.0 | 0.0 |
| **What actually happens** | 5.0 ppm | 4.0 ppm | 3.2 ppm | 2.4 ppm | 1.5 ppm |

---

## Proof from Multiple Code Locations

### 1. Initialization (soil_nutcarb_init.f90)
```fortran
do ly = 1, nly  ← ALL LAYERS
  soil1(ihru)%mp(ly)%lab = lab_p * dep_frac
end do
```

### 2. Plant Uptake (pl_pup.f90)
```fortran
do l = 1, soil(j)%nly  ← PLANTS CAN UPTAKE FROM ALL LAYERS
  uapl = Min(upmx, soil1(j)%mp(l)%lab)
  soil1(j)%mp(l)%lab = soil1(j)%mp(l)%lab - uapl
end do
```

### 3. Leaching (nut_solp.f90)
```fortran
do ly = 1, soil(j)%nly  ← LEACHING THROUGH ALL LAYERS
  soil1(j)%mp(ly)%lab = soil1(j)%mp(ly)%lab - plch
  soil1(j)%mp(ly+1)%lab = soil1(j)%mp(ly+1)%lab + plch
end do
```

### 4. Transformations (nut_pminrl.f90)
```fortran
do l = 1, soil(j)%nly  ← TRANSFORMATIONS IN ALL LAYERS
  rmp1 = (soil1(j)%mp(l)%lab - soil1(j)%mp(l)%act * rto)
  soil1(j)%mp(l)%lab = soil1(j)%mp(l)%lab - rmp1
end do
```

**If lab_P were only in layer 1, these loops would be pointless!**

---

## Final Answer

### Question: "Is lab_P ever just set for the first layer?"

### Answer: **NO, NEVER**

- ✅ lab_P is **ALWAYS** set for **ALL soil layers** (1 to nly)
- ✅ Each layer gets a **different value** based on depth
- ✅ Surface layer has **highest concentration**
- ✅ Concentration **decreases exponentially** with depth
- ✅ Formula: `lab_P(ly) = lab_p_input × exp(-exp_co × depth(ly))`

The code uses a **loop** (`do ly = 1, nly`) that explicitly processes **every layer**, ensuring all layers receive an initial labile P value.

---

## Related Documentation
- **LAB_P_LAYER_CLARIFICATION.md** - Detailed explanation with code evidence
- **SOIL_LAB_P_DOCUMENTATION.md** - General lab_p overview
- **PHOSPHORUS_DOCUMENTATION_INDEX.md** - Master documentation index
