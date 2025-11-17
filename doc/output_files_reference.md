# SWAT+ Output Files Reference

This document provides information about SWAT+ output files and where they are written in the source code.

## Basin Crop Yield Output Files

### basin_crop_yld_yr.txt

**Description:** Annual basin crop yields and harvested areas

**File Handle:** 5100

**Opened in:** `src/header_yield.f90` (line 21)
```fortran
open (5100,file="basin_crop_yld_yr.txt", recl=800)
```

**Data Written in:** `src/time_control.f90` (line 279)
- **Subroutine:** `time_control`
- **When:** End of each year (after daily loop completes)
- **Condition:** `if (sp_ob%hru > 0)`

**Output Format:**
```
year, plant_id, plant_name, area_ha, yield, yield_per_ha
```

**Variables Written:**
- `time%yrc` - Current year
- `iplt` - Plant index
- `plts_bsn(iplt)` - Plant name
- `bsn_crop_yld(iplt)%area_ha` - Harvested area (hectares)
- `bsn_crop_yld(iplt)%yield` - Total yield
- `crop_yld_t_ha` - Yield per hectare (tonnes/ha)

### basin_crop_yld_aa.txt

**Description:** Average annual basin crop yields and harvested areas

**File Handle:** 5101

**Opened in:** `src/header_yield.f90` (line 25)
```fortran
open (5101,file="basin_crop_yld_aa.txt", recl=800)
```

**Data Written in:** `src/time_control.f90` (line 289)
- **Subroutine:** `time_control`
- **When:** End of simulation (`time%end_sim == 1`)
- **Condition:** `if (sp_ob%hru > 0)`

**Output Format:**
```
year, plant_id, plant_name, avg_area_ha, avg_yield, avg_yield_per_ha
```

**Variables Written:**
- `time%yrc` - Current year
- `iplt` - Plant index
- `plts_bsn(iplt)` - Plant name
- `bsn_crop_yld_aa(iplt)%area_ha` - Average harvested area (hectares)
- `bsn_crop_yld_aa(iplt)%yield` - Average total yield
- `crop_yld_t_ha` - Average yield per hectare (tonnes/ha)

## Related Files

For more information about output file formats and usage, see:
- [SWAT+ Input/Output Documentation](https://swatplus.gitbook.io/docs)
- [SWAT+ Source Documentation](https://swat-model.github.io/swatplus)

## Contributing

When adding new output files, please update this reference document with:
1. File name and description
2. File handle number
3. Where the file is opened (source file and line number)
4. Where data is written (source file, subroutine, and line number)
5. Output format and variables
