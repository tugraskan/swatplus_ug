#!/usr/bin/env python3
"""
Validator for SWAT+ Automation Output

This module validates generated CSV files and database schemas,
comparing them with reference data and checking for completeness
and accuracy.
"""

import csv
import json
import logging
from pathlib import Path
from typing import Dict, List, Any, Optional, Tuple
from dataclasses import dataclass

try:
    from .parameter_extractor import ParameterMapping
except ImportError:
    from parameter_extractor import ParameterMapping


@dataclass
class ValidationResult:
    """Result of validation operation."""
    valid: bool
    errors: List[str]
    warnings: List[str]
    statistics: Dict[str, Any]


class Validator:
    """Validates automation output against reference data and quality criteria."""
    
    def __init__(self):
        """Initialize the validator."""
        # Configure logging
        logging.basicConfig(level=logging.INFO)
        self.logger = logging.getLogger(__name__)
        
    def validate_csv_completeness(
        self,
        generated_csv: Path,
        source_dir: Path
    ) -> ValidationResult:
        """
        Validate that generated CSV contains all expected parameters.
        
        Args:
            generated_csv: Path to generated CSV file
            source_dir: Path to SWAT+ source directory
            
        Returns:
            ValidationResult with completeness analysis
        """
        result = ValidationResult(
            valid=True,
            errors=[],
            warnings=[],
            statistics={}
        )
        
        try:
            # Load generated CSV
            csv_data = self._load_csv_data(generated_csv)
            
            # Analyze source files for expected parameter count
            expected_params = self._analyze_source_files(source_dir)
            
            # Compare counts
            generated_count = len([row for row in csv_data if row[0].isdigit()])
            result.statistics = {
                'generated_parameters': generated_count,
                'expected_minimum': expected_params['minimum_expected'],
                'fortran_types_found': expected_params['types_found'],
                'completeness_ratio': generated_count / expected_params['minimum_expected'] if expected_params['minimum_expected'] > 0 else 0
            }
            
            # Validation criteria
            if generated_count < expected_params['minimum_expected'] * 0.8:  # Allow 20% variance
                result.errors.append(
                    f"Generated parameter count ({generated_count}) is significantly below "
                    f"expected minimum ({expected_params['minimum_expected']})"
                )
                result.valid = False
            
            if generated_count < 1000:  # SWAT+ should have at least 1000 parameters
                result.warnings.append(
                    f"Parameter count ({generated_count}) seems low for SWAT+ model"
                )
            
        except Exception as e:
            result.errors.append(f"Error validating completeness: {e}")
            result.valid = False
        
        return result
    
    def validate_csv_structure(
        self,
        csv_path: Path,
        required_columns: Optional[List[str]] = None
    ) -> ValidationResult:
        """
        Validate CSV file structure and format.
        
        Args:
            csv_path: Path to CSV file
            required_columns: List of required column names
            
        Returns:
            ValidationResult with structure analysis
        """
        result = ValidationResult(
            valid=True,
            errors=[],
            warnings=[],
            statistics={}
        )
        
        if required_columns is None:
            required_columns = [
                'Unique ID', 'Broad_Classification', 'SWAT_File',
                'database_table', 'DATABASE_FIELD_NAME', 'Description',
                'Units', 'Data_Type'
            ]
        
        try:
            csv_data = self._load_csv_data(csv_path)
            
            if not csv_data:
                result.errors.append("CSV file is empty")
                result.valid = False
                return result
            
            # Check header
            header = csv_data[0]
            missing_columns = [col for col in required_columns if col not in header]
            if missing_columns:
                result.errors.append(f"Missing required columns: {missing_columns}")
                result.valid = False
            
            # Validate data rows
            data_rows = [row for row in csv_data[1:] if row and not row[0].startswith('#')]
            unique_ids = set()
            field_validation = {
                'duplicate_ids': [],
                'invalid_ids': [],
                'missing_required_fields': [],
                'invalid_data_types': []
            }
            
            for i, row in enumerate(data_rows, 2):  # Start from row 2 (after header)
                if len(row) < len(required_columns):
                    result.warnings.append(f"Row {i}: Insufficient columns")
                    continue
                
                # Validate unique ID
                try:
                    unique_id = int(row[0])
                    if unique_id in unique_ids:
                        field_validation['duplicate_ids'].append(unique_id)
                    unique_ids.add(unique_id)
                except (ValueError, IndexError):
                    field_validation['invalid_ids'].append(i)
                
                # Check required fields
                for j, col_name in enumerate(required_columns):
                    if j < len(row) and not row[j].strip():
                        field_validation['missing_required_fields'].append(f"Row {i}, Column {col_name}")
                
                # Validate data types
                if len(row) > 14:  # Data_Type column
                    data_type = row[14].lower()
                    if data_type and data_type not in ['string', 'numeric', 'integer']:
                        field_validation['invalid_data_types'].append(f"Row {i}: {data_type}")
            
            # Report validation issues
            if field_validation['duplicate_ids']:
                result.errors.append(f"Duplicate unique IDs: {field_validation['duplicate_ids'][:5]}")
                result.valid = False
            
            if field_validation['invalid_ids']:
                result.errors.append(f"Invalid unique IDs in rows: {field_validation['invalid_ids'][:5]}")
                result.valid = False
            
            if field_validation['missing_required_fields']:
                result.warnings.append(f"Missing required fields: {len(field_validation['missing_required_fields'])} instances")
            
            # Statistics
            result.statistics = {
                'total_rows': len(data_rows),
                'unique_parameters': len(unique_ids),
                'duplicate_id_count': len(field_validation['duplicate_ids']),
                'missing_field_count': len(field_validation['missing_required_fields']),
                'data_type_issues': len(field_validation['invalid_data_types'])
            }
            
        except Exception as e:
            result.errors.append(f"Error validating CSV structure: {e}")
            result.valid = False
        
        return result
    
    def validate_parameter_coverage(
        self,
        generated_csv: Path,
        source_dir: Path
    ) -> ValidationResult:
        """
        Validate that generated parameters cover all major SWAT+ components.
        
        Args:
            generated_csv: Path to generated CSV file
            source_dir: Path to SWAT+ source directory
            
        Returns:
            ValidationResult with coverage analysis
        """
        result = ValidationResult(
            valid=True,
            errors=[],
            warnings=[],
            statistics={}
        )
        
        try:
            csv_data = self._load_csv_data(generated_csv)
            
            # Expected SWAT+ components
            expected_components = {
                'PLANT': ['plant', 'crop', 'vegetation'],
                'SOIL': ['soil', 'layer'],
                'HYDROLOGY': ['water', 'hydro', 'flow'],
                'CLIMATE': ['weather', 'climate', 'temp', 'precip'],
                'NUTRIENTS': ['nitrogen', 'phosphorus', 'nutrient'],
                'SEDIMENT': ['sediment', 'erosion'],
                'CHANNEL': ['channel', 'stream'],
                'RESERVOIR': ['reservoir', 'pond', 'wetland'],
                'GROUNDWATER': ['aquifer', 'groundwater', 'gw'],
                'URBAN': ['urban', 'city'],
                'MANAGEMENT': ['management', 'tillage', 'fertilizer']
            }
            
            # Analyze parameter coverage
            component_coverage = {}
            parameter_classifications = []
            
            for row in csv_data[1:]:  # Skip header
                if row and len(row) > 1 and not row[0].startswith('#'):
                    if len(row) > 1:
                        classification = row[1]  # Broad_Classification column
                        parameter_classifications.append(classification)
            
            # Check coverage for each component
            for component, keywords in expected_components.items():
                found_params = []
                for classification in parameter_classifications:
                    if any(keyword.lower() in classification.lower() for keyword in keywords):
                        found_params.append(classification)
                
                component_coverage[component] = {
                    'found': len(found_params) > 0,
                    'count': len(found_params),
                    'examples': list(set(found_params))[:3]  # First 3 unique examples
                }
            
            # Validate coverage
            missing_components = [comp for comp, data in component_coverage.items() if not data['found']]
            if missing_components:
                result.warnings.append(f"Missing or low coverage for components: {missing_components}")
            
            # Check for reasonable distribution
            total_params = len(parameter_classifications)
            if total_params > 0:
                largest_component_count = max(data['count'] for data in component_coverage.values())
                if largest_component_count > total_params * 0.5:
                    result.warnings.append("Parameter distribution is heavily skewed towards one component")
            
            result.statistics = {
                'total_parameters': total_params,
                'component_coverage': component_coverage,
                'missing_components': missing_components,
                'coverage_percentage': (len(expected_components) - len(missing_components)) / len(expected_components) * 100
            }
            
        except Exception as e:
            result.errors.append(f"Error validating parameter coverage: {e}")
            result.valid = False
        
        return result
    
    def compare_with_reference(
        self,
        generated_csv: Path,
        reference_csv: Path
    ) -> ValidationResult:
        """
        Compare generated CSV with reference CSV file.
        
        Args:
            generated_csv: Path to generated CSV file
            reference_csv: Path to reference CSV file
            
        Returns:
            ValidationResult with comparison analysis
        """
        result = ValidationResult(
            valid=True,
            errors=[],
            warnings=[],
            statistics={}
        )
        
        try:
            # Load both CSV files
            generated_data = self._load_csv_data(generated_csv)
            reference_data = self._load_csv_data(reference_csv)
            
            # Extract parameter data (skip headers and metadata)
            gen_params = self._extract_parameter_data(generated_data)
            ref_params = self._extract_parameter_data(reference_data)
            
            # Create lookup dictionaries
            gen_lookup = {param['field_name']: param for param in gen_params}
            ref_lookup = {param['field_name']: param for param in ref_params}
            
            # Compare parameters
            gen_fields = set(gen_lookup.keys())
            ref_fields = set(ref_lookup.keys())
            
            new_fields = gen_fields - ref_fields
            missing_fields = ref_fields - gen_fields
            common_fields = gen_fields & ref_fields
            
            # Analyze differences in common fields
            modified_fields = []
            for field_name in common_fields:
                gen_param = gen_lookup[field_name]
                ref_param = ref_lookup[field_name]
                
                # Compare key attributes
                if (gen_param['description'] != ref_param['description'] or
                    gen_param['units'] != ref_param['units'] or
                    gen_param['data_type'] != ref_param['data_type']):
                    modified_fields.append(field_name)
            
            # Validation assessment
            if len(missing_fields) > len(ref_fields) * 0.1:  # More than 10% missing
                result.errors.append(f"High number of missing parameters: {len(missing_fields)}")
                result.valid = False
            
            if len(new_fields) > len(ref_fields) * 0.2:  # More than 20% new
                result.warnings.append(f"Large number of new parameters: {len(new_fields)}")
            
            result.statistics = {
                'generated_count': len(gen_params),
                'reference_count': len(ref_params),
                'new_parameters': len(new_fields),
                'missing_parameters': len(missing_fields),
                'modified_parameters': len(modified_fields),
                'common_parameters': len(common_fields),
                'similarity_ratio': len(common_fields) / max(len(gen_fields), len(ref_fields)),
                'examples': {
                    'new_fields': list(new_fields)[:5],
                    'missing_fields': list(missing_fields)[:5],
                    'modified_fields': list(modified_fields)[:5]
                }
            }
            
        except Exception as e:
            result.errors.append(f"Error comparing with reference: {e}")
            result.valid = False
        
        return result
    
    def _load_csv_data(self, csv_path: Path) -> List[List[str]]:
        """Load CSV data from file."""
        data = []
        with open(csv_path, 'r', encoding='utf-8') as f:
            reader = csv.reader(f)
            for row in reader:
                data.append(row)
        return data
    
    def _extract_parameter_data(self, csv_data: List[List[str]]) -> List[Dict[str, str]]:
        """Extract parameter data from CSV rows."""
        parameters = []
        
        # Find header row
        header_row = None
        for i, row in enumerate(csv_data):
            if row and 'DATABASE_FIELD_NAME' in row:
                header_row = i
                break
        
        if header_row is None:
            return parameters
        
        header = csv_data[header_row]
        
        # Extract data rows
        for row in csv_data[header_row + 1:]:
            if row and not row[0].startswith('#') and len(row) >= len(header):
                param_dict = {}
                for i, value in enumerate(row):
                    if i < len(header):
                        param_dict[header[i].lower().replace(' ', '_')] = value
                
                # Extract key fields
                param = {
                    'field_name': param_dict.get('database_field_name', ''),
                    'description': param_dict.get('description', ''),
                    'units': param_dict.get('units', ''),
                    'data_type': param_dict.get('data_type', ''),
                    'default_value': param_dict.get('default_value', '')
                }
                
                if param['field_name']:
                    parameters.append(param)
        
        return parameters
    
    def _analyze_source_files(self, source_dir: Path) -> Dict[str, int]:
        """Analyze source files to estimate expected parameter count."""
        analysis = {
            'minimum_expected': 1000,  # Conservative estimate for SWAT+
            'types_found': 0
        }
        
        try:
            # Count Fortran type definitions
            type_count = 0
            for fortran_file in source_dir.glob('**/*.f90'):
                try:
                    with open(fortran_file, 'r', encoding='utf-8', errors='ignore') as f:
                        content = f.read()
                        # Simple count of type definitions
                        type_count += content.lower().count('type ::')
                        type_count += content.lower().count('type,')
                except:
                    continue
            
            analysis['types_found'] = type_count
            # Estimate based on typical SWAT+ structure
            analysis['minimum_expected'] = max(type_count * 5, 1000)  # Rough estimate
            
        except Exception:
            pass  # Use defaults
        
        return analysis
    
    def generate_validation_report(
        self,
        validation_results: Dict[str, ValidationResult],
        output_path: Path
    ) -> bool:
        """
        Generate comprehensive validation report.
        
        Args:
            validation_results: Dictionary of validation results
            output_path: Path to output report file
            
        Returns:
            True if report generated successfully, False otherwise
        """
        try:
            report_lines = [
                "SWAT+ Automation Validation Report",
                "=" * 50,
                f"Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}",
                ""
            ]
            
            # Overall summary
            total_tests = len(validation_results)
            passed_tests = sum(1 for result in validation_results.values() if result.valid)
            
            report_lines.extend([
                "Overall Summary:",
                f"  Tests Run: {total_tests}",
                f"  Tests Passed: {passed_tests}",
                f"  Tests Failed: {total_tests - passed_tests}",
                f"  Success Rate: {passed_tests / total_tests * 100:.1f}%",
                ""
            ])
            
            # Detailed results
            for test_name, result in validation_results.items():
                report_lines.extend([
                    f"Test: {test_name}",
                    "-" * (6 + len(test_name)),
                    f"Status: {'PASS' if result.valid else 'FAIL'}",
                    ""
                ])
                
                if result.errors:
                    report_lines.append("Errors:")
                    for error in result.errors:
                        report_lines.append(f"  - {error}")
                    report_lines.append("")
                
                if result.warnings:
                    report_lines.append("Warnings:")
                    for warning in result.warnings:
                        report_lines.append(f"  - {warning}")
                    report_lines.append("")
                
                if result.statistics:
                    report_lines.append("Statistics:")
                    for key, value in result.statistics.items():
                        if isinstance(value, dict):
                            report_lines.append(f"  {key}:")
                            for sub_key, sub_value in value.items():
                                report_lines.append(f"    {sub_key}: {sub_value}")
                        else:
                            report_lines.append(f"  {key}: {value}")
                    report_lines.append("")
                
                report_lines.append("")
            
            # Write report
            with open(output_path, 'w', encoding='utf-8') as f:
                f.write('\n'.join(report_lines))
            
            self.logger.info(f"Generated validation report: {output_path}")
            return True
            
        except Exception as e:
            self.logger.error(f"Error generating validation report: {e}")
            return False


def main():
    """Command-line interface for validator."""
    import argparse
    
    parser = argparse.ArgumentParser(description='Validate SWAT+ automation output')
    parser.add_argument('generated_csv', help='Generated CSV file to validate')
    parser.add_argument('--source-dir', help='SWAT+ source directory for completeness check')
    parser.add_argument('--reference-csv', help='Reference CSV file for comparison')
    parser.add_argument('--report', help='Output validation report file')
    
    args = parser.parse_args()
    
    validator = Validator()
    validation_results = {}
    
    # Run structure validation
    print("Running structure validation...")
    structure_result = validator.validate_csv_structure(Path(args.generated_csv))
    validation_results['Structure'] = structure_result
    print(f"Structure validation: {'PASS' if structure_result.valid else 'FAIL'}")
    
    # Run completeness validation if source directory provided
    if args.source_dir:
        print("Running completeness validation...")
        completeness_result = validator.validate_csv_completeness(
            Path(args.generated_csv), 
            Path(args.source_dir)
        )
        validation_results['Completeness'] = completeness_result
        print(f"Completeness validation: {'PASS' if completeness_result.valid else 'FAIL'}")
    
    # Run coverage validation
    if args.source_dir:
        print("Running coverage validation...")
        coverage_result = validator.validate_parameter_coverage(
            Path(args.generated_csv), 
            Path(args.source_dir)
        )
        validation_results['Coverage'] = coverage_result
        print(f"Coverage validation: {'PASS' if coverage_result.valid else 'FAIL'}")
    
    # Run comparison if reference provided
    if args.reference_csv:
        print("Running reference comparison...")
        comparison_result = validator.compare_with_reference(
            Path(args.generated_csv), 
            Path(args.reference_csv)
        )
        validation_results['Comparison'] = comparison_result
        print(f"Reference comparison: {'PASS' if comparison_result.valid else 'FAIL'}")
    
    # Generate report if requested
    if args.report:
        validator.generate_validation_report(
            validation_results, 
            Path(args.report)
        )
        print(f"Generated validation report: {args.report}")
    
    # Print summary
    total_tests = len(validation_results)
    passed_tests = sum(1 for result in validation_results.values() if result.valid)
    print(f"\nValidation Summary: {passed_tests}/{total_tests} tests passed")
    
    return 0 if passed_tests == total_tests else 1


if __name__ == '__main__':
    exit(main())