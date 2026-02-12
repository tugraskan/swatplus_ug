# SWAT+ Burncase Scenario Documentation

This directory contains comprehensive documentation analyzing fire disturbance and recovery scenarios in SWAT+.

## Documentation Files

### 1. [burncase_input_analysis.md](burncase_input_analysis.md) (297 lines)
**Analyzes the original problematic inputs** from the burncase branch root directory.

**Key Content:**
- What the user was trying to accomplish (fire and recovery scenario)
- 6 critical issues preventing the scenario from working:
  1. Invalid `plant_kill` action (doesn't exist in SWAT+)
  2. `burn` action missing fire.ops database configuration
  3. `grow_init` only works with hru_lte objects, not regular HRUs
  4. Mismatched decision table names between files
  5. Missing land_use and probability conditional targeting
  6. Non-zero num_hits causing unexpected behavior
- Source code verification from SWAT+ Fortran files
- Corrected syntax examples with proper fire.ops configuration
- Alternative management schedule approach suggestions

**Use this document to:**
- Understand common mistakes when setting up fire scenarios
- Learn what SWAT+ actions are valid for HRUs
- See how to properly configure burn operations
- Understand the difference between kill (complete) vs burn (partial mortality)

### 2. [implemented_burncase_solution.md](implemented_burncase_solution.md) (311 lines)
**Explains the working solution** in the burncase/TxtInOut directory.

**Key Content:**
- What the implemented approach models vs original intent
- Complete architecture using scen_lu.dtl and lum.dtl
- Detailed walkthrough of all scenarios and conditions
- Timeline of events from 2012-2017:
  - 2012: Forest to grassland conversion (70%)
  - 2016: Two fire events (40% and 70% spatial coverage, with 70% and 90% burn intensity)
  - 2017: Differential reforestation (fast 60%, slow 30%)
- Technical explanation of probability vs burn intensity
- Comparison table of original vs implemented approach
- Enhancement suggestions for future work

**Use this document to:**
- Understand the working fire scenario implementation
- Learn how to separate land use changes (scen_lu.dtl) from operations (lum.dtl)
- See proper 4-condition targeting (year, day, land_use, prob)
- Model differential recovery rates through land use types
- Implement spatial heterogeneity using probability conditions

## Quick Reference: Key Differences

| Feature | Original (Broken) | Implemented (Working) |
|---------|------------------|----------------------|
| **Fire Method** | plant_kill + burn with null | burn with fire.ops references |
| **Recovery** | grow_init (hru_lte only) | Land use type changes |
| **Conditions** | 2 (year, day) | 4 (year, day, land_use, prob) |
| **Structure** | All in scen_lu.dtl | scen_lu.dtl + lum.dtl |
| **Targeting** | All HRUs | Specific land use types only |
| **num_hits** | 1-6 | 0 (correct) |

## Common Fire Scenario Patterns

### Pattern 1: Fire Events in Management Schedules (lum.dtl)
**When to use:** Fire operations tied to specific land uses
```
burn_event
  conds: 4 (year_cal, jday, land_use, prob)
  action: burn with fire.ops reference
```

### Pattern 2: Land Use Changes in Scenarios (scen_lu.dtl)
**When to use:** Changing land use types over time
```
land_use_transition
  conds: 4 (year_cal, jday, land_use, prob)
  action: lu_change to different land use type
```

### Pattern 3: Differential Recovery
**How to implement:** Create different land use types for different recovery rates
- Define: frst_fast_lum, frst_slow_lum
- Assign different management schedules or plant communities
- Use probability to create spatial patterns

## Required Files for Fire Scenarios

1. **fire.ops** - Fire operation parameters
   ```
   name           chg_cn2    frac_burn
   tree_low       6.00000    0.70000
   tree_intense   8.00000    0.90000
   ```

2. **landuse.lum** - Land use type definitions
   - Must include all land use types referenced in decision tables
   - frst_lum, rnge_lum, frst_fast_lum, frst_slow_lum, etc.

3. **scen_lu.dtl** - Land use change decision tables
   - 4 conditions minimum (year, day, land_use, prob)
   - Use lu_change actions

4. **lum.dtl** - Management operation decision tables
   - Fire events with burn actions
   - Reference fire.ops entries in option field

5. **scen_dtl.upd** - Scenario control file
   - Lists which decision tables from scen_lu.dtl to activate
   - Set num_hits=0

## Key Concepts

### HRU Selection Probability vs Operation Intensity
These are **two distinct parameters**:

**Probability (prob condition)**: Which HRUs are selected
- `prob < 0.40` means 40% of HRUs are randomly selected
- Controls spatial coverage/pattern

**Burn Intensity (frac_burn in fire.ops)**: How much biomass burns on selected HRUs
- `frac_burn=0.70` means 70% biomass reduction
- Controls severity of disturbance

**Example:**
- `prob < 0.40` + `frac_burn=0.70` = 40% of landscape affected, each with 70% burn

### Land Use Targeting
**Always use land_use conditions** to prevent actions from affecting wrong HRUs:
```
land_use    hru    0    frst_lum    -    0.00000    =
```
This ensures burns only affect forest, not agricultural or urban HRUs.

### Recovery Modeling Options

**Option 1: Land Use Type Changes** (Recommended)
- Create frst_fast_lum and frst_slow_lum
- Different management schedules
- Different plant communities
- Extensible and maintainable

**Option 2: Direct Growth Manipulation** (Not Recommended)
- grow_init only works with hru_lte simulations
- Not available for standard HRU runs
- Limited flexibility

## Source Code References

All findings in these documents are verified against SWAT+ source code:
- `src/actions.f90` - All action implementations
- `src/dtbl_lum_read.f90` - Decision table reading
- `src/pl_burnop.f90` - Burn operation
- `src/mgt_killop.f90` - Kill operation
- `src/hru_lte_module.f90` - Long-term environmental tracking

## Example Scenario Timeline

A complete fire disturbance and recovery scenario:

```
Year 2012, Day 1 (Jan 1):
  └─ forest_to_grass: 70% of frst_lum → rnge_lum

Year 2016, Day 1 (Jan 1):
  └─ burn_jan_2016: 40% of frst_lum get 70% burn (tree_low)

Year 2016, Day 152 (Jun 1):
  └─ burn_june_2016: 70% of frst_lum get 90% burn (tree_intense)

Year 2017, Day 1 (Jan 1):
  └─ reforest_fast_2017: 60% of rnge_lum → frst_fast_lum

Year 2017, Day 152 (Jun 1):
  └─ reforest_slow_2017: 30% of remaining rnge_lum → frst_slow_lum
```

## Contributing

When creating new fire scenarios:
1. Always verify action names against `src/actions.f90`
2. Use 4 conditions minimum for proper targeting
3. Separate land use changes from operations
4. Test with small probabilities first
5. Document fire.ops parameters used

## See Also

- [SWAT+ I/O Documentation](https://swatplus.gitbook.io/docs)
- [SWAT+ Source Documentation](https://swat-model.github.io/swatplus)
- [Building SWAT+](Building.md)
- [Testing Scenarios](Testing.md)
