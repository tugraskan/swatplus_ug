#!/usr/bin/env python3
"""
FORD Parser for SWAT+ Automation

This module parses FORD (Fortran Documenter) JSON output to extract
structured information about Fortran types, modules, and procedures.

The parser provides a foundation for automated generation of the
SWAT+ modular spreadsheet and database schemas.
"""

import json
import logging
from pathlib import Path
from typing import Dict, List, Any, Optional
from dataclasses import dataclass


@dataclass
class FortranField:
    """Represents a field in a Fortran derived type."""
    name: str
    data_type: str
    default_value: Optional[str] = None
    description: Optional[str] = None
    units: Optional[str] = None
    module: Optional[str] = None


@dataclass 
class FortranType:
    """Represents a Fortran derived type."""
    name: str
    module: str
    fields: List[FortranField]
    description: Optional[str] = None
    source_file: Optional[str] = None


@dataclass
class FortranModule:
    """Represents a Fortran module."""
    name: str
    types: List[FortranType]
    procedures: List[str]
    source_file: Optional[str] = None


class FordParser:
    """Parser for FORD JSON output."""
    
    def __init__(self, ford_output_path: Path):
        """
        Initialize the FORD parser.
        
        Args:
            ford_output_path: Path to FORD output directory containing search_database.json
        """
        self.ford_path = Path(ford_output_path)
        self.search_db_path = self.ford_path / "search" / "search_database.json"
        self.ford_data: Dict[str, Any] = {}
        self.modules: Dict[str, FortranModule] = {}
        self.types: Dict[str, FortranType] = {}
        
        # Configure logging
        logging.basicConfig(level=logging.INFO)
        self.logger = logging.getLogger(__name__)
        
    def load_ford_data(self) -> bool:
        """
        Load FORD JSON data from search database.
        
        Returns:
            True if data loaded successfully, False otherwise
        """
        try:
            if not self.search_db_path.exists():
                self.logger.error(f"FORD search database not found: {self.search_db_path}")
                return False
                
            with open(self.search_db_path, 'r', encoding='utf-8') as f:
                self.ford_data = json.load(f)
                
            self.logger.info(f"Loaded FORD data from {self.search_db_path}")
            return True
            
        except Exception as e:
            self.logger.error(f"Error loading FORD data: {e}")
            return False
    
    def parse_types(self) -> Dict[str, FortranType]:
        """
        Extract all Fortran derived types from FORD data.
        
        Returns:
            Dictionary mapping type names to FortranType objects
        """
        if not self.ford_data:
            self.logger.warning("No FORD data loaded. Call load_ford_data() first.")
            return {}
            
        types = {}
        
        try:
            # Look for type definitions in FORD data structure
            for item in self.ford_data.get('items', []):
                if item.get('type') == 'type':
                    type_name = item.get('name', '')
                    module_name = item.get('module', '')
                    source_file = item.get('src', '')
                    
                    # Extract fields
                    fields = []
                    for field_data in item.get('variables', []):
                        field = self._parse_field(field_data)
                        if field:
                            fields.append(field)
                    
                    # Create FortranType object
                    fortran_type = FortranType(
                        name=type_name,
                        module=module_name,
                        fields=fields,
                        description=item.get('doc', ''),
                        source_file=source_file
                    )
                    
                    types[type_name] = fortran_type
                    
            self.types = types
            self.logger.info(f"Parsed {len(types)} Fortran types")
            
        except Exception as e:
            self.logger.error(f"Error parsing types: {e}")
            
        return types
    
    def _parse_field(self, field_data: Dict[str, Any]) -> Optional[FortranField]:
        """
        Parse a single field from FORD data.
        
        Args:
            field_data: Field data from FORD JSON
            
        Returns:
            FortranField object or None if parsing failed
        """
        try:
            name = field_data.get('name', '')
            data_type = field_data.get('vartype', '')
            
            # Extract default value
            default_value = field_data.get('initial', None)
            
            # Extract description and units from doc string
            doc = field_data.get('doc', '')
            description, units = self._parse_doc_string(doc)
            
            return FortranField(
                name=name,
                data_type=data_type,
                default_value=default_value,
                description=description,
                units=units,
                module=field_data.get('module', '')
            )
            
        except Exception as e:
            self.logger.warning(f"Error parsing field {field_data.get('name', 'unknown')}: {e}")
            return None
    
    def _parse_doc_string(self, doc: str) -> tuple[Optional[str], Optional[str]]:
        """
        Parse description and units from Fortran comment string.
        
        Fortran comments often follow patterns like:
        "!units      |description"
        "!none       |some description here"
        
        Args:
            doc: Documentation string from FORD
            
        Returns:
            Tuple of (description, units)
        """
        if not doc:
            return None, None
            
        description = None
        units = None
        
        try:
            # Look for pattern: units|description
            if '|' in doc:
                parts = doc.split('|', 1)
                if len(parts) == 2:
                    units_part = parts[0].strip()
                    desc_part = parts[1].strip()
                    
                    # Extract units (remove common prefixes)
                    units = units_part.replace('!', '').strip()
                    if units.lower() in ['none', '']:
                        units = None
                        
                    # Extract description
                    description = desc_part if desc_part else None
            else:
                # No units, just description
                description = doc.replace('!', '').strip()
                
        except Exception as e:
            self.logger.warning(f"Error parsing doc string '{doc}': {e}")
            
        return description, units
    
    def get_database_types(self) -> Dict[str, FortranType]:
        """
        Get types that represent database tables (typically ending with '_db').
        
        Returns:
            Dictionary of database-related types
        """
        if not self.types:
            self.parse_types()
            
        db_types = {}
        for name, type_obj in self.types.items():
            if name.endswith('_db') or name.endswith('_init') or name.endswith('_parms'):
                db_types[name] = type_obj
                
        self.logger.info(f"Found {len(db_types)} database types")
        return db_types
    
    def get_type_by_name(self, type_name: str) -> Optional[FortranType]:
        """
        Get a specific type by name.
        
        Args:
            type_name: Name of the type to retrieve
            
        Returns:
            FortranType object or None if not found
        """
        if not self.types:
            self.parse_types()
            
        return self.types.get(type_name)
    
    def get_types_by_module(self, module_name: str) -> List[FortranType]:
        """
        Get all types defined in a specific module.
        
        Args:
            module_name: Name of the module
            
        Returns:
            List of FortranType objects
        """
        if not self.types:
            self.parse_types()
            
        module_types = []
        for type_obj in self.types.values():
            if type_obj.module == module_name:
                module_types.append(type_obj)
                
        return module_types
    
    def get_field_statistics(self) -> Dict[str, int]:
        """
        Get statistics about parsed fields.
        
        Returns:
            Dictionary with field statistics
        """
        if not self.types:
            self.parse_types()
            
        stats = {
            'total_types': len(self.types),
            'total_fields': 0,
            'fields_with_defaults': 0,
            'fields_with_units': 0,
            'fields_with_descriptions': 0
        }
        
        for type_obj in self.types.values():
            stats['total_fields'] += len(type_obj.fields)
            for field in type_obj.fields:
                if field.default_value:
                    stats['fields_with_defaults'] += 1
                if field.units:
                    stats['fields_with_units'] += 1
                if field.description:
                    stats['fields_with_descriptions'] += 1
                    
        return stats


def main():
    """Command-line interface for FORD parser."""
    import argparse
    
    parser = argparse.ArgumentParser(description='Parse FORD output for SWAT+ automation')
    parser.add_argument('ford_path', help='Path to FORD output directory')
    parser.add_argument('--output', '-o', help='Output JSON file for parsed data')
    parser.add_argument('--stats', action='store_true', help='Show parsing statistics')
    
    args = parser.parse_args()
    
    # Initialize parser
    ford_parser = FordParser(args.ford_path)
    
    # Load and parse data
    if not ford_parser.load_ford_data():
        print("Failed to load FORD data")
        return 1
        
    types = ford_parser.parse_types()
    
    if args.stats:
        stats = ford_parser.get_field_statistics()
        print("\nFORD Parsing Statistics:")
        print(f"  Total types: {stats['total_types']}")
        print(f"  Total fields: {stats['total_fields']}")
        print(f"  Fields with defaults: {stats['fields_with_defaults']}")
        print(f"  Fields with units: {stats['fields_with_units']}")
        print(f"  Fields with descriptions: {stats['fields_with_descriptions']}")
        
        # Show database types
        db_types = ford_parser.get_database_types()
        print(f"\nDatabase types found: {len(db_types)}")
        for name in sorted(db_types.keys()):
            print(f"  {name} ({len(db_types[name].fields)} fields)")
    
    if args.output:
        # Export parsed data to JSON
        output_data = {}
        for name, type_obj in types.items():
            output_data[name] = {
                'module': type_obj.module,
                'source_file': type_obj.source_file,
                'description': type_obj.description,
                'fields': [
                    {
                        'name': f.name,
                        'type': f.data_type,
                        'default': f.default_value,
                        'description': f.description,
                        'units': f.units
                    }
                    for f in type_obj.fields
                ]
            }
            
        with open(args.output, 'w') as f:
            json.dump(output_data, f, indent=2)
        print(f"Exported parsed data to {args.output}")
    
    return 0


if __name__ == '__main__':
    exit(main())