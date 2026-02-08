#!/usr/bin/env python3
"""
Enhanced SWAT+ File I/O Analysis Script

This enhanced version traces variable-based filenames back to their assignments
and provides better matching with the provided list.
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
            try:
                filename, count = part.rsplit(',', 1)
                files[filename] = int(count)
            except ValueError:
                pass
    return files

def trace_variable_assignments(src_dir):
    """
    Trace variable assignments to find filenames assigned to variables.
    This helps identify files referenced through variables like in_hru%hru_data
    """
    assignments = {}  # variable_name -> filename
    
    fortran_files = list(Path(src_dir).glob('**/*.f90'))
    
    # Common patterns for variable assignments pointing to filenames
    patterns = [
        r'(\w+)\s*=\s*["\']([^"\']+\.(hru|sol|cha|res|aqu|con|ini|ops|str|frt|plt|cli|cio|out|key|def|ele|lum|dtl|sch|cst|pth|pes|prt|hrd|fld|sft|rec|dat|del|exc|wet|sno|hyd|wro|urb|wal|til|sim|sep))["\']',
    ]
    
    for filepath in fortran_files:
        try:
            with open(filepath, 'r', encoding='utf-8', errors='ignore') as f:
                content = f.read()
            
            for pattern in patterns:
                for match in re.finditer(pattern, content, re.IGNORECASE):
                    var_name = match.group(1)
                    filename = match.group(2)
                    assignments[var_name.lower()] = filename
        except Exception as e:
            pass
    
    return assignments

def extract_all_literal_filenames(src_dir):
    """
    Extract all literal filenames from the source code, not just from OPEN statements.
    This catches files that might be referenced in other ways.
    """
    filenames = set()
    
    fortran_files = list(Path(src_dir).glob('**/*.f90'))
    
    # Pattern to match filename literals with common SWAT+ extensions
    pattern = r'["\']([^"\']+\.(hru|sol|cha|res|aqu|con|ini|ops|str|frt|plt|cli|cio|out|key|def|ele|lum|dtl|sch|cst|pth|pes|prt|hrd|fld|sft|rec|dat|del|exc|wet|sno|hyd|wro|urb|wal|til|sim|sep|txt|csv|swf|cbn|tes|com))["\']'
    
    for filepath in fortran_files:
        try:
            with open(filepath, 'r', encoding='utf-8', errors='ignore') as f:
                content = f.read()
            
            for match in re.finditer(pattern, content, re.IGNORECASE):
                filename = match.group(1)
                # Skip paths that are obviously not data files
                if not any(x in filename.lower() for x in ['/tmp/', 'test', 'example']):
                    filenames.add(filename)
        except Exception as e:
            pass
    
    return filenames

def normalize_for_matching(filename):
    """
    Normalize filename for loose matching with the provided list.
    Handle time series and format variations.
    """
    # Remove quotes and whitespace
    filename = filename.strip().strip('"').strip("'").strip()
    
    # Convert to lowercase
    base = filename.lower()
    
    # Remove directory paths
    base = os.path.basename(base)
    
    # Remove time series suffixes but keep the base name
    base = re.sub(r'_(day|mon|yr|aa)', '', base)
    
    # Normalize extension variations
    base = re.sub(r'\.(txt|csv)$', '', base)
    
    # Remove SWIFT prefix
    base = base.replace('swift/', '')
    
    return base

def find_matching_provided_file(code_file, provided_files):
    """
    Find if a code file matches any file in the provided list.
    Returns the matched provided filename or None.
    """
    code_norm = normalize_for_matching(code_file)
    
    for provided in provided_files.keys():
        provided_norm = normalize_for_matching(provided)
        
        # Exact match
        if code_norm == provided_norm:
            return provided
        
        # Base name match (without extension)
        code_base = re.sub(r'\.[^.]+$', '', code_norm)
        provided_base = re.sub(r'\.[^.]+$', '', provided_norm)
        if code_base == provided_base:
            return provided
    
    return None

def main():
    """Main entry point"""
    src_dir = Path(__file__).parent / 'src'
    
    if not src_dir.exists():
        print(f"Error: Source directory not found: {src_dir}", file=sys.stderr)
        sys.exit(1)
    
    print("Enhanced SWAT+ File I/O Analysis")
    print("=" * 80)
    print()
    
    provided_files = parse_provided_files()
    print(f"Step 1: Parsed {len(provided_files)} files from provided list")
    
    # Extract all literal filenames
    literal_files = extract_all_literal_filenames(src_dir)
    print(f"Step 2: Found {len(literal_files)} literal filenames in code")
    
    # Trace variable assignments
    assignments = trace_variable_assignments(src_dir)
    print(f"Step 3: Found {len(assignments)} variable assignments")
    
    all_code_files = literal_files
    print(f"Step 4: Total unique files in code: {len(all_code_files)}")
    print()
    
    # Match code files with provided list
    matched_files = set()
    unmatched_code_files = []
    
    for code_file in sorted(all_code_files):
        matched = find_matching_provided_file(code_file, provided_files)
        if matched:
            matched_files.add(matched)
        else:
            unmatched_code_files.append(code_file)
    
    # Find files in provided list but not in code
    unmatched_provided_files = []
    for provided_file in provided_files.keys():
        if provided_file not in matched_files:
            # Try reverse match
            found = False
            for code_file in all_code_files:
                if find_matching_provided_file(code_file, {provided_file: 1}):
                    found = True
                    break
            if not found:
                unmatched_provided_files.append(provided_file)
    
    # Generate report
    print("=" * 80)
    print("ANALYSIS RESULTS")
    print("=" * 80)
    print()
    
    print(f"Files in PROVIDED LIST: {len(provided_files)}")
    print(f"Files matched with CODE: {len(matched_files)}")
    print(f"Files in PROVIDED LIST but NOT in CODE: {len(unmatched_provided_files)}")
    print()
    
    print("Files in PROVIDED LIST but NOT found in CODE:")
    print("(These may be unused, use dynamic naming, or loaded via file.cio)")
    print("-" * 80)
    for f in sorted(unmatched_provided_files):
        count = provided_files.get(f, 0)
        print(f"  {f:<50} (referenced {count} times in original list)")
    
    print()
    print()
    print(f"Files in CODE but NOT in PROVIDED LIST: {len(unmatched_code_files)}")
    print("-" * 80)
    
    # Group unmatched code files by pattern
    grouped = defaultdict(list)
    for f in unmatched_code_files:
        # Normalize to base pattern
        base = normalize_for_matching(f)
        grouped[base].append(f)
    
    for base in sorted(grouped.keys()):
        files = grouped[base]
        if len(files) == 1:
            print(f"  {files[0]}")
        else:
            print(f"  {base} -> {', '.join(files[:3])}")
            if len(files) > 3:
                print(f"    ... and {len(files) - 3} more variants")
    
    print()
    print("=" * 80)
    print("SUMMARY STATISTICS")
    print("=" * 80)
    print(f"Files in provided list:                    {len(provided_files):4d}")
    print(f"Unique files found in code:                {len(all_code_files):4d}")
    print(f"Files matched between list and code:       {len(matched_files):4d}")
    print(f"Files in list but not clearly in code:     {len(unmatched_provided_files):4d}")
    print(f"Files in code but not in list:             {len(unmatched_code_files):4d}")
    print()
    
    # Calculate percentage
    match_rate = (len(matched_files) / len(provided_files) * 100) if provided_files else 0
    print(f"Match rate: {match_rate:.1f}%")
    print()

if __name__ == '__main__':
    main()
