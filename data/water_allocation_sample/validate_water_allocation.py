#!/usr/bin/env python3
"""
Water Allocation File Validator
Validates the format and structure of SWAT+ water allocation files
"""

import os
import sys

def validate_water_allocation_file(filepath):
    """Validate water allocation file format"""
    errors = []
    warnings = []
    
    try:
        with open(filepath, 'r') as f:
            lines = [line.strip() for line in f.readlines()]
        
        # Check basic structure
        if len(lines) < 5:
            errors.append("File too short - missing required sections")
            return errors, warnings
            
        # Line 1: Title/comment
        if not lines[0]:
            warnings.append("Line 1: No title/comment provided")
            
        # Line 2: Number of water allocation objects
        try:
            num_objects = int(lines[1])
            if num_objects < 1:
                errors.append("Line 2: Number of objects must be >= 1")
        except ValueError:
            errors.append("Line 2: Invalid number format")
            return errors, warnings
            
        current_line = 2
        
        for obj_idx in range(num_objects):
            # Header line
            if current_line >= len(lines):
                errors.append(f"Object {obj_idx+1}: Missing header line")
                break
            current_line += 1
            
            # Object definition line
            if current_line >= len(lines):
                errors.append(f"Object {obj_idx+1}: Missing object definition")
                break
                
            obj_parts = lines[current_line].split()
            if len(obj_parts) < 4:
                errors.append(f"Object {obj_idx+1}: Invalid object definition format")
            else:
                # Validate object name, rule type, source count, demand count
                try:
                    src_count = int(obj_parts[2])
                    dmd_count = int(obj_parts[3])
                except ValueError:
                    errors.append(f"Object {obj_idx+1}: Invalid source/demand counts")
                    
            current_line += 1
            
            # Source objects section
            if current_line < len(lines) and "source" in lines[current_line].lower():
                current_line += 1
                
                for src_idx in range(src_count):
                    if current_line >= len(lines):
                        errors.append(f"Object {obj_idx+1}: Missing source {src_idx+1}")
                        break
                    src_parts = lines[current_line].split()
                    if len(src_parts) < 15:  # src_num, ob_typ, ob_num, 12 monthly limits
                        errors.append(f"Object {obj_idx+1}, Source {src_idx+1}: Invalid format")
                    current_line += 1
                    
            # Demand objects section
            if current_line < len(lines) and "demand" in lines[current_line].lower():
                current_line += 1
                
                for dmd_idx in range(dmd_count):
                    if current_line >= len(lines):
                        errors.append(f"Object {obj_idx+1}: Missing demand {dmd_idx+1}")
                        break
                    dmd_parts = lines[current_line].split()
                    if len(dmd_parts) < 8:  # Basic demand object parameters
                        errors.append(f"Object {obj_idx+1}, Demand {dmd_idx+1}: Invalid format")
                    current_line += 1
        
        # Summary
        print(f"Validation complete for {filepath}")
        print(f"Errors: {len(errors)}")
        print(f"Warnings: {len(warnings)}")
        
        return errors, warnings
        
    except FileNotFoundError:
        errors.append(f"File not found: {filepath}")
        return errors, warnings
    except Exception as e:
        errors.append(f"Unexpected error: {str(e)}")
        return errors, warnings

def validate_supporting_files(directory):
    """Validate supporting water allocation files"""
    required_files = [
        'water_treat.wal',
        'water_use.wal', 
        'water_pipe.wal',
        'water_tower.wal',
        'om_treat.wal',
        'om_use.wal'
    ]
    
    print("\nChecking supporting files:")
    for filename in required_files:
        filepath = os.path.join(directory, filename)
        if os.path.exists(filepath):
            print(f"✓ {filename} - exists")
            # Basic format check
            try:
                with open(filepath, 'r') as f:
                    lines = f.readlines()
                if len(lines) < 3:
                    print(f"  ⚠ {filename} - file seems too short")
                else:
                    print(f"  ✓ {filename} - basic format OK")
            except Exception as e:
                print(f"  ✗ {filename} - error reading: {e}")
        else:
            print(f"✗ {filename} - missing")

def main():
    """Main validation function"""
    if len(sys.argv) > 1:
        directory = sys.argv[1]
    else:
        directory = "."
        
    print(f"Validating water allocation files in: {directory}")
    
    # Find .wro files
    wro_files = [f for f in os.listdir(directory) if f.endswith('.wro')]
    
    if not wro_files:
        print("No .wro files found in directory")
        return
        
    all_errors = []
    all_warnings = []
    
    for wro_file in wro_files:
        print(f"\n--- Validating {wro_file} ---")
        filepath = os.path.join(directory, wro_file)
        errors, warnings = validate_water_allocation_file(filepath)
        
        all_errors.extend(errors)
        all_warnings.extend(warnings)
        
        if errors:
            print("ERRORS:")
            for error in errors:
                print(f"  ✗ {error}")
                
        if warnings:
            print("WARNINGS:")
            for warning in warnings:
                print(f"  ⚠ {warning}")
                
        if not errors and not warnings:
            print("✓ File validation passed")
    
    # Validate supporting files
    validate_supporting_files(directory)
    
    # Summary
    print(f"\n--- SUMMARY ---")
    print(f"Total errors: {len(all_errors)}")
    print(f"Total warnings: {len(all_warnings)}")
    
    if all_errors:
        print("❌ Validation failed - please fix errors")
        return 1
    else:
        print("✅ Validation passed")
        return 0

if __name__ == "__main__":
    sys.exit(main())