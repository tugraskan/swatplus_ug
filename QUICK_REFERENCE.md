# SWAT+ Input Files - Quick Reference

## 📋 What You Have

**6 files delivered:**
1. `SWAT_INPUT_FILES.txt` - Human-readable list (230 lines)
2. `SWAT_INPUT_FILES.csv` - CSV format (148 lines)
3. `INPUT_FILES_README.md` - Full documentation
4. `SUMMARY.md` - Complete summary with all details
5. `list_input_files.py` - Generator (text format)
6. `list_input_files_csv.py` - Generator (CSV format)

## 📊 Quick Stats

- **147 input files** across **25 categories**
- Extracted from `src/input_file_module.f90`
- Shows variable names (e.g., `in_basin%codes_bas`)

## 🔍 How to Find a File

### By Category
```bash
grep -A 20 "Simulation Files" SWAT_INPUT_FILES.txt
grep -A 20 "Climate Files" SWAT_INPUT_FILES.txt
grep -A 20 "HRU Files" SWAT_INPUT_FILES.txt
```

### By Filename
```bash
grep "codes.bsn" SWAT_INPUT_FILES.txt
grep "pcp.cli" SWAT_INPUT_FILES.txt
grep "plants.plt" SWAT_INPUT_FILES.txt
```

### By Variable Name
```bash
grep "in_basin" SWAT_INPUT_FILES.txt
grep "in_cli" SWAT_INPUT_FILES.txt
grep "in_parmdb" SWAT_INPUT_FILES.txt
```

## 📁 Top 10 Most Common File Types

1. **Connection files (.con)** - 13 files
2. **Region definition files (.ele, .def, .reg)** - 17 files
3. **Initial condition files (.ini)** - 11 files
4. **Parameter database files (.plt, .frt, etc.)** - 10 files
5. **Calibration files (.cal, .sft)** - 9 files
6. **Climate files (.cli)** - 9 files
7. **Channel files (.cha)** - 8 files
8. **Reservoir files (.res, .wet)** - 8 files
9. **Operation files (.ops)** - 6 files
10. **External constant files (.exc)** - 6 files

## 🎯 Common Variable Prefixes

| Prefix | Category | Example |
|--------|----------|---------|
| `in_sim` | Simulation | `in_sim%time` → time.sim |
| `in_basin` | Basin | `in_basin%codes_bas` → codes.bsn |
| `in_cli` | Climate | `in_cli%pcp_cli` → pcp.cli |
| `in_con` | Connection | `in_con%hru_con` → hru.con |
| `in_cha` | Channel | `in_cha%init` → initial.cha |
| `in_res` | Reservoir | `in_res%init_res` → initial.res |
| `in_hru` | HRU | `in_hru%hru_data` → hru-data.hru |
| `in_parmdb` | Parameters | `in_parmdb%plants_plt` → plants.plt |
| `in_init` | Initial | `in_init%soil_plant_ini` → soil_plant.ini |
| `in_sol` | Soil | `in_sol%soils_sol` → soils.sol |

## 💡 Quick Tips

### View all files in a category
```bash
# All climate files
grep "in_cli" SWAT_INPUT_FILES.csv

# All parameter database files
grep "in_parmdb" SWAT_INPUT_FILES.csv
```

### Count files by category
```bash
# Count simulation files
grep "Simulation" SWAT_INPUT_FILES.csv | wc -l

# Count climate files
grep "Climate" SWAT_INPUT_FILES.csv | wc -l
```

### Find files with specific extensions
```bash
# All .ini files
grep "\.ini" SWAT_INPUT_FILES.txt

# All .con files
grep "\.con" SWAT_INPUT_FILES.txt
```

## 🔧 Regenerate Lists

If source code changes:
```bash
# Regenerate text list
python3 list_input_files.py > SWAT_INPUT_FILES.txt

# Regenerate CSV
python3 list_input_files_csv.py > SWAT_INPUT_FILES.csv
```

## 📖 Need More Info?

- **Full documentation:** `INPUT_FILES_README.md`
- **Complete summary:** `SUMMARY.md`
- **Source code:** `src/input_file_module.f90`

---
*Quick reference for 147 SWAT+ input files*
