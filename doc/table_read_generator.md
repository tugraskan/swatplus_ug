# Table Read Generator Documentation

## Overview

The `make_fortran_table_read.py` script generates Fortran subroutines that read SWAT+ table files using the flexible `table_reader` type from `utils.f90`.

## Options Considered for Required Column Specification

When addressing the hard-coded header string issue, several approaches were evaluated:

### Option 1: Module Parameter (✓ Implemented)

**Description**: Define required columns as a module-level parameter in the data module.

**Pros**:
- Single source of truth - columns defined once near the type definition
- Easy to maintain - update in one place
- Good code organization - related data kept together
- No external dependencies - stays within Fortran ecosystem
- Supports custom versions - users can modify the module parameter
- Self-documenting - parameter serves as documentation

**Cons**:
- Requires regenerating the read subroutine if parameter name changes
- Parameter must exist in the module before compiling

**Implementation**: A parameter is added to the module (e.g., `cons_prac_req_cols = "name PFAC sl_len_mx"`), and the generated read subroutine references this parameter.

### Option 2: Schema File

**Description**: Create separate schema files (JSON/YAML/custom) defining expected columns for each table type.

**Pros**:
- Centralized configuration
- Could support multiple versions easily
- More flexible for runtime configuration
- Could include additional metadata (data types, validation rules)

**Cons**:
- Requires file I/O at runtime or compile time
- Adds external dependency
- More complex implementation
- Not common in Fortran ecosystem
- Would need parser for schema format
- Deployment complexity (additional files to distribute)

**Not Recommended For**: Fortran-based projects where simplicity is preferred.

### Option 3: Read from Data File Header

**Description**: Embed required column information in the data file itself (e.g., special marker in first line).

**Pros**:
- Self-contained data files
- Users can see requirements in the data file

**Cons**:
- Breaks separation of concerns (data vs schema)
- Difficult to validate before reading data
- Non-standard file format
- Error-prone for users to maintain
- Can't validate file structure before opening

**Not Recommended For**: This use case, as it complicates the data file format.

### Option 4: Runtime Type Introspection

**Description**: Automatically derive required columns from type definition at runtime using Fortran introspection.

**Pros**:
- Fully automatic
- No manual configuration needed

**Cons**:
- Limited Fortran introspection capabilities
- Complex implementation
- Performance overhead
- Not widely supported across compilers
- Cannot distinguish required vs optional columns

**Not Feasible**: Fortran lacks the necessary introspection features.

### Option 5: Hard-coded String (Legacy)

**Description**: Directly embed the column string in the read subroutine code.

**Pros**:
- Simple and direct
- No additional dependencies
- Works immediately

**Cons**:
- Duplication - string may appear in multiple places
- Hard to maintain - need to update code when columns change
- Not flexible - requires code changes for custom versions
- Poor code organization

**Why Changed**: This was the original approach, which led to the issue being addressed.

## Chosen Solution: Module Parameter

The module parameter approach (Option 1) was selected as it provides the best balance of:
- **Simplicity**: Stays within standard Fortran conventions
- **Maintainability**: Single location to define requirements
- **Flexibility**: Easy for users to customize
- **Organization**: Keeps related definitions together
- **Performance**: Zero runtime overhead

## Features

### Required Column Headers

When generating a table read subroutine, you can specify the minimum required columns in two ways:

#### 1. Module Parameter (Recommended)

Define a module-level parameter in the data module that contains the required column names. This approach:
- Keeps the column specification close to the type definition
- Makes it easy to maintain and update
- Avoids hard-coding strings in multiple places
- Allows users to see what columns are required when examining the module

**Example:**

In your data module (e.g., `landuse_data_module.f90`):
```fortran
type conservation_practice_table
  character(len=40) :: name = ""
  real :: pfac = 1.0
  real :: sl_len_mx = 1.0
end type conservation_practice_table
type (conservation_practice_table), dimension (:), allocatable :: cons_prac
character(len=*), parameter :: cons_prac_req_cols = "name PFAC sl_len_mx"
```

In the Python script configuration:
```python
module_name = "landuse_data_module"
type_name = "conservation_practice_table"
cust_hdr_string = "name PFAC sl_len_mx"
req_cols_param = "cons_prac_req_cols"  # Name of the parameter in the module
allocation_name = "cons_prac"
```

The generated code will use the parameter:
```fortran
call lu_tbl%min_req_cols(cons_prac_req_cols)
```

#### 2. Hard-coded String (Legacy)

If you don't specify a `req_cols_param`, the string will be hard-coded in the generated subroutine:

```python
req_cols_param = ""  # Empty string means hard-code it
```

Generated code:
```fortran
call lu_tbl%min_req_cols("name PFAC sl_len_mx")
```

## Benefits of Module Parameter Approach

1. **Single Source of Truth**: The required columns are defined once in the module, near the type definition
2. **Easy Maintenance**: Update the parameter in one place to change required columns
3. **Better Code Organization**: Related data (type definition and its requirements) are kept together
4. **Custom Versions**: Users can create custom versions of the module with different required columns without modifying the read subroutine
5. **Documentation**: The parameter serves as documentation of what columns are required for the table

## Usage Example

### Step 1: Define the Type and Parameter in Module

```fortran
module my_data_module
  type my_table_type
    character(len=40) :: name = ""
    real :: value1 = 0.0
    real :: value2 = 0.0
  end type my_table_type
  type (my_table_type), dimension (:), allocatable :: my_table
  character(len=*), parameter :: my_table_req_cols = "name value1 value2"
end module my_data_module
```

### Step 2: Configure the Python Script

Edit `make_fortran_table_read.py`:

```python
subroutine_name = "my_table_read"
module_name = "my_data_module"
type_name = "my_table_type"
cust_hdr_string = "name value1 value2"
req_cols_param = "my_table_req_cols"  # Use the module parameter
col_is_string = ["name"]
input_file_name = "in_data%my_table_file"
allocation_name = "my_table"
dtype = "tbl"
db_max_name = "my_table"
```

### Step 3: Generate the Read Subroutine

From the `src` directory:
```bash
python3 ../test/make_fortran_table_read.py
```

This will create `my_table_read.f90` that uses the module parameter.

## Migration Guide

To migrate existing table read subroutines to use module parameters:

1. Add a parameter to the module (e.g., `landuse_data_module.f90`):
   ```fortran
   character(len=*), parameter :: cons_prac_req_cols = "name PFAC sl_len_mx"
   ```

2. Update the Python script configuration to set `req_cols_param`:
   ```python
   req_cols_param = "cons_prac_req_cols"
   ```

3. Regenerate the read subroutine:
   ```bash
   cd src
   python3 ../test/make_fortran_table_read.py
   ```

4. The generated subroutine will now use the parameter instead of a hard-coded string
