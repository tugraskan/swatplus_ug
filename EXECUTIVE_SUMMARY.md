# SWAT+ File I/O Analysis - Executive Summary

## Overview
This analysis identifies all input and output files in the SWAT+ model by scanning the Fortran source code, comparing them with a provided list of 192 files, and mapping each file to the subroutine(s) that use it.

## Key Findings

### Match Statistics
- **Files in provided list:** 192
- **Files found in code:** 1,362 unique filenames
- **Successfully matched:** 136 files (70.8%)
- **In list but not clearly in code:** 56 files (29.2%)
- **In code but not in list:** 1,225+ files

### Important Discovery: Default Filenames
Most files from the provided list are defined as **default filenames** in `src/input_file_module.f90`. This module defines structure types that contain default filenames which can be overridden in `file.cio`. Examples:

```fortran
type input_hru
  character(len=25) :: hru_data = "hru-data.hru"
  character(len=25) :: hru_ez   = "hru-lte.hru"
end type input_hru

type input_cha 
  character(len=25) :: init = "initial.cha"
  character(len=25) :: dat =  "channel.cha"
  character(len=25) :: hyd =  "hydrology.cha"
  character(len=25) :: sed =  "sediment.cha"
  character(len=25) :: nut =  "nutrients.cha"
end type input_cha
```

This explains why many files appear to be referenced only in `input_file_module.f90` - they are the default values.

## Files in List but Not Found in Code (56 files)

These files may be:
1. **Output files** written using dynamic naming
2. **Legacy files** from older SWAT+ versions
3. **Optional files** not used in all configurations
4. **Files accessed through variables** that couldn't be traced

### Critical Files Potentially Unused:

#### Configuration/Input:
- `cal_parms.cal`, `calibration.cal` - Calibration parameters
- `codes.bsn`, `codes.sft` - Code definitions
- `constituents.cs` - Constituent definitions
- `modflow.con` - MODFLOW connection

#### Output Files:
- Main outputs: `aquifer.out`, `channel.out`, `reservoir.out`
- Basin outputs: `bsn_chan.out`, `sd_channel.out`, `soils.out`
- Water balance: `waterbal.bsn`, `waterbal.hru`, `waterbal.sd`, `waterbal.sub`
- Losses: `losses.bsn`, `losses.hru`, `losses.sd`, `losses.sub`
- Nutrient balance: `nutbal.bsn`, `nutbal.hru`, `nutbal.sub`
- Management: `crop_yld_aa.out`, `mgt.out`

#### Constituent Databases:
- `metl.cst`, `path.cst`, `pest.cst`, `salt.cst`

#### Key/Lookup Files:
- `cha.key`, `hru_sub.key`, `mgt.key`, `res.key`, `object.cnt`

**Note:** Many of these are likely still valid but accessed indirectly through:
- `file.cio` dynamic reading
- Variable-based references (e.g., `in_basin%codes_bas`)
- Runtime-generated filenames

## Files in Code but Not in List (1,225+ files)

These represent significant additions/enhancements to SWAT+ not reflected in the original list.

### Major Categories:

#### 1. Time Series Output Files (800+ files)
Files with temporal suffixes `_day`, `_mon`, `_yr`, `_aa` and formats `.txt`, `.csv`:

**Examples:**
- `basin_aqu_*` → 8 variants (4 time periods × 2 formats)
- `basin_ls_*`, `basin_nb_*`, `basin_pw_*`
- `channel_*`, `channel_sd_*`, `channel_sdmorph_*`
- `hru_*`, `hru_ls_*`, `hru_nb_*`, `hru_pw_*`
- `aquifer_*`, `reservoir_*`, `wetland_*`
- `routing_unit_*`, `lsunit_*`

**Note:** Each base output name has 4-8 variants for different time periods and formats.

#### 2. GWFLOW Module Files (100+ files)
Groundwater flow modeling system:

**Input Files:**
- `gwflow.input`, `gwflow.con`, `gwflow.solutes`
- `gwflow.chancells`, `gwflow.rescells`, `gwflow.tiles`
- `gwflow.hrucell`, `gwflow.lsucell`, `gwflow.huc12cell`
- `gwflow.canals`, `gwflow.floodplain`, `gwflow.wetland`
- `gwflow.pumpex`, `gwflow.streamobs`

**Output Files:**
- Flux outputs: `gwflow_flux_*` (rech, gwsw, gwet, soil, tile, resv, canl, ppag, ppex, satx, pumping_*)
- Mass outputs: `gwflow_mass_*` (rech, gwsw, soil, satx, ppag, ppex, resv, canl, fpln, tile, wetl)
- State outputs: `gwflow_state_*` (head, conc, hydsep, obs_*)
- Balance outputs: `gwflow_balance_*` (gw_day, gw_yr, gw_aa, huc12_*)

#### 3. Constituent System Files (50+ files)
Enhanced constituent transport/fate modeling:

**Input Files:**
- `cs_*.ini` - Initial conditions (hru, aqu, channel)
- `cs_*` databases - (reactions, uptake, plants_boron, irrigation, urban, streamobs)
- `*_cs` specific files

**Output Files:**
- `*_cs_*` outputs for various objects (aquifer_cs, channel_cs, reservoir_cs, wetland_cs, rout_unit_cs)

#### 4. Salt Module Files (30+ files)
Enhanced salt modeling:

**Input Files:**
- `salt_*.ini` - Initial conditions (hru, aqu, channel)
- `salt_*` databases - (fertilizer, irrigation, plants, road, uptake, urban)
- `salt_atmo.cli`, `salt_recall.rec`

**Output Files:**
- `*_salt_*` outputs for various objects

#### 5. SWIFT Integration Files (15+ files)
SWIFT model coupling:

**SWIFT/*.swf files:**
- `SWIFT/file_cio.swf`, `SWIFT/precip.swf`
- `SWIFT/hru_dat.swf`, `SWIFT/hru_exco.swf`, `SWIFT/hru_wet.swf`
- `SWIFT/chan_dat.swf`, `SWIFT/chan_dr.swf`
- `SWIFT/res_dat.swf`, `SWIFT/res_dr.swf`
- `SWIFT/aqu_dr.swf`

#### 6. Water Allocation Files (20+ files)
Water management and allocation:

**Input Files:**
- `water_*.wal` - (use, pipe, tower, treat, osrc)
- `om_*.wal` - (use, osrc, treat)
- `outside_src.wal`

**Output Files:**
- `water_allo_*` - Time series outputs

#### 7. New Feature Files:
- **Sub-daily outputs:** `*_subday.txt/csv`
- **Carbon cycling:** `basins_carbon.tes`, `carb_coefs.cbn`
- **CO2:** `co2_yr.dat`
- **Enhanced calibration:** `hydrology-cal.hyd`, `plant_parms.cal`
- **Conditions:** `res_conds.dat`, `looping.con`
- **Manure:** `manure.frt`, `manure_allo.mnu`
- **Pesticides:** `pest_metabolite.pes`
- **Structures:** `satbuffer.str`, `puddle.ops`
- **Recalls:** `recall_db.rec`, `cs_recall.rec`, `salt_recall.rec`
- **Soil:** `soil_lyr_depths.sol`
- **Plants:** `transplant.plt`

## File Naming Conventions

### Time Series Suffixes
- `_day` - Daily timestep
- `_mon` - Monthly timestep
- `_yr` - Yearly timestep
- `_aa` - Annual average

### Format Extensions
- `.txt` - Text format (default)
- `.csv` - CSV format
- Both treated as same logical file

### Wildcard Grouping
`basin_aqu_*` represents 8 files:
- `basin_aqu_day.txt`, `basin_aqu_day.csv`
- `basin_aqu_mon.txt`, `basin_aqu_mon.csv`
- `basin_aqu_yr.txt`, `basin_aqu_yr.csv`
- `basin_aqu_aa.txt`, `basin_aqu_aa.csv`

## Detailed File-to-Subroutine Mapping

### Core Input Files

| File | Module/Subroutine | Source File | Action |
|------|------------------|-------------|---------|
| `file.cio` | `readcio_read()` | readcio_read.f90:22 | open |
| `time.sim` | `time_read()` | time_read.f90:27 | open |
| `print.prt` | `object_read_output()` | object_read_output.f90 | open |
| `object.cnt` | `basin_read_objs()` | basin_read_objs.f90 | open |
| `soils.sol` | `soil_db_read()` | soil_db_read.f90:32 | open |
| `plants.plt` | `plant_parm_read()` | plant_parm_read.f90:31 | open |
| `fertilizer.frt` | `fert_parm_read()` | fert_parm_read.f90:27 | open |
| `pesticide.pes` | `pest_parm_read()` | pest_parm_read.f90:28 | open |
| `tillage.til` | `till_parm_read()` | till_parm_read.f90:27 | open |
| `urban.urb` | `urban_parm_read()` | urban_parm_read.f90:30 | open |
| `septic.sep` | `septic_parm_read()` | septic_parm_read.f90:28 | open |
| `snow.sno` | `snowdb_read()` | snowdb_read.f90:27 | open |
| `landuse.lum` | `landuse_read()` | landuse_read.f90:35 | open |
| `management.sch` | Various | Multiple files | open |

### Output File Headers

| File Pattern | Header Subroutine | Source File |
|-------------|-------------------|-------------|
| `aquifer_*.txt/csv` | `header_aquifer()` | header_aquifer.f90 |
| `basin_*.txt/csv` | Various `header_*()` | Multiple header files |
| `channel_*.txt/csv` | `header_channel()` | header_channel.f90 |
| `hru_*.txt/csv` | `header_hru()` | header_hru.f90 |
| `reservoir_*.txt/csv` | `header_reservoir()` | header_reservoir.f90 |
| `wetland_*.txt/csv` | `header_wetland()` | header_wetland.f90 |
| `routing_unit_*.txt/csv` | Various | Multiple files |

### GWFLOW Files

| File Pattern | Subroutine | Source File |
|-------------|-----------|-------------|
| `gwflow.input` | `gwflow_read()` | gwflow_read.f90:165 |
| `gwflow.con` | `gwflow_chan_read()` | gwflow_chan_read.f90:32 |
| `gwflow_flux_*` | `gwflow_read()` | gwflow_read.f90 |
| `gwflow_state_*` | `gwflow_read()` | gwflow_read.f90 |
| `gwflow_balance_*` | `gwflow_read()` | gwflow_read.f90 |

## Recommendations

### 1. Update Documentation List
The provided list is significantly outdated. Recommend grouping files using wildcards:

**Instead of listing:**
```
basin_aqu_day.txt
basin_aqu_mon.txt
basin_aqu_yr.txt
basin_aqu_aa.txt
basin_aqu_day.csv
basin_aqu_mon.csv
basin_aqu_yr.csv
basin_aqu_aa.csv
```

**Use pattern:**
```
basin_aqu_* (8 variants: _day/_mon/_yr/_aa × .txt/.csv)
```

### 2. Remove Truly Unused Files
If the following are confirmed unused, mark as deprecated:
- Output files with no write subroutines
- Legacy calibration files replaced by new .sft files

### 3. Document New Modules
Add documentation for:
- GWFLOW system (100+ files)
- Constituent transport (50+ files)
- Salt module (30+ files)
- SWIFT integration (15+ files)
- Water allocation (20+ files)

### 4. Standardize Naming
Consider standardizing:
- Time series suffixes (already good: _day, _mon, _yr, _aa)
- Module prefixes (gwflow_, cs_, salt_)
- Format extensions (.txt default, .csv optional)

## Files and Tools Provided

1. **`analyze_files_io.py`** - Basic file I/O scanner
2. **`enhanced_file_analysis.py`** - Enhanced analysis with better matching
3. **`detailed_file_mapping.py`** ⭐ - Comprehensive mapping (RECOMMENDED)
4. **`FILE_IO_ANALYSIS_README.md`** - Detailed documentation
5. **`EXECUTIVE_SUMMARY.md`** - This document

### Reports Generated:
- `file_io_analysis_report.txt` (1,054 lines)
- `enhanced_analysis_report.txt` (~800 lines)
- `detailed_mapping_report.txt` (803 lines)

## Usage

To regenerate the analysis:

```bash
# Detailed mapping with subroutines (recommended)
python3 detailed_file_mapping.py > detailed_mapping_report.txt

# Enhanced matching analysis
python3 enhanced_file_analysis.py > enhanced_analysis_report.txt

# Basic analysis
python3 analyze_files_io.py > file_io_analysis_report.txt
```

## Conclusion

The SWAT+ model has evolved significantly beyond the original 192-file list:
- **70.8% of listed files** are still in use
- **1,225+ new files** have been added for:
  - Enhanced output capabilities (time series, formats)
  - GWFLOW groundwater module
  - Constituent transport system
  - Salt modeling
  - SWIFT coupling
  - Water allocation

The provided analysis tools enable:
✓ Identification of unused files
✓ Discovery of undocumented files
✓ Mapping of files to subroutines
✓ Grouping of related files by pattern

**Next Steps:**
1. Review the 56 "potentially unused" files to confirm status
2. Update documentation with the 1,225+ new files
3. Use wildcard patterns to simplify file lists
4. Document new module file requirements
