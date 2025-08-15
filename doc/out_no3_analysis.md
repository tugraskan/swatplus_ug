# Understanding `out_no3` in SWAT+: What it represents, where it comes from, and why it could be negative

## Overview

`out_no3` is a variable in the SWAT+ (Soil & Water Assessment Tool Plus) model that represents **outgoing nitrate nitrogen (NO3-N) from stream channels**. This document explains what it represents, its sources, calculation methods, and reasons why it might become negative.

## What `out_no3` Represents

`out_no3` represents the mass of nitrate nitrogen (NO3-N) that flows out of a stream channel reach during a given time step. Specifically:

- **Units**: Typically measured in kg N (kilograms of nitrogen) or tons N
- **Scope**: Represents nitrate leaving a specific channel reach
- **Time frame**: Usually calculated on a daily time step
- **Component**: Part of the overall nitrogen budget for stream water quality modeling

## Where `out_no3` Comes From

### 1. Source Location in Code

The variable is defined and calculated in several key files:

- **`src/sd_channel_module.f90`**: Defines the `out_no3` variable as part of the channel sediment budget structure
- **`src/sd_channel_control3.f90`**: Assigns the calculated value at line 456: `ch_sed_bud(ich)%out_no3 = ht2%no3`

### 2. Calculation Process

The `out_no3` value comes from the hydrograph variable `ht2%no3`, which is calculated through:

#### A. Water Quality Transformations (`ch_watqual4.f90`)
The primary calculation occurs in the `ch_watqual4` subroutine, which implements QUAL2E water quality equations:

```fortran
! Convert concentration back to mass
ht2%no3 = ht3%no3 * ht1%flo / 1000.
```

Where:
- `ht3%no3` = nitrate concentration (mg/L) after in-stream transformations
- `ht1%flo` = water flow volume (m³)
- `ht2%no3` = resulting nitrate mass (kg N)

#### B. In-Stream Nitrogen Transformations
The nitrate concentration (`ht3%no3`) is modified by several biogeochemical processes:

1. **Biological oxidation of nitrite to nitrate**:
   ```fortran
   factm = -bc2_m  ! bc2 = rate constant for NO2 → NO3 oxidation
   ht3%no3 = wq_semianalyt(tday, rt_delt, factm, 0., ht3%no3, ht3%no3)
   ```

2. **Algal uptake** (removes nitrate for photosynthesis)
3. **Denitrification** (converts nitrate to nitrogen gas under anaerobic conditions)
4. **Settling of organic matter** (affects nitrogen cycling)

#### C. Alternative Calculation (with qual2e flag)
When `bsn_cc%qual2e == 1`, an alternative transformation occurs:
```fortran
ht2%no3 = ht1%no3 - ch_trans%no3
```
Where `ch_trans%no3` represents nitrogen transformations (organic N → NO3).

## Why `out_no3` Could Be Negative

### 1. Mathematical Reasons

#### A. Excessive Transformations
If the in-stream processes remove more nitrate than is available:
- High denitrification rates in anaerobic conditions
- Excessive algal uptake during intense photosynthesis
- Over-parameterized transformation coefficients

#### B. Semi-analytical Solution Issues
The `wq_semianalyt` function solves differential equations for nitrogen cycling. Under certain conditions:
- Extreme parameter values (e.g., very high `bc2` rate constants)
- Numerical instabilities in the exponential calculations
- Unrealistic residence times or reaction rates

#### C. Concentration-to-Mass Conversion
Since `ht2%no3 = ht3%no3 * ht1%flo / 1000.`, if `ht3%no3` becomes negative through the transformation calculations, the final mass will be negative.

### 2. Physical Process Interpretations

#### A. Rapid Denitrification
In channels with:
- Low dissolved oxygen (anaerobic conditions)
- High organic matter content
- Warm temperatures
- Long residence times

Denitrification can theoretically remove nitrate faster than it's replenished, leading to "negative" values that represent overconsumption.

#### B. Algal Bloom Scenarios
During intense algal blooms:
- Rapid nitrate uptake for photosynthesis
- Depletion of available nitrate
- Model attempting to account for more uptake than available nitrate

#### C. Transformation Imbalances
When the model calculates:
- Fast conversion of organic N to nitrate (nitrification)
- Even faster removal processes (denitrification, algal uptake)
- Net result can temporarily show negative values

### 3. Model Parameterization Issues

Negative values often indicate:
- **Over-parameterized reaction rates**: Coefficients set too high for local conditions
- **Unrealistic environmental conditions**: Temperature, oxygen, or flow parameters outside normal ranges
- **Calibration problems**: Parameters not properly adjusted for the specific watershed

## Interpretation and Recommendations

### 1. When Negative Values Occur

1. **Check model parameters**:
   - `bc2`: Biological oxidation rate for NO2→NO3
   - `rs4`: Organic nitrogen settling rate
   - Algal growth and uptake parameters

2. **Examine environmental conditions**:
   - Water temperature (affects reaction rates)
   - Dissolved oxygen levels
   - Channel residence time
   - Flow velocities

3. **Review input data**:
   - Initial nitrate concentrations
   - Organic nitrogen loads
   - Channel characteristics

### 2. Physical Meaning

Negative `out_no3` values typically indicate:
- **Model artifact**: The mathematical solution exceeded physical bounds
- **Extreme conditions**: Unrealistic parameter combinations
- **Process imbalance**: Removal processes outpacing supply

### 3. Recommended Actions

1. **Parameter adjustment**: Reduce transformation rate coefficients
2. **Boundary checking**: Implement minimum value constraints (already done: `if (ht3%no3 < 1.e-6) ht3%no3 = 0.`)
3. **Process validation**: Verify that modeled conditions match field observations
4. **Sensitivity analysis**: Test parameter ranges to identify stable configurations

## Model Implementation Details

The SWAT+ model includes several safeguards:
```fortran
if (ht3%no3 < 1.e-6) ht3%no3 = 0.
```

However, negative values can still occur before this check, especially in the intermediate calculations of the semi-analytical solutions.

## Conclusion

`out_no3` represents a critical component of stream nitrogen cycling in SWAT+. While negative values are non-physical, they often provide valuable diagnostic information about model parameterization and extreme environmental conditions. Understanding the sources and calculation methods helps users properly interpret and address these values in their modeling applications.