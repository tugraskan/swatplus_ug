#!/usr/bin/env python3
"""
Generate CSV list of hardcoded files
"""

import re
from pathlib import Path
from collections import defaultdict

def get_configurable_files():
    """Get list of files already defined in input_file_module.f90"""
    module_path = Path(__file__).parent / 'src' / 'input_file_module.f90'
    
    with open(module_path, 'r') as f:
        content = f.read()
    
    pattern = r'character\(len=\d+\)\s*::\s*\w+\s*=\s*"([^"]+)"'
    matches = re.findall(pattern, content, re.IGNORECASE)
    
    return set(f.lower().strip() for f in matches)

def extract_hardcoded_files(src_dir):
    """Extract hardcoded filenames from OPEN statements in Fortran source"""
    
    hardcoded = defaultdict(list)
    
    fortran_files = list(Path(src_dir).glob('**/*.f90')) + list(Path(src_dir).glob('**/*.f'))
    
    for filepath in fortran_files:
        try:
            with open(filepath, 'r', encoding='utf-8', errors='ignore') as f:
                lines = f.readlines()
            
            for line_num, line in enumerate(lines, 1):
                match = re.search(r'open\s*\(\s*\d+\s*,\s*file\s*=\s*["\']([^"\']+)["\']', 
                                line, re.IGNORECASE)
                
                if match:
                    filename = match.group(1).strip()
                    
                    if any(x in filename.lower() for x in ['trim', 'adjustl', '//', '%']):
                        continue
                    
                    if '/' in filename or filename.startswith('.'):
                        continue
                    
                    rel_path = filepath.relative_to(src_dir)
                    hardcoded[filename.lower()].append((str(rel_path), line_num))
        
        except Exception as e:
            pass
    
    return hardcoded

def main():
    """Main entry point"""
    
    src_dir = Path(__file__).parent / 'src'
    
    configurable = get_configurable_files()
    hardcoded = extract_hardcoded_files(src_dir)
    
    # CSV header
    print("Filename,Configurable,References,Source_Files")
    
    # Sort by filename
    for filename in sorted(hardcoded.keys()):
        locations = hardcoded[filename]
        is_configurable = "Yes" if filename in configurable else "No"
        num_refs = len(locations)
        
        # Get unique source files
        source_files = sorted(set(loc[0] for loc in locations))
        sources_str = "; ".join(source_files[:3])
        if len(source_files) > 3:
            sources_str += f" (+{len(source_files)-3} more)"
        
        print(f'"{filename}",{is_configurable},{num_refs},"{sources_str}"')

if __name__ == '__main__':
    main()
