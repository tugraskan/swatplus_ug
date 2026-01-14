# Input Reading Approach in fgeter/swatplus_fg_fork

## Overview

The fork at [https://github.com/fgeter/swatplus_fg_fork](https://github.com/fgeter/swatplus_fg_fork) introduces a modernized, object-oriented approach to reading tabular input files in SWAT+. The key innovation is the introduction of a `table_reader` type with associated methods that provide a robust, reusable framework for parsing data files.

## Key Changes

The fork adds a new module file `src/utils.f90` (807 lines) that contains:
- A **table_reader** type with comprehensive file reading capabilities
- Utility functions for string manipulation and data parsing
- Improved error handling and validation

## The table_reader Type

### Structure

The `table_reader` type is defined with the following key components:

```fortran
type :: table_reader
    ! Column and field storage
    character(MAX_NAME_LEN)  :: header_cols(MAX_TABLE_COLS) = ''  ! Column header names
    character(MAX_NAME_LEN)  :: row_field(MAX_TABLE_COLS) = ''    ! Data fields in current row
    character(len=MAX_LINE_LEN)   :: line = ''                    ! Buffer for reading lines
    character(len=:), allocatable :: left_str                     ! Line without comments
    character(len=:), allocatable :: file_name                    ! File being read
    character (len=80)     :: titldum = ""                        ! Title/first line
    
    ! State tracking
    integer                :: nrow = 0                             ! Current data row number
    integer                :: ncols = 0                            ! Number of header columns
    integer                :: nfields = 0                          ! Fields in current row
    integer                :: skipped_rows = 0                     ! Count of skipped rows
    integer                :: start_row_numbr = 1                  ! Starting row for reading
    integer                :: unit = 0                             ! File unit number
    
    ! Status flags
    logical                :: found_header_row = .false.           ! Header found flag
    logical, allocatable   :: col_okay(:)                          ! Column warning tracker
    logical                :: file_exists  = .false.               ! File existence flag

contains
    procedure              :: init
    procedure              :: get_num_data_lines
    procedure              :: get_header_columns
    procedure              :: get_row_fields
    procedure              :: output_column_warning
    procedure              :: get_row_idx
    procedure              :: get_col_count
end type table_reader
```

### Core Methods

#### 1. **init** - Initialize the table reader

```fortran
subroutine init(self, unit, file_name, start_row_numbr)
```

**Purpose**: Initialize the table reader with file information and options.

**Parameters**:
- `unit` (optional): File unit number
- `file_name` (optional): Name of the file to read
- `start_row_numbr` (optional): Row number to start reading from (default: 1)

**Features**:
- Validates file existence
- Provides warnings for missing or null files
- Flexible starting position for reading data

#### 2. **get_header_columns** - Read and parse header row

```fortran
subroutine get_header_columns(self, eof)
```

**Purpose**: Locate and process the header row containing column names.

**Key Features**:
- Rewinds file to beginning
- Handles flexible starting positions (start_row_numbr)
- Skips blank lines and comment-only lines (lines starting with `#`)
- Converts column names to lowercase for case-insensitive matching
- Trims and normalizes whitespace
- Tracks number of skipped rows

**Workflow**:
1. Rewind to file start
2. Skip to specified starting row
3. Skip empty/comment lines
4. Parse first meaningful line as header
5. Split into column names
6. Normalize names (lowercase, trim)
7. Store in `header_cols` array

#### 3. **get_row_fields** - Read next data row

```fortran
subroutine get_row_fields(self, eof)
```

**Purpose**: Read and parse the next valid data row from the file.

**Key Features**:
- Strips comments (everything after `#`)
- Skips empty lines
- Splits row into fields
- Validates column count matches header
- Provides warnings for malformed rows
- Increments row counter only for valid rows

**Workflow**:
1. Read line from file
2. Remove comments (text after `#`)
3. Skip if empty
4. Split into fields
5. Check field count matches header columns
6. Issue warning and skip if count mismatch
7. Increment row counter for valid row

#### 4. **get_num_data_lines** - Count valid data rows

```fortran
function get_num_data_lines(self) result(imax)
```

**Purpose**: Pre-scan file to count valid data rows (for array allocation).

**Key Features**:
- Scans entire file
- Counts only rows with correct column count
- Ignores empty lines and comments
- Sets `ncols` and `found_header_row` as side effects

**Important**: Leaves file at EOF; requires rewind before actual data reading.

#### 5. **output_column_warning** - Issue one-time warnings

```fortran
subroutine output_column_warning(self, i)
```

**Purpose**: Print warning for unrecognized column headers (only once per column).

**Key Features**:
- Prevents duplicate warnings
- Helps identify unexpected/unknown columns
- Writes to both log file (unit 9001) and stdout

## Supporting Utility Functions

### 1. **split_line** - Flexible string splitting

```fortran
subroutine split_line(line2, fields2, nfields, delim, maxsplit)
```

**Purpose**: Split a string into fields with flexible delimiters.

**Key Features**:
- **Default mode** (no delimiter): Splits on whitespace, collapses consecutive spaces
- **Custom delimiter mode**: Preserves empty fields (handles consecutive delimiters)
- **maxsplit option**: Limit number of splits, remainder becomes last field
- Fixed-size output arrays (debugger-friendly)
- Handles tabs (char(9)) as whitespace

**Examples**:
```fortran
! Whitespace splitting (collapse spaces)
line = "  hello   world  example  "
call split_line(line, fields, nf)
! Result: nf=3, fields=['hello', 'world', 'example']

! Comma delimiter (preserve empty fields)
line = ",,apple,,banana,"
call split_line(line, fields, nf, delim=",")
! Result: nf=6, fields=['', '', 'apple', '', 'banana', '']

! Limited splits
line = "one;two;three;four"
call split_line(line, fields, nf, delim=";", maxsplit=1)
! Result: nf=2, fields=['one', 'two;three;four']
```

### 2. **left_of_delim** - Extract text before delimiter

```fortran
subroutine left_of_delim(input, delim, result)
```

**Purpose**: Extract substring before first occurrence of delimiter (typically used to strip comments).

**Example**:
```fortran
call left_of_delim("data  1 2 3  # this is a comment", "#", comment_free)
! Result: comment_free = "data  1 2 3  "
```

### 3. **to_lower** - Convert string to lowercase

```fortran
pure function to_lower(str) result(lower)
```

**Purpose**: Convert string to lowercase for case-insensitive comparisons.

**Features**:
- Pure function (no side effects)
- Handles only ASCII characters (A-Z)
- Portable, dependency-free implementation

### 4. **exp_w** - Safe exponential function

```fortran
real function exp_w(y)
  real, intent(in) :: y
```

**Purpose**: Compute exp(y) with underflow protection.

**Features**:
- Returns 0.0 for y < -80.0 (prevents underflow)
- Optional diagnostic warnings (disabled by default)
- Compiler-specific stack trace support (Intel, GNU)

## Comparison with Current Approach

### Current Repository Pattern

The current repository uses ad-hoc file reading in each module, for example in `carbon_read.f90`:

```fortran
subroutine carbon_read
  character (len=80) :: titldum = ""
  character (len=80) :: header = ""
  integer :: eof = 0
  integer :: imax = 0
  
  ! Manual file opening and reading
  inquire (file='basins_carbon.tes', exist=i_exist)
  open (104,file='basins_carbon.tes')
  read (104,*,iostat=eof) titldum
  read (104,*,iostat=eof) header
  
  ! Count rows manually
  do while (eof == 0)
    read (104,*,iostat=eof) titldum
    if (eof < 0) exit
    imax = imax + 1
  end do
  
  ! Rewind and read data
  rewind (104)
  read (104,*,iostat=eof) titldum
  read (104,*,iostat=eof) header
  
  do icarb = 1, imax
    read (104,*,iostat=eof) cbn_tes
  end do
  
  close (104)
end subroutine carbon_read
```

**Issues with current approach**:
- Duplicated logic across multiple read subroutines
- No comment handling
- Limited error reporting
- Fixed format assumptions
- No column name validation
- Difficult to maintain consistency

### Fork's Improved Pattern

With the `table_reader` type, the same operation becomes:

```fortran
type(table_reader) :: tblr
integer :: eof, imax, icarb

! Initialize
call tblr%init(unit=104, file_name='basins_carbon.tes')

! Count data rows (for allocation)
imax = tblr%get_num_data_lines()

! Read header
call tblr%get_header_columns(eof)

! Read data rows
do icarb = 1, imax
  call tblr%get_row_fields(eof)
  ! Process tblr%row_field(:) array
end do

close(104)
```

**Advantages**:
- Consistent, reusable interface
- Built-in comment handling (`#` delimiter)
- Automatic validation (column count checks)
- Better error messages with context
- Case-insensitive column matching
- Flexible starting positions
- Robust empty line handling

## Key Benefits of the Fork's Approach

### 1. **Code Reusability**
- Single, well-tested implementation for all file reading
- Reduces code duplication across ~50+ read subroutines
- Easier to add new file reading functionality

### 2. **Robustness**
- Handles comments in data files (`#` prefix)
- Validates column counts
- Skips empty lines automatically
- Better error messages with file names and line numbers

### 3. **Flexibility**
- Configurable starting row
- Support for both whitespace and delimiter-separated files
- Case-insensitive column matching
- Optional maxsplit for complex parsing

### 4. **Maintainability**
- Centralized bug fixes and improvements
- Consistent behavior across all input files
- Well-documented methods
- Clear separation of concerns

### 5. **Debugging Support**
- Fixed-size arrays for better debugger compatibility (gfortran)
- Detailed warning messages
- Row and column tracking
- One-time warnings prevent spam

## Technical Implementation Notes

### Constants
```fortran
integer, parameter :: MAX_TABLE_COLS = 100    ! Maximum columns per table
integer, parameter :: MAX_NAME_LEN = 50       ! Maximum column name length
integer, parameter :: MAX_LINE_LEN = 2500     ! Maximum line length
```

### Comment Delimiter
- Uses `#` as the standard comment delimiter
- Everything after `#` on a line is ignored
- Allows inline documentation in data files

### File Unit
- Uses unit 9001 for warning/error log output (assumed to be opened externally)
- Standard output (print) for console warnings
- Caller responsible for opening/closing the data file unit
- Note: Unit 9001 should be opened by the calling program before using table_reader

### Row Numbering
- `start_row_numbr` allows flexible starting positions
- If set to 1: skips first line as title
- If set > 1: skips to that row, then finds header

## Usage Pattern

Typical workflow with `table_reader`:

```fortran
use utils

type(table_reader) :: tblr
integer :: eof, imax, i, col_idx
real :: value

! 1. Initialize
call tblr%init(unit=101, file_name='input_data.txt', start_row_numbr=1)

! 2. Count valid data rows (for array allocation)
imax = tblr%get_num_data_lines()
rewind(101)  ! get_num_data_lines leaves file at EOF

! 3. Read and process header
call tblr%get_header_columns(eof)
print *, 'Found', tblr%ncols, 'columns'

! 4. Find column index for specific column name
col_idx = 0
do i = 1, tblr%ncols
  if (trim(tblr%header_cols(i)) == 'my_column') then
    col_idx = i
    exit
  endif
end do

! Note: output_column_warning should be called during data processing
! when an unknown column is encountered, not here

! 5. Read data rows
do i = 1, imax
  call tblr%get_row_fields(eof)
  if (eof /= 0) exit
  
  ! Access field by column index
  if (col_idx > 0) then
    read(tblr%row_field(col_idx), *) value
    ! Process value...
  endif
end do

close(101)
```

## Summary

The fork's approach represents a significant improvement in code organization and robustness for reading input files in SWAT+. The `table_reader` type provides:

- **Object-oriented design** with clear encapsulation
- **Reusable components** reducing code duplication
- **Robust parsing** with comment support and validation
- **Better error handling** with informative messages
- **Flexible configuration** for various file formats
- **Maintainable codebase** with centralized logic

This modernization makes the SWAT+ codebase easier to maintain, extend, and debug while providing better user feedback when input files have issues.
