# Integration Guide: SWAT+ Modular Spreadsheet Automation

This guide shows how to integrate the automation system with the existing SWAT+ build and documentation workflow.

## Quick Start

### 1. Prerequisites
- Python 3.7+ installed
- FORD documentation system (already integrated in SWAT+)
- PyYAML package: `pip install PyYAML`

### 2. Basic Usage
```bash
# Build FORD documentation (existing step)
cd build
cmake ..
ford ../ford.md

# Run automation to generate modular spreadsheet
cd ..
python -m automation.src.main \
    --ford-path build/doc \
    --source-dir src \
    --output-dir automation/output
```

### 3. Compare with Existing CSV
```bash
python -m automation.src.main \
    --ford-path build/doc \
    --source-dir src \
    --output-dir automation/output \
    --reference-csv "doc/Modular Database_5_15_24_nbs.csv"
```

## CMake Integration

### Option 1: Add to Existing Documentation Target

Add to `CMakeLists.txt`:

```cmake
# Find Python interpreter
find_package(Python3 COMPONENTS Interpreter REQUIRED)

# Custom target for modular spreadsheet generation
add_custom_target(modular_spreadsheet
    COMMAND ${Python3_EXECUTABLE} -m automation.src.main
            --ford-path ${CMAKE_BINARY_DIR}/doc
            --source-dir ${CMAKE_SOURCE_DIR}/src
            --output-dir ${CMAKE_BINARY_DIR}/automation_output
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    DEPENDS ford_documentation
    COMMENT "Generating SWAT+ modular spreadsheet from FORD documentation"
)

# Optional: Add to main documentation target
add_dependencies(documentation modular_spreadsheet)
```

### Option 2: Standalone Target

```cmake
# Modular spreadsheet automation target
add_custom_target(generate_modular_db
    COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_BINARY_DIR}/automation_output
    COMMAND ${Python3_EXECUTABLE} -m automation.src.main
            --ford-path ${CMAKE_BINARY_DIR}/doc
            --source-dir ${CMAKE_SOURCE_DIR}/src
            --output-dir ${CMAKE_BINARY_DIR}/automation_output
            --reference-csv "${CMAKE_SOURCE_DIR}/doc/Modular Database_5_15_24_nbs.csv"
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    DEPENDS ford_documentation
    COMMENT "Generating and validating SWAT+ modular database"
)
```

## GitHub Actions Integration

Add to `.github/workflows/documentation.yml`:

```yaml
name: Documentation and Database Generation

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  generate-docs-and-database:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Python
      uses: actions/setup-python@v4
      with:
        python-version: '3.9'
        
    - name: Install Python dependencies
      run: |
        pip install PyYAML
    
    - name: Setup Fortran
      uses: fortran-lang/setup-fortran@v1
      with:
        compiler: gfortran
        version: 11
    
    - name: Install FORD
      run: pip install ford
    
    - name: Configure and build
      run: |
        cmake -B build
        
    - name: Generate FORD documentation
      run: |
        cd build
        ford ../ford.md
        
    - name: Generate modular database
      run: |
        python -m automation.src.main \
          --ford-path build/doc \
          --source-dir src \
          --output-dir automation/output \
          --reference-csv "doc/Modular Database_5_15_24_nbs.csv"
    
    - name: Upload automation artifacts
      uses: actions/upload-artifact@v3
      with:
        name: swat-automation-output
        path: automation/output/
        
    - name: Deploy documentation
      if: github.ref == 'refs/heads/main'
      uses: peaceiris/actions-gh-pages@v3
      with:
        github_token: ${{ secrets.GITHUB_TOKEN }}
        publish_dir: build/doc
```

## Development Workflow Integration

### Pre-commit Hook (Optional)

Create `.git/hooks/pre-commit`:

```bash
#!/bin/bash

# Check if automation tests pass before commit
echo "Running SWAT+ automation tests..."

cd "$(git rev-parse --show-toplevel)"

if [ -f "automation/test_automation.py" ]; then
    python automation/test_automation.py
    if [ $? -ne 0 ]; then
        echo "❌ Automation tests failed. Commit aborted."
        exit 1
    fi
    echo "✅ Automation tests passed."
fi

exit 0
```

Make executable: `chmod +x .git/hooks/pre-commit`

### Makefile Integration

Add to project `Makefile`:

```makefile
.PHONY: modular-db modular-db-validate modular-db-test

# Generate modular database
modular-db: ford-docs
	python -m automation.src.main \
		--ford-path build/doc \
		--source-dir src \
		--output-dir automation/output

# Generate and validate against reference
modular-db-validate: ford-docs
	python -m automation.src.main \
		--ford-path build/doc \
		--source-dir src \
		--output-dir automation/output \
		--reference-csv "doc/Modular Database_5_15_24_nbs.csv"

# Test automation system
modular-db-test:
	cd automation && python test_automation.py

# Demo automation system
modular-db-demo:
	cd automation && python demo.py
```

## Configuration Management

### Environment-Specific Configuration

Create `automation/config/production.yml`:

```yaml
# Production configuration
output:
  csv:
    include_bom: false
    encoding: "utf-8"
  metadata:
    include_comments: true
    include_statistics: true

validation:
  quality_checks:
    min_parameters_per_type: 1
    require_units_for_numeric: true
    description_min_length: 10

# Stricter validation for production
parameter_validation:
  require_all_fields: true
  validate_units: true
  check_ranges: true
```

Use with: `--config automation/config/production.yml`

### User-Specific Overrides

Create `automation/config/local.yml` (git-ignored):

```yaml
# Local development overrides
validation:
  quality_checks:
    min_parameters_per_type: 0  # Relaxed for development
    require_units_for_numeric: false

output:
  metadata:
    include_statistics: false  # Faster generation
```

## Monitoring and Alerts

### Parameter Change Detection

Create script `automation/scripts/check_parameter_changes.py`:

```python
#!/usr/bin/env python3
"""
Check for parameter changes between versions.
"""

import sys
from pathlib import Path

# Add automation to path
sys.path.insert(0, str(Path(__file__).parent.parent / "src"))

from csv_generator import CSVGenerator

def check_changes(new_csv, old_csv):
    generator = CSVGenerator()
    comparison = generator.compare_with_reference(new_csv, old_csv)
    
    # Alert on significant changes
    if comparison['summary']['missing_count'] > 10:
        print(f"⚠️  WARNING: {comparison['summary']['missing_count']} parameters removed")
        return False
    
    if comparison['summary']['new_count'] > 50:
        print(f"⚠️  WARNING: {comparison['summary']['new_count']} new parameters added")
    
    print(f"✅ Parameter changes acceptable")
    return True

if __name__ == '__main__':
    success = check_changes(sys.argv[1], sys.argv[2])
    sys.exit(0 if success else 1)
```

## Troubleshooting

### Common Issues

1. **FORD data not found**
   ```
   Error: FORD path does not exist
   Solution: Ensure FORD documentation has been built first
   ```

2. **Python import errors**
   ```
   ImportError: No module named 'automation.src'
   Solution: Run from project root directory, not automation/
   ```

3. **Missing PyYAML**
   ```
   ModuleNotFoundError: No module named 'yaml'
   Solution: pip install PyYAML
   ```

### Debug Mode

Run with debug logging:

```bash
python -m automation.src.main \
    --ford-path build/doc \
    --source-dir src \
    --output-dir automation/output \
    --log-level DEBUG
```

### Validation Issues

Check validation report:

```bash
python -m automation.src.validator \
    automation/output/modular_database.csv \
    --source-dir src \
    --reference-csv "doc/Modular Database_5_15_24_nbs.csv" \
    --report validation_report.txt
```

## Maintenance

### Regular Tasks

1. **Update configuration** as new parameter types are added
2. **Review validation rules** periodically
3. **Update reference CSV** when intentional changes are made
4. **Monitor automation logs** for warnings

### Version Updates

When updating the automation system:

1. Test with current reference CSV
2. Validate output quality
3. Update configuration if needed
4. Update documentation

## Support

For issues with the automation system:

1. Check the troubleshooting section above
2. Run the test suite: `python automation/test_automation.py`
3. Run the demo: `python automation/demo.py`
4. Review logs with `--log-level DEBUG`
5. Compare with reference using `--reference-csv`

The automation system is designed to be robust and self-documenting. Most issues can be resolved by checking the configuration and ensuring FORD documentation is current.