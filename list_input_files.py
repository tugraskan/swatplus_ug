#!/usr/bin/env python3
"""
Extract all SWAT+ input files from input_file_module.f90

This script parses the input_file_module.f90 to extract all input file definitions
showing the variable name and corresponding filename.
"""

import re
from pathlib import Path

def parse_input_file_module(filepath):
    """Parse input_file_module.f90 and extract all input file definitions"""
    
    with open(filepath, 'r') as f:
        lines = f.readlines()
    
    content = ''.join(lines)
    
    # Also find the type instances to get the variable prefix
    # Pattern: type (type_name) :: variable_name
    type_pattern = r'type\s*\((\w+)\)\s*::\s*(\w+)'
    type_matches = re.findall(type_pattern, content, re.IGNORECASE)
    
    # Create mapping of type to variable prefix
    type_to_var = {}
    for type_name, var_name in type_matches:
        type_to_var[type_name] = var_name
    
    # Extract type definitions and their fields
    # Pattern: type type_name ... end type
    type_def_pattern = r'type\s+(\w+)\s*\n(.*?)end\s+type'
    type_defs = re.findall(type_def_pattern, content, re.DOTALL | re.IGNORECASE)
    
    inputs = []
    
    for type_name, type_body in type_defs:
        # Skip path types
        if 'path' in type_name.lower():
            continue
            
        # Get the variable prefix for this type
        var_prefix = type_to_var.get(type_name, 'unknown')
        
        # Split type body into lines and check for comments
        type_lines = type_body.split('\n')
        
        for line in type_lines:
            # Skip lines that start with ! (commented out)
            stripped = line.strip()
            if stripped.startswith('!'):
                continue
            
            # Find field definitions
            field_match = re.search(r'character\(len=\d+\)\s*::\s*(\w+)\s*=\s*"([^"]+)"', line, re.IGNORECASE)
            if field_match:
                field_name = field_match.group(1)
                filename = field_match.group(2)
                full_var_name = f"{var_prefix}%{field_name}"
                inputs.append((full_var_name, filename, type_name))
    
    return inputs

def main():
    """Main entry point"""
    
    # Path to input_file_module.f90
    module_path = Path(__file__).parent / 'src' / 'input_file_module.f90'
    
    if not module_path.exists():
        print(f"Error: {module_path} not found")
        return
    
    print("SWAT+ INPUT FILES")
    print("=" * 80)
    print()
    print("Extracted from: src/input_file_module.f90")
    print()
    
    inputs = parse_input_file_module(module_path)
    
    # Group by type
    current_type = None
    count = 0
    
    for var_name, filename, type_name in inputs:
        if type_name != current_type:
            if current_type is not None:
                print()
            current_type = type_name
            # Print type header
            type_comment = {
                'input_sim': 'Simulation Files',
                'input_basin': 'Basin Files',
                'input_cli': 'Climate Files',
                'input_con': 'Connection Files',
                'input_cha': 'Channel Files',
                'input_res': 'Reservoir Files',
                'input_ru': 'Routing Unit Files',
                'input_hru': 'HRU Files',
                'input_exco': 'External Constant (Recall Constant) Files',
                'input_rec': 'Recall Files',
                'input_delr': 'Delivery Ratio Files',
                'input_aqu': 'Aquifer Files',
                'input_herd': 'Herd/Animal Files',
                'input_water_rights': 'Water Rights Files',
                'input_link': 'Link Files',
                'input_hydrology': 'Hydrology Files',
                'input_structural': 'Structural Files',
                'input_parameter_databases': 'Parameter Database Files',
                'input_ops': 'Operation Scheduling Files',
                'input_lum': 'Land Use Management Files',
                'input_chg': 'Calibration Files',
                'input_init': 'Initial Condition Files',
                'input_soils': 'Soil Files',
                'input_condition': 'Conditional/Decision Table Files',
                'input_regions': 'Region Definition Files'
            }
            print(f"{type_comment.get(type_name, type_name)}")
            print("-" * 80)
        
        print(f"  {var_name:<35} -> {filename}")
        count += 1
    
    print()
    print("=" * 80)
    print(f"Total input files: {count}")
    print()

if __name__ == '__main__':
    main()
