#!/usr/bin/env python3
"""
Generate CSV list of SWAT+ input files from input_file_module.f90
"""

import re
from pathlib import Path

def parse_input_file_module(filepath):
    """Parse input_file_module.f90 and extract all input file definitions"""
    
    with open(filepath, 'r') as f:
        lines = f.readlines()
    
    content = ''.join(lines)
    
    # Find the type instances to get the variable prefix
    type_pattern = r'type\s*\((\w+)\)\s*::\s*(\w+)'
    type_matches = re.findall(type_pattern, content, re.IGNORECASE)
    
    # Create mapping of type to variable prefix
    type_to_var = {}
    for type_name, var_name in type_matches:
        type_to_var[type_name] = var_name
    
    # Extract type definitions and their fields
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
    
    inputs = parse_input_file_module(module_path)
    
    # Print CSV header
    print("Variable,Filename,Category")
    
    # Type to category mapping
    type_categories = {
        'input_sim': 'Simulation',
        'input_basin': 'Basin',
        'input_cli': 'Climate',
        'input_con': 'Connection',
        'input_cha': 'Channel',
        'input_res': 'Reservoir',
        'input_ru': 'Routing Unit',
        'input_hru': 'HRU',
        'input_exco': 'External Constant',
        'input_rec': 'Recall',
        'input_delr': 'Delivery Ratio',
        'input_aqu': 'Aquifer',
        'input_herd': 'Herd/Animal',
        'input_water_rights': 'Water Rights',
        'input_link': 'Link',
        'input_hydrology': 'Hydrology',
        'input_structural': 'Structural',
        'input_parameter_databases': 'Parameter Database',
        'input_ops': 'Operation Scheduling',
        'input_lum': 'Land Use Management',
        'input_chg': 'Calibration',
        'input_init': 'Initial Condition',
        'input_soils': 'Soil',
        'input_condition': 'Conditional/Decision Table',
        'input_regions': 'Region Definition'
    }
    
    for var_name, filename, type_name in inputs:
        category = type_categories.get(type_name, type_name)
        print(f"{var_name},{filename},{category}")

if __name__ == '__main__':
    main()
