#!/usr/bin/env python3
"""
Find hardcoded files in SWAT+ source code

This script identifies files that are hardcoded (literal strings) in the 
Fortran source code and are NOT configurable through file.cio or 
input_file_module.f90.
"""

import re
from pathlib import Path
from collections import defaultdict

def get_configurable_files():
    """Get list of files already defined in input_file_module.f90"""
    module_path = Path(__file__).parent / 'src' / 'input_file_module.f90'
    
    with open(module_path, 'r') as f:
        content = f.read()
    
    # Extract filenames from character variable definitions
    pattern = r'character\(len=\d+\)\s*::\s*\w+\s*=\s*"([^"]+)"'
    matches = re.findall(pattern, content, re.IGNORECASE)
    
    # Normalize to lowercase for comparison
    return set(f.lower().strip() for f in matches)

def extract_hardcoded_files(src_dir):
    """Extract hardcoded filenames from OPEN statements in Fortran source"""
    
    hardcoded = defaultdict(list)  # filename -> [(source_file, line_num, line_content)]
    
    fortran_files = list(Path(src_dir).glob('**/*.f90')) + list(Path(src_dir).glob('**/*.f'))
    
    for filepath in fortran_files:
        try:
            with open(filepath, 'r', encoding='utf-8', errors='ignore') as f:
                lines = f.readlines()
            
            for line_num, line in enumerate(lines, 1):
                # Look for OPEN statements with literal string filenames
                # Pattern: open(unit, file="filename.ext")
                match = re.search(r'open\s*\(\s*\d+\s*,\s*file\s*=\s*["\']([^"\']+)["\']', 
                                line, re.IGNORECASE)
                
                if match:
                    filename = match.group(1).strip()
                    
                    # Skip if it's clearly a variable or expression
                    if any(x in filename.lower() for x in ['trim', 'adjustl', '//', '%']):
                        continue
                    
                    # Skip paths and system files
                    if '/' in filename or filename.startswith('.'):
                        continue
                    
                    rel_path = filepath.relative_to(src_dir)
                    hardcoded[filename.lower()].append((str(rel_path), line_num, line.strip()))
        
        except Exception as e:
            pass
    
    return hardcoded

def main():
    """Main entry point"""
    
    src_dir = Path(__file__).parent / 'src'
    
    if not src_dir.exists():
        print(f"Error: {src_dir} not found")
        return
    
    print("HARDCODED FILES IN SWAT+ SOURCE CODE")
    print("=" * 80)
    print()
    print("Files that are hardcoded in the source and NOT configurable via file.cio")
    print()
    
    # Get configurable files from input_file_module.f90
    configurable = get_configurable_files()
    print(f"Step 1: Found {len(configurable)} configurable files in input_file_module.f90")
    
    # Get hardcoded files from source code
    hardcoded = extract_hardcoded_files(src_dir)
    print(f"Step 2: Found {len(hardcoded)} hardcoded file references in source code")
    print()
    
    # Find files that are hardcoded but NOT configurable
    non_configurable = {}
    also_configurable = {}
    
    for filename, locations in hardcoded.items():
        if filename in configurable:
            also_configurable[filename] = locations
        else:
            non_configurable[filename] = locations
    
    print("=" * 80)
    print("HARDCODED FILES NOT IN FILE.CIO (NOT CONFIGURABLE)")
    print("=" * 80)
    print()
    print(f"Total: {len(non_configurable)} files")
    print()
    
    # Sort by frequency
    sorted_files = sorted(non_configurable.items(), 
                         key=lambda x: len(x[1]), reverse=True)
    
    for filename, locations in sorted_files:
        print(f"File: {filename}")
        print(f"  Referenced {len(locations)} time(s):")
        for source_file, line_num, line_content in locations[:5]:  # Show first 5
            print(f"    - {source_file}:{line_num}")
            print(f"      {line_content}")
        if len(locations) > 5:
            print(f"    ... and {len(locations) - 5} more references")
        print()
    
    # Also show files that are both hardcoded AND configurable
    print()
    print("=" * 80)
    print("FILES THAT ARE BOTH HARDCODED AND CONFIGURABLE")
    print("=" * 80)
    print()
    print(f"Total: {len(also_configurable)} files")
    print("(These have defaults in input_file_module.f90 but are also hardcoded)")
    print()
    
    sorted_both = sorted(also_configurable.items(), 
                        key=lambda x: len(x[1]), reverse=True)
    
    for filename, locations in sorted_both[:20]:  # Show first 20
        print(f"  {filename:<40} ({len(locations)} reference(s))")
    
    if len(sorted_both) > 20:
        print(f"  ... and {len(sorted_both) - 20} more")
    
    # Summary
    print()
    print("=" * 80)
    print("SUMMARY")
    print("=" * 80)
    print(f"Configurable files (in input_file_module.f90):    {len(configurable):4d}")
    print(f"Hardcoded files (literal strings in code):        {len(hardcoded):4d}")
    print(f"  - NOT configurable (hardcoded only):             {len(non_configurable):4d}")
    print(f"  - Also configurable (have defaults):             {len(also_configurable):4d}")
    print()
    print(f"NON-CONFIGURABLE RATE: {len(non_configurable)/max(len(hardcoded),1)*100:.1f}%")
    print()

if __name__ == '__main__':
    main()
