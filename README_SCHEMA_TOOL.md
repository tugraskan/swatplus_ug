# SWAT+ Schema Extraction Tool - Documentation

## Overview

Automated tool to extract SWAT+ input file schemas from Fortran source code and update the master CSV documentation.

**Core Principle**: Code is the source of truth.

## Quick Start

```bash
python3 schema_extractor.py
```

## What It Does

1. Parses Fortran source files for READ statements
2. Extracts type definitions from module files
3. Updates baseline CSV with extracted schema information
4. Generates evidence reports tracking all changes

## Pilot Files (4 files)

1. **time.sim** - Simulation timing parameters
2. **hru.con** - HRU connection configuration  
3. **plant.ini** - Initial plant communities
4. **hyd-sed-lte.cha** - Channel hydrology/sediment properties

## Outputs Generated

### 1. updated_inputs.csv
Updated version of `Rev_61_0_nbs_inputs_master_full.csv`:
- Excel-compatible format
- Same column structure as baseline
- **Only these columns updated**:
  - `Line_in_file` - Line number in file
  - `Position_in_File` - Position in read list
  - `SWAT_Code_Variable_Name` - Variable name (day_start, num, etc.)
  - `Description` - From code comments
  - `Units` - From code comments  
  - `Data_Type` - Fortran type mapped to spreadsheet type
  - `Number_Decimal_Places` - From format specs (when available)
- **NOT updated**: `Swat_code type` (component name, preserved from baseline)

### 2. evidence_rows.csv
Detailed change tracking:
- Action type (added/updated/removed/unchanged)
- Schema key (file|line|position)
- Fields changed
- Old/new values
- Confidence level
- Code references (file, line, snippet)

### 3. per_file_summary.csv
Statistics per file:
- Baseline vs extracted vs updated row counts
- Action counts (added, updated, removed, unchanged)

### 4. extracted_schema.ndjson
Machine-readable schema in NDJSON format

## Results Summary

| File | Baseline | Extracted | Changes |
|------|----------|-----------|---------|
| time.sim | 6 | 5 | 5 updated, 1 removed |
| hru.con | 18 | 13 | 13 added, 18 removed |
| plant.ini | 12 | 11 | 11 added, 12 removed |
| hyd-sed-lte.cha | 24 | 20 | 20 added, 24 removed |

## Key Features

✅ **Code-based extraction** - All schema from Fortran READ statements  
✅ **Type mapping** - character→string, integer→integer, real→numeric  
✅ **Preserves baseline** - Swat_code_type unchanged (component name)  
✅ **Updates variables** - SWAT_Code_Variable_Name reflects actual code  
✅ **Full traceability** - Evidence with code file, line, and snippet  
✅ **Excel compatible** - Same CSV structure as baseline  

## Important Notes

### Swat_code_type is NOT Updated
This column represents the **component name** (e.g., `in_sim`, `in_con`) and is intentionally preserved from the baseline CSV. Only the actual variable names in `SWAT_Code_Variable_Name` are updated.

### Example: time.sim
- `Swat_code type`: `in_sim` (unchanged from baseline)
- `SWAT_Code_Variable_Name`: `day_start`, `yrc_start`, `day_end`, `yrc_end`, `step`
- `Description`: Updated from `time_module.f90` type definition comments

## Technical Details

### Fortran Type Mapping
```
character(...)           → string
integer(...)             → integer  
real(...), double        → numeric
logical                  → boolean
```

### Schema Key
Format: `SWAT_File | Line_in_file | Position_in_File`

Used for stable matching between baseline and extracted schema.

## Code References

| File | Read Subroutine | Type Definition |
|------|----------------|-----------------|
| time.sim | time_read.f90:28 | time_module.f90 |
| hru.con | hyd_read_connect.f90:220-221 | hydrograph_module.f90 |
| plant.ini | readpcom.f90:62,68-70 | plant_data_module.f90 |
| hyd-sed-lte.cha | sd_hydsed_read.f90:61 | sd_channel_module.f90 |

## Requirements

- Python 3.x (no external dependencies)
- SWAT+ source code in `src/` directory
- Baseline CSV: `Rev_61_0_nbs_inputs_master_full.csv`

## Limitations

- Pilot scope: 4 of 149 files
- Regex-based parsing (not full Fortran AST parser)
- Format specs for decimal places not yet extracted
- FORD docs available but not yet integrated

## Future Enhancements

To extend to all 149 files:
1. Map remaining 145 files to read subroutines
2. Enhanced Fortran parser for complex control flow
3. FORD documentation integration
4. Support for derived type hierarchies
5. Dynamic schema support

---

**Version**: 1.0 (Pilot)  
**Date**: 2026-02-08  
**Status**: Production-ready for 4 pilot files
