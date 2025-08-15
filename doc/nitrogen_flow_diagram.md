# Nitrogen Cycling and out_no3 in SWAT+ Channel Routing

## Nitrogen Flow Diagram in SWAT+ Channels

```
                    INCOMING WATER (ht1)
                           |
                    +-------------+
                    |   ht1%no3   |  (Incoming NO3-N mass)
                    |   ht1%orgn  |  (Incoming Organic N)
                    |   ht1%nh3   |  (Incoming NH3-N)
                    |   ht1%no2   |  (Incoming NO2-N)
                    +-------------+
                           |
                           v
                +-----------------------+
                |  CONCENTRATION        |
                |  CALCULATION          |
                |  ht3%no3 = 1000 *     |
                |  ht1%no3 / ht1%flo    |
                +-----------------------+
                           |
                           v
                +-----------------------+
                |  IN-STREAM PROCESSES  |
                |  (ch_watqual4)        |
                +-----------------------+
                    |              |
                    v              v
            +---------------+  +------------------+
            | NITRIFICATION |  |  DENITRIFICATION |
            |   NH3 → NO2   |  |   NO3 → N2 gas   |
            |   NO2 → NO3   |  |   (bc2_m factor) |
            | (bc1, bc2)    |  +------------------+
            +---------------+              |
                    |                      |
                    v                      v
            +---------------+  +------------------+
            | ALGAL UPTAKE  |  |    SETTLING      |
            |  (removes     |  | (organic matter  |
            |   NO3 for     |  |  and nutrients)  |
            |   growth)     |  |     (rs4)        |
            +---------------+  +------------------+
                           |        |
                           v        v
                +-----------------------+
                |  SEMI-ANALYTICAL      |
                |  SOLUTION             |
                |  wq_semianalyt()      |
                |  factm = -bc2_m       |
                +-----------------------+
                           |
                           v
                +-----------------------+
                |  CONCENTRATION        |
                |  CHECK & UPDATE       |
                |  if ht3%no3 < 1e-6    |
                |    ht3%no3 = 0        |
                +-----------------------+
                           |
                           v
                +-----------------------+
                |  MASS CONVERSION      |
                |  ht2%no3 = ht3%no3 *  |
                |  ht1%flo / 1000       |
                +-----------------------+
                           |
                           v
                +-----------------------+
                |  OUTPUT ASSIGNMENT    |
                |  ch_sed_bud(ich)%     |
                |  out_no3 = ht2%no3    |
                +-----------------------+
                           |
                           v
                    +-------------+
                    |  out_no3    |  (Final output value)
                    +-------------+
```

## Process Equations and Negative Value Sources

### 1. Semi-Analytical Solution (wq_semianalyt)

```
For NO3 concentration:
factm = -bc2_m  (negative because NO3 is being consumed)

ht3%no3 = wq_semianalyt(tday, rt_delt, factm, 0., ht3%no3, ht3%no3)

Where the solution involves:
help1 = 1/tres - prock
help2 = exp(-tdel * help1)
help3 = cint/tres + term_m  
help4 = help3/help1
result = cprev * help2 + help4 * (1 - help2)
```

**Negative values can occur when:**
- `bc2_m` (consumption rate) is very high
- `help3` becomes strongly negative due to large `term_m` values
- Exponential terms create instabilities

### 2. Alternative Transformation Route

```
When bsn_cc%qual2e == 1:

conc_chng = 1 - exp(-sd_ch(ich)%n_sol_part * rcurv%ttime)
ch_trans%orgn = conc_chng * ht1%orgn
ch_trans%no3 = ch_trans%orgn
ht2%no3 = ht1%no3 - ch_trans%no3
```

**Negative values can occur when:**
- `ch_trans%no3` > `ht1%no3` (more transformation than available NO3)
- High `n_sol_part` coefficient
- Long residence time (`rcurv%ttime`)

## Key Parameters Affecting out_no3

| Parameter | Description | Units | Effect on out_no3 |
|-----------|-------------|-------|-------------------|
| `bc2` | NO2→NO3 biological oxidation rate | 1/hr | High values can cause overconsumption |
| `rs4` | Organic N settling rate | 1/day | Affects N cycling balance |
| `n_sol_part` | Nitrogen solid-solution partitioning | 1/day | Controls transformation rates |
| `rcurv%ttime` | Channel residence time | hours | Longer times = more transformation |
| Temperature | Water temperature | °C | Affects all biochemical rates |
| Dissolved O2 | Oxygen concentration | mg/L | Controls aerobic/anaerobic processes |

## Diagnostic Steps for Negative out_no3

1. **Check transformation rates:**
   ```
   bc2_m = wq_k2m(tday, rt_delt, bc2_k, ht3%no2, ht3%no2)
   factm = -bc2_m
   ```

2. **Examine input concentrations:**
   ```
   ht3%no3 = 1000. * ht1%no3 / ht1%flo
   ```

3. **Review residence time:**
   ```
   tday = rcurv%ttime / 24.0
   ```

4. **Verify flow conditions:**
   ```
   Check if ht1%flo > 1.e-6 (minimum flow threshold)
   ```

## Common Scenarios Leading to Negative Values

### Scenario 1: High Denitrification
- Anaerobic conditions (low dissolved oxygen)
- High organic matter content
- Warm temperatures
- Long residence times

### Scenario 2: Algal Bloom
- High light conditions
- Nutrient-rich water
- Rapid algal growth consuming available NO3

### Scenario 3: Parameterization Issues
- `bc2` coefficient too high
- `n_sol_part` coefficient too high  
- Unrealistic channel characteristics

### Scenario 4: Numerical Issues
- Very small flow values causing concentration spikes
- Extreme temperature values affecting rate constants
- Convergence problems in semi-analytical solutions