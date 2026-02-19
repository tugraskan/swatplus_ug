# SWAT+ Hardcoded Files Analysis

This directory contains an analysis of files that are **hardcoded** in the SWAT+ source code and are **NOT configurable** through `file.cio`.

## What Are Hardcoded Files?

Hardcoded files are those with literal string filenames in OPEN statements:

```fortran
! Hardcoded - NOT configurable
open (107, file="cs_recall.rec")

! Configurable - defined in input_file_module.f90
open (107, file=in_rec%recall_rec)  ! defaults to "recall.rec"
```

## Files Generated

1. **`HARDCODED_FILES.txt`** - Human-readable report (detailed)
2. **`HARDCODED_FILES.csv`** - CSV format (Filename, Configurable, References, Source_Files)
3. **`find_hardcoded_files.py`** - Python script to generate text report
4. **`find_hardcoded_files_csv.py`** - Python script to generate CSV

## Key Findings

### Summary Statistics

- **Configurable files** (in input_file_module.f90): **149**
- **Hardcoded files** (literal strings in code): **73**
  - **NOT configurable** (hardcoded only): **70** (95.9%)
  - **Also configurable** (have defaults): **3** (4.1%)

### Critical Discovery

**70 files (95.9%)** are hardcoded and **cannot be configured** through `file.cio`!

These files have fixed names and locations, which means:
- Users cannot rename them
- Users cannot specify alternative locations
- File naming is inflexible

## Categories of Hardcoded Files

### 1. Master Configuration (1 file)
- **`file.cio`** - The master configuration file itself (must be hardcoded)

### 2. GWFLOW Module Files (20+ files)
GWFLOW (groundwater flow module) has many hardcoded files:
- `gwflow.chancells` (2 references)
- `gwflow.input`
- `gwflow.con` (also has default in input_file_module.f90)
- `out.key`
- Many output files

### 3. Constituent System Files (15+ files)
Enhanced constituent transport system:
- `cs_recall.rec`
- `cs_reactions`
- `cs_aqu.ini`
- `cs_channel.ini`
- `cs_hru.ini`
- `cs_plants_boron`
- `cs_res`
- `cs_streamobs`
- `cs_streamobs_output`
- `cs_uptake`
- `cs_urban`
- `cs_irrigation`
- `cs_atmo.cli`
- `fertilizer.frt_cs`

### 4. Salt Module Files (10+ files)
Salt transport modeling:
- `salt_irrigation`
- `salt_road`
- `salt_atmo.cli`
- `salt_recall.rec`
- `salt_aqu.ini`
- `salt_channel.ini`
- `salt_plants`
- `salt_res`
- `salt_uptake`
- `salt_urban`

### 5. Water Allocation Files (8 files)
Water management features:
- `water_use.wal`
- `water_pipe.wal`
- `water_tower.wal`
- `water_treat.wal`
- `om_use.wal`
- `om_osrc.wal`
- `om_treat.wal`
- `outside_src.wal`

### 6. Calibration Output Files (5 files)
Calibration-related outputs:
- `hru-out.cal`
- `hru-new.cal`
- `hydrology-cal.hyd`
- `hru-lte-out.cal`
- `hru-lte-new.cal`
- `plant_parms.cal`

### 7. Specialized Database Files (10+ files)
- `recall_db.rec` - Recall database
- `pest.com` - Pesticide common blocks
- `pest_metabolite.pes` - Pesticide metabolites
- `manure.frt` - Manure database
- `carb_coefs.cbn` - Carbon coefficients
- `basins_carbon.tes` - Basin carbon testing
- `co2_yr.dat` - Annual CO2 data
- `transplant.plt` - Plant transplant data
- `soil_lyr_depths.sol` - Soil layer depths

### 8. Other Hardcoded Files
- `looping.con` - Hydrologic connectivity loops
- `nutrients.rte` - Nutrient routing
- `puddle.ops` - Puddle operations
- `satbuffer.str` - Saturated buffer structures
- `scen_dtl.upd` - Scenario detail updates
- `sed_nut.cha` - Sediment nutrients in channels
- `element.ccu` - Channel connectivity units
- And others...

## Files That Are BOTH Hardcoded AND Configurable

Only **3 files** have defaults in `input_file_module.f90` but are also hardcoded:

1. **`pet.cli`** - PET climate data
2. **`salt_hru.ini`** - Salt HRU initial conditions
3. **`gwflow.con`** - GWFLOW connection file

This is redundant - they should use the configurable version.

## Impact & Recommendations

### Issues with Hardcoded Files

1. **Lack of Flexibility**
   - Users cannot customize filenames
   - Cannot organize files in subdirectories
   - Cannot use different naming conventions

2. **Portability Problems**
   - File names are case-sensitive on Linux
   - Path separators differ between systems
   - Cannot adapt to different workflows

3. **Maintenance Burden**
   - Changes require recompiling source code
   - Cannot be modified through configuration
   - Difficult to test with alternative inputs

### Recommendations

1. **Move to input_file_module.f90**
   - Add all hardcoded files to `input_file_module.f90`
   - Make them configurable through `file.cio`
   - Maintain backward compatibility with default names

2. **Priority Files to Make Configurable**
   - GWFLOW module files (most referenced)
   - Constituent system files
   - Salt module files
   - Water allocation files

3. **Keep Hardcoded (if necessary)**
   - `file.cio` - Must be hardcoded (bootstrap problem)
   - Temporary/debug files
   - System-level files

## Usage

### View the Report
```bash
# Human-readable format
cat HARDCODED_FILES.txt

# CSV format
cat HARDCODED_FILES.csv
```

### Find Specific Files
```bash
# Find all GWFLOW files
grep "gwflow" HARDCODED_FILES.csv

# Find all constituent files
grep "cs_" HARDCODED_FILES.csv

# Find files with multiple references
awk -F',' '$3 > 1' HARDCODED_FILES.csv
```

### Regenerate the Analysis
```bash
# Text report
python3 find_hardcoded_files.py > HARDCODED_FILES.txt

# CSV format
python3 find_hardcoded_files_csv.py > HARDCODED_FILES.csv
```

## Technical Details

### Detection Method

The scripts scan all Fortran source files for OPEN statements with literal string filenames:

```python
# Pattern: open(unit_number, file="literal_filename.ext")
pattern = r'open\s*\(\s*\d+\s*,\s*file\s*=\s*["\']([^"\']+)["\']'
```

### Excluded Patterns

The following are excluded from detection:
- Variables: `file=in_basin%codes_bas`
- Expressions: `file=trim(filename)`
- Paths: `file="/path/to/file"`
- Concatenations: `file=path//filename`

### Comparison Method

Files are compared (case-insensitive) with:
- Configurable files from `input_file_module.f90`
- Hardcoded files from OPEN statements in source

## Example Hardcoded Files

### GWFLOW Module
```fortran
! gwflow_chan_read.f90:31
open(1280, file='gwflow.chancells')

! gwflow_read.f90:1717
open(5100, file='out.key')
```

### Constituent System
```fortran
! cs_aqu_read.f90:23
open(107, file="cs_aqu.ini")

! cs_reactions_read.f90:34
open(107, file="cs_reactions")
```

### Water Allocation
```fortran
! water_use_read.f90:32
open(107, file='water_use.wal')

! water_pipe_read.f90:30
open(107, file='water_pipe.wal')
```

## Conclusion

**70 files** in SWAT+ are hardcoded and cannot be configured through `file.cio`. This affects:
- User flexibility
- System portability
- Maintenance efficiency

Recommendation: Migrate hardcoded files to `input_file_module.f90` to make them configurable.

---

*Analysis Date: 2026-02-08*  
*Source: SWAT+ Fortran source code*  
*Total Files Analyzed: 625 Fortran files*
