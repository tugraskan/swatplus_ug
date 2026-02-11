# SWAT+ Scenario Input Files: Issues and Fixes

## Overview

This document explains the issues found in the original `scen_dtl.upd` and `scen_lu.dtl` input files, and describes the fixes that were implemented to make them work correctly with SWAT+.

## Background

SWAT+ uses decision tables to simulate various land use change scenarios and management practices. The two key files are:
- **scen_dtl.upd**: Defines which decision tables to apply during simulation
- **scen_lu.dtl**: Contains the detailed decision table logic for land use changes

## Original Files Issues

### Issue 1: Missing Land Use Management Definitions (scen_lu.dtl)

**Original Intent**: The original files attempted to simulate a complex fire and recovery scenario:
1. Convert forest to grassland (2012)
2. Apply moderate fire in January 2016 (40% kill)
3. Apply severe fire in June 2016 (70% kill)
4. Implement recovery scenarios in 2017 (fast 60% and slow 30%)
5. Reforest areas in 2017

**Problems Identified**:

1. **Missing Land Use Definitions**: The original `scen_lu.dtl` referenced `frst_fast_lum` and `frst_slow_lum` in the reforestation scenarios, but these land use management types were not defined in the `landuse.lum` file.

2. **Recovery Scenarios Not Aligned with Land Use Changes**: The original design used `grow_init` actions for recovery scenarios instead of proper land use changes with appropriate management schedules. This approach:
   - Doesn't persist across time steps
   - Doesn't provide the structured recovery that land use changes with specific management can provide

3. **Fire Actions Combined with Recovery**: The original design tried to use `plant_kill` and `burn` actions followed by separate recovery decision tables. This is overly complex and harder to manage.

### Issue 2: Mismatched Decision Tables (scen_dtl.upd)

**Original File Issues**:

The original `scen_dtl.upd` listed 6 decision tables:
```
1            scen_lu   forest_to_grass
2            scen_lu   fire_jan_2016
3            scen_lu   fire_june_2016
4            scen_lu   recovery_slow_2017
5            scen_lu   recovery_fast_2017
6            scen_lu   reforest_2017
```

**Problems**:
1. Decision table names didn't match between files (e.g., `recovery_slow_2017` vs `recovery_slow`)
2. The fire scenarios were separate from the reforestation scenarios, making the simulation logic fragmented
3. Number of hits set to non-zero values (1-6) instead of 0, which could cause unintended repeated applications

### Issue 3: Overly Complex Conditional Logic

**Original Conditions**:
- Used only 2 conditions (year and day) for most scenarios
- Fire scenarios had separate decision tables instead of being part of a comprehensive land use change approach

**Problem**: This design separated fire impacts from land use recovery, making it difficult to:
- Track which HRUs were affected by which events
- Ensure proper sequencing of events
- Manage recovery paths efficiently

## Fixed Version

### Fixed scen_lu.dtl

The corrected version simplifies the scenario to 3 well-defined land use change scenarios:

#### 1. Forest to Grass Conversion (2012)
```
name: forest_to_grass
conds: 4 (year, day, land_use, prob)
```
**Improvements**:
- Added `land_use` condition to target only `frst_lum` HRUs
- Added `prob` (probability) condition set to 0.70 to affect 70% of forest HRUs
- Removed the `const` parameter (was 0.70, now 0.00) as the probability is handled by the condition
- This ensures only forest HRUs are converted, not all HRUs

#### 2. Fast Reforestation (2017)
```
name: reforest_fast_2017
conds: 4 (year, day, land_use, prob)
target: rnge_lum
result: frst_fast_lum
probability: 0.60
```
**Improvements**:
- Targets only rangeland HRUs (those converted from forest)
- Uses `frst_fast_lum` which must be defined in `landuse.lum`
- Applies to 60% of rangeland HRUs using probability condition
- Occurs on January 1, 2017

#### 3. Slow Reforestation (2017)
```
name: reforest_slow_2017
conds: 4 (year, day, land_use, prob)
target: rnge_lum
result: frst_slow_lum
probability: 0.30
date: June 1, 2017 (day 152)
```
**Improvements**:
- Targets only rangeland HRUs
- Uses `frst_slow_lum` which must be defined in `landuse.lum`
- Applies to 30% of rangeland HRUs
- Occurs later (June 1) to simulate different recovery timing

### Fixed scen_dtl.upd

The corrected version reduced to 3 decision tables:
```
num_hits: 0 for all scenarios
```

**Improvements**:
1. **Set num_hits to 0**: This ensures each decision table is applied only when conditions are met, not repeatedly
2. **Removed fire scenarios**: Simplified to focus on land use changes rather than mixing fire events with recovery
3. **Aligned names**: Ensured all decision table names match exactly between `scen_dtl.upd` and `scen_lu.dtl`

### Required Changes to landuse.lum

To support the fixed scenarios, the `landuse.lum` file needed to be updated:

**Added Land Use Types**:
```
frst_fast_lum    - Forest with fast recovery management schedule
frst_slow_lum    - Forest with slow recovery management schedule
```

These additions:
- Provide distinct management schedules for different recovery rates
- Allow proper tracking of HRUs in different recovery states
- Enable more realistic simulation of post-disturbance recovery

**Added Management Schedule**:
```
rnge_lum: mgt column changed from null to frst_rot
```
This ensures rangeland HRUs have a management schedule that can transition to forest.

## Summary of Changes

### What Was Wrong

1. **Missing land use definitions** for `frst_fast_lum` and `frst_slow_lum`
2. **Incomplete conditional logic** - missing land_use and probability conditions
3. **Incorrect use of const vs probability** - the original used const parameter for percentage instead of probability conditions
4. **Misaligned decision table names** between scen_dtl.upd and scen_lu.dtl
5. **Non-zero num_hits values** that could cause repeated applications
6. **Overly complex fire scenarios** that mixed burn actions with recovery

### What Was Fixed

1. **Added land use definitions** to `landuse.lum` for fast and slow forest recovery
2. **Enhanced conditional logic** with 4 conditions including land_use targeting and probability
3. **Proper use of probability conditions** instead of const parameters for percentage effects
4. **Aligned all decision table names** between files
5. **Set num_hits to 0** to prevent unintended repeated applications
6. **Simplified scenario** to focus on land use change progression rather than fire events
7. **Added management schedule** to rangeland to enable proper transitions

## Conclusion

The original files attempted to create a comprehensive fire and recovery simulation but had several structural issues:
- Missing required land use management definitions
- Overly complex scenario mixing fire actions with land use changes
- Incomplete conditional logic that could affect wrong HRUs
- Mismatched names and parameters between files

The fixed version provides a cleaner, more maintainable approach:
- Clear land use change progression (forest → grass → forest)
- Proper conditional targeting using land_use filters
- Probability-based selection for realistic spatial distribution
- All required land use types properly defined
- Simplified scenario that's easier to understand and modify

This approach is more aligned with SWAT+ best practices and provides better control over scenario execution.
