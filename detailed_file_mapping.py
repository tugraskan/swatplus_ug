#!/usr/bin/env python3
"""
Final SWAT+ File I/O Analysis - Detailed Mapping Report

This creates a comprehensive report showing:
1. Files from the provided list that are unused (not found in code)
2. Files in code that are not in the provided list
3. Detailed mapping of each file to the subroutines that open/write them
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
    """Parse the provided file list"""
    files = {}
    parts = PROVIDED_FILES.strip().split()
    for part in parts:
        if ',' in part:
            try:
                filename, count = part.rsplit(',', 1)
                files[filename] = int(count)
            except ValueError:
                pass
    return files

def normalize_filename(filename):
    """Normalize filename removing time series and format variations"""
    base = filename.strip().strip('"').strip("'").lower()
    base = os.path.basename(base)
    base = re.sub(r'_(day|mon|yr|aa)', '', base)
    base = re.sub(r'\.(txt|csv)$', '', base)
    base = base.replace('swift/', '')
    return base

def find_subroutine_or_function(lines, line_num):
    """Find the subroutine or function name for a given line number"""
    for i in range(line_num - 1, -1, -1):
        line = lines[i].strip().lower()
        match = re.match(r'^\s*(subroutine|function|program)\s+(\w+)', line)
        if match:
            return match.group(2)
    return "unknown"

def analyze_file_io(src_dir):
    """Analyze all file I/O in Fortran source files"""
    file_locations = defaultdict(list)  # filename -> [(source_file, subroutine, line_num, context)]
    
    fortran_files = list(Path(src_dir).glob('**/*.f90')) + list(Path(src_dir).glob('**/*.f'))
    
    # Pattern to match filename literals with SWAT+ extensions
    filename_pattern = r'["\']([^"\']+\.(hru|sol|cha|res|aqu|con|ini|ops|str|frt|plt|cli|cio|out|key|def|ele|lum|dtl|sch|cst|pth|pes|prt|hrd|fld|sft|rec|dat|del|exc|wet|sno|hyd|wro|urb|wal|til|sim|sep|txt|csv|swf|cbn|tes|com|fin))["\']'
    
    for filepath in fortran_files:
        try:
            with open(filepath, 'r', encoding='utf-8', errors='ignore') as f:
                lines = f.readlines()
            
            for line_num, line in enumerate(lines, 1):
                # Look for filename references
                for match in re.finditer(filename_pattern, line, re.IGNORECASE):
                    filename = match.group(1)
                    
                    # Determine context (OPEN, write, read, etc.)
                    context = "reference"
                    if re.search(r'\bopen\s*\(', line, re.IGNORECASE):
                        context = "open"
                    elif re.search(r'\bwrite\s*\(', line, re.IGNORECASE):
                        context = "write"
                    elif re.search(r'\bread\s*\(', line, re.IGNORECASE):
                        context = "read"
                    elif re.search(r'\binquire\s*\(', line, re.IGNORECASE):
                        context = "inquire"
                    
                    subroutine = find_subroutine_or_function(lines, line_num)
                    rel_path = filepath.relative_to(src_dir)
                    
                    file_locations[filename].append({
                        'source': str(rel_path),
                        'subroutine': subroutine,
                        'line': line_num,
                        'context': context
                    })
        except Exception as e:
            pass
    
    return file_locations

def main():
    """Main entry point"""
    src_dir = Path(__file__).parent / 'src'
    
    if not src_dir.exists():
        print(f"Error: Source directory not found: {src_dir}", file=sys.stderr)
        sys.exit(1)
    
    print("SWAT+ File I/O Detailed Mapping Report")
    print("=" * 100)
    print()
    
    # Parse provided files
    provided_files = parse_provided_files()
    print(f"Files in provided list: {len(provided_files)}")
    
    # Analyze code
    print("Analyzing Fortran source code...")
    file_locations = analyze_file_io(src_dir)
    print(f"Unique files found in code: {len(file_locations)}")
    print()
    
    # Create normalized mapping
    normalized_to_actual = defaultdict(set)
    for filename in file_locations.keys():
        norm = normalize_filename(filename)
        normalized_to_actual[norm].add(filename)
    
    provided_normalized = {}
    for pfile in provided_files.keys():
        norm = normalize_filename(pfile)
        provided_normalized[norm] = pfile
    
    # Find matches and non-matches
    matched_provided = set()
    for norm in provided_normalized.keys():
        if norm in normalized_to_actual:
            matched_provided.add(provided_normalized[norm])
    
    unmatched_provided = set(provided_files.keys()) - matched_provided
    unmatched_code = []
    for norm, actuals in normalized_to_actual.items():
        if norm not in provided_normalized:
            unmatched_code.extend(actuals)
    
    # Generate Report
    print("=" * 100)
    print("SECTION 1: FILES IN PROVIDED LIST NOT FOUND IN CODE (Potentially Unused)")
    print("=" * 100)
    print()
    print(f"Total: {len(unmatched_provided)} files")
    print()
    
    for filename in sorted(unmatched_provided):
        count = provided_files[filename]
        print(f"  {filename:<60} (ref count: {count})")
    
    print()
    print("=" * 100)
    print("SECTION 2: FILES IN CODE NOT IN PROVIDED LIST (Missing from List)")
    print("=" * 100)
    print()
    print(f"Total: {len(unmatched_code)} files (grouped by pattern)")
    print()
    
    # Group by normalized name
    grouped = defaultdict(list)
    for f in unmatched_code:
        norm = normalize_filename(f)
        grouped[norm].append(f)
    
    for norm in sorted(grouped.keys())[:100]:  # Show first 100 patterns
        files = grouped[norm]
        if len(files) == 1:
            f = files[0]
            locs = file_locations[f]
            print(f"\n  {f}")
            for loc in locs[:2]:
                print(f"    └─ {loc['context']:8} in {loc['subroutine']}() [{loc['source']}:{loc['line']}]")
            if len(locs) > 2:
                print(f"    └─ ... and {len(locs) - 2} more locations")
        else:
            print(f"\n  Pattern: {norm} ({len(files)} variants)")
            for f in files[:3]:
                print(f"    - {f}")
            if len(files) > 3:
                print(f"    - ... and {len(files) - 3} more")
    
    if len(grouped) > 100:
        print(f"\n  ... and {len(grouped) - 100} more patterns")
    
    print()
    print("=" * 100)
    print("SECTION 3: MATCHED FILES - DETAILED MAPPING")
    print("=" * 100)
    print()
    print(f"Total matched: {len(matched_provided)} files")
    print()
    
    for pfile in sorted(matched_provided)[:50]:  # Show first 50 matched files
        norm = normalize_filename(pfile)
        if norm in normalized_to_actual:
            print(f"\n  PROVIDED: {pfile}")
            code_files = sorted(normalized_to_actual[norm])
            for cfile in code_files[:3]:
                print(f"    CODE FILE: {cfile}")
                locs = file_locations[cfile]
                for loc in locs[:3]:
                    print(f"      └─ {loc['context']:8} in {loc['subroutine']}() [{loc['source']}:{loc['line']}]")
                if len(locs) > 3:
                    print(f"      └─ ... and {len(locs) - 3} more locations")
            if len(code_files) > 3:
                print(f"    ... and {len(code_files) - 3} more code file variants")
    
    if len(matched_provided) > 50:
        print(f"\n  ... and {len(matched_provided) - 50} more matched files")
    
    # Summary
    print()
    print("=" * 100)
    print("SUMMARY")
    print("=" * 100)
    print(f"Files in provided list:                 {len(provided_files):5d}")
    print(f"Files matched with code:                {len(matched_provided):5d}")
    print(f"Files in list but not in code:          {len(unmatched_provided):5d}")
    print(f"Unique files in code:                   {len(file_locations):5d}")
    print(f"Files in code but not in list:          {len(unmatched_code):5d}")
    print()
    match_rate = (len(matched_provided) / len(provided_files) * 100) if provided_files else 0
    print(f"Match rate: {match_rate:.1f}%")
    print()
    print("NOTE: Files with time series suffixes (_day, _mon, _yr, _aa) and format variations")
    print("      (.txt, .csv) are grouped together as they represent the same logical file.")
    print("=" * 100)

if __name__ == '__main__':
    main()
