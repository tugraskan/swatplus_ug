# SWAT+ File I/O Analysis - Quick Start Guide

This directory contains comprehensive analysis tools for identifying all inputs and outputs in the SWAT+ model code.

## 📋 What's Included

### Analysis Tools (Python Scripts)
1. **`detailed_file_mapping.py`** ⭐ **RECOMMENDED** - Complete mapping with subroutines
2. **`enhanced_file_analysis.py`** - Enhanced matching and statistics
3. **`analyze_files_io.py`** - Basic file I/O scanner

### Generated Reports
1. **`detailed_mapping_report.txt`** - 803 lines, comprehensive analysis
2. **`enhanced_analysis_report.txt`** - 800+ lines, enhanced matching
3. **`file_io_analysis_report.txt`** - 1,054 lines, basic analysis

### Documentation
1. **`EXECUTIVE_SUMMARY.md`** ⭐ **START HERE** - Key findings and recommendations
2. **`FILE_IO_ANALYSIS_README.md`** - Detailed documentation
3. **`EXAMPLE_OUTPUT.md`** - Example analysis results with interpretation
4. **`README_QUICKSTART.md`** - This file

## 🚀 Quick Start

### To View Results Immediately:
```bash
# View executive summary (recommended first step)
less EXECUTIVE_SUMMARY.md

# View detailed analysis report
less detailed_mapping_report.txt

# View example outputs with interpretation
less EXAMPLE_OUTPUT.md
```

### To Run Analysis:
```bash
# Run detailed analysis (recommended)
python3 detailed_file_mapping.py > my_analysis.txt

# View specific sections
grep -A 60 "SECTION 1:" my_analysis.txt  # Files in list but not in code
grep -A 100 "SECTION 2:" my_analysis.txt # Files in code but not in list
tail -20 my_analysis.txt                  # Summary statistics
```

## 📊 Key Results Summary

| Metric | Value |
|--------|-------|
| Files in provided list | 192 |
| Files found in code | 1,362 |
| Match rate | **70.8%** |
| Potentially unused files | 56 |
| New files not in list | 1,225+ |

### Main Findings:

1. **136 files (70.8%)** from the provided list are actively used in code
2. **56 files (29.2%)** from the list were not clearly found (may be unused or accessed indirectly)
3. **1,225+ new files** exist in code but weren't in the original list

### New File Categories:
- **GWFLOW module:** 100+ groundwater modeling files
- **Constituent transport:** 50+ files for enhanced constituent modeling
- **Salt module:** 30+ files for salt transport
- **SWIFT integration:** 15+ coupling files
- **Time series outputs:** 800+ output file variants

## 📁 File Organization

### Files from Provided List Likely Unused (56 files):
- Output files: `channel.out`, `reservoir.out`, `aquifer.out`
- Balance files: `waterbal.*`, `nutbal.*`, `losses.*`
- Configuration: `calibration.cal`, `codes.bsn`, `modflow.con`
- Databases: `metl.cst`, `path.cst`, `pest.cst`, `salt.cst`

**Note:** These may be accessed via `file.cio` or dynamic naming

### Major New Files in Code (Not in Original List):

#### GWFLOW (100+ files)
- Input: `gwflow.input`, `gwflow.con`, `gwflow.solutes`, etc.
- Output: `gwflow_flux_*`, `gwflow_mass_*`, `gwflow_state_*`, `gwflow_balance_*`

#### Constituent System (50+ files)
- Input: `cs_*.ini`, `cs_reactions`, `cs_uptake`
- Output: `*_cs_*` (aquifer_cs, channel_cs, reservoir_cs, etc.)

#### Salt Module (30+ files)
- Input: `salt_*.ini`, `salt_fertilizer.frt`, `salt_plants`
- Output: `*_salt_*` outputs

#### Time Series Outputs (800+ files)
- Pattern: `<object>_<type>_<period>.<format>`
- Periods: `_day`, `_mon`, `_yr`, `_aa`
- Formats: `.txt`, `.csv`
- Example: `basin_aqu_day.txt`, `basin_aqu_mon.csv`

## 🔍 How Files are Referenced in Code

### 1. Direct String Literals
```fortran
open (107, file="file.cio")
open (105, file="initial.cha")
```

### 2. Module Variables (Most Common)
```fortran
! Defined in input_file_module.f90
type input_hru
  character(len=25) :: hru_data = "hru-data.hru"
end type input_hru

! Used elsewhere
open (107, file=in_hru%hru_data)
```

### 3. Dynamic Construction
```fortran
! Time series outputs constructed at runtime
call open_output_file(2090, "basin_aqu_day.txt", 1500)
call open_output_file(2091, "basin_aqu_mon.txt", 1500)
```

## 📖 File Naming Conventions

### Time Series Suffixes
- `_day` - Daily timestep
- `_mon` - Monthly timestep
- `_yr` - Yearly timestep
- `_aa` - Annual average

### Format Extensions
- `.txt` - Text format (default)
- `.csv` - CSV format (alternative)

### Pattern Grouping
Instead of listing 8 variants individually:
```
basin_aqu_*  # Covers: _day/_mon/_yr/_aa × .txt/.csv = 8 files
```

## 🎯 Subroutine Mapping Examples

| File | Subroutine | Source File | Line |
|------|-----------|-------------|------|
| `file.cio` | `readcio_read()` | readcio_read.f90 | 22 |
| `time.sim` | `time_read()` | time_read.f90 | 27 |
| `soils.sol` | `soil_db_read()` | soil_db_read.f90 | 32 |
| `plants.plt` | `plant_parm_read()` | plant_parm_read.f90 | 31 |
| `aquifer_*.txt/csv` | `header_aquifer()` | header_aquifer.f90 | - |
| `gwflow.input` | `gwflow_read()` | gwflow_read.f90 | 165 |

## 💡 Recommendations

### For Documentation Updates:
1. **Use pattern-based grouping** to reduce 1,400 files to ~150 patterns
2. **Document new modules**: GWFLOW, constituents, salt, SWIFT
3. **Mark deprecated files** that are confirmed unused
4. **Standardize naming** for new outputs (already mostly consistent)

### For Users:
1. **Start with EXECUTIVE_SUMMARY.md** for overview
2. **Check detailed_mapping_report.txt** for specific file locations
3. **Review EXAMPLE_OUTPUT.md** for interpretation help
4. **Run detailed_file_mapping.py** to regenerate with latest code

## 🔧 Technical Details

### Analysis Method:
1. Scans all 625 Fortran `.f90` source files
2. Extracts filename literals using regex patterns
3. Identifies OPEN, READ, WRITE, INQUIRE statements
4. Maps filenames to subroutines/functions
5. Normalizes for time series and format variations
6. Compares with provided 192-file list

### Limitations:
- Variable-based filenames may not be fully captured
- Dynamic filename construction may be missed
- Files accessed only via `file.cio` may appear as "not found"

### Dependencies:
- Python 3.x
- Standard library only (re, os, pathlib, collections)

## 📞 Support

For questions about:
- **Analysis results:** See EXECUTIVE_SUMMARY.md and EXAMPLE_OUTPUT.md
- **Tool usage:** See FILE_IO_ANALYSIS_README.md
- **SWAT+ model:** Refer to SWAT+ documentation

## 📄 Files at a Glance

```
.
├── README_QUICKSTART.md           ← You are here
├── EXECUTIVE_SUMMARY.md           ← Start here for overview
├── FILE_IO_ANALYSIS_README.md     ← Detailed documentation
├── EXAMPLE_OUTPUT.md              ← Example results
├── detailed_file_mapping.py       ← Recommended tool
├── enhanced_file_analysis.py      ← Alternative tool
├── analyze_files_io.py            ← Basic tool
├── detailed_mapping_report.txt    ← Main results
├── enhanced_analysis_report.txt   ← Alternative results
└── file_io_analysis_report.txt    ← Basic results
```

---

**Created:** 2026-02-08  
**Analysis Version:** 1.0  
**Code Base:** SWAT+ (tugraskan/swatplus_ug)
