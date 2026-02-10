# Answer: Column Header for vcr_coef

## Direct Answer

**The current `hyd-sed-lte.cha` file format does NOT have a column header for `vcr_coef`.**

## Explanation

The `vcr_coef` parameter is defined in the code structure (`swatdeg_channel_dynamic` type in `src/sd_channel_module.f90`), but it is **not included** in the existing `hyd-sed-lte.cha` file format.

### Current File Header
The `hyd-sed-lte.cha` file contains these columns:
```
name, order, wd, dp, slp, len, mann, k, erod_fact, cov_fact, wd_rto, eq_slp, 
d50, clay, carbon, dry_bd, side_slp, bed_load, fps, fpn, n_conc, p_conc, 
p_bio, description
```

### Impact

- **Default Value**: Since `vcr_coef` is not in the file, it uses the default value of **0.0**
- **Effect**: This effectively **disables** the velocity-based bank erosion calculation because the critical velocity is multiplied by 0
- **Location**: See `src/sd_channel_sediment3.f90` line 170: `vel_cr = sd_ch(ich)%vcr_coef * vel_cr`

### Workaround

To use `vcr_coef`, you can:
1. Set it via calibration parameters (see `src/cal_parm_select.f90` lines 622-624)
2. Modify the file format to include the column (would require structural changes)

## For More Details

See `doc/vcr_coef_source.md` for comprehensive documentation about `vcr_coef`, including:
- Input file source
- Data flow through the codebase
- File format details
- Usage in calculations
- Calibration options
