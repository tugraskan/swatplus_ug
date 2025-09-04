#!/usr/bin/env python3
"""
Quick test script to verify the automation system works.

This script provides a simple way to test the automation components
without requiring a full FORD documentation build.
"""

import sys
import tempfile
import json
from pathlib import Path

# Add automation src to path
automation_dir = Path(__file__).parent
src_dir = automation_dir / "src"
sys.path.insert(0, str(src_dir))

from ford_parser import FordParser, FortranField, FortranType
from parameter_extractor import ParameterExtractor, ParameterMapping
from csv_generator import CSVGenerator
from schema_generator import SchemaGenerator
from validator import Validator


def create_mock_ford_data():
    """Create mock FORD data for testing."""
    return {
        "items": [
            {
                "type": "type",
                "name": "plant_db",
                "module": "plant_data_module",
                "src": "src/plant_data_module.f90",
                "doc": "Plant database parameters for crop growth simulation",
                "variables": [
                    {
                        "name": "plantnm",
                        "vartype": "character(len=40)",
                        "initial": "''",
                        "doc": "none              |plant name",
                        "module": "plant_data_module"
                    },
                    {
                        "name": "bio_e",
                        "vartype": "real",
                        "initial": "15.0",
                        "doc": "(kg/ha)/(MJ/m**2)|biomass-energy ratio",
                        "module": "plant_data_module"
                    },
                    {
                        "name": "days_mat",
                        "vartype": "integer",
                        "initial": "120",
                        "doc": "days             |days to maturity",
                        "module": "plant_data_module"
                    }
                ]
            },
            {
                "type": "type",
                "name": "soil_db",
                "module": "soil_data_module",
                "src": "src/soil_data_module.f90",
                "doc": "Soil database parameters",
                "variables": [
                    {
                        "name": "texture",
                        "vartype": "character(len=20)",
                        "initial": "'loam'",
                        "doc": "none              |soil texture class",
                        "module": "soil_data_module"
                    },
                    {
                        "name": "bulk_density",
                        "vartype": "real",
                        "initial": "1.3",
                        "doc": "g/cm3            |soil bulk density",
                        "module": "soil_data_module"
                    }
                ]
            }
        ]
    }


def test_ford_parser():
    """Test FORD parser functionality."""
    print("Testing FORD Parser...")
    
    # Create temporary directory structure
    with tempfile.TemporaryDirectory() as temp_dir:
        ford_path = Path(temp_dir)
        search_dir = ford_path / "search"
        search_dir.mkdir(parents=True)
        
        # Create mock FORD data
        search_db_path = search_dir / "search_database.json"
        with open(search_db_path, 'w') as f:
            json.dump(create_mock_ford_data(), f)
        
        # Test parser
        parser = FordParser(ford_path)
        
        # Load data
        if not parser.load_ford_data():
            print("  ❌ Failed to load FORD data")
            return False
        
        # Parse types
        types = parser.parse_types()
        if len(types) != 2:
            print(f"  ❌ Expected 2 types, found {len(types)}")
            return False
        
        # Check database types
        db_types = parser.get_database_types()
        if len(db_types) != 2:
            print(f"  ❌ Expected 2 database types, found {len(db_types)}")
            return False
        
        # Check statistics
        stats = parser.get_field_statistics()
        expected_fields = 5  # 3 from plant_db + 2 from soil_db
        if stats['total_fields'] != expected_fields:
            print(f"  ❌ Expected {expected_fields} fields, found {stats['total_fields']}")
            return False
        
        print("  ✅ FORD Parser tests passed")
        return True


def test_parameter_extractor():
    """Test parameter extractor functionality."""
    print("Testing Parameter Extractor...")
    
    with tempfile.TemporaryDirectory() as temp_dir:
        ford_path = Path(temp_dir)
        source_dir = Path(temp_dir) / "src"
        source_dir.mkdir()
        
        # Setup FORD data
        search_dir = ford_path / "search"
        search_dir.mkdir(parents=True)
        search_db_path = search_dir / "search_database.json"
        with open(search_db_path, 'w') as f:
            json.dump(create_mock_ford_data(), f)
        
        # Create mock source files
        (source_dir / "plant_data_module.f90").touch()
        (source_dir / "soil_data_module.f90").touch()
        
        # Test extractor
        parser = FordParser(ford_path)
        parser.load_ford_data()
        parser.parse_types()
        
        extractor = ParameterExtractor(parser, source_dir)
        parameters = extractor.extract_parameters()
        
        if len(parameters) != 5:  # 3 + 2 fields
            print(f"  ❌ Expected 5 parameters, found {len(parameters)}")
            return False
        
        # Check parameter structure
        first_param = parameters[0]
        if not isinstance(first_param, ParameterMapping):
            print("  ❌ Parameters not properly mapped")
            return False
        
        # Check statistics
        stats = extractor.get_parameter_statistics()
        if stats['total_parameters'] != 5:
            print(f"  ❌ Statistics mismatch: expected 5, got {stats['total_parameters']}")
            return False
        
        print("  ✅ Parameter Extractor tests passed")
        return True


def test_csv_generator():
    """Test CSV generator functionality."""
    print("Testing CSV Generator...")
    
    # Create mock parameters
    parameters = [
        ParameterMapping(
            unique_id=1,
            broad_classification="PLANT",
            swat_file="plants.plt",
            database_table="plant_db",
            database_field_name="plantnm",
            swat_header_name="plantnm",
            text_file_structure="Unique",
            position_in_file=1,
            line_in_file=1,
            swat_code_type="plant_data_module",
            swat_code_variable_name="plantnm",
            description="plant name",
            core="core",
            units="",
            data_type="string",
            use_in_db="x"
        ),
        ParameterMapping(
            unique_id=2,
            broad_classification="PLANT",
            swat_file="plants.plt",
            database_table="plant_db",
            database_field_name="bio_e",
            swat_header_name="bio_e",
            text_file_structure="Unique",
            position_in_file=2,
            line_in_file=1,
            swat_code_type="plant_data_module",
            swat_code_variable_name="bio_e",
            description="biomass-energy ratio",
            core="core",
            units="(kg/ha)/(MJ/m**2)",
            data_type="numeric",
            default_value="15.0",
            use_in_db="x"
        )
    ]
    
    with tempfile.TemporaryDirectory() as temp_dir:
        output_path = Path(temp_dir) / "test_modular.csv"
        
        generator = CSVGenerator()
        
        # Generate CSV
        if not generator.generate_csv(parameters, output_path):
            print("  ❌ Failed to generate CSV")
            return False
        
        # Validate generated CSV
        validation = generator.validate_csv_structure(output_path)
        if not validation['valid']:
            print(f"  ❌ CSV validation failed: {validation['errors']}")
            return False
        
        # Check content
        with open(output_path, 'r') as f:
            lines = f.readlines()
        
        # Should have header + 2 data rows (plus metadata)
        data_lines = [line for line in lines if not line.startswith('#')]
        if len(data_lines) < 3:  # header + 2 rows
            print(f"  ❌ Expected at least 3 data lines, found {len(data_lines)}")
            return False
        
        print("  ✅ CSV Generator tests passed")
        return True


def test_schema_generator():
    """Test schema generator functionality."""
    print("Testing Schema Generator...")
    
    # Create mock parameters
    parameters = [
        ParameterMapping(
            unique_id=1,
            broad_classification="PLANT",
            swat_file="plants.plt",
            database_table="plant_db",
            database_field_name="plantnm",
            swat_header_name="plantnm",
            text_file_structure="Unique",
            position_in_file=1,
            line_in_file=1,
            swat_code_type="plant_data_module",
            swat_code_variable_name="plantnm",
            description="plant name",
            core="core",
            units="",
            data_type="string",
            use_in_db="x"
        )
    ]
    
    with tempfile.TemporaryDirectory() as temp_dir:
        schema_path = Path(temp_dir) / "test_schema.sql"
        
        generator = SchemaGenerator()
        
        # Generate schema
        if not generator.generate_schema(parameters, schema_path):
            print("  ❌ Failed to generate schema")
            return False
        
        # Check content
        with open(schema_path, 'r') as f:
            content = f.read()
        
        # Should contain CREATE TABLE statement
        if "CREATE TABLE plant_db" not in content:
            print("  ❌ Schema does not contain expected table creation")
            return False
        
        print("  ✅ Schema Generator tests passed")
        return True


def test_validator():
    """Test validator functionality."""
    print("Testing Validator...")
    
    # Create a test CSV file
    with tempfile.TemporaryDirectory() as temp_dir:
        csv_path = Path(temp_dir) / "test.csv"
        
        # Write test CSV
        with open(csv_path, 'w') as f:
            f.write("Unique ID,Broad_Classification,SWAT_File,database_table,DATABASE_FIELD_NAME,Description,Units,Data_Type\n")
            f.write("1,PLANT,plants.plt,plant_db,plantnm,plant name,none,string\n")
            f.write("2,PLANT,plants.plt,plant_db,bio_e,biomass energy,(kg/ha),numeric\n")
        
        validator = Validator()
        
        # Test structure validation
        result = validator.validate_csv_structure(csv_path)
        if not result.valid:
            print(f"  ❌ Structure validation failed: {result.errors}")
            return False
        
        print("  ✅ Validator tests passed")
        return True


def main():
    """Run all tests."""
    print("Running SWAT+ Automation Quick Tests")
    print("=" * 40)
    
    tests = [
        test_ford_parser,
        test_parameter_extractor,
        test_csv_generator,
        test_schema_generator,
        test_validator
    ]
    
    passed = 0
    total = len(tests)
    
    for test_func in tests:
        try:
            if test_func():
                passed += 1
            else:
                print(f"  ❌ {test_func.__name__} failed")
        except Exception as e:
            print(f"  ❌ {test_func.__name__} failed with error: {e}")
    
    print("\n" + "=" * 40)
    print(f"Test Results: {passed}/{total} passed")
    
    if passed == total:
        print("🎉 All tests passed! The automation system is working correctly.")
        return 0
    else:
        print("❌ Some tests failed. Check the output above for details.")
        return 1


if __name__ == '__main__':
    exit(main())