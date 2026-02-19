#!/usr/bin/env python3
"""
SWAT+ I/O Trace Documentation Generator

This script automates the generation of I/O trace documentation for SWAT+ input files.
It analyzes Fortran source code to extract file I/O patterns, variable definitions,
and type structures.

Usage:
    python generate_io_trace.py <filename>
    
Example:
    python generate_io_trace.py aquifer.aqu
    
The script will:
1. Search for the filename in input_file_module.f90 to find the variable name
2. Locate the read subroutine that processes this file
3. Extract I/O statements and variable lists
4. Generate a PRIMARY DATA READ table with all components
"""

import re
import sys
import os
from pathlib import Path
from typing import List, Dict, Tuple, Optional

class IOTraceGenerator:
    def __init__(self, src_dir: str = "src"):
        self.src_dir = Path(src_dir)
        self.input_file_module = self.src_dir / "input_file_module.f90"
        
    def find_file_variable(self, filename: str) -> Optional[Tuple[str, str, str]]:
        """Find the variable and derived type for a given filename.
        
        Returns: (variable_name, derived_type, default_value)
        """
        if not self.input_file_module.exists():
            return None
            
        content = self.input_file_module.read_text()
        
        # Search for filename assignments like: aqu = "aquifer.aqu"
        pattern = rf'(\w+)\s*=\s*["\']({re.escape(filename)})["\']'
        match = re.search(pattern, content)
        
        if match:
            var_name = match.group(1)
            # Find which derived type this belongs to
            # Look backwards for type definition
            lines = content[:match.start()].split('\n')
            for line in reversed(lines):
                if 'type(' in line.lower() and '::' in line:
                    type_match = re.search(r'type\((\w+)\)\s*::\s*(\w+)', line, re.IGNORECASE)
                    if type_match:
                        derived_type = type_match.group(2)
                        return (f"{derived_type}%{var_name}", derived_type, filename)
        
        return None
    
    def find_read_subroutine(self, file_variable: str) -> Optional[Path]:
        """Find the subroutine that reads this file."""
        # Search all .f90 files for this variable in open or read statements
        for f90_file in self.src_dir.glob("**/*.f90"):
            content = f90_file.read_text()
            if file_variable in content:
                # Check if it's in an open statement
                if re.search(rf'open\s*\([^)]*{re.escape(file_variable)}', content, re.IGNORECASE):
                    return f90_file
        return None
    
    def extract_io_statements(self, subroutine_file: Path, file_variable: str) -> Dict:
        """Extract I/O statements from the subroutine."""
        content = subroutine_file.read_text()
        
        result = {
            'file': subroutine_file.name,
            'open_statement': None,
            'unit': None,
            'read_statements': [],
            'close_statement': None
        }
        
        # Find open statement
        open_match = re.search(
            rf'open\s*\(\s*(?:unit\s*=\s*)?(\d+)\s*,.*?file\s*=\s*{re.escape(file_variable)}',
            content, re.IGNORECASE | re.DOTALL
        )
        if open_match:
            result['unit'] = open_match.group(1)
            result['open_statement'] = open_match.group(0)
        
        # Find read statements using this unit
        if result['unit']:
            read_pattern = rf'read\s*\(\s*{result["unit"]}[^)]*\)(.+?)(?:\n|$)'
            for match in re.finditer(read_pattern, content, re.IGNORECASE):
                result['read_statements'].append(match.group(0).strip())
        
        return result
    
    def generate_documentation(self, filename: str) -> str:
        """Generate documentation for a given input file."""
        output = []
        output.append(f"# I/O Trace Documentation: {filename}\n")
        output.append("=" * 70 + "\n")
        
        # Step 1: Find file variable
        file_info = self.find_file_variable(filename)
        if not file_info:
            output.append(f"ERROR: Could not find '{filename}' in {self.input_file_module}\n")
            return '\n'.join(output)
        
        var_name, derived_type, default_val = file_info
        output.append(f"## Filename Resolution\n")
        output.append(f"- Variable: `{var_name}`\n")
        output.append(f"- Derived Type: `{derived_type}`\n")
        output.append(f"- Default Value: `{default_val}`\n")
        output.append(f"- Declared in: `{self.input_file_module}`\n\n")
        
        # Step 2: Find read subroutine
        subroutine_file = self.find_read_subroutine(var_name)
        if not subroutine_file:
            output.append(f"ERROR: Could not find subroutine that reads '{var_name}'\n")
            return '\n'.join(output)
        
        output.append(f"## I/O Subroutine\n")
        output.append(f"- File: `{subroutine_file}`\n\n")
        
        # Step 3: Extract I/O statements
        io_info = self.extract_io_statements(subroutine_file, var_name)
        
        output.append(f"## I/O Statements\n")
        if io_info['open_statement']:
            output.append(f"### Open Statement\n")
            output.append(f"```fortran\n{io_info['open_statement']}\n```\n")
            output.append(f"- Unit: {io_info['unit']}\n\n")
        
        if io_info['read_statements']:
            output.append(f"### Read Statements ({len(io_info['read_statements'])} total)\n")
            for i, stmt in enumerate(io_info['read_statements'], 1):
                output.append(f"{i}. ```fortran\n{stmt}\n```\n")
        
        output.append("\n## Next Steps\n")
        output.append("To complete the documentation:\n")
        output.append(f"1. Manually analyze each read statement in `{subroutine_file}`\n")
        output.append("2. Extract variable names from the I/O list\n")
        output.append("3. Look up type definitions for derived types\n")
        output.append("4. Create PRIMARY DATA READ table with all components\n")
        output.append("5. Add line numbers, defaults, units, and descriptions\n")
        
        return '\n'.join(output)
    
    def generate_primary_data_table_template(self, filename: str) -> str:
        """Generate a template for PRIMARY DATA READ table."""
        output = []
        output.append(f"\n## PRIMARY DATA READ Table Template: {filename}\n")
        output.append("| Line in File | Position | Local (Y/N) | Derived Type | Component | Type | Default | Units | Description | Swat_codetype | Source Line |\n")
        output.append("|--------------|----------|-------------|--------------|-----------|------|---------|-------|-------------|---------------|-------------|\n")
        output.append("| 3+ | 1 | Y | N/A | variable_name | type | default | units | description | derived_type | src/file.f90:line |\n")
        output.append("| ... | ... | ... | ... | ... | ... | ... | ... | ... | ... | ... |\n")
        return '\n'.join(output)

def main():
    if len(sys.argv) < 2:
        print("Usage: python generate_io_trace.py <filename>")
        print("Example: python generate_io_trace.py aquifer.aqu")
        sys.exit(1)
    
    filename = sys.argv[1]
    
    generator = IOTraceGenerator()
    documentation = generator.generate_documentation(filename)
    print(documentation)
    print(generator.generate_primary_data_table_template(filename))
    
    # Optionally save to file
    output_file = f"io_trace_{filename.replace('.', '_')}.md"
    with open(output_file, 'w') as f:
        f.write(documentation)
        f.write(generator.generate_primary_data_table_template(filename))
    
    print(f"\nDocumentation saved to: {output_file}")

if __name__ == "__main__":
    main()
