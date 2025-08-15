# SWAT+ out_no3 Variable: Quick Reference Guide

## Summary

`out_no3` is a SWAT+ output variable that represents **outgoing nitrate nitrogen (NO3-N) mass from stream channels**, measured in **tons** or **kg N**.

## What it represents

- **Physical meaning**: Total mass of nitrate nitrogen flowing out of a channel reach per day
- **Units**: tons N or kg N (nitrogen mass)
- **Scope**: Channel-scale nitrogen transport
- **Purpose**: Water quality assessment, nutrient loading analysis

## Where it comes from

### 1. Calculation Path
```
Incoming NO3 → In-stream processes → Concentration changes → Mass conversion → out_no3
```

### 2. Key Code Locations
- **Definition**: `src/sd_channel_module.f90` (line 72)
- **Assignment**: `src/sd_channel_control3.f90` (line 456)
- **Processing**: `src/ch_watqual4.f90` (QUAL2E water quality equations)

### 3. Input Sources
- **Upstream channels**: NO3 from connecting reaches
- **Surface runoff**: Agricultural and urban runoff
- **Groundwater**: Baseflow contribution
- **Point sources**: Wastewater discharge, industrial inputs

## Why it could be negative

### 1. **In-stream consumption processes**
- **Denitrification**: Bacteria convert NO3 to N2 gas under low-oxygen conditions
- **Algal uptake**: Photosynthesis consumes nitrate for growth
- **Plant uptake**: Aquatic vegetation absorption

### 2. **Model calculation issues**
- **Over-parameterization**: Reaction rate coefficients set too high
- **Numerical instability**: Semi-analytical solutions exceed physical bounds
- **Mass balance errors**: Consumption calculated > available nitrate

### 3. **Extreme environmental conditions**
- **Stagnant water**: Long residence times increase transformation
- **High temperatures**: Accelerate biochemical reactions
- **Anaerobic conditions**: Promote denitrification
- **Eutrophic conditions**: Intense algal blooms

## Typical Values and Interpretation

### Normal Range
- **Background levels**: 0.001 - 0.1 tons N/day (small watersheds)
- **Agricultural areas**: 0.1 - 10 tons N/day (depending on size and intensity)
- **Urban areas**: Highly variable, 0.01 - 5 tons N/day

### Negative Values
- **Small negative values (-0.001 to -0.01)**: Likely numerical artifacts, generally acceptable
- **Large negative values (< -0.1)**: Indicates model parameterization problems
- **Persistent negative values**: Requires parameter adjustment

## Troubleshooting Negative Values

### 1. **Check model parameters**
```
Parameter        Typical Range    Description
bc2             0.1 - 5.0 /hr    NO2→NO3 biological oxidation rate
rs4             0.01 - 0.5 /day  Organic nitrogen settling rate  
n_sol_part      0.1 - 2.0 /day   N solid-solution partitioning
```

### 2. **Review environmental inputs**
- Water temperature (15-30°C typical)
- Dissolved oxygen levels (>2 mg/L for aerobic)
- Channel flow rates and residence times
- Initial nitrate concentrations

### 3. **Model settings to check**
- `bsn_cc%qual2e` flag (controls which equations are used)
- Channel geometry (affects residence time)
- Time step size (daily vs sub-daily)

## Recommended Actions

### For Users
1. **Monitor trends**: Look for patterns in negative values (seasonal, location-specific)
2. **Compare with observations**: Validate against measured stream nitrate data
3. **Check mass balance**: Ensure `in_no3` ≥ `out_no3` over longer periods
4. **Review calibration**: Adjust water quality parameters if negatives persist

### For Model Developers
1. **Add bounds checking**: Implement minimum value constraints
2. **Improve numerical stability**: Review semi-analytical solutions
3. **Enhanced documentation**: Provide parameter guidance for different watershed types

## Output Files Containing out_no3

- `basin_sd_chanbud_aa.txt`: Basin-level annual averages
- `sd_chanbud_aa.txt`: Individual channel annual averages  
- `sd_chanbud_yr.txt`: Individual channel yearly totals
- `sd_chanbud_mon.txt`: Individual channel monthly totals
- `sd_chanbud_day.txt`: Individual channel daily values

## Related Variables

- `in_no3`: Incoming nitrate nitrogen to channel
- `fp_no3`: Floodplain nitrate deposition/loss
- `bank_no3`: Bank erosion nitrate contribution
- `bed_no3`: Bed erosion nitrate contribution
- `no3_orgn`: NO3 transformation to organic nitrogen

## Further Information

For detailed technical information, see:
- `doc/out_no3_analysis.md`: Comprehensive technical analysis
- `doc/nitrogen_flow_diagram.md`: Process flow diagrams and equations
- SWAT+ documentation: Water quality modeling section