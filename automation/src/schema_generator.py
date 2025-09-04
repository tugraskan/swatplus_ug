#!/usr/bin/env python3
"""
Schema Generator for SWAT+ Access Database

This module generates Access Database schema (SQL DDL) from extracted parameters.
The schema creates normalized database tables matching the parameter structure
defined in the modular spreadsheet.
"""

import logging
from pathlib import Path
from typing import List, Dict, Any, Set
from collections import defaultdict
from datetime import datetime

try:
    from .parameter_extractor import ParameterMapping
except ImportError:
    from parameter_extractor import ParameterMapping


class SchemaGenerator:
    """Generates Access Database schema from extracted parameters."""
    
    # Fortran to SQL type mappings
    TYPE_MAPPINGS = {
        'real': 'DOUBLE',
        'integer': 'INTEGER',
        'character': 'VARCHAR',
        'string': 'VARCHAR',
        'numeric': 'DOUBLE',
        'logical': 'BOOLEAN'
    }
    
    def __init__(self):
        """Initialize the schema generator."""
        # Configure logging
        logging.basicConfig(level=logging.INFO)
        self.logger = logging.getLogger(__name__)
        
    def generate_schema(
        self, 
        parameters: List[ParameterMapping], 
        output_path: Path,
        database_name: str = "swatplus_parameters"
    ) -> bool:
        """
        Generate Access Database schema from parameters.
        
        Args:
            parameters: List of ParameterMapping objects
            output_path: Path to output SQL file
            database_name: Name of the database
            
        Returns:
            True if schema generated successfully, False otherwise
        """
        try:
            self.logger.info(f"Generating database schema for {len(parameters)} parameters...")
            
            # Group parameters by table
            tables = self._group_parameters_by_table(parameters)
            self.logger.info(f"Creating {len(tables)} database tables")
            
            # Generate SQL DDL
            sql_statements = self._generate_sql_ddl(tables, database_name)
            
            # Write to file
            with open(output_path, 'w', encoding='utf-8') as f:
                f.write('\n'.join(sql_statements))
            
            self.logger.info(f"Successfully generated schema: {output_path}")
            return True
            
        except Exception as e:
            self.logger.error(f"Error generating schema: {e}")
            return False
    
    def _group_parameters_by_table(
        self, 
        parameters: List[ParameterMapping]
    ) -> Dict[str, List[ParameterMapping]]:
        """
        Group parameters by their database table.
        
        Args:
            parameters: List of ParameterMapping objects
            
        Returns:
            Dictionary mapping table names to parameter lists
        """
        tables = defaultdict(list)
        
        for param in parameters:
            tables[param.database_table].append(param)
        
        return dict(tables)
    
    def _generate_sql_ddl(
        self, 
        tables: Dict[str, List[ParameterMapping]], 
        database_name: str
    ) -> List[str]:
        """
        Generate SQL DDL statements for all tables.
        
        Args:
            tables: Dictionary mapping table names to parameter lists
            database_name: Name of the database
            
        Returns:
            List of SQL statements
        """
        sql_statements = []
        
        # Add header comment
        timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        sql_statements.extend([
            f"-- SWAT+ Parameter Database Schema",
            f"-- Generated: {timestamp}",
            f"-- Database: {database_name}",
            f"-- Tables: {len(tables)}",
            "",
            f"-- Create database if not exists",
            f"CREATE DATABASE IF NOT EXISTS {database_name};",
            f"USE {database_name};",
            ""
        ])
        
        # Generate table creation statements
        for table_name, table_params in sorted(tables.items()):
            sql_statements.extend(self._generate_table_ddl(table_name, table_params))
            sql_statements.append("")
        
        # Generate foreign key constraints
        foreign_key_statements = self._generate_foreign_key_constraints(tables)
        if foreign_key_statements:
            sql_statements.extend([
                "-- Foreign Key Constraints",
                ""
            ])
            sql_statements.extend(foreign_key_statements)
        
        # Generate indexes
        index_statements = self._generate_indexes(tables)
        if index_statements:
            sql_statements.extend([
                "-- Indexes for Performance",
                ""
            ])
            sql_statements.extend(index_statements)
        
        return sql_statements
    
    def _generate_table_ddl(
        self, 
        table_name: str, 
        parameters: List[ParameterMapping]
    ) -> List[str]:
        """
        Generate DDL for a single table.
        
        Args:
            table_name: Name of the table
            parameters: List of parameters for this table
            
        Returns:
            List of SQL statements for table creation
        """
        statements = []
        
        # Table comment
        statements.append(f"-- Table: {table_name}")
        statements.append(f"-- Parameters: {len(parameters)}")
        
        # Drop table if exists
        statements.append(f"DROP TABLE IF EXISTS {table_name};")
        
        # Create table statement
        statements.append(f"CREATE TABLE {table_name} (")
        
        # Generate column definitions
        column_definitions = []
        primary_keys = []
        
        for param in parameters:
            col_def = self._generate_column_definition(param)
            column_definitions.append(col_def)
            
            if param.primary_key:
                primary_keys.append(param.database_field_name)
        
        # Add ID column if no primary key is defined
        if not primary_keys:
            column_definitions.insert(0, "    id INTEGER PRIMARY KEY AUTOINCREMENT")
        
        statements.extend(column_definitions)
        
        # Add primary key constraint if multiple columns
        if len(primary_keys) > 1:
            pk_constraint = f"    PRIMARY KEY ({', '.join(primary_keys)})"
            statements.append(pk_constraint)
        
        statements.append(");")
        
        # Add table comment (if supported by database)
        param_count = len(parameters)
        statements.append(f"-- {table_name} contains {param_count} parameters")
        
        return statements
    
    def _generate_column_definition(self, param: ParameterMapping) -> str:
        """
        Generate column definition for a parameter.
        
        Args:
            param: ParameterMapping object
            
        Returns:
            SQL column definition string
        """
        # Map data type
        sql_type = self._map_data_type(param.data_type, param.default_value)
        
        # Build column definition
        col_parts = [f"    {param.database_field_name}", sql_type]
        
        # Add constraints
        constraints = []
        
        # Primary key
        if param.primary_key:
            constraints.append("PRIMARY KEY")
        
        # Not null for required fields
        if param.database_field_name in ['name', 'id', 'code']:
            constraints.append("NOT NULL")
        
        # Default value
        if param.default_value:
            default_val = self._format_default_value(param.default_value, param.data_type)
            constraints.append(f"DEFAULT {default_val}")
        
        if constraints:
            col_parts.append(' '.join(constraints))
        
        # Add comment
        if param.description:
            # Note: Comment syntax varies by database
            comment = param.description.replace("'", "''")  # Escape quotes
            col_parts.append(f"-- {comment}")
        
        col_def = ' '.join(col_parts[:2])  # Type and constraints
        if len(col_parts) > 2:
            col_def += f",  {col_parts[2]}"  # Comment
        else:
            col_def += ","
        
        return col_def
    
    def _map_data_type(self, data_type: str, default_value: str = None) -> str:
        """
        Map parameter data type to SQL data type.
        
        Args:
            data_type: Parameter data type
            default_value: Default value (used for type inference)
            
        Returns:
            SQL data type string
        """
        # Clean up data type
        clean_type = data_type.lower().strip()
        
        # Handle character types with length
        if 'character' in clean_type or clean_type == 'string':
            # Try to infer length from default value
            if default_value and isinstance(default_value, str):
                length = max(len(default_value) * 2, 40)  # At least 2x default length
                return f"VARCHAR({min(length, 255)})"
            else:
                return "VARCHAR(255)"  # Default length
        
        # Map other types
        return self.TYPE_MAPPINGS.get(clean_type, 'VARCHAR(255)')
    
    def _format_default_value(self, default_value: str, data_type: str) -> str:
        """
        Format default value for SQL.
        
        Args:
            default_value: Raw default value
            data_type: Parameter data type
            
        Returns:
            Formatted default value for SQL
        """
        if not default_value:
            return "NULL"
        
        clean_type = data_type.lower().strip()
        
        # String types need quotes
        if 'character' in clean_type or clean_type == 'string':
            # Escape quotes in string
            escaped = default_value.replace("'", "''")
            return f"'{escaped}'"
        
        # Numeric types
        if clean_type in ['real', 'numeric', 'integer']:
            try:
                # Validate it's a number
                float(default_value)
                return default_value
            except ValueError:
                return "NULL"
        
        # Boolean types
        if clean_type == 'logical':
            if default_value.lower() in ['true', 't', '1', 'yes']:
                return "TRUE"
            elif default_value.lower() in ['false', 'f', '0', 'no']:
                return "FALSE"
            else:
                return "NULL"
        
        # Default case
        return f"'{default_value}'"
    
    def _generate_foreign_key_constraints(
        self, 
        tables: Dict[str, List[ParameterMapping]]
    ) -> List[str]:
        """
        Generate foreign key constraint statements.
        
        Args:
            tables: Dictionary mapping table names to parameter lists
            
        Returns:
            List of foreign key constraint SQL statements
        """
        constraints = []
        
        for table_name, parameters in tables.items():
            for param in parameters:
                if param.foreign_key and param.foreign_table:
                    constraint_name = f"fk_{table_name}_{param.database_field_name}"
                    foreign_variable = param.foreign_variable or param.foreign_key
                    
                    constraint = (
                        f"ALTER TABLE {table_name} "
                        f"ADD CONSTRAINT {constraint_name} "
                        f"FOREIGN KEY ({param.database_field_name}) "
                        f"REFERENCES {param.foreign_table}({foreign_variable});"
                    )
                    constraints.append(constraint)
        
        return constraints
    
    def _generate_indexes(
        self, 
        tables: Dict[str, List[ParameterMapping]]
    ) -> List[str]:
        """
        Generate index statements for performance.
        
        Args:
            tables: Dictionary mapping table names to parameter lists
            
        Returns:
            List of index creation SQL statements
        """
        indexes = []
        
        # Common field names that should be indexed
        index_fields = {'name', 'code', 'id', 'type', 'category'}
        
        for table_name, parameters in tables.items():
            for param in parameters:
                field_name = param.database_field_name.lower()
                
                # Create index for commonly queried fields
                if any(index_field in field_name for index_field in index_fields):
                    index_name = f"idx_{table_name}_{param.database_field_name}"
                    index_stmt = (
                        f"CREATE INDEX {index_name} "
                        f"ON {table_name}({param.database_field_name});"
                    )
                    indexes.append(index_stmt)
        
        return indexes
    
    def generate_schema_documentation(
        self, 
        parameters: List[ParameterMapping],
        output_path: Path
    ) -> bool:
        """
        Generate human-readable schema documentation.
        
        Args:
            parameters: List of ParameterMapping objects
            output_path: Path to output documentation file
            
        Returns:
            True if documentation generated successfully, False otherwise
        """
        try:
            tables = self._group_parameters_by_table(parameters)
            
            doc_lines = [
                "SWAT+ Database Schema Documentation",
                "=" * 50,
                f"Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}",
                f"Total Tables: {len(tables)}",
                f"Total Parameters: {len(parameters)}",
                "",
                "Table Overview:",
                "-" * 20
            ]
            
            # Table summary
            for table_name, table_params in sorted(tables.items()):
                param_count = len(table_params)
                doc_lines.append(f"  {table_name:30} : {param_count:4d} parameters")
            
            doc_lines.extend(["", "Detailed Table Definitions:", "=" * 30])
            
            # Detailed table documentation
            for table_name, table_params in sorted(tables.items()):
                doc_lines.extend([
                    "",
                    f"Table: {table_name}",
                    "-" * (7 + len(table_name)),
                    f"Parameters: {len(table_params)}",
                    ""
                ])
                
                # Column documentation
                doc_lines.append("Columns:")
                for param in table_params:
                    data_type = self._map_data_type(param.data_type, param.default_value)
                    default_val = param.default_value or "NULL"
                    units = param.units if param.units and param.units != "*" else "none"
                    
                    doc_lines.append(
                        f"  {param.database_field_name:25} {data_type:15} "
                        f"Default: {default_val:10} Units: {units:10}"
                    )
                    if param.description:
                        doc_lines.append(f"    Description: {param.description}")
                
                # Relationships
                foreign_keys = [p for p in table_params if p.foreign_key]
                if foreign_keys:
                    doc_lines.extend(["", "Foreign Keys:"])
                    for fk in foreign_keys:
                        doc_lines.append(
                            f"  {fk.database_field_name} -> {fk.foreign_table}.{fk.foreign_variable}"
                        )
            
            # Write documentation
            with open(output_path, 'w', encoding='utf-8') as f:
                f.write('\n'.join(doc_lines))
            
            self.logger.info(f"Generated schema documentation: {output_path}")
            return True
            
        except Exception as e:
            self.logger.error(f"Error generating schema documentation: {e}")
            return False


def main():
    """Command-line interface for schema generator."""
    import argparse
    import json
    
    parser = argparse.ArgumentParser(description='Generate SWAT+ database schema')
    parser.add_argument('parameters_json', help='JSON file with extracted parameters')
    parser.add_argument('output_sql', help='Output SQL schema file')
    parser.add_argument('--database-name', default='swatplus_parameters', 
                       help='Database name (default: swatplus_parameters)')
    parser.add_argument('--documentation', help='Generate schema documentation file')
    
    args = parser.parse_args()
    
    # Load parameters from JSON
    try:
        with open(args.parameters_json, 'r') as f:
            param_data = json.load(f)
        
        # Convert JSON data to ParameterMapping objects  
        parameters = []
        for item in param_data:
            param = ParameterMapping(
                unique_id=item['unique_id'],
                broad_classification=item['broad_classification'],
                swat_file=item['swat_file'],
                database_table=item['database_table'],
                database_field_name=item['database_field_name'],
                swat_header_name=item['database_field_name'],
                text_file_structure="Unique",
                position_in_file=1,
                line_in_file=1,
                swat_code_type="extracted",
                swat_code_variable_name=item['database_field_name'],
                description=item['description'],
                core="core",
                units=item['units'],
                data_type=item['data_type'],
                default_value=item.get('default_value'),
                use_in_db="x"
            )
            parameters.append(param)
            
    except Exception as e:
        print(f"Error loading parameters: {e}")
        return 1
    
    # Initialize schema generator
    generator = SchemaGenerator()
    
    # Generate schema
    success = generator.generate_schema(
        parameters,
        Path(args.output_sql),
        args.database_name
    )
    
    if not success:
        print("Failed to generate schema")
        return 1
    
    print(f"Generated database schema: {args.output_sql}")
    
    # Generate documentation if requested
    if args.documentation:
        doc_success = generator.generate_schema_documentation(
            parameters,
            Path(args.documentation)
        )
        if doc_success:
            print(f"Generated schema documentation: {args.documentation}")
        else:
            print("Failed to generate schema documentation")
    
    return 0


if __name__ == '__main__':
    exit(main())