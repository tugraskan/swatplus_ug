# Automating SWAT+ Database Schema and Modular CSV Generation

This document explains how to potentially automate the creation of the Access Database Schema and Modular Database CSV files from the SWAT+ Fortran source code through static code analysis and pattern recognition.

## Current Manual Process vs Automation Potential

### What We Have Now (Manual)
- **Access_DB_Schema.txt**: 142 tables with 2,677+ fields manually documented
- **Modular Database CSV**: 3,330 parameters manually mapped across database/files/code
- **Source Code**: 645+ Fortran files with parameter definitions and file I/O

### What Can Be Automated
✅ **High Automation Potential (80-90%)**
- Input file name extraction from `input_file_module.f90`
- Database type structures from `*_data_module.f90` files  
- Variable declarations with data types and default values
- File reading patterns and parameter sequences
- Cross-references between modules and input files

⚠️ **Medium Automation Potential (50-70%)**
- Parameter descriptions (from inline comments)
- Units of measurement (from comments)  
- Valid ranges and constraints
- Database table relationships

❌ **Low Automation Potential (10-30%)**
- Semantic parameter meanings and detailed descriptions
- Complex business rules and parameter interactions
- Quality assurance and validation logic
- Documentation formatting and presentation

## Automation Architecture

### Phase 1: Static Code Analysis Engine

```python
# Pseudo-code for automation framework
class SWATPlusDatabaseAnalyzer:
    def __init__(self, source_directory):
        self.fortran_parser = FortranParser()
        self.schema_extractor = SchemaExtractor()
        self.csv_generator = CSVGenerator()
    
    def extract_input_files(self):
        """Extract all input file definitions from input_file_module.f90"""
        # Pattern: character(len=25) :: filename = "default.ext"
        
    def extract_database_types(self):
        """Extract type definitions from *_data_module.f90 files"""
        # Pattern: type table_name ... end type table_name
        
    def extract_read_patterns(self):
        """Extract parameter reading patterns from *_read.f90 files"""
        # Pattern: read (fileunit,*) var1, var2, var3
        
    def cross_reference_mapping(self):
        """Map input files → database tables → source variables"""
```

### Phase 2: Pattern Recognition Rules

#### Input File Pattern Recognition
```fortran
! FROM: input_file_module.f90
character(len=25) :: plants_plt = "plants.plt"
character(len=25) :: time = "time.sim"
character(len=25) :: codes_bas = "codes.bsn"

! EXTRACT: Input file registry
files = {
    "plants_plt": "plants.plt",
    "time": "time.sim", 
    "codes_bas": "codes.bsn"
}
```

#### Database Type Pattern Recognition
```fortran
! FROM: plant_data_module.f90
type plant_db
    character(len=40) :: plantnm = ""  !none              |crop name
    real :: bio_e = 15.0               !(kg/ha/(MJ/m**2)  |biomass-energy ratio
    real :: hvsti = 0.76               !(kg/ha)/(kg/ha)   |harvest index
end type plant_db

! EXTRACT: Database schema
plant_db = {
    "plantnm": {"type": "String", "default": "", "units": "none", "desc": "crop name"},
    "bio_e": {"type": "Double", "default": 15.0, "units": "(kg/ha/(MJ/m**2)", "desc": "biomass-energy ratio"},
    "hvsti": {"type": "Double", "default": 0.76, "units": "(kg/ha)/(kg/ha)", "desc": "harvest index"}
}
```

#### Read Pattern Recognition
```fortran
! FROM: plant_parm_read.f90
open (104,file=in_parmdb%plants_plt)
read (104,*,iostat=eof) pldb(ic)

! EXTRACT: File-to-structure mapping
mappings = {
    "plants.plt": {
        "database_table": "plant_db", 
        "structure": "pldb",
        "file_unit": 104,
        "line_position": "variable"
    }
}
```

## Implementation Strategy

### Step 1: Fortran Source Code Parser

**Required Tools:**
- FORTRAN parser (FortLS, or custom regex-based parser)
- AST (Abstract Syntax Tree) generator for Fortran
- Pattern matching engine

**Key Parsing Targets:**
```bash
# Primary source files to analyze
input_file_module.f90          # Input file definitions
*_data_module.f90             # Database type structures  
*_read.f90                    # File reading patterns
*_parm_read.f90              # Parameter reading routines
readcio_read.f90             # Master configuration reader
```

### Step 2: Database Schema Generator

**Algorithm:**
1. **Extract Type Definitions**
   ```python
   def extract_database_types():
       for module_file in find_files("*_data_module.f90"):
           types = parse_type_definitions(module_file)
           for type_name, fields in types.items():
               if type_name.endswith("_db"):
                   database_tables[type_name] = fields
   ```

2. **Generate Access DB Schema**
   ```python
   def generate_access_schema():
       for table_name, fields in database_tables.items():
           print(f"Table: {table_name}")
           print("-" * 50)
           for field_name, field_info in fields.items():
               data_type = fortran_to_access_type(field_info['type'])
               print(f"{field_name} ({data_type}, Nullable)")
   ```

### Step 3: Modular CSV Generator

**Algorithm:**
1. **Cross-Reference Input Files and Database Tables**
   ```python
   def generate_modular_csv():
       for input_file, database_table in file_table_mapping.items():
           read_pattern = find_read_pattern(input_file)
           for position, field in enumerate(read_pattern.fields):
               csv_row = {
                   'SWAT_File': input_file,
                   'database_table': database_table,
                   'DATABASE_FIELD_NAME': field.name,
                   'Position_in_File': position,
                   'Data_Type': field.type,
                   'Default_Value': field.default,
                   'Units': field.units,
                   'Description': field.description
               }
               write_csv_row(csv_row)
   ```

## Practical Implementation Tools

### Option 1: Python-Based Analyzer
```python
# Required packages
import re
import pandas as pd
from pathlib import Path

class SWATAnalyzer:
    def __init__(self):
        self.fortran_patterns = {
            'type_def': r'type\s+(\w+).*?end\s+type\s+\1',
            'variable_decl': r'(\w+)\s*::\s*(\w+)\s*=\s*([^!]+)(?:![^|]*\|([^|]*))?',
            'file_def': r'character\(len=\d+\)\s*::\s*(\w+)\s*=\s*"([^"]+)"',
            'read_stmt': r'read\s*\(\s*(\d+),\*[^)]*\)\s*([^!]+)'
        }
```

### Option 2: Bash/AWK Scripts
```bash
#!/bin/bash
# Extract input file definitions
grep -r "character(len=" src/input_file_module.f90 | \
awk -F'"' '{print $2}' > input_files.txt

# Extract type definitions  
grep -A 100 "type.*_db" src/*_data_module.f90 | \
grep -E "(real|integer|character)" > database_fields.txt

# Extract read patterns
grep -r "read.*104" src/*_read.f90 > read_patterns.txt
```

### Option 3: Modern Fortran Analysis Tools
```yaml
# Using fortls (Fortran Language Server)
tools:
  - fortls: "pip install fortls"
  - fypp: "conda install fypp" 
  - fparser2: "pip install fparser2"
  
workflow:
  1. Generate symbol table with fortls
  2. Parse AST with fparser2
  3. Extract patterns with custom scripts
```

## Example Automated Output

### Generated Access DB Schema
```
Table: plant_db
----------------------------------------------------
plantnm (String, Nullable)
typ (String, Nullable)
trig (String, Nullable)
nfix_co (Double, Nullable)
days_mat (Int32, Nullable)
bio_e (Double, Nullable)
hvsti (Double, Nullable)
blai (Double, Nullable)
```

### Generated Modular CSV Entries
```csv
Unique ID,SWAT_File,database_table,DATABASE_FIELD_NAME,Description,Units,Data_Type,Default_Value
194,plants.plt,plant_db,plantnm,crop name,none,string,""
195,plants.plt,plant_db,bio_e,biomass-energy ratio,(kg/ha/(MJ/m**2),real,15.0
196,plants.plt,plant_db,hvsti,harvest index,(kg/ha)/(kg/ha),real,0.76
```

## Limitations and Manual Work Still Required

### 1. Complex Parameter Relationships
- **Example**: Multi-dimensional arrays and dynamic structures
- **Manual Work**: Documenting complex interdependencies

### 2. Conditional Reading Logic
```fortran
if (bsn_cc%nam1 == 0) then
    read (104,*,iostat=eof) pldb(ic)
else
    read (104,*,iostat=eof) pldb(ic), pl_class(ic)
end if
```
- **Challenge**: Multiple file formats based on conditions
- **Manual Work**: Documenting conditional parameter structures

### 3. Parameter Validation Rules
- **Example**: Valid ranges, business rules, constraints
- **Manual Work**: Extracting validation logic from code comments and documentation

### 4. Semantic Documentation  
- **Example**: "Why this parameter exists and how it affects model behavior"
- **Manual Work**: Writing comprehensive parameter descriptions

## Recommended Hybrid Approach

### Phase 1: Automated Extraction (90% automation)
1. **File Structure Analysis**: Extract input files, database types, read patterns
2. **Basic Mapping**: Generate initial CSV with file/table/field relationships
3. **Data Type Detection**: Identify Fortran → Access database type mappings
4. **Default Value Extraction**: Pull default values from source code

### Phase 2: Manual Enhancement (10% manual)
1. **Parameter Descriptions**: Add detailed semantic descriptions
2. **Validation Rules**: Document parameter constraints and business rules
3. **Cross-References**: Add complex relationships and dependencies
4. **Quality Assurance**: Review and validate automated extractions

## Benefits of Automation

### 1. Consistency and Accuracy
- Eliminates manual transcription errors
- Ensures up-to-date documentation as code evolves
- Maintains consistent formatting and structure

### 2. Maintainability  
- Automatically updates when source code changes
- Reduces documentation maintenance burden
- Enables continuous integration of documentation

### 3. Comprehensive Coverage
- Captures all parameters systematically
- Identifies parameters that might be missed manually
- Provides complete cross-reference mapping

### 4. Development Efficiency
- Reduces time from weeks to hours for initial documentation
- Enables faster onboarding of new developers
- Supports automated code analysis and refactoring

## Next Steps for Implementation

1. **Create prototype parser** for `input_file_module.f90`
2. **Test pattern recognition** on `plant_data_module.f90` and `plant_parm_read.f90`
3. **Validate cross-referencing** between files, tables, and source code
4. **Generate sample outputs** and compare with existing manual documentation
5. **Implement full automation pipeline** with error handling and validation
6. **Create documentation maintenance workflow** for continuous updates

This automation approach would transform SWAT+ documentation from a manual, error-prone process into a systematic, maintainable system that evolves with the codebase.