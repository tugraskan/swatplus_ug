# SWAT+ File I/O Analysis Report

This directory contains analysis tools and reports for identifying inputs and outputs in the SWAT+ model code.

## Purpose

The analysis addresses the following requirements:
1. Find all inputs and outputs referenced in the code
2. Check if files in the provided list are still used
3. Identify inputs/outputs not on the list
4. Identify which subroutine the inputs or outputs are opened in/written in
5. Group files of the same type with different time series (_day, _mon, _yr, _aa) or formats (.txt, .csv) and treat them as one

## Analysis Tools

### 1. `analyze_files_io.py`
Basic file I/O analysis that scans for OPEN statements and file references in Fortran source code.

**Usage:**
```bash
python3 analyze_files_io.py > file_io_analysis_report.txt
```

**Output:** Shows files found in code, variable-based file references, and comparison with provided list.

### 2. `enhanced_file_analysis.py`
Enhanced analysis that extracts all literal filenames from the code and provides better matching.

**Usage:**
```bash
python3 enhanced_file_analysis.py > enhanced_analysis_report.txt
```

**Features:**
- Scans for all filename literals in the code (not just OPEN statements)
- Traces variable assignments
- Groups files by normalized patterns (removes time series and format suffixes)
- Shows match rate percentage

### 3. `detailed_file_mapping.py` ⭐ **RECOMMENDED**
Comprehensive analysis providing detailed mapping of files to subroutines.

**Usage:**
```bash
python3 detailed_file_mapping.py > detailed_mapping_report.txt
```

**Output Sections:**
1. **Files in provided list NOT found in code** (potentially unused)
2. **Files in code NOT in provided list** (missing from list)
3. **Matched files with detailed mapping** showing:
   - Which subroutine/function opens/writes the file
   - Source file and line number
   - Context (open, write, read, inquire, reference)

## Key Findings

### Summary Statistics

| Metric | Count |
|--------|-------|
| Files in provided list | 192 |
| Unique files found in code | 1,362 |
| Files matched between list and code | 115-136 |
| Files in list but not clearly in code | 46-56 |
| Files in code but not in list | 1,175-1,225 |
| **Match rate** | **59.9% - 70.8%** |

### Files Likely Unused (in list but not in code)

The following files from the provided list were **not found** in the current code:

**Configuration/Input Files:**
- `cal_parms.cal`, `calibration.cal` - Calibration files
- `cha.key`, `hru_sub.key`, `mgt.key`, `res.key` - Key/lookup files
- `codes.bsn`, `codes.sft` - Code definition files
- `constituents.cs` - Constituent definitions
- `modflow.con` - MODFLOW connection (may be legacy)

**Output Files:**
- `aquifer.out`, `channel.out`, `reservoir.out` - Main output files
- `bsn_chan.out`, `sd_channel.out`, `soils.out` - Specific outputs
- Various balance files: `waterbal.bsn`, `waterbal.hru`, `waterbal.sd`, `waterbal.sub`
- Various loss files: `losses.bsn`, `losses.hru`, `losses.sd`, `losses.sub`
- Nutrient balance: `nutbal.bsn`, `nutbal.hru`, `nutbal.sub`
- `crop_yld_aa.out`, `mgt.out` - Management outputs

**Constituent Files:**
- `metl.cst`, `path.cst`, `pest.cst`, `salt.cst` - Constituent databases

**Note:** These files may be:
1. Referenced through variables (not direct string literals)
2. Read/written by `file.cio` indirectly
3. Legacy files no longer used
4. Dynamically generated filenames

### Files in Code but Missing from List

Over **1,200 files** are referenced in the code but not in the original list. Key categories include:

**1. Time Series Outputs** (grouped by base name):
- `aquifer_*` (day, mon, yr, aa in txt/csv formats)
- `basin_*`, `channel_*`, `reservoir_*`, `wetland_*`
- `hru_*`, `lsunit_*`, `routing_unit_*`
- Each with 4-8 variants for different time periods and formats

**2. Constituent-Specific Files:**
- `cs_*.ini` - Constituent initial conditions
- `*_cs_*` outputs - Constituent-specific outputs
- `*_pest_*`, `*_salt_*` - Pesticide and salt variants

**3. GWFLOW Module Files:**
- `gwflow.input`, `gwflow.con`, `gwflow.*` - Over 100 GWFLOW-related files
- Groundwater flow modeling files (cells, solutes, fluxes, states)

**4. SWIFT Integration:**
- `SWIFT/*.swf` - SWIFT coupling files
- `swift/file_cio.swf`, `swift/precip.swf`, etc.

**5. New/Enhanced Features:**
- `cs_*` files - Full constituent system
- `salt_*` files - Enhanced salt modeling
- `*_subday.*` - Sub-daily output files
- Water allocation: `water_allo_*`, `water_pipe.wal`, `water_tower.wal`

## File Naming Patterns

### Time Series Suffixes
Files can have temporal resolution suffixes:
- `_day` - Daily output
- `_mon` - Monthly output
- `_yr` - Yearly output
- `_aa` - Annual average

**Example:** `basin_aqu_day.txt`, `basin_aqu_mon.csv`, `basin_aqu_yr.txt`, `basin_aqu_aa.csv`

### Format Variations
- `.txt` - Text format (default)
- `.csv` - CSV format
- Both are treated as the same logical file

### Wildcards
When grouping files, `basin_aqu_*` covers:
- All time series: `basin_aqu_day`, `basin_aqu_mon`, `basin_aqu_yr`, `basin_aqu_aa`
- All formats: `.txt` and `.csv`
- Total: 8 file variants

## Subroutine Mapping Examples

### Input Files
| File | Subroutine | Source File | Context |
|------|-----------|-------------|---------|
| `file.cio` | `readcio_read()` | readcio_read.f90:22 | open |
| `time.sim` | `time_read()` | time_read.f90:27 | open |
| `soils.sol` | `soil_db_read()` | soil_db_read.f90:32 | open |
| `plants.plt` | `plant_parm_read()` | plant_parm_read.f90:31 | open |
| `fertilizer.frt` | `fert_parm_read()` | fert_parm_read.f90:27 | open |

### Output Files
| File Pattern | Subroutine | Source File | Context |
|-------------|-----------|-------------|---------|
| `aquifer_*.txt/csv` | `header_aquifer()` | header_aquifer.f90 | open |
| `basin_*.txt/csv` | `header_basin()` | header_basin.f90 | open |
| `channel_*.txt/csv` | `header_channel()` | header_channel.f90 | open |
| `hru_*.txt/csv` | `header_hru()` | header_hru.f90 | open |
| `reservoir_*.txt/csv` | `header_reservoir()` | header_reservoir.f90 | open |

### Variable-Based Files
Many files are referenced through structure variables:
- `in_hru%hru_data` → typically `hru-data.hru`
- `in_sol%sol` → typically `soils.sol`
- `in_cha%init` → typically `initial.cha`
- `in_cli%pcp_cli` → typically `pcp.cli`

These are read from `file.cio` at runtime.

## Recommendations

### For Files in List but Not in Code (56 files)
1. **Verify if truly unused:** Some may be accessed via `file.cio` or variables
2. **Consider removing** from documentation if confirmed unused
3. **Mark as deprecated** if replaced by newer files

### For Files in Code but Not in List (1,225 files)
1. **Update documentation** to include new output files
2. **Group by pattern** using wildcards (e.g., `basin_*` for all basin outputs)
3. **Document new modules:**
   - GWFLOW system files
   - Constituent system files
   - SWIFT integration files
   - Sub-daily outputs

### File Grouping Strategy
Instead of listing individual files, use pattern-based grouping:

**Example:**
```
# Basin outputs (8 variants: day/mon/yr/aa × txt/csv)
basin_aqu_*
basin_ls_*
basin_nb_*
basin_pw_*

# Channel outputs (8 variants each)
channel_*
channel_sd_*
channel_sdmorph_*

# HRU outputs (8 variants each)  
hru_*
hru_ls_*
hru_nb_*
hru_pw_*
```

This reduces ~1,400 files to ~150 patterns while maintaining completeness.

## Files Generated

1. `file_io_analysis_report.txt` - Basic analysis (1,054 lines)
2. `enhanced_analysis_report.txt` - Enhanced analysis (~800 lines)
3. `detailed_mapping_report.txt` - Detailed mapping with subroutines (803 lines)

## Notes

- Analysis based on static code analysis of Fortran `.f90` files
- Variable-based file references may not be fully captured
- Files read dynamically or via `file.cio` may appear as "not found"
- Time series and format variations are grouped as single logical files
- Case-insensitive matching used for comparisons

## Contact

For questions or updates, please refer to the SWAT+ documentation or repository maintainers.
