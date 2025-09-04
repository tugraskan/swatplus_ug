#!/usr/bin/env python3
"""
Tests for FORD Parser module.
"""

import unittest
import json
import tempfile
from pathlib import Path

from ford_parser import FordParser, FortranField, FortranType


class TestFordParser(unittest.TestCase):
    """Test cases for FordParser class."""
    
    def setUp(self):
        """Set up test fixtures."""
        self.test_ford_data = {
            "items": [
                {
                    "type": "type",
                    "name": "plant_db",
                    "module": "plant_data_module",
                    "src": "plant_data_module.f90",
                    "doc": "Plant database parameters",
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
                        }
                    ]
                },
                {
                    "type": "procedure",
                    "name": "plant_read",
                    "module": "plant_read_module"
                }
            ]
        }
        
        # Create temporary directory for test files
        self.temp_dir = tempfile.mkdtemp()
        self.ford_path = Path(self.temp_dir)
        
        # Create search directory and database file
        search_dir = self.ford_path / "search"
        search_dir.mkdir(parents=True, exist_ok=True)
        
        self.search_db_path = search_dir / "search_database.json"
        with open(self.search_db_path, 'w') as f:
            json.dump(self.test_ford_data, f)
    
    def tearDown(self):
        """Clean up test fixtures."""
        import shutil
        shutil.rmtree(self.temp_dir)
    
    def test_ford_parser_initialization(self):
        """Test FordParser initialization."""
        parser = FordParser(self.ford_path)
        
        self.assertEqual(parser.ford_path, self.ford_path)
        self.assertEqual(parser.search_db_path, self.search_db_path)
        self.assertEqual(parser.ford_data, {})
        self.assertEqual(parser.modules, {})
        self.assertEqual(parser.types, {})
    
    def test_load_ford_data_success(self):
        """Test successful loading of FORD data."""
        parser = FordParser(self.ford_path)
        result = parser.load_ford_data()
        
        self.assertTrue(result)
        self.assertEqual(parser.ford_data, self.test_ford_data)
    
    def test_load_ford_data_missing_file(self):
        """Test loading FORD data when file is missing."""
        # Create parser with non-existent path
        missing_path = Path(self.temp_dir) / "missing"
        parser = FordParser(missing_path)
        result = parser.load_ford_data()
        
        self.assertFalse(result)
        self.assertEqual(parser.ford_data, {})
    
    def test_parse_types(self):
        """Test parsing of Fortran types."""
        parser = FordParser(self.ford_path)
        parser.load_ford_data()
        types = parser.parse_types()
        
        # Should find one type
        self.assertEqual(len(types), 1)
        self.assertIn("plant_db", types)
        
        # Check type details
        plant_type = types["plant_db"]
        self.assertEqual(plant_type.name, "plant_db")
        self.assertEqual(plant_type.module, "plant_data_module")
        self.assertEqual(plant_type.source_file, "plant_data_module.f90")
        self.assertEqual(plant_type.description, "Plant database parameters")
        
        # Check fields
        self.assertEqual(len(plant_type.fields), 2)
        
        # Check first field (plantnm)
        plantnm_field = plant_type.fields[0]
        self.assertEqual(plantnm_field.name, "plantnm")
        self.assertEqual(plantnm_field.data_type, "character(len=40)")
        self.assertEqual(plantnm_field.default_value, "''")
        self.assertEqual(plantnm_field.description, "plant name")
        self.assertIsNone(plantnm_field.units)
        
        # Check second field (bio_e)
        bio_e_field = plant_type.fields[1]
        self.assertEqual(bio_e_field.name, "bio_e")
        self.assertEqual(bio_e_field.data_type, "real")
        self.assertEqual(bio_e_field.default_value, "15.0")
        self.assertEqual(bio_e_field.description, "biomass-energy ratio")
        self.assertEqual(bio_e_field.units, "(kg/ha)/(MJ/m**2)")
    
    def test_parse_doc_string(self):
        """Test parsing of documentation strings."""
        parser = FordParser(self.ford_path)
        
        # Test with units and description
        description, units = parser._parse_doc_string("(kg/ha)|biomass energy ratio")
        self.assertEqual(description, "biomass energy ratio")
        self.assertEqual(units, "(kg/ha)")
        
        # Test with 'none' units
        description, units = parser._parse_doc_string("none|some description")
        self.assertEqual(description, "some description")
        self.assertIsNone(units)
        
        # Test without units
        description, units = parser._parse_doc_string("just a description")
        self.assertEqual(description, "just a description")
        self.assertIsNone(units)
        
        # Test empty string
        description, units = parser._parse_doc_string("")
        self.assertIsNone(description)
        self.assertIsNone(units)
    
    def test_get_database_types(self):
        """Test filtering for database types."""
        parser = FordParser(self.ford_path)
        parser.load_ford_data()
        parser.parse_types()
        
        db_types = parser.get_database_types()
        
        # Should find plant_db
        self.assertEqual(len(db_types), 1)
        self.assertIn("plant_db", db_types)
    
    def test_get_type_by_name(self):
        """Test retrieving specific type by name."""
        parser = FordParser(self.ford_path)
        parser.load_ford_data()
        parser.parse_types()
        
        # Get existing type
        plant_type = parser.get_type_by_name("plant_db")
        self.assertIsNotNone(plant_type)
        self.assertEqual(plant_type.name, "plant_db")
        
        # Get non-existing type
        missing_type = parser.get_type_by_name("missing_type")
        self.assertIsNone(missing_type)
    
    def test_get_field_statistics(self):
        """Test field statistics calculation."""
        parser = FordParser(self.ford_path)
        parser.load_ford_data()
        parser.parse_types()
        
        stats = parser.get_field_statistics()
        
        expected_stats = {
            'total_types': 1,
            'total_fields': 2,
            'fields_with_defaults': 2,
            'fields_with_units': 1,
            'fields_with_descriptions': 2
        }
        
        self.assertEqual(stats, expected_stats)


class TestFortranDataClasses(unittest.TestCase):
    """Test cases for Fortran data classes."""
    
    def test_fortran_field_creation(self):
        """Test FortranField creation."""
        field = FortranField(
            name="test_field",
            data_type="real",
            default_value="1.0",
            description="Test field",
            units="kg/ha",
            module="test_module"
        )
        
        self.assertEqual(field.name, "test_field")
        self.assertEqual(field.data_type, "real")
        self.assertEqual(field.default_value, "1.0")
        self.assertEqual(field.description, "Test field")
        self.assertEqual(field.units, "kg/ha")
        self.assertEqual(field.module, "test_module")
    
    def test_fortran_type_creation(self):
        """Test FortranType creation."""
        field1 = FortranField(name="field1", data_type="real")
        field2 = FortranField(name="field2", data_type="integer")
        
        fort_type = FortranType(
            name="test_type",
            module="test_module",
            fields=[field1, field2],
            description="Test type",
            source_file="test.f90"
        )
        
        self.assertEqual(fort_type.name, "test_type")
        self.assertEqual(fort_type.module, "test_module")
        self.assertEqual(len(fort_type.fields), 2)
        self.assertEqual(fort_type.description, "Test type")
        self.assertEqual(fort_type.source_file, "test.f90")


if __name__ == '__main__':
    unittest.main()