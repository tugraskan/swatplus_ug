# Example Output from File I/O Analysis

## Example 1: file.cio (Master Configuration File)

```
PROVIDED: file.cio
  CODE FILE: file.cio
    └─ inquire  in readcio_read() [readcio_read.f90:20]
    └─ open     in readcio_read() [readcio_read.f90:22]
```

**Interpretation:**
- File is checked for existence (inquire) then opened
- Used in subroutine `readcio_read()`
- Located at lines 20-22 of `readcio_read.f90`

---

## Example 2: Time Series Output (Multiple Variants)

```
Pattern: aquifer (8 variants)
  - aquifer_mon.txt
  - aquifer_day.csv
  - aquifer_day.txt
  - aquifer_yr.txt
  - aquifer_yr.csv
  - aquifer_mon.csv
  - aquifer_aa.txt
  - aquifer_aa.csv
```

**Interpretation:**
- Single logical file with 8 physical variants
- 4 time periods: daily, monthly, yearly, annual average
- 2 formats: txt, csv
- All handled by `header_aquifer()` subroutine

---

## Example 3: GWFLOW Module Files (Not in Original List)

```
Pattern: gwflow_flux_rech
  CODE FILE: gwflow_flux_rech
    └─ reference in gwflow_read() [gwflow_read.f90:781]

Pattern: gwflow_flux_gwsw
  CODE FILE: gwflow_flux_gwsw
    └─ reference in gwflow_read() [gwflow_read.f90:807]

Pattern: gwflow_flux_tile
  CODE FILE: gwflow_flux_tile
    └─ reference in gwflow_read() [gwflow_read.f90:1045]
```

**Interpretation:**
- New GWFLOW module files not in original 192-file list
- All referenced in `gwflow_read()` subroutine
- Groundwater flux output files for recharge, groundwater-surface water, and tile drainage

---

## Example 4: File Referenced via Variable (Input File Module)

```
PROVIDED: plants.plt
  CODE FILE: plants.plt
    └─ reference in unknown() [input_file_module.f90:177]
```

**Context from input_file_module.f90:**
```fortran
type input_parameter_databases
  character(len=25) :: plants_plt = "plants.plt"
  character(len=25) :: fert_frt = "fertilizer.frt"
  character(len=25) :: till_til = "tillage.til"
  ...
end type input_parameter_databases
```

**Interpretation:**
- File defined as default filename in module variable
- Actual OPEN occurs elsewhere using `in_parmdb%plants_plt`
- This is why many files appear to be "only" in input_file_module.f90

---

## Example 5: Files Potentially Unused (In List, Not in Code)

```
Files in PROVIDED LIST but NOT clearly found in CODE:

  calibration.cal                (ref count: 16)
  codes.bsn                      (ref count: 26)
  channel.out                    (ref count: 62)
  waterbal.bsn                   (ref count: 20)
  nutbal.hru                     (ref count: 22)
  losses.hru                     (ref count: 15)
```

**Interpretation:**
- Listed in original documentation with reference counts
- Not found as string literals in current source code
- May be:
  1. Dynamically generated filenames
  2. Legacy files from older versions
  3. Files read via file.cio indirectly
  4. Output files with pattern-based naming

---

## Example 6: Constituent System Files (In Code, Not in List)

```
Pattern: cs_aqu.ini
  CODE FILE: cs_aqu.ini
    └─ open in cs_aqu_read() [cs_aqu_read.f90:23]

Pattern: cs_channel.ini
  CODE FILE: cs_channel.ini
    └─ open in cs_cha_read() [cs_cha_read.f90:28]

Pattern: cs_hru.ini
  CODE FILE: cs_hru.ini
    └─ open in cs_hru_read() [cs_hru_read.f90:23]
```

**Interpretation:**
- New constituent transport system initial condition files
- Each opened in respective read subroutine
- Part of enhanced constituent modeling not in original list

---

## Summary Statistics from Analysis

```
Files in provided list:                     192
Files matched with code:                    136
Files in list but not clearly in code:       56
Unique files found in code:                1362
Files in code but not in list:             1225

Match rate: 70.8%
```

---

## File Grouping Strategy

### Before (Individual Files):
```
basin_aqu_day.txt
basin_aqu_day.csv
basin_aqu_mon.txt
basin_aqu_mon.csv
basin_aqu_yr.txt
basin_aqu_yr.csv
basin_aqu_aa.txt
basin_aqu_aa.csv
```

### After (Pattern-Based):
```
basin_aqu_* (8 variants: _day/_mon/_yr/_aa × .txt/.csv)
```

**Benefits:**
- Reduces 1,400+ files to ~150 patterns
- Easier to maintain documentation
- Clear indication of time series and format variations
- Still complete and unambiguous

---

## Tools Usage

### Run Detailed Analysis:
```bash
python3 detailed_file_mapping.py > detailed_mapping_report.txt
```

### View Results:
```bash
# Section 1: Files in list but not in code
grep -A 60 "SECTION 1:" detailed_mapping_report.txt

# Section 2: Files in code but not in list
grep -A 100 "SECTION 2:" detailed_mapping_report.txt

# Section 3: Matched files with mappings
grep -A 100 "SECTION 3:" detailed_mapping_report.txt

# Summary statistics
tail -20 detailed_mapping_report.txt
```

---

## Key Insights

1. **Most files in original list are still valid** - They're just defined in `input_file_module.f90` as defaults
2. **Massive expansion in outputs** - Time series variants have expanded outputs from ~50 to 800+ files
3. **New modules added** - GWFLOW (100+ files), constituents (50+), salt (30+), SWIFT (15+)
4. **Pattern-based naming is consistent** - Time series suffixes and format extensions follow clear conventions
5. **File.cio is the master** - Most input files are read through file.cio configuration

