# SWAT+ I/O Trace Documentation Automation Guide

## Overview

This guide explains how to generate I/O trace documentation for SWAT+ input files automatically and semi-automatically.

## Quick Start

### Option 1: Automated Script (Partial Automation)

Use the provided Python script to extract basic I/O patterns:

```bash
python generate_io_trace.py <filename>
```

**Example:**
```bash
python generate_io_trace.py aquifer.aqu
```

**What the script does:**
- Finds the file variable in `input_file_module.f90`
- Locates the read subroutine
- Extracts open/read/close statements
- Generates a documentation template

**What requires manual work:**
- Parsing complex read statements with multiple variables
- Extracting derived type component definitions
- Adding defaults, units, and descriptions from comments
- Verifying line numbers in actual input files
- Creating the complete PRIMARY DATA READ table

### Option 2: Manual Analysis (Full Control)

For complete and accurate documentation, follow this systematic process:

#### Step 1: Find Filename Variable

Search `src/input_file_module.f90`:
```bash
grep -n "aquifer.aqu" src/input_file_module.f90
```

Example output:
```
130:    character(len=25) :: aqu = "aquifer.aqu"
```

This tells you:
- Variable: `in_aqu%aqu`
- Derived type: `in_aqu`
- Source line: `src/input_file_module.f90:130`

#### Step 2: Find Read Subroutine

Search for the variable in all source files:
```bash
grep -rn "in_aqu%aqu" src/
```

Example output:
```
src/aqu_read.f90:15:  inquire(file=in_aqu%aqu, exist=i_exist)
src/aqu_read.f90:18:  open (107,file=in_aqu%aqu)
```

This identifies:
- Read subroutine: `aqu_read` in `src/aqu_read.f90`
- Unit number: 107

#### Step 3: Analyze Read Statements

View the subroutine:
```bash
view src/aqu_read.f90
```

Extract all read statements using unit 107:
```fortran
read (107,*,iostat=eof) titldum
read (107,*,iostat=eof) k, aqudb(i)
```

#### Step 4: Extract Variable Definitions

For each variable in read statements:

**Local variables:**
```bash
grep -n "integer :: k" src/aqu_read.f90
```

**Derived type components:**
Find the type definition:
```bash
grep -rn "type aquifer_database" src/
```

View the type:
```bash
view src/basin_module.f90:50-80
```

Extract all components with their types, defaults, and comments.

#### Step 5: Build PRIMARY DATA READ Table

Create table with columns:
- **Line in File**: Actual line number in input file (3+, after title/header)
- **Position**: Sequential position (1, 2, 3...)
- **Local (Y/N)**: Y for local variables, N for derived type components
- **Derived Type**: Name of type (or N/A for local)
- **Component**: Variable or component name
- **Type**: Fortran type (integer, real, character, etc.)
- **Default**: Default value from declaration
- **Units**: Units from comments
- **Description**: Description from comments
- **Swat_codetype**: file.cio derived type (e.g., in_aqu)
- **Source Line**: Location in source code (e.g., src/file.f90:123)

## Tools and Commands Reference

### Essential grep Patterns

**Find filename assignments:**
```bash
grep -rn '"filename.ext"' src/input_file_module.f90
```

**Find file open statements:**
```bash
grep -rn 'open.*file.*variable_name' src/
```

**Find type definitions:**
```bash
grep -rn 'type .*typename' src/
```

**Find read statements by unit:**
```bash
grep -n 'read (107' src/subroutine.f90
```

### Useful View Commands

**View specific line range:**
```bash
view src/file.f90 --view_range [50, 100]
```

**View entire file:**
```bash
view src/file.f90
```

## Common Patterns

### Two-Pass Reading Strategy

Many SWAT+ files use a two-pass approach:

**Pass 1:** Count records
```fortran
do
  read (107,*,iostat=eof) k
  if (eof < 0) exit
  counter = counter + 1
end do
```

**Pass 2:** Read data
```fortran
rewind (107)
read (107,*) titldum  ! skip header
do i = 1, counter
  read (107,*) k, aqudb(i)
end do
```

### Array vs. Single Record

**Array reading (multiple records):**
```fortran
do i = 1, sp_ob%objs
  read (107,*) bsn%name, bsn%area_ha, sp_ob(i)
end do
```

**Single record:**
```fortran
read (107,*) time_sim
```

### Derived Type I/O

**List-directed (automatic):**
```fortran
read (107,*) aqudb(i)  ! Reads all components in declaration order
```

**Explicit components:**
```fortran
read (107,*) aqudb(i)%name, aqudb(i)%area, aqudb(i)%depth
```

## File.cio Cross-Reference

To find the Swat_codetype for any file:

1. Search file.cio example or documentation
2. Match filename to derived type component
3. Common mappings:
   - `aquifer.aqu` → `in_aqu`
   - `object.cnt` → `in_sim`
   - `management.sch` → `in_lum`
   - `plants.plt` → `in_parmdb`
   - `codes.bsn` → `in_basin`
   - `weather-sta.cli` → `in_cli`

## Best Practices

1. **Always verify line numbers** by checking actual example input files
2. **Extract comments** from source code for units and descriptions
3. **Check derived type definitions** for default initializations
4. **Document I/O unit reuse** (many files use unit 107)
5. **Note special cases** like sparse arrays, optional fields, null handling
6. **Cross-reference** with file.cio to confirm Swat_codetype

## Limitations of Automation

The script provides a starting point but cannot fully automate:

- **Complex I/O lists**: Requires manual parsing of variable order
- **Type component expansion**: Must manually extract from type definitions
- **Defaults and units**: Must extract from source code comments
- **Line number mapping**: Must verify against actual input file format
- **Special cases**: Two-pass reading, conditional I/O, dynamic arrays

## Full Manual Process (Most Accurate)

For publication-quality documentation:

1. Use grep/view to extract all information
2. Manually create PRIMARY DATA READ table
3. Verify all details against source code
4. Cross-check with example input files
5. Add comprehensive descriptions
6. Review for accuracy and completeness

## Recommended Workflow

For new files:

1. **Run script** to get basic structure
2. **Manual analysis** to fill in details
3. **Verification** against source and examples
4. **Review** for consistency with existing documentation

This hybrid approach balances automation with accuracy.

## Examples

See the existing documentation in `IO_TRACE_REPORT.md` for:
- `aquifer.aqu` (Section 3.1)
- `object.cnt` (Section 3.2)
- `file.cio` (Section 4)

These serve as templates for documenting additional files.

## Getting Help

For questions or issues:
1. Review existing documentation in `IO_TRACE_REPORT.md`
2. Check `DOCUMENTATION_COMPLETION_SUMMARY.md` for methodology
3. Examine source files directly in `src/` directory
4. Refer to this guide for automation options

## Future Enhancements

Potential improvements to automation:

- [ ] Enhanced Fortran parser for read statement variable lists
- [ ] Automatic type definition extraction and expansion
- [ ] Comment parsing for units/descriptions
- [ ] Integration with SWAT+ editor for validation
- [ ] Batch processing for multiple files
- [ ] Template generation for common patterns
