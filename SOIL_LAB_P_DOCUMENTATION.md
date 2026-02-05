# Soil lab_p Parameter Documentation

## Overview
`lab_p` is a soil nutrient parameter in SWAT+ that represents **labile phosphorus** in soil, measured in parts per million (ppm). This document details where it's defined, read, used, and how it's distributed across soil layers.

---

## 1. Where is lab_p defined?

### Data Structure Definition
**File:** `src/soil_data_module.f90` (Line 16)

```fortran
type soiltest_db
  character(len=16) :: name = "default"
  real :: exp_co = .001         ! depth coefficient to adjust concentrations for depth
  real :: lab_p = 5.            ! ppm | labile P in soil surface
  real :: nitrate = 7.          ! ppm | nitrate N in soil surface
  real :: fr_hum_act = .02      ! 0-1 | fraction of soil humus that is active
  real :: hum_c_n = 10.         ! ratio | humus C:N ratio (range 8-12)
  real :: hum_c_p = 80.         ! ratio | humus C:P ratio (range 70-90)
  ...
end type soiltest_db
```

**Default Value:** 5.0 ppm  
**Description:** Labile P in soil surface

---

## 2. Where is lab_p read in?

### Reading Mechanism
**File:** `src/solt_db_read.f90`

The subroutine `solt_db_read` reads lab_p values from the soil nutrient input file:

```fortran
subroutine solt_db_read
  ...
  inquire (file=in_sol%nut_sol, exist=i_exist)
  if (.not. i_exist .or. in_sol%nut_sol == "null") then
    allocate (solt_db(0:0))
  else
    open (107, file=in_sol%nut_sol)
    read (107,*) titldum        ! Read title
    read (107,*) header         ! Read header
    do isolt = 1, imax
      read (107,*) solt_db(isolt)   ! Read entire soiltest_db structure including lab_p
    end do
  end if
end subroutine solt_db_read
```

### Input File
**File:** `nutrients.sol` (default name defined in `src/input_file_module.f90`)

**Example:** `data/Osu_1hru/nutrients.sol`
```
nutrients.sol: written by SWAT+ editor v2.2.0 on 2023-03-22 04:25 for SWAT+ rev.60.5.4
name         exp_co    lab_p    nitrate  fr_hum_act  hum_c_n  hum_c_p  inorgp  watersol_p  h3a_p  mehlich_p  bray_strong_p  description
soilnut1     0.00050   5.00000  7.00000  0.02000     10.00000 80.00000 3.50000 0.15000     0.25000 1.20000   0.85000  
```

**Called from:** `src/proc_read.f90` which calls `solt_db_read` during initialization

---

## 3. Where is lab_p used?

### Primary Usage - Soil Initialization
**File:** `src/soil_nutcarb_init.f90` (Lines 55-75)

The lab_p value is used to initialize the labile phosphorus pool for **each soil layer** in each HRU (Hydrologic Response Unit):

```fortran
do ly = 1, nly  ! Loop through all soil layers
  ! Calculate depth fraction using exponential decay
  dep_frac = Exp(-solt_db(isolt)%exp_co * soil(ihru)%phys(ly)%d)
  
  ! Set initial labile P pool
  if (solt_db(isolt)%lab_p > 1.e-9) then
    soil1(ihru)%mp(ly)%lab = solt_db(isolt)%lab_p * dep_frac
  else
    ! Default: assume initial concentration of 5 mg/kg
    soil1(ihru)%mp(ly)%lab = 5. * dep_frac
  end if
  
  ! Convert from mg/kg to kg/ha
  soil1(ihru)%mp(ly)%lab = soil1(ihru)%mp(ly)%lab * wt1
end do
```

**Conversion:**
- `wt1 = soil(ihru)%phys(ly)%conv_wt` 
- `conv_wt = bulk_density * thickness / 100` (converts mg/kg to kg/ha)

### Secondary Usage - Calibration
**File:** `src/cal_parm_select.f90` (Lines 1002-1005)

The calibration module can adjust lab_p values:

```fortran
case ("lab_p")
  do ielem = 1, nly
    soil1(ihru)%mp(ielem)%lab = soil1(ihru)%mp(ielem)%lab + chg_val
  end do
```

### Output Usage
**File:** `src/output_landscape_module.f90`

The parameter `org_lab_p` tracks phosphorus movement from organic pool to labile pool in outputs (different from initial lab_p, but related to labile P dynamics).

---

## 4. Is lab_p hardcoded to a specific layer?

### Answer: NO - Applied to ALL Layers with Depth Attenuation

**Key Points:**

1. **Not hardcoded to one layer:** lab_p is applied to **every soil layer** in the profile (loop: `do ly = 1, nly`)

2. **Depth-dependent distribution:** The concentration decreases exponentially with depth using:
   ```fortran
   dep_frac = Exp(-exp_co * depth)
   ```
   Where:
   - `exp_co` = exponential coefficient (default 0.001, read from nutrients.sol)
   - `depth` = depth to the center of the soil layer

3. **Surface layer has highest concentration:** 
   - The surface layer (ly=1) receives the full lab_p value (or close to it)
   - Deeper layers receive progressively less based on the exponential decay function

4. **Example calculation:**
   - If lab_p = 5.0 ppm and exp_co = 0.001
   - Layer at depth 0 mm: lab_p × exp(-0.001 × 0) = 5.0 ppm
   - Layer at depth 100 mm: lab_p × exp(-0.001 × 100) = 4.52 ppm
   - Layer at depth 500 mm: lab_p × exp(-0.001 × 500) = 3.03 ppm
   - Layer at depth 1000 mm: lab_p × exp(-0.001 × 1000) = 1.84 ppm

5. **Coefficient validation:** The code includes a check:
   ```fortran
   if (solt_db(isolt)%exp_co > 0.005) solt_db(isolt)%exp_co = 0.001
   ```
   This prevents unrealistic depth decay (caps exp_co at 0.005, resets to 0.001 if exceeded)

---

## Summary

| Aspect | Details |
|--------|---------|
| **Definition** | `src/soil_data_module.f90`, line 16 in `soiltest_db` type |
| **Default Value** | 5.0 ppm |
| **Input File** | `nutrients.sol` |
| **Read By** | `solt_db_read()` subroutine in `src/solt_db_read.f90` |
| **Used In** | `soil_nutcarb_init()` for initialization; `cal_parm_select()` for calibration |
| **Layer Distribution** | Applied to ALL layers with exponential depth attenuation |
| **Depth Function** | `concentration(depth) = lab_p × exp(-exp_co × depth)` |
| **Units** | Input: ppm (mg/kg); Stored: kg/ha after conversion |

---

## Related Parameters

- **exp_co**: Exponential coefficient controlling depth decay of lab_p and nitrate
- **nitrate**: Similar parameter for nitrogen, uses same depth distribution mechanism
- **inorgp, watersol_p, h3a_p, mehlich_p, bray_strong_p**: Other P forms (currently not used in the model)
