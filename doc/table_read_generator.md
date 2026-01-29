# Table Read Generator Documentation

## Overview

The `make_fortran_table_read.py` script generates Fortran subroutines that read SWAT+ table files using the flexible `table_reader` type from `utils.f90`.

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
