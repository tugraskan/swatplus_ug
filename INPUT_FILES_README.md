# SWAT+ Input Files List

This directory contains a clean, accurate list of all SWAT+ input files extracted directly from the source code.

## Files

1. **`SWAT_INPUT_FILES.txt`** - Human-readable list with categories (147 files)
2. **`SWAT_INPUT_FILES.csv`** - CSV format for easy import to spreadsheets (147 files)
3. **`list_input_files.py`** - Python script to generate the text list
4. **`list_input_files_csv.py`** - Python script to generate the CSV

## How This Works

All input files are defined in `src/input_file_module.f90` as Fortran type structures with default filenames. For example:

```fortran
!! basin
type input_basin
  character(len=25) :: codes_bas = "codes.bsn"
  character(len=25) :: parms_bas = "parameters.bsn"
end type input_basin
type (input_basin) :: in_basin
```

This means:
- Variable name: `in_basin%codes_bas`
- Default filename: `codes.bsn`
- Category: Basin Files

## Input File Categories

The 147 input files are organized into these categories:

1. **Simulation Files (5)** - Core simulation setup (time.sim, print.prt, etc.)
2. **Basin Files (2)** - Basin-level parameters (codes.bsn, parameters.bsn)
3. **Climate Files (9)** - Weather data (pcp.cli, tmp.cli, etc.)
4. **Connection Files (13)** - Object connections (hru.con, channel.con, etc.)
5. **Channel Files (8)** - Channel properties (initial.cha, hydrology.cha, etc.)
6. **Reservoir Files (8)** - Reservoir and wetland data
7. **Routing Unit Files (4)** - Routing unit definitions
8. **HRU Files (2)** - HRU data (hru-data.hru, hru-lte.hru)
9. **External Constant Files (6)** - Recall constants (exco*.exc)
10. **Recall Files (1)** - Recall data (recall.rec)
11. **Delivery Ratio Files (6)** - Delivery ratios (dr_*.del)
12. **Aquifer Files (2)** - Aquifer data (initial.aqu, aquifer.aqu)
13. **Herd/Animal Files (3)** - Animal management (animal.hrd, herd.hrd, ranch.hrd)
14. **Water Rights Files (3)** - Water allocation (water_allocation.wro, etc.)
15. **Link Files (2)** - Object links (chan-surf.lin, aqu_cha.lin)
16. **Hydrology Files (3)** - Hydrologic parameters (hydrology.hyd, etc.)
17. **Structural Files (5)** - Structural BMPs (tiledrain.str, septic.str, etc.)
18. **Parameter Database Files (10)** - Plant, fertilizer, pesticide databases
19. **Operation Scheduling Files (6)** - Management operations (harv.ops, irr.ops, etc.)
20. **Land Use Management Files (5)** - Land use data (landuse.lum, etc.)
21. **Calibration Files (9)** - Calibration parameters (cal_parms.cal, etc.)
22. **Initial Condition Files (11)** - Initial states (plant.ini, soil_plant.ini, etc.)
23. **Soil Files (3)** - Soil properties (soils.sol, nutrients.sol, soils_lte.sol)
24. **Conditional/Decision Table Files (4)** - Decision tables (*.dtl)
25. **Region Definition Files (17)** - Regional groupings (ls_unit.ele, ch_catunit.def, etc.)

## Variable Naming Convention

Files are accessed in code using the pattern: `<type_instance>%<field_name>`

Examples:
- `in_basin%codes_bas` → `codes.bsn`
- `in_cli%pcp_cli` → `pcp.cli`
- `in_hru%hru_data` → `hru-data.hru`
- `in_parmdb%plants_plt` → `plants.plt`
- `in_init%soil_plant_ini` → `soil_plant.ini`

## Usage

### View the list:
```bash
# Human-readable format
cat SWAT_INPUT_FILES.txt

# Or open CSV in spreadsheet
libreoffice SWAT_INPUT_FILES.csv
```

### Regenerate the list:
```bash
# Text format
python3 list_input_files.py > SWAT_INPUT_FILES.txt

# CSV format
python3 list_input_files_csv.py > SWAT_INPUT_FILES.csv
```

## Notes

- These are **input files only** (not outputs)
- All files are defined with default names in `input_file_module.f90`
- Actual filenames can be overridden in `file.cio`
- Total: **147 input files** across 25 categories
- Commented-out files (like `wind-dir.cli`) are excluded

## Source

Extracted from: `src/input_file_module.f90` (lines 1-311)

Last updated: 2026-02-08
