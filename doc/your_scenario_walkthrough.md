# Understanding Your SWAT+ Land Use Change Scenario

## Analysis of Your scen_lu.dtl File

Based on the `scen_lu.dtl` file you provided, you have set up a comprehensive forest conversion scenario with 40 different decision tables. Let me walk you through how this works:

## Your Scenario Overview

Your scenario involves converting different types of forest land use to either:
1. **Grassland** (in 2005)
2. **Winter wheat (wost)** (from 2018-2022)

## Forest Types in Your Scenario

You have several forest types being converted:

### 1. Forest Types:
- `frsd_tecf_sb` - Forest deciduous, temperate coniferous, shallow bedrock
- `frse_tecf_db` - Forest deciduous, temperate coniferous, deep bedrock  
- `frse_tecf_fb` - Forest deciduous, temperate coniferous, flat bottomland
- `frse_tecf_lb` - Forest deciduous, temperate coniferous, low bedrock
- `frse_tecf_sb` - Forest deciduous, temperate coniferous, shallow bedrock
- `frse_teyg_db` - Forest deciduous, temperate young growth, deep bedrock
- `frse_teyg_fb` - Forest deciduous, temperate young growth, flat bottomland
- `frse_teyg_sb` - Forest deciduous, temperate young growth, shallow bedrock

### 2. Conversion Targets:
- `gras_sb_lum` - Grassland shallow bedrock land use management
- `wost_db_lum`, `wost_sb_lum`, `wost_fb_lum`, `wost_lb_lum` - Winter wheat land use management for different soil types

## How Your Decision Tables Work

### Example 1: Forest to Grass (2005)
```
name                     conds      alts      acts       !changing all forest to grass on January 1, 2005
frsd_tecf_sb_to_grass         3         1         1  
var                        obj   obj_num           lim_var            lim_op     lim_const      alt1  
year_cal                  null         0              null                 -    2005.00000         =       !year 2005
jday                      null         0              null                 -       1.00000         =       !January 1
land_use                   hru         0  frsd_tecf_sb_lum                 -       0.00000         =       !forest land use (in landuse.lum)
act_typ                    obj   obj_num              name            option         const        const2                fp  outcome           
lu_change                  hru         0      frsd_to_gras              null       0.00000       0.00000       gras_sb_lum  y   
```

**This means:**
- **When:** January 1, 2005 (`year_cal = 2005`, `jday = 1`)
- **Where:** HRUs with `frsd_tecf_sb_lum` land use
- **What:** Convert to `gras_sb_lum` (grassland)
- **How often:** Once per HRU (controlled by scen_dtl.upd)

### Example 2: Forest to Winter Wheat (2019)
```
name                     conds      alts      acts       !changing all forest to wost on January 1, 2019
frsd_tecf_sb_2019_to_wost         3         1         1  
var                        obj   obj_num           lim_var            lim_op     lim_const      alt1  
year_cal                  null         0              null                 -    2019.00000         =       !year 2019
jday                      null         0              null                 -       1.00000         =       !January 1
land_use                   hru         0  frsd_tecf_sb_2019_lum                 -       0.00000         =       !forest land use (in landuse.lum)
act_typ                    obj   obj_num              name            option         const        const2                fp  outcome           
lu_change                  hru         0      frsd_to_wost              null       0.00000       0.00000       wost_sb_lum  y   
```

**This means:**
- **When:** January 1, 2019
- **Where:** HRUs with `frsd_tecf_sb_2019_lum` land use
- **What:** Convert to `wost_sb_lum` (winter wheat)

## Required Supporting Files

### 1. scen_dtl.upd File
You need a `scen_dtl.upd` file that controls how many times each decision table executes. For your 40 decision tables, it might look like:

```
scen_dtl.upd: Forest conversion scenario control
40

max_hits    typ         dtbl
1           lu_change   frsd_tecf_sb_to_grass
1           lu_change   frse_tecf_db_to_grass
1           lu_change   frsd_tecf_sb_2019_to_wost
1           lu_change   frsd_tecf_sb_2020_to_wost
1           lu_change   frsd_tecf_sb_2021_to_wost
1           lu_change   frsd_tecf_sb_2022_to_wost
... (continue for all 40 decision tables)
```

### 2. landuse.lum File
Your `landuse.lum` file must contain definitions for:

**Source land uses (what you're converting from):**
- `frsd_tecf_sb_lum`
- `frse_tecf_db_lum`
- `frse_tecf_fb_lum`
- `frse_tecf_lb_lum`
- `frse_tecf_sb_lum`
- `frse_teyg_db_lum`
- `frse_teyg_fb_lum`
- `frse_teyg_sb_lum`
- All the year-specific variants (e.g., `frsd_tecf_sb_2019_lum`)

**Target land uses (what you're converting to):**
- `gras_sb_lum` (grassland)
- `wost_db_lum` (winter wheat, deep bedrock)
- `wost_sb_lum` (winter wheat, shallow bedrock)
- `wost_fb_lum` (winter wheat, flat bottomland)
- `wost_lb_lum` (winter wheat, low bedrock)

## What Happens During Simulation

### Phase 1: Forest to Grass (2005)
On January 1, 2005:
1. SWAT+ checks all HRUs for the specified forest land uses
2. Converts matching HRUs to grassland
3. Reinitializes plant communities, soil parameters, management practices
4. Logs changes to `lu_change_out.txt`

### Phase 2: Forest to Winter Wheat (2018-2022)
On January 1 of each year from 2018-2022:
1. SWAT+ checks remaining forest HRUs
2. Converts them to appropriate winter wheat land use based on soil type
3. Updates all HRU parameters for agricultural management
4. Logs all changes

## Timeline of Your Scenario

| Year | Conversion | Target Land Use |
|------|------------|-----------------|
| 2005 | Forest → Grass | Various grassland types |
| 2018 | Forest → Winter Wheat | wost_db_lum, wost_fb_lum, etc. |
| 2019 | Forest → Winter Wheat | wost_db_lum, wost_sb_lum, etc. |
| 2020 | Forest → Winter Wheat | wost_db_lum, wost_sb_lum, etc. |
| 2021 | Forest → Winter Wheat | wost_db_lum, wost_sb_lum, etc. |
| 2022 | Forest → Winter Wheat | wost_db_lum, wost_sb_lum, etc. |

## Monitoring Your Results

### 1. Check lu_change_out.txt
After running your simulation, check this file for entries like:
```
hru    year    month    day    operation    lu_before               lu_after
15     2005    1        1      LU_CHANGE    frsd_tecf_sb_lum       gras_sb_lum
23     2019    1        1      LU_CHANGE    frse_tecf_db_2019_lum  wost_db_lum
```

### 2. Verify Expected Changes
- Count HRUs that changed in each year
- Confirm the correct land use transitions
- Check that all forest types are being converted as expected

## Potential Issues and Solutions

### 1. No Changes Occurring
**Possible causes:**
- Land use names don't match between scen_lu.dtl and landuse.lum
- HRUs don't have the expected initial land use
- scen_dtl.upd file is missing or incorrect

**Solutions:**
- Verify exact spelling of land use names
- Check initial HRU land use assignments
- Ensure scen_dtl.upd contains all decision table names

### 2. Partial Changes
**Possible causes:**
- Some HRUs already converted in earlier years
- Year-specific land use variants not matching current HRU land use

**Solutions:**
- Review the sequence of conversions
- Check if HRUs are being converted multiple times
- Verify year-specific land use name consistency

### 3. Wrong Target Land Use
**Possible causes:**
- Incorrect file_pointer values in decision tables
- Missing target land use definitions in landuse.lum

**Solutions:**
- Double-check all file_pointer values
- Ensure all target land uses are properly defined

## Recommendations for Your Scenario

1. **Simplify initially**: Test with just one or two decision tables first
2. **Use consistent naming**: Ensure land use names are consistent across all files
3. **Monitor incrementally**: Check results after each conversion year
4. **Backup original files**: Keep copies of your original landuse.lum and HRU files
5. **Document assumptions**: Keep track of which forest types go to which targets

This systematic approach should help you successfully implement your forest conversion scenario in SWAT+.