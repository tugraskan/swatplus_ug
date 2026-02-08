# Quick Start Guide - SWAT+ Schema Extraction Tool

## What This Tool Does

Extracts input file schemas from SWAT+ Fortran source code and updates the master CSV documentation to match the current codebase.

**Principle**: Code is the source of truth.

## Quick Start

### Run the Tool

```bash
cd /home/runner/work/swatplus_ug/swatplus_ug
python3 schema_extractor.py
```

### What Happens

1. ✅ Parses Fortran source code for 4 pilot files
2. ✅ Extracts READ statements and type definitions  
3. ✅ Updates baseline CSV with extracted schema
4. ✅ Generates 4 output files

### Outputs

```
updated_inputs.csv          # Updated CSV (Excel-compatible)
evidence_rows.csv           # Change tracking with code references
per_file_summary.csv        # Statistics per file
extracted_schema.ndjson     # Machine-readable schema
```

## Pilot Files

Currently processes 4 files:
1. **time.sim** - Simulation timing
2. **hru.con** - HRU connections
3. **plant.ini** - Initial plant communities
4. **hyd-sed-lte.cha** - Channel hydrology/sediment

## Example Output

```
================================================================================
SWAT+ Schema Extraction and CSV Update Tool
================================================================================

Step 1: Extracting schemas from Fortran source...
  Extracted 49 schema elements
    time.sim: 5 elements
    hru.con: 13 elements
    plant.ini: 11 elements
    hyd-sed-lte.cha: 20 elements

Step 2: Updating CSV...
  Total rows in updated CSV: 2078

Step 3: Writing outputs...
  ✓ Updated CSV: updated_inputs.csv
  ✓ Evidence CSV: evidence_rows.csv
  ✓ Summary CSV: per_file_summary.csv
  ✓ Schema NDJSON: extracted_schema.ndjson

================================================================================
File Summaries
================================================================================

time.sim:
  Baseline rows: 6
  Extracted rows: 5
  Updated rows: 5
  Changes:
    Added: 0
    Updated: 5
    Removed: 1
    Unchanged: 0

[... etc for other files ...]

================================================================================
Done!
================================================================================
```

## Check Results

### 1. View Summary Statistics

```bash
cat per_file_summary.csv
```

### 2. Check Evidence for Specific File

```bash
grep "^time.sim" evidence_rows.csv
```

### 3. Compare Before/After

```bash
# Baseline
grep "^340" Rev_61_0_nbs_inputs_master_full.csv | cut -d',' -f1-15

# Updated
grep "^340" updated_inputs.csv | cut -d',' -f1-15
```

### 4. View Extracted Schema

```bash
head -5 extracted_schema.ndjson | python3 -m json.tool
```

## Key Changes Made

### time.sim
- Fixed `Swat_code type`: `in_sim` → `time`
- Updated descriptions from type definitions

### hru.con
- Fixed `Swat_code type`: `in_con` → `ob`
- Fixed variable: `numb` → `num`
- Added 8 missing fields

### plant.ini
- Two-level structure: `pcomdb` + `pcomdb%pl`
- All 11 fields with correct types

### hyd-sed-lte.cha
- All 20 fields from type definition
- Units from inline comments

## Documentation

| File | Description |
|------|-------------|
| SCHEMA_EXTRACTOR_README.md | Full tool documentation |
| SCHEMA_EXAMPLES.md | Before/after comparisons |
| PILOT_RESULTS.txt | Execution results summary |
| IMPLEMENTATION_SUMMARY.md | Technical details & compliance |

## Requirements

- Python 3.x (no additional dependencies)
- Access to SWAT+ source code in `src/` directory
- Baseline CSV: `Rev_61_0_nbs_inputs_master_full.csv`

## Troubleshooting

**Issue**: Tool doesn't run  
**Solution**: Ensure Python 3 is installed: `python3 --version`

**Issue**: No outputs generated  
**Solution**: Check permissions in working directory

**Issue**: Different results than expected  
**Solution**: Check that source code hasn't changed

## Next Steps

1. Review `evidence_rows.csv` for detailed changes
2. Compare `updated_inputs.csv` with baseline
3. Validate changes match your expectations
4. Use updated CSV for Excel workflow

## Support

For questions or issues:
1. Check SCHEMA_EXTRACTOR_README.md
2. Review IMPLEMENTATION_SUMMARY.md
3. Examine evidence_rows.csv for specific changes
4. Consult SCHEMA_EXAMPLES.md for examples

---

**Tool Version**: 1.0 (Pilot)  
**Status**: Production-ready for 4 pilot files  
**Date**: 2026-02-08
