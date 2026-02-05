# codes.bsn Dynamic P Model Options Documentation

## Overview

The `codes.bsn` file contains the **sol_P_model** flag (also called **soil_p**) that controls which phosphorus cycling model is used in SWAT+. This flag fundamentally changes how **labile phosphorus** is initialized and transformed during the simulation.

---

## Location of codes.bsn File

**Example Files in Repository:**
- `data/Osu_1hru/codes.bsn`
- `data/Ames_sub1/codes.bsn`

**File Format (Line 2):**
```
pet_file  wq_file  pet  event  crack  rtu_wq  sed_det  rte_cha  deg_cha  wq_cha  nostress  cn  c_fact  carbon  lapse  uhyd  sed_cha  tiledrain  wtable  soil_p  gampt  atmo_dep  stor_max  i_fpwet
```

**File Values (Line 3):**
```
null      null     1    0      0      1       0        0        0        1       0         0   0       0       0      1     0       0          0       0       0      a         0         0
```

The **20th column** is `soil_p` (sol_P_model flag).

---

## Flag Definition

**Source File:** `src/basin_module.f90` (Lines 61-62)

```fortran
type basin_control_codes
  ...
  integer :: sol_p_model=0  !! 0 = original soil P model in SWAT documentation
                            !! 1 = new soil P model in Vadas and White (2010)
  ...
end type basin_control_codes
type (basin_control_codes) :: bsn_cc
```

**Default Value:** 0 (original SWAT model)

---

## Available Options

| Value | Model | Reference | Description |
|-------|-------|-----------|-------------|
| **0** | Original SWAT | SWAT Documentation | Static PSP and SSP ratios, simple transformation rates |
| **1** | Vadas & White | Vadas and White (2010) | Dynamic PSP and SSP, time-dependent transformations |

---

## How Options Affect Labile P

### 1. **During Initialization** (`src/soil_nutcarb_init.f90`)

After labile P is initialized from `lab_p` input (lines 69-75), the model diverges:

#### **Option 0: Original SWAT Model** (Lines 94, 111)

```fortran
psp = hru(ihru)%nut%psp  ! Fixed PSP from HRU parameter file

soil1(ihru)%mp(ly)%act = soil1(ihru)%mp(ly)%lab * (1. - psp) / psp

soil1(ihru)%mp(ly)%sta = 4. * soil1(ihru)%mp(ly)%act  ! Fixed 4× multiplier
```

**Characteristics:**
- Uses **fixed PSP** (Phosphorus Sorption Probability) from HRU input file
- Active P pool calculated from labile P using fixed PSP ratio
- Stable P pool = **4 × Active P** (hardcoded multiplier)
- Same ratios used throughout simulation

#### **Option 1: Vadas & White Model** (Lines 78-108)

```fortran
!! Dynamic PSP Calculation
solp = soil1(ihru)%mp(ly)%lab / wt1  ! Convert to mg/kg

!! PSP equation from Vadas & White (2010)
psp = -0.045 * log(soil(ihru)%phys(ly)%clay) + (0.001 * solp) 
      - (0.035 * soil1(ihru)%cbn(ly)) + 0.43

!! Limit PSP range to realistic values
if (psp < 0.10) psp = 0.10
if (psp > 0.70) psp = 0.70

!! Calculate Active P from dynamic PSP
soil1(ihru)%mp(ly)%act = soil1(ihru)%mp(ly)%lab * (1. - psp) / psp

!! Dynamic SSP from Sharpley (2004)
actp = soil1(ihru)%mp(ly)%act / wt1
solp = soil1(ihru)%mp(ly)%lab / wt1
ssp = 25.044 * (actp + solp)^(-0.3833)  ! Total mineral P relationship

!! Limit SSP range
if (ssp > 7.0) ssp = 7.0
if (ssp < 1.0) ssp = 1.0

!! Calculate Stable P
soil1(ihru)%mp(ly)%sta = ssp * (soil1(ihru)%mp(ly)%act + soil1(ihru)%mp(ly)%lab)
```

**Characteristics:**
- PSP calculated from **soil properties**: clay %, organic C %, and solution P concentration
- PSP constrained to range: **0.10 to 0.70**
- SSP (Stable-to-Soluble ratio) calculated from **total mineral P** using Sharpley (2004) equation
- SSP constrained to range: **1.0 to 7.0**
- More realistic representation based on soil chemistry

---

### 2. **During Daily Simulation** (`src/hru_control.f90`)

The flag determines which P mineralization subroutine is called (Line 371-375):

```fortran
if (bsn_cc%sol_P_model == 1) then  
  call nut_pminrl2    ! Vadas & White model
else
  call nut_pminrl     ! Original SWAT model
end if
```

---

### 3. **Daily P Transformations - Original Model** (`src/nut_pminrl.f90`)

**Method:** Simple rate equations with fixed coefficients

```fortran
rto = hru(j)%nut%psp / (1. - hru(j)%nut%psp)  ! Fixed ratio from input

!! Calculate P imbalance between labile and active pools
rmp1 = (soil1(j)%mp(l)%lab - soil1(j)%mp(l)%act * rto)

!! Apply transformation rates
if (rmp1 > 0.) rmp1 = rmp1 * 0.1   ! 10% rate: labile → active
if (rmp1 < 0.) rmp1 = rmp1 * 0.6   ! 60% rate: active → labile

!! Update labile pool
soil1(j)%mp(l)%lab = soil1(j)%mp(l)%lab - rmp1
soil1(j)%mp(l)%act = soil1(j)%mp(l)%act + rmp1

!! Active ↔ Stable transformation (fixed rate = 0.01)
roc = 0.01 * (4. * soil1(j)%mp(l)%act - soil1(j)%mp(l)%sta)
```

**Key Features:**
- ✅ Simple and fast calculations
- ✅ Fixed transformation rates (10% forward, 60% backward)
- ✅ Uses PSP from input file (doesn't change daily)
- ❌ Doesn't respond to soil conditions or fertilizer applications
- ❌ No time-dependency in transformation rates

---

### 4. **Daily P Transformations - Vadas & White Model** (`src/nut_pminrl2.f90`)

**Method:** Dynamic, time-dependent transformations based on soil chemistry

#### **A. Daily PSP Recalculation** (Lines 58-74)

```fortran
!! Convert pools to concentration (mg/kg)
solp = soil1(j)%mp(l)%lab / soil(j)%phys(l)%conv_wt
actpp = soil1(j)%mp(l)%act / soil(j)%phys(l)%conv_wt
stap = soil1(j)%mp(l)%sta / soil(j)%phys(l)%conv_wt

!! Calculate PSP from soil properties (same equation as initialization)
psp = -0.045 * log(soil(j)%phys(l)%clay) + (0.001 * solp) 
      - (0.035 * soil1(j)%cbn(l)) + 0.43

!! Limit PSP range
if (psp < 0.1) psp = 0.1
if (psp > 0.7) psp = 0.7

!! Smooth PSP using 30-day moving average
if (soil(j)%ly(l)%psp_store > 0.) then
  psp = (soil(j)%ly(l)%psp_store * 29. + psp * 1.) / 30.
end if
soil(j)%ly(l)%psp_store = psp  ! Store for tomorrow
```

**Why This Matters:**
- PSP adjusts daily based on current solution P concentration
- Responds to fertilizer applications (high solp → higher PSP → less P sorption)
- Smoothing prevents rapid oscillations

#### **B. Time-Dependent Transformation Rates** (Lines 84-118)

The transformation rate depends on **time since last P application or deficit**:

```fortran
!! Calculate P imbalance
rto = psp / (1. - psp)
rmp1 = soil1(j)%mp(l)%lab - soil1(j)%mp(l)%act * rto

if (rmp1 >= 0.) then  
  !! POSITIVE: Labile → Active (P excess)
  !! Rate decreases with time since P application (Vadas et al., 2006)
  
  vara = 0.918 * (exp(-4.603 * psp))
  varb = (-0.238 * ALOG(vara)) - 1.126
  
  if (soil(j)%ly(l)%a_days > 0) then
    arate = vara * (soil(j)%ly(l)%a_days ** varb)
  else
    arate = vara
  end if
  
  !! Limit rate: 0.1 to 0.5
  if (arate > 0.5) arate = 0.5
  if (arate < 0.1) arate = 0.1
  
  rmp1 = arate * rmp1
  soil(j)%ly(l)%a_days = soil(j)%ly(l)%a_days + 1  ! Increment counter
  soil(j)%ly(l)%b_days = 0
  
else  
  !! NEGATIVE: Active → Labile (P deficit)
  !! Rate based on PSP
  
  base = (-1.08 * psp) + 0.79
  varc = base * (exp(-0.29))
  
  !! Limit varc: 0.1 to 1.0
  if (varc > 1.0) varc = 1.0
  if (varc < 0.1) varc = 0.1
  
  rmp1 = rmp1 * varc
  soil(j)%ly(l)%a_days = 0
  soil(j)%ly(l)%b_days = soil(j)%ly(l)%b_days + 1  ! Increment counter
end if

!! Apply transformation
soil1(j)%mp(l)%lab = soil1(j)%mp(l)%lab - rmp1
soil1(j)%mp(l)%act = soil1(j)%mp(l)%act + rmp1
```

**Key Features:**
- ✅ Transformation rate **decreases over time** after P application (realistic sorption kinetics)
- ✅ Different rates for forward (labile→active) vs backward (active→labile)
- ✅ Rates depend on **PSP** (soil chemistry feedback)
- ✅ Tracks "days since application" and "days since deficit"
- ✅ More mechanistic representation of P dynamics

#### **C. Active ↔ Stable Transformations** (Lines 120-180)

Similar time-dependent approach for active-stable pool exchanges (see source code for details).

---

## Comparison Summary

| Aspect | sol_P_model = 0 (Original) | sol_P_model = 1 (Vadas & White) |
|--------|----------------------------|----------------------------------|
| **PSP Calculation** | Fixed from input file | Dynamic from clay, org C, solution P |
| **PSP Updates** | Never changes | Recalculated daily with 30-day smoothing |
| **PSP Range** | User-defined | 0.10 to 0.70 (constrained) |
| **SSP Calculation** | Stable = 4 × Active (fixed) | Dynamic from Sharpley (2004): ssp = 25.044 × (actp+solp)^(-0.3833) |
| **SSP Range** | Fixed 4:1 ratio | 1.0 to 7.0 (constrained) |
| **Labile → Active Rate** | 10% of imbalance | Time-dependent (0.1 to 0.5), decreases after fertilizer |
| **Active → Labile Rate** | 60% of imbalance | PSP-dependent (0.1 to 1.0) |
| **Time Dependency** | None | Tracks days since P application/deficit |
| **Soil Property Feedback** | None | PSP responds to clay, organic C, solution P |
| **Fertilizer Response** | Indirect (via pool size only) | Direct (PSP increases, affects sorption) |
| **Computational Cost** | Low | Higher (daily recalculations) |
| **Scientific Basis** | SWAT documentation | Vadas & White (2010), Sharpley (2004) |

---

## Impact on Labile P Behavior

### **With sol_P_model = 0 (Original)**

**Labile P Dynamics:**
1. Initial labile P set from `lab_p` in `nutrients.sol`
2. PSP ratio fixed throughout simulation
3. Simple equilibrium-seeking behavior with fixed rates
4. After fertilizer application:
   - Labile pool increases immediately
   - Fixed 10% daily transfer to active pool
   - No acceleration or deceleration of transformation
5. Predictable, stable behavior

**Best For:**
- Simple applications
- When detailed P chemistry data unavailable
- Computational efficiency important
- Historical SWAT calibrations

### **With sol_P_model = 1 (Vadas & White)**

**Labile P Dynamics:**
1. Initial labile P set from `lab_p` in `nutrients.sol`
2. PSP calculated from soil properties
3. Complex, time-dependent transformations
4. After fertilizer application:
   - Labile pool increases immediately
   - PSP increases (more P in solution → higher sorption probability)
   - Transformation rate highest initially, then decreases
   - Rate tracked by "days since application" counter
5. More realistic representation of P chemistry

**Best For:**
- Detailed P cycling studies
- Management practice comparisons (fertilizer timing, rates)
- Soils with variable clay/organic matter content
- Research applications requiring mechanistic accuracy

---

## Setting the Flag in codes.bsn

**To Use Original Model (sol_P_model = 0):**
```
Line 3, Column 20: 0
```

**To Use Vadas & White Model (sol_P_model = 1):**
```
Line 3, Column 20: 1
```

**Example codes.bsn (Line 3):**
```
null  null  1  0  0  1  0  0  0  1  0  0  0  0  0  1  0  0  0  1  0  a  0  0
                                                              ↑
                                                         soil_p flag
```

---

## Required Input Files

### For sol_P_model = 0
- `nutrients.sol` - provides `lab_p` (initial labile P)
- HRU input file - provides fixed PSP value

### For sol_P_model = 1
- `nutrients.sol` - provides `lab_p` (initial labile P)
- Soil physical properties - clay content (%)
- Soil carbon data - organic C content (%)

**Note:** The Vadas & White model does NOT require PSP input since it calculates it dynamically.

---

## References

1. **Vadas, P.A. and White, M.J. (2010).** "Validating soil phosphorus routines in the SWAT model." 
   *Transactions of the ASABE*, 53(5), 1469-1476.

2. **Sharpley, A.N. (2004).** Phosphorus chemistry in soils and links to water quality. 
   Data referenced for total mineral P relationships.

3. **Vadas, P.A., Krogstad, T., and Sharpley, A.N. (2006).** "Modeling phosphorus transfer between labile and nonlabile soil pools: Updating the EPIC model."
   *Soil Science Society of America Journal*, 70, 736-743.

---

## Code Files Reference

| File | Purpose | Lines |
|------|---------|-------|
| `src/basin_module.f90` | Flag definition | 61-62 |
| `src/basin_read_cc.f90` | Read codes.bsn | 24 |
| `src/soil_nutcarb_init.f90` | Initialize P pools | 78-112 |
| `src/hru_control.f90` | Select mineralization routine | 371-375 |
| `src/nut_pminrl.f90` | Original P transformations | 1-59 |
| `src/nut_pminrl2.f90` | Vadas & White P transformations | 1-188 |

---

## Related Documentation

- **SOIL_LAB_P_DOCUMENTATION.md** - General labile P overview
- **LAB_P_COMPLETE_REFERENCE.md** - All labile P code references
- **LAB_P_VERIFICATION_SUMMARY.md** - Verification of labile P usage

---

## Quick Decision Guide

**Choose sol_P_model = 0 if:**
- ✅ Running standard SWAT+ applications
- ✅ Limited soil chemistry data available
- ✅ Computational speed is important
- ✅ Using existing calibrated parameters from SWAT
- ✅ Simple P management scenarios

**Choose sol_P_model = 1 if:**
- ✅ Studying detailed P cycling dynamics
- ✅ Comparing fertilizer management strategies
- ✅ Have good soil physical/chemical data
- ✅ Need mechanistic representation
- ✅ Research or publication quality results required
- ✅ Soils have widely varying properties
