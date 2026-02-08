# SWAT+ Schema Extraction Tool

## Overview

This tool extracts input file schemas from SWAT+ Fortran source code and updates the master CSV documentation to match the current codebase.

**Design Principle**: Code is the source of truth. The tool parses actual Fortran READ statements to determine the schema.

## Pilot Implementation

This is a **pilot implementation** covering 4 critical input files:
- `time.sim` - Simulation timing parameters
- `hru.con` - HRU connection/configuration
- `plant.ini` - Initial plant communities
- `hyd-sed-lte.cha` - Channel hydrology/sediment properties

## Usage

```bash
python3 schema_extractor.py
```

## Outputs

The tool generates 4 output files:

### 1. `updated_inputs.csv`
Updated version of `Rev_61_0_nbs_inputs_master_full.csv` with:
- Same column structure (Excel-compatible)
- Updated schema information extracted from code
- Only specified columns modified:
  - Line_in_file
  - Position_in_File
  - SWAT_Code_Variable_Name (the actual variable names: day_start, yrc_start, etc.)
  - Description (when clear comments exist)
  - Units (when clear comments exist)
  - Data_Type
  - Number_Decimal_Places (when format explicit)
- **Note**: Swat_code type is NOT modified - it represents the component name and remains as-is from baseline

### 2. `evidence_rows.csv`
Detailed evidence for every change:
- **action**: unchanged, updated, added, removed
- **schema_key**: unique identifier (file|line|position)
- **field_changed**: which columns were updated
- **confidence**: high/medium/low
- **code_file**: source file containing the schema
- **code_line_start/end**: exact line numbers
- **code_snippet**: actual READ statement
- **notes**: explanations and warnings

### 3. `per_file_summary.csv`
Summary statistics per file:
- Baseline row count
- Extracted row count
- Updated row count
- Number of additions, updates, removals, unchanged

### 4. `extracted_schema.ndjson`
Machine-readable schema extraction in NDJSON format (one JSON object per line).

## Results Summary

| File | Baseline Rows | Extracted Rows | Added | Updated | Removed | Unchanged |
|------|---------------|----------------|-------|---------|---------|-----------|
| time.sim | 6 | 5 | 0 | 5 | 1 | 0 |
| hru.con | 18 | 13 | 13 | 0 | 18 | 0 |
| plant.ini | 12 | 11 | 11 | 0 | 12 | 0 |
| hyd-sed-lte.cha | 24 | 20 | 20 | 0 | 24 | 0 |

### Notable Changes

**time.sim**: Updated all 5 fields with correct type mappings (`time%field` → `time` type)

**hru.con**: Complete schema replacement - baseline had old schema, now matches `hyd_read_connect` generic reader with proper `ob%field` mappings

**plant.ini**: Schema extracted from `readpcom.f90` with two levels:
- Community header: name, plants_com, rot_yr_ini
- Plant details: cpnm, igro, lai, bioms, phuacc, pop, fr_yrmat, rsdin

**hyd-sed-lte.cha**: All 20 fields from `swatdeg_hydsed_data` type definition, with units and descriptions from inline comments

## Implementation Details

### Fortran Parsing Strategy

1. **Type Definitions**: Extract from module files (e.g., `time_module.f90`)
   - Parse `type <name>` blocks
   - Extract field names, types, and inline comments
   - Map units and descriptions from `! unit | description` format

2. **READ Statements**: Locate in subroutines (e.g., `time_read.f90`)
   - Find file open/read patterns
   - Extract variable lists from READ statements
   - Determine position from order in READ list

3. **Type Mappings**: Fortran → Spreadsheet
   - `character(...)` → `string`
   - `integer(...)` → `integer`
   - `real(...)`, `double precision` → `numeric`
   - `logical` → `boolean`

### Code References

| File | Read Subroutine | Module/Type |
|------|----------------|-------------|
| time.sim | time_read.f90, line 28 | time_module.f90, type time_current |
| hru.con | hyd_read_connect.f90, line 220-221 | hydrograph_module.f90, type ob |
| plant.ini | readpcom.f90, lines 62, 68-70 | plant_data_module.f90, type pcomdb |
| hyd-sed-lte.cha | sd_hydsed_read.f90, line 61 | sd_channel_module.f90, type swatdeg_hydsed_data |

## Validation

The tool includes built-in sanity checks:
- Coverage check: baseline vs extracted vs updated row counts
- Duplicate key detection (file|line|position must be unique)
- Type mapping verification

## Known Limitations

1. **Pilot Only**: Only 4 files are processed. Baseline CSV contains 149 files.
2. **Simple Parsing**: Uses regex-based parsing, not a full Fortran parser
3. **Format Specs**: Decimal places only extracted from explicit formats (F10.3, etc.)
4. **Complex Control Flow**: May miss schema in complex conditional reads
5. **No FORD Integration**: FORD docs available but not yet used

## Future Enhancements

To extend to all 149 files:
1. Add file-to-reader mappings for remaining files
2. Implement more sophisticated Fortran parsing
3. Integrate FORD documentation as secondary source
4. Add support for derived type hierarchies
5. Handle dynamic schema (varying number of fields)

## Compliance with Requirements

✅ **Code is source of truth**: All schema extracted from actual Fortran code
✅ **Column preservation**: Only updates specified columns, keeps all others
✅ **Type mapping**: Fortran types properly mapped to spreadsheet types
✅ **Evidence tracking**: Full provenance with code references
✅ **Removal handling**: Removes baseline rows not found in code (with evidence)
✅ **Addition handling**: Adds new schema elements found in code
✅ **Sanity checks**: Coverage, duplicate detection, ordering
✅ **Show your work**: Three evidence files + updated CSV

## Contact

For questions or issues, refer to the main SWAT+ repository or documentation.
