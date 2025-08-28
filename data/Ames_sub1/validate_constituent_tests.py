#!/usr/bin/env python3

"""
SWAT+ Constituent Fertilizer Test Validation Script

This script validates that the constituent fertilizer test files are properly formatted
and can be used to test the new SWAT+ constituent functionality.
"""

import os
import sys
from pathlib import Path

def validate_file_exists(filepath, description):
    """Check if a file exists and is readable."""
    if not os.path.exists(filepath):
        print(f"❌ MISSING: {description} - {filepath}")
        return False
    elif os.path.getsize(filepath) == 0:
        print(f"⚠️  EMPTY: {description} - {filepath}")
        return False
    else:
        print(f"✅ FOUND: {description} - {filepath}")
        return True

def validate_fertilizer_frt_cs(filepath):
    """Validate the fertilizer.frt_cs file format."""
    print(f"\n🔍 Validating {filepath}...")
    try:
        with open(filepath, 'r') as f:
            lines = f.readlines()
        
        if len(lines) < 3:
            print("❌ File too short")
            return False
            
        # Check header
        header = lines[1].strip()
        expected_cols = ['name', 'seo4', 'seo3', 'boron']
        for col in expected_cols:
            if col not in header:
                print(f"❌ Missing column: {col}")
                return False
        
        # Check data lines
        data_lines = 0
        for i, line in enumerate(lines[2:], start=3):
            if line.strip():
                parts = line.split()
                if len(parts) >= 4:
                    try:
                        # Validate numeric values
                        float(parts[1])  # seo4
                        float(parts[2])  # seo3  
                        float(parts[3])  # boron
                        data_lines += 1
                    except ValueError:
                        print(f"❌ Invalid numeric data on line {i}")
                        return False
        
        print(f"✅ Found {data_lines} valid fertilizer entries")
        return True
        
    except Exception as e:
        print(f"❌ Error reading file: {e}")
        return False

def validate_constituent_table(filepath, expected_constituents):
    """Validate pest.man, path.man, or cs.man file format."""
    print(f"\n🔍 Validating {filepath}...")
    try:
        with open(filepath, 'r') as f:
            content = f.read()
        
        # Check for expected constituent names
        found_constituents = []
        for const in expected_constituents:
            if const in content:
                found_constituents.append(const)
        
        if found_constituents:
            print(f"✅ Found constituents: {', '.join(found_constituents)}")
            return True
        else:
            print(f"❌ No expected constituents found: {expected_constituents}")
            return False
            
    except Exception as e:
        print(f"❌ Error reading file: {e}")
        return False

def validate_cs_ini_file(filepath):
    """Validate cs initialization file format."""
    print(f"\n🔍 Validating {filepath}...")
    try:
        with open(filepath, 'r') as f:
            lines = f.readlines()
        
        if len(lines) < 5:
            print("❌ File too short")
            return False
        
        # Look for data lines (should contain numeric values)
        numeric_lines = 0
        for line in lines[5:]:  # Skip header lines
            if line.strip():
                parts = line.split()
                if len(parts) >= 3:
                    try:
                        for part in parts:
                            float(part)
                        numeric_lines += 1
                    except ValueError:
                        # Not a numeric line, could be a name
                        pass
        
        if numeric_lines > 0:
            print(f"✅ Found {numeric_lines} data lines")
            return True
        else:
            print("❌ No valid numeric data found")
            return False
            
    except Exception as e:
        print(f"❌ Error reading file: {e}")
        return False

def validate_constituents_cs(filepath):
    """Validate the constituents.cs database file format."""
    print(f"\n🔍 Validating {filepath}...")
    try:
        with open(filepath, 'r') as f:
            lines = f.readlines()
        
        if len(lines) < 6:
            print("❌ File too short - should have at least 6 lines")
            return False
        
        # Expected format:
        # Line 1: title
        # Line 2: num_pests
        # Line 3: pest names
        # Line 4: num_paths
        # Line 5: path names
        # Line 6: num_metals
        # Line 7: metal names (if any)
        # Line 8: num_salts
        # Line 9: salt names (if any)
        # Line 10: num_cs
        # Line 11: cs names
        
        line_idx = 1
        
        # Parse pesticides
        try:
            num_pests = int(lines[line_idx].strip())
            print(f"  Pesticides: {num_pests}")
            if num_pests > 0:
                pest_names = lines[line_idx + 1].strip().split()
                if len(pest_names) != num_pests:
                    print(f"❌ Pesticide count mismatch: expected {num_pests}, found {len(pest_names)}")
                    return False
                print(f"    Names: {', '.join(pest_names)}")
                line_idx += 2
            else:
                line_idx += 1
        except (ValueError, IndexError):
            print("❌ Error parsing pesticides section")
            return False
        
        # Parse pathogens
        try:
            num_paths = int(lines[line_idx].strip())
            print(f"  Pathogens: {num_paths}")
            if num_paths > 0:
                path_names = lines[line_idx + 1].strip().split()
                if len(path_names) != num_paths:
                    print(f"❌ Pathogen count mismatch: expected {num_paths}, found {len(path_names)}")
                    return False
                print(f"    Names: {', '.join(path_names)}")
                line_idx += 2
            else:
                line_idx += 1
        except (ValueError, IndexError):
            print("❌ Error parsing pathogens section")
            return False
        
        # Parse metals
        try:
            num_metals = int(lines[line_idx].strip())
            print(f"  Heavy metals: {num_metals}")
            if num_metals > 0:
                metal_names = lines[line_idx + 1].strip().split()
                if len(metal_names) != num_metals:
                    print(f"❌ Metal count mismatch: expected {num_metals}, found {len(metal_names)}")
                    return False
                print(f"    Names: {', '.join(metal_names)}")
                line_idx += 2
            else:
                line_idx += 1
        except (ValueError, IndexError):
            print("❌ Error parsing metals section")
            return False
        
        # Parse salts
        try:
            num_salts = int(lines[line_idx].strip())
            print(f"  Salt ions: {num_salts}")
            if num_salts > 0:
                salt_names = lines[line_idx + 1].strip().split()
                if len(salt_names) != num_salts:
                    print(f"❌ Salt count mismatch: expected {num_salts}, found {len(salt_names)}")
                    return False
                print(f"    Names: {', '.join(salt_names)}")
                line_idx += 2
            else:
                line_idx += 1
        except (ValueError, IndexError):
            print("❌ Error parsing salts section")
            return False
        
        # Parse other constituents
        try:
            num_cs = int(lines[line_idx].strip())
            print(f"  Other constituents: {num_cs}")
            if num_cs > 0:
                cs_names = lines[line_idx + 1].strip().split()
                if len(cs_names) != num_cs:
                    print(f"❌ Constituent count mismatch: expected {num_cs}, found {len(cs_names)}")
                    return False
                print(f"    Names: {', '.join(cs_names)}")
        except (ValueError, IndexError):
            print("❌ Error parsing constituents section")
            return False
        
        print("✅ constituents.cs format is valid")
        return True
        
    except Exception as e:
        print(f"❌ Error reading file: {e}")
        return False

def main():
    """Main validation function."""
    print("🧪 SWAT+ Constituent Fertilizer Test File Validation")
    print("=" * 60)
    
    # Check if we're in the right directory
    if not os.path.exists("fertilizer.frt"):
        print("❌ Please run this script from the Ames_sub1 data directory")
        sys.exit(1)
    
    validation_results = []
    
    # Core test files
    files_to_check = [
        ("fertilizer.frt_cs", "Fertilizer constituent concentrations"),
        ("pest.man", "Pesticide fertilizer table"),
        ("path.man", "Pathogen fertilizer table"), 
        ("cs.man", "Generic constituent fertilizer table"),
        ("cs_hru.ini", "HRU constituent initialization"),
        ("cs_aqu.ini", "Aquifer constituent initialization"),
        ("cs_channel.ini", "Channel constituent initialization"),
        ("constituents.cs", "General constituent database file"),
        ("constituents_man.cs", "Manure constituent database file"),
    ]
    
    print("\n📋 Checking test file existence...")
    for filepath, description in files_to_check:
        validation_results.append(validate_file_exists(filepath, description))
    
    # Detailed format validation
    if os.path.exists("fertilizer.frt_cs"):
        validation_results.append(validate_fertilizer_frt_cs("fertilizer.frt_cs"))
    
    if os.path.exists("pest.man"):
        validation_results.append(validate_constituent_table("pest.man", 
            ["roundup", "aatrex", "dual"]))
    
    if os.path.exists("path.man"):
        validation_results.append(validate_constituent_table("path.man", 
            ["ecoli", "salmonella"]))
    
    if os.path.exists("cs.man"):
        validation_results.append(validate_constituent_table("cs.man", 
            ["seo4", "seo3", "boron"]))
    
    if os.path.exists("cs_hru.ini"):
        validation_results.append(validate_cs_ini_file("cs_hru.ini"))
    
    if os.path.exists("constituents.cs"):
        validation_results.append(validate_constituents_cs("constituents.cs"))
    
    if os.path.exists("constituents_man.cs"):
        validation_results.append(validate_constituents_cs("constituents_man.cs"))
    
    # Summary
    print("\n" + "=" * 60)
    passed = sum(validation_results)
    total = len(validation_results)
    
    if passed == total:
        print(f"🎉 ALL TESTS PASSED ({passed}/{total})")
        print("\n✅ Test files are ready for SWAT+ constituent testing!")
        print("\nNext steps:")
        print("1. Enable constituent simulation in SWAT+")
        print("2. Run SWAT+ with these test files")
        print("3. Check output for constituent balance tracking")
        sys.exit(0)
    else:
        print(f"⚠️  SOME TESTS FAILED ({passed}/{total})")
        print("\n❌ Please fix the issues above before testing")
        sys.exit(1)

if __name__ == "__main__":
    main()