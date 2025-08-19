#!/usr/bin/env python3
"""
Analyze Fortran files for File I/O operations using string literals instead of variables.
Focus on: open, read, write, inquire, close statements with hardcoded file names.
"""

import os
import re
import sys
from pathlib import Path

class FIOStringAnalyzer:
    def __init__(self, source_dir):
        self.source_dir = Path(source_dir)
        self.results = []
        
        # Patterns for different FIO operations with string literals
        self.fio_patterns = {
            'open': re.compile(r'open\s*\([^)]*file\s*=\s*["\']([^"\']+)["\'][^)]*\)', re.IGNORECASE),
            'inquire': re.compile(r'inquire\s*\([^)]*file\s*=\s*["\']([^"\']+)["\'][^)]*\)', re.IGNORECASE),
            'read_file': re.compile(r'read\s*\([^)]*file\s*=\s*["\']([^"\']+)["\'][^)]*\)', re.IGNORECASE),
            'write_file': re.compile(r'write\s*\([^)]*file\s*=\s*["\']([^"\']+)["\'][^)]*\)', re.IGNORECASE),
            'close_file': re.compile(r'close\s*\([^)]*file\s*=\s*["\']([^"\']+)["\'][^)]*\)', re.IGNORECASE),
        }
        
        # Also look for formatted I/O with hardcoded filenames
        self.additional_patterns = {
            'format_read': re.compile(r'read\s*\(\s*["\']([^"\']+)["\']\s*,[^)]*\)', re.IGNORECASE),
            'format_write': re.compile(r'write\s*\(\s*["\']([^"\']+)["\']\s*,[^)]*\)', re.IGNORECASE),
        }
    
    def analyze_file(self, file_path):
        """Analyze a single Fortran file for FIO operations with string literals."""
        file_results = []
        
        try:
            with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
                lines = f.readlines()
            
            for line_num, line in enumerate(lines, 1):
                line_stripped = line.strip()
                
                # Skip comments and empty lines
                if not line_stripped or line_stripped.startswith('!') or line_stripped.startswith('c') or line_stripped.startswith('C'):
                    continue
                
                # Check all FIO patterns
                for pattern_name, pattern in self.fio_patterns.items():
                    matches = pattern.findall(line)
                    for match in matches:
                        file_results.append({
                            'file': str(file_path.relative_to(self.source_dir)),
                            'line_number': line_num,
                            'line_content': line.strip(),
                            'operation': pattern_name,
                            'string_literal': match,
                            'pattern_type': 'fio_operation'
                        })
                
                # Check additional patterns
                for pattern_name, pattern in self.additional_patterns.items():
                    matches = pattern.findall(line)
                    for match in matches:
                        file_results.append({
                            'file': str(file_path.relative_to(self.source_dir)),
                            'line_number': line_num,
                            'line_content': line.strip(),
                            'operation': pattern_name,
                            'string_literal': match,
                            'pattern_type': 'formatted_io'
                        })
                        
        except Exception as e:
            print(f"Error analyzing {file_path}: {e}")
        
        return file_results
    
    def analyze_directory(self):
        """Analyze all Fortran files in the source directory."""
        fortran_extensions = {'.f90', '.f', '.F90', '.F'}
        
        for file_path in self.source_dir.rglob('*'):
            if file_path.is_file() and file_path.suffix in fortran_extensions:
                file_results = self.analyze_file(file_path)
                self.results.extend(file_results)
        
        return self.results
    
    def generate_report(self, output_file):
        """Generate a comprehensive report of findings."""
        
        # Sort results by file and line number
        self.results.sort(key=lambda x: (x['file'], x['line_number']))
        
        # Generate summary statistics
        total_files = len(set(result['file'] for result in self.results))
        total_occurrences = len(self.results)
        
        # Group by operation type
        by_operation = {}
        for result in self.results:
            op = result['operation']
            if op not in by_operation:
                by_operation[op] = []
            by_operation[op].append(result)
        
        # Group by file
        by_file = {}
        for result in self.results:
            file = result['file']
            if file not in by_file:
                by_file[file] = []
            by_file[file].append(result)
        
        with open(output_file, 'w') as f:
            f.write("# SWAT+ UG File I/O Operations Using String Literals\n\n")
            f.write("## Executive Summary\n\n")
            f.write(f"**Total Files with FIO String Literals:** {total_files}\n")
            f.write(f"**Total FIO String Literal Occurrences:** {total_occurrences}\n\n")
            
            f.write("## Analysis Scope\n\n")
            f.write("This analysis specifically identifies File I/O operations that use hardcoded string literals instead of variables for file names. The focus is on:\n\n")
            f.write("- `open()` statements with file=\"string\"\n")
            f.write("- `inquire()` statements with file=\"string\"\n")
            f.write("- `read()` statements with file=\"string\"\n")
            f.write("- `write()` statements with file=\"string\"\n")
            f.write("- `close()` statements with file=\"string\"\n")
            f.write("- Formatted I/O with hardcoded filenames\n\n")
            
            f.write("## Summary by Operation Type\n\n")
            for op_type, results in sorted(by_operation.items()):
                f.write(f"**{op_type.upper()}:** {len(results)} occurrences\n")
            f.write("\n")
            
            f.write("## Summary by File\n\n")
            for file, results in sorted(by_file.items(), key=lambda x: len(x[1]), reverse=True):
                f.write(f"**{file}:** {len(results)} occurrences\n")
            f.write("\n")
            
            f.write("## Detailed Findings\n\n")
            
            current_file = None
            for result in self.results:
                if result['file'] != current_file:
                    current_file = result['file']
                    f.write(f"### {current_file}\n\n")
                
                f.write(f"**Line {result['line_number']}** ({result['operation']}):\n")
                f.write(f"```fortran\n{result['line_content']}\n```\n")
                f.write(f"String literal: `{result['string_literal']}`\n\n")
            
            f.write("## Recommendations\n\n")
            f.write("1. **Replace hardcoded filenames with variables** - Use configurable filename variables instead of string literals\n")
            f.write("2. **Centralize filename management** - Consider a filename configuration module\n")
            f.write("3. **Use meaningful variable names** - Make file paths configurable through parameters\n")
            f.write("4. **Standardize file I/O patterns** - Establish consistent patterns for file operations\n\n")
            
            f.write("## Example Refactoring\n\n")
            f.write("**Before (using string literal):**\n")
            f.write("```fortran\nopen(unit=10, file=\"output.txt\", status=\"replace\")\n```\n\n")
            f.write("**After (using variable):**\n")
            f.write("```fortran\ncharacter(len=255) :: output_filename\noutput_filename = \"output.txt\"  ! or read from config\nopen(unit=10, file=output_filename, status=\"replace\")\n```\n")

def main():
    if len(sys.argv) != 2:
        print("Usage: python analyze_fio_strings.py <source_directory>")
        sys.exit(1)
    
    source_dir = sys.argv[1]
    if not os.path.exists(source_dir):
        print(f"Error: Directory {source_dir} does not exist")
        sys.exit(1)
    
    analyzer = FIOStringAnalyzer(source_dir)
    results = analyzer.analyze_directory()
    
    print(f"Found {len(results)} FIO operations with string literals in {len(set(r['file'] for r in results))} files")
    
    # Generate report
    output_file = "/tmp/fio_string_literals_report.md"
    analyzer.generate_report(output_file)
    
    print(f"Report generated: {output_file}")
    
    # Also create a summary file
    summary_file = "/tmp/fio_string_literals_summary.txt"
    with open(summary_file, 'w') as f:
        f.write(f"FIO String Literals Analysis Summary\n")
        f.write(f"=====================================\n")
        f.write(f"Total files analyzed: {len(set(r['file'] for r in results))}\n")
        f.write(f"Total FIO string literal occurrences: {len(results)}\n")
        f.write(f"\nBy operation type:\n")
        
        by_operation = {}
        for result in results:
            op = result['operation']
            by_operation[op] = by_operation.get(op, 0) + 1
        
        for op, count in sorted(by_operation.items()):
            f.write(f"  {op}: {count}\n")
            
        f.write(f"\nTop files with most occurrences:\n")
        by_file = {}
        for result in results:
            file = result['file']
            by_file[file] = by_file.get(file, 0) + 1
        
        for file, count in sorted(by_file.items(), key=lambda x: x[1], reverse=True)[:10]:
            f.write(f"  {file}: {count}\n")
    
    print(f"Summary generated: {summary_file}")

if __name__ == "__main__":
    main()