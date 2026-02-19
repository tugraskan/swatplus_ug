# I/O Trace Documentation

This directory contains comprehensive documentation of input/output operations for the SWAT+ model.

## Files

### IO_TRACE_REPORT.md

A comprehensive Phase 1 I/O trace report documenting all code paths that read or write the following files:

1. **aquifer.aqu** (input) - Aquifer parameter database
2. **object.cnt** (input) - Spatial object counts
3. **mgt.out** (output) - Management operations log
4. **aquifer.out** (output) - Aquifer simulation results

## Report Structure

The report includes the following sections:

### 1. Filename Resolution Map
- Complete mapping from target filenames to variable expressions
- Type definitions and default values
- Source code locations (file:line format)

### 2. I/O Sites and Unit Mappings
- All file operations (inquire, open, read, write, close, rewind, backspace)
- Unit number to filename associations
- Line-by-line documentation of each I/O statement

### 3. Read/Write Payload Map
- Complete variable definitions for every read/write operation
- Derived type expansions with all components
- Type, default values, units, and descriptions
- Source code locations for declarations

### 4. Worked Example: aqu_read
- Step-by-step walkthrough of the aqu_read subroutine
- Two-pass reading strategy explained
- Complete variable tracking
- Input file format specification

## Location Format

All source code locations use the format: `relative/path/to/file.f90:line` or `relative/path/to/file.f90:line-range`

Examples:
- `src/aqu_read.f90:55` - Single line reference
- `src/aquifer_module.f90:5-23` - Range reference

## Key Findings

- **Input Files**: Use list-directed (free format) I/O with derived types
- **Output Files**: Use formatted or CSV output with explicit format statements
- **Unit Reuse**: Unit 107 is reused for different input files
- **Output Units**: Unique persistent units (2520-2527 for aquifer, 2612 for management)
- **No User-Defined I/O**: All derived types use default Fortran I/O
- **Sparse Arrays**: aquifer.aqu uses a two-pass strategy to support non-sequential IDs

## Usage

This documentation is intended for:
- Developers modifying I/O routines
- Users understanding input file formats
- Analysts tracing data flow through the model
- Maintainers debugging I/O issues

## Future Phases

This report covers Phase 1 (the four target files). Future phases may expand to:
- Additional input files (soils, climate, etc.)
- Additional output files (channel, reservoir, etc.)
- Runtime filename overrides via configuration files
- Binary I/O operations (if any)

---

**Generated**: 2026-01-22  
**Repository**: tugraskan/swatplus_ug
