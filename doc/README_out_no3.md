# SWAT+ out_no3 Documentation

This documentation explains the `out_no3` variable in SWAT+ (Soil & Water Assessment Tool Plus), addressing common questions about what it represents, where it comes from, and why it might become negative.

## Documentation Files

### 1. [Quick Reference Guide](out_no3_quick_reference.md)
**For users who need immediate answers**
- Summary of what `out_no3` represents
- Common value ranges and interpretation
- Troubleshooting steps for negative values
- Key parameters to check

### 2. [Technical Analysis](out_no3_analysis.md)
**For detailed understanding and model developers**
- Complete technical explanation of calculations
- Source code locations and implementation details
- Mathematical equations and transformation processes
- Comprehensive analysis of negative value causes

### 3. [Nitrogen Flow Diagram](nitrogen_flow_diagram.md)
**For understanding the process flow**
- Visual representation of nitrogen cycling in channels
- Process equations and parameter interactions
- Step-by-step calculation walkthrough
- Diagnostic procedures

## Quick Answer

**What is out_no3?**
`out_no3` represents the mass of nitrate nitrogen (NO3-N) flowing out of a stream channel reach, typically measured in tons N or kg N per day.

**Where does it come from?**
It's calculated from incoming nitrate loads modified by in-stream biogeochemical processes including denitrification, algal uptake, and nitrification, using QUAL2E water quality equations.

**Why might it be negative?**
Negative values occur when in-stream consumption processes (like denitrification or algal uptake) remove more nitrate than is available, often due to:
- Over-parameterized reaction rates
- Extreme environmental conditions (low oxygen, high temperature)
- Numerical instabilities in the water quality calculations

## Key Files in SWAT+ Source Code

- `src/sd_channel_module.f90`: Variable definition
- `src/sd_channel_control3.f90`: Value assignment  
- `src/ch_watqual4.f90`: Water quality calculations
- `src/ch_watqual_semi_analitical_function.f90`: Mathematical solutions

## Getting Help

If you encounter persistent negative `out_no3` values:

1. Start with the [Quick Reference Guide](out_no3_quick_reference.md)
2. Check the troubleshooting section
3. Review parameter ranges and typical values
4. Consult the [Technical Analysis](out_no3_analysis.md) for deeper investigation

## Related Output Variables

- `in_no3`: Incoming nitrate nitrogen
- `fp_no3`: Floodplain nitrate processes
- `bank_no3`: Bank erosion nitrate
- `bed_no3`: Bed erosion nitrate
- `no3_orgn`: NO3 to organic nitrogen transformation