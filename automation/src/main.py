#!/usr/bin/env python3
"""
Main automation script for SWAT+ modular spreadsheet generation.

This script orchestrates the complete automation pipeline:
1. Parse FORD documentation
2. Extract parameters from Fortran code
3. Generate modular database CSV
4. Generate Access database schema
5. Validate and compare results

Usage:
    python -m automation.src.main --ford-path build/doc --output-dir automation/output
"""

import argparse
import logging
import sys
from pathlib import Path
from typing import Optional

try:
    from .ford_parser import FordParser
    from .parameter_extractor import ParameterExtractor
    from .csv_generator import CSVGenerator
    from .schema_generator import SchemaGenerator
    from .validator import Validator
except ImportError:
    from ford_parser import FordParser
    from parameter_extractor import ParameterExtractor
    from csv_generator import CSVGenerator
    from schema_generator import SchemaGenerator
    from validator import Validator


def setup_logging(log_level: str = 'INFO', log_file: Optional[Path] = None):
    """Set up logging configuration."""
    level = getattr(logging, log_level.upper(), logging.INFO)
    
    handlers = [logging.StreamHandler(sys.stdout)]
    if log_file:
        handlers.append(logging.FileHandler(log_file))
    
    logging.basicConfig(
        level=level,
        format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
        handlers=handlers
    )


def run_automation_pipeline(
    ford_path: Path,
    source_dir: Path,
    output_dir: Path,
    reference_csv: Optional[Path] = None,
    generate_schema: bool = True,
    validate_output: bool = True
) -> bool:
    """
    Run the complete automation pipeline.
    
    Args:
        ford_path: Path to FORD output directory
        source_dir: Path to SWAT+ source directory
        output_dir: Path to output directory
        reference_csv: Optional path to reference CSV for comparison
        generate_schema: Whether to generate database schema
        validate_output: Whether to validate generated output
        
    Returns:
        True if pipeline completed successfully, False otherwise
    """
    logger = logging.getLogger(__name__)
    logger.info("Starting SWAT+ modular spreadsheet automation pipeline")
    
    try:
        # Ensure output directory exists
        output_dir.mkdir(parents=True, exist_ok=True)
        
        # Step 1: Parse FORD documentation
        logger.info("Step 1: Parsing FORD documentation...")
        ford_parser = FordParser(ford_path)
        
        if not ford_parser.load_ford_data():
            logger.error("Failed to load FORD data")
            return False
        
        types = ford_parser.parse_types()
        logger.info(f"Parsed {len(types)} Fortran types")
        
        # Step 2: Extract parameters
        logger.info("Step 2: Extracting parameters...")
        extractor = ParameterExtractor(ford_parser, source_dir)
        parameters = extractor.extract_parameters()
        logger.info(f"Extracted {len(parameters)} parameters")
        
        # Save extracted parameters as JSON for debugging
        import json
        param_json_path = output_dir / "extracted_parameters.json"
        with open(param_json_path, 'w') as f:
            json.dump([
                {
                    'unique_id': p.unique_id,
                    'broad_classification': p.broad_classification,
                    'swat_file': p.swat_file,
                    'database_table': p.database_table,
                    'database_field_name': p.database_field_name,
                    'description': p.description,
                    'units': p.units,
                    'data_type': p.data_type,
                    'default_value': p.default_value
                }
                for p in parameters
            ], f, indent=2)
        logger.info(f"Saved extracted parameters to {param_json_path}")
        
        # Step 3: Generate modular database CSV
        logger.info("Step 3: Generating modular database CSV...")
        csv_generator = CSVGenerator()
        csv_path = output_dir / "modular_database.csv"
        
        if not csv_generator.generate_csv(parameters, csv_path):
            logger.error("Failed to generate CSV")
            return False
        
        logger.info(f"Generated modular database CSV: {csv_path}")
        
        # Step 4: Generate database schema (if requested)
        if generate_schema:
            logger.info("Step 4: Generating database schema...")
            schema_generator = SchemaGenerator()
            schema_path = output_dir / "access_schema.sql"
            
            if not schema_generator.generate_schema(parameters, schema_path):
                logger.error("Failed to generate database schema")
                return False
            
            logger.info(f"Generated database schema: {schema_path}")
        
        # Step 5: Validation and comparison (if requested)
        if validate_output:
            logger.info("Step 5: Validating output...")
            validator = Validator()
            
            # Validate CSV structure
            validation_result = csv_generator.validate_csv_structure(csv_path)
            if validation_result['valid']:
                logger.info("CSV validation passed")
            else:
                logger.warning(f"CSV validation issues: {validation_result['errors']}")
            
            # Compare with reference CSV if provided
            if reference_csv and reference_csv.exists():
                comparison = csv_generator.compare_with_reference(csv_path, reference_csv)
                logger.info(f"Comparison with reference CSV:")
                logger.info(f"  Generated: {comparison['summary']['generated_count']} parameters")
                logger.info(f"  Reference: {comparison['summary']['reference_count']} parameters")
                logger.info(f"  New: {comparison['summary']['new_count']}")
                logger.info(f"  Missing: {comparison['summary']['missing_count']}")
                logger.info(f"  Modified: {comparison['summary']['modified_count']}")
                
                # Save comparison report
                comparison_path = output_dir / "comparison_report.json"
                with open(comparison_path, 'w') as f:
                    json.dump(comparison, f, indent=2)
                logger.info(f"Saved comparison report to {comparison_path}")
        
        # Generate summary report
        report = csv_generator.generate_summary_report(parameters)
        report_path = output_dir / "summary_report.txt"
        with open(report_path, 'w') as f:
            f.write(report)
        logger.info(f"Generated summary report: {report_path}")
        
        logger.info("Automation pipeline completed successfully!")
        return True
        
    except Exception as e:
        logger.error(f"Pipeline failed with error: {e}")
        return False


def main():
    """Main entry point for the automation script."""
    parser = argparse.ArgumentParser(
        description='SWAT+ Modular Spreadsheet Automation Pipeline',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Basic usage
  python -m automation.src.main --ford-path build/doc --source-dir src --output-dir automation/output
  
  # With reference comparison
  python -m automation.src.main --ford-path build/doc --source-dir src --output-dir automation/output \\
                                 --reference-csv "doc/Modular Database_5_15_24_nbs.csv"
  
  # Skip schema generation
  python -m automation.src.main --ford-path build/doc --source-dir src --output-dir automation/output \\
                                 --no-schema
        """
    )
    
    # Required arguments
    parser.add_argument(
        '--ford-path',
        type=Path,
        required=True,
        help='Path to FORD output directory containing search_database.json'
    )
    
    parser.add_argument(
        '--source-dir',
        type=Path,
        required=True,
        help='Path to SWAT+ source directory (src/)'
    )
    
    parser.add_argument(
        '--output-dir',
        type=Path,
        required=True,
        help='Path to output directory for generated files'
    )
    
    # Optional arguments
    parser.add_argument(
        '--reference-csv',
        type=Path,
        help='Path to reference CSV file for comparison'
    )
    
    parser.add_argument(
        '--no-schema',
        action='store_true',
        help='Skip database schema generation'
    )
    
    parser.add_argument(
        '--no-validation',
        action='store_true',
        help='Skip output validation'
    )
    
    parser.add_argument(
        '--log-level',
        choices=['DEBUG', 'INFO', 'WARNING', 'ERROR'],
        default='INFO',
        help='Logging level (default: INFO)'
    )
    
    parser.add_argument(
        '--log-file',
        type=Path,
        help='Log file path (logs to stdout if not specified)'
    )
    
    args = parser.parse_args()
    
    # Set up logging
    setup_logging(args.log_level, args.log_file)
    
    # Validate input paths
    if not args.ford_path.exists():
        print(f"Error: FORD path does not exist: {args.ford_path}")
        return 1
    
    if not args.source_dir.exists():
        print(f"Error: Source directory does not exist: {args.source_dir}")
        return 1
    
    if args.reference_csv and not args.reference_csv.exists():
        print(f"Error: Reference CSV does not exist: {args.reference_csv}")
        return 1
    
    # Run the automation pipeline
    success = run_automation_pipeline(
        ford_path=args.ford_path,
        source_dir=args.source_dir,
        output_dir=args.output_dir,
        reference_csv=args.reference_csv,
        generate_schema=not args.no_schema,
        validate_output=not args.no_validation
    )
    
    return 0 if success else 1


if __name__ == '__main__':
    exit(main())