#!/usr/bin/env python3
"""
SWAT+ File I/O Analysis Script

This script analyzes all Fortran source files to:
1. Find all input/output files referenced in the code
2. Identify which subroutine/function opens or writes each file
3. Compare with a provided list of files
4. Group files by base name (handling time series and format variations)
"""

import re
import os
from pathlib import Path
from collections import defaultdict
import sys

# The provided list of files from the problem statement
PROVIDED_FILES = """
animal.hrd,1 aqu_catunit.def,6 aqu_catunit.ele,7 aqu_cha.lin,6 aqu_reg.def,6 aquifer.aqu,18 aquifer.con,20 aquifer.out,17 aquifer2d.con,20 atmo.cli,12 bmpuser.str,10 bsn_chan.out,13 cal_parms.cal,7 calibration.cal,16 ch_catunit.def,6 ch_catunit.ele,1 ch_reg.def,6 ch_sed_budget.sft,11 ch_sed_parms.sft,8 cha.key,21 chan-surf.lin,6 chandeg.con,20 channel-lte.cha,7 channel.cha,7 channel.con,20 channel.out,62 chem_app.ops,11 cntable.lum,13 codes.bsn,26 codes.sft,9 cons_prac.lum,9 constituents.cs,10 crop_yld_aa.out,5 delratio.con,20 delratio.del,7 deposition .out,29 diagnostics.out,4 dr_hmet.del,4 dr_om.del,20 dr_path.del,4 dr_pest.del,4 dr_salt.del,4 element.wro,1 exco.con,20 exco.exc,7 exco_hmet.exc,4 exco_om.exc,20 exco_path.exc,4 exco_pest.exc,4 exco_salt.exc,4 fertilizer.frt,8 field.fld,5 file.cio,152 files_out.out,2 filterstrip.str,7 fire.ops,5 flo_con.dtl,45 flow_duration_curve.out,11 grassedww.str,10 graze.ops,8 harv.ops,6 herd.hrd,1 hmd.cli,1 hmet_hru.ini,5 hmet_water.ini,5 hru-data.hru,10 hru-lte.con,20 hru-lte.hru,35 hru.con,20 hru_sub.key,12 hycon.out,4 hyd-out.out,29 hyd-sed-lte.cha,25 hyd_in.out,29 hydcon.out,7 hydrology.cha,12 hydrology.hyd,16 hydrology.res,12 hydrology.wet,11 initial.aqu,6 initial.cha,8 initial.res,8 irr.ops,10 landuse.lum,16 losses.bsn,14 losses.hru,15 losses.sd,14 losses.sub,14 ls_cal.reg,1 ls_reg.def,7 ls_reg.ele,5 ls_unit.def,8 ls_unit.ele,6 lum.dtl,45 management.sch,18 metl.cst,9 mgt.key,24 mgt.out,29 modflow.con,20 NEEDS WORK,4 nutbal.bsn,21 nutbal.hru,22 nutbal.sub,21 nutrients.cha,41 nutrients.res,14 nutrients.sol,14 object.cnt,21 om_water.ini,21 out.key,16 outlet.con,20 ovn_table.lum,8 parameters.bsn,45 path.cst,9 path_hru_ini,5 path_water.ini,5 pathogens.pth,20 pcp.cli,1 pest.cst,9 pest_hru.ini,5 pest_water.ini,5 pesticide.pes,16 pet.cli,1 plant.ini,14 plant_gro.sft,11 plant_parms.sft,11 plants.plt,57 plantwx.bsn,20 plantwx.hru,26 plantwx.sd,20 plantwx.sub,20 print.prt,227 ranch.hrd,1 rec_catunit.def,6 rec_catunit.ele,7 rec_reg.def,6 recall.con,20 recall.rec,4 recann.dat,25 recday.dat,25 res.dtl,47 res.key,21 res_catunit.def,6 res_catunit.ele,7 res_reg.def,6 reservoir.con,20 reservoir.out,44 reservoir.res,8 rout_unit.con,20 rout_unit.def,6 rout_unit.dr,19 rout_unit.ele,6 rout_unit.rtu,7 salt.cst,9 salt_hru_ini,5 salt_water.ini,5 scen_lu.dtl,45 sd_channel.out,17 sed_nut.cha,12 sediment.cha,26 sediment.res,8 septic.sep,12 septic.str,29 slr.cli,1 snow.sno,10 soil_plant.ini,9 soils.out,7 soils.sol,25 soils_lte.sol,6 sweep.ops,5 temperature.cha,7 tiledrain.str,11 tillage.til,8 time.sim,6 tmp.cli,1 topography.hyd,7 transfer.wro,1 urban.urb,13 water_allocation.wro,49 water_balance.sft,15 water_rights.wro,1 waterbal.bsn,20 waterbal.hru,42 waterbal.sd,20 waterbal.sub,20 wb_parms.sft,8 weather-sta.cli,9 weather-wgn.cli,22 weir.res,8 wetland.wet,10 wind-dir.cli,18 wnd.cli,1 yield.out,7
"""

def parse_provided_files():
    """Parse the provided file list into a dictionary"""
    files = {}
    parts = PROVIDED_FILES.strip().split()
    for part in parts:
        if ',' in part:
            filename, count = part.rsplit(',', 1)
            try:
                files[filename] = int(count)
            except ValueError:
                # Handle cases where filename has comma
                files[filename + ',' + count] = 0
    return files

def normalize_filename(filename):
    """
    Normalize filenames to group similar files together.
    Handle time series (_day, _mon, _yr, _aa) and formats (.txt, .csv)
    """
    # Remove quotes and whitespace
    filename = filename.strip().strip('"').strip("'")
    
    # Convert to lowercase for comparison
    base = filename.lower()
    
    # Remove time series suffixes
    base = re.sub(r'_(day|mon|yr|aa)\.(txt|csv)$', '.*', base)
    base = re.sub(r'_(day|mon|yr|aa)$', '.*', base)
    
    # Normalize txt/csv extension
    base = re.sub(r'\.(txt|csv)$', '.*', base)
    
    return base

def find_subroutine_or_function(lines, line_num):
    """Find the subroutine or function name for a given line number"""
    # Search backwards from the line to find the subroutine/function declaration
    for i in range(line_num - 1, -1, -1):
        line = lines[i].strip().lower()
        # Match subroutine or function declarations
        match = re.match(r'^\s*(subroutine|function)\s+(\w+)', line)
        if match:
            return match.group(2)
    return "unknown"

def extract_filename_from_open(line):
    """Extract filename from an OPEN statement"""
    # Pattern for file='filename' or file="filename"
    match = re.search(r'file\s*=\s*["\']([^"\']+)["\']', line, re.IGNORECASE)
    if match:
        return match.group(1)
    
    # Pattern for file=variable (we'll need to track these separately)
    match = re.search(r'file\s*=\s*(\w+)', line, re.IGNORECASE)
    if match:
        return f"<variable:{match.group(1)}>"
    
    return None

def analyze_fortran_files(src_dir):
    """Analyze all Fortran files in the source directory"""
    files_found = defaultdict(list)  # filename -> [(source_file, subroutine, line_num)]
    variable_refs = defaultdict(list)  # variable_name -> [(source_file, subroutine, line_num)]
    
    fortran_files = list(Path(src_dir).glob('**/*.f90')) + list(Path(src_dir).glob('**/*.f'))
    
    for filepath in fortran_files:
        try:
            with open(filepath, 'r', encoding='utf-8', errors='ignore') as f:
                lines = f.readlines()
            
            for line_num, line in enumerate(lines, 1):
                # Look for OPEN statements
                if re.search(r'\bopen\s*\(', line, re.IGNORECASE):
                    filename = extract_filename_from_open(line)
                    if filename:
                        subroutine = find_subroutine_or_function(lines, line_num)
                        rel_path = filepath.relative_to(src_dir)
                        
                        if filename.startswith('<variable:'):
                            var_name = filename[10:-1]  # Extract variable name
                            variable_refs[var_name].append((str(rel_path), subroutine, line_num))
                        else:
                            files_found[filename].append((str(rel_path), subroutine, line_num))
        except Exception as e:
            print(f"Error processing {filepath}: {e}", file=sys.stderr)
    
    return files_found, variable_refs

def group_files_by_pattern(files_found):
    """Group files by their normalized pattern"""
    grouped = defaultdict(list)
    for filename, locations in files_found.items():
        normalized = normalize_filename(filename)
        grouped[normalized].append((filename, locations))
    return grouped

def generate_report(files_found, variable_refs, provided_files):
    """Generate a comprehensive report"""
    print("=" * 80)
    print("SWAT+ FILE I/O ANALYSIS REPORT")
    print("=" * 80)
    print()
    
    # Section 1: Files found in code with their locations
    print("1. FILES FOUND IN CODE")
    print("-" * 80)
    
    # Group by pattern
    grouped = group_files_by_pattern(files_found)
    
    for pattern in sorted(grouped.keys()):
        file_group = grouped[pattern]
        print(f"\nPattern: {pattern}")
        for filename, locations in file_group:
            print(f"  File: {filename}")
            for source_file, subroutine, line_num in locations[:3]:  # Show first 3 locations
                print(f"    - {source_file} :: {subroutine}() [line {line_num}]")
            if len(locations) > 3:
                print(f"    ... and {len(locations) - 3} more locations")
    
    print(f"\nTotal unique filenames found: {len(files_found)}")
    print(f"Total unique patterns: {len(grouped)}")
    
    # Section 2: Variable-based file references
    print("\n\n2. VARIABLE-BASED FILE REFERENCES")
    print("-" * 80)
    for var_name in sorted(variable_refs.keys())[:20]:  # Show first 20
        locations = variable_refs[var_name]
        print(f"\nVariable: {var_name}")
        for source_file, subroutine, line_num in locations[:2]:
            print(f"  - {source_file} :: {subroutine}() [line {line_num}]")
        if len(locations) > 2:
            print(f"  ... and {len(locations) - 2} more locations")
    
    if len(variable_refs) > 20:
        print(f"\n... and {len(variable_refs) - 20} more variables")
    
    # Section 3: Comparison with provided list
    print("\n\n3. COMPARISON WITH PROVIDED LIST")
    print("-" * 80)
    
    # Normalize provided files
    provided_normalized = {normalize_filename(f): f for f in provided_files.keys()}
    code_normalized = set(grouped.keys())
    
    # Files in list but not in code
    in_list_not_code = []
    for norm_name, orig_name in provided_normalized.items():
        # Check for exact match or pattern match
        found = False
        for code_pattern in code_normalized:
            if norm_name == code_pattern or norm_name in code_pattern or code_pattern in norm_name:
                found = True
                break
        if not found:
            in_list_not_code.append(orig_name)
    
    print("\nFiles in PROVIDED LIST but NOT clearly found in CODE:")
    print("(These may be unused or use variable-based filenames)")
    for f in sorted(in_list_not_code)[:50]:  # Show first 50
        print(f"  - {f}")
    if len(in_list_not_code) > 50:
        print(f"  ... and {len(in_list_not_code) - 50} more")
    print(f"\nTotal: {len(in_list_not_code)} files")
    
    # Files in code but not in list
    in_code_not_list = []
    for code_pattern in code_normalized:
        found = False
        for norm_name in provided_normalized.keys():
            if norm_name == code_pattern or norm_name in code_pattern or code_pattern in norm_name:
                found = True
                break
        if not found and not code_pattern.startswith('<variable'):
            in_code_not_list.append(code_pattern)
    
    print("\n\nFiles in CODE but NOT in provided LIST:")
    for f in sorted(in_code_not_list):
        if f in grouped:
            examples = [fname for fname, _ in grouped[f]]
            print(f"  - {f}")
            print(f"    Examples: {', '.join(examples[:3])}")
    print(f"\nTotal: {len(in_code_not_list)} file patterns")
    
    # Section 4: Summary statistics
    print("\n\n4. SUMMARY STATISTICS")
    print("-" * 80)
    print(f"Files in provided list: {len(provided_files)}")
    print(f"Unique filenames found in code: {len(files_found)}")
    print(f"Unique file patterns in code: {len(grouped)}")
    print(f"Variable-based file references: {len(variable_refs)}")
    print(f"Files potentially unused: {len(in_list_not_code)}")
    print(f"Files missing from list: {len(in_code_not_list)}")
    
    print("\n" + "=" * 80)

def main():
    """Main entry point"""
    src_dir = Path(__file__).parent / 'src'
    
    if not src_dir.exists():
        print(f"Error: Source directory not found: {src_dir}", file=sys.stderr)
        sys.exit(1)
    
    print("Analyzing Fortran source files...")
    print(f"Source directory: {src_dir}")
    print()
    
    provided_files = parse_provided_files()
    print(f"Parsed {len(provided_files)} files from provided list")
    
    files_found, variable_refs = analyze_fortran_files(src_dir)
    print(f"Found {len(files_found)} unique filenames in code")
    print(f"Found {len(variable_refs)} variable-based file references")
    print()
    
    generate_report(files_found, variable_refs, provided_files)

if __name__ == '__main__':
    main()
