# SWAT+ Focused I/O Trace Report
## Phase 1: aquifer.aqu, object.cnt, mgt.out, aquifer.out + file.cio (Master Config)

**Date**: 2026-01-22
**Repository**: tugraskan/swatplus_ug

---

## 1. Filename Resolution Map

### 1.1 aquifer.aqu (INPUT)

**Resolution Chain**:
- Target filename: `aquifer.aqu`
- Expression: `in_aqu%aqu`
- Type definition: `input_aqu` at src/input_file_module.f90:128-132
- Variable instance: `in_aqu` at src/input_file_module.f90:132
- Default value: `"aquifer.aqu"` set at src/input_file_module.f90:130
- Runtime overrides: None detected in Phase 1 scope

**Detailed Mapping**:
```
aquifer.aqu → in_aqu%aqu 
            → type input_aqu (src/input_file_module.f90:128-132)
            → character(len=25) :: aqu = "aquifer.aqu" (src/input_file_module.f90:130)
```

### 1.2 object.cnt (INPUT)

**Resolution Chain**:
- Target filename: `object.cnt`
- Expression: `in_sim%object_cnt`
- Type definition: `input_sim` at src/input_file_module.f90:8-14
- Variable instance: `in_sim` at src/input_file_module.f90:15
- Default value: `"object.cnt"` set at src/input_file_module.f90:12
- Runtime overrides: None detected in Phase 1 scope

**Detailed Mapping**:
```
object.cnt → in_sim%object_cnt 
           → type input_sim (src/input_file_module.f90:8-14)
           → character(len=25) :: object_cnt = "object.cnt" (src/input_file_module.f90:12)
```

### 1.3 mgt.out (OUTPUT)

**Resolution Chain**:
- Target filename: `mgt_out.txt` (actual output filename)
- Expression: String literal in call to `open_output_file(2612, "mgt_out.txt", 800)`
- Opening location: src/header_mgt.f90:9
- Control flag: `pco%mgtout` (src/basin_module.f90:176)
- Default control: `character(len=1) :: mgtout = "n"` at src/basin_module.f90:176
- Runtime overrides: Set via print.prt configuration file

**Detailed Mapping**:
```
mgt.out → unit 2612 → "mgt_out.txt" literal
        → open_output_file(2612, "mgt_out.txt", 800) (src/header_mgt.f90:9)
        → Controlled by pco%mgtout (src/basin_module.f90:176)
```

### 1.4 aquifer.out (OUTPUT)

**Resolution Chain**:
- Target filenames (multiple):
  - `aquifer_day.txt` (unit 2520, daily)
  - `aquifer_day.csv` (unit 2524, daily CSV)
  - `aquifer_mon.txt` (unit 2521, monthly)
  - `aquifer_mon.csv` (unit 2525, monthly CSV)
  - `aquifer_yr.txt` (unit 2522, yearly)
  - `aquifer_yr.csv` (unit 2526, yearly CSV)
  - `aquifer_aa.txt` (unit 2523, average annual)
  - `aquifer_aa.csv` (unit 2527, average annual CSV)
- Expression: String literals in calls to `open_output_file`
- Opening locations: src/header_aquifer.f90:13,19,30,36,47,53,64,70
- Control flags: `pco%aqu%d`, `pco%aqu%m`, `pco%aqu%y`, `pco%aqu%a` (src/basin_module.f90:221)
- CSV flag: `pco%csvout` (src/basin_module.f90:167)
- Runtime overrides: Set via print.prt configuration file

**Detailed Mapping**:
```
aquifer.out → Multiple unit/filename pairs:
  Daily:   2520 → "aquifer_day.txt", 2524 → "aquifer_day.csv"
  Monthly: 2521 → "aquifer_mon.txt", 2525 → "aquifer_mon.csv"
  Yearly:  2522 → "aquifer_yr.txt",  2526 → "aquifer_yr.csv"
  Avg Ann: 2523 → "aquifer_aa.txt",  2527 → "aquifer_aa.csv"
  → Controlled by pco%aqu (type print_interval, src/basin_module.f90:221)
```

---

## 2. I/O Sites and Unit Mappings

### 2.1 aquifer.aqu

**Routine**: `aqu_read`  
**File**: src/aqu_read.f90  
**Expression**: `in_aqu%aqu`  
**Unit mapping**: 107 → in_aqu%aqu → "aquifer.aqu"

**I/O Sites**:

| Line | Statement | Type | Description |
|------|-----------|------|-------------|
| 25 | `inquire (file=in_aqu%aqu, exist=i_exist)` | INQUIRE | Check file existence |
| 30 | `open (107,file=in_aqu%aqu)` | OPEN | Open aquifer database file |
| 31 | `read (107,*,iostat=eof) titldum` | READ | Read title line |
| 33 | `read (107,*,iostat=eof) header` | READ | Read column headers |
| 36 | `read (107,*,iostat=eof) i` | READ | Read aquifer ID (first pass) |
| 44 | `rewind (107)` | REWIND | Reset file pointer to beginning |
| 45 | `read (107,*,iostat=eof) titldum` | READ | Re-read title line |
| 47 | `read (107,*,iostat=eof) header` | READ | Re-read column headers |
| 51 | `read (107,*,iostat=eof) i` | READ | Read aquifer ID (second pass) |
| 53 | `backspace (107)` | BACKSPACE | Move back one record |
| 55 | `read (107,*,iostat=eof) k, aqudb(i)` | READ | Read aquifer ID and full record |
| 59 | `close (107)` | CLOSE | Close file |

**Two-Pass Reading Strategy**:
1. **First pass (lines 30-40)**: Count records and find maximum aquifer ID to allocate `aqudb` array
2. **Second pass (lines 44-57)**: Read actual data into allocated array

### 2.2 object.cnt

**Routine**: `basin_read_objs`  
**File**: src/basin_read_objs.f90  
**Expression**: `in_sim%object_cnt`  
**Unit mapping**: 107 → in_sim%object_cnt → "object.cnt"

**I/O Sites**:

| Line | Statement | Type | Description |
|------|-----------|------|-------------|
| 27 | `inquire (file=in_sim%object_cnt, exist=i_exist)` | INQUIRE | Check file existence |
| 33 | `open (107,file=in_sim%object_cnt)` | OPEN | Open object count file |
| 34 | `read (107,*,iostat=eof) titldum` | READ | Read title line |
| 36 | `read (107,*,iostat=eof) header` | READ | Read column headers |
| 38 | `read (107,*,iostat=eof) bsn, sp_ob` | READ | Read basin and spatial object counts |
| 43 | `close (107)` | CLOSE | Close file |

### 2.3 mgt.out

**Opening Routine**: `header_mgt`  
**File**: src/header_mgt.f90  
**Unit**: 2612  
**Filename**: "mgt_out.txt"

**I/O Sites - Header**:

| Line | Statement | Type | Description |
|------|-----------|------|-------------|
| src/header_mgt.f90:9 | `call open_output_file(2612, "mgt_out.txt", 800)` | OPEN | Open management output file |
| src/header_mgt.f90:10 | `write (2612,*) bsn%name, prog` | WRITE | Write basin name and program name |
| src/header_mgt.f90:11 | `write (2612,*) mgt_hdr` | WRITE | Write column headers |
| src/header_mgt.f90:12 | `write (2612,*) mgt_hdr_unt1` | WRITE | Write units line |

**I/O Sites - Data Output** (abbreviated - multiple files write to 2612):

Key writing routines (partial list):
- src/mgt_sched.f90: Lines 109,116,126,211,238,308,333,350,365,375,391,414,427,441,452,465,482,505,522,531,537,545,563,594
- src/actions.f90: Lines 151,158,252,256,282,290,316,343,382,389,398,483,513,601,663,739,803,821,841,878,1127,1145
- src/wallo_control.f90: Line 169
- src/mallo_control.f90: Line 70

All write operations follow format: `write (2612, *) <management event data>`

### 2.4 aquifer.out

**Opening Routine**: `header_aquifer`  
**File**: src/header_aquifer.f90  
**Writing Routine**: `aquifer_output`  
**File**: src/aquifer_output.f90

**I/O Sites - Headers**:

| Unit | Filename | Open Line | Description |
|------|----------|-----------|-------------|
| 2520 | "aquifer_day.txt" | src/header_aquifer.f90:13 | Daily output (text) |
| 2524 | "aquifer_day.csv" | src/header_aquifer.f90:19 | Daily output (CSV) |
| 2521 | "aquifer_mon.txt" | src/header_aquifer.f90:30 | Monthly output (text) |
| 2525 | "aquifer_mon.csv" | src/header_aquifer.f90:36 | Monthly output (CSV) |
| 2522 | "aquifer_yr.txt" | src/header_aquifer.f90:47 | Yearly output (text) |
| 2526 | "aquifer_yr.csv" | src/header_aquifer.f90:53 | Yearly output (CSV) |
| 2523 | "aquifer_aa.txt" | src/header_aquifer.f90:64 | Average annual (text) |
| 2527 | "aquifer_aa.csv" | src/header_aquifer.f90:70 | Average annual (CSV) |

**I/O Sites - Data Output**:

| Line | Statement | Type | Description |
|------|-----------|------|-------------|
| src/aquifer_output.f90:22 | `write (2520,100) ...` | WRITE | Daily aquifer data (text) |
| src/aquifer_output.f90:24 | `write (2524,'(*(G0.3,:","))') ...` | WRITE | Daily aquifer data (CSV) |
| src/aquifer_output.f90:37 | `write (2521,100) ...` | WRITE | Monthly aquifer data (text) |
| src/aquifer_output.f90:39 | `write (2525,'(*(G0.3,:","))') ...` | WRITE | Monthly aquifer data (CSV) |
| src/aquifer_output.f90:52 | `write (2522,102) ...` | WRITE | Yearly aquifer data (text) |
| src/aquifer_output.f90:54 | `write (2526,'(*(G0.3,:","))') ...` | WRITE | Yearly aquifer data (CSV) |
| src/aquifer_output.f90:64 | `write (2523,102) ...` | WRITE | Avg annual aquifer data (text) |
| src/aquifer_output.f90:66 | `write (2527,'(*(G0.3,:","))') ...` | WRITE | Avg annual aquifer data (CSV) |

---

## 3. Read/Write Payload Map

### 3.1 aquifer.aqu (INPUT)

#### Read Statement 1: Title Line
**Location**: src/aqu_read.f90:31  
**Statement**: `read (107,*,iostat=eof) titldum`  
**Format**: List-directed (free format)

**Variable**: `titldum`
- **Name**: titldum
- **Scope**: Local variable
- **Type**: character(len=80)
- **Default**: "" (empty string)
- **Units**: N/A (text)
- **Description**: Title or description line from file
- **Declared at**: src/aqu_read.f90:11

#### Read Statement 2: Header Line
**Location**: src/aqu_read.f90:33  
**Statement**: `read (107,*,iostat=eof) header`  
**Format**: List-directed (free format)

**Variable**: `header`
- **Name**: header
- **Scope**: Local variable
- **Type**: character(len=500)
- **Default**: "" (empty string)
- **Units**: N/A (text)
- **Description**: Column header line
- **Declared at**: src/aqu_read.f90:10

#### Read Statement 3: Aquifer ID (First Pass)
**Location**: src/aqu_read.f90:36  
**Statement**: `read (107,*,iostat=eof) i`  
**Format**: List-directed (free format)

**Variable**: `i`
- **Name**: i
- **Scope**: Local variable
- **Type**: integer
- **Default**: 0
- **Units**: none (counter/ID)
- **Description**: Aquifer record ID
- **Declared at**: src/aqu_read.f90:13

#### Read Statement 4: Title Line (After Rewind)
**Location**: src/aqu_read.f90:45  
**Statement**: `read (107,*,iostat=eof) titldum`  
**Format**: List-directed (free format)

(Same variable details as Read Statement 1)

#### Read Statement 5: Header Line (After Rewind)
**Location**: src/aqu_read.f90:47  
**Statement**: `read (107,*,iostat=eof) header`  
**Format**: List-directed (free format)

(Same variable details as Read Statement 2)

#### Read Statement 6: Aquifer ID (Second Pass)
**Location**: src/aqu_read.f90:51  
**Statement**: `read (107,*,iostat=eof) i`  
**Format**: List-directed (free format)

(Same variable details as Read Statement 3)

#### Read Statement 7: Full Aquifer Record (PRIMARY DATA READ)
**Location**: src/aqu_read.f90:55  
**Statement**: `read (107,*,iostat=eof) k, aqudb(i)`  
**Format**: List-directed (free format)

**Variable 1**: `k`
- **Name**: k
- **Scope**: Local variable
- **Type**: integer
- **Default**: 0
- **Units**: none (index)
- **Description**: Aquifer index/ID
- **Declared at**: src/aqu_read.f90:18

**Variable 2**: `aqudb(i)`
- **Name**: aqudb (array element i)
- **Scope**: Module variable (imported from aquifer_module)
- **Type**: aquifer_database (derived type)
- **Allocated at**: src/aqu_read.f90:43
- **Declared at**: src/aquifer_module.f90:24

**Derived Type Definition: aquifer_database**  
**Location**: src/aquifer_module.f90:5-23  
**I/O Method**: List-directed (default sequential component read)

| Component | Type | Default | Units | Description | Line |
|-----------|------|---------|-------|-------------|------|
| aqunm | character(len=16) | "" | N/A | Aquifer name | 6 |
| aqu_ini | character(len=16) | "" | N/A | Initial aquifer data - points to name in initial.aqu | 7 |
| flo | real | 0.05 | mm | Flow from aquifer in current time step | 8 |
| dep_bot | real | 0. | m | Depth from mid-slope surface to bottom of aquifer | 9 |
| dep_wt | real | 0. | m | Depth from mid-slope surface to water table (initial) | 10 |
| no3 | real | 0. | ppm NO3-N | Nitrate-N concentration in aquifer (initial) | 11 |
| minp | real | 0. | ppm P | Mineral phosphorus concentration in aquifer (initial) | 12 |
| cbn | real | 0.5 | percent | Organic carbon in aquifer (initial) | 13 |
| flo_dist | real | 50. | m | Average flow distance to stream or object | 14 |
| bf_max | real | 0. | mm | Maximum daily baseflow - when all channels are contributing | 15 |
| alpha | real | 0. | 1/days | Lag factor for groundwater recession curve | 16 |
| revap_co | real | 0. | dimensionless | Revap coefficient - evap=pet*revap_co | 17 |
| seep | real | 0. | frac | Fraction of recharge that seeps from aquifer | 18 |
| spyld | real | 0. | m³/m³ | Specific yield of aquifer | 19 |
| hlife_n | real | 30. | days | Half-life of nitrogen in groundwater | 20 |
| flo_min | real | 0. | m | Water table depth for return flow to occur | 21 |
| revap_min | real | 0. | m | Water table depth for revap to occur | 22 |

**Note on I/O**: The derived type `aquifer_database` does **NOT** have user-defined I/O. Therefore, list-directed READ reads components sequentially in declaration order. The input file must provide 17 values per record (after the ID `k`):
1. aqunm (character)
2. aqu_ini (character)
3. flo (real)
4. dep_bot (real)
5. dep_wt (real)
6. no3 (real)
7. minp (real)
8. cbn (real)
9. flo_dist (real)
10. bf_max (real)
11. alpha (real)
12. revap_co (real)
13. seep (real)
14. spyld (real)
15. hlife_n (real)
16. flo_min (real)
17. revap_min (real)

#### PRIMARY DATA READ Table

**Read Statement**: `read (107,*,iostat=eof) k, aqudb(i)` at src/aqu_read.f90:55

| Position in File | Local (Y/N) | Derived Type Name | Component (or Var Name if Local) | Type | Default | Units | Description |
|------------------|-------------|-------------------|-----------------------------------|------|---------|-------|-------------|
| 1 | Y | N/A | k | integer | 0 | none | Aquifer index/ID |
| 2 | N | aqudb | aqunm | character(len=16) | "" | N/A | Aquifer name |
| 3 | N | aqudb | aqu_ini | character(len=16) | "" | N/A | Initial aquifer data - points to name in initial.aqu |
| 4 | N | aqudb | flo | real | 0.05 | mm | Flow from aquifer in current time step |
| 5 | N | aqudb | dep_bot | real | 0. | m | Depth from mid-slope surface to bottom of aquifer |
| 6 | N | aqudb | dep_wt | real | 0. | m | Depth from mid-slope surface to water table (initial) |
| 7 | N | aqudb | no3 | real | 0. | ppm NO3-N | Nitrate-N concentration in aquifer (initial) |
| 8 | N | aqudb | minp | real | 0. | ppm P | Mineral phosphorus concentration in aquifer (initial) |
| 9 | N | aqudb | cbn | real | 0.5 | percent | Organic carbon in aquifer (initial) |
| 10 | N | aqudb | flo_dist | real | 50. | m | Average flow distance to stream or object |
| 11 | N | aqudb | bf_max | real | 0. | mm | Maximum daily baseflow - when all channels are contributing |
| 12 | N | aqudb | alpha | real | 0. | 1/days | Lag factor for groundwater recession curve |
| 13 | N | aqudb | revap_co | real | 0. | dimensionless | Revap coefficient - evap=pet*revap_co |
| 14 | N | aqudb | seep | real | 0. | frac | Fraction of recharge that seeps from aquifer |
| 15 | N | aqudb | spyld | real | 0. | m³/m³ | Specific yield of aquifer |
| 16 | N | aqudb | hlife_n | real | 30. | days | Half-life of nitrogen in groundwater |
| 17 | N | aqudb | flo_min | real | 0. | m | Water table depth for return flow to occur |
| 18 | N | aqudb | revap_min | real | 0. | m | Water table depth for revap to occur |


---

### 3.2 object.cnt (INPUT)

#### Read Statement 1: Title Line
**Location**: src/basin_read_objs.f90:34  
**Statement**: `read (107,*,iostat=eof) titldum`  
**Format**: List-directed (free format)

**Variable**: `titldum`
- **Name**: titldum
- **Scope**: Local variable
- **Type**: character(len=80)
- **Default**: "" (empty string)
- **Units**: N/A (text)
- **Description**: Title of file
- **Declared at**: src/basin_read_objs.f90:17

#### Read Statement 2: Header Line
**Location**: src/basin_read_objs.f90:36  
**Statement**: `read (107,*,iostat=eof) header`  
**Format**: List-directed (free format)

**Variable**: `header`
- **Name**: header
- **Scope**: Local variable
- **Type**: character(len=80)
- **Default**: "" (empty string)
- **Units**: N/A (text)
- **Description**: Header line
- **Declared at**: src/basin_read_objs.f90:18

#### Read Statement 3: Basin and Spatial Object Counts
**Location**: src/basin_read_objs.f90:38  
**Statement**: `read (107,*,iostat=eof) bsn, sp_ob`  
**Format**: List-directed (free format)

**Variable 1**: `bsn`
- **Name**: bsn
- **Scope**: Module variable (imported from basin_module)
- **Type**: basin_inputs (derived type)
- **Declared at**: src/basin_module.f90:14

**Derived Type: basin_inputs**  
**Location**: src/basin_module.f90:9-13

| Component | Type | Default | Units | Description | Line |
|-----------|------|---------|-------|-------------|------|
| name | character(len=25) | "" | N/A | Basin name | 10 |
| area_ls_ha | real | 0. | ha | Land surface area | 11 |
| area_tot_ha | real | 0. | ha | Total area | 12 |

**Variable 2**: `sp_ob`
- **Name**: sp_ob
- **Scope**: Module variable (imported from hydrograph_module)
- **Type**: spatial_objects (derived type)
- **Declared at**: src/hydrograph_module.f90:472

**Derived Type: spatial_objects**  
**Location**: src/hydrograph_module.f90:451-471

| Component | Type | Default | Units | Description | Line |
|-----------|------|---------|-------|-------------|------|
| objs | integer | 0 | none | Number of objects or 1st object command | 452 |
| hru | integer | 0 | none | Number of HRUs or 1st HRU command | 453 |
| hru_lte | integer | 0 | none | Number of HRU_LTEs or 1st HRU_LTE command | 454 |
| ru | integer | 0 | none | Number of routing units or 1st RU command | 456 |
| gwflow | integer | 0 | none | Number of gwflow objects or 1st gwflow command | 457 |
| aqu | integer | 0 | none | Number of aquifers or 1st aquifer command | 458 |
| chan | integer | 0 | none | Number of channels or 1st channel command | 459 |
| res | integer | 0 | none | Number of reservoirs or 1st reservoir command | 460 |
| recall | integer | 0 | none | Number of recall points or 1st recall command | 461 |
| exco | integer | 0 | none | Number of export coefficients or 1st exco command | 462 |
| dr | integer | 0 | none | Number of delivery ratios or 1st DR command | 463 |
| canal | integer | 0 | none | Number of canals or 1st canal command | 464 |
| pump | integer | 0 | none | Number of pumps or 1st pump command | 465 |
| outlet | integer | 0 | none | Number of outlets or 1st outlet command | 466 |
| chandeg | integer | 0 | none | Number of SWAT-DEG channels or 1st SWAT-DEG channel command | 467 |
| aqu2d | integer | 0 | none | Not currently used (number of 2D aquifers) | 468 |
| herd | integer | 0 | none | Not currently used (number of herds) | 469 |
| wro | integer | 0 | none | Not currently used (number of water rights) | 470 |

**Note on I/O**: Both `basin_inputs` and `spatial_objects` do **NOT** have user-defined I/O. List-directed READ reads components sequentially. The input file must provide:
- 3 values for bsn (name, area_ls_ha, area_tot_ha)
- 17 values for sp_ob (objs through wro)
- **Total: 20 values** in one record

#### PRIMARY DATA READ Table

**Read Statement**: `read (107,*,iostat=eof) bsn, sp_ob` at src/basin_read_objs.f90:38

| Position in File | Local (Y/N) | Derived Type Name | Component (or Var Name if Local) | Type | Default | Units | Description |
|------------------|-------------|-------------------|-----------------------------------|------|---------|-------|-------------|
| 1 | N | bsn | name | character(len=25) | "" | N/A | Basin name |
| 2 | N | bsn | area_ls_ha | real | 0. | ha | Land surface area |
| 3 | N | bsn | area_tot_ha | real | 0. | ha | Total area |
| 4 | N | sp_ob | objs | integer | 0 | none | Number of objects or 1st object command |
| 5 | N | sp_ob | hru | integer | 0 | none | Number of HRUs or 1st HRU command |
| 6 | N | sp_ob | hru_lte | integer | 0 | none | Number of HRU_LTEs or 1st HRU_LTE command |
| 7 | N | sp_ob | ru | integer | 0 | none | Number of routing units or 1st RU command |
| 8 | N | sp_ob | gwflow | integer | 0 | none | Number of gwflow objects or 1st gwflow command |
| 9 | N | sp_ob | aqu | integer | 0 | none | Number of aquifers or 1st aquifer command |
| 10 | N | sp_ob | chan | integer | 0 | none | Number of channels or 1st channel command |
| 11 | N | sp_ob | res | integer | 0 | none | Number of reservoirs or 1st reservoir command |
| 12 | N | sp_ob | recall | integer | 0 | none | Number of recall points or 1st recall command |
| 13 | N | sp_ob | exco | integer | 0 | none | Number of export coefficients or 1st exco command |
| 14 | N | sp_ob | dr | integer | 0 | none | Number of delivery ratios or 1st DR command |
| 15 | N | sp_ob | canal | integer | 0 | none | Number of canals or 1st canal command |
| 16 | N | sp_ob | pump | integer | 0 | none | Number of pumps or 1st pump command |
| 17 | N | sp_ob | outlet | integer | 0 | none | Number of outlets or 1st outlet command |
| 18 | N | sp_ob | chandeg | integer | 0 | none | Number of SWAT-DEG channels or 1st SWAT-DEG channel command |
| 19 | N | sp_ob | aqu2d | integer | 0 | none | Not currently used (number of 2D aquifers) |
| 20 | N | sp_ob | herd | integer | 0 | none | Not currently used (number of herds) |
| 21 | N | sp_ob | wro | integer | 0 | none | Not currently used (number of water rights) |


---

### 3.3 mgt.out (OUTPUT)

#### Write Statement 1: Basin Name and Program
**Location**: src/header_mgt.f90:10  
**Statement**: `write (2612,*) bsn%name, prog`  
**Format**: List-directed (free format)

**Variable 1**: `bsn%name`
- **Component**: name of bsn
- **Type**: character(len=25)
- **Description**: Basin name
- **Parent Type**: basin_inputs at src/basin_module.f90:9-13

**Variable 2**: `prog`
- **Name**: prog
- **Scope**: Module variable (from basin_module)
- **Type**: character(len=80)
- **Default**: "" (empty string)
- **Description**: Program identifier string
- **Declared at**: src/basin_module.f90:5

#### Write Statement 2: Management Headers
**Location**: src/header_mgt.f90:11  
**Statement**: `write (2612,*) mgt_hdr`  
**Format**: List-directed (free format)

**Variable**: `mgt_hdr`
- **Name**: mgt_hdr
- **Scope**: Module variable (from basin_module)
- **Type**: mgt_header (derived type)
- **Declared at**: src/basin_module.f90:287

**Derived Type: mgt_header**  
**Location**: src/basin_module.f90:264-286

| Component | Type | Default | Description | Line |
|-----------|------|---------|-------------|------|
| hru | character(len=12) | "        hru" | HRU column header | 265 |
| year | character(len=12) | "       year" | Year column header | 266 |
| mon | character(len=12) | "        mon" | Month column header | 267 |
| day | character(len=11) | "        day" | Day column header | 268 |
| crop | character(len=15) | " crop/fert/pest" | Crop/fert/pest column header | 269 |
| oper | character(len=12) | " operation" | Operation column header | 270 |
| phub | character(len=12) | "phubase" | PHU base column header | 271 |
| phua | character(len=11) | "   phuplant" | PHU plant column header | 272 |
| sw | character(len=12) | "  soil_water" | Soil water column header | 273 |
| bio | character(len=17) | "      plant_bioms" | Plant biomass column header | 274 |
| rsd | character(len=11) | "   surf_rsd" | Surface residue column header | 275 |
| solno3 | character(len=15) | "       soil_no3" | Soil NO3 column header | 276 |
| solp | character(len=15) | "      soil_solp" | Soil soluble P column header | 277 |
| op_var | character(len=15) | "         op_var" | Operation variable column header | 278 |
| var1 | character(len=15) | "           var1" | Variable 1 column header | 279 |
| var2 | character(len=14) | "          var2" | Variable 2 column header | 280 |
| var3 | character(len=17) | "             var3" | Variable 3 column header | 281 |
| var4 | character(len=17) | "             var4" | Variable 4 column header | 282 |
| var5 | character(len=16) | "            var5" | Variable 5 column header | 283 |
| var6 | character(len=16) | "            var6" | Variable 6 column header | 284 |
| var7 | character(len=16) | "           var7" | Variable 7 column header | 285 |

#### Write Statement 3: Management Units
**Location**: src/header_mgt.f90:12  
**Statement**: `write (2612,*) mgt_hdr_unt1`  
**Format**: List-directed (free format)

**Variable**: `mgt_hdr_unt1`
- **Name**: mgt_hdr_unt1
- **Scope**: Module variable (from basin_module)
- **Type**: mgt_header_unit1 (derived type)
- **Declared at**: src/basin_module.f90:312

**Derived Type: mgt_header_unit1**  
**Location**: src/basin_module.f90:289-311  
(Similar structure to mgt_header but contains units instead of names - e.g., "deg_c", "mm", "kg/ha")

#### Write Statements: Management Event Data
**Multiple Locations**: Various management operation write statements

**Example Location**: src/mgt_sched.f90:116  
**Statement**: `write (2612, *) j, time%yrc, time%mo, time%day_mo, pldb(idp)%plantnm, "    PLANT ", ...`

**Common Variables written** (varies by operation):
1. `j` - HRU number (integer) - local loop counter
2. `time%yrc` - Year (integer) - from time_module
3. `time%mo` - Month (integer) - from time_module
4. `time%day_mo` - Day of month (integer) - from time_module
5. Operation identifier - Plant name, fertilizer name, etc. (character)
6. Operation type - Literal string (character) - "PLANT", "TILLAGE", "FERT", etc.
7-20. Operation-specific variables (real) - PHU, soil water, biomass, nutrients, etc.

**Note**: Different management operations write different sets of variables, but all follow the general format of date/location, operation type, and operation-specific data.


---

### 3.4 aquifer.out (OUTPUT)

#### Write Statements: Aquifer Output Data
**Location**: src/aquifer_output.f90:22 (daily), 37 (monthly), 52 (yearly), 64 (avg annual)  
**Format**: Format 100/102 (formatted) or CSV (list-directed with comma separator)

**Example Statement (Daily Text)**: src/aquifer_output.f90:22  
**Statement**: `write (2520,100) time%day, time%mo, time%day_mo, time%yrc, iaq, ob(iob)%gis_id, ob(iob)%name, aqu_d(iaq)`

**Variables written** (in order):

1. **time%day** (integer) - Julian day
   - Type: integer
   - Units: day of year (1-366)
   - Parent: time (module variable from time_module)

2. **time%mo** (integer) - Month
   - Type: integer
   - Units: month (1-12)
   - Parent: time

3. **time%day_mo** (integer) - Day of month
   - Type: integer
   - Units: day (1-31)
   - Parent: time

4. **time%yrc** (integer) - Year
   - Type: integer
   - Units: calendar year
   - Parent: time

5. **iaq** (integer) - Aquifer number
   - Type: integer
   - Units: none (counter)
   - Scope: Subroutine parameter

6. **ob(iob)%gis_id** (integer*8) - GIS ID
   - Type: integer*8
   - Units: none (ID)
   - Parent: object_connectivity type at src/hydrograph_module.f90:342

7. **ob(iob)%name** (character) - Object name
   - Type: character(len=16)
   - Units: N/A
   - Parent: object_connectivity type at src/hydrograph_module.f90:322

8. **aqu_d(iaq)** - Aquifer dynamic data (derived type)
   - Type: aquifer_dynamic
   - Scope: Module variable (from aquifer_module)
   - Declared at: src/aquifer_module.f90:56

**Derived Type: aquifer_dynamic**  
**Location**: src/aquifer_module.f90:36-54

| Component | Type | Default | Units | Description | Line |
|-----------|------|---------|-------|-------------|------|
| flo | real | 0. | mm | Lateral flow from aquifer | 37 |
| dep_wt | real | 0. | m | Average depth from average surface elevation to water table | 38 |
| stor | real | 0. | mm | Average water storage in aquifer in timestep | 39 |
| rchrg | real | 0. | mm | Recharge entering aquifer from other objects | 40 |
| seep | real | 0. | mm | Seepage from bottom of aquifer | 41 |
| revap | real | 0. | mm | Plant water uptake and evaporation | 42 |
| no3_st | real | 0. | kg/ha N | Current total NO3-N mass in aquifer | 43 |
| minp | real | 0. | kg/ha P | Mineral phosphorus transported in return (lateral) flow | 44 |
| cbn | real | 0. | percent | Organic carbon in aquifer - currently static | 45 |
| orgn | real | 0. | kg/ha P | Organic nitrogen in aquifer - currently static | 46 |
| no3_rchg | real | 0. | kg/ha N | Nitrate NO3-N flowing into aquifer from another object | 47 |
| no3_loss | real | 0. | kg/ha | Nitrate NO3-N loss | 48 |
| no3_lat | real | 0. | kg/ha N | Nitrate loading to reach in groundwater | 49 |
| no3_seep | real | 0. | kg/ha N | Seepage of NO3 to next object | 50 |
| flo_cha | real | 0. | mm H2O | Surface runoff flowing into channels | 51 |
| flo_res | real | 0. | mm H2O | Surface runoff flowing into reservoirs | 52 |
| flo_ls | real | 0. | mm H2O | Surface runoff flowing into a landscape element (HRU or RU) | 53 |

**Note on I/O**: The derived type `aquifer_dynamic` does **NOT** have user-defined I/O. Therefore, formatted WRITE (format 100) writes all 17 components sequentially. The output record contains date/ID information followed by 17 aquifer state/flux values.

**Format Statements**:
- Format 100 (src/aquifer_output.f90:72): `format (4i6,2i8,2x,a,20f15.3)` - Daily/Monthly
- Format 102 (src/aquifer_output.f90:73): `format (4i6,2i8,2x,a,20f15.3)` - Yearly/Avg Annual


---

## 4. file.cio (Master Configuration File - INPUT)

### 4.1 Filename Resolution

**Resolution Chain**:
- Target filename: `file.cio`
- Expression: String literal "file.cio"
- Opening location: src/readcio_read.f90:22
- No default value override mechanism - hardcoded filename
- Runtime overrides: None

**Detailed Mapping**:
```
file.cio → Hardcoded string literal in readcio_read
         → open (107,file="file.cio") (src/readcio_read.f90:22)
```

### 4.2 I/O Sites and Unit Mappings

**Routine**: `readcio_read`  
**File**: src/readcio_read.f90  
**Expression**: "file.cio" (string literal)  
**Unit mapping**: 107 → "file.cio"

**I/O Sites**:

| Line | Statement | Type | Description |
|------|-----------|------|-------------|
| 20 | `inquire (file="file.cio", exist=i_exist)` | INQUIRE | Check file existence |
| 22 | `open (107,file="file.cio")` | OPEN | Open master configuration file |
| 23 | `read (107,*) titldum` | READ | Read title line |
| 25 | `read (107,*,iostat=eof) name, in_sim` | READ | Read simulation file names |
| 27 | `read (107,*,iostat=eof) name, in_basin` | READ | Read basin file names |
| 29 | `read (107,*,iostat=eof) name, in_cli` | READ | Read climate file names |
| 31 | `read (107,*,iostat=eof) name, in_con` | READ | Read connection file names |
| 33 | `read (107,*,iostat=eof) name, in_cha` | READ | Read channel file names |
| 35 | `read (107,*,iostat=eof) name, in_res` | READ | Read reservoir file names |
| 37 | `read (107,*,iostat=eof) name, in_ru` | READ | Read routing unit file names |
| 39 | `read (107,*,iostat=eof) name, in_hru` | READ | Read HRU file names |
| 41 | `read (107,*,iostat=eof) name, in_exco` | READ | Read export coefficient file names |
| 43 | `read (107,*,iostat=eof) name, in_rec` | READ | Read recall file names |
| 45 | `read (107,*,iostat=eof) name, in_delr` | READ | Read delivery ratio file names |
| 47 | `read (107,*,iostat=eof) name, in_aqu` | READ | Read aquifer file names |
| 49 | `read (107,*,iostat=eof) name, in_herd` | READ | Read herd file names |
| 51 | `read (107,*,iostat=eof) name, in_watrts` | READ | Read water rights file names |
| 53 | `read (107,*,iostat=eof) name, in_link` | READ | Read link file names |
| 55 | `read (107,*,iostat=eof) name, in_hyd` | READ | Read hydrology file names |
| 57 | `read (107,*,iostat=eof) name, in_str` | READ | Read structural file names |
| 59 | `read (107,*,iostat=eof) name, in_parmdb` | READ | Read parameter database file names |
| 61 | `read (107,*,iostat=eof) name, in_ops` | READ | Read operation scheduling file names |
| 63 | `read (107,*,iostat=eof) name, in_lum` | READ | Read land use management file names |
| 65 | `read (107,*,iostat=eof) name, in_chg` | READ | Read calibration change file names |
| 67 | `read (107,*,iostat=eof) name, in_init` | READ | Read initial conditions file names |
| 69 | `read (107,*,iostat=eof) name, in_sol` | READ | Read soils file names |
| 71 | `read (107,*,iostat=eof) name, in_cond` | READ | Read conditional file names |
| 73 | `read (107,*,iostat=eof) name, in_regs` | READ | Read regions file names |
| 76 | `read (107,*,iostat=eof) name, in_path_pcp` | READ | Read precipitation path |
| 78 | `read (107,*,iostat=eof) name, in_path_tmp` | READ | Read temperature path |
| 80 | `read (107,*,iostat=eof) name, in_path_slr` | READ | Read solar radiation path |
| 82 | `read (107,*,iostat=eof) name, in_path_hmd` | READ | Read humidity path |
| 84 | `read (107,*,iostat=eof) name, in_path_wnd` | READ | Read wind path |
| 89 | `read (107,'(A)',iostat=eof) line_buffer` | READ | Read output path (formatted) |
| 109 | `close (107)` | CLOSE | Close file |

**Note**: The routine reads 31 configuration structures in sequence, each prefixed by a label name.

### 4.3 Read/Write Payload Map

#### Read Statement 1: Title Line
**Location**: src/readcio_read.f90:23  
**Statement**: `read (107,*) titldum`  
**Format**: List-directed (free format)

**Variable**: `titldum`
- **Name**: titldum
- **Scope**: Local variable
- **Type**: character(len=80)
- **Default**: "" (empty string)
- **Units**: N/A (text)
- **Description**: Title or description line from file
- **Declared at**: src/readcio_read.f90:8

#### PRIMARY DATA READ Table

**Overview**: file.cio contains 31 configuration records, each reading a derived type that holds input filenames for different model components. Each record format: `<label> <filename_structure>`

The table below shows the sequence of reads. Each derived type contains multiple character(len=25) or character(len=80) components representing individual input filenames.

| Position | Local (Y/N) | Label Variable | Derived Type Name | Type Instance | Components Count | Declared At |
|----------|-------------|----------------|-------------------|---------------|------------------|-------------|
| 0 | Y | titldum | N/A | N/A | N/A | src/readcio_read.f90:8 |
| 1 | Y | name | N/A | N/A | N/A | src/readcio_read.f90:9 |
| 1 | N | N/A | input_sim | in_sim | 5 | src/input_file_module.f90:8-15 |
| 2 | Y | name | N/A | N/A | N/A | src/readcio_read.f90:9 |
| 2 | N | N/A | input_basin | in_basin | 2 | src/input_file_module.f90:18-22 |
| 3 | Y | name | N/A | N/A | N/A | src/readcio_read.f90:9 |
| 3 | N | N/A | input_cli | in_cli | 10 | src/input_file_module.f90:25-37 |
| 4 | Y | name | N/A | N/A | N/A | src/readcio_read.f90:9 |
| 4 | N | N/A | input_con | in_con | 13 | src/input_file_module.f90:40-55 |
| 5 | Y | name | N/A | N/A | N/A | src/readcio_read.f90:9 |
| 5 | N | N/A | input_cha | in_cha | 8 | src/input_file_module.f90:58-68 |
| 6 | Y | name | N/A | N/A | N/A | src/readcio_read.f90:9 |
| 6 | N | N/A | input_res | in_res | 8 | src/input_file_module.f90:71-81 |
| 7 | Y | name | N/A | N/A | N/A | src/readcio_read.f90:9 |
| 7 | N | N/A | input_ru | in_ru | 4 | src/input_file_module.f90:84-90 |
| 8 | Y | name | N/A | N/A | N/A | src/readcio_read.f90:9 |
| 8 | N | N/A | input_hru | in_hru | 2 | src/input_file_module.f90:93-97 |
| 9 | Y | name | N/A | N/A | N/A | src/readcio_read.f90:9 |
| 9 | N | N/A | input_exco | in_exco | 6 | src/input_file_module.f90:100-108 |
| 10 | Y | name | N/A | N/A | N/A | src/readcio_read.f90:9 |
| 10 | N | N/A | input_rec | in_rec | 1 | src/input_file_module.f90:111-114 |
| 11 | Y | name | N/A | N/A | N/A | src/readcio_read.f90:9 |
| 11 | N | N/A | input_delr | in_delr | 6 | src/input_file_module.f90:117-125 |
| 12 | Y | name | N/A | N/A | N/A | src/readcio_read.f90:9 |
| 12 | N | N/A | input_aqu | in_aqu | 2 | src/input_file_module.f90:128-132 |
| 13 | Y | name | N/A | N/A | N/A | src/readcio_read.f90:9 |
| 13 | N | N/A | input_herd | in_herd | 3 | src/input_file_module.f90:135-140 |
| 14 | Y | name | N/A | N/A | N/A | src/readcio_read.f90:9 |
| 14 | N | N/A | input_water_rights | in_watrts | 3 | src/input_file_module.f90:143-148 |
| 15 | Y | name | N/A | N/A | N/A | src/readcio_read.f90:9 |
| 15 | N | N/A | input_link | in_link | 2 | src/input_file_module.f90:151-155 |
| 16 | Y | name | N/A | N/A | N/A | src/readcio_read.f90:9 |
| 16 | N | N/A | input_hydrology | in_hyd | 3 | src/input_file_module.f90:158-163 |
| 17 | Y | name | N/A | N/A | N/A | src/readcio_read.f90:9 |
| 17 | N | N/A | input_structural | in_str | 5 | src/input_file_module.f90:166-173 |
| 18 | Y | name | N/A | N/A | N/A | src/readcio_read.f90:9 |
| 18 | N | N/A | input_parameter_databases | in_parmdb | 10 | src/input_file_module.f90:176-188 |
| 19 | Y | name | N/A | N/A | N/A | src/readcio_read.f90:9 |
| 19 | N | N/A | input_ops | in_ops | 6 | src/input_file_module.f90:191-199 |
| 20 | Y | name | N/A | N/A | N/A | src/readcio_read.f90:9 |
| 20 | N | N/A | input_lum | in_lum | 5 | src/input_file_module.f90:202-209 |
| 21 | Y | name | N/A | N/A | N/A | src/readcio_read.f90:9 |
| 21 | N | N/A | input_chg | in_chg | 9 | src/input_file_module.f90:212-223 |
| 22 | Y | name | N/A | N/A | N/A | src/readcio_read.f90:9 |
| 22 | N | N/A | input_init | in_init | 11 | src/input_file_module.f90:226-239 |
| 23 | Y | name | N/A | N/A | N/A | src/readcio_read.f90:9 |
| 23 | N | N/A | input_soils | in_sol | 3 | src/input_file_module.f90:242-247 |
| 24 | Y | name | N/A | N/A | N/A | src/readcio_read.f90:9 |
| 24 | N | N/A | input_condition | in_cond | 4 | src/input_file_module.f90:250-256 |
| 25 | Y | name | N/A | N/A | N/A | src/readcio_read.f90:9 |
| 25 | N | N/A | input_regions | in_regs | 17 | src/input_file_module.f90:259-278 |
| 26 | Y | name | N/A | N/A | N/A | src/readcio_read.f90:9 |
| 26 | N | N/A | input_path_pcp | in_path_pcp | 1 | src/input_file_module.f90:280-283 |
| 27 | Y | name | N/A | N/A | N/A | src/readcio_read.f90:9 |
| 27 | N | N/A | input_path_tmp | in_path_tmp | 1 | src/input_file_module.f90:285-288 |
| 28 | Y | name | N/A | N/A | N/A | src/readcio_read.f90:9 |
| 28 | N | N/A | input_path_slr | in_path_slr | 1 | src/input_file_module.f90:290-293 |
| 29 | Y | name | N/A | N/A | N/A | src/readcio_read.f90:9 |
| 29 | N | N/A | input_path_hmd | in_path_hmd | 1 | src/input_file_module.f90:295-298 |
| 30 | Y | name | N/A | N/A | N/A | src/readcio_read.f90:9 |
| 30 | N | N/A | input_path_wnd | in_path_wnd | 1 | src/input_file_module.f90:300-303 |
| 31 | Y | line_buffer | N/A | N/A | N/A | src/readcio_read.f90:11 |

**Note**: Position 0 is the title line. Positions 1-30 each read a label (name) followed by a derived type structure. Position 31 reads the output path using formatted I/O to handle spaces in paths.

**Total Components**: The 30 derived types contain 145+ individual filename components in total.

### 4.4 Key Components Detail (Selected Examples)

#### Example 1: in_sim (Position 1)
**Type**: input_sim (src/input_file_module.f90:8-15)  
**Components**:

| Component | Type | Default | Description | Line |
|-----------|------|---------|-------------|------|
| time | character(len=25) | "time.sim" | Simulation time configuration | 9 |
| prt | character(len=25) | "print.prt" | Print configuration | 10 |
| object_prt | character(len=25) | "object.prt" | Object print configuration | 11 |
| object_cnt | character(len=25) | "object.cnt" | Object count file (documented in Phase 1) | 12 |
| cs_db | character(len=25) | "constituents.cs" | Constituents database | 13 |

#### Example 2: in_aqu (Position 12)
**Type**: input_aqu (src/input_file_module.f90:128-132)  
**Components**:

| Component | Type | Default | Description | Line |
|-----------|------|---------|-------------|------|
| init | character(len=25) | "initial.aqu" | Initial aquifer conditions | 129 |
| aqu | character(len=25) | "aquifer.aqu" | Aquifer parameters (documented in Phase 1) | 130 |

#### Example 3: in_parmdb (Position 18)
**Type**: input_parameter_databases (src/input_file_module.f90:176-188)  
**Components**:

| Component | Type | Default | Description | Line |
|-----------|------|---------|-------------|------|
| plants_plt | character(len=25) | "plants.plt" | Plant parameters | 177 |
| fert_frt | character(len=25) | "fertilizer.frt" | Fertilizer parameters | 178 |
| till_til | character(len=25) | "tillage.til" | Tillage parameters | 179 |
| pest | character(len=25) | "pesticide.pes" | Pesticide parameters | 180 |
| pathcom_db | character(len=25) | "pathogens.pth" | Pathogen parameters | 181 |
| hmetcom_db | character(len=25) | "metals.mtl" | Heavy metals parameters | 182 |
| saltcom_db | character(len=25) | "salt.slt" | Salt parameters | 183 |
| urban_urb | character(len=25) | "urban.urb" | Urban parameters | 184 |
| septic_sep | character(len=25) | "septic.sep" | Septic parameters | 185 |
| snow | character(len=25) | "snow.sno" | Snow parameters | 186 |

### 4.5 File Format

**file.cio** is a master configuration file that specifies all input filenames for the SWAT+ model. The format is:

```
<Title Line>
<label1> <simulation filenames...>
<label2> <basin filenames...>
<label3> <climate filenames...>
...
<label30> <wind path>
<label31> <output path>
```

Each label line contains a section identifier followed by the filename(s) for that configuration group. The derived types use list-directed I/O, so components are read sequentially in declaration order.

**Note on I/O**: All derived types use default list-directed I/O (no user-defined read procedures). Each type's components are read in the order they appear in the type definition.


---

## 5. Worked Example: aqu_read Subroutine (aquifer.aqu)

### Overview
The `aqu_read` subroutine reads aquifer parameter data from the `aquifer.aqu` input file. It uses a **two-pass reading strategy** to first determine array sizes, then read the actual data.

### Filename Resolution
- **Expression**: `in_aqu%aqu`
- **Type**: `input_aqu` (src/input_file_module.f90:128-132)
- **Default Value**: `"aquifer.aqu"` (src/input_file_module.f90:130)
- **Variable Instance**: `in_aqu` (src/input_file_module.f90:132)

### Subroutine Flow

#### 1. File Existence Check
**Location**: src/aqu_read.f90:25-27
```fortran
inquire (file=in_aqu%aqu, exist=i_exist)
if (.not. i_exist .or. in_aqu%aqu == "null") then
    allocate (aqudb(0:0))
```
- Checks if aquifer.aqu exists
- If missing or "null", allocates empty array and returns

#### 2. First Pass - Count Records and Find Maximum ID
**Location**: src/aqu_read.f90:30-40
```fortran
open (107,file=in_aqu%aqu)
read (107,*,iostat=eof) titldum
read (107,*,iostat=eof) header
do while (eof == 0)
  read (107,*,iostat=eof) i
  if (eof < 0) exit
  imax = Max(imax,i)
  msh_aqp = msh_aqp + 1
end do
```

**Variables**:
- **Unit 107**: Opened to in_aqu%aqu → "aquifer.aqu"
- **titldum** (src/aqu_read.f90:11): character(len=80), title line
- **header** (src/aqu_read.f90:10): character(len=500), column headers
- **i** (src/aqu_read.f90:13): integer, aquifer ID from each record
- **imax** (src/aqu_read.f90:14): integer, maximum aquifer ID found
- **msh_aqp** (src/aqu_read.f90:15): integer, count of aquifer records

**Purpose**: Determines the maximum ID to properly dimension the `aqudb` array.

#### 3. Array Allocation
**Location**: src/aqu_read.f90:42-43
```fortran
db_mx%aqudb = msh_aqp
allocate (aqudb(0:imax))
```

**Variables**:
- **db_mx%aqudb**: integer, stores count for tracking
- **aqudb** (src/aquifer_module.f90:24): Allocated as array from index 0 to imax
  - Type: `aquifer_database`, dimension(:), allocatable
  - Allows sparse indexing (aquifer IDs don't need to be sequential)

#### 4. Second Pass - Read Actual Data
**Location**: src/aqu_read.f90:44-57
```fortran
rewind (107)
read (107,*,iostat=eof) titldum
read (107,*,iostat=eof) header

do ish_aqp = 1, msh_aqp
  read (107,*,iostat=eof) i
  if (eof < 0) exit
  backspace (107)
  read (107,*,iostat=eof) k, aqudb(i)
  if (eof < 0) exit
end do
```

**Key Read Statement (Line 55)**:
```fortran
read (107,*,iostat=eof) k, aqudb(i)
```

**Variable 1: k**
- **Name**: k
- **Type**: integer
- **Default**: 0
- **Units**: none
- **Description**: Aquifer ID (should match i)
- **Declared at**: src/aqu_read.f90:18

**Variable 2: aqudb(i)**
- **Name**: aqudb (array element at index i)
- **Type**: aquifer_database (derived type)
- **Scope**: Module variable from aquifer_module

### Derived Type Expansion: aquifer_database

**Type Definition**: src/aquifer_module.f90:5-23

**Full Component List** (read in declaration order via list-directed I/O):

| # | Component | Type | Default | Units | Description | Declared At |
|---|-----------|------|---------|-------|-------------|-------------|
| 1 | aqunm | character(len=16) | "" | N/A | Aquifer name | src/aquifer_module.f90:6 |
| 2 | aqu_ini | character(len=16) | "" | N/A | Initial aquifer data - points to name in initial.aqu | src/aquifer_module.f90:7 |
| 3 | flo | real | 0.05 | mm | Flow from aquifer in current time step | src/aquifer_module.f90:8 |
| 4 | dep_bot | real | 0. | m | Depth from mid-slope surface to bottom of aquifer | src/aquifer_module.f90:9 |
| 5 | dep_wt | real | 0. | m | Depth from mid-slope surface to water table (initial) | src/aquifer_module.f90:10 |
| 6 | no3 | real | 0. | ppm NO3-N | Nitrate-N concentration in aquifer (initial) | src/aquifer_module.f90:11 |
| 7 | minp | real | 0. | ppm P | Mineral phosphorus concentration in aquifer (initial) | src/aquifer_module.f90:12 |
| 8 | cbn | real | 0.5 | percent | Organic carbon in aquifer (initial) | src/aquifer_module.f90:13 |
| 9 | flo_dist | real | 50. | m | Average flow distance to stream or object | src/aquifer_module.f90:14 |
| 10 | bf_max | real | 0. | mm | Maximum daily baseflow - when all channels are contributing | src/aquifer_module.f90:15 |
| 11 | alpha | real | 0. | 1/days | Lag factor for groundwater recession curve | src/aquifer_module.f90:16 |
| 12 | revap_co | real | 0. | dimensionless | Revap coefficient - evap=pet*revap_co | src/aquifer_module.f90:17 |
| 13 | seep | real | 0. | frac | Fraction of recharge that seeps from aquifer | src/aquifer_module.f90:18 |
| 14 | spyld | real | 0. | m³/m³ | Specific yield of aquifer | src/aquifer_module.f90:19 |
| 15 | hlife_n | real | 30. | days | Half-life of nitrogen in groundwater | src/aquifer_module.f90:20 |
| 16 | flo_min | real | 0. | m | Water table depth for return flow to occur | src/aquifer_module.f90:21 |
| 17 | revap_min | real | 0. | m | Water table depth for revap to occur | src/aquifer_module.f90:22 |

### Input Record Format Mapping

**User-Defined I/O**: NO - The type `aquifer_database` does not have defined I/O procedures.

**List-Directed I/O Behavior**: Components are read sequentially in declaration order.

**Expected Input Record** (one per aquifer):
```
<ID> <aqunm> <aqu_ini> <flo> <dep_bot> <dep_wt> <no3> <minp> <cbn> <flo_dist> <bf_max> <alpha> <revap_co> <seep> <spyld> <hlife_n> <flo_min> <revap_min>
```

**Total Fields**: 18 (1 integer ID + 2 characters + 15 reals)

**Example Input Line**:
```
1 aqu1 aqu_init1 0.05 100.0 5.0 10.0 0.5 0.5 50.0 1.0 0.05 0.02 0.05 0.15 30.0 1.0 2.0
```

This would be read as:
- k = 1
- aqudb(1)%aqunm = "aqu1"
- aqudb(1)%aqu_ini = "aqu_init1"
- aqudb(1)%flo = 0.05
- aqudb(1)%dep_bot = 100.0
- aqudb(1)%dep_wt = 5.0
- aqudb(1)%no3 = 10.0
- aqudb(1)%minp = 0.5
- aqudb(1)%cbn = 0.5
- aqudb(1)%flo_dist = 50.0
- aqudb(1)%bf_max = 1.0
- aqudb(1)%alpha = 0.05
- aqudb(1)%revap_co = 0.02
- aqudb(1)%seep = 0.05
- aqudb(1)%spyld = 0.15
- aqudb(1)%hlife_n = 30.0
- aqudb(1)%flo_min = 1.0
- aqudb(1)%revap_min = 2.0

#### 5. File Close
**Location**: src/aqu_read.f90:59
```fortran
close (107)
```

### Complete Variable Summary

| Variable | Type | Scope | Purpose | Declared At |
|----------|------|-------|---------|-------------|
| in_aqu%aqu | character(len=25) | Module | Filename container, defaults to "aquifer.aqu" | src/input_file_module.f90:130 |
| i_exist | logical | Local | File existence check result | src/aqu_read.f90:16 |
| titldum | character(len=80) | Local | File title line | src/aqu_read.f90:11 |
| header | character(len=500) | Local | Column headers | src/aqu_read.f90:10 |
| eof | integer | Local | I/O status flag | src/aqu_read.f90:12 |
| i | integer | Local | Aquifer ID (loop counter) | src/aqu_read.f90:13 |
| imax | integer | Local | Maximum aquifer ID found | src/aqu_read.f90:14 |
| msh_aqp | integer | Local | Count of aquifer records | src/aqu_read.f90:15 |
| ish_aqp | integer | Local | Loop counter for second pass | src/aqu_read.f90:17 |
| k | integer | Local | Aquifer ID read with data | src/aqu_read.f90:18 |
| aqudb | aquifer_database(:) | Module | Aquifer parameter database array | src/aquifer_module.f90:24 |
| db_mx%aqudb | integer | Module | Count tracker | Located in maximum_data_module |

---

## 6. Summary

### Phase 1 Coverage

This report documents all I/O operations for the four target files:
1. **aquifer.aqu** - Input file read by aqu_read
2. **object.cnt** - Input file read by basin_read_objs
3. **mgt.out** - Output file (mgt_out.txt) written by header_mgt and various management routines
4. **aquifer.out** - Output files (aquifer_day/mon/yr/aa.txt/csv) written by header_aquifer and aquifer_output

### Extended Coverage

5. **file.cio** - Master configuration file read by readcio_read (31 input file structures)

### Key Findings

- All filenames are resolved through module-level derived types with default values
- Unit 107 is reused for different input files (aquifer.aqu, object.cnt, file.cio)
- Output units are unique and persistent (2520-2527 for aquifer, 2612 for management)
- No user-defined I/O is used; all derived types use default list-directed or formatted I/O
- Two-pass reading strategy is used for aquifer.aqu to handle sparse array indexing
- file.cio reads 30+ configuration structures containing 145+ individual filename specifications

### Location Format

All locations follow the format: `relative/path/to/file.f90:line` or `relative/path/to/file.f90:line-range`

---

**End of Report**
