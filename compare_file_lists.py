#!/usr/bin/env python3
"""
Compare provided file list with ALL_INPUTS.md

This script compares a user-provided list of files against the comprehensive
ALL_INPUTS.md to identify which files are present, missing, or different.
"""

import re
from pathlib import Path

def parse_provided_list(filepath):
    """Parse the provided list of files"""
    with open(filepath, 'r') as f:
        files = [line.strip().lower() for line in f if line.strip() and line.strip() != 'NEEDS WORK']
    return set(files)

def parse_all_inputs_md(filepath):
    """Extract all filenames from ALL_INPUTS.md"""
    with open(filepath, 'r') as f:
        content = f.read()
    
    # Extract filenames from tables and text
    # Pattern: word.extension format
    pattern = r'\b([a-z_\-0-9]+\.(?:hrd|def|ele|lin|reg|aqu|con|cli|str|cal|sft|key|cha|ops|lum|bsn|cs|del|exc|frt|fld|cio|dtl|hru|hyd|res|wet|ini|sol|pth|pes|plt|prt|rec|dat|rtu|dr|cst|sep|sno|til|sim|wro|wal|mit|mtl|slt|urb))\b'
    
    matches = re.findall(pattern, content, re.IGNORECASE)
    
    # Normalize to lowercase and deduplicate
    files = set(f.lower() for f in matches)
    
    return files

def main():
    """Main entry point"""
    
    provided_file = Path('/tmp/provided_list.txt')
    all_inputs_file = Path(__file__).parent / 'ALL_INPUTS.md'
    
    print("COMPARISON: Provided List vs ALL_INPUTS.md")
    print("=" * 80)
    print()
    
    # Parse both lists
    provided = parse_provided_list(provided_file)
    all_inputs = parse_all_inputs_md(all_inputs_file)
    
    print(f"Files in provided list: {len(provided)}")
    print(f"Files in ALL_INPUTS.md: {len(all_inputs)}")
    print()
    
    # Find differences
    in_provided_not_in_all = provided - all_inputs
    in_all_not_in_provided = all_inputs - provided
    in_both = provided & all_inputs
    
    print("=" * 80)
    print("SECTION 1: FILES IN PROVIDED LIST BUT NOT IN ALL_INPUTS.MD")
    print("=" * 80)
    print()
    print(f"Total: {len(in_provided_not_in_all)} files")
    print()
    
    if in_provided_not_in_all:
        for filename in sorted(in_provided_not_in_all):
            print(f"  ❌ {filename}")
    else:
        print("  (None)")
    
    print()
    print("=" * 80)
    print("SECTION 2: FILES IN ALL_INPUTS.MD BUT NOT IN PROVIDED LIST")
    print("=" * 80)
    print()
    print(f"Total: {len(in_all_not_in_provided)} files")
    print()
    
    if in_all_not_in_provided:
        # Group by category if possible
        sorted_files = sorted(in_all_not_in_provided)
        for filename in sorted_files:
            print(f"  ➕ {filename}")
    else:
        print("  (None)")
    
    print()
    print("=" * 80)
    print("SECTION 3: FILES IN BOTH LISTS (MATCHED)")
    print("=" * 80)
    print()
    print(f"Total: {len(in_both)} files")
    print()
    
    # Show first 20 as examples
    for filename in sorted(in_both)[:20]:
        print(f"  ✓ {filename}")
    
    if len(in_both) > 20:
        print(f"  ... and {len(in_both) - 20} more")
    
    print()
    print("=" * 80)
    print("SUMMARY")
    print("=" * 80)
    print(f"Files in provided list:                 {len(provided):4d}")
    print(f"Files in ALL_INPUTS.md:                 {len(all_inputs):4d}")
    print(f"  ├─ Matched (in both):                 {len(in_both):4d}")
    print(f"  ├─ Only in provided list:             {len(in_provided_not_in_all):4d}")
    print(f"  └─ Only in ALL_INPUTS.md:             {len(in_all_not_in_provided):4d}")
    print()
    print(f"Match rate: {len(in_both)/max(len(provided),1)*100:.1f}% of provided list")
    print(f"Coverage: {len(in_both)/max(len(all_inputs),1)*100:.1f}% of ALL_INPUTS.md")
    print()
    
    # Additional analysis
    print("=" * 80)
    print("ANALYSIS: MISSING FILES BY TYPE")
    print("=" * 80)
    print()
    
    if in_provided_not_in_all:
        # Group by extension
        by_ext = {}
        for f in in_provided_not_in_all:
            ext = f.split('.')[-1] if '.' in f else 'no_ext'
            by_ext.setdefault(ext, []).append(f)
        
        print("Missing files grouped by extension:")
        print()
        for ext in sorted(by_ext.keys()):
            print(f"  .{ext} ({len(by_ext[ext])} files):")
            for f in sorted(by_ext[ext]):
                print(f"    - {f}")
            print()

if __name__ == '__main__':
    main()
