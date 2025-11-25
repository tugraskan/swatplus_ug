## Analyzing Commit Changes

The `analyze_commits.py` script helps analyze differences between two commits in the SWAT+ repository and categorizes file changes into meaningful groups.

### Purpose

When comparing two commits, this tool categorizes all changes into:

1. **NEW_INPUT_FILES**: New input files that are being tested
2. **NEW_OUTPUT_FILES**: New output files being reviewed
3. **Existing output files**: Changes in existing output files
4. **Existing input files**: Changes in existing input files
5. **Other**: Added/removed subroutines and modules, and other file changes

### Usage

```bash
cd /path/to/swatplus_ug
python3 test/analyze_commits.py <commit1> <commit2>
```

### Examples

#### Compare two specific commits
```bash
python3 test/analyze_commits.py abc123 def456
```

#### Compare HEAD with previous commit
```bash
python3 test/analyze_commits.py HEAD~1 HEAD
```

#### Compare a specific commit with current state
```bash
python3 test/analyze_commits.py e2ec829 HEAD
```

#### Compare two tags
```bash
python3 test/analyze_commits.py 61.0.2.4 61.0.2.5
```

### Sample Output

```
Analyzing changes between 54ddb5f and 118c27b

================================================================================

I. NEW_INPUT_FILES
--------------------------------------------------------------------------------
  (none)


II. NEW_OUTPUT_FILES
--------------------------------------------------------------------------------
  (none)


III. EXISTING OUTPUT FILES
--------------------------------------------------------------------------------
  (none)


IV. EXISTING INPUT FILES
--------------------------------------------------------------------------------
List of changes in input files:
  M data/Ames_sub1/hru-data.hru
  M data/Ames_sub1/irr.ops
  M data/Ames_sub1/landuse.lum
  M data/Ames_sub1/management.sch
  M data/Ames_sub1/soil_lyr_depths.sol
  M data/Ames_sub1/soils.sol


V. OTHER CHANGES
--------------------------------------------------------------------------------

Other modified files:
  M src/actions.f90
  M src/soils_init.f90
  M src/time_control.f90

================================================================================
```

### File Classification

The script classifies files based on their extensions:

#### Input Files
Files with extensions: `.con`, `.cli`, `.dat`, `.cha`, `.res`, `.hru`, `.rtu`, `.dr`, `.def`, `.ele`, `.wet`, `.bsn`, `.prt`, `.cnt`, `.cs`, `.sim`, `.wgn`, `.sta`, `.pet`, `.pcp`, `.tmp`, `.slr`, `.hmd`, `.wnd`, `.sol`, `.dtl`, `.lum`, `.sch`, `.cal`, `.sft`, `.ops`, `.mgt`, `.pst`, `.aqu`, `.exco`, `.rec`

#### Output Files
Files with extensions: `.txt`, `.out`

#### Source Files
Files with extensions: `.f90`, `.f`, `.F90`, `.F`

### Detecting Subroutines and Modules

For source files (`.f90`, `.f`, etc.), the script also detects:
- Added subroutines
- Removed subroutines
- Added modules
- Removed modules

This helps track code structure changes between commits.

### Use Cases

1. **Release Preparation**: Identify all input/output file changes for release notes
2. **Code Review**: Quickly see what types of changes were made across commits
3. **Testing Planning**: Identify new input files that need test coverage
4. **Documentation**: Track which output files have changed and need documentation updates
5. **Debugging**: Understand what subroutines and modules were modified between working and broken versions
