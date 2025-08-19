# SWAT+ Land Use Change Examples

This directory contains example files demonstrating different approaches to setting up land use change scenarios in SWAT+.

## Simple Example

**Files:**
- `simple_scen_lu.dtl` - Single land use change scenario
- `simple_scen_dtl.upd` - Control file for simple scenario

**Scenario:** Convert all cornland to forest on January 1, 2010

This example demonstrates:
- Basic time-based triggering (specific year and day)
- Land use condition checking
- Simple one-time land use change

## Complex Example

**Files:**
- `complex_scen_lu.dtl` - Multiple scenarios with environmental conditions
- `complex_scen_dtl.upd` - Control file for complex scenarios

**Scenarios:**
1. **Forest to Agriculture** - Convert forest to crops when water stress is low (after 2015)
2. **Agriculture to Forest** - Convert crops back to forest during drought conditions (after 2020)
3. **Urban Expansion** - Probabilistic urban development in 2025 (5% chance per HRU)
4. **Irrigation Management** - Automatic irrigation during growing season when plants are stressed
5. **Automatic Harvest** - Harvest when crops reach 95% maturity after July

This example demonstrates:
- Environmental condition triggering (water stress, soil moisture)
- Probabilistic applications
- Plant development-based triggering
- Management operations (irrigation, harvest)
- Multiple applications per scenario (different max_hits values)

## Using These Examples

1. Copy the desired .dtl and .upd files to your SWAT+ project directory
2. Update `file.cio` to reference your scenario files:
   - Set `dtbl_scen` to your .dtl file name
3. Create `scen_dtl.upd` file in your project directory
4. Ensure all referenced land use management names exist in your `landuse.lum` file
5. Run your simulation and check `lu_change_out.txt` for results

## Customization Tips

1. **Modify timing:** Change `year_cal` and `jday` values for different timing
2. **Target specific HRUs:** Use `land_use` conditions to target specific land uses
3. **Add environmental triggers:** Include conditions like `w_stress`, `soil_water`, `precip_cur`
4. **Adjust probabilities:** Modify `prob` values for stochastic applications
5. **Control frequency:** Adjust `max_hits` in the .upd file to limit applications

## Troubleshooting

- Verify land use names match those in your `landuse.lum` file
- Check that conditions can be satisfied simultaneously
- Monitor `lu_change_out.txt` to confirm changes are occurring as expected
- Start with simple scenarios and add complexity gradually