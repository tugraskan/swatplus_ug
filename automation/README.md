# SWAT+ Modular Spreadsheet Automation

This directory contains the automation system for generating and maintaining the SWAT+ modular spreadsheet and related database schemas.

## Overview

The SWAT+ modular spreadsheet automation system automates the generation of:

1. **Modular Database CSV** (`Modular Database_5_15_24_nbs.csv`) - 3,330 parameter definitions
2. **Access Database Schema** (`Access_DB_Schema.txt`) - 142 database table definitions
3. **Cross-reference validation** between Fortran source code, input files, and database structures

## Architecture

```
FORD Documentation → Parameter Extraction → Schema Generation → Validation
       ↓                      ↓                    ↓              ↓
   JSON Output         Python Parsers      CSV/SQL Output    Test Suite
```

## Directory Structure

```
automation/
├── README.md                 # This file
├── src/                      # Source code for automation scripts
│   ├── __init__.py
│   ├── ford_parser.py        # FORD JSON output parser
│   ├── parameter_extractor.py # Extract parameters from Fortran source
│   ├── csv_generator.py      # Generate modular CSV file
│   ├── schema_generator.py   # Generate Access DB schema
│   └── validator.py          # Validation and cross-checking
├── tests/                    # Test suite
│   ├── __init__.py
│   ├── test_ford_parser.py
│   ├── test_parameter_extractor.py
│   ├── test_csv_generator.py
│   └── test_validator.py
├── config/                   # Configuration files
│   ├── parameter_config.yml  # Parameter extraction configuration
│   └── schema_config.yml     # Database schema configuration
└── output/                   # Generated output files
    ├── modular_database.csv
    ├── access_schema.sql
    └── validation_report.txt
```

## Usage

### Basic Usage

```bash
# Generate all outputs from FORD documentation
python -m automation.src.main --ford-path build/doc --output-dir automation/output

# Generate only the modular CSV
python -m automation.src.csv_generator --ford-path build/doc --output automation/output/modular_database.csv

# Validate existing CSV against source code
python -m automation.src.validator --csv-path doc/Modular\ Database_5_15_24_nbs.csv --source-dir src/
```

### Integration with Build System

The automation can be integrated with the existing CMake build system:

```bash
# Generate FORD documentation (existing)
ford ford.md

# Run automation (new)
python -m automation.src.main --ford-path build/doc --output-dir automation/output

# Validate results (new)
python -m automation.src.validator --generated automation/output --reference doc/
```

## Key Components

### 1. FORD Parser (`ford_parser.py`)
- Parses FORD JSON output from `search/search_database.json`
- Extracts type definitions, module information, and cross-references
- Provides structured access to Fortran source code metadata

### 2. Parameter Extractor (`parameter_extractor.py`)
- Processes FORD data to identify SWAT+ parameters
- Maps parameters to input files and database tables
- Extracts metadata like units, descriptions, and default values

### 3. CSV Generator (`csv_generator.py`)
- Generates the modular database CSV file
- Maintains compatibility with existing CSV structure
- Includes all 3,330+ parameter definitions with proper metadata

### 4. Schema Generator (`schema_generator.py`)
- Creates Access Database schema from parameter definitions
- Generates SQL DDL statements for 142 database tables
- Ensures type compatibility and referential integrity

### 5. Validator (`validator.py`)
- Compares generated output with existing manual files
- Validates parameter completeness and accuracy
- Generates detailed reports on differences and improvements

## Configuration

### Parameter Configuration (`config/parameter_config.yml`)
```yaml
# Types to include/exclude from parameter extraction
include_types:
  - "*_db"      # Database types
  - "*_parms"   # Parameter types
  - "*_init"    # Initial condition types

exclude_patterns:
  - "temp_*"    # Temporary variables
  - "*_scratch" # Scratch variables

# Default mappings for common patterns
default_mappings:
  file_extensions:
    ".plt": "plant_db"
    ".frt": "fertilizer_db"
    ".til": "tillage_db"
```

### Schema Configuration (`config/schema_config.yml`)
```yaml
# Database schema generation settings
database:
  name: "swatplus_parameters"
  tables:
    max_varchar_length: 255
    default_varchar_length: 40
    use_foreign_keys: true

# Type mappings from Fortran to SQL
type_mappings:
  "character": "VARCHAR"
  "real": "DOUBLE"
  "integer": "INT"
  "logical": "BOOLEAN"
```

## Testing

Run the complete test suite:

```bash
cd automation
python -m pytest tests/ -v
```

Run specific test categories:

```bash
# Test FORD parsing
python -m pytest tests/test_ford_parser.py -v

# Test parameter extraction
python -m pytest tests/test_parameter_extractor.py -v

# Test CSV generation
python -m pytest tests/test_csv_generator.py -v
```

## Integration Points

### With Existing Systems
- **FORD Documentation**: Uses existing FORD integration in `ford.md.in`
- **CMake Build**: Can be integrated into existing CMake workflow
- **CI/CD Pipeline**: Compatible with GitHub Actions in `.github/workflows/`

### With Manual Processes
- **Validates** against existing `Modular Database_5_15_24_nbs.csv`
- **Preserves** existing CSV structure and field ordering
- **Extends** current parameter management with automation

## Benefits

1. **Accuracy**: Eliminates manual transcription errors
2. **Completeness**: Ensures all parameters are captured
3. **Synchronization**: Keeps documentation in sync with source code
4. **Efficiency**: Reduces weeks of manual work to hours of automated processing
5. **Quality**: Provides automated validation and consistency checking

## Future Enhancements

- Real-time parameter change detection
- Integration with parameter sensitivity analysis
- Automated generation of user documentation
- Support for multiple output formats (JSON, XML, etc.)
- Web-based parameter browser and editor