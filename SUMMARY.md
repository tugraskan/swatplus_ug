# SWAT+ Input Files - Final Summary

## Task Completed Successfully

Extracted all SWAT+ input files from the source code with their variable names.

## What Was Delivered

### Files Created
1. **`SWAT_INPUT_FILES.txt`** - Human-readable list (230 lines)
   - Organized by 25 functional categories
   - Shows variable name -> filename mapping
   - Easy to read and understand

2. **`SWAT_INPUT_FILES.csv`** - Machine-readable CSV (148 lines)
   - Headers: Variable, Filename, Category
   - Easy to import into Excel/spreadsheets
   - Suitable for automated processing

3. **`INPUT_FILES_README.md`** - Complete documentation
   - Explains the extraction method
   - Lists all 25 categories
   - Provides usage examples
   - Documents variable naming conventions

4. **`list_input_files.py`** - Generator script for text format
5. **`list_input_files_csv.py`** - Generator script for CSV format

### Key Statistics
- **Total Input Files:** 147
- **Categories:** 25
- **Source:** `src/input_file_module.f90`
- **Method:** Direct parsing of Fortran type definitions

## Input File Categories (25)

1. **Simulation (5)** - time.sim, print.prt, object.prt, object.cnt, constituents.cs
2. **Basin (2)** - codes.bsn, parameters.bsn
3. **Climate (9)** - weather-sta.cli, weather-wgn.cli, pet.cli, pcp.cli, tmp.cli, slr.cli, hmd.cli, wnd.cli, atmodep.cli
4. **Connection (13)** - hru.con, hru-lte.con, rout_unit.con, gwflow.con, aquifer.con, aquifer2d.con, channel.con, reservoir.con, recall.con, exco.con, delratio.con, outlet.con, chandeg.con
5. **Channel (8)** - initial.cha, channel.cha, hydrology.cha, sediment.cha, nutrients.cha, channel-lte.cha, hyd-sed-lte.cha, temperature.cha
6. **Reservoir (8)** - initial.res, reservoir.res, hydrology.res, sediment.res, nutrients.res, weir.res, wetland.wet, hydrology.wet
7. **Routing Unit (4)** - rout_unit.def, rout_unit.ele, rout_unit.rtu, rout_unit.dr
8. **HRU (2)** - hru-data.hru, hru-lte.hru
9. **External Constant (6)** - exco.exc, exco_om.exc, exco_pest.exc, exco_path.exc, exco_hmet.exc, exco_salt.exc
10. **Recall (1)** - recall.rec
11. **Delivery Ratio (6)** - delratio.del, dr_om.del, dr_pest.del, dr_path.del, dr_hmet.del, dr_salt.del
12. **Aquifer (2)** - initial.aqu, aquifer.aqu
13. **Herd/Animal (3)** - animal.hrd, herd.hrd, ranch.hrd
14. **Water Rights (3)** - water_allocation.wro, element.wro, water_rights.wro
15. **Link (2)** - chan-surf.lin, aqu_cha.lin
16. **Hydrology (3)** - hydrology.hyd, topography.hyd, field.fld
17. **Structural (5)** - tiledrain.str, septic.str, filterstrip.str, grassedww.str, bmpuser.str
18. **Parameter Database (10)** - plants.plt, fertilizer.frt, tillage.til, pesticide.pes, pathogens.pth, metals.mtl, salt.slt, urban.urb, septic.sep, snow.sno
19. **Operation Scheduling (6)** - harv.ops, graze.ops, irr.ops, chem_app.ops, fire.ops, sweep.ops
20. **Land Use Management (5)** - landuse.lum, management.sch, cntable.lum, cons_practice.lum, ovn_table.lum
21. **Calibration (9)** - cal_parms.cal, calibration.cal, codes.sft, wb_parms.sft, water_balance.sft, ch_sed_budget.sft, ch_sed_parms.sft, plant_parms.sft, plant_gro.sft
22. **Initial Condition (11)** - plant.ini, soil_plant.ini, om_water.ini, pest_hru.ini, pest_water.ini, path_hru.ini, path_water.ini, hmet_hru.ini, hmet_water.ini, salt_hru.ini, salt_water.ini
23. **Soil (3)** - soils.sol, nutrients.sol, soils_lte.sol
24. **Conditional/Decision Table (4)** - lum.dtl, res_rel.dtl, scen_lu.dtl, flo_con.dtl
25. **Region Definition (17)** - ls_unit.ele, ls_unit.def, ls_reg.ele, ls_reg.def, ls_cal.reg, ch_catunit.ele, ch_catunit.def, ch_reg.def, aqu_catunit.ele, aqu_catunit.def, aqu_reg.def, res_catunit.ele, res_catunit.def, res_reg.def, rec_catunit.ele, rec_catunit.def, rec_reg.def

## Variable Name Examples

```
Variable Name              Filename
in_basin%codes_bas      -> codes.bsn
in_basin%parms_bas      -> parameters.bsn
in_cli%pcp_cli          -> pcp.cli
in_cli%tmp_cli          -> tmp.cli
in_hru%hru_data         -> hru-data.hru
in_parmdb%plants_plt    -> plants.plt
in_parmdb%fert_frt      -> fertilizer.frt
in_init%soil_plant_ini  -> soil_plant.ini
in_sol%soils_sol        -> soils.sol
```

## How to Use

### View the Lists
```bash
# Human-readable format
cat SWAT_INPUT_FILES.txt

# CSV format
cat SWAT_INPUT_FILES.csv
```

### Regenerate from Source
```bash
# Text format
python3 list_input_files.py > SWAT_INPUT_FILES.txt

# CSV format  
python3 list_input_files_csv.py > SWAT_INPUT_FILES.csv
```

## Technical Details

### Source Code Location
All input files are defined in: `src/input_file_module.f90` (lines 1-311)

### Fortran Type Definitions
Files are defined as Fortran type structures with default filenames:

```fortran
!! basin
type input_basin
  character(len=25) :: codes_bas = "codes.bsn"
  character(len=25) :: parms_bas = "parameters.bsn"
end type input_basin
type (input_basin) :: in_basin
```

### Variable Access Pattern
In code, files are accessed as: `<type_instance>%<field_name>`

Example: `open(107, file=in_basin%codes_bas)` opens `codes.bsn`

### Excluded Items
- Commented-out files (e.g., wind-dir.cli)
- Path variables (in_path_pcp, in_path_tmp, etc.)
- Output files (not defined in input_file_module.f90)

## Comparison with Original Request

The original request had a list of 192 files (mix of inputs and outputs). This new analysis:
- Focuses **only on inputs** (147 files)
- Shows **variable names** for each file (e.g., in_basin%codes_bas)
- Extracted **directly from source code** (no errors)
- Organized by **functional categories** (25 groups)
- Provides both **text and CSV** formats
- **Excludes output files** and commented entries

## Files Removed

The previous analysis had errors and mixed inputs/outputs. These files were removed:
- analyze_files_io.py
- enhanced_file_analysis.py  
- detailed_file_mapping.py
- file_io_analysis_report.txt
- enhanced_analysis_report.txt
- detailed_mapping_report.txt
- EXECUTIVE_SUMMARY.md
- EXAMPLE_OUTPUT.md
- FILE_IO_ANALYSIS_README.md
- README_QUICKSTART.md

## Result

**Clean, accurate list of 147 SWAT+ input files with their variable names, ready for use.**

---

*Generated: 2026-02-08*  
*Source: src/input_file_module.f90*  
*Repository: tugraskan/swatplus_ug*
