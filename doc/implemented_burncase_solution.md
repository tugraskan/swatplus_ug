# Implemented Burncase Solution Analysis

## Overview

This document explains the implemented solution in the burncase branch's TxtInOut directory, comparing what was actually implemented versus what the original user attempted, and providing a technical walkthrough of how the working solution operates.

## What the Original User Wanted vs. What Was Implemented

### Original User's Intent (from burncase root files)

The original user attempted to create a fire and recovery scenario with the following sequence:

1. **Forest to Grassland (2012)**: Convert 70% of forest to grassland - January 1, 2012
2. **Moderate Fire (2016)**: Apply 40% plant kill - January 1, 2016  
3. **Severe Fire (2016)**: Apply 70% plant kill - June 1, 2016
4. **Fast Recovery (2017)**: 60% recovery rate - January 1, 2017
5. **Slow Recovery (2017)**: 30% recovery rate - June 1, 2017
6. **Reforestation (2017)**: Convert 80% of grass back to forest - January 1, 2017

**Issues with Original Approach:**
- Used invalid action `plant_kill` (doesn't exist)
- Attempted `grow_init` which only works with hru_lte, not regular HRUs
- Fire burns had `option: null` instead of referencing fire database
- Missing land use targeting conditions
- Overly complex mixing of fires, kills, and recovery

### What the Implemented Solution Actually Models

The implemented solution **simplifies and corrects** the scenario to focus on:

1. **Land Use Change Progression**: Forest → Grassland → Forest (with variations)
2. **Fire Events on Forest HRUs**: Two fire events with different intensities (40% and 70% burn)
3. **Differential Recovery Rates**: Reforestation with fast (60%) vs slow (30%) recovery probabilities

**Key Philosophical Change:**
- **Original**: Attempted to mix fire events, plant kills, and abstract recovery percentages
- **Implemented**: Uses land use changes as the primary mechanism, with fire events applied to forest HRUs via management schedules

The implemented approach models **land use transitions driven by disturbance and recovery** rather than trying to directly manipulate plant growth parameters.

## How the Implemented Solution Works

### Architecture Overview

The solution uses **two decision table files** working together:

1. **scen_lu.dtl** (Scenario Decision Tables): Controls land use changes
2. **lum.dtl** (Land Use Management Decision Tables): Controls fire operations

### Component 1: Land Use Definitions (landuse.lum)

```
rnge_lum         - Rangeland (post-conversion grassland)
frst_lum         - Original forest
frst_fast_lum    - Forest with fast recovery characteristics  
frst_slow_lum    - Forest with slow recovery characteristics
```

**Key Addition**: The `frst_fast_lum` and `frst_slow_lum` land use types allow different forest recovery trajectories to be modeled with potentially different management schedules, growth parameters, or plant communities.

### Component 2: Scenario Decision Tables (scen_lu.dtl)

**Three land use change scenarios**, triggered by year and day:

#### Scenario 1: Forest to Grass (2012)
```
name: forest_to_grass
conds: 4 (year_cal, jday, land_use, prob)
- Trigger: January 1, 2012 (year=2012, jday=1)
- Target: Only frst_lum HRUs (land_use = frst_lum)
- Probability: 70% (prob < 0.70)
- Action: lu_change from frst_to_rnge → rnge_lum
```

**How it works:**
- On Jan 1, 2012, SWAT+ evaluates all HRUs
- Only HRUs with land_use = frst_lum are considered
- 70% of those HRUs are randomly selected (probability condition)
- Selected HRUs change to rnge_lum (rangeland)

#### Scenario 2: Fast Reforestation (2017)
```
name: reforest_fast_2017
conds: 4 (year_cal, jday, land_use, prob)
- Trigger: January 1, 2017 (year=2017, jday=1)
- Target: Only rnge_lum HRUs (land_use = rnge_lum)
- Probability: 60% (prob < 0.60)
- Action: lu_change from rnge_to_frst → frst_fast_lum
```

**How it works:**
- On Jan 1, 2017, evaluates all rangeland HRUs
- 60% of rangeland HRUs randomly selected
- Selected HRUs convert to frst_fast_lum (fast recovering forest)

#### Scenario 3: Slow Reforestation (2017)
```
name: reforest_slow_2017
conds: 4 (year_cal, jday, land_use, prob)
- Trigger: June 1, 2017 (year=2017, jday=152)
- Target: Only rnge_lum HRUs (land_use = rnge_lum)
- Probability: 30% (prob < 0.30)
- Action: lu_change from rnge_to_frst → frst_slow_lum
```

**How it works:**
- On June 1, 2017, evaluates remaining rangeland HRUs
- 30% of remaining rangeland HRUs selected
- Selected HRUs convert to frst_slow_lum (slow recovering forest)

**Note on Probability Logic:**
- Fast recovery happens first (Jan 1) with 60% probability
- Slow recovery happens later (June 1) with 30% probability of remaining rangeland
- Some rangeland may remain as permanent grassland (neither scenario triggers)

### Component 3: Fire Events (lum.dtl)

Fire operations are defined in the **Land Use Management decision tables** (lum.dtl), not in the scenario tables. This is the key architectural decision.

#### Fire Event 1: Moderate Fire (January 2016)
```
name: burn_jan_2016
conds: 4 (year_cal, jday, land_use, prob)
- Trigger: January 1, 2016 (year=2016, jday=1)
- Target: Only frst_lum HRUs
- Probability: 40% (prob < 0.40)
- Action: burn with option=tree_low
```

**References fire.ops database:**
```
tree_low: chg_cn2=6.00, frac_burn=0.70
```

**How it works:**
- On Jan 1, 2016, evaluates forest HRUs
- **40% of forest HRUs randomly selected** for burning (prob < 0.40 = HRU selection probability)
- **On selected HRUs, burn operation applies 70% biomass reduction** (frac_burn=0.70 = burn intensity)
- Curve number increased by 6 (chg_cn2=6.00) to reflect reduced cover

**Note**: These are two distinct parameters:
- `prob < 0.40`: Controls which HRUs are selected (40% spatial coverage)
- `frac_burn=0.70`: Controls burn intensity on selected HRUs (70% biomass reduction)

#### Fire Event 2: Severe Fire (June 2016)
```
name: burn_june_2016
conds: 4 (year_cal, jday, land_use, prob)
- Trigger: June 1, 2016 (year=2016, jday=152)
- Target: Only frst_lum HRUs  
- Probability: 70% (prob < 0.70)
- Action: burn with option=tree_intense
```

**References fire.ops database:**
```
tree_intense: chg_cn2=8.00, frac_burn=0.90
```

**How it works:**
- On June 1, 2016, evaluates forest HRUs
- **70% of forest HRUs randomly selected** for burning (prob < 0.70 = HRU selection probability)
- **On selected HRUs, burn operation applies 90% biomass reduction** (frac_burn=0.90 = burn intensity)
- Curve number increased by 8 (chg_cn2=8.00) for more severe fire impact

**Note**: Again, two distinct parameters:
- `prob < 0.70`: Controls which HRUs are selected (70% spatial coverage)
- `frac_burn=0.90`: Controls burn intensity on selected HRUs (90% biomass reduction)

**Important Note**: These fires target `frst_lum` HRUs, which includes forests that haven't been converted to grassland yet. The fires happen AFTER the 2012 conversion, so they would affect:
- The 30% of original forest that didn't convert to grassland in 2012
- Any HRUs that started as forest but weren't selected for conversion

### Component 4: Control File (scen_dtl.upd)

```
num_hits=0 for all scenarios
```

Activates the three land use change scenarios from scen_lu.dtl:
1. forest_to_grass
2. reforest_fast_2017
3. reforest_slow_2017

**Note**: Fire operations are NOT listed here because they're in lum.dtl, not scen_lu.dtl. The fires are automatically active for all HRUs that have the management schedules referencing the burn decision tables.

## Timeline of Events

Here's what happens chronologically in the simulation:

**2012, Jan 1**: 70% of forest HRUs convert to rangeland (forest_to_grass)
- Forest land use changes from frst_lum → rnge_lum

**2016, Jan 1**: 40% of remaining forest HRUs experience moderate fire (burn_jan_2016)
- Applies to frst_lum HRUs only (not the converted rangeland)
- 70% biomass burn, CN increases by 6

**2016, Jun 1**: 70% of remaining forest HRUs experience severe fire (burn_june_2016)
- Applies to frst_lum HRUs only
- 90% biomass burn, CN increases by 8

**2017, Jan 1**: 60% of rangeland converts to fast-recovery forest (reforest_fast_2017)
- Rangeland changes from rnge_lum → frst_fast_lum

**2017, Jun 1**: 30% of remaining rangeland converts to slow-recovery forest (reforest_slow_2017)
- Rangeland changes from rnge_lum → frst_slow_lum

## Key Technical Features

### 1. Proper Conditional Targeting

**All decision tables use 4 conditions:**
- `year_cal`: Triggers on specific year
- `jday`: Triggers on specific Julian day
- `land_use`: **Targets only specific land use types**
- `prob`: **Probabilistic selection of HRUs**

This ensures:
- Actions only apply to intended HRU types
- Realistic spatial heterogeneity through probability
- No unintended side effects on wrong HRUs

### 2. Separation of Concerns

**Scenario tables (scen_lu.dtl)**: Land use changes
**Management tables (lum.dtl)**: Operations on existing land uses (fires)

This separation allows:
- Fires to be tied to specific land uses (frst_lum)
- Land use changes to be scenario-driven
- Different management for different land use types

### 3. Fire Database Integration

Burns reference `fire.ops` database entries:
- `tree_low`: 70% burn fraction (moderate fire)
- `tree_intense`: 90% burn fraction (severe fire)

This provides:
- Proper biomass reduction
- Curve number updates
- Consistent fire parameter management

### 4. No Use of Invalid Actions

**Avoided:**
- `plant_kill` (doesn't exist) → Used proper `burn` action
- `grow_init` (hru_lte only) → Used land use changes instead

**Used:**
- `lu_change`: Standard land use change action
- `burn`: Properly configured with fire database

### 5. Recovery Through Land Use Types

Instead of trying to manipulate growth directly with `grow_init`, recovery is modeled through:
- Different forest land use types (frst_fast_lum, frst_slow_lum)
- These can have different management schedules
- Allows future customization of growth rates, plant communities, etc.

## Comparison Summary

| Aspect | Original Attempt | Implemented Solution |
|--------|------------------|---------------------|
| **Fire Method** | plant_kill (invalid) + burn with null option | burn with proper fire.ops references |
| **Recovery Method** | grow_init (hru_lte only) | Land use changes to different forest types |
| **Targeting** | Only year and day (2 conditions) | Year, day, land_use, probability (4 conditions) |
| **File Structure** | All in scen_lu.dtl | scen_lu.dtl for LU changes, lum.dtl for fires |
| **Land Use Types** | Missing frst_fast/slow_lum | Added frst_fast_lum and frst_slow_lum |
| **Probability** | Used const parameter incorrectly | Proper prob condition |
| **num_hits** | Non-zero (1-6) | Zero (proper initialization) |

## Why This Approach Works Better

1. **Valid SWAT+ Actions**: Only uses actions that exist and work with regular HRUs
2. **Proper Fire Implementation**: Burns reference actual fire database with frac_burn parameters
3. **Spatial Heterogeneity**: Probability conditions create realistic landscape patterns
4. **Extensible**: Can add different management schedules to frst_fast_lum vs frst_slow_lum
5. **Clean Separation**: Scenarios handle land use transitions, management handles operations
6. **Proper Targeting**: land_use conditions ensure actions only affect intended HRUs

## Potential Enhancements

The current implementation could be extended to:

1. **Different Management Schedules**: Assign different management schedules to frst_fast_lum and frst_slow_lum to control actual growth rates

2. **Different Plant Communities**: Use different plant community definitions for fast vs slow recovering forest

3. **Fire.ops File**: Add a fire.ops file to TxtInOut (currently relies on reference data) with the actual values used:
   ```
   fire.ops: written by SWAT+ editor v3.1.0
   name                   chg_cn2     frac_burn  description
   tree_low               6.00000       0.70000  moderate fire 70% burn
   tree_intense           8.00000       0.90000  severe fire 90% burn
   ```
   Note: These match the values from refdata/Osu_1hru/fire.ops that the simulation uses

4. **Post-Fire Recovery**: Add additional decision tables in lum.dtl that trigger growth operations after fire events

5. **Conditional Reforestation**: Make reforestation probability dependent on fire history or other factors

## Conclusion

The implemented solution successfully models a fire disturbance and recovery scenario by:
- Using land use changes as the primary mechanism for landscape transitions
- Applying fire events through management decision tables with proper fire database integration
- Creating differential recovery pathways through distinct land use types
- Properly targeting specific HRUs using land_use and probability conditions

This approach is more maintainable, extensible, and aligned with SWAT+ architecture than the original attempt that mixed invalid actions and improper conditional logic.
