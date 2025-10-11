#!/usr/bin/env python3

"""
SWAT+ Commit Analyzer
Analyzes differences between two commits and categorizes changes into:
- NEW_INPUT_FILES: New input files being tested
- NEW_OUTPUT_FILES: New output files being reviewed
- Existing output files: Changes in existing output files
- Existing input files: Changes in existing input files
- Other: Added/removed subroutines and modules

Usage:
    python3 analyze_commits.py <commit1> <commit2>
    python3 analyze_commits.py HEAD~1 HEAD
"""

import sys
import subprocess
import re
from collections import defaultdict


# File extensions typically used for input files in SWAT+
INPUT_EXTENSIONS = {
    '.con', '.cli', '.dat', '.cha', '.res', '.hru', '.rtu', '.dr', '.def', 
    '.ele', '.wet', '.bsn', '.prt', '.cnt', '.cs', '.sim', '.wgn', '.sta',
    '.pet', '.pcp', '.tmp', '.slr', '.hmd', '.wnd', '.sol', '.dtl', '.lum',
    '.sch', '.cal', '.sft', '.ops', '.mgt', '.pst', '.aqu', '.exco', '.rec'
}

# File extensions typically used for output files in SWAT+
OUTPUT_EXTENSIONS = {
    '.txt', '.out'
}

# File extensions for source code
SOURCE_EXTENSIONS = {
    '.f90', '.f', '.F90', '.F'
}


def run_git_command(command):
    """Run a git command and return the output."""
    try:
        result = subprocess.run(
            command,
            shell=True,
            capture_output=True,
            text=True,
            check=True
        )
        return result.stdout.strip()
    except subprocess.CalledProcessError as e:
        print(f"Error running git command: {e}", file=sys.stderr)
        print(f"stderr: {e.stderr}", file=sys.stderr)
        sys.exit(1)


def get_file_extension(filename):
    """Get the file extension from a filename."""
    if '.' in filename:
        return '.' + filename.rsplit('.', 1)[1]
    return ''


def classify_file(filename):
    """Classify a file as input, output, source, or other."""
    ext = get_file_extension(filename)
    
    if ext in INPUT_EXTENSIONS:
        return 'input'
    elif ext in OUTPUT_EXTENSIONS:
        return 'output'
    elif ext in SOURCE_EXTENSIONS:
        return 'source'
    else:
        return 'other'


def get_file_changes(commit1, commit2):
    """Get all file changes between two commits."""
    # Get diff with status for each file
    cmd = f"git diff --name-status {commit1} {commit2}"
    output = run_git_command(cmd)
    
    changes = {
        'added': [],
        'modified': [],
        'deleted': [],
        'renamed': []
    }
    
    for line in output.split('\n'):
        if not line.strip():
            continue
            
        parts = line.split('\t')
        status = parts[0]
        
        if status == 'A':
            changes['added'].append(parts[1])
        elif status == 'M':
            changes['modified'].append(parts[1])
        elif status == 'D':
            changes['deleted'].append(parts[1])
        elif status.startswith('R'):
            # Renamed files: R100 old_name new_name
            changes['renamed'].append((parts[1], parts[2]))
    
    return changes


def analyze_source_changes(commit1, commit2, modified_files, added_files, deleted_files):
    """Analyze source files for subroutine and module changes."""
    subroutines_added = []
    subroutines_removed = []
    modules_added = []
    modules_removed = []
    
    # Check modified source files
    for file in modified_files:
        if classify_file(file) == 'source':
            # Get diff for this file
            cmd = f"git diff {commit1} {commit2} -- {file}"
            try:
                diff_output = run_git_command(cmd)
                
                # Look for added subroutines and modules (lines starting with +)
                for line in diff_output.split('\n'):
                    if line.startswith('+') and not line.startswith('+++'):
                        # Check for subroutine definitions
                        subroutine_match = re.search(r'subroutine\s+(\w+)', line, re.IGNORECASE)
                        if subroutine_match:
                            subroutines_added.append(f"{subroutine_match.group(1)} in {file}")
                        
                        # Check for module definitions
                        module_match = re.search(r'^\s*module\s+(\w+)', line, re.IGNORECASE)
                        if module_match and 'end module' not in line.lower():
                            modules_added.append(f"{module_match.group(1)} in {file}")
                    
                    elif line.startswith('-') and not line.startswith('---'):
                        # Check for removed subroutines and modules
                        subroutine_match = re.search(r'subroutine\s+(\w+)', line, re.IGNORECASE)
                        if subroutine_match:
                            subroutines_removed.append(f"{subroutine_match.group(1)} in {file}")
                        
                        module_match = re.search(r'^\s*module\s+(\w+)', line, re.IGNORECASE)
                        if module_match and 'end module' not in line.lower():
                            modules_removed.append(f"{module_match.group(1)} in {file}")
            except:
                pass
    
    # Check newly added source files
    for file in added_files:
        if classify_file(file) == 'source':
            cmd = f"git show {commit2}:{file}"
            try:
                file_content = run_git_command(cmd)
                for line in file_content.split('\n'):
                    subroutine_match = re.search(r'subroutine\s+(\w+)', line, re.IGNORECASE)
                    if subroutine_match:
                        subroutines_added.append(f"{subroutine_match.group(1)} in {file} (new file)")
                    
                    module_match = re.search(r'^\s*module\s+(\w+)', line, re.IGNORECASE)
                    if module_match and 'end module' not in line.lower():
                        modules_added.append(f"{module_match.group(1)} in {file} (new file)")
            except:
                pass
    
    # Check deleted source files
    for file in deleted_files:
        if classify_file(file) == 'source':
            cmd = f"git show {commit1}:{file}"
            try:
                file_content = run_git_command(cmd)
                for line in file_content.split('\n'):
                    subroutine_match = re.search(r'subroutine\s+(\w+)', line, re.IGNORECASE)
                    if subroutine_match:
                        subroutines_removed.append(f"{subroutine_match.group(1)} in {file} (file deleted)")
                    
                    module_match = re.search(r'^\s*module\s+(\w+)', line, re.IGNORECASE)
                    if module_match and 'end module' not in line.lower():
                        modules_removed.append(f"{module_match.group(1)} in {file} (file deleted)")
            except:
                pass
    
    return {
        'subroutines_added': subroutines_added,
        'subroutines_removed': subroutines_removed,
        'modules_added': modules_added,
        'modules_removed': modules_removed
    }


def main():
    if len(sys.argv) != 3:
        print(__doc__)
        sys.exit(1)
    
    commit1 = sys.argv[1]
    commit2 = sys.argv[2]
    
    print(f"Analyzing changes between {commit1} and {commit2}\n")
    print("=" * 80)
    
    # Get all file changes
    changes = get_file_changes(commit1, commit2)
    
    # Categorize files
    new_input_files = []
    new_output_files = []
    existing_input_changes = []
    existing_output_changes = []
    other_added = []
    other_modified = []
    other_deleted = []
    
    # Process added files
    for file in changes['added']:
        file_type = classify_file(file)
        if file_type == 'input':
            new_input_files.append(file)
        elif file_type == 'output':
            new_output_files.append(file)
        else:
            other_added.append(file)
    
    # Process modified files
    for file in changes['modified']:
        file_type = classify_file(file)
        if file_type == 'input':
            existing_input_changes.append(file)
        elif file_type == 'output':
            existing_output_changes.append(file)
        else:
            other_modified.append(file)
    
    # Process deleted files
    for file in changes['deleted']:
        file_type = classify_file(file)
        if file_type not in ['input', 'output']:
            other_deleted.append(file)
    
    # Analyze source code changes
    source_changes = analyze_source_changes(
        commit1, commit2, 
        changes['modified'], 
        changes['added'], 
        changes['deleted']
    )
    
    # Print results
    print("\nI. NEW_INPUT_FILES")
    print("-" * 80)
    if new_input_files:
        print("Contains a list of new input files that are being tested:")
        for file in sorted(new_input_files):
            print(f"  + {file}")
    else:
        print("  (none)")
    
    print("\n\nII. NEW_OUTPUT_FILES")
    print("-" * 80)
    if new_output_files:
        print("Contains a list of new output files being reviewed:")
        for file in sorted(new_output_files):
            print(f"  + {file}")
    else:
        print("  (none)")
    
    print("\n\nIII. EXISTING OUTPUT FILES")
    print("-" * 80)
    if existing_output_changes:
        print("List of changes in output files:")
        for file in sorted(existing_output_changes):
            print(f"  M {file}")
    else:
        print("  (none)")
    
    print("\n\nIV. EXISTING INPUT FILES")
    print("-" * 80)
    if existing_input_changes:
        print("List of changes in input files:")
        for file in sorted(existing_input_changes):
            print(f"  M {file}")
    else:
        print("  (none)")
    
    print("\n\nV. OTHER CHANGES")
    print("-" * 80)
    
    # Added subroutines
    if source_changes['subroutines_added']:
        print("\nAdded subroutines:")
        for item in source_changes['subroutines_added']:
            print(f"  + {item}")
    
    # Removed subroutines
    if source_changes['subroutines_removed']:
        print("\nRemoved subroutines:")
        for item in source_changes['subroutines_removed']:
            print(f"  - {item}")
    
    # Added modules
    if source_changes['modules_added']:
        print("\nAdded modules:")
        for item in source_changes['modules_added']:
            print(f"  + {item}")
    
    # Removed modules
    if source_changes['modules_removed']:
        print("\nRemoved modules:")
        for item in source_changes['modules_removed']:
            print(f"  - {item}")
    
    # Other added files
    if other_added:
        print("\nOther added files:")
        for file in sorted(other_added):
            print(f"  + {file}")
    
    # Other modified files
    if other_modified:
        print("\nOther modified files:")
        for file in sorted(other_modified):
            print(f"  M {file}")
    
    # Other deleted files
    if other_deleted:
        print("\nOther deleted files:")
        for file in sorted(other_deleted):
            print(f"  - {file}")
    
    # Renamed files
    if changes['renamed']:
        print("\nRenamed files:")
        for old, new in changes['renamed']:
            print(f"  R {old} -> {new}")
    
    if not any([
        source_changes['subroutines_added'],
        source_changes['subroutines_removed'],
        source_changes['modules_added'],
        source_changes['modules_removed'],
        other_added,
        other_modified,
        other_deleted,
        changes['renamed']
    ]):
        print("  (none)")
    
    print("\n" + "=" * 80)


if __name__ == "__main__":
    main()
