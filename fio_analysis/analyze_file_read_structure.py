#!/usr/bin/env python3
"""
Analyze file read structures in Fortran files after open statements.
This script identifies:
1. Whether files read title/header lines
2. What data types are read from inputs  
3. The structure of data being read
"""

import os
import re
import sys
from pathlib import Path

class FileReadStructureAnalyzer:
    def __init__(self, source_dir):
        self.source_dir = Path(source_dir)
        self.results = []
        
        # Pattern to match open statements with string literals
        self.open_pattern = re.compile(r'open\s*\(\s*([^,\s]+)\s*,\s*file\s*=\s*["\']([^"\']+)["\'][^)]*\)', re.IGNORECASE)
        
        # Pattern to match read statements
        self.read_pattern = re.compile(r'read\s*\(\s*([^,\s]+)\s*[,\)]', re.IGNORECASE)
        
        # Fortran data type patterns in comments and variable declarations
        self.data_type_patterns = {
            'integer': re.compile(r'integer', re.IGNORECASE),
            'real': re.compile(r'real', re.IGNORECASE),
            'character': re.compile(r'character', re.IGNORECASE),
            'logical': re.compile(r'logical', re.IGNORECASE),
            'double_precision': re.compile(r'double\s+precision', re.IGNORECASE),
        }
        
    def analyze_file(self, file_path):
        """Analyze a single Fortran file for file read structures."""
        file_results = []
        
        try:
            with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
                lines = f.readlines()
            
            # Find all open statements with string literals
            open_statements = []
            for line_num, line in enumerate(lines, 1):
                line_stripped = line.strip()
                
                # Skip comments
                if not line_stripped or line_stripped.startswith('!') or line_stripped.startswith('c') or line_stripped.startswith('C'):
                    continue
                    
                matches = self.open_pattern.findall(line)
                for file_unit, filename in matches:
                    open_statements.append({
                        'line_num': line_num,
                        'line': line.strip(),
                        'file_unit': file_unit,
                        'filename': filename,
                        'read_structure': []
                    })
            
            # For each open statement, analyze subsequent read operations
            for open_stmt in open_statements:
                read_structure = self.analyze_read_structure(lines, open_stmt, file_path.name)
                open_stmt['read_structure'] = read_structure
                file_results.append(open_stmt)
            
        except Exception as e:
            print(f"Error analyzing {file_path}: {e}")
        
        return file_results
    
    def analyze_read_structure(self, lines, open_stmt, filename):
        """Analyze the read structure following an open statement."""
        file_unit = open_stmt['file_unit']
        start_line = open_stmt['line_num']
        read_structure = []
        
        # Look ahead for read statements using the same file unit
        for i in range(start_line, min(start_line + 50, len(lines))):  # Look ahead 50 lines max
            line = lines[i].strip()
            
            # Skip comments and empty lines
            if not line or line.startswith('!') or line.startswith('c') or line.startswith('C'):
                continue
            
            # Check if this line contains a read from our file unit
            read_match = self.read_pattern.search(line)
            if read_match and read_match.group(1).strip() == file_unit:
                read_info = self.analyze_read_statement(line, i + 1)
                if read_info:
                    read_structure.append(read_info)
                    
                # Stop if we hit a close statement for this file unit
                if 'close' in line.lower() and file_unit in line:
                    break
                    
            # Stop if we encounter another open statement (likely different file)
            elif 'open' in line.lower() and '=' in line:
                break
                
            # Stop if we encounter end of subroutine/function
            elif re.match(r'\s*(end\s+)?(subroutine|function)', line, re.IGNORECASE):
                break
                
        return read_structure
    
    def analyze_read_statement(self, line, line_num):
        """Analyze a single read statement to determine what's being read."""
        read_info = {
            'line_num': line_num,
            'line': line.strip(),
            'read_type': 'unknown',
            'variables': [],
            'format': None,
            'data_types': []
        }
        
        # Check if it's a header/title read (common patterns)
        if any(keyword in line.lower() for keyword in ['header', 'title', '*']):
            if 'header' in line.lower():
                read_info['read_type'] = 'header'
            elif '*' in line and not any(var in line for var in ['(', ')']):
                read_info['read_type'] = 'title_or_skip'
            else:
                read_info['read_type'] = 'data'
        else:
            read_info['read_type'] = 'data'
        
        # Extract variables being read
        # Look for variables after the read statement
        if ')' in line:
            after_paren = line.split(')', 1)[1].strip()
            if after_paren:
                # Remove common prefixes and split by commas
                variables = [var.strip() for var in after_paren.split(',') if var.strip()]
                read_info['variables'] = variables
        
        # Determine format
        if '*' in line:
            read_info['format'] = 'free_format'
        elif any(fmt in line for fmt in ["'", '"', "fmt="]):
            read_info['format'] = 'formatted'
        else:
            read_info['format'] = 'unformatted'
        
        # Try to infer data types from variable names and comments
        read_info['data_types'] = self.infer_data_types(line, read_info['variables'])
        
        return read_info
    
    def infer_data_types(self, line, variables):
        """Infer data types from variable names and comments."""
        data_types = []
        
        # Common Fortran variable naming conventions
        for var in variables:
            if not var:
                continue
                
            var_lower = var.lower()
            
            # Integer patterns (i, j, k, n, m, id, num, etc.)
            if (var_lower.startswith(('i', 'j', 'k', 'n', 'm', 'id', 'num', 'count')) or 
                'id' in var_lower or 'num' in var_lower or 'flag' in var_lower):
                data_types.append('integer')
            # Real patterns
            elif (var_lower.startswith(('x', 'y', 'z', 'r', 'val', 'coord', 'dist', 'size', 'depth', 'width')) or
                  any(keyword in var_lower for keyword in ['coord', 'dist', 'size', 'area', 'volume', 'depth', 'width', 'length', 'thick'])):
                data_types.append('real')
            # Character patterns
            elif (var_lower.startswith(('c', 'str', 'name', 'header', 'title', 'type')) or
                  any(keyword in var_lower for keyword in ['name', 'header', 'title', 'type', 'file'])):
                data_types.append('character')
            # Logical patterns
            elif ('flag' in var_lower or var_lower.startswith('i_exist') or 'exist' in var_lower):
                data_types.append('logical')
            else:
                data_types.append('unknown')
        
        # Check comments for explicit type information
        comment_match = re.search(r'!\s*(.+)', line)
        if comment_match:
            comment = comment_match.group(1).lower()
            for dtype, pattern in self.data_type_patterns.items():
                if pattern.search(comment):
                    if dtype not in data_types:
                        data_types.append(dtype)
        
        return list(set(data_types)) if data_types else ['unknown']
    
    def analyze_directory(self):
        """Analyze all Fortran files in the source directory."""
        fortran_files = []
        
        # Find all Fortran files
        for ext in ['*.f90', '*.f', '*.F90', '*.F']:
            fortran_files.extend(self.source_dir.rglob(ext))
        
        total_files = 0
        total_open_statements = 0
        
        for file_path in fortran_files:
            file_results = self.analyze_file(file_path)
            if file_results:
                total_files += 1
                total_open_statements += len(file_results)
                
                relative_path = file_path.relative_to(self.source_dir)
                self.results.append({
                    'file': str(relative_path),
                    'full_path': str(file_path),
                    'open_statements': file_results
                })
        
        print(f"Analyzed {len(fortran_files)} Fortran files")
        print(f"Found files with open statements: {total_files}")
        print(f"Total open statements with string literals: {total_open_statements}")
        
        return self.results
    
    def generate_report(self, output_file):
        """Generate a detailed report of file read structures."""
        with open(output_file, 'w') as f:
            f.write("# File Read Structure Analysis Report\n\n")
            f.write("This report analyzes the read structure of files opened with string literals in SWAT+ UG.\n\n")
            
            f.write("## Summary\n\n")
            total_files = len(self.results)
            total_opens = sum(len(result['open_statements']) for result in self.results)
            f.write(f"- **Files analyzed with open statements:** {total_files}\n")
            f.write(f"- **Total open statements with string literals:** {total_opens}\n\n")
            
            # Categorize by read types
            header_count = 0
            data_count = 0
            title_skip_count = 0
            
            for file_result in self.results:
                for open_stmt in file_result['open_statements']:
                    for read_info in open_stmt['read_structure']:
                        if read_info['read_type'] == 'header':
                            header_count += 1
                        elif read_info['read_type'] == 'data':
                            data_count += 1
                        elif read_info['read_type'] == 'title_or_skip':
                            title_skip_count += 1
            
            f.write("### Read Operation Types\n")
            f.write(f"- **Header reads:** {header_count}\n")
            f.write(f"- **Data reads:** {data_count}\n")
            f.write(f"- **Title/Skip lines:** {title_skip_count}\n\n")
            
            f.write("## Detailed Analysis\n\n")
            
            for file_result in self.results:
                f.write(f"### File: `{file_result['file']}`\n\n")
                
                for open_stmt in file_result['open_statements']:
                    f.write(f"**Filename:** `{open_stmt['filename']}` (Unit: {open_stmt['file_unit']})\n")
                    f.write(f"**Line {open_stmt['line_num']}:** `{open_stmt['line']}`\n\n")
                    
                    if open_stmt['read_structure']:
                        f.write("**Read Structure:**\n")
                        for i, read_info in enumerate(open_stmt['read_structure'], 1):
                            f.write(f"{i}. **Line {read_info['line_num']}** ({read_info['read_type']}, {read_info['format']}): `{read_info['line']}`\n")
                            if read_info['variables']:
                                f.write(f"   - Variables: {', '.join(read_info['variables'])}\n")
                            if read_info['data_types']:
                                f.write(f"   - Data types: {', '.join(read_info['data_types'])}\n")
                        f.write("\n")
                    else:
                        f.write("**Read Structure:** No read operations found (likely output file)\n\n")
                    
                    f.write("---\n\n")
    
    def generate_summary(self, output_file):
        """Generate a summary of file read patterns."""
        with open(output_file, 'w') as f:
            f.write("File Read Structure Summary\n")
            f.write("==========================\n\n")
            
            # Count different patterns
            input_files = []
            output_files = []
            
            for file_result in self.results:
                for open_stmt in file_result['open_statements']:
                    if open_stmt['read_structure']:
                        # Has read operations - likely input file
                        pattern = {
                            'filename': open_stmt['filename'],
                            'file': file_result['file'],
                            'has_header': any(r['read_type'] == 'header' for r in open_stmt['read_structure']),
                            'has_title_skip': any(r['read_type'] == 'title_or_skip' for r in open_stmt['read_structure']),
                            'data_reads': len([r for r in open_stmt['read_structure'] if r['read_type'] == 'data']),
                            'total_reads': len(open_stmt['read_structure']),
                            'data_types': list(set([dt for r in open_stmt['read_structure'] for dt in r['data_types']]))
                        }
                        input_files.append(pattern)
                    else:
                        # No read operations - likely output file
                        output_files.append({
                            'filename': open_stmt['filename'],
                            'file': file_result['file']
                        })
            
            f.write(f"Input files (with read operations): {len(input_files)}\n")
            f.write(f"Output files (no read operations): {len(output_files)}\n\n")
            
            f.write("Input File Patterns:\n")
            f.write("===================\n")
            
            header_files = [f for f in input_files if f['has_header']]
            title_skip_files = [f for f in input_files if f['has_title_skip']]
            
            f.write(f"Files with header reads: {len(header_files)}\n")
            f.write(f"Files with title/skip lines: {len(title_skip_files)}\n\n")
            
            # Most common data types
            all_data_types = []
            for file_info in input_files:
                all_data_types.extend(file_info['data_types'])
            
            from collections import Counter
            type_counts = Counter(all_data_types)
            
            f.write("Data types found:\n")
            for dtype, count in type_counts.most_common():
                f.write(f"  {dtype}: {count}\n")
            
            f.write(f"\nTop input files by read operations:\n")
            input_files.sort(key=lambda x: x['total_reads'], reverse=True)
            for i, file_info in enumerate(input_files[:10], 1):
                f.write(f"{i:2d}. {file_info['filename']} ({file_info['file']}) - {file_info['total_reads']} reads\n")

def main():
    if len(sys.argv) != 2:
        print("Usage: python analyze_file_read_structure.py <source_directory>")
        sys.exit(1)
    
    source_dir = sys.argv[1]
    
    analyzer = FileReadStructureAnalyzer(source_dir)
    results = analyzer.analyze_directory()
    
    output_dir = Path("fio_analysis")
    output_dir.mkdir(exist_ok=True)
    
    # Generate detailed report
    report_file = output_dir / "file_read_structure_report.md"
    analyzer.generate_report(report_file)
    print(f"Detailed report written to: {report_file}")
    
    # Generate summary
    summary_file = output_dir / "file_read_structure_summary.txt"
    analyzer.generate_summary(summary_file)
    print(f"Summary written to: {summary_file}")

if __name__ == "__main__":
    main()