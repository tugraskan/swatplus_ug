#!/usr/bin/env python3
"""
Parameter Extractor for SWAT+ Automation

This module extracts parameter information from FORD-parsed Fortran types
and maps them to SWAT+ input files and database structures.

The extractor identifies parameters, their relationships, and prepares
data for CSV and schema generation.
"""

import re
import logging
from pathlib import Path
from typing import Dict, List, Any, Optional, Tuple
from dataclasses import dataclass

try:
    from .ford_parser import FordParser, FortranType, FortranField
except ImportError:
    from ford_parser import FordParser, FortranType, FortranField


@dataclass
class ParameterMapping:
    """Represents a mapping between a parameter and its file/database locations."""
    unique_id: int
    broad_classification: str
    swat_file: str
    database_table: str
    database_field_name: str
    swat_header_name: str
    text_file_structure: str
    position_in_file: int
    line_in_file: int
    swat_code_type: str
    swat_code_variable_name: str
    description: str
    core: str
    units: str
    data_type: str
    minimum_range: Optional[str] = None
    maximum_range: Optional[str] = None
    default_value: Optional[str] = None
    number_decimal_places: Optional[int] = None
    primary_key: bool = False
    foreign_key: Optional[str] = None
    foreign_table: Optional[str] = None
    foreign_variable: Optional[str] = None
    doc_path: Optional[str] = None
    use_in_db: str = "x"
    parm_doc_name: Optional[str] = None


class ParameterExtractor:
    """Extracts SWAT+ parameters from FORD-parsed Fortran code."""
    
    def __init__(self, ford_parser: FordParser, source_dir: Path):
        """
        Initialize the parameter extractor.
        
        Args:
            ford_parser: Initialized FordParser with loaded data
            source_dir: Path to SWAT+ source directory
        """
        self.ford_parser = ford_parser
        self.source_dir = Path(source_dir)
        self.parameters: List[ParameterMapping] = []
        self.file_mappings: Dict[str, str] = {}
        
        # Configure logging
        logging.basicConfig(level=logging.INFO)
        self.logger = logging.getLogger(__name__)
        
        # Load default file mappings
        self._load_file_mappings()
        
    def _load_file_mappings(self):
        """Load default mappings between file extensions and database tables."""
        self.file_mappings = {
            'plants.plt': 'plant_db',
            'fertilizer.frt': 'fertilizer_db', 
            'tillage.til': 'tillage_db',
            'pesticide.pes': 'pesticide_db',
            'pathogens.pth': 'pathogen_db',
            'metals.mtl': 'metals_db',
            'salt.slt': 'salt_db',
            'urban.urb': 'urban_db',
            'septic.sep': 'septic_db',
            'snow.sno': 'snow_db',
            
            # Configuration files
            'file.cio': 'file_cio',
            'time.sim': 'time_sim',
            'print.prt': 'print_prt',
            'object.prt': 'object_prt',
            'object.cnt': 'object_cnt',
            
            # Data files
            'hru-data.hru': 'hru_data',
            'hru-lte.hru': 'hru_lte_data',
            'channel.cha': 'channel_data',
            'reservoir.res': 'reservoir_data',
            'aquifer.aqu': 'aquifer_data',
            
            # Weather files
            'weather-sta.cli': 'weather_sta',
            'weather-wgn.cli': 'weather_wgn',
            'pcp.cli': 'precipitation_data',
            'tmp.cli': 'temperature_data',
            'slr.cli': 'solar_data',
            'hmd.cli': 'humidity_data',
            'wnd.cli': 'wind_data',
        }
    
    def extract_parameters(self) -> List[ParameterMapping]:
        """
        Extract all parameters from FORD-parsed types.
        
        Returns:
            List of ParameterMapping objects
        """
        self.logger.info("Starting parameter extraction...")
        
        # Get database types from FORD parser
        db_types = self.ford_parser.get_database_types()
        
        parameter_id = 1
        parameters = []
        
        for type_name, type_obj in db_types.items():
            self.logger.info(f"Processing type: {type_name} ({len(type_obj.fields)} fields)")
            
            for field in type_obj.fields:
                param = self._create_parameter_mapping(
                    parameter_id, type_name, type_obj, field
                )
                if param:
                    parameters.append(param)
                    parameter_id += 1
        
        self.parameters = parameters
        self.logger.info(f"Extracted {len(parameters)} parameters")
        return parameters
    
    def _create_parameter_mapping(
        self, 
        param_id: int, 
        type_name: str, 
        type_obj: FortranType, 
        field: FortranField
    ) -> Optional[ParameterMapping]:
        """
        Create a ParameterMapping from a Fortran field.
        
        Args:
            param_id: Unique parameter ID
            type_name: Name of the Fortran type
            type_obj: FortranType object
            field: FortranField object
            
        Returns:
            ParameterMapping object or None if creation failed
        """
        try:
            # Determine broad classification
            broad_classification = self._classify_parameter(type_name, field.name)
            
            # Map to SWAT file
            swat_file = self._map_to_swat_file(type_name)
            
            # Determine database table name
            database_table = self._get_database_table_name(type_name)
            
            # Get file structure information
            text_file_structure, position, line = self._get_file_structure_info(type_name, field.name)
            
            # Determine data type
            data_type = self._map_fortran_to_csv_type(field.data_type)
            
            # Create parameter mapping
            param = ParameterMapping(
                unique_id=param_id,
                broad_classification=broad_classification,
                swat_file=swat_file,
                database_table=database_table,
                database_field_name=field.name,
                swat_header_name=field.name,  # Could be enhanced with better mapping
                text_file_structure=text_file_structure,
                position_in_file=position,
                line_in_file=line,
                swat_code_type=type_obj.module,
                swat_code_variable_name=field.name,
                description=field.description or f"Parameter {field.name} from {type_name}",
                core="core",  # Most SWAT+ parameters are core
                units=field.units or "*",
                data_type=data_type,
                default_value=field.default_value,
                use_in_db="x"
            )
            
            return param
            
        except Exception as e:
            self.logger.warning(f"Error creating parameter mapping for {field.name}: {e}")
            return None
    
    def _classify_parameter(self, type_name: str, field_name: str) -> str:
        """
        Classify a parameter into broad categories.
        
        Args:
            type_name: Name of the Fortran type
            field_name: Name of the field
            
        Returns:
            Broad classification string
        """
        # Classification based on type name patterns
        if 'plant' in type_name.lower():
            return "PLANT"
        elif 'soil' in type_name.lower():
            return "SOIL"
        elif 'water' in type_name.lower() or 'hydro' in type_name.lower():
            return "HYDROLOGY"
        elif 'weather' in type_name.lower() or 'climate' in type_name.lower():
            return "CLIMATE"
        elif 'nutrient' in type_name.lower() or 'nitrogen' in type_name.lower() or 'phosphorus' in type_name.lower():
            return "NUTRIENTS"
        elif 'sediment' in type_name.lower() or 'erosion' in type_name.lower():
            return "SEDIMENT"
        elif 'pesticide' in type_name.lower():
            return "PESTICIDE"
        elif 'pathogen' in type_name.lower():
            return "PATHOGEN"
        elif 'urban' in type_name.lower():
            return "URBAN"
        elif 'channel' in type_name.lower():
            return "CHANNEL"
        elif 'reservoir' in type_name.lower() or 'wetland' in type_name.lower():
            return "WATER_BODY"
        elif 'aquifer' in type_name.lower() or 'groundwater' in type_name.lower():
            return "GROUNDWATER"
        elif 'simulation' in type_name.lower() or 'time' in type_name.lower():
            return "SIMULATION"
        elif 'output' in type_name.lower() or 'print' in type_name.lower():
            return "OUTPUT"
        else:
            return "GENERAL"
    
    def _map_to_swat_file(self, type_name: str) -> str:
        """
        Map a type name to its corresponding SWAT+ input file.
        
        Args:
            type_name: Name of the Fortran type
            
        Returns:
            SWAT+ input file name
        """
        # Direct mappings for known types
        direct_mappings = {
            'plant_db': 'plants.plt',
            'fertilizer_db': 'fertilizer.frt',
            'tillage_db': 'tillage.til',
            'pesticide_db': 'pesticide.pes',
            'pathogen_db': 'pathogens.pth',
            'metals_db': 'metals.mtl',
            'salt_db': 'salt.slt',
            'urban_db': 'urban.urb',
            'septic_db': 'septic.sep',
            'snow_db': 'snow.sno',
            
            'file_cio': 'file.cio',
            'time_sim': 'time.sim',
            'print_prt': 'print.prt',
            'object_prt': 'object.prt',
            'object_cnt': 'object.cnt',
            
            'hru_data': 'hru-data.hru',
            'hru_lte_data': 'hru-lte.hru',
            'channel_data': 'channel.cha',
            'reservoir_data': 'reservoir.res',
            'aquifer_data': 'aquifer.aqu',
        }
        
        if type_name in direct_mappings:
            return direct_mappings[type_name]
        
        # Pattern-based mapping
        if type_name.endswith('_db'):
            base_name = type_name[:-3]  # Remove '_db'
            return f"{base_name}.{self._get_file_extension(base_name)}"
        
        return f"{type_name}.dat"  # Default fallback
    
    def _get_file_extension(self, base_name: str) -> str:
        """Get file extension for a base name."""
        extension_map = {
            'plant': 'plt',
            'fertilizer': 'frt',
            'tillage': 'til',
            'pesticide': 'pes',
            'pathogen': 'pth',
            'metals': 'mtl',
            'salt': 'slt',
            'urban': 'urb',
            'septic': 'sep',
            'snow': 'sno',
            'hru': 'hru',
            'channel': 'cha',
            'reservoir': 'res',
            'aquifer': 'aqu',
            'weather': 'cli',
        }
        
        for key, ext in extension_map.items():
            if key in base_name.lower():
                return ext
                
        return 'dat'  # Default
    
    def _get_database_table_name(self, type_name: str) -> str:
        """
        Get the database table name for a Fortran type.
        
        Args:
            type_name: Name of the Fortran type
            
        Returns:
            Database table name
        """
        # For most cases, the type name is the table name
        return type_name
    
    def _get_file_structure_info(self, type_name: str, field_name: str) -> Tuple[str, int, int]:
        """
        Get file structure information for a parameter.
        
        Args:
            type_name: Name of the Fortran type
            field_name: Name of the field
            
        Returns:
            Tuple of (structure_type, position, line)
        """
        # This is a simplified implementation
        # In practice, this would analyze the actual file reading code
        
        structure_type = "Unique"  # Most parameters are unique
        position = 1  # Default position
        line = 1  # Default line
        
        # Pattern-based determination could be enhanced by analyzing
        # the actual file reading procedures in the source code
        
        return structure_type, position, line
    
    def _map_fortran_to_csv_type(self, fortran_type: str) -> str:
        """
        Map Fortran data type to CSV data type.
        
        Args:
            fortran_type: Fortran data type string
            
        Returns:
            CSV-compatible data type
        """
        type_map = {
            'real': 'numeric',
            'integer': 'integer',
            'character': 'string',
            'logical': 'string',
            'double precision': 'numeric',
        }
        
        # Clean up the type string
        clean_type = fortran_type.lower().strip()
        
        # Handle character with length specification
        if 'character' in clean_type:
            return 'string'
        
        # Map basic types
        for fort_type, csv_type in type_map.items():
            if fort_type in clean_type:
                return csv_type
        
        return 'string'  # Default fallback
    
    def get_parameter_statistics(self) -> Dict[str, Any]:
        """
        Get statistics about extracted parameters.
        
        Returns:
            Dictionary with parameter statistics
        """
        if not self.parameters:
            return {}
        
        stats = {
            'total_parameters': len(self.parameters),
            'by_classification': {},
            'by_data_type': {},
            'by_file': {},
            'with_defaults': 0,
            'with_units': 0,
            'with_descriptions': 0
        }
        
        for param in self.parameters:
            # Count by classification
            if param.broad_classification not in stats['by_classification']:
                stats['by_classification'][param.broad_classification] = 0
            stats['by_classification'][param.broad_classification] += 1
            
            # Count by data type
            if param.data_type not in stats['by_data_type']:
                stats['by_data_type'][param.data_type] = 0
            stats['by_data_type'][param.data_type] += 1
            
            # Count by file
            if param.swat_file not in stats['by_file']:
                stats['by_file'][param.swat_file] = 0
            stats['by_file'][param.swat_file] += 1
            
            # Count attributes
            if param.default_value:
                stats['with_defaults'] += 1
            if param.units and param.units != '*':
                stats['with_units'] += 1
            if param.description:
                stats['with_descriptions'] += 1
        
        return stats
    
    def filter_parameters(self, **filters) -> List[ParameterMapping]:
        """
        Filter parameters by various criteria.
        
        Args:
            **filters: Filter criteria (e.g., broad_classification='PLANT')
            
        Returns:
            Filtered list of parameters
        """
        filtered = []
        
        for param in self.parameters:
            include = True
            
            for attr, value in filters.items():
                if hasattr(param, attr):
                    param_value = getattr(param, attr)
                    if param_value != value:
                        include = False
                        break
            
            if include:
                filtered.append(param)
        
        return filtered


def main():
    """Command-line interface for parameter extractor."""
    import argparse
    import json
    
    parser = argparse.ArgumentParser(description='Extract SWAT+ parameters from FORD output')
    parser.add_argument('ford_path', help='Path to FORD output directory')
    parser.add_argument('source_dir', help='Path to SWAT+ source directory')
    parser.add_argument('--output', '-o', help='Output JSON file for extracted parameters')
    parser.add_argument('--stats', action='store_true', help='Show extraction statistics')
    
    args = parser.parse_args()
    
    # Initialize FORD parser
    ford_parser = FordParser(args.ford_path)
    if not ford_parser.load_ford_data():
        print("Failed to load FORD data")
        return 1
    
    ford_parser.parse_types()
    
    # Initialize parameter extractor
    extractor = ParameterExtractor(ford_parser, args.source_dir)
    
    # Extract parameters
    parameters = extractor.extract_parameters()
    
    if args.stats:
        stats = extractor.get_parameter_statistics()
        print("\nParameter Extraction Statistics:")
        print(f"  Total parameters: {stats['total_parameters']}")
        print(f"  With defaults: {stats['with_defaults']}")
        print(f"  With units: {stats['with_units']}")
        print(f"  With descriptions: {stats['with_descriptions']}")
        
        print(f"\nBy classification:")
        for classification, count in sorted(stats['by_classification'].items()):
            print(f"  {classification}: {count}")
        
        print(f"\nBy data type:")
        for data_type, count in sorted(stats['by_data_type'].items()):
            print(f"  {data_type}: {count}")
    
    if args.output:
        # Export parameters to JSON
        output_data = []
        for param in parameters:
            output_data.append({
                'unique_id': param.unique_id,
                'broad_classification': param.broad_classification,
                'swat_file': param.swat_file,
                'database_table': param.database_table,
                'database_field_name': param.database_field_name,
                'description': param.description,
                'units': param.units,
                'data_type': param.data_type,
                'default_value': param.default_value
            })
        
        with open(args.output, 'w') as f:
            json.dump(output_data, f, indent=2)
        print(f"Exported {len(parameters)} parameters to {args.output}")
    
    return 0


if __name__ == '__main__':
    exit(main())