# SWAT+ Land Use Change System: Complete Documentation Package

This documentation package provides comprehensive guidance on understanding and implementing land use changes in SWAT+.

## Files in This Package

### 1. Core Documentation
- **`land_use_change_guide.md`** - Complete technical guide explaining the SWAT+ land use change system
- **`your_scenario_walkthrough.md`** - Specific analysis of the user's forest conversion scenario

### 2. Example Files
- **`data/examples/`** - Directory containing practical examples:
  - `simple_scen_lu.dtl` - Basic single land use change
  - `simple_scen_dtl.upd` - Control file for simple scenario  
  - `complex_scen_lu.dtl` - Advanced multi-scenario example
  - `complex_scen_dtl.upd` - Control file for complex scenarios
  - `README.md` - Guide to using the examples

## Quick Start Guide

### Understanding the System
1. **Read**: `land_use_change_guide.md` for comprehensive understanding
2. **Study**: Your specific scenario in `your_scenario_walkthrough.md`
3. **Practice**: Use examples in `data/examples/` to test concepts

### Key Concepts

**Decision Tables (`scen_lu.dtl`)**: Define WHEN and HOW land use changes occur
- **Conditions**: Year, day, current land use, environmental factors
- **Actions**: What to do when conditions are met (lu_change, irrigate, harvest, etc.)

**Scenario Control (`scen_dtl.upd`)**: Controls HOW OFTEN each decision table executes
- Prevents infinite loops
- Limits frequency of applications

### Your Forest Conversion Scenario

You have 40 decision tables converting:
1. **Forest → Grass** (2005)
2. **Forest → Winter Wheat** (2018-2022)

Each decision table targets:
- Specific forest types (frsd_tecf_sb, frse_tecf_db, etc.)
- Specific years and dates (January 1st of target years)
- Converts to appropriate land use (grass or winter wheat variants)

## Implementation Checklist

### ✅ Required Files
- [ ] `scen_lu.dtl` - Your decision tables (you have this)
- [ ] `scen_dtl.upd` - Control file (you need to create this)
- [ ] `landuse.lum` - Must contain all source and target land uses
- [ ] Update `file.cio` to reference your scenario files

### ✅ Verification Steps
- [ ] All land use names in scen_lu.dtl exist in landuse.lum
- [ ] All decision table names in scen_dtl.upd match those in scen_lu.dtl
- [ ] Initial HRU land uses match expected source land uses
- [ ] Target land uses are properly defined with management practices

### ✅ Testing Process
1. [ ] Start with simple test case (1-2 decision tables)
2. [ ] Run simulation and check `lu_change_out.txt`
3. [ ] Verify expected changes occur at correct times
4. [ ] Gradually add more decision tables
5. [ ] Monitor results throughout simulation period

## Common Patterns in Your Scenario

### Time-Based Triggers
```
year_cal = 2005  # Calendar year
jday = 1         # January 1st
```

### Land Use Targeting
```
land_use = frsd_tecf_sb_lum  # Only target specific forest type
```

### Action Definition
```
lu_change -> gras_sb_lum  # Convert to grassland
lu_change -> wost_sb_lum  # Convert to winter wheat
```

## Troubleshooting Quick Reference

| Problem | Likely Cause | Solution |
|---------|--------------|----------|
| No changes occur | Land use name mismatch | Check spelling in all files |
| Wrong HRUs affected | Incorrect land_use condition | Verify initial HRU assignments |
| Changes happen multiple times | Missing max_hits limit | Check scen_dtl.upd values |
| Wrong target land use | Incorrect file_pointer | Verify target names in landuse.lum |

## Advanced Features You Could Add

### Environmental Triggers
Add conditions like water stress or soil moisture:
```
w_stress > 0.8     # High water stress
soil_water < 0.5   # Low soil water
```

### Probabilistic Changes
Add randomness to conversions:
```
prob < 0.1  # 10% probability
```

### Conditional Logic
Create more sophisticated decision rules:
```
year_cal >= 2015 AND w_stress < 0.3  # From 2015 onwards, low stress only
```

## Next Steps

1. **Immediate**: Create your `scen_dtl.upd` file with all 40 decision tables
2. **Verify**: Check that all land use names exist in your `landuse.lum`
3. **Test**: Start with a subset of your decision tables
4. **Monitor**: Use `lu_change_out.txt` to verify correct behavior
5. **Expand**: Gradually add more complexity or environmental conditions

## Support Resources

- **Technical Reference**: `land_use_change_guide.md`
- **Your Scenario**: `your_scenario_walkthrough.md`  
- **Practice Examples**: `data/examples/`
- **Source Code**: Key files are `src/conditions.f90` and `src/actions.f90`

This documentation should provide everything you need to successfully implement and troubleshoot your SWAT+ land use change scenarios.