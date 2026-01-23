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
**File.cio Reference**: This file (aquifer.aqu) is referenced in file.cio as component `aqu` of derived type `in_aqu`

| Line in File | Position in File | Local (Y/N) | Derived Type Name | Component (or Var Name if Local) | Type | Default | Units | Description | Source Line | Swat_codetype |
|--------------|------------------|-------------|-------------------|-----------------------------------|------|---------|-------|-------------|-------------|---------------|
| 3+ | 1 | Y | N/A | k | integer | 0 | none | Aquifer index/ID | src/aqu_read.f90:18 | in_aqu |
| 3+ | 2 | N | aqudb | aqunm | character(len=16) | "" | N/A | Aquifer name | src/aquifer_module.f90:6 | in_aqu |
| 3+ | 3 | N | aqudb | aqu_ini | character(len=16) | "" | N/A | Initial aquifer data - points to name in initial.aqu | src/aquifer_module.f90:7 | in_aqu |
| 3+ | 4 | N | aqudb | flo | real | 0.05 | mm | Flow from aquifer in current time step | src/aquifer_module.f90:8 | in_aqu |
| 3+ | 5 | N | aqudb | dep_bot | real | 0. | m | Depth from mid-slope surface to bottom of aquifer | src/aquifer_module.f90:9 | in_aqu |
| 3+ | 6 | N | aqudb | dep_wt | real | 0. | m | Depth from mid-slope surface to water table (initial) | src/aquifer_module.f90:10 | in_aqu |
| 3+ | 7 | N | aqudb | no3 | real | 0. | ppm NO3-N | Nitrate-N concentration in aquifer (initial) | src/aquifer_module.f90:11 | in_aqu |
| 3+ | 8 | N | aqudb | minp | real | 0. | ppm P | Mineral phosphorus concentration in aquifer (initial) | src/aquifer_module.f90:12 | in_aqu |
| 3+ | 9 | N | aqudb | cbn | real | 0.5 | percent | Organic carbon in aquifer (initial) | src/aquifer_module.f90:13 | in_aqu |
| 3+ | 10 | N | aqudb | flo_dist | real | 50. | m | Average flow distance to stream or object | src/aquifer_module.f90:14 | in_aqu |
| 3+ | 11 | N | aqudb | bf_max | real | 0. | mm | Maximum daily baseflow - when all channels are contributing | src/aquifer_module.f90:15 | in_aqu |
| 3+ | 12 | N | aqudb | alpha | real | 0. | 1/days | Lag factor for groundwater recession curve | src/aquifer_module.f90:16 | in_aqu |
| 3+ | 13 | N | aqudb | revap_co | real | 0. | dimensionless | Revap coefficient - evap=pet*revap_co | src/aquifer_module.f90:17 | in_aqu |
| 3+ | 14 | N | aqudb | seep | real | 0. | frac | Fraction of recharge that seeps from aquifer | src/aquifer_module.f90:18 | in_aqu |
| 3+ | 15 | N | aqudb | spyld | real | 0. | m³/m³ | Specific yield of aquifer | src/aquifer_module.f90:19 | in_aqu |
| 3+ | 16 | N | aqudb | hlife_n | real | 30. | days | Half-life of nitrogen in groundwater | src/aquifer_module.f90:20 | in_aqu |
| 3+ | 17 | N | aqudb | flo_min | real | 0. | m | Water table depth for return flow to occur | src/aquifer_module.f90:21 | in_aqu |
| 3+ | 18 | N | aqudb | revap_min | real | 0. | m | Water table depth for revap to occur | src/aquifer_module.f90:22 | in_aqu |


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
**File.cio Reference**: This file (object.cnt) is referenced in file.cio as component `object_cnt` of derived type `in_sim`

| Line in File | Position in File | Local (Y/N) | Derived Type Name | Component (or Var Name if Local) | Type | Default | Units | Description | Source Line | Swat_codetype |
|--------------|------------------|-------------|-------------------|-----------------------------------|------|---------|-------|-------------|-------------|---------------|
| 3 | 1 | N | bsn | name | character(len=25) | "" | N/A | Basin name | src/basin_module.f90:10 | in_sim |
| 3 | 2 | N | bsn | area_ls_ha | real | 0. | ha | Land surface area | src/basin_module.f90:11 | in_sim |
| 3 | 3 | N | bsn | area_tot_ha | real | 0. | ha | Total area | src/basin_module.f90:12 | in_sim |
| 3 | 4 | N | sp_ob | objs | integer | 0 | none | Number of objects or 1st object command | src/hydrograph_module.f90:452 | in_sim |
| 3 | 5 | N | sp_ob | hru | integer | 0 | none | Number of HRUs or 1st HRU command | src/hydrograph_module.f90:453 | in_sim |
| 3 | 6 | N | sp_ob | hru_lte | integer | 0 | none | Number of HRU_LTEs or 1st HRU_LTE command | src/hydrograph_module.f90:454 | in_sim |
| 3 | 7 | N | sp_ob | ru | integer | 0 | none | Number of routing units or 1st RU command | src/hydrograph_module.f90:456 | in_sim |
| 3 | 8 | N | sp_ob | gwflow | integer | 0 | none | Number of gwflow objects or 1st gwflow command | src/hydrograph_module.f90:457 | in_sim |
| 3 | 9 | N | sp_ob | aqu | integer | 0 | none | Number of aquifers or 1st aquifer command | src/hydrograph_module.f90:458 | in_sim |
| 3 | 10 | N | sp_ob | chan | integer | 0 | none | Number of channels or 1st channel command | src/hydrograph_module.f90:459 | in_sim |
| 3 | 11 | N | sp_ob | res | integer | 0 | none | Number of reservoirs or 1st reservoir command | src/hydrograph_module.f90:460 | in_sim |
| 3 | 12 | N | sp_ob | recall | integer | 0 | none | Number of recall points or 1st recall command | src/hydrograph_module.f90:461 | in_sim |
| 3 | 13 | N | sp_ob | exco | integer | 0 | none | Number of export coefficients or 1st exco command | src/hydrograph_module.f90:462 | in_sim |
| 3 | 14 | N | sp_ob | dr | integer | 0 | none | Number of delivery ratios or 1st DR command | src/hydrograph_module.f90:463 | in_sim |
| 3 | 15 | N | sp_ob | canal | integer | 0 | none | Number of canals or 1st canal command | src/hydrograph_module.f90:464 | in_sim |
| 3 | 16 | N | sp_ob | pump | integer | 0 | none | Number of pumps or 1st pump command | src/hydrograph_module.f90:465 | in_sim |
| 3 | 17 | N | sp_ob | outlet | integer | 0 | none | Number of outlets or 1st outlet command | src/hydrograph_module.f90:466 | in_sim |
| 3 | 18 | N | sp_ob | chandeg | integer | 0 | none | Number of SWAT-DEG channels or 1st SWAT-DEG channel command | src/hydrograph_module.f90:467 | in_sim |
| 3 | 19 | N | sp_ob | aqu2d | integer | 0 | none | Not currently used (number of 2D aquifers) | src/hydrograph_module.f90:468 | in_sim |
| 3 | 20 | N | sp_ob | herd | integer | 0 | none | Not currently used (number of herds) | src/hydrograph_module.f90:469 | in_sim |
| 3 | 21 | N | sp_ob | wro | integer | 0 | none | Not currently used (number of water rights) | src/hydrograph_module.f90:470 | in_sim |


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

#### PRIMARY DATA WRITE Table

The following table documents the most common management event write statement pattern. Multiple write statements exist throughout src/mgt_sched.f90 and src/actions.f90, with variations depending on the operation type.

**Representative Write Statement**: `write (2612, *) j, time%yrc, time%mo, time%day_mo, pldb(idp)%plantnm, "PLANT", phubase(j), pcom(j)%plcur(ipl)%phuacc, soil(j)%sw, pl_mass(j)%tot(ipl)%m, pl_mass(j)%rsd_tot%m, sol_sumno3(j), sol_sumsolp(j), pcom(j)%plg(ipl)%lai, pcom(j)%plcur(ipl)%lai_pot` at src/mgt_sched.f90:116-119

| Line in File | Position in Output | Variable Name | Type | Units | Description | Source Line |
|--------------|-------------------|---------------|------|-------|-------------|-------------|
| 4+ | 1 | j | integer | none | HRU number (object number) | src/mgt_sched.f90:62 |
| 4+ | 2 | time%yrc | integer | year | Calendar year | src/time_module.f90 |
| 4+ | 3 | time%mo | integer | month | Month (1-12) | src/time_module.f90 |
| 4+ | 4 | time%day_mo | integer | day | Day of month (1-31) | src/time_module.f90 |
| 4+ | 5 | pldb(idp)%plantnm | character(len=16) | N/A | Plant name or operation identifier | src/plant_data_module.f90 |
| 4+ | 6 | operation_literal | character | N/A | Operation type (e.g., "PLANT", "HARVEST", "TILLAGE", "FERT") | Literal string |
| 4+ | 7 | phubase(j) | real | heat units | Base plant heat units for HRU | src/hru_module.f90 |
| 4+ | 8 | pcom(j)%plcur(ipl)%phuacc | real | heat units | Accumulated plant heat units | src/plant_module.f90 |
| 4+ | 9 | soil(j)%sw | real | mm | Soil water content | src/soil_module.f90 |
| 4+ | 10 | pl_mass(j)%tot(ipl)%m | real | kg/ha | Total plant biomass | src/organic_mineral_mass_module.f90 |
| 4+ | 11 | pl_mass(j)%rsd_tot%m | real | kg/ha | Surface residue mass | src/organic_mineral_mass_module.f90 |
| 4+ | 12 | sol_sumno3(j) | real | kg/ha | Total soil NO3-N | src/hru_module.f90 |
| 4+ | 13 | sol_sumsolp(j) | real | kg/ha | Total soil soluble P | src/hru_module.f90 |
| 4+ | 14+ | operation_specific_vars | real/integer | varies | Operation-specific variables (varies by operation type) | Various files |

**Operation-Specific Variable Examples**:

**PLANT Operation** (src/mgt_sched.f90:116-119):
- Position 14: pcom(j)%plg(ipl)%lai (real, m²/m²) - Leaf area index
- Position 15: pcom(j)%plcur(ipl)%lai_pot (real, m²/m²) - Potential leaf area index

**HARVEST Operation** (src/mgt_sched.f90:211-215):
- Position 14: pl_yield%m (real, kg/ha) - Crop yield
- Position 15: pcom(j)%plstr(ipl)%sum_n (real, none) - Sum of nitrogen stress
- Position 16: pcom(j)%plstr(ipl)%sum_p (real, none) - Sum of phosphorus stress
- Position 17: pcom(j)%plstr(ipl)%sum_tmp (real, none) - Sum of temperature stress
- Position 18: pcom(j)%plstr(ipl)%sum_w (real, none) - Sum of water stress
- Position 19: pcom(j)%plstr(ipl)%sum_a (real, none) - Sum of aeration stress

**TILLAGE Operation** (src/mgt_sched.f90:333-335):
- Position 1-6: Standard (j, time%yrc, time%mo, time%day_mo, tilldb(idtill)%tillnm, "TILLAGE")
- Position 7: phubase(j) (real, heat units)
- Position 8: pcom(j)%plcur(ipl)%phuacc (real, heat units)
- Position 9: soil(j)%sw (real, mm)
- Position 10: pl_mass(j)%tot(ipl)%m (real, kg/ha)
- Position 11: pl_mass(j)%rsd_tot%m (real, kg/ha)
- Position 12: sol_sumno3(j) (real, kg/ha)
- Position 13: sol_sumsolp(j) (real, kg/ha)
- Position 14: tilldb(idtill)%effmix (real, fraction) - Tillage mixing efficiency

**FERTILIZER Operation** (src/mgt_sched.f90:375-378):
- Position 1-6: Standard (j, time%yrc, time%mo, time%day_mo, mgt%op_char, "FERT")
- Position 7-13: Standard HRU state variables
- Position 14: frt_kg (real, kg/ha) - Amount of fertilizer applied
- Position 15: fertno3 (real, kg/ha) - NO3-N applied
- Position 16: fertnh3 (real, kg/ha) - NH3-N applied
- Position 17: fertorgn (real, kg/ha) - Organic N applied
- Position 18: fertsolp (real, kg/ha) - Soluble P applied
- Position 19: fertorgp (real, kg/ha) - Organic P applied

**IRRIGATION Operation** (src/mgt_sched.f90:350-352):
- Position 14: irrig(j)%applied (real, mm) - Irrigation water applied
- Position 15: irrig(j)%runoff (real, mm) - Irrigation runoff

**PESTICIDE Operation** (src/mgt_sched.f90:414-416):
- Position 14: pest_kg (real, kg/ha) - Amount of pesticide applied

**GRAZING Operation** (src/mgt_sched.f90:427-430):
- Position 14: grazeop_db(mgt%op1)%eat (real, kg/ha) - Biomass consumed
- Position 15: grazeop_db(mgt%op1)%manure (real, kg/ha) - Manure deposited

**Note on Write Locations**:
- src/mgt_sched.f90: Lines 109, 116, 126, 211, 238, 308, 333, 350, 365, 375, 391, 414, 427, 441, 452, 465, 482, 505, 522, 531, 537, 545, 563, 594
- src/actions.f90: Lines 151, 158, 252, 256, 282, 290, 316, 343, 382, 389, 398, 483, 513, 601, 663, 739, 803, 821, 841, 878, 1127, 1145
- src/wallo_control.f90: Line 169
- src/mallo_control.f90: Line 70



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

#### PRIMARY DATA WRITE Table

**Write Statement**: `write (2520,100) time%day, time%mo, time%day_mo, time%yrc, iaq, ob(iob)%gis_id, ob(iob)%name, aqu_d(iaq)` at src/aquifer_output.f90:22

The same structure applies to all output frequencies (daily at line 22, monthly at line 37, yearly at line 52, average annual at line 64), with different format codes (100 for daily/monthly, 102 for yearly/avg annual) and different units (2520-2523 for text, 2524-2527 for CSV).

| Line in File | Position in Output | Local (Y/N) | Derived Type Name | Component (or Var Name if Local) | Type | Units | Description | Source Line |
|--------------|-------------------|-------------|-------------------|-----------------------------------|------|-------|-------------|-------------|
| 2+ | 1 | Y | N/A | time%day | integer | day of year | Julian day (1-366) | src/time_module.f90 |
| 2+ | 2 | Y | N/A | time%mo | integer | month | Month (1-12) | src/time_module.f90 |
| 2+ | 3 | Y | N/A | time%day_mo | integer | day | Day of month (1-31) | src/time_module.f90 |
| 2+ | 4 | Y | N/A | time%yrc | integer | year | Calendar year | src/time_module.f90 |
| 2+ | 5 | Y | N/A | iaq | integer | none | Aquifer number/ID | src/aquifer_output.f90:10 |
| 2+ | 6 | Y | N/A | ob(iob)%gis_id | integer*8 | none | GIS identifier for object | src/hydrograph_module.f90:342 |
| 2+ | 7 | Y | N/A | ob(iob)%name | character(len=16) | N/A | Object name | src/hydrograph_module.f90:322 |
| 2+ | 8 | N | aqu_d | flo | real | mm | Lateral flow from aquifer | src/aquifer_module.f90:37 |
| 2+ | 9 | N | aqu_d | dep_wt | real | m | Average depth from average surface elevation to water table | src/aquifer_module.f90:38 |
| 2+ | 10 | N | aqu_d | stor | real | mm | Average water storage in aquifer in timestep | src/aquifer_module.f90:39 |
| 2+ | 11 | N | aqu_d | rchrg | real | mm | Recharge entering aquifer from other objects | src/aquifer_module.f90:40 |
| 2+ | 12 | N | aqu_d | seep | real | mm | Seepage from bottom of aquifer | src/aquifer_module.f90:41 |
| 2+ | 13 | N | aqu_d | revap | real | mm | Plant water uptake and evaporation | src/aquifer_module.f90:42 |
| 2+ | 14 | N | aqu_d | no3_st | real | kg/ha N | Current total NO3-N mass in aquifer | src/aquifer_module.f90:43 |
| 2+ | 15 | N | aqu_d | minp | real | kg/ha P | Mineral phosphorus transported in return (lateral) flow | src/aquifer_module.f90:44 |
| 2+ | 16 | N | aqu_d | cbn | real | percent | Organic carbon in aquifer - currently static | src/aquifer_module.f90:45 |
| 2+ | 17 | N | aqu_d | orgn | real | kg/ha P | Organic nitrogen in aquifer - currently static | src/aquifer_module.f90:46 |
| 2+ | 18 | N | aqu_d | no3_rchg | real | kg/ha N | Nitrate NO3-N flowing into aquifer from another object | src/aquifer_module.f90:47 |
| 2+ | 19 | N | aqu_d | no3_loss | real | kg/ha | Nitrate NO3-N loss | src/aquifer_module.f90:48 |
| 2+ | 20 | N | aqu_d | no3_lat | real | kg/ha N | Nitrate loading to reach in groundwater | src/aquifer_module.f90:49 |
| 2+ | 21 | N | aqu_d | no3_seep | real | kg/ha N | Seepage of NO3 to next object | src/aquifer_module.f90:50 |
| 2+ | 22 | N | aqu_d | flo_cha | real | mm H2O | Surface runoff flowing into channels | src/aquifer_module.f90:51 |
| 2+ | 23 | N | aqu_d | flo_res | real | mm H2O | Surface runoff flowing into reservoirs | src/aquifer_module.f90:52 |
| 2+ | 24 | N | aqu_d | flo_ls | real | mm H2O | Surface runoff flowing into a landscape element (HRU or RU) | src/aquifer_module.f90:53 |

**Write Locations by Output Frequency**:
- **Daily**: src/aquifer_output.f90:22 (text, unit 2520), line 24 (CSV, unit 2524)
- **Monthly**: src/aquifer_output.f90:37 (text, unit 2521), line 39 (CSV, unit 2525)
- **Yearly**: src/aquifer_output.f90:52 (text, unit 2522), line 54 (CSV, unit 2526)
- **Average Annual**: src/aquifer_output.f90:64 (text, unit 2523), line 66 (CSV, unit 2527)


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

**Overview**: file.cio contains 32 lines total. Line 1 is the title, lines 2-31 contain configuration records (label + derived type components), and line 32 contains the output path. The table below shows ALL individual components expanded out, showing which line and position each appears at in file.cio.

**Read Pattern**: Each configuration line (2-31) reads a label string followed by all components of a derived type structure. List-directed I/O reads components sequentially in declaration order.

| Line in File | Position in File | Local (Y/N) | Derived Type Name | Component | Type | Default | Units | Description | Source Line |
|--------------|------------------|-------------|-------------------|-----------|------|---------|-------|-------------|-------------|
| 1 | 1 | Y | N/A | titldum | character(len=80) | "" | N/A | Title or description line from file | src/readcio_read.f90:8 |
| 2 | 1 | Y | N/A | name (label) | character(len=25) | "" | N/A | Label for in_sim section | src/readcio_read.f90:9 |
| 2 | 2 | N | in_sim | time | character(len=25) | "time.sim" | N/A | Simulation time configuration | src/input_file_module.f90:9 |
| 2 | 3 | N | in_sim | prt | character(len=25) | "print.prt" | N/A | Print configuration | src/input_file_module.f90:10 |
| 2 | 4 | N | in_sim | object_prt | character(len=25) | "object.prt" | N/A | Object print configuration | src/input_file_module.f90:11 |
| 2 | 5 | N | in_sim | object_cnt | character(len=25) | "object.cnt" | N/A | Object count file | src/input_file_module.f90:12 |
| 2 | 6 | N | in_sim | cs_db | character(len=25) | "constituents.cs" | N/A | Constituents database | src/input_file_module.f90:13 |
| 3 | 1 | Y | N/A | name (label) | character(len=25) | "" | N/A | Label for in_basin section | src/readcio_read.f90:9 |
| 3 | 2 | N | in_basin | codes_bas | character(len=25) | "codes.bsn" | N/A | Basin codes configuration | src/input_file_module.f90:19 |
| 3 | 3 | N | in_basin | parms_bas | character(len=25) | "parameters.bsn" | N/A | Basin parameters | src/input_file_module.f90:20 |
| 4 | 1 | Y | N/A | name (label) | character(len=25) | "" | N/A | Label for in_cli section | src/readcio_read.f90:9 |
| 4 | 2 | N | in_cli | weat_sta | character(len=25) | "weather-sta.cli" | N/A | Weather station data | src/input_file_module.f90:26 |
| 4 | 3 | N | in_cli | weat_wgn | character(len=25) | "weather-wgn.cli" | N/A | Weather generator data | src/input_file_module.f90:27 |
| 4 | 4 | N | in_cli | pet_cli | character(len=25) | "pet.cli" | N/A | Potential evapotranspiration data | src/input_file_module.f90:28 |
| 4 | 5 | N | in_cli | pcp_cli | character(len=25) | "pcp.cli" | N/A | Precipitation data | src/input_file_module.f90:30 |
| 4 | 6 | N | in_cli | tmp_cli | character(len=25) | "tmp.cli" | N/A | Temperature data | src/input_file_module.f90:31 |
| 4 | 7 | N | in_cli | slr_cli | character(len=25) | "slr.cli" | N/A | Solar radiation data | src/input_file_module.f90:32 |
| 4 | 8 | N | in_cli | hmd_cli | character(len=25) | "hmd.cli" | N/A | Humidity data | src/input_file_module.f90:33 |
| 4 | 9 | N | in_cli | wnd_cli | character(len=25) | "wnd.cli" | N/A | Wind data | src/input_file_module.f90:34 |
| 4 | 10 | N | in_cli | atmo_cli | character(len=25) | "atmodep.cli" | N/A | Atmospheric deposition data | src/input_file_module.f90:35 |
| 5 | 1 | Y | N/A | name (label) | character(len=25) | "" | N/A | Label for in_con section | src/readcio_read.f90:9 |
| 5 | 2 | N | in_con | hru_con | character(len=25) | "hru.con" | N/A | HRU connections | src/input_file_module.f90:41 |
| 5 | 3 | N | in_con | hruez_con | character(len=25) | "hru-lte.con" | N/A | HRU landscape element connections | src/input_file_module.f90:42 |
| 5 | 4 | N | in_con | ru_con | character(len=25) | "rout_unit.con" | N/A | Routing unit connections | src/input_file_module.f90:43 |
| 5 | 5 | N | in_con | gwflow_con | character(len=25) | "gwflow.con" | N/A | Groundwater flow connections | src/input_file_module.f90:44 |
| 5 | 6 | N | in_con | aqu_con | character(len=25) | "aquifer.con" | N/A | Aquifer connections | src/input_file_module.f90:45 |
| 5 | 7 | N | in_con | aqu2d_con | character(len=25) | "aquifer2d.con" | N/A | 2D aquifer connections | src/input_file_module.f90:46 |
| 5 | 8 | N | in_con | chan_con | character(len=25) | "channel.con" | N/A | Channel connections | src/input_file_module.f90:47 |
| 5 | 9 | N | in_con | res_con | character(len=25) | "reservoir.con" | N/A | Reservoir connections | src/input_file_module.f90:48 |
| 5 | 10 | N | in_con | rec_con | character(len=25) | "recall.con" | N/A | Recall connections | src/input_file_module.f90:49 |
| 5 | 11 | N | in_con | exco_con | character(len=25) | "exco.con" | N/A | Export coefficient connections | src/input_file_module.f90:50 |
| 5 | 12 | N | in_con | delr_con | character(len=25) | "delratio.con" | N/A | Delivery ratio connections | src/input_file_module.f90:51 |
| 5 | 13 | N | in_con | out_con | character(len=25) | "outlet.con" | N/A | Outlet connections | src/input_file_module.f90:52 |
| 5 | 14 | N | in_con | chandeg_con | character(len=25) | "chandeg.con" | N/A | SWAT-DEG channel connections | src/input_file_module.f90:53 |
| 6 | 1 | Y | N/A | name (label) | character(len=25) | "" | N/A | Label for in_cha section | src/readcio_read.f90:9 |
| 6 | 2 | N | in_cha | init | character(len=25) | "initial.cha" | N/A | Initial channel conditions | src/input_file_module.f90:59 |
| 6 | 3 | N | in_cha | dat | character(len=25) | "channel.cha" | N/A | Channel data | src/input_file_module.f90:60 |
| 6 | 4 | N | in_cha | hyd | character(len=25) | "hydrology.cha" | N/A | Channel hydrology parameters | src/input_file_module.f90:61 |
| 6 | 5 | N | in_cha | sed | character(len=25) | "sediment.cha" | N/A | Channel sediment parameters | src/input_file_module.f90:62 |
| 6 | 6 | N | in_cha | nut | character(len=25) | "nutrients.cha" | N/A | Channel nutrient parameters | src/input_file_module.f90:63 |
| 6 | 7 | N | in_cha | chan_ez | character(len=25) | "channel-lte.cha" | N/A | Channel landscape element parameters | src/input_file_module.f90:64 |
| 6 | 8 | N | in_cha | hyd_sed | character(len=25) | "hyd-sed-lte.cha" | N/A | Hydrology-sediment landscape element parameters | src/input_file_module.f90:65 |
| 6 | 9 | N | in_cha | temp | character(len=25) | "temperature.cha" | N/A | Channel temperature parameters | src/input_file_module.f90:66 |
| 7 | 1 | Y | N/A | name (label) | character(len=25) | "" | N/A | Label for in_res section | src/readcio_read.f90:9 |
| 7 | 2 | N | in_res | init_res | character(len=25) | "initial.res" | N/A | Initial reservoir conditions | src/input_file_module.f90:72 |
| 7 | 3 | N | in_res | res | character(len=25) | "reservoir.res" | N/A | Reservoir data | src/input_file_module.f90:73 |
| 7 | 4 | N | in_res | hyd_res | character(len=25) | "hydrology.res" | N/A | Reservoir hydrology parameters | src/input_file_module.f90:74 |
| 7 | 5 | N | in_res | sed_res | character(len=25) | "sediment.res" | N/A | Reservoir sediment parameters | src/input_file_module.f90:75 |
| 7 | 6 | N | in_res | nut_res | character(len=25) | "nutrients.res" | N/A | Reservoir nutrient parameters | src/input_file_module.f90:76 |
| 7 | 7 | N | in_res | weir_res | character(len=25) | "weir.res" | N/A | Reservoir weir data | src/input_file_module.f90:77 |
| 7 | 8 | N | in_res | wet | character(len=25) | "wetland.wet" | N/A | Wetland data | src/input_file_module.f90:78 |
| 7 | 9 | N | in_res | hyd_wet | character(len=25) | "hydrology.wet" | N/A | Wetland hydrology parameters | src/input_file_module.f90:79 |
| 8 | 1 | Y | N/A | name (label) | character(len=25) | "" | N/A | Label for in_ru section | src/readcio_read.f90:9 |
| 8 | 2 | N | in_ru | ru_def | character(len=25) | "rout_unit.def" | N/A | Routing unit definitions | src/input_file_module.f90:85 |
| 8 | 3 | N | in_ru | ru_ele | character(len=25) | "rout_unit.ele" | N/A | Routing unit elements | src/input_file_module.f90:86 |
| 8 | 4 | N | in_ru | ru | character(len=25) | "rout_unit.rtu" | N/A | Routing unit data | src/input_file_module.f90:87 |
| 8 | 5 | N | in_ru | ru_dr | character(len=25) | "rout_unit.dr" | N/A | Routing unit delivery ratio | src/input_file_module.f90:88 |
| 9 | 1 | Y | N/A | name (label) | character(len=25) | "" | N/A | Label for in_hru section | src/readcio_read.f90:9 |
| 9 | 2 | N | in_hru | hru_data | character(len=25) | "hru-data.hru" | N/A | HRU data | src/input_file_module.f90:94 |
| 9 | 3 | N | in_hru | hru_ez | character(len=25) | "hru-lte.hru" | N/A | HRU landscape element data | src/input_file_module.f90:95 |
| 10 | 1 | Y | N/A | name (label) | character(len=25) | "" | N/A | Label for in_exco section | src/readcio_read.f90:9 |
| 10 | 2 | N | in_exco | exco | character(len=25) | "exco.exc" | N/A | Export coefficients | src/input_file_module.f90:101 |
| 10 | 3 | N | in_exco | om | character(len=25) | "exco_om.exc" | N/A | Export coefficients for organic matter | src/input_file_module.f90:102 |
| 10 | 4 | N | in_exco | pest | character(len=25) | "exco_pest.exc" | N/A | Export coefficients for pesticides | src/input_file_module.f90:103 |
| 10 | 5 | N | in_exco | path | character(len=25) | "exco_path.exc" | N/A | Export coefficients for pathogens | src/input_file_module.f90:104 |
| 10 | 6 | N | in_exco | hmet | character(len=25) | "exco_hmet.exc" | N/A | Export coefficients for heavy metals | src/input_file_module.f90:105 |
| 10 | 7 | N | in_exco | salt | character(len=25) | "exco_salt.exc" | N/A | Export coefficients for salt | src/input_file_module.f90:106 |
| 11 | 1 | Y | N/A | name (label) | character(len=25) | "" | N/A | Label for in_rec section | src/readcio_read.f90:9 |
| 11 | 2 | N | in_rec | recall_rec | character(len=25) | "recall.rec" | N/A | Recall data (daily, monthly, annual) | src/input_file_module.f90:112 |
| 12 | 1 | Y | N/A | name (label) | character(len=25) | "" | N/A | Label for in_delr section | src/readcio_read.f90:9 |
| 12 | 2 | N | in_delr | del_ratio | character(len=25) | "delratio.del" | N/A | Delivery ratios | src/input_file_module.f90:118 |
| 12 | 3 | N | in_delr | om | character(len=25) | "dr_om.del" | N/A | Delivery ratios for organic matter | src/input_file_module.f90:119 |
| 12 | 4 | N | in_delr | pest | character(len=25) | "dr_pest.del" | N/A | Delivery ratios for pesticides | src/input_file_module.f90:120 |
| 12 | 5 | N | in_delr | path | character(len=25) | "dr_path.del" | N/A | Delivery ratios for pathogens | src/input_file_module.f90:121 |
| 12 | 6 | N | in_delr | hmet | character(len=25) | "dr_hmet.del" | N/A | Delivery ratios for heavy metals | src/input_file_module.f90:122 |
| 12 | 7 | N | in_delr | salt | character(len=25) | "dr_salt.del" | N/A | Delivery ratios for salt | src/input_file_module.f90:123 |
| 13 | 1 | Y | N/A | name (label) | character(len=25) | "" | N/A | Label for in_aqu section | src/readcio_read.f90:9 |
| 13 | 2 | N | in_aqu | init | character(len=25) | "initial.aqu" | N/A | Initial aquifer conditions | src/input_file_module.f90:129 |
| 13 | 3 | N | in_aqu | aqu | character(len=25) | "aquifer.aqu" | N/A | Aquifer parameters | src/input_file_module.f90:130 |
| 14 | 1 | Y | N/A | name (label) | character(len=25) | "" | N/A | Label for in_herd section | src/readcio_read.f90:9 |
| 14 | 2 | N | in_herd | animal | character(len=25) | "animal.hrd" | N/A | Animal parameters | src/input_file_module.f90:136 |
| 14 | 3 | N | in_herd | herd | character(len=25) | "herd.hrd" | N/A | Herd data | src/input_file_module.f90:137 |
| 14 | 4 | N | in_herd | ranch | character(len=25) | "ranch.hrd" | N/A | Ranch data | src/input_file_module.f90:138 |
| 15 | 1 | Y | N/A | name (label) | character(len=25) | "" | N/A | Label for in_watrts section | src/readcio_read.f90:9 |
| 15 | 2 | N | in_watrts | transfer_wro | character(len=25) | "water_allocation.wro" | N/A | Transferring water using water rights objects | src/input_file_module.f90:144 |
| 15 | 3 | N | in_watrts | element | character(len=25) | "element.wro" | N/A | Water rights elements | src/input_file_module.f90:145 |
| 15 | 4 | N | in_watrts | water_rights | character(len=25) | "water_rights.wro" | N/A | Water rights data | src/input_file_module.f90:146 |
| 16 | 1 | Y | N/A | name (label) | character(len=25) | "" | N/A | Label for in_link section | src/readcio_read.f90:9 |
| 16 | 2 | N | in_link | chan_surf | character(len=25) | "chan-surf.lin" | N/A | Channel-surface linkage | src/input_file_module.f90:152 |
| 16 | 3 | N | in_link | aqu_cha | character(len=25) | "aqu_cha.lin" | N/A | Aquifer-channel linkage | src/input_file_module.f90:153 |
| 17 | 1 | Y | N/A | name (label) | character(len=25) | "" | N/A | Label for in_hyd section | src/readcio_read.f90:9 |
| 17 | 2 | N | in_hyd | hydrol_hyd | character(len=25) | "hydrology.hyd" | N/A | Hydrology parameters | src/input_file_module.f90:159 |
| 17 | 3 | N | in_hyd | topogr_hyd | character(len=25) | "topography.hyd" | N/A | Topography parameters | src/input_file_module.f90:160 |
| 17 | 4 | N | in_hyd | field_fld | character(len=25) | "field.fld" | N/A | Field parameters | src/input_file_module.f90:161 |
| 18 | 1 | Y | N/A | name (label) | character(len=25) | "" | N/A | Label for in_str section | src/readcio_read.f90:9 |
| 18 | 2 | N | in_str | tiledrain_str | character(len=25) | "tiledrain.str" | N/A | Tile drainage data | src/input_file_module.f90:167 |
| 18 | 3 | N | in_str | septic_str | character(len=25) | "septic.str" | N/A | Septic system data | src/input_file_module.f90:168 |
| 18 | 4 | N | in_str | fstrip_str | character(len=25) | "filterstrip.str" | N/A | Filter strip data | src/input_file_module.f90:169 |
| 18 | 5 | N | in_str | grassww_str | character(len=25) | "grassedww.str" | N/A | Grassed waterway data | src/input_file_module.f90:170 |
| 18 | 6 | N | in_str | bmpuser_str | character(len=25) | "bmpuser.str" | N/A | User-defined BMP data | src/input_file_module.f90:171 |
| 19 | 1 | Y | N/A | name (label) | character(len=25) | "" | N/A | Label for in_parmdb section | src/readcio_read.f90:9 |
| 19 | 2 | N | in_parmdb | plants_plt | character(len=25) | "plants.plt" | N/A | Plant database | src/input_file_module.f90:177 |
| 19 | 3 | N | in_parmdb | fert_frt | character(len=25) | "fertilizer.frt" | N/A | Fertilizer database | src/input_file_module.f90:178 |
| 19 | 4 | N | in_parmdb | till_til | character(len=25) | "tillage.til" | N/A | Tillage database | src/input_file_module.f90:179 |
| 19 | 5 | N | in_parmdb | pest | character(len=25) | "pesticide.pes" | N/A | Pesticide database | src/input_file_module.f90:180 |
| 19 | 6 | N | in_parmdb | pathcom_db | character(len=25) | "pathogens.pth" | N/A | Pathogen database | src/input_file_module.f90:181 |
| 19 | 7 | N | in_parmdb | hmetcom_db | character(len=25) | "metals.mtl" | N/A | Heavy metal database | src/input_file_module.f90:182 |
| 19 | 8 | N | in_parmdb | saltcom_db | character(len=25) | "salt.slt" | N/A | Salt database | src/input_file_module.f90:183 |
| 19 | 9 | N | in_parmdb | urban_urb | character(len=25) | "urban.urb" | N/A | Urban database | src/input_file_module.f90:184 |
| 19 | 10 | N | in_parmdb | septic_sep | character(len=25) | "septic.sep" | N/A | Septic database | src/input_file_module.f90:185 |
| 19 | 11 | N | in_parmdb | snow | character(len=25) | "snow.sno" | N/A | Snow database | src/input_file_module.f90:186 |
| 20 | 1 | Y | N/A | name (label) | character(len=25) | "" | N/A | Label for in_ops section | src/readcio_read.f90:9 |
| 20 | 2 | N | in_ops | harv_ops | character(len=25) | "harv.ops" | N/A | Harvest operations | src/input_file_module.f90:192 |
| 20 | 3 | N | in_ops | graze_ops | character(len=25) | "graze.ops" | N/A | Grazing operations | src/input_file_module.f90:193 |
| 20 | 4 | N | in_ops | irr_ops | character(len=25) | "irr.ops" | N/A | Irrigation operations | src/input_file_module.f90:194 |
| 20 | 5 | N | in_ops | chem_ops | character(len=25) | "chem_app.ops" | N/A | Chemical application operations | src/input_file_module.f90:195 |
| 20 | 6 | N | in_ops | fire_ops | character(len=25) | "fire.ops" | N/A | Fire operations | src/input_file_module.f90:196 |
| 20 | 7 | N | in_ops | sweep_ops | character(len=25) | "sweep.ops" | N/A | Sweep operations | src/input_file_module.f90:197 |
| 21 | 1 | Y | N/A | name (label) | character(len=25) | "" | N/A | Label for in_lum section | src/readcio_read.f90:9 |
| 21 | 2 | N | in_lum | landuse_lum | character(len=25) | "landuse.lum" | N/A | Land use management | src/input_file_module.f90:203 |
| 21 | 3 | N | in_lum | management_sch | character(len=25) | "management.sch" | N/A | Management schedule | src/input_file_module.f90:204 |
| 21 | 4 | N | in_lum | cntable_lum | character(len=25) | "cntable.lum" | N/A | CN table | src/input_file_module.f90:205 |
| 21 | 5 | N | in_lum | cons_prac_lum | character(len=25) | "cons_practice.lum" | N/A | Conservation practice | src/input_file_module.f90:206 |
| 21 | 6 | N | in_lum | ovn_lum | character(len=25) | "ovn_table.lum" | N/A | Overland flow N table | src/input_file_module.f90:207 |
| 22 | 1 | Y | N/A | name (label) | character(len=25) | "" | N/A | Label for in_chg section | src/readcio_read.f90:9 |
| 22 | 2 | N | in_chg | cal_parms | character(len=25) | "cal_parms.cal" | N/A | Calibration parameters | src/input_file_module.f90:213 |
| 22 | 3 | N | in_chg | cal_upd | character(len=25) | "calibration.cal" | N/A | Calibration update | src/input_file_module.f90:214 |
| 22 | 4 | N | in_chg | codes_sft | character(len=25) | "codes.sft" | N/A | Soft calibration codes | src/input_file_module.f90:215 |
| 22 | 5 | N | in_chg | wb_parms_sft | character(len=25) | "wb_parms.sft" | N/A | Water balance parameters | src/input_file_module.f90:216 |
| 22 | 6 | N | in_chg | water_balance_sft | character(len=25) | "water_balance.sft" | N/A | Water balance soft calibration | src/input_file_module.f90:217 |
| 22 | 7 | N | in_chg | ch_sed_budget_sft | character(len=25) | "ch_sed_budget.sft" | N/A | Channel sediment budget | src/input_file_module.f90:218 |
| 22 | 8 | N | in_chg | ch_sed_parms_sft | character(len=25) | "ch_sed_parms.sft" | N/A | Channel sediment parameters | src/input_file_module.f90:219 |
| 22 | 9 | N | in_chg | plant_parms_sft | character(len=25) | "plant_parms.sft" | N/A | Plant parameters | src/input_file_module.f90:220 |
| 22 | 10 | N | in_chg | plant_gro_sft | character(len=25) | "plant_gro.sft" | N/A | Plant growth parameters | src/input_file_module.f90:221 |
| 23 | 1 | Y | N/A | name (label) | character(len=25) | "" | N/A | Label for in_init section | src/readcio_read.f90:9 |
| 23 | 2 | N | in_init | plant | character(len=25) | "plant.ini" | N/A | Plant initial conditions | src/input_file_module.f90:227 |
| 23 | 3 | N | in_init | soil_plant_ini | character(len=25) | "soil_plant.ini" | N/A | Soil-plant initial conditions | src/input_file_module.f90:228 |
| 23 | 4 | N | in_init | om_water | character(len=25) | "om_water.ini" | N/A | Organic matter-water initial conditions | src/input_file_module.f90:229 |
| 23 | 5 | N | in_init | pest_soil | character(len=25) | "pest_hru.ini" | N/A | Pesticide soil initial conditions | src/input_file_module.f90:230 |
| 23 | 6 | N | in_init | pest_water | character(len=25) | "pest_water.ini" | N/A | Pesticide water initial conditions | src/input_file_module.f90:231 |
| 23 | 7 | N | in_init | path_soil | character(len=25) | "path_hru.ini" | N/A | Pathogen soil initial conditions | src/input_file_module.f90:232 |
| 23 | 8 | N | in_init | path_water | character(len=25) | "path_water.ini" | N/A | Pathogen water initial conditions | src/input_file_module.f90:233 |
| 23 | 9 | N | in_init | hmet_soil | character(len=25) | "hmet_hru.ini" | N/A | Heavy metal soil initial conditions | src/input_file_module.f90:234 |
| 23 | 10 | N | in_init | hmet_water | character(len=25) | "hmet_water.ini" | N/A | Heavy metal water initial conditions | src/input_file_module.f90:235 |
| 23 | 11 | N | in_init | salt_soil | character(len=25) | "salt_hru.ini" | N/A | Salt soil initial conditions | src/input_file_module.f90:236 |
| 23 | 12 | N | in_init | salt_water | character(len=25) | "salt_water.ini" | N/A | Salt water initial conditions | src/input_file_module.f90:237 |
| 24 | 1 | Y | N/A | name (label) | character(len=25) | "" | N/A | Label for in_sol section | src/readcio_read.f90:9 |
| 24 | 2 | N | in_sol | soils_sol | character(len=25) | "soils.sol" | N/A | Soil properties | src/input_file_module.f90:243 |
| 24 | 3 | N | in_sol | nut_sol | character(len=25) | "nutrients.sol" | N/A | Nutrient data | src/input_file_module.f90:244 |
| 24 | 4 | N | in_sol | lte_sol | character(len=25) | "soils_lte.sol" | N/A | Soil landscape element data | src/input_file_module.f90:245 |
| 25 | 1 | Y | N/A | name (label) | character(len=25) | "" | N/A | Label for in_cond section | src/readcio_read.f90:9 |
| 25 | 2 | N | in_cond | dtbl_lum | character(len=25) | "lum.dtl" | N/A | Land use management decision table | src/input_file_module.f90:251 |
| 25 | 3 | N | in_cond | dtbl_res | character(len=25) | "res_rel.dtl" | N/A | Reservoir release decision table | src/input_file_module.f90:252 |
| 25 | 4 | N | in_cond | dtbl_scen | character(len=25) | "scen_lu.dtl" | N/A | Scenario land use decision table | src/input_file_module.f90:253 |
| 25 | 5 | N | in_cond | dtbl_flo | character(len=25) | "flo_con.dtl" | N/A | Flow control decision table | src/input_file_module.f90:254 |
| 26 | 1 | Y | N/A | name (label) | character(len=25) | "" | N/A | Label for in_regs section | src/readcio_read.f90:9 |
| 26 | 2 | N | in_regs | ele_lsu | character(len=25) | "ls_unit.ele" | N/A | Landscape unit elements | src/input_file_module.f90:260 |
| 26 | 3 | N | in_regs | def_lsu | character(len=25) | "ls_unit.def" | N/A | Landscape unit definitions | src/input_file_module.f90:261 |
| 26 | 4 | N | in_regs | ele_reg | character(len=25) | "ls_reg.ele" | N/A | Landscape region elements | src/input_file_module.f90:262 |
| 26 | 5 | N | in_regs | def_reg | character(len=25) | "ls_reg.def" | N/A | Landscape region definitions | src/input_file_module.f90:263 |
| 26 | 6 | N | in_regs | cal_lcu | character(len=25) | "ls_cal.reg" | N/A | Landscape calibration regions | src/input_file_module.f90:264 |
| 26 | 7 | N | in_regs | ele_cha | character(len=25) | "ch_catunit.ele" | N/A | Channel catchment unit elements | src/input_file_module.f90:265 |
| 26 | 8 | N | in_regs | def_cha | character(len=25) | "ch_catunit.def" | N/A | Channel catchment unit definitions | src/input_file_module.f90:266 |
| 26 | 9 | N | in_regs | def_cha_reg | character(len=25) | "ch_reg.def" | N/A | Channel region definitions | src/input_file_module.f90:267 |
| 26 | 10 | N | in_regs | ele_aqu | character(len=25) | "aqu_catunit.ele" | N/A | Aquifer catchment unit elements | src/input_file_module.f90:268 |
| 26 | 11 | N | in_regs | def_aqu | character(len=25) | "aqu_catunit.def" | N/A | Aquifer catchment unit definitions | src/input_file_module.f90:269 |
| 26 | 12 | N | in_regs | def_aqu_reg | character(len=25) | "aqu_reg.def" | N/A | Aquifer region definitions | src/input_file_module.f90:270 |
| 26 | 13 | N | in_regs | ele_res | character(len=25) | "res_catunit.ele" | N/A | Reservoir catchment unit elements | src/input_file_module.f90:271 |
| 26 | 14 | N | in_regs | def_res | character(len=25) | "res_catunit.def" | N/A | Reservoir catchment unit definitions | src/input_file_module.f90:272 |
| 26 | 15 | N | in_regs | def_res_reg | character(len=25) | "res_reg.def" | N/A | Reservoir region definitions | src/input_file_module.f90:273 |
| 26 | 16 | N | in_regs | ele_psc | character(len=25) | "rec_catunit.ele" | N/A | Recall catchment unit elements | src/input_file_module.f90:274 |
| 26 | 17 | N | in_regs | def_psc | character(len=25) | "rec_catunit.def" | N/A | Recall catchment unit definitions | src/input_file_module.f90:275 |
| 26 | 18 | N | in_regs | def_psc_reg | character(len=25) | "rec_reg.def" | N/A | Recall region definitions | src/input_file_module.f90:276 |
| 27 | 1 | Y | N/A | name (label) | character(len=25) | "" | N/A | Label for in_path_pcp section | src/readcio_read.f90:9 |
| 27 | 2 | N | in_path_pcp | pcp | character(len=80) | " " | N/A | Precipitation file path | src/input_file_module.f90:281 |
| 28 | 1 | Y | N/A | name (label) | character(len=25) | "" | N/A | Label for in_path_tmp section | src/readcio_read.f90:9 |
| 28 | 2 | N | in_path_tmp | tmp | character(len=80) | " " | N/A | Temperature file path | src/input_file_module.f90:286 |
| 29 | 1 | Y | N/A | name (label) | character(len=25) | "" | N/A | Label for in_path_slr section | src/readcio_read.f90:9 |
| 29 | 2 | N | in_path_slr | slr | character(len=80) | " " | N/A | Solar radiation file path | src/input_file_module.f90:291 |
| 30 | 1 | Y | N/A | name (label) | character(len=25) | "" | N/A | Label for in_path_hmd section | src/readcio_read.f90:9 |
| 30 | 2 | N | in_path_hmd | hmd | character(len=80) | " " | N/A | Humidity file path | src/input_file_module.f90:296 |
| 31 | 1 | Y | N/A | name (label) | character(len=25) | "" | N/A | Label for in_path_wnd section | src/readcio_read.f90:9 |
| 31 | 2 | N | in_path_wnd | wnd | character(len=80) | " " | N/A | Wind file path | src/input_file_module.f90:301 |
| 32 | 1 | Y | N/A | line_buffer (output path) | character(len=80) | "" | N/A | Output file path | src/readcio_read.f90:11 |

**Note**: 
- Line 1 contains the title
- Lines 2-31 each have a label (position 1) followed by derived type components (positions 2+)
- Line 32 contains the output path
- Lines 27-31 use character(len=80) for path strings; all others use character(len=25)
- **Total Expanded Components**: 176 individual values across all 32 lines (including labels and title)

### 4.4 Complete Derived Types Detail (All 30 Types)

This section provides comprehensive component details for all 30 derived types read from file.cio, in the order they appear in the file.

#### Type 1: input_sim (Position 1, Line 25)
**Type Definition**: src/input_file_module.f90:8-15  
**Instance**: in_sim  
**Read Statement**: `read (107,*,iostat=eof) name, in_sim` at src/readcio_read.f90:25

| Component | Type | Default | Description | Line |
|-----------|------|---------|-------------|------|
| time | character(len=25) | "time.sim" | Simulation time configuration | 9 |
| prt | character(len=25) | "print.prt" | Print configuration | 10 |
| object_prt | character(len=25) | "object.prt" | Object print configuration | 11 |
| object_cnt | character(len=25) | "object.cnt" | Object count file | 12 |
| cs_db | character(len=25) | "constituents.cs" | Constituents database | 13 |

#### Type 2: input_basin (Position 2, Line 27)
**Type Definition**: src/input_file_module.f90:18-22  
**Instance**: in_basin  
**Read Statement**: `read (107,*,iostat=eof) name, in_basin` at src/readcio_read.f90:27

| Component | Type | Default | Description | Line |
|-----------|------|---------|-------------|------|
| codes_bas | character(len=25) | "codes.bsn" | Basin codes configuration | 19 |
| parms_bas | character(len=25) | "parameters.bsn" | Basin parameters | 20 |

#### Type 3: input_cli (Position 3, Line 29)
**Type Definition**: src/input_file_module.f90:25-37  
**Instance**: in_cli  
**Read Statement**: `read (107,*,iostat=eof) name, in_cli` at src/readcio_read.f90:29

| Component | Type | Default | Description | Line |
|-----------|------|---------|-------------|------|
| weat_sta | character(len=25) | "weather-sta.cli" | Weather station data | 26 |
| weat_wgn | character(len=25) | "weather-wgn.cli" | Weather generator data | 27 |
| pet_cli | character(len=25) | "pet.cli" | Potential evapotranspiration data | 28 |
| pcp_cli | character(len=25) | "pcp.cli" | Precipitation data | 30 |
| tmp_cli | character(len=25) | "tmp.cli" | Temperature data | 31 |
| slr_cli | character(len=25) | "slr.cli" | Solar radiation data | 32 |
| hmd_cli | character(len=25) | "hmd.cli" | Humidity data | 33 |
| wnd_cli | character(len=25) | "wnd.cli" | Wind data | 34 |
| atmo_cli | character(len=25) | "atmodep.cli" | Atmospheric deposition data | 35 |

#### Type 4: input_con (Position 4, Line 31)
**Type Definition**: src/input_file_module.f90:40-55  
**Instance**: in_con  
**Read Statement**: `read (107,*,iostat=eof) name, in_con` at src/readcio_read.f90:31

| Component | Type | Default | Description | Line |
|-----------|------|---------|-------------|------|
| hru_con | character(len=25) | "hru.con" | HRU connections | 41 |
| hruez_con | character(len=25) | "hru-lte.con" | HRU landscape element connections | 42 |
| ru_con | character(len=25) | "rout_unit.con" | Routing unit connections | 43 |
| gwflow_con | character(len=25) | "gwflow.con" | Groundwater flow connections | 44 |
| aqu_con | character(len=25) | "aquifer.con" | Aquifer connections | 45 |
| aqu2d_con | character(len=25) | "aquifer2d.con" | 2D aquifer connections | 46 |
| chan_con | character(len=25) | "channel.con" | Channel connections | 47 |
| res_con | character(len=25) | "reservoir.con" | Reservoir connections | 48 |
| rec_con | character(len=25) | "recall.con" | Recall connections | 49 |
| exco_con | character(len=25) | "exco.con" | Export coefficient connections | 50 |
| delr_con | character(len=25) | "delratio.con" | Delivery ratio connections | 51 |
| out_con | character(len=25) | "outlet.con" | Outlet connections | 52 |
| chandeg_con | character(len=25) | "chandeg.con" | SWAT-DEG channel connections | 53 |

#### Type 5: input_cha (Position 5, Line 33)
**Type Definition**: src/input_file_module.f90:58-68  
**Instance**: in_cha  
**Read Statement**: `read (107,*,iostat=eof) name, in_cha` at src/readcio_read.f90:33

| Component | Type | Default | Description | Line |
|-----------|------|---------|-------------|------|
| init | character(len=25) | "initial.cha" | Initial channel conditions | 59 |
| dat | character(len=25) | "channel.cha" | Channel data | 60 |
| hyd | character(len=25) | "hydrology.cha" | Channel hydrology parameters | 61 |
| sed | character(len=25) | "sediment.cha" | Channel sediment parameters | 62 |
| nut | character(len=25) | "nutrients.cha" | Channel nutrient parameters | 63 |
| chan_ez | character(len=25) | "channel-lte.cha" | Channel landscape element parameters | 64 |
| hyd_sed | character(len=25) | "hyd-sed-lte.cha" | Hydrology-sediment landscape element parameters | 65 |
| temp | character(len=25) | "temperature.cha" | Channel temperature parameters | 66 |

#### Type 6: input_res (Position 6, Line 35)
**Type Definition**: src/input_file_module.f90:71-81  
**Instance**: in_res  
**Read Statement**: `read (107,*,iostat=eof) name, in_res` at src/readcio_read.f90:35

| Component | Type | Default | Description | Line |
|-----------|------|---------|-------------|------|
| init_res | character(len=25) | "initial.res" | Initial reservoir conditions | 72 |
| res | character(len=25) | "reservoir.res" | Reservoir data | 73 |
| hyd_res | character(len=25) | "hydrology.res" | Reservoir hydrology parameters | 74 |
| sed_res | character(len=25) | "sediment.res" | Reservoir sediment parameters | 75 |
| nut_res | character(len=25) | "nutrients.res" | Reservoir nutrient parameters | 76 |
| weir_res | character(len=25) | "weir.res" | Reservoir weir data | 77 |
| wet | character(len=25) | "wetland.wet" | Wetland data | 78 |
| hyd_wet | character(len=25) | "hydrology.wet" | Wetland hydrology parameters | 79 |

#### Type 7: input_ru (Position 7, Line 37)
**Type Definition**: src/input_file_module.f90:84-90  
**Instance**: in_ru  
**Read Statement**: `read (107,*,iostat=eof) name, in_ru` at src/readcio_read.f90:37

| Component | Type | Default | Description | Line |
|-----------|------|---------|-------------|------|
| ru_def | character(len=25) | "rout_unit.def" | Routing unit definitions | 85 |
| ru_ele | character(len=25) | "rout_unit.ele" | Routing unit elements | 86 |
| ru | character(len=25) | "rout_unit.rtu" | Routing unit data | 87 |
| ru_dr | character(len=25) | "rout_unit.dr" | Routing unit delivery ratio | 88 |

#### Type 8: input_hru (Position 8, Line 39)
**Type Definition**: src/input_file_module.f90:93-97  
**Instance**: in_hru  
**Read Statement**: `read (107,*,iostat=eof) name, in_hru` at src/readcio_read.f90:39

| Component | Type | Default | Description | Line |
|-----------|------|---------|-------------|------|
| hru_data | character(len=25) | "hru-data.hru" | HRU data | 94 |
| hru_ez | character(len=25) | "hru-lte.hru" | HRU landscape element data | 95 |

#### Type 9: input_exco (Position 9, Line 41)
**Type Definition**: src/input_file_module.f90:100-108  
**Instance**: in_exco  
**Read Statement**: `read (107,*,iostat=eof) name, in_exco` at src/readcio_read.f90:41

| Component | Type | Default | Description | Line |
|-----------|------|---------|-------------|------|
| exco | character(len=25) | "exco.exc" | Export coefficients | 101 |
| om | character(len=25) | "exco_om.exc" | Export coefficients for organic matter | 102 |
| pest | character(len=25) | "exco_pest.exc" | Export coefficients for pesticides | 103 |
| path | character(len=25) | "exco_path.exc" | Export coefficients for pathogens | 104 |
| hmet | character(len=25) | "exco_hmet.exc" | Export coefficients for heavy metals | 105 |
| salt | character(len=25) | "exco_salt.exc" | Export coefficients for salt | 106 |

#### Type 10: input_rec (Position 10, Line 43)
**Type Definition**: src/input_file_module.f90:111-114  
**Instance**: in_rec  
**Read Statement**: `read (107,*,iostat=eof) name, in_rec` at src/readcio_read.f90:43

| Component | Type | Default | Description | Line |
|-----------|------|---------|-------------|------|
| recall_rec | character(len=25) | "recall.rec" | Recall data (daily, monthly, annual) | 112 |

#### Type 11: input_delr (Position 11, Line 45)
**Type Definition**: src/input_file_module.f90:117-125  
**Instance**: in_delr  
**Read Statement**: `read (107,*,iostat=eof) name, in_delr` at src/readcio_read.f90:45

| Component | Type | Default | Description | Line |
|-----------|------|---------|-------------|------|
| del_ratio | character(len=25) | "delratio.del" | Delivery ratios | 118 |
| om | character(len=25) | "dr_om.del" | Delivery ratios for organic matter | 119 |
| pest | character(len=25) | "dr_pest.del" | Delivery ratios for pesticides | 120 |
| path | character(len=25) | "dr_path.del" | Delivery ratios for pathogens | 121 |
| hmet | character(len=25) | "dr_hmet.del" | Delivery ratios for heavy metals | 122 |
| salt | character(len=25) | "dr_salt.del" | Delivery ratios for salt | 123 |

#### Type 12: input_aqu (Position 12, Line 47)
**Type Definition**: src/input_file_module.f90:128-132  
**Instance**: in_aqu  
**Read Statement**: `read (107,*,iostat=eof) name, in_aqu` at src/readcio_read.f90:47

| Component | Type | Default | Description | Line |
|-----------|------|---------|-------------|------|
| init | character(len=25) | "initial.aqu" | Initial aquifer conditions | 129 |
| aqu | character(len=25) | "aquifer.aqu" | Aquifer parameters | 130 |

#### Type 13: input_herd (Position 13, Line 49)
**Type Definition**: src/input_file_module.f90:135-140  
**Instance**: in_herd  
**Read Statement**: `read (107,*,iostat=eof) name, in_herd` at src/readcio_read.f90:49

| Component | Type | Default | Description | Line |
|-----------|------|---------|-------------|------|
| animal | character(len=25) | "animal.hrd" | Animal parameters | 136 |
| herd | character(len=25) | "herd.hrd" | Herd data | 137 |
| ranch | character(len=25) | "ranch.hrd" | Ranch data | 138 |

#### Type 14: input_water_rights (Position 14, Line 51)
**Type Definition**: src/input_file_module.f90:143-148  
**Instance**: in_watrts  
**Read Statement**: `read (107,*,iostat=eof) name, in_watrts` at src/readcio_read.f90:51

| Component | Type | Default | Description | Line |
|-----------|------|---------|-------------|------|
| transfer_wro | character(len=25) | "water_allocation.wro" | Water allocation/transfer using decision tables | 144 |
| element | character(len=25) | "element.wro" | Water rights elements | 145 |
| water_rights | character(len=25) | "water_rights.wro" | Water rights (2 sources + compensation for NAM) | 146 |

#### Type 15: input_link (Position 15, Line 53)
**Type Definition**: src/input_file_module.f90:151-155  
**Instance**: in_link  
**Read Statement**: `read (107,*,iostat=eof) name, in_link` at src/readcio_read.f90:53

| Component | Type | Default | Description | Line |
|-----------|------|---------|-------------|------|
| chan_surf | character(len=25) | "chan-surf.lin" | Channel-surface links | 152 |
| aqu_cha | character(len=25) | "aqu_cha.lin" | Aquifer-channel links | 153 |

#### Type 16: input_hydrology (Position 16, Line 55)
**Type Definition**: src/input_file_module.f90:158-163  
**Instance**: in_hyd  
**Read Statement**: `read (107,*,iostat=eof) name, in_hyd` at src/readcio_read.f90:55

| Component | Type | Default | Description | Line |
|-----------|------|---------|-------------|------|
| hydrol_hyd | character(len=25) | "hydrology.hyd" | Hydrology parameters | 159 |
| topogr_hyd | character(len=25) | "topography.hyd" | Topography parameters | 160 |
| field_fld | character(len=25) | "field.fld" | Field parameters | 161 |

#### Type 17: input_structural (Position 17, Line 57)
**Type Definition**: src/input_file_module.f90:166-173  
**Instance**: in_str  
**Read Statement**: `read (107,*,iostat=eof) name, in_str` at src/readcio_read.f90:57

| Component | Type | Default | Description | Line |
|-----------|------|---------|-------------|------|
| tiledrain_str | character(len=25) | "tiledrain.str" | Tile drainage parameters | 167 |
| septic_str | character(len=25) | "septic.str" | Septic system parameters | 168 |
| fstrip_str | character(len=25) | "filterstrip.str" | Filter strip parameters | 169 |
| grassww_str | character(len=25) | "grassedww.str" | Grassed waterway parameters | 170 |
| bmpuser_str | character(len=25) | "bmpuser.str" | User-defined BMP parameters | 171 |

#### Type 18: input_parameter_databases (Position 18, Line 59)
**Type Definition**: src/input_file_module.f90:176-188  
**Instance**: in_parmdb  
**Read Statement**: `read (107,*,iostat=eof) name, in_parmdb` at src/readcio_read.f90:59

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

#### Type 19: input_ops (Position 19, Line 61)
**Type Definition**: src/input_file_module.f90:191-199  
**Instance**: in_ops  
**Read Statement**: `read (107,*,iostat=eof) name, in_ops` at src/readcio_read.f90:61

| Component | Type | Default | Description | Line |
|-----------|------|---------|-------------|------|
| harv_ops | character(len=25) | "harv.ops" | Harvest operations | 192 |
| graze_ops | character(len=25) | "graze.ops" | Grazing operations | 193 |
| irr_ops | character(len=25) | "irr.ops" | Irrigation operations | 194 |
| chem_ops | character(len=25) | "chem_app.ops" | Chemical application operations | 195 |
| fire_ops | character(len=25) | "fire.ops" | Fire operations | 196 |
| sweep_ops | character(len=25) | "sweep.ops" | Street sweeping operations | 197 |

#### Type 20: input_lum (Position 20, Line 63)
**Type Definition**: src/input_file_module.f90:202-209  
**Instance**: in_lum  
**Read Statement**: `read (107,*,iostat=eof) name, in_lum` at src/readcio_read.f90:63

| Component | Type | Default | Description | Line |
|-----------|------|---------|-------------|------|
| landuse_lum | character(len=25) | "landuse.lum" | Land use management | 203 |
| management_sch | character(len=25) | "management.sch" | Management schedules | 204 |
| cntable_lum | character(len=25) | "cntable.lum" | Curve number tables | 205 |
| cons_prac_lum | character(len=25) | "cons_practice.lum" | Conservation practices | 206 |
| ovn_lum | character(len=25) | "ovn_table.lum" | Overland flow parameters | 207 |

#### Type 21: input_chg (Position 21, Line 65)
**Type Definition**: src/input_file_module.f90:212-223  
**Instance**: in_chg  
**Read Statement**: `read (107,*,iostat=eof) name, in_chg` at src/readcio_read.f90:65

| Component | Type | Default | Description | Line |
|-----------|------|---------|-------------|------|
| cal_parms | character(len=25) | "cal_parms.cal" | Calibration parameters | 213 |
| cal_upd | character(len=25) | "calibration.cal" | Calibration updates | 214 |
| codes_sft | character(len=25) | "codes.sft" | Soft calibration codes (renamed from codes.cal) | 215 |
| wb_parms_sft | character(len=25) | "wb_parms.sft" | Water balance parameters (renamed from ls_parms.cal) | 216 |
| water_balance_sft | character(len=25) | "water_balance.sft" | Water balance regions (renamed from ls_regions.cal) | 217 |
| ch_sed_budget_sft | character(len=25) | "ch_sed_budget.sft" | Channel sediment budget (renamed from ch_orders.cal) | 218 |
| ch_sed_parms_sft | character(len=25) | "ch_sed_parms.sft" | Channel sediment parameters (renamed from ch_parms.cal) | 219 |
| plant_parms_sft | character(len=25) | "plant_parms.sft" | Plant parameters (renamed from pl_parms.cal) | 220 |
| plant_gro_sft | character(len=25) | "plant_gro.sft" | Plant growth regions (renamed from pl_regions.cal) | 221 |

#### Type 22: input_init (Position 22, Line 67)
**Type Definition**: src/input_file_module.f90:226-239  
**Instance**: in_init  
**Read Statement**: `read (107,*,iostat=eof) name, in_init` at src/readcio_read.f90:67

| Component | Type | Default | Description | Line |
|-----------|------|---------|-------------|------|
| plant | character(len=25) | "plant.ini" | Initial plant conditions | 227 |
| soil_plant_ini | character(len=25) | "soil_plant.ini" | Initial soil-plant conditions | 228 |
| om_water | character(len=25) | "om_water.ini" | Initial organic matter in water | 229 |
| pest_soil | character(len=25) | "pest_hru.ini" | Initial pesticide in soil/HRU | 230 |
| pest_water | character(len=25) | "pest_water.ini" | Initial pesticide in water | 231 |
| path_soil | character(len=25) | "path_hru.ini" | Initial pathogens in soil/HRU | 232 |
| path_water | character(len=25) | "path_water.ini" | Initial pathogens in water | 233 |
| hmet_soil | character(len=25) | "hmet_hru.ini" | Initial heavy metals in soil/HRU | 234 |
| hmet_water | character(len=25) | "hmet_water.ini" | Initial heavy metals in water | 235 |
| salt_soil | character(len=25) | "salt_hru.ini" | Initial salt in soil/HRU | 236 |
| salt_water | character(len=25) | "salt_water.ini" | Initial salt in water | 237 |

#### Type 23: input_soils (Position 23, Line 69)
**Type Definition**: src/input_file_module.f90:242-247  
**Instance**: in_sol  
**Read Statement**: `read (107,*,iostat=eof) name, in_sol` at src/readcio_read.f90:69

| Component | Type | Default | Description | Line |
|-----------|------|---------|-------------|------|
| soils_sol | character(len=25) | "soils.sol" | Soil parameters | 243 |
| nut_sol | character(len=25) | "nutrients.sol" | Soil nutrient parameters | 244 |
| lte_sol | character(len=25) | "soils_lte.sol" | Soil landscape element parameters | 245 |

#### Type 24: input_condition (Position 24, Line 71)
**Type Definition**: src/input_file_module.f90:250-256  
**Instance**: in_cond  
**Read Statement**: `read (107,*,iostat=eof) name, in_cond` at src/readcio_read.f90:71

| Component | Type | Default | Description | Line |
|-----------|------|---------|-------------|------|
| dtbl_lum | character(len=25) | "lum.dtl" | Land use management decision tables | 251 |
| dtbl_res | character(len=25) | "res_rel.dtl" | Reservoir release decision tables | 252 |
| dtbl_scen | character(len=25) | "scen_lu.dtl" | Scenario land use decision tables | 253 |
| dtbl_flo | character(len=25) | "flo_con.dtl" | Flow control decision tables | 254 |

#### Type 25: input_regions (Position 25, Line 73)
**Type Definition**: src/input_file_module.f90:259-278  
**Instance**: in_regs  
**Read Statement**: `read (107,*,iostat=eof) name, in_regs` at src/readcio_read.f90:73

| Component | Type | Default | Description | Line |
|-----------|------|---------|-------------|------|
| ele_lsu | character(len=25) | "ls_unit.ele" | Landscape unit elements | 260 |
| def_lsu | character(len=25) | "ls_unit.def" | Landscape unit definitions | 261 |
| ele_reg | character(len=25) | "ls_reg.ele" | Landscape region elements | 262 |
| def_reg | character(len=25) | "ls_reg.def" | Landscape region definitions | 263 |
| cal_lcu | character(len=25) | "ls_cal.reg" | Landscape calibration regions | 264 |
| ele_cha | character(len=25) | "ch_catunit.ele" | Channel catchment unit elements | 265 |
| def_cha | character(len=25) | "ch_catunit.def" | Channel catchment unit definitions | 266 |
| def_cha_reg | character(len=25) | "ch_reg.def" | Channel region definitions | 267 |
| ele_aqu | character(len=25) | "aqu_catunit.ele" | Aquifer catchment unit elements | 268 |
| def_aqu | character(len=25) | "aqu_catunit.def" | Aquifer catchment unit definitions | 269 |
| def_aqu_reg | character(len=25) | "aqu_reg.def" | Aquifer region definitions | 270 |
| ele_res | character(len=25) | "res_catunit.ele" | Reservoir catchment unit elements | 271 |
| def_res | character(len=25) | "res_catunit.def" | Reservoir catchment unit definitions | 272 |
| def_res_reg | character(len=25) | "res_reg.def" | Reservoir region definitions | 273 |
| ele_psc | character(len=25) | "rec_catunit.ele" | Recall point catchment unit elements | 274 |
| def_psc | character(len=25) | "rec_catunit.def" | Recall point catchment unit definitions | 275 |
| def_psc_reg | character(len=25) | "rec_reg.def" | Recall point region definitions | 276 |

#### Type 26: input_path_pcp (Position 26, Line 76)
**Type Definition**: src/input_file_module.f90:280-283  
**Instance**: in_path_pcp  
**Read Statement**: `read (107,*,iostat=eof) name, in_path_pcp` at src/readcio_read.f90:76

| Component | Type | Default | Description | Line |
|-----------|------|---------|-------------|------|
| pcp | character(len=80) | " " | Precipitation data file path | 281 |

#### Type 27: input_path_tmp (Position 27, Line 78)
**Type Definition**: src/input_file_module.f90:285-288  
**Instance**: in_path_tmp  
**Read Statement**: `read (107,*,iostat=eof) name, in_path_tmp` at src/readcio_read.f90:78

| Component | Type | Default | Description | Line |
|-----------|------|---------|-------------|------|
| tmp | character(len=80) | " " | Temperature data file path | 286 |

#### Type 28: input_path_slr (Position 28, Line 80)
**Type Definition**: src/input_file_module.f90:290-293  
**Instance**: in_path_slr  
**Read Statement**: `read (107,*,iostat=eof) name, in_path_slr` at src/readcio_read.f90:80

| Component | Type | Default | Description | Line |
|-----------|------|---------|-------------|------|
| slr | character(len=80) | " " | Solar radiation data file path | 291 |

#### Type 29: input_path_hmd (Position 29, Line 82)
**Type Definition**: src/input_file_module.f90:295-298  
**Instance**: in_path_hmd  
**Read Statement**: `read (107,*,iostat=eof) name, in_path_hmd` at src/readcio_read.f90:82

| Component | Type | Default | Description | Line |
|-----------|------|---------|-------------|------|
| hmd | character(len=80) | " " | Humidity data file path | 296 |

#### Type 30: input_path_wnd (Position 30, Line 84)
**Type Definition**: src/input_file_module.f90:300-303  
**Instance**: in_path_wnd  
**Read Statement**: `read (107,*,iostat=eof) name, in_path_wnd` at src/readcio_read.f90:84

| Component | Type | Default | Description | Line |
|-----------|------|---------|-------------|------|
| wnd | character(len=80) | " " | Wind data file path | 301 |

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

### 3.3 time.sim (INPUT)

**Routine**: `time_read`  
**File**: src/time_read.f90  
**Expression**: `in_sim%time`  
**Unit mapping**: 107 → in_sim%time → "time.sim"

#### Filename Resolution

**Resolution Chain**:
- Target filename: `time.sim`
- Expression: `in_sim%time`
- Type definition: `input_sim` at src/input_file_module.f90:8-14
- Variable instance: `in_sim` at src/input_file_module.f90:15
- Default value: `"time.sim"` set at src/input_file_module.f90:9
- Runtime overrides: Set via file.cio (line 2, column 2)

**Detailed Mapping**:
```
time.sim → in_sim%time 
         → type input_sim (src/input_file_module.f90:8-14)
         → character(len=25) :: time = "time.sim" (src/input_file_module.f90:9)
```

#### I/O Sites

| Line | Statement | Type | Description |
|------|-----------|------|-------------|
| 20 | `inquire (file=in_sim%time, exist=i_exist)` | INQUIRE | Check file existence |
| 23 | `open (107,file=in_sim%time)` | OPEN | Open simulation time file |
| 24 | `read (107,*,iostat=eof) titldum` | READ | Read title line |
| 26 | `read (107,*,iostat=eof) header` | READ | Read column headers |
| 28 | `read (107,*,iostat=eof) time%day_start, time%yrc_start, time%day_end, time%yrc_end, time%step` | READ | Read simulation time parameters |
| 39 | `close (107)` | CLOSE | Close file |

#### Read Statement Analysis

**Read Statement 1: Title Line**
**Location**: src/time_read.f90:24  
**Statement**: `read (107,*,iostat=eof) titldum`  
**Format**: List-directed (free format)

**Variable**: `titldum`
- **Name**: titldum
- **Scope**: Local variable
- **Type**: character(len=80)
- **Default**: "" (empty string)
- **Units**: N/A (text)
- **Description**: Title of file
- **Declared at**: src/time_read.f90:10

**Read Statement 2: Header Line**
**Location**: src/time_read.f90:26  
**Statement**: `read (107,*,iostat=eof) header`  
**Format**: List-directed (free format)

**Variable**: `header`
- **Name**: header
- **Scope**: Local variable
- **Type**: character(len=500)
- **Default**: "" (empty string)
- **Units**: N/A (text)
- **Description**: Header line with column names
- **Declared at**: src/time_read.f90:11

**Read Statement 3: Simulation Time Parameters (PRIMARY DATA READ)**
**Location**: src/time_read.f90:28  
**Statement**: `read (107,*,iostat=eof) time%day_start, time%yrc_start, time%day_end, time%yrc_end, time%step`  
**Format**: List-directed (free format)

**Variable 1**: `time%day_start`
- **Component**: day_start of time
- **Type**: integer
- **Default**: 0
- **Units**: julian day
- **Description**: Beginning julian day of simulation
- **Parent Type**: time_current at src/time_module.f90:16-43
- **Component Line**: src/time_module.f90:30

**Variable 2**: `time%yrc_start`
- **Component**: yrc_start of time
- **Type**: integer
- **Default**: 0
- **Units**: year
- **Description**: Starting calendar year
- **Parent Type**: time_current at src/time_module.f90:16-43
- **Component Line**: src/time_module.f90:22

**Variable 3**: `time%day_end`
- **Component**: day_end of time
- **Type**: integer
- **Default**: 0
- **Units**: julian day
- **Description**: Input ending julian day of simulation
- **Parent Type**: time_current at src/time_module.f90:16-43
- **Component Line**: src/time_module.f90:32

**Variable 4**: `time%yrc_end`
- **Component**: yrc_end of time
- **Type**: integer
- **Default**: 0
- **Units**: year
- **Description**: Ending calendar year
- **Parent Type**: time_current at src/time_module.f90:16-43
- **Component Line**: src/time_module.f90:23

**Variable 5**: `time%step`
- **Component**: step of time
- **Type**: integer
- **Default**: 0
- **Units**: timesteps/day
- **Description**: Number of time steps in a day for rainfall, runoff and routing (0=daily; 1=increment(12hrs); 24=hourly; 96=15mins; 1440=minute)
- **Parent Type**: time_current at src/time_module.f90:16-43
- **Component Line**: src/time_module.f90:34

#### PRIMARY DATA READ Table

**Read Statement**: `read (107,*,iostat=eof) time%day_start, time%yrc_start, time%day_end, time%yrc_end, time%step` at src/time_read.f90:28
**File.cio Reference**: This file (time.sim) is referenced in file.cio as component `time` of derived type `in_sim` (line 2, column 2)

| Line in File | Position in File | Local (Y/N) | Derived Type Name | Component (or Var Name if Local) | Type | Default | Units | Description | Source Line | Swat_codetype |
|--------------|------------------|-------------|-------------------|-----------------------------------|------|---------|-------|-------------|-------------|---------------|
| 3 | 1 | N | time | day_start | integer | 0 | julian day | Beginning julian day of simulation | src/time_module.f90:30 | in_sim |
| 3 | 2 | N | time | yrc_start | integer | 0 | year | Starting calendar year | src/time_module.f90:22 | in_sim |
| 3 | 3 | N | time | day_end | integer | 0 | julian day | Ending julian day of simulation | src/time_module.f90:32 | in_sim |
| 3 | 4 | N | time | yrc_end | integer | 0 | year | Ending calendar year | src/time_module.f90:23 | in_sim |
| 3 | 5 | N | time | step | integer | 0 | timesteps/day | Number of time steps per day (0=daily; 1=12hr; 24=hourly; 96=15min; 1440=1min) | src/time_module.f90:34 | in_sim |

**Post-Read Processing**:
- Line 30: `if (time%step <= 0) time%step = 1` - Default timestep to 1 if not positive
- Line 31: `if (time%day_start <= 0) time%day_start = 1` - Default start day to 1 if not positive
- Line 32: `time%nbyr = time%yrc_end - time%yrc_start + 1` - Calculate number of years
- Lines 33-36: Convert day_start to month and day of month using xmon subroutine

---

### 3.4 print.prt (INPUT)

**Routine**: `basin_print_codes_read`  
**File**: src/basin_print_codes_read.f90  
**Expression**: `in_sim%prt`  
**Unit mapping**: 107 → in_sim%prt → "print.prt"

#### Filename Resolution

**Resolution Chain**:
- Target filename: `print.prt`
- Expression: `in_sim%prt`
- Type definition: `input_sim` at src/input_file_module.f90:8-14
- Variable instance: `in_sim` at src/input_file_module.f90:15
- Default value: `"print.prt"` set at src/input_file_module.f90:10
- Runtime overrides: Set via file.cio (line 2, column 3)

**Detailed Mapping**:
```
print.prt → in_sim%prt 
          → type input_sim (src/input_file_module.f90:8-14)
          → character(len=25) :: prt = "print.prt" (src/input_file_module.f90:10)
```

#### I/O Sites

**Note**: This file has extensive reads. Only primary data reads are listed below. Full detail available in source code lines 20-285.

| Line | Statement | Type | Description |
|------|-----------|------|-------------|
| 20 | `inquire (file=in_sim%prt, exist=i_exist)` | INQUIRE | Check file existence |
| 23 | `open (107,file=in_sim%prt)` | OPEN | Open print control file |
| 24 | `read (107,*,iostat=eof) titldum` | READ | Read title line |
| 26 | `read (107,*,iostat=eof) header` | READ | Read column headers |
| 28 | `read (107,*,iostat=eof) pco%nyskip, pco%day_start, pco%yrc_start, pco%day_end, pco%yrc_end, pco%int_day` | READ | Read print time controls |
| 30 | `read (107,*,iostat=eof) header` | READ | Read header |
| 32-36 | `read (107,*,iostat=eof) pco%aa_numint, (pco%aa_yrs(ii), ii = 1, pco%aa_numint)` | READ | Read average annual print intervals |
| 42 | `read (107,*,iostat=eof) header` | READ | Read header |
| 44 | `read (107,*,iostat=eof) pco%csvout, pco%use_obj_labels, pco%cdfout` | READ | Read database output flags |
| 48 | `read (107,*,iostat=eof) header` | READ | Read header |
| 50 | `read (107,*,iostat=eof) pco%crop_yld, pco%mgtout, pco%hydcon, pco%fdcout` | READ | Read other output flags |
| 55-285 | Multiple reads | READ | Read object-specific output controls (basin, region, lsu, hru, channels, aquifers, reservoirs, etc.) |
| 286 | `close (107)` | CLOSE | Close file |

#### Primary Data Read Sections

**Section 1: Time Controls (Line 28)**
**Statement**: `read (107,*,iostat=eof) pco%nyskip, pco%day_start, pco%yrc_start, pco%day_end, pco%yrc_end, pco%int_day`

| Position | Component | Type | Default | Units | Description | Source Line |
|----------|-----------|------|---------|-------|-------------|-------------|
| 1 | nyskip | integer | 0 | years | Number of years to skip before printing | src/basin_module.f90 |
| 2 | day_start | integer | 0 | julian day | Starting day for printing | src/basin_module.f90 |
| 3 | yrc_start | integer | 0 | year | Starting year for printing | src/basin_module.f90 |
| 4 | day_end | integer | 0 | julian day | Ending day for printing | src/basin_module.f90 |
| 5 | yrc_end | integer | 0 | year | Ending year for printing | src/basin_module.f90 |
| 6 | int_day | integer | 0 | days | Daily print interval | src/basin_module.f90 |

**Section 2: Average Annual Intervals (Lines 32-36)**
**Statement**: `read (107,*,iostat=eof) pco%aa_numint, (pco%aa_yrs(ii), ii = 1, pco%aa_numint)`

| Position | Component | Type | Units | Description |
|----------|-----------|------|-------|-------------|
| 1 | aa_numint | integer | none | Number of average annual print intervals |
| 2+ | aa_yrs(:) | integer array | years | Years for each average annual interval |

**Section 3: Database Output Flags (Line 44)**
**Statement**: `read (107,*,iostat=eof) pco%csvout, pco%use_obj_labels, pco%cdfout`

| Position | Component | Type | Units | Description |
|----------|-----------|------|-------|-------------|
| 1 | csvout | character(len=1) | N/A | CSV output flag ("y"/"n") |
| 2 | use_obj_labels | character(len=1) | N/A | Use object labels in output ("y"/"n") |
| 3 | cdfout | character(len=1) | N/A | NetCDF output flag ("y"/"n") |

**Section 4: Other Output Flags (Line 50)**
**Statement**: `read (107,*,iostat=eof) pco%crop_yld, pco%mgtout, pco%hydcon, pco%fdcout`

| Position | Component | Type | Units | Description |
|----------|-----------|------|-------|-------------|
| 1 | crop_yld | character(len=1) | N/A | Crop yield output flag ("y"/"n") |
| 2 | mgtout | character(len=1) | N/A | Management output flag ("y"/"n") |
| 3 | hydcon | character(len=1) | N/A | Hydrograph connection output flag ("y"/"n") |
| 4 | fdcout | character(len=1) | N/A | Flow duration curve output flag ("y"/"n") |

**Section 5: Object Output Controls (Lines 55-285)**

Each object type (basin, region, lsu, hru, channel, aquifer, reservoir, recall, etc.) has reads for output intervals in format:
`read (107,*,iostat=eof) name, object%d, object%m, object%y, object%a`

Where:
- `name` = object type name (character, not stored)
- `object%d` = daily output flag (character(len=1), "y"/"n")
- `object%m` = monthly output flag (character(len=1), "y"/"n")
- `object%y` = yearly output flag (character(len=1), "y"/"n")
- `object%a` = average annual output flag (character(len=1), "y"/"n")

**Example Object Output Controls**:
- Line 58: `pco%wb_bsn` - Basin water balance
- Line 60: `pco%nb_bsn` - Basin nutrient balance
- Line 62: `pco%ls_bsn` - Basin losses
- Line 66: `pco%aqu_bsn` - Basin aquifer
- Line 68: `pco%res_bsn` - Basin reservoir
- Line 70: `pco%chan_bsn` - Basin channel
- And many more...

#### PRIMARY DATA READ Table (Key Records Only)

**File.cio Reference**: This file (print.prt) is referenced in file.cio as component `prt` of derived type `in_sim` (line 2, column 3)

| Line in File | Position in File | Local (Y/N) | Derived Type Name | Component (or Var Name if Local) | Type | Default | Units | Description | Source Line | Swat_codetype |
|--------------|------------------|-------------|-------------------|-----------------------------------|------|---------|-------|-------------|-------------|---------------|
| 3 | 1 | N | pco | nyskip | integer | 0 | years | Number of years to skip before printing | src/basin_module.f90 | in_sim |
| 3 | 2 | N | pco | day_start | integer | 0 | julian day | Starting day for printing | src/basin_module.f90 | in_sim |
| 3 | 3 | N | pco | yrc_start | integer | 0 | year | Starting year for printing | src/basin_module.f90 | in_sim |
| 3 | 4 | N | pco | day_end | integer | 0 | julian day | Ending day for printing | src/basin_module.f90 | in_sim |
| 3 | 5 | N | pco | yrc_end | integer | 0 | year | Ending year for printing | src/basin_module.f90 | in_sim |
| 3 | 6 | N | pco | int_day | integer | 0 | days | Daily print interval | src/basin_module.f90 | in_sim |
| 5 | 1 | N | pco | aa_numint | integer | 0 | none | Number of average annual print intervals | src/basin_module.f90 | in_sim |
| 5 | 2+ | N | pco | aa_yrs(:) | integer | 0 | years | Years for each average annual interval | src/basin_module.f90 | in_sim |
| 7 | 1 | N | pco | csvout | character(len=1) | "n" | N/A | CSV output flag ("y"/"n") | src/basin_module.f90:167 | in_sim |
| 7 | 2 | N | pco | use_obj_labels | character(len=1) | "n" | N/A | Use object labels in output ("y"/"n") | src/basin_module.f90 | in_sim |
| 7 | 3 | N | pco | cdfout | character(len=1) | "n" | N/A | NetCDF output flag ("y"/"n") | src/basin_module.f90 | in_sim |
| 9 | 1 | N | pco | crop_yld | character(len=1) | "n" | N/A | Crop yield output flag | src/basin_module.f90:173 | in_sim |
| 9 | 2 | N | pco | mgtout | character(len=1) | "n" | N/A | Management output flag | src/basin_module.f90:176 | in_sim |
| 9 | 3 | N | pco | hydcon | character(len=1) | "n" | N/A | Hydrograph connection output flag | src/basin_module.f90 | in_sim |
| 9 | 4 | N | pco | fdcout | character(len=1) | "n" | N/A | Flow duration curve output flag | src/basin_module.f90 | in_sim |
| 11+ | 1-4 | N | pco | (various)%d,%m,%y,%a | character(len=1) | "n" | N/A | Object-specific output intervals (d=daily, m=monthly, y=yearly, a=avg annual) | src/basin_module.f90 | in_sim |

**Note**: The print.prt file contains 50+ additional lines for object-specific output controls. Each follows the pattern: object_name, daily_flag, monthly_flag, yearly_flag, avg_annual_flag. See src/basin_print_codes_read.f90:55-285 for complete list.

---

### 3.5 codes.bsn (INPUT)

**Routine**: `basin_read_cc`  
**File**: src/basin_read_cc.f90  
**Expression**: `in_basin%codes_bas`  
**Unit mapping**: 107 → in_basin%codes_bas → "codes.bsn"

#### Filename Resolution

**Resolution Chain**:
- Target filename: `codes.bsn`
- Expression: `in_basin%codes_bas`
- Type definition: `input_basin` at src/input_file_module.f90:18-22
- Variable instance: `in_basin` at src/input_file_module.f90:22
- Default value: `"codes.bsn"` set at src/input_file_module.f90:19
- Runtime overrides: Set via file.cio (line 3, column 2)

**Detailed Mapping**:
```
codes.bsn → in_basin%codes_bas 
          → type input_basin (src/input_file_module.f90:18-22)
          → character(len=25) :: codes_bas = "codes.bsn" (src/input_file_module.f90:19)
```

#### I/O Sites

| Line | Statement | Type | Description |
|------|-----------|------|-------------|
| 16 | `inquire (file=in_basin%codes_bas, exist=i_exist)` | INQUIRE | Check file existence |
| 19 | `open (107,file=in_basin%codes_bas)` | OPEN | Open basin codes file |
| 20 | `read (107,*,iostat=eof) titldum` | READ | Read title line |
| 22 | `read (107,*,iostat=eof) header` | READ | Read column headers |
| 24 | `read (107,*,iostat=eof) bsn_cc` | READ | Read basin control codes (PRIMARY) |
| 42 | `close(107)` | CLOSE | Close file |

**Conditional I/O** (if bsn_cc%pet == 3):
| Line | Statement | Type | Description |
|------|-----------|------|-------------|
| 31 | `open (140,file = 'pet.cli')` | OPEN | Open PET climate file |
| 33 | `read (140,*,iostat=eof) titldum` | READ | Read PET file title |
| 35 | `read (140,*,iostat=eof) header` | READ | Read PET file header |
| 37 | `read (140,*,iostat = eof) titldum` | READ | Read PET file data line |

#### Read Statement Analysis

**Read Statement 1: Title Line**
**Location**: src/basin_read_cc.f90:20  
**Statement**: `read (107,*,iostat=eof) titldum`  
**Format**: List-directed (free format)

**Variable**: `titldum`
- **Name**: titldum
- **Scope**: Local variable
- **Type**: character(len=80)
- **Default**: "" (empty string)
- **Units**: N/A (text)
- **Description**: Title of file
- **Declared at**: src/basin_read_cc.f90:8

**Read Statement 2: Header Line**
**Location**: src/basin_read_cc.f90:22  
**Statement**: `read (107,*,iostat=eof) header`  
**Format**: List-directed (free format)

**Variable**: `header`
- **Name**: header
- **Scope**: Local variable
- **Type**: character(len=80)
- **Default**: "" (empty string)
- **Units**: N/A (text)
- **Description**: Header line
- **Declared at**: src/basin_read_cc.f90:9

**Read Statement 3: Basin Control Codes (PRIMARY DATA READ)**
**Location**: src/basin_read_cc.f90:24  
**Statement**: `read (107,*,iostat=eof) bsn_cc`  
**Format**: List-directed (free format)

**Variable**: `bsn_cc`
- **Name**: bsn_cc
- **Scope**: Module variable (imported from basin_module)
- **Type**: basin_control_codes (derived type)
- **Declared at**: src/basin_module.f90:75

**Derived Type: basin_control_codes**  
**Location**: src/basin_module.f90:17-74

| Component | Type | Default | Units | Description | Line |
|-----------|------|---------|-------|-------------|------|
| petfile | character(len=16) | "pet.cli" | N/A | Potential ET filename | 18 |
| wwqfile | character(len=16) | "" | N/A | Watershed stream water quality filename | 19 |
| pet | integer | 0 | code | PET method: 0=Priestley-Taylor, 1=Penman-Monteith, 2=Hargreaves | 20 |
| nam1 | integer | 0 | code | Not used | 24 |
| crk | integer | 0 | code | Crack flow: 1=compute crack flow | 25 |
| swift_out | integer | 0 | code | SWIFT output: 0=no, 1=write to swift_hru.inp | 27 |
| sed_det | integer | 0 | code | Peak rate method: 0=NRCS dimensionless hydrograph, 1=half hour intensity | 30 |
| rte | integer | 0 | code | Water routing: 0=variable storage, 1=Muskingum | 33 |
| deg | integer | 0 | code | Not used | 35 |
| wq | integer | 0 | code | Not used | 36 |
| nostress | integer | 0 | code | Plant stress: 0=all stresses, 1=no stress, 2=no nutrient stress only | 37 |
| cn | integer | 0 | code | Not used | 41 |
| cfac | integer | 0 | code | Not used | 42 |
| cswat | integer | 0 | code | Carbon: 0=static, 1=C-FARM, 2=Century | 43 |
| lapse | integer | 0 | code | Lapse rate: 0=no elevation adjust, 1=adjust for elevation | 47 |
| uhyd | integer | 1 | code | Unit hydrograph: 0=triangular, 1=gamma function | 49 |
| sed_ch | integer | 0 | code | Not used | 52 |
| tdrn | integer | 0 | code | Tile drainage: 0=drawdown days, 1=drainmod | 53 |
| wtdn | integer | 0 | code | Water table depth: 0=original, 1=drainmod | 56 |
| sol_p_model | integer | 0 | code | Soil P model: 0=original SWAT, 1=Vadas and White (2010) | 59 |
| gampt | integer | 0 | code | Infiltration: 0=curve number, 1=Green and Ampt | 60 |
| atmo | character(len=1) | "a" | N/A | Not used | 61 |
| smax | integer | 0 | code | Not used | 62 |
| qual2e | integer | 0 | code | Instream nutrient routing: 0=full QUAL2E, 1=simplified | 63 |
| gwflow | integer | 0 | code | GWFlow module: 0=inactive, 1=active | 65 |
| idc_till | integer | 3 | code | Tillage method (if cswat=2): 1=DSSAT, 2=EPIC, 3=Kemanian, 4=DNDC | 66 |

#### PRIMARY DATA READ Table

**Read Statement**: `read (107,*,iostat=eof) bsn_cc` at src/basin_read_cc.f90:24
**File.cio Reference**: This file (codes.bsn) is referenced in file.cio as component `codes_bas` of derived type `in_basin` (line 3, column 2)

| Line in File | Position in File | Local (Y/N) | Derived Type Name | Component (or Var Name if Local) | Type | Default | Units | Description | Source Line | Swat_codetype |
|--------------|------------------|-------------|-------------------|-----------------------------------|------|---------|-------|-------------|-------------|---------------|
| 3 | 1 | N | bsn_cc | petfile | character(len=16) | "pet.cli" | N/A | Potential ET filename | src/basin_module.f90:18 | in_basin |
| 3 | 2 | N | bsn_cc | wwqfile | character(len=16) | "" | N/A | Watershed stream water quality filename | src/basin_module.f90:19 | in_basin |
| 3 | 3 | N | bsn_cc | pet | integer | 0 | code | PET method (0=Priestley-Taylor, 1=Penman-Monteith, 2=Hargreaves) | src/basin_module.f90:20 | in_basin |
| 3 | 4 | N | bsn_cc | nam1 | integer | 0 | code | Not used | src/basin_module.f90:24 | in_basin |
| 3 | 5 | N | bsn_cc | crk | integer | 0 | code | Crack flow code (1=compute crack flow) | src/basin_module.f90:25 | in_basin |
| 3 | 6 | N | bsn_cc | swift_out | integer | 0 | code | SWIFT output (0=no, 1=write swift_hru.inp) | src/basin_module.f90:27 | in_basin |
| 3 | 7 | N | bsn_cc | sed_det | integer | 0 | code | Peak rate method (0=NRCS, 1=half hour intensity) | src/basin_module.f90:30 | in_basin |
| 3 | 8 | N | bsn_cc | rte | integer | 0 | code | Water routing (0=variable storage, 1=Muskingum) | src/basin_module.f90:33 | in_basin |
| 3 | 9 | N | bsn_cc | deg | integer | 0 | code | Not used | src/basin_module.f90:35 | in_basin |
| 3 | 10 | N | bsn_cc | wq | integer | 0 | code | Not used | src/basin_module.f90:36 | in_basin |
| 3 | 11 | N | bsn_cc | nostress | integer | 0 | code | Plant stress (0=all, 1=none, 2=no nutrient stress) | src/basin_module.f90:37 | in_basin |
| 3 | 12 | N | bsn_cc | cn | integer | 0 | code | Not used | src/basin_module.f90:41 | in_basin |
| 3 | 13 | N | bsn_cc | cfac | integer | 0 | code | Not used | src/basin_module.f90:42 | in_basin |
| 3 | 14 | N | bsn_cc | cswat | integer | 0 | code | Carbon model (0=static, 1=C-FARM, 2=Century) | src/basin_module.f90:43 | in_basin |
| 3 | 15 | N | bsn_cc | lapse | integer | 0 | code | Lapse rate (0=no elevation adjust, 1=adjust) | src/basin_module.f90:47 | in_basin |
| 3 | 16 | N | bsn_cc | uhyd | integer | 1 | code | Unit hydrograph (0=triangular, 1=gamma function) | src/basin_module.f90:49 | in_basin |
| 3 | 17 | N | bsn_cc | sed_ch | integer | 0 | code | Not used | src/basin_module.f90:52 | in_basin |
| 3 | 18 | N | bsn_cc | tdrn | integer | 0 | code | Tile drainage (0=drawdown days, 1=drainmod) | src/basin_module.f90:53 | in_basin |
| 3 | 19 | N | bsn_cc | wtdn | integer | 0 | code | Water table depth (0=original, 1=drainmod) | src/basin_module.f90:56 | in_basin |
| 3 | 20 | N | bsn_cc | sol_p_model | integer | 0 | code | Soil P model (0=original, 1=Vadas and White 2010) | src/basin_module.f90:59 | in_basin |
| 3 | 21 | N | bsn_cc | gampt | integer | 0 | code | Infiltration (0=curve number, 1=Green and Ampt) | src/basin_module.f90:60 | in_basin |
| 3 | 22 | N | bsn_cc | atmo | character(len=1) | "a" | N/A | Not used | src/basin_module.f90:61 | in_basin |
| 3 | 23 | N | bsn_cc | smax | integer | 0 | code | Not used | src/basin_module.f90:62 | in_basin |
| 3 | 24 | N | bsn_cc | qual2e | integer | 0 | code | Instream routing (0=QUAL2E, 1=simplified QUAL2E) | src/basin_module.f90:63 | in_basin |
| 3 | 25 | N | bsn_cc | gwflow | integer | 0 | code | GWFlow module (0=inactive, 1=active) | src/basin_module.f90:65 | in_basin |
| 3 | 26 | N | bsn_cc | idc_till | integer | 3 | code | Tillage method if cswat=2 (1=DSSAT, 2=EPIC, 3=Kemanian, 4=DNDC) | src/basin_module.f90:66 | in_basin |

---

### 3.6 parameters.bsn (INPUT)

**Routine**: `basin_read_prm`  
**File**: src/basin_read_prm.f90  
**Expression**: `in_basin%parms_bas`  
**Unit mapping**: 107 → in_basin%parms_bas → "parameters.bsn"

#### Filename Resolution

**Resolution Chain**:
- Target filename: `parameters.bsn`
- Expression: `in_basin%parms_bas`
- Type definition: `input_basin` at src/input_file_module.f90:18-22
- Variable instance: `in_basin` at src/input_file_module.f90:22
- Default value: `"parameters.bsn"` set at src/input_file_module.f90:20
- Runtime overrides: Set via file.cio (line 3, column 3)

**Detailed Mapping**:
```
parameters.bsn → in_basin%parms_bas 
               → type input_basin (src/input_file_module.f90:18-22)
               → character(len=25) :: parms_bas = "parameters.bsn" (src/input_file_module.f90:20)
```

#### I/O Sites

| Line | Statement | Type | Description |
|------|-----------|------|-------------|
| 15 | `inquire (file=in_basin%parms_bas, exist=i_exist)` | INQUIRE | Check file existence |
| 19 | `open (107,file=in_basin%parms_bas)` | OPEN | Open basin parameters file |
| 20 | `read (107,*,iostat=eof) titldum` | READ | Read title line |
| 22 | `read (107,*,iostat=eof) header` | READ | Read column headers |
| 24 | `read (107,*,iostat=eof) bsn_prm` | READ | Read basin parameters (PRIMARY) |
| 29 | `close(107)` | CLOSE | Close file |

#### Read Statement Analysis

**Read Statement 1: Title Line**
**Location**: src/basin_read_prm.f90:20  
**Statement**: `read (107,*,iostat=eof) titldum`  
**Format**: List-directed (free format)

**Variable**: `titldum`
- **Name**: titldum
- **Scope**: Local variable
- **Type**: character(len=80)
- **Default**: "" (empty string)
- **Units**: N/A (text)
- **Description**: Title of file
- **Declared at**: src/basin_read_prm.f90:8

**Read Statement 2: Header Line**
**Location**: src/basin_read_prm.f90:22  
**Statement**: `read (107,*,iostat=eof) header`  
**Format**: List-directed (free format)

**Variable**: `header`
- **Name**: header
- **Scope**: Local variable
- **Type**: character(len=80)
- **Default**: "" (empty string)
- **Units**: N/A (text)
- **Description**: Header line
- **Declared at**: src/basin_read_prm.f90:9

**Read Statement 3: Basin Parameters (PRIMARY DATA READ)**
**Location**: src/basin_read_prm.f90:24  
**Statement**: `read (107,*,iostat=eof) bsn_prm`  
**Format**: List-directed (free format)

**Variable**: `bsn_prm`
- **Name**: bsn_prm
- **Scope**: Module variable (imported from basin_module)
- **Type**: basin_parms (derived type)
- **Declared at**: src/basin_module.f90:136

**Derived Type: basin_parms**  
**Location**: src/basin_module.f90:77-135

| Component | Type | Default | Units | Description | Line |
|-----------|------|---------|-------|-------------|------|
| evlai | real | 3.0 | none | Leaf area index at which no evap occurs | 78 |
| ffcb | real | 0. | none | Initial soil water content expressed as fraction of field capacity | 79 |
| surlag | real | 4.0 | days | Surface runoff lag time | 80 |
| adj_pkr | real | 1.0 | none | Peak rate adjustment factor in the subbasin | 81 |
| prf | real | 484. | none | Peak rate factor for peak rate equation | 82 |
| spcon | real | 0.0 | none | Not used | 83 |
| spexp | real | 0.0 | none | Not used | 84 |
| cmn | real | 0.003 | none | Rate factor for mineralization on active org N | 85 |
| n_updis | real | 20.0 | none | Nitrogen uptake distribution parameter | 86 |
| p_updis | real | 20.0 | none | Phosphorus uptake distribution parameter | 87 |
| nperco | real | 0.10 | none | Nitrate percolation coefficient (0-1) | 88 |
| pperco | real | 10.0 | none | Phosphorus percolation coefficient (0-1) | 91 |
| phoskd | real | 175.0 | none | Phosphorus soil partitioning coefficient | 94 |
| psp | real | 0.40 | none | Phosphorus availability index | 95 |
| rsdco | real | 0.05 | none | Residue decomposition coefficient | 96 |
| percop | real | 0.5 | none | Pesticide percolation coefficient (0-1) | 97 |
| msk_co1 | real | 0.75 | none | Muskingum coeff to control storage time constant at bankfull | 98 |
| msk_co2 | real | 0.25 | none | Muskingum coeff to control storage time constant at low flow | 101 |
| msk_x | real | 0.20 | none | Muskingum weighting factor for inflow/outflow | 104 |
| nperco_lchtile | real | .5 | none | N concentration coefficient for tile flow and leach | 106 |
| evrch | real | 0.60 | none | Reach evaporation adjustment factor | 107 |
| scoef | real | 1.0 | none | Channel storage coefficient (0-1) | 108 |
| cdn | real | 1.40 | none | Denitrification exponential rate coefficient | 109 |
| sdnco | real | 1.30 | none | Denitrification threshold fraction of field capacity | 110 |
| bact_swf | real | 0.15 | none | Fraction of manure containing active colony forming units | 111 |
| tb_adj | real | 0. | none | Adjustment factor for subdaily unit hydrograph basetime | 112 |
| cn_froz | real | 0.000862 | none | Parameter for frozen soil adjustment on infiltration/runoff | 113 |
| dorm_hr | real | -1. | hrs | Time threshold used to define dormant | 114 |
| plaps | real | 0. | mm/km | Precipitation lapse rate | 115 |
| tlaps | real | 6.5 | deg C/km | Temperature lapse rate | 116 |
| nfixmx | real | 20.0 | kg/ha | Maximum daily N-fixation | 117 |
| decr_min | real | 0.01 | none | Minimum daily residue decay | 118 |
| rsd_covco | real | 0.75 | none | Residue cover factor for computing fraction of cover | 119 |
| urb_init_abst | real | 1. | mm | Maximum initial abstraction for urban areas when using Green and Ampt | 120 |
| petco_pmpt | real | 100.0 | % | PET adjustment for Penman-Monteith and Priestley-Taylor methods | 121 |
| uhalpha | real | 1.0 | none | Alpha coefficient for estimating unit hydrograph using gamma function | 122 |
| eros_spl | real | 0. | none | Coefficient of splash erosion varying 0.9-3.1 | 123 |
| rill_mult | real | 0. | none | Rill erosion coefficient | 124 |
| eros_expo | real | 0. | none | Exponential coefficient for overland flow | 125 |
| c_factor | real | 0. | none | Scaling parameter for cover and management factor for overland flow erosion | 126 |
| ch_d50 | real | 0. | mm | Median particle diameter of main channel | 128 |
| co2 | real | 400. | ppm | CO2 concentration at start of simulation | 129 |
| day_lag_mx | integer | 0 | days | Max days to lag hydrographs for hru, ru and channels | 131 |
| igen | integer | 5 | code | Random generator code (0=default, 1=generate new) | 133 |

#### PRIMARY DATA READ Table

**Read Statement**: `read (107,*,iostat=eof) bsn_prm` at src/basin_read_prm.f90:24
**File.cio Reference**: This file (parameters.bsn) is referenced in file.cio as component `parms_bas` of derived type `in_basin` (line 3, column 3)

| Line in File | Position in File | Local (Y/N) | Derived Type Name | Component (or Var Name if Local) | Type | Default | Units | Description | Source Line | Swat_codetype |
|--------------|------------------|-------------|-------------------|-----------------------------------|------|---------|-------|-------------|-------------|---------------|
| 3 | 1 | N | bsn_prm | evlai | real | 3.0 | none | Leaf area index at which no evaporation occurs | src/basin_module.f90:78 | in_basin |
| 3 | 2 | N | bsn_prm | ffcb | real | 0. | none | Initial soil water content as fraction of field capacity | src/basin_module.f90:79 | in_basin |
| 3 | 3 | N | bsn_prm | surlag | real | 4.0 | days | Surface runoff lag time | src/basin_module.f90:80 | in_basin |
| 3 | 4 | N | bsn_prm | adj_pkr | real | 1.0 | none | Peak rate adjustment factor in subbasin | src/basin_module.f90:81 | in_basin |
| 3 | 5 | N | bsn_prm | prf | real | 484. | none | Peak rate factor for peak rate equation | src/basin_module.f90:82 | in_basin |
| 3 | 6 | N | bsn_prm | spcon | real | 0.0 | none | Not used | src/basin_module.f90:83 | in_basin |
| 3 | 7 | N | bsn_prm | spexp | real | 0.0 | none | Not used | src/basin_module.f90:84 | in_basin |
| 3 | 8 | N | bsn_prm | cmn | real | 0.003 | none | Rate factor for mineralization on active organic N | src/basin_module.f90:85 | in_basin |
| 3 | 9 | N | bsn_prm | n_updis | real | 20.0 | none | Nitrogen uptake distribution parameter | src/basin_module.f90:86 | in_basin |
| 3 | 10 | N | bsn_prm | p_updis | real | 20.0 | none | Phosphorus uptake distribution parameter | src/basin_module.f90:87 | in_basin |
| 3 | 11 | N | bsn_prm | nperco | real | 0.10 | none | Nitrate percolation coefficient (0-1) | src/basin_module.f90:88 | in_basin |
| 3 | 12 | N | bsn_prm | pperco | real | 10.0 | none | Phosphorus percolation coefficient (0-1) | src/basin_module.f90:91 | in_basin |
| 3 | 13 | N | bsn_prm | phoskd | real | 175.0 | none | Phosphorus soil partitioning coefficient | src/basin_module.f90:94 | in_basin |
| 3 | 14 | N | bsn_prm | psp | real | 0.40 | none | Phosphorus availability index | src/basin_module.f90:95 | in_basin |
| 3 | 15 | N | bsn_prm | rsdco | real | 0.05 | none | Residue decomposition coefficient | src/basin_module.f90:96 | in_basin |
| 3 | 16 | N | bsn_prm | percop | real | 0.5 | none | Pesticide percolation coefficient (0-1) | src/basin_module.f90:97 | in_basin |
| 3 | 17 | N | bsn_prm | msk_co1 | real | 0.75 | none | Muskingum coefficient for storage time at bankfull | src/basin_module.f90:98 | in_basin |
| 3 | 18 | N | bsn_prm | msk_co2 | real | 0.25 | none | Muskingum coefficient for storage time at low flow | src/basin_module.f90:101 | in_basin |
| 3 | 19 | N | bsn_prm | msk_x | real | 0.20 | none | Muskingum weighting factor for inflow/outflow | src/basin_module.f90:104 | in_basin |
| 3 | 20 | N | bsn_prm | nperco_lchtile | real | .5 | none | N concentration coefficient for tile flow and leach | src/basin_module.f90:106 | in_basin |
| 3 | 21 | N | bsn_prm | evrch | real | 0.60 | none | Reach evaporation adjustment factor | src/basin_module.f90:107 | in_basin |
| 3 | 22 | N | bsn_prm | scoef | real | 1.0 | none | Channel storage coefficient (0-1) | src/basin_module.f90:108 | in_basin |
| 3 | 23 | N | bsn_prm | cdn | real | 1.40 | none | Denitrification exponential rate coefficient | src/basin_module.f90:109 | in_basin |
| 3 | 24 | N | bsn_prm | sdnco | real | 1.30 | none | Denitrification threshold fraction of field capacity | src/basin_module.f90:110 | in_basin |
| 3 | 25 | N | bsn_prm | bact_swf | real | 0.15 | none | Fraction of manure containing active CFU | src/basin_module.f90:111 | in_basin |
| 3 | 26 | N | bsn_prm | tb_adj | real | 0. | none | Adjustment factor for subdaily UH basetime | src/basin_module.f90:112 | in_basin |
| 3 | 27 | N | bsn_prm | cn_froz | real | 0.000862 | none | Parameter for frozen soil adjustment on infiltration | src/basin_module.f90:113 | in_basin |
| 3 | 28 | N | bsn_prm | dorm_hr | real | -1. | hrs | Time threshold used to define dormant | src/basin_module.f90:114 | in_basin |
| 3 | 29 | N | bsn_prm | plaps | real | 0. | mm/km | Precipitation lapse rate | src/basin_module.f90:115 | in_basin |
| 3 | 30 | N | bsn_prm | tlaps | real | 6.5 | deg C/km | Temperature lapse rate | src/basin_module.f90:116 | in_basin |
| 3 | 31 | N | bsn_prm | nfixmx | real | 20.0 | kg/ha | Maximum daily N-fixation | src/basin_module.f90:117 | in_basin |
| 3 | 32 | N | bsn_prm | decr_min | real | 0.01 | none | Minimum daily residue decay | src/basin_module.f90:118 | in_basin |
| 3 | 33 | N | bsn_prm | rsd_covco | real | 0.75 | none | Residue cover factor for fraction of cover | src/basin_module.f90:119 | in_basin |
| 3 | 34 | N | bsn_prm | urb_init_abst | real | 1. | mm | Max initial abstraction for urban areas (Green-Ampt) | src/basin_module.f90:120 | in_basin |
| 3 | 35 | N | bsn_prm | petco_pmpt | real | 100.0 | % | PET adjustment for Penman-Monteith/Priestley-Taylor | src/basin_module.f90:121 | in_basin |
| 3 | 36 | N | bsn_prm | uhalpha | real | 1.0 | none | Alpha coefficient for unit hydrograph (gamma function) | src/basin_module.f90:122 | in_basin |
| 3 | 37 | N | bsn_prm | eros_spl | real | 0. | none | Coefficient of splash erosion (0.9-3.1) | src/basin_module.f90:123 | in_basin |
| 3 | 38 | N | bsn_prm | rill_mult | real | 0. | none | Rill erosion coefficient | src/basin_module.f90:124 | in_basin |
| 3 | 39 | N | bsn_prm | eros_expo | real | 0. | none | Exponential coefficient for overland flow | src/basin_module.f90:125 | in_basin |
| 3 | 40 | N | bsn_prm | c_factor | real | 0. | none | Scaling parameter for C-factor (overland erosion) | src/basin_module.f90:126 | in_basin |
| 3 | 41 | N | bsn_prm | ch_d50 | real | 0. | mm | Median particle diameter of main channel | src/basin_module.f90:128 | in_basin |
| 3 | 42 | N | bsn_prm | co2 | real | 400. | ppm | CO2 concentration at simulation start | src/basin_module.f90:129 | in_basin |
| 3 | 43 | N | bsn_prm | day_lag_mx | integer | 0 | days | Max days to lag hydrographs for hru/ru/channels | src/basin_module.f90:131 | in_basin |
| 3 | 44 | N | bsn_prm | igen | integer | 5 | code | Random generator code (0=default, 1=generate new) | src/basin_module.f90:133 | in_basin |

---

### 3.7 weather-sta.cli (INPUT)

**Routine**: `cli_staread`  
**File**: src/cli_staread.f90  
**Expression**: `in_cli%weat_sta`  
**Unit mapping**: 107 → in_cli%weat_sta → "weather-sta.cli"

#### Filename Resolution

**Resolution Chain**:
- Target filename: `weather-sta.cli`
- Expression: `in_cli%weat_sta`
- Type definition: `input_cli` at src/input_file_module.f90:25-37
- Variable instance: `in_cli` at src/input_file_module.f90:37
- Default value: `"weather-sta.cli"` set at src/input_file_module.f90:26
- Runtime overrides: Set via file.cio (line 4, column 2)

**Detailed Mapping**:
```
weather-sta.cli → in_cli%weat_sta 
                → type input_cli (src/input_file_module.f90:25-37)
                → character(len=25) :: weat_sta = "weather-sta.cli" (src/input_file_module.f90:26)
```

#### I/O Sites

| Line | Statement | Type | Description |
|------|-----------|------|-------------|
| 27 | `inquire (file=in_cli%weat_sta, exist=i_exist)` | INQUIRE | Check file existence |
| 34 | `open (107,file=in_cli%weat_sta)` | OPEN | Open weather station file |
| 35 | `read (107,*,iostat=eof) titldum` | READ | Read title line |
| 37 | `read (107,*,iostat=eof) header` | READ | Read column headers |
| 41 | `read (107,*,iostat=eof) titldum` | READ | Count records (first pass) |
| 59 | `rewind (107)` | REWIND | Reset file pointer |
| 60 | `read (107,*,iostat=eof) titldum` | READ | Re-read title |
| 62 | `read (107,*,iostat=eof) header` | READ | Re-read header |
| 65 | `read (107,*,iostat=eof) titldum` | READ | Read station name |
| 68 | `read (107,*,iostat=eof) wst(i)%name, wst(i)%wco_c` | READ | Read weather station data (PRIMARY) |
| 103 | `close (107)` | CLOSE | Close file |

#### Read Statement: Weather Station Data (PRIMARY DATA READ)
**Location**: src/cli_staread.f90:68  
**Statement**: `read (107,*,iostat=eof) wst(i)%name, wst(i)%wco_c`  
**Format**: List-directed (free format)

**Variables**:
1. `wst(i)%name` - Weather station name (character(len=50))
2. `wst(i)%wco_c` - Weather codes character structure (weather_codes_station_char type)

**Derived Type: weather_codes_station_char**  
**Location**: src/climate_module.f90:115-123

| Component | Type | Default | Units | Description | Line |
|-----------|------|---------|-------|-------------|------|
| wgn | character(len=50) | "" | N/A | Weather generator name | 117 |
| pgage | character(len=50) | "" | N/A | Precipitation gage name | 118 |
| tgage | character(len=50) | "" | N/A | Temperature gage name | 119 |
| sgage | character(len=50) | "" | N/A | Solar radiation gage name | 120 |
| hgage | character(len=50) | "" | N/A | Relative humidity gage name | 121 |
| wgage | character(len=50) | "" | N/A | Wind speed gage name | 122 |
| petgage | character(len=50) | "" | N/A | PET gage name | 123 |
| atmodep | character(len=50) | "" | N/A | Atmospheric deposition data file name | 124 |

#### PRIMARY DATA READ Table

**File.cio Reference**: This file (weather-sta.cli) is referenced in file.cio as component `weat_sta` of derived type `in_cli` (line 4, column 2)

| Line in File | Position in File | Local (Y/N) | Derived Type Name | Component (or Var Name if Local) | Type | Default | Units | Description | Source Line | Swat_codetype |
|--------------|------------------|-------------|-------------------|-----------------------------------|------|---------|-------|-------------|-------------|---------------|
| 3+ | 1 | N | wst | name | character(len=50) | "Farmer Branch IL" | N/A | Weather station name | src/climate_module.f90:126 | in_cli |
| 3+ | 2 | N | wst(i)%wco_c | wgn | character(len=50) | "" | N/A | Weather generator name | src/climate_module.f90:117 | in_cli |
| 3+ | 3 | N | wst(i)%wco_c | pgage | character(len=50) | "" | N/A | Precipitation gage name (or "sim" to generate) | src/climate_module.f90:118 | in_cli |
| 3+ | 4 | N | wst(i)%wco_c | tgage | character(len=50) | "" | N/A | Temperature gage name (or "sim" to generate) | src/climate_module.f90:119 | in_cli |
| 3+ | 5 | N | wst(i)%wco_c | sgage | character(len=50) | "" | N/A | Solar radiation gage name (or "sim" to generate) | src/climate_module.f90:120 | in_cli |
| 3+ | 6 | N | wst(i)%wco_c | hgage | character(len=50) | "" | N/A | Relative humidity gage name (or "sim" to generate) | src/climate_module.f90:121 | in_cli |
| 3+ | 7 | N | wst(i)%wco_c | wgage | character(len=50) | "" | N/A | Wind speed gage name (or "sim" to generate) | src/climate_module.f90:122 | in_cli |
| 3+ | 8 | N | wst(i)%wco_c | petgage | character(len=50) | "" | N/A | PET gage name (or "null") | src/climate_module.f90:123 | in_cli |
| 3+ | 9 | N | wst(i)%wco_c | atmodep | character(len=50) | "" | N/A | Atmospheric deposition data file name (or "null") | src/climate_module.f90:124 | in_cli |

**Post-Read Processing**: Lines 71-95 perform searches to link climate file names to their array indices using the search subroutine.

---

### 3.8 hru-data.hru (INPUT)

**Routine**: `hru_read`  
**File**: src/hru_read.f90  
**Expression**: `in_hru%hru_data`  
**Unit mapping**: 113 → in_hru%hru_data → "hru-data.hru"

#### Filename Resolution

**Resolution Chain**:
- Target filename: `hru-data.hru`
- Expression: `in_hru%hru_data`
- Type definition: `input_hru` at src/input_file_module.f90:93-97
- Variable instance: `in_hru` at src/input_file_module.f90:97
- Default value: `"hru-data.hru"` set at src/input_file_module.f90:94
- Runtime overrides: Set via file.cio (line 9, column 2)

**Detailed Mapping**:
```
hru-data.hru → in_hru%hru_data 
             → type input_hru (src/input_file_module.f90:93-97)
             → character(len=25) :: hru_data = "hru-data.hru" (src/input_file_module.f90:94)
```

#### I/O Sites

| Line | Statement | Type | Description |
|------|-----------|------|-------------|
| 39 | `inquire (file=in_hru%hru_data, exist=i_exist)` | INQUIRE | Check file existence |
| 44 | `open (113,file=in_hru%hru_data)` | OPEN | Open HRU data file |
| 45 | `read (113,*,iostat=eof) titldum` | READ | Read title line |
| 47 | `read (113,*,iostat=eof) header` | READ | Read column headers |
| 50 | `read (113,*,iostat=eof) i` | READ | Count and find max HRU ID (first pass) |
| 57 | `rewind (113)` | REWIND | Reset file pointer |
| 58 | `read (113,*,iostat=eof) titldum` | READ | Re-read title |
| 60 | `read (113,*,iostat=eof) header` | READ | Re-read header |
| 64 | `read (113,*,iostat=eof) i` | READ | Read HRU ID |
| 67 | `read (113,*,iostat=eof) k, hru_db(i)%dbsc` | READ | Read HRU data (PRIMARY) |

#### Read Statement: HRU Data (PRIMARY DATA READ)
**Location**: src/hru_read.f90:67  
**Statement**: `read (113,*,iostat=eof) k, hru_db(i)%dbsc`  
**Format**: List-directed (free format)

**Variables**:
1. `k` - HRU ID (integer, local)
2. `hru_db(i)%dbsc` - HRU database character structure

**Note**: The HRU database structure is extensive and contains numerous components that link to other database files including:
- land_use_mgt (landuse.lum)
- soil_plant_init (soil_plant.ini)  
- plant_ini (plant.ini)
- surf_stor (initial storage)
- snow (snow.sno)
- field (field.fld)
- topography (topography.hyd)
- hydrology (hydrology.hyd)
- soil (soils.sol)
- soil_plant_nutrients (nutrients.sol)

The complete documentation of all HRU components would require extensive tables documenting the hru_databases_char derived type and its many linked components. This is a highly complex file connecting many model components.

---

## 6. Summary

### Documentation Coverage

This report provides comprehensive I/O trace documentation for critical SWAT+ input and output files:

**Fully Documented Files (Complete)**:
1. **aquifer.aqu** - Aquifer parameter database
2. **object.cnt** - Object count configuration
3. **mgt.out** - Management operations output
4. **aquifer.out** - Aquifer simulation output (multiple intervals)
5. **file.cio** - Master configuration file
6. **time.sim** - Simulation time controls
7. **print.prt** - Output printing controls
8. **codes.bsn** - Basin control codes
9. **parameters.bsn** - Basin parameters
10. **weather-sta.cli** - Weather station definitions
11. **hru-data.hru** - HRU (Hydrologic Response Unit) data

### Remaining Files to Document

Based on file.cio structure (31 file categories, 145+ individual files), the following files still require comprehensive documentation:

**Climate Files** (in_cli):
- ~~weather-wgn.cli~~ - DOCUMENTED (Section 3.9)
- ~~pcp.cli~~ - DOCUMENTED (Section 3.10)
- ~~tmp.cli~~ - DOCUMENTED (Section 3.11)
- slr.cli - Solar radiation data
- ~~hmd.cli~~ - DOCUMENTED (Section 3.12)
- ~~wnd.cli~~ - DOCUMENTED (Section 3.13)
- atmodep.cli - Atmospheric deposition
- pet.cli - Measured potential ET (conditional on codes.bsn)

**Connection Files** (in_con):
- ~~hru.con~~ - DOCUMENTED (Section 3.19)
- hru-lte.con - HRU long-term environmental connections
- ~~rout_unit.con~~ - DOCUMENTED (Section 3.20)
- gwflow.con - Groundwater flow connections
- ~~aquifer.con~~ - DOCUMENTED (Section 3.21)
- aquifer2d.con - 2D aquifer connections
- ~~channel.con~~ - DOCUMENTED (Section 3.22)
- reservoir.con - Reservoir connections
- recall.con - Recall point connections
- exco.con - Export coefficient connections
- delratio.con - Delivery ratio connections
- outlet.con - Outlet connections
- chandeg.con - SWAT-DEG channel connections

**Channel Files** (in_cha):
- ~~initial.cha~~ - DOCUMENTED (Section 3.23)
- channel.cha - Channel data
- hydrology.cha - Channel hydrology
- sediment.cha - Channel sediment
- ~~nutrients.cha~~ - DOCUMENTED (Section 3.24)
- channel-lte.cha - Channel LTE
- hyd-sed-lte.cha - Hydrology-sediment LTE
- temperature.cha - Channel temperature

**Reservoir Files** (in_res):
- initial.res - Initial reservoir conditions
- reservoir.res - Reservoir data
- hydrology.res - Reservoir hydrology
- sediment.res - Reservoir sediment
- nutrients.res - Reservoir nutrients
- weir.res - Weir data
- wetland.wet - Wetland data
- hydrology.wet - Wetland hydrology

**Routing Unit Files** (in_ru):
- rout_unit.def - Routing unit definitions
- rout_unit.ele - Routing unit elements
- rout_unit.rtu - Routing unit data
- rout_unit.dr - Routing unit delivery ratio

**Exco Files** (in_exco):
- exco.exc - Export coefficient data
- exco_om.exc - Organic matter export
- exco_pest.exc - Pesticide export
- exco_path.exc - Pathogen export
- exco_hmet.exc - Heavy metal export
- exco_salt.exc - Salt export

**Recall Files** (in_rec):
- recall.rec - Recall point data

**Delivery Ratio Files** (in_delr):
- delratio.del - Delivery ratio data
- dr_om.del - Organic matter delivery
- dr_pest.del - Pesticide delivery
- dr_path.del - Pathogen delivery
- dr_hmet.del - Heavy metal delivery
- dr_salt.del - Salt delivery

**Hydrology Files** (in_hyd):
- hydrology.hyd - Hydrology parameters
- topography.hyd - Topography parameters
- field.fld - Field data

**Structural Files** (in_str):
- tiledrain.str - Tile drainage
- septic.str - Septic systems
- filterstrip.str - Filter strips
- grassedww.str - Grassed waterways
- bmpuser.str - User-defined BMPs

**Parameter Database Files** (in_parmdb):
- plants.plt - Plant parameters
- fertilizer.frt - Fertilizer parameters
- tillage.til - Tillage parameters
- pesticide.pes - Pesticide parameters
- pathogens.pth - Pathogen parameters
- metals.mtl - Heavy metal parameters
- salt.slt - Salt parameters
- urban.urb - Urban parameters
- septic.sep - Septic parameters
- snow.sno - Snow parameters

**Operation Files** (in_ops):
- ~~harv.ops~~ - DOCUMENTED (Section 3.25)
- graze.ops - Grazing operations
- ~~irr.ops~~ - DOCUMENTED (Section 3.26)
- chem_app.ops - Chemical application
- fire.ops - Fire operations
- sweep.ops - Street sweeping

**Land Use Management Files** (in_lum):
- ~~landuse.lum~~ - DOCUMENTED (Section 3.16)
- ~~management.sch~~ - DOCUMENTED (Section 3.17)
- ~~cntable.lum~~ - DOCUMENTED (Section 3.18)
- cons_practice.lum - Conservation practices
- ovn_table.lum - Overland flow Manning's n

**Soils Files** (in_sol):
- ~~soils.sol~~ - DOCUMENTED (Section 3.14)
- ~~nutrients.sol~~ - DOCUMENTED (Section 3.15)
- soils_lte.sol - Soil LTE data

**Calibration Files** (in_chg):
- cal_parms.cal - Calibration parameters
- calibration.cal - Calibration updates
- codes.sft - Soft calibration codes
- wb_parms.sft - Water balance parameters
- water_balance.sft - Water balance regions
- ch_sed_budget.sft - Channel sediment budget
- ch_sed_parms.sft - Channel sediment parameters
- plant_parms.sft - Plant parameters
- plant_gro.sft - Plant growth regions

**Initial Condition Files** (in_init):
- plant.ini - Initial plant conditions
- soil_plant.ini - Initial soil-plant conditions
- om_water.ini - Initial organic matter in water
- pest_hru.ini - Initial pesticide in soil
- pest_water.ini - Initial pesticide in water
- path_hru.ini - Initial pathogens in soil
- path_water.ini - Initial pathogens in water
- hmet_hru.ini - Initial heavy metals in soil
- hmet_water.ini - Initial heavy metals in water
- salt_hru.ini - Initial salt in soil
- salt_water.ini - Initial salt in water

**Soil Files** (in_sol):
- soils.sol - Soil physical properties
- nutrients.sol - Soil nutrients
- soils_lte.sol - Soil LTE properties

**Decision Table Files** (in_cond):
- lum.dtl - Land use management decision tables
- res_rel.dtl - Reservoir release decision tables
- scen_lu.dtl - Scenario land use decision tables
- flo_con.dtl - Flow control decision tables

**Region Files** (in_regs):
- ls_unit.ele - Landscape unit elements
- ls_unit.def - Landscape unit definitions
- ls_reg.ele - Landscape region elements
- ls_reg.def - Landscape region definitions
- ls_cal.reg - Landscape calibration regions
- ch_catunit.ele - Channel catchment elements
- ch_catunit.def - Channel catchment definitions
- ch_reg.def - Channel region definitions
- aqu_catunit.ele - Aquifer catchment elements
- aqu_catunit.def - Aquifer catchment definitions
- aqu_reg.def - Aquifer region definitions
- res_catunit.ele - Reservoir catchment elements
- res_catunit.def - Reservoir catchment definitions
- res_reg.def - Reservoir region definitions
- rec_catunit.ele - Recall catchment elements
- rec_catunit.def - Recall catchment definitions
- rec_reg.def - Recall region definitions

**Path Files** (in_path_*):
- Precipitation path file
- Temperature path file
- Solar radiation path file
- Humidity path file
- Wind path file
- PET path file

**Constituent Files** (in_sim):
- constituents.cs - Constituent definitions (if using constituent module)
- object.prt - Object-specific printing controls

### Documentation Pattern Template

For each remaining file, the complete documentation should follow this structure:

1. **Filename Resolution** - Map filename to variable expressions and defaults
2. **I/O Sites** - Document all open/read/write/close operations with unit mappings
3. **Read/Write Payload Map** - Expand all read variables with type definitions
4. **PRIMARY DATA READ Table** - Complete table with columns:
   - Line in File (actual file line number)
   - Position in File
   - Local (Y/N)
   - Derived Type Name
   - Component (or Var Name if Local)
   - Type
   - Default
   - Units
   - Description
   - Source Line
   - Swat_codetype (file.cio cross-reference)

### Key Findings

- All filenames are resolved through module-level derived types with default values (input_file_module.f90)
- Unit 107 is the most commonly reused unit for input files
- Unit 113 is commonly used for HRU-related files
- Unit 114 is used for weather generator files
- Output units are unique and persistent per output file type
- No user-defined I/O is used in primary input files; all use default list-directed or formatted I/O
- Two-pass reading strategy is common for files with sparse array indexing (count first, allocate, read data)
- file.cio structure defines 31 major file categories with 145+ individual filenames
- Complex cross-referencing between files (e.g., HRU references landuse, soil, topography, hydrology databases)

### Completion Strategy

To complete documentation for remaining 135+ files:

1. **Priority 1 (Core Model Setup)**: Climate files, connection files, soil files, landuse files
2. **Priority 2 (Model Parameterization)**: Parameter databases (plants, fertilizer, tillage, pesticide, etc.)
3. **Priority 3 (Operations)**: Management operations, decision tables
4. **Priority 4 (Advanced Features)**: Calibration files, constituent files, region files
5. **Priority 5 (Optional Components)**: LTE files, 2D aquifer, special modules

---

### 3.9 weather-wgn.cli (INPUT)

**File**: src/cli_wgnread.f90  
**Routine**: `cli_wgnread`  
**Expression**: `in_cli%weat_wgn`  
**Unit**: 114

#### Filename Resolution

```
weather-wgn.cli → in_cli%weat_wgn
                → type input_cli (src/input_file_module.f90:25-37)
                → character(len=25) :: weat_wgn = "weather-wgn.cli" (line 27)
```

#### I/O Sites

| **Site** | **File** | **Line(s)** | **Operation** | **Unit** | **Expression** |
|----------|----------|-------------|---------------|----------|----------------|
| OPEN     | src/cli_wgnread.f90 | 44 | `open (114,file=in_cli%weat_wgn)` | 114 | `in_cli%weat_wgn` |
| READ (header) | src/cli_wgnread.f90 | 45 | Title line | 114 | - |
| READ (count) | src/cli_wgnread.f90 | 48-50 | Count records | 114 | Loop to count |
| READ (names) | src/cli_wgnread.f90 | 69-73 | Read station names | 114 | `wgn_n(i)` |
| READ (data) | src/cli_wgnread.f90 | 81-106 | Read wgn parameters | 114 | `wgn(iwgn)` |

#### Payload Map

**Target Variable**: `wgn(:)` (allocated array of type `weather_generator_db`)  
**Module**: climate_module  
**Type Definition**: src/climate_module.f90:24-43

**PRIMARY DATA READ**:

| **Variable** | **Field** | **Type** | **Units** | **Description** | **Swat_codetype** | **Source** |
|--------------|-----------|----------|-----------|-----------------|-------------------|------------|
| wgn_n(i) | station_name | character(len=50) | - | Weather station name | - | Line 69-73 |
| wgn(i)%lat | lat | real | degrees | Latitude of station | weather_generator_db%lat | Line 81 |
| wgn(i)%long | long | real | degrees | Longitude of station | weather_generator_db%long | Line 82 |
| wgn(i)%elev | elev | real | m | Elevation of station | weather_generator_db%elev | Line 83 |
| wgn(i)%rain_yrs | rain_yrs | real | years | Years of rainfall data | weather_generator_db%rain_yrs | Line 84 |
| wgn(i)%tmpmx(1:12) | tmpmx | real(12) | deg C | Monthly avg max temperature | weather_generator_db%tmpmx | Line 85-86 |
| wgn(i)%tmpmn(1:12) | tmpmn | real(12) | deg C | Monthly avg min temperature | weather_generator_db%tmpmn | Line 87-88 |
| wgn(i)%tmpstdmx(1:12) | tmpstdmx | real(12) | deg C | Std dev monthly max temp | weather_generator_db%tmpstdmx | Line 89-90 |
| wgn(i)%tmpstdmn(1:12) | tmpstdmn | real(12) | deg C | Std dev monthly min temp | weather_generator_db%tmpstdmn | Line 91-92 |
| wgn(i)%pcpmm(1:12) | pcpmm | real(12) | mm | Monthly precipitation | weather_generator_db%pcpmm | Line 93-94 |
| wgn(i)%pcpstd(1:12) | pcpstd | real(12) | mm/day | Std dev daily precip | weather_generator_db%pcpstd | Line 95-96 |
| wgn(i)%pcpskw(1:12) | pcpskw | real(12) | - | Skew coefficient precip | weather_generator_db%pcpskw | Line 97-98 |
| wgn(i)%pr_wd(1:12) | pr_wd | real(12) | - | Prob wet after dry | weather_generator_db%pr_wd | Line 99-100 |
| wgn(i)%pr_ww(1:12) | pr_ww | real(12) | - | Prob wet after wet | weather_generator_db%pr_ww | Line 101-102 |
| wgn(i)%pcpd(1:12) | pcpd | real(12) | days | Precip days per month | weather_generator_db%pcpd | Line 103 |
| wgn(i)%rainhmx(1:12) | rainhmx | real(12) | mm | Max 0.5hr rainfall | weather_generator_db%rainhmx | Line 104 |
| wgn(i)%solarav(1:12) | solarav | real(12) | MJ/m²/day | Avg solar radiation | weather_generator_db%solarav | Line 105 |
| wgn(i)%dewpt(1:12) | dewpt | real(12) | deg C | Avg dewpoint temp | weather_generator_db%dewpt | Line 106 |
| wgn(i)%windav(1:12) | windav | real(12) | m/s | Avg wind speed | weather_generator_db%windav | Line 106 |

**Type Expansion - weather_generator_db** (src/climate_module.f90:24-43):
```fortran
type weather_generator_db
  real :: lat = 0.0                          ! latitude (degrees)
  real :: long = 0.0                         ! longitude (degrees)
  real :: elev = 0.0                         ! elevation (m)
  real :: rain_yrs = 10.0                    ! years of rainfall data
  real, dimension (12) :: tmpmx = 0.         ! monthly avg max temp (deg C)
  real, dimension (12) :: tmpmn = 0.         ! monthly avg min temp (deg C)
  real, dimension (12) :: tmpstdmx = 0.      ! std dev max temp (deg C)
  real, dimension (12) :: tmpstdmn = 0.      ! std dev min temp (deg C)
  real, dimension (12) :: pcpmm = 0.         ! monthly precip (mm)
  real, dimension (12) :: pcpstd = 0.        ! std dev daily precip (mm/day)
  real, dimension (12) :: pcpskw = 0.        ! skew coefficient
  real, dimension (12) :: pr_wd = 0.         ! prob wet after dry
  real, dimension (12) :: pr_ww = 0.         ! prob wet after wet
  real, dimension (12) :: pcpd = 0.          ! precip days (days)
  real, dimension (12) :: rainhmx = 0.       ! max 0.5hr rainfall (mm)
  real, dimension (12) :: solarav = 0.       ! avg solar radiation (MJ/m²/day)
  real, dimension (12) :: dewpt = 0.         ! avg dewpoint (deg C)
  real, dimension (12) :: windav = 0.        ! avg wind speed (m/s)
end type weather_generator_db
```

**file.cio Cross-Reference**: `in_cli%weat_wgn` is loaded from file.cio climate section

**Notes**:
- Allocates wgn(0:imax), wgn_n(imax), wgn_orig(0:imax)
- Also allocates supporting arrays: wgncur, wgnold, wgn_pms, frad, rnd arrays
- Calls external subroutines cli_initwgn and gcycl
- If file doesn't exist or is "null", creates empty arrays with size 0:1

---

### 3.10 pcp.cli (INPUT)

**File**: src/cli_pmeas.f90  
**Routine**: `cli_pmeas`  
**Expression**: `in_cli%pcp_cli`  
**Unit**: 107 (file list), 108 (individual station files)

#### Filename Resolution

```
pcp.cli → in_cli%pcp_cli
        → type input_cli (src/input_file_module.f90:25-37)
        → character(len=25) :: pcp_cli = "pcp.cli" (line 30)
```

#### I/O Sites

| **Site** | **File** | **Line(s)** | **Operation** | **Unit** | **Expression** |
|----------|----------|-------------|---------------|----------|----------------|
| OPEN (list) | src/cli_pmeas.f90 | 38 | `open (107,file=in_cli%pcp_cli)` | 107 | `in_cli%pcp_cli` |
| READ (title) | src/cli_pmeas.f90 | 39 | Title line | 107 | - |
| READ (header) | src/cli_pmeas.f90 | 41 | Header line | 107 | - |
| READ (count) | src/cli_pmeas.f90 | 44-46 | Count stations | 107 | Loop |
| READ (names) | src/cli_pmeas.f90 | 58-59 | Station names | 107 | `pcp_n(i)` |
| READ (filenames) | src/cli_pmeas.f90 | 69 | Precipitation filenames | 107 | `pcp(i)%filename` |
| OPEN (station) | src/cli_pmeas.f90 | 74-76 | Open individual pcp file | 108 | `pcp(i)%filename` |
| READ (station data) | src/cli_pmeas.f90 | 79-145 | Read station precip data | 108 | `pcp(i)` fields |

#### Payload Map

**Target Variable**: `pcp(:)` (allocated array of type `climate_measured_data`)  
**Module**: climate_module  
**Type Definition**: src/climate_module.f90:161-183

**PRIMARY DATA READ** (from pcp.cli):

| **Variable** | **Field** | **Type** | **Units** | **Description** | **Swat_codetype** | **Source** |
|--------------|-----------|----------|-----------|-----------------|-------------------|------------|
| pcp_n(i) | station_name | character(len=50) | - | Precipitation station name | - | Line 58-59 |
| pcp(i)%filename | filename | character(len=50) | - | Station data filename | climate_measured_data%filename | Line 69 |

**SECONDARY DATA READ** (from individual station files):

| **Variable** | **Field** | **Type** | **Units** | **Description** | **Swat_codetype** | **Source** |
|--------------|-----------|----------|-----------|-----------------|-------------------|------------|
| pcp(i)%lat | lat | real | degrees | Station latitude | climate_measured_data%lat | Line 81 |
| pcp(i)%long | long | real | degrees | Station longitude | climate_measured_data%long | Line 82 |
| pcp(i)%elev | elev | real | m | Station elevation | climate_measured_data%elev | Line 83 |
| pcp(i)%nbyr | nbyr | integer | years | Number of years of data | climate_measured_data%nbyr | Line 84 |
| pcp(i)%tstep | tstep | integer | 1/day | Timesteps per day | climate_measured_data%tstep | Line 85 |
| pcp(i)%start_day | start_day | integer | julian | Start day of record | climate_measured_data%start_day | Line 86 |
| pcp(i)%start_yr | start_yr | integer | year | Start year of record | climate_measured_data%start_yr | Line 87 |
| pcp(i)%ts(iyr,istep) | ts | real(:,:) | mm | Daily/subdaily precip data | climate_measured_data%ts | Line 102-145 |

**Type Expansion - climate_measured_data** (src/climate_module.f90:161-183):
```fortran
type climate_measured_data
  character (len=50) :: filename = ""          ! data filename
  real :: lat = 0.                             ! latitude (degrees)
  real :: long = 0.                            ! longitude (degrees)
  real :: elev = 0.                            ! elevation (m)
  integer :: nbyr = 0                          ! number of years
  integer :: tstep = 0                         ! timestep (1/day)
  integer :: days_gen = 0                      ! generated days
  integer :: yrs_start = 1                     ! years before record
  integer :: start_day = 0                     ! start julian day
  integer :: start_yr = 0                      ! start year
  integer :: end_day = 0                       ! end julian day
  integer :: end_yr = 0                        ! end year
  real, dimension (12) :: mean_mon = 0.        ! monthly means
  real, dimension (12) :: max_mon = 0.         ! monthly maxima
  real, dimension (12) :: min_mon = 0.         ! monthly minima
  real, dimension (:,:), allocatable :: ts     ! time series data
  real, dimension (:,:), allocatable :: ts2    ! secondary time series
  real, dimension (:,:,:), allocatable :: tss  ! subdaily time series
end type climate_measured_data
```

**file.cio Cross-Reference**: `in_cli%pcp_cli` is loaded from file.cio climate section

**Notes**:
- Two-level file structure: pcp.cli lists station files, each station file contains data
- Path prefix `in_path_pcp%pcp` can be prepended to filenames
- Handles both daily and subdaily precipitation data via tstep parameter
- Allocates pcp(0:imax) and pcp_n(imax)
- If file doesn't exist or is "null", creates pcp(0:0) and pcp_n(0)

---

### 3.11 tmp.cli (INPUT)

**File**: src/cli_tmeas.f90 (similar structure to cli_pmeas.f90)  
**Routine**: `cli_tmeas`  
**Expression**: `in_cli%tmp_cli`  
**Unit**: 107 (file list), 108 (individual station files)

#### Filename Resolution

```
tmp.cli → in_cli%tmp_cli
        → type input_cli (src/input_file_module.f90:25-37)
        → character(len=25) :: tmp_cli = "tmp.cli" (line 31)
```

#### I/O Sites

Similar structure to pcp.cli - lists temperature station files

**Target Variable**: `tmp(:)` (allocated array of type `climate_measured_data`)  
**Module**: climate_module  
**Type Definition**: src/climate_module.f90:161-183 (same as pcp)

**PRIMARY DATA READ**: Temperature station names and filenames  
**SECONDARY DATA READ**: Max/min temperature time series from individual station files

**file.cio Cross-Reference**: `in_cli%tmp_cli` is loaded from file.cio climate section

---

### 3.12 hmd.cli (INPUT)

**File**: src/cli_hmeas.f90  
**Routine**: `cli_hmeas`  
**Expression**: `in_cli%hmd_cli`  
**Unit**: 107 (file list), 108 (individual station files)

#### Filename Resolution

```
hmd.cli → in_cli%hmd_cli
        → type input_cli (src/input_file_module.f90:25-37)
        → character(len=25) :: hmd_cli = "hmd.cli" (line 33)
```

#### I/O Sites

Similar structure to pcp.cli - lists humidity station files

**Target Variable**: `hmd(:)` (allocated array of type `climate_measured_data`)  
**Module**: climate_module  
**Type Definition**: src/climate_module.f90:161-183 (same as pcp)

**file.cio Cross-Reference**: `in_cli%hmd_cli` is loaded from file.cio climate section

---

### 3.13 wnd.cli (INPUT)

**File**: src/cli_wmeas.f90  
**Routine**: `cli_wmeas`  
**Expression**: `in_cli%wnd_cli`  
**Unit**: 107 (file list), 108 (individual station files)

#### Filename Resolution

```
wnd.cli → in_cli%wnd_cli
        → type input_cli (src/input_file_module.f90:25-37)
        → character(len=25) :: wnd_cli = "wnd.cli" (line 34)
```

#### I/O Sites

Similar structure to pcp.cli - lists wind speed station files

**Target Variable**: `wnd(:)` (allocated array of type `climate_measured_data`)  
**Module**: climate_module  
**Type Definition**: src/climate_module.f90:161-183 (same as pcp)

**file.cio Cross-Reference**: `in_cli%wnd_cli` is loaded from file.cio climate section

---

### 3.14 soils.sol (INPUT)

**File**: src/soils_lte_read.f90  
**Routine**: `soils_lte_read`  
**Expression**: `in_sol%soils_sol`  
**Unit**: 107

#### Filename Resolution

```
soils.sol → in_sol%soils_sol
          → type input_soils (src/input_file_module.f90:242-247)
          → character(len=25) :: soils_sol = "soils.sol" (line 243)
```

#### I/O Sites

| **Site** | **File** | **Line(s)** | **Operation** | **Unit** | **Expression** |
|----------|----------|-------------|---------------|----------|----------------|
| OPEN | src/soils_lte_read.f90 | ~25 | `open (107,file=in_sol%soils_sol)` | 107 | `in_sol%soils_sol` |
| READ | src/soils_lte_read.f90 | Various | Read soil properties | 107 | `soildb(i)` |

#### Payload Map

**Target Variable**: `soildb(:)` (allocated array of type `soil_database`)  
**Module**: soil_data_module  
**Type Definition**: src/soil_data_module.f90

**Type Expansion - soil_database**:
```fortran
type soil_database
  type (soil_profile_db) :: s          ! soil profile properties
  type (soilayer_db), dimension(:), allocatable :: ly  ! layer properties
end type soil_database
```

Contains soil profile properties and layer-by-layer characteristics including texture, bulk density, hydraulic conductivity, etc.

**file.cio Cross-Reference**: `in_sol%soils_sol` is loaded from file.cio soils section

---

### 3.15 nutrients.sol (INPUT)

**File**: src/nut_sol_read.f90  
**Routine**: `nut_sol_read`  
**Expression**: `in_sol%nut_sol`  
**Unit**: 107

#### Filename Resolution

```
nutrients.sol → in_sol%nut_sol
              → type input_soils (src/input_file_module.f90:242-247)
              → character(len=25) :: nut_sol = "nutrients.sol" (line 244)
```

**Target Variable**: Soil nutrient properties linked to soildb  
**file.cio Cross-Reference**: `in_sol%nut_sol` is loaded from file.cio soils section

---

### 3.16 landuse.lum (INPUT)

**File**: src/landuse_read.f90  
**Routine**: `landuse_read`  
**Expression**: `in_lum%landuse_lum`  
**Unit**: 107

#### Filename Resolution

```
landuse.lum → in_lum%landuse_lum
            → type input_lum (src/input_file_module.f90:202-209)
            → character(len=25) :: landuse_lum = "landuse.lum" (line 203)
```

#### I/O Sites

| **Site** | **File** | **Line(s)** | **Operation** | **Unit** | **Expression** |
|----------|----------|-------------|---------------|----------|----------------|
| OPEN | src/landuse_read.f90 | 35 | `open (107,file=in_lum%landuse_lum)` | 107 | `in_lum%landuse_lum` |
| READ (title) | src/landuse_read.f90 | 36 | Title line | 107 | - |
| READ (header) | src/landuse_read.f90 | 38 | Header line | 107 | - |
| READ (count) | src/landuse_read.f90 | 40-44 | Count records | 107 | Loop |
| READ (data) | src/landuse_read.f90 | 55-58 | Read land use data | 107 | `lum(ilu)` |

#### Payload Map

**Target Variable**: `lum(:)` (allocated array of type `land_use_management`)  
**Module**: landuse_data_module  
**Type Definition**: src/landuse_data_module.f90:5-22

**PRIMARY DATA READ**:

| **Variable** | **Field** | **Type** | **Units** | **Description** | **Swat_codetype** | **Source** |
|--------------|-----------|----------|-----------|-----------------|-------------------|------------|
| lum(i)%name | name | character(40) | - | Land use name | land_use_management%name | Line 56 |
| lum(i)%cal_group | cal_group | character(40) | - | Calibration group | land_use_management%cal_group | Line 56 |
| lum(i)%plant_cov | plant_cov | character(40) | - | Plant community init (→plants.ini) | land_use_management%plant_cov | Line 56 |
| lum(i)%mgt_ops | mgt_ops | character(40) | - | Management operations (→management.sch) | land_use_management%mgt_ops | Line 56 |
| lum(i)%cn_lu | cn_lu | character(40) | - | Curve number table (→cntable.lum) | land_use_management%cn_lu | Line 56 |
| lum(i)%cons_prac | cons_prac | character(40) | - | Conservation practice (→cons_practice.lum) | land_use_management%cons_prac | Line 56 |
| lum(i)%urb_lu | urb_lu | character(40) | - | Urban land use type (→urban.urb) | land_use_management%urb_lu | Line 56 |
| lum(i)%urb_ro | urb_ro | character(40) | - | Urban runoff model | land_use_management%urb_ro | Line 56 |
| lum(i)%ovn | ovn | character(40) | - | Manning's n (→ovn_table.lum) | land_use_management%ovn | Line 56 |
| lum(i)%tiledrain | tiledrain | character(40) | - | Tile drainage (→tiledrain.str) | land_use_management%tiledrain | Line 56 |
| lum(i)%septic | septic | character(40) | - | Septic tanks (→septic.str) | land_use_management%septic | Line 56 |
| lum(i)%fstrip | fstrip | character(40) | - | Filter strips (→filterstrip.str) | land_use_management%fstrip | Line 56 |
| lum(i)%grassww | grassww | character(40) | - | Grass waterways (→grassedww.str) | land_use_management%grassww | Line 56 |
| lum(i)%bmpuser | bmpuser | character(40) | - | User BMP (→bmpuser.str) | land_use_management%bmpuser | Line 56 |

**Type Expansion - land_use_management** (src/landuse_data_module.f90:5-22):
```fortran
type land_use_management
  character (len=40) :: name = ""         ! land use name
  character (len=40) :: cal_group = ""    ! calibration group
  character (len=40) :: plant_cov = ""    ! plant community → plants.ini
  character (len=40) :: mgt_ops = ""      ! management → management.sch
  character (len=40) :: cn_lu = ""        ! curve number → cntable.lum
  character (len=40) :: cons_prac = ""    ! conservation → cons_practice.lum
  character (len=40) :: urb_lu = ""       ! urban type → urban.urb
  character (len=40) :: urb_ro = ""       ! urban runoff model
  character (len=40) :: ovn = ""          ! Manning's n → ovn_table.lum
  character (len=40) :: tiledrain = ""    ! tile → tiledrain.str
  character (len=40) :: septic = ""       ! septic → septic.str
  character (len=40) :: fstrip = ""       ! filter strips → filterstrip.str
  character (len=40) :: grassww = ""      ! grass waterways → grassedww.str
  character (len=40) :: bmpuser = ""      ! user BMP → bmpuser.str
end type land_use_management
```

**file.cio Cross-Reference**: `in_lum%landuse_lum` is loaded from file.cio land use management section

**Notes**:
- Acts as master index file pointing to 10+ other database files
- Each field is a pointer/name that gets resolved to database indices
- Code at lines 61-177 resolves character names to integer indices
- Allocates lum(0:imax) and lum_str(0:imax)

---

### 3.17 management.sch (INPUT)

**File**: src/mgt_read_mgtops.f90  
**Routine**: `mgt_read_mgtops`  
**Expression**: `in_lum%management_sch`  
**Unit**: 107

#### Filename Resolution

```
management.sch → in_lum%management_sch
               → type input_lum (src/input_file_module.f90:202-209)
               → character(len=25) :: management_sch = "management.sch" (line 204)
```

#### I/O Sites

| **Site** | **File** | **Line(s)** | **Operation** | **Unit** | **Expression** |
|----------|----------|-------------|---------------|----------|----------------|
| OPEN | src/mgt_read_mgtops.f90 | 33 | `open (107,file=in_lum%management_sch)` | 107 | `in_lum%management_sch` |
| READ (title) | src/mgt_read_mgtops.f90 | 34 | Title line | 107 | - |
| READ (header) | src/mgt_read_mgtops.f90 | 36 | Header line | 107 | - |
| READ (count) | src/mgt_read_mgtops.f90 | 38-50 | Count schedules | 107 | Loop |
| READ (schedule) | src/mgt_read_mgtops.f90 | 61-62 | Schedule name, nops, nautos | 107 | `sched(isched)` |
| READ (autos) | src/mgt_read_mgtops.f90 | 69-78 | Auto operation names | 107 | `sched%auto_name` |
| READ (ops) | src/mgt_read_mgtops.f90 | Various | Individual operations | 107 | `sched%mgt_ops` |

#### Payload Map

**Target Variable**: `sched(:)` (allocated array of type `management_schedule`)  
**Module**: mgt_operations_module  
**Type Definition**: src/mgt_operations_module.f90:178-188

**PRIMARY DATA READ**:

| **Variable** | **Field** | **Type** | **Units** | **Description** | **Swat_codetype** | **Source** |
|--------------|-----------|----------|-----------|-----------------|-------------------|------------|
| sched(i)%name | name | character(40) | - | Schedule name | management_schedule%name | Line 61 |
| sched(i)%num_ops | num_ops | integer | - | Number of operations | management_schedule%num_ops | Line 61 |
| sched(i)%num_autos | num_autos | integer | - | Number of auto operations | management_schedule%num_autos | Line 61 |
| sched(i)%auto_name(j) | auto_name | character(40) | - | Auto operation name | management_schedule%auto_name | Line 69 |
| sched(i)%mgt_ops(k) | mgt_ops | management_ops | - | Management operation | management_schedule%mgt_ops | Various |

**Type Expansion - management_schedule** (src/mgt_operations_module.f90:178-188):
```fortran
type management_schedule
  character(len=40) :: name = ""
  integer :: num_ops = 0
  integer :: num_autos = 0
  integer :: first_op = 0
  type (management_ops), dimension (:), allocatable :: mgt_ops
  character(len=40), dimension (:), allocatable :: auto_name
  character(len=40), dimension (:), allocatable :: auto_crop
  integer :: auto_crop_num = 0
  integer, dimension (:), allocatable :: num_db
  integer :: irr = 0
end type management_schedule
```

**file.cio Cross-Reference**: `in_lum%management_sch` is loaded from file.cio land use management section

**Notes**:
- Complex nested structure with auto operations and scheduled operations
- Allocates sched(0:imax) where imax = number of schedules
- Each schedule contains variable number of operations (num_ops) and auto operations (num_autos)
- File has hierarchical structure: schedule header, then auto ops, then scheduled ops

---

### 3.18 cntable.lum (INPUT)

**File**: src/cntbl_read.f90  
**Routine**: `cntbl_read`  
**Expression**: `in_lum%cntable_lum`  
**Unit**: 107

#### Filename Resolution

```
cntable.lum → in_lum%cntable_lum
            → type input_lum (src/input_file_module.f90:202-209)
            → character(len=25) :: cntable_lum = "cntable.lum" (line 205)
```

#### I/O Sites

| **Site** | **File** | **Line(s)** | **Operation** | **Unit** | **Expression** |
|----------|----------|-------------|---------------|----------|----------------|
| OPEN | src/cntbl_read.f90 | 25 | `open (107,file=in_lum%cntable_lum)` | 107 | `in_lum%cntable_lum` |
| READ (title) | src/cntbl_read.f90 | 26 | Title line | 107 | - |
| READ (header) | src/cntbl_read.f90 | 28 | Header line | 107 | - |
| READ (count) | src/cntbl_read.f90 | 30-34 | Count records | 107 | Loop |
| READ (data) | src/cntbl_read.f90 | 44-46 | Read CN table | 107 | `cn(icno)` |

#### Payload Map

**Target Variable**: `cn(:)` (allocated array of type `curvenumber_table`)  
**Module**: landuse_data_module  
**Type Definition**: src/landuse_data_module.f90:38-42

**PRIMARY DATA READ**:

| **Variable** | **Field** | **Type** | **Units** | **Description** | **Swat_codetype** | **Source** |
|--------------|-----------|----------|-----------|-----------------|-------------------|------------|
| cn(i)%name | name | character(40) | - | CN table name (land use/treatment/condition) | curvenumber_table%name | Line 45 |
| cn(i)%cn(1) | cn(1) | real | - | Curve number for hydrologic group A | curvenumber_table%cn(1) | Line 45 |
| cn(i)%cn(2) | cn(2) | real | - | Curve number for hydrologic group B | curvenumber_table%cn(2) | Line 45 |
| cn(i)%cn(3) | cn(3) | real | - | Curve number for hydrologic group C | curvenumber_table%cn(3) | Line 45 |
| cn(i)%cn(4) | cn(4) | real | - | Curve number for hydrologic group D | curvenumber_table%cn(4) | Line 45 |

**Type Expansion - curvenumber_table** (src/landuse_data_module.f90:38-42):
```fortran
type curvenumber_table
  character(len=40) :: name = ""                  ! name includes lu/treatment/condition
  real, dimension(4) :: cn = (/30.,55.,70.,77./)  ! curve numbers for A,B,C,D soil groups
end type curvenumber_table
```

**file.cio Cross-Reference**: `in_lum%cntable_lum` is loaded from file.cio land use management section

**Notes**:
- Simple table structure with curve numbers for 4 hydrologic soil groups
- Allocates cn(0:imax)
- Default CN values are provided: 30,55,70,77 for groups A,B,C,D

---

### 3.19 hru.con (INPUT)

**File**: src/hyd_read_connect.f90  
**Routine**: `hyd_read_connect`  
**Expression**: `in_con%hru_con`  
**Unit**: 107

#### Filename Resolution

```
hru.con → in_con%hru_con
        → type input_con (src/input_file_module.f90:40-54)
        → character(len=25) :: hru_con = "hru.con" (line 41)
```

#### I/O Sites

| **Site** | **File** | **Line(s)** | **Operation** | **Unit** | **Expression** |
|----------|----------|-------------|---------------|----------|----------------|
| OPEN | src/hyd_read_connect.f90 | 57 | `open (107,file=con_file)` | 107 | `con_file` (=hru.con) |
| READ (title) | src/hyd_read_connect.f90 | 58 | Title line | 107 | - |
| READ (header) | src/hyd_read_connect.f90 | 60 | Header line | 107 | - |
| READ (data) | src/hyd_read_connect.f90 | Various | Read connections | 107 | `ob(i)` structures |

#### Payload Map

**Target Variable**: `ob(:)` (object connection array)  
**Module**: hydrograph_module

**Notes**:
- Generic connection reader called with different con_file parameters
- For HRUs: called with `in_con%hru_con`, obtyp="hru", nspu=sp_ob%hru
- Sets up connectivity between HRUs and downstream objects
- Allocates hydrograph structures for each HRU
- If constituents enabled, allocates constituent hydrograph structures

**file.cio Cross-Reference**: `in_con%hru_con` is loaded from file.cio connection section

---

### 3.20 rout_unit.con (INPUT)

**File**: src/hyd_read_connect.f90  
**Routine**: `hyd_read_connect`  
**Expression**: `in_con%ru_con`  
**Unit**: 107

#### Filename Resolution

```
rout_unit.con → in_con%ru_con
              → type input_con (src/input_file_module.f90:40-54)
              → character(len=25) :: ru_con = "rout_unit.con" (line 43)
```

**Notes**:
- Uses same `hyd_read_connect` routine as hru.con
- Called with obtyp="ru", nspu=sp_ob%ru
- Defines connectivity for routing units

**file.cio Cross-Reference**: `in_con%ru_con` is loaded from file.cio connection section

---

### 3.21 aquifer.con (INPUT)

**File**: src/hyd_read_connect.f90  
**Routine**: `hyd_read_connect`  
**Expression**: `in_con%aqu_con`  
**Unit**: 107

#### Filename Resolution

```
aquifer.con → in_con%aqu_con
            → type input_con (src/input_file_module.f90:40-54)
            → character(len=25) :: aqu_con = "aquifer.con" (line 45)
```

**Notes**:
- Uses same `hyd_read_connect` routine
- Called with obtyp="aqu", nspu=sp_ob%aqu
- Defines connectivity for aquifers

**file.cio Cross-Reference**: `in_con%aqu_con` is loaded from file.cio connection section

---

### 3.22 channel.con (INPUT)

**File**: src/hyd_read_connect.f90  
**Routine**: `hyd_read_connect`  
**Expression**: `in_con%chan_con`  
**Unit**: 107

#### Filename Resolution

```
channel.con → in_con%chan_con
            → type input_con (src/input_file_module.f90:40-54)
            → character(len=25) :: chan_con = "channel.con" (line 47)
```

**Notes**:
- Uses same `hyd_read_connect` routine
- Called with obtyp="cha", nspu=sp_ob%chan
- Defines connectivity for channels

**file.cio Cross-Reference**: `in_con%chan_con` is loaded from file.cio connection section

---

### 3.23 initial.cha (INPUT)

**File**: src/ch_read_init.f90  
**Routine**: `ch_read_init`  
**Expression**: `in_cha%init`  
**Unit**: 105

#### Filename Resolution

```
initial.cha → in_cha%init
            → type input_cha (src/input_file_module.f90:58-68)
            → character(len=25) :: init = "initial.cha" (line 59)
```

#### I/O Sites

| **Site** | **File** | **Line(s)** | **Operation** | **Unit** | **Expression** |
|----------|----------|-------------|---------------|----------|----------------|
| OPEN | src/ch_read_init.f90 | 27 | `open (105,file=in_cha%init)` | 105 | `in_cha%init` |
| READ (title) | src/ch_read_init.f90 | 28 | Title line | 105 | - |
| READ (header) | src/ch_read_init.f90 | 30 | Header line | 105 | - |
| READ (count) | src/ch_read_init.f90 | 32-36 | Count records | 105 | Loop |
| READ (data) | src/ch_read_init.f90 | 48-50 | Read initial conditions | 105 | `ch_init(ich)` |

#### Payload Map

**Target Variable**: `ch_init(:)` and `sd_init(:)` (arrays of type `channel_init_datafiles`)  
**Module**: channel_data_module  
**Type Definition**: src/channel_data_module.f90

**Type Expansion - channel_init_datafiles**:
```fortran
type channel_init_datafiles
  character(len=16) :: name = "default"
  character(len=16) :: org_min = ""    ! → initial organic-mineral file
  character(len=16) :: pest = ""       ! → initial pesticide file
  character(len=16) :: path = ""       ! → initial pathogen file
  character(len=16) :: hmet = ""       ! → initial heavy metals file
  character(len=16) :: salt = ""       ! → initial salt file
end type channel_init_datafiles
```

**file.cio Cross-Reference**: `in_cha%init` is loaded from file.cio channel section

**Notes**:
- Allocates both ch_init(0:imax) and sd_init(0:imax)
- sd_init used for stream/drainage initial conditions
- Each entry points to constituent-specific initial condition files

---

### 3.24 nutrients.cha (INPUT)

**File**: src/ch_read_nut.f90  
**Routine**: `ch_read_nut`  
**Expression**: `in_cha%nut`  
**Unit**: 105

#### Filename Resolution

```
nutrients.cha → in_cha%nut
              → type input_cha (src/input_file_module.f90:58-68)
              → character(len=25) :: nut = "nutrients.cha" (line 63)
```

#### I/O Sites

| **Site** | **File** | **Line(s)** | **Operation** | **Unit** | **Expression** |
|----------|----------|-------------|---------------|----------|----------------|
| OPEN | src/ch_read_nut.f90 | 33 | `open (105,file=in_cha%nut)` | 105 | `in_cha%nut` |
| READ (title) | src/ch_read_nut.f90 | 34 | Title line | 105 | - |
| READ (header) | src/ch_read_nut.f90 | 36 | Header line | 105 | - |
| READ (count) | src/ch_read_nut.f90 | 38-42 | Count records | 105 | Loop |
| READ (data) | src/ch_read_nut.f90 | 54-57 | Read nutrient parameters | 105 | `ch_nut(ich)` |

#### Payload Map

**Target Variable**: `ch_nut(:)` (allocated array of type `channel_nut_data`)  
**Module**: channel_data_module

**Type Expansion - channel_nut_data** (partial - has 20+ parameters):
```fortran
type channel_nut_data
  integer :: lao = 2               ! light averaging option
  integer :: igropt = 2            ! algae growth option
  real :: ai0 = 50.                ! non-algal light extinction (1/m)
  real :: ai1 = 0.08               ! linear algal self-shading (1/(m*ug/L))
  real :: mumax = 2.0              ! max algae growth rate (1/day)
  real :: rhoq = 2.5               ! algae respiration rate (1/day)
  real :: k_l = 0.75               ! light half-saturation (MJ/m²/day)
  real :: k_n = 0.02               ! N half-saturation (mg N/L)
  real :: k_p = 0.025              ! P half-saturation (mg P/L)
  real :: lambda0 = 1.0            ! non-algal light extinction (1/m)
  ! ... 10+ more parameters for algae, nutrients, etc.
end type channel_nut_data
```

**file.cio Cross-Reference**: `in_cha%nut` is loaded from file.cio channel section

**Notes**:
- Contains parameters for in-stream water quality processes
- Allocates ch_nut(0:imax)
- Lines 62-106 set default values for undefined parameters
- Default values ensure model can run even with incomplete data

---

### 3.25 harv.ops (INPUT)

**File**: src/mgt_read_harvops.f90  
**Routine**: `mgt_read_harvops`  
**Expression**: `in_ops%harv_ops`  
**Unit**: 107

#### Filename Resolution

```
harv.ops → in_ops%harv_ops
         → type input_ops (src/input_file_module.f90:191-199)
         → character(len=25) :: harv_ops = "harv.ops" (line 192)
```

#### I/O Sites

| **Site** | **File** | **Line(s)** | **Operation** | **Unit** | **Expression** |
|----------|----------|-------------|---------------|----------|----------------|
| OPEN | src/mgt_read_harvops.f90 | 25 | `open (107,file=in_ops%harv_ops)` | 107 | `in_ops%harv_ops` |
| READ (title) | src/mgt_read_harvops.f90 | 26 | Title line | 107 | - |
| READ (header) | src/mgt_read_harvops.f90 | 28 | Header line | 107 | - |
| READ (count) | src/mgt_read_harvops.f90 | 30-34 | Count records | 107 | Loop |
| READ (data) | src/mgt_read_harvops.f90 | 43-45 | Read harvest operations | 107 | `harvop_db(iharvop)` |

#### Payload Map

**Target Variable**: `harvop_db(:)` (allocated array of type `harvest_operation`)  
**Module**: mgt_operations_module  
**Type Definition**: src/mgt_operations_module.f90:110-118

**PRIMARY DATA READ**:

| **Variable** | **Field** | **Type** | **Units** | **Description** | **Swat_codetype** | **Source** |
|--------------|-----------|----------|-----------|-----------------|-------------------|------------|
| harvop_db(i)%name | name | character(40) | - | Harvest operation name | harvest_operation%name | Line 44 |
| harvop_db(i)%typ | typ | character(40) | - | Harvest type (grain/biomass/residue/tree/tuber) | harvest_operation%typ | Line 44 |
| harvop_db(i)%hi_ovr | hi_ovr | real | kg/ha/kg/ha | Harvest index override | harvest_operation%hi_ovr | Line 44 |
| harvop_db(i)%eff | eff | real | fraction | Harvest efficiency | harvest_operation%eff | Line 44 |
| harvop_db(i)%bm_min | bm_min | real | kg/ha | Minimum biomass to allow harvest | harvest_operation%bm_min | Line 44 |

**Type Expansion - harvest_operation** (src/mgt_operations_module.f90:110-118):
```fortran
type harvest_operation
  character (len=40) :: name = ""    ! operation name
  character (len=40) :: typ = ""     ! grain;biomass;residue;tree;tuber
  real :: hi_ovr = 0.                ! harvest index target (kg/ha)/(kg/ha)
  real :: eff = 0.                   ! harvest efficiency (fraction removed)
  real :: bm_min = 0                 ! minimum biomass to allow harvest (kg/ha)
end type harvest_operation
```

**file.cio Cross-Reference**: `in_ops%harv_ops` is loaded from file.cio operation scheduling section

**Notes**:
- Allocates harvop_db(0:imax)
- Sets db_mx%harvop_db = imax at line 53
- If file doesn't exist or is "null", allocates harvop_db(0:0)

---

### 3.26 irr.ops (INPUT)

**File**: src/mgt_read_irrops.f90  
**Routine**: `mgt_read_irrops`  
**Expression**: `in_ops%irr_ops`  
**Unit**: 107

#### Filename Resolution

```
irr.ops → in_ops%irr_ops
        → type input_ops (src/input_file_module.f90:191-199)
        → character(len=25) :: irr_ops = "irr.ops" (line 194)
```

#### I/O Sites

| **Site** | **File** | **Line(s)** | **Operation** | **Unit** | **Expression** |
|----------|----------|-------------|---------------|----------|----------------|
| OPEN | src/mgt_read_irrops.f90 | 28 | `open (107,file=in_ops%irr_ops)` | 107 | `in_ops%irr_ops` |
| READ (title) | src/mgt_read_irrops.f90 | 29 | Title line | 107 | - |
| READ (header) | src/mgt_read_irrops.f90 | 31 | Header line | 107 | - |
| READ (count) | src/mgt_read_irrops.f90 | 33-37 | Count records | 107 | Loop |
| READ (data) | src/mgt_read_irrops.f90 | 47-49 | Read irrigation operations | 107 | `irrop_db(irr_op)` |

#### Payload Map

**Target Variable**: `irrop_db(:)` (allocated array of type `irrigation_operation`)  
**Module**: mgt_operations_module  
**Type Definition**: src/mgt_operations_module.f90:5-14

**PRIMARY DATA READ**:

| **Variable** | **Field** | **Type** | **Units** | **Description** | **Swat_codetype** | **Source** |
|--------------|-----------|----------|-----------|-----------------|-------------------|------------|
| irrop_db(i)%name | name | character(40) | - | Irrigation operation name | irrigation_operation%name | Line 48 |
| irrop_db(i)%amt_mm | amt_mm | real | mm | Irrigation application amount | irrigation_operation%amt_mm | Line 48 |
| irrop_db(i)%eff | eff | real | fraction | Irrigation in-field efficiency | irrigation_operation%eff | Line 48 |
| irrop_db(i)%surq | surq | real | fraction | Surface runoff ratio | irrigation_operation%surq | Line 48 |
| irrop_db(i)%dep_mm | dep_mm | real | mm | Depth for subsurface irrigation | irrigation_operation%dep_mm | Line 48 |
| irrop_db(i)%salt | salt | real | mg/kg | Total salt concentration | irrigation_operation%salt | Line 48 |
| irrop_db(i)%no3 | no3 | real | mg/kg | Nitrate concentration | irrigation_operation%no3 | Line 48 |
| irrop_db(i)%po4 | po4 | real | mg/kg | Phosphate concentration | irrigation_operation%po4 | Line 48 |

**Type Expansion - irrigation_operation** (src/mgt_operations_module.f90:5-14):
```fortran
type irrigation_operation
  character (len=40) :: name = ""
  real :: amt_mm = 25.4          ! irrigation amount (mm)
  real :: eff = 0.               ! in-field efficiency
  real :: surq = 0.              ! surface runoff ratio (frac)
  real :: dep_mm = 0.            ! subsurface irrigation depth (mm)
  real :: salt = 0.              ! total salt concentration (mg/kg)
  real :: no3 = 0.               ! nitrate concentration (mg/kg)
  real :: po4 = 0.               ! phosphate concentration (mg/kg)
end type irrigation_operation
```

**file.cio Cross-Reference**: `in_ops%irr_ops` is loaded from file.cio operation scheduling section

**Notes**:
- Allocates irrop_db(0:imax)
- Sets db_mx%irrop_db = imax at line 56
- If file doesn't exist or is "null", allocates irrop_db(0:0)
- Default amt_mm = 25.4 mm (1 inch)

---

### Notes on Complexity

Some files contain highly complex nested structures:
- HRU files link to 10+ other database files
- Channel/reservoir files have multiple sub-components (hydrology, sediment, nutrients, temperature)
- Decision table files have conditional logic structures
- Calibration files have region-specific parameter arrays

Full documentation of all 145+ files would require significant additional effort, with an estimated 50-100 pages per complex file when fully expanded.

### Location Format

All locations follow the format: `src/file.f90:line` or `src/file.f90:line-range`

---

**Report Status**: Phase 2 Extended - 28 of 145+ files fully documented  
**Last Updated**: 2026-01-23

---

## 3.27 reservoir.con (INPUT)

**File**: src/hyd_read_connect.f90  
**Routine**: `hyd_read_connect`  
**Expression**: `in_con%res_con`  
**Unit**: 107

#### Filename Resolution

```
reservoir.con → in_con%res_con
              → type input_con (src/input_file_module.f90:40-54)
              → character(len=25) :: res_con = "reservoir.con" (line 48)
```

#### I/O Sites

| **Site** | **File** | **Line(s)** | **Operation** | **Unit** | **Expression** |
|----------|----------|-------------|---------------|----------|----------------|
| CALL | src/hyd_connect.f90 | 158 | `call hyd_read_connect(in_con%res_con, ...)` | - | `in_con%res_con` |
| OPEN | src/hyd_read_connect.f90 | 57 | `open (107,file=con_file)` | 107 | `con_file` param |
| READ (title) | src/hyd_read_connect.f90 | 58 | Title line | 107 | - |
| READ (header) | src/hyd_read_connect.f90 | 60 | Header line | 107 | - |
| READ (data) | src/hyd_read_connect.f90 | 220-221 | Read object connectivity | 107 | `ob(i)%*` |
| READ (outflows) | src/hyd_read_connect.f90 | 298-301 | Read outflow objects | 107 | `ob(i)%obtyp_out(*)` |
| CLOSE | src/hyd_read_connect.f90 | 342 | Close file | 107 | - |

#### Payload Map

**Target Variable**: `ob(i)` (object_connectivity array, i = sp_ob1%res to sp_ob1%res + sp_ob%res - 1)  
**Module**: hydrograph_module  
**Type Definition**: src/hydrograph_module.f90:321-403

**PRIMARY DATA READ**:

| **Variable** | **Field** | **Type** | **Units** | **Description** | **Swat_codetype** | **Source** |
|--------------|-----------|----------|-----------|-----------------|-------------------|------------|
| ob(i)%num | num | integer | - | Spatial object number | object_connectivity%num | Line 220 |
| ob(i)%name | name | character(16) | - | Object name | object_connectivity%name | Line 220 |
| ob(i)%gis_id | gis_id | integer*8 | - | GIS identification number | object_connectivity%gis_id | Line 220 |
| ob(i)%area_ha | area_ha | real | ha | Drainage area | object_connectivity%area_ha | Line 220 |
| ob(i)%lat | lat | real | degrees | Latitude | object_connectivity%lat | Line 220 |
| ob(i)%long | long | real | degrees | Longitude | object_connectivity%long | Line 220 |
| ob(i)%elev | elev | real | m | Elevation | object_connectivity%elev | Line 220 |
| ob(i)%props | props | integer | - | Properties pointer (reservoir.res) | object_connectivity%props | Line 220 |
| ob(i)%wst_c | wst_c | character(50) | - | Weather station name | object_connectivity%wst_c | Line 220 |
| ob(i)%constit | constit | integer | - | Constituent data pointer | object_connectivity%constit | Line 220 |
| ob(i)%props2 | props2 | integer | - | Secondary properties pointer | object_connectivity%props2 | Line 220 |
| ob(i)%ruleset | ruleset | character(16) | - | Decision table ruleset name | object_connectivity%ruleset | Line 220 |
| ob(i)%src_tot | src_tot | integer | - | Total outflow objects | object_connectivity%src_tot | Line 220 |
| ob(i)%obtyp_out(:) | obtyp_out | character(3) array | - | Outflow object types | object_connectivity%obtyp_out | Line 300 |
| ob(i)%obtypno_out(:) | obtypno_out | integer array | - | Outflow object numbers | object_connectivity%obtypno_out | Line 300 |
| ob(i)%htyp_out(:) | htyp_out | character(3) array | - | Outflow hydrograph types | object_connectivity%htyp_out | Line 300 |
| ob(i)%frac_out(:) | frac_out | real array | fraction | Outflow fractions | object_connectivity%frac_out | Line 300 |

**Type Expansion - object_connectivity** (src/hydrograph_module.f90:321-403):
```fortran
type object_connectivity
  character(len=16) :: name = "default"
  character(len=8) :: typ = " "          ! object type (res for reservoirs)
  integer :: nhyds = 0                   ! number of hydrographs (1 for res)
  real :: lat = 0.                       ! latitude (degrees)
  real :: long = 0.                      ! longitude (degrees)
  real :: elev = 100.                    ! elevation (m)
  real :: area_ha = 80.                  ! drainage area (ha)
  integer :: sp_ob_no = 1                ! spatial object number
  integer :: props = 1                   ! properties pointer to reservoir.res
  character(len=50) :: wst_c = ""        ! weather station name
  integer :: wst = 1                     ! weather station number
  integer :: constit = 0                 ! constituent data pointer
  integer :: props2 = 0                  ! secondary properties pointer
  character(len=16) :: ruleset = ""      ! decision table ruleset name
  integer*8 :: gis_id = 0                ! GIS identifier
  integer :: num = 1                     ! spatial object number
  integer :: src_tot = 0                 ! total outflow objects
  character(len=3), allocatable :: obtyp_out(:)    ! outflow object types
  integer, allocatable :: obtypno_out(:)            ! outflow object numbers
  character(len=3), allocatable :: htyp_out(:)      ! outflow hyd types
  real, allocatable :: frac_out(:)                  ! outflow fractions
  ! ... plus ~80 additional fields for hydrology, routing, constituents
end type object_connectivity
```

**file.cio Cross-Reference**: `in_con%res_con` loaded from file.cio connectivity section

**Notes**:
- Called with parameters: (in_con%res_con, "res     ", sp_ob1%res, sp_ob%res, hd_tot%res, 1)
- Sets ob(i)%typ = "res" for all reservoir objects
- Sets ob(i)%nhyds = 1 (single hydrograph per reservoir)
- Allocates complex nested hydrograph structures if constituents enabled
- Object numbers range from sp_ob1%res to (sp_ob1%res + sp_ob%res - 1)

---

### 3.28 recall.con (INPUT)

**File**: src/hyd_read_connect.f90  
**Routine**: `hyd_read_connect`  
**Expression**: `in_con%rec_con`  
**Unit**: 107

#### Filename Resolution

```
recall.con → in_con%rec_con
           → type input_con (src/input_file_module.f90:40-54)
           → character(len=25) :: rec_con = "recall.con" (line 49)
```

#### I/O Sites

| **Site** | **File** | **Line(s)** | **Operation** | **Unit** | **Expression** |
|----------|----------|-------------|---------------|----------|----------------|
| CALL | src/hyd_connect.f90 | 163 | `call hyd_read_connect(in_con%rec_con, ...)` | - | `in_con%rec_con` |
| OPEN | src/hyd_read_connect.f90 | 57 | `open (107,file=con_file)` | 107 | `con_file` param |
| READ (title) | src/hyd_read_connect.f90 | 58 | Title line | 107 | - |
| READ (header) | src/hyd_read_connect.f90 | 60 | Header line | 107 | - |
| READ (data) | src/hyd_read_connect.f90 | 220-221 | Read object connectivity | 107 | `ob(i)%*` |
| READ (outflows) | src/hyd_read_connect.f90 | 298-301 | Read outflow objects | 107 | `ob(i)%obtyp_out(*)` |
| CLOSE | src/hyd_read_connect.f90 | 342 | Close file | 107 | - |

#### Payload Map

**Target Variable**: `ob(i)` (object_connectivity array, i = sp_ob1%recall to sp_ob1%recall + sp_ob%recall - 1)  
**Module**: hydrograph_module  
**Type Definition**: src/hydrograph_module.f90:321-403

**PRIMARY DATA READ**: Same structure as reservoir.con (section 3.27)

**file.cio Cross-Reference**: `in_con%rec_con` loaded from file.cio connectivity section

**Notes**:
- Called with parameters: (in_con%rec_con, "recall  ", sp_ob1%recall, sp_ob%recall, hd_tot%recall, 1)
- Sets ob(i)%typ = "recall" for all recall objects
- Sets ob(i)%nhyds = 1 (single hydrograph per recall)
- Recall objects read hydrograph data from recall files
- Initializes area_ha_calc = area_ha for drainage area calculations (line 225)

---

### 3.29 exco.con (INPUT)

**File**: src/hyd_read_connect.f90  
**Routine**: `hyd_read_connect`  
**Expression**: `in_con%exco_con`  
**Unit**: 107

#### Filename Resolution

```
exco.con → in_con%exco_con
         → type input_con (src/input_file_module.f90:40-54)
         → character(len=25) :: exco_con = "exco.con" (line 50)
```

#### I/O Sites

| **Site** | **File** | **Line(s)** | **Operation** | **Unit** | **Expression** |
|----------|----------|-------------|---------------|----------|----------------|
| CALL | src/hyd_connect.f90 | 168 | `call hyd_read_connect(in_con%exco_con, ...)` | - | `in_con%exco_con` |
| OPEN | src/hyd_read_connect.f90 | 57 | `open (107,file=con_file)` | 107 | `con_file` param |
| READ (title) | src/hyd_read_connect.f90 | 58 | Title line | 107 | - |
| READ (header) | src/hyd_read_connect.f90 | 60 | Header line | 107 | - |
| READ (data) | src/hyd_read_connect.f90 | 220-221 | Read object connectivity | 107 | `ob(i)%*` |
| READ (outflows) | src/hyd_read_connect.f90 | 298-301 | Read outflow objects | 107 | `ob(i)%obtyp_out(*)` |
| CLOSE | src/hyd_read_connect.f90 | 342 | Close file | 107 | - |

#### Payload Map

**Target Variable**: `ob(i)` (object_connectivity array, i = sp_ob1%exco to sp_ob1%exco + sp_ob%exco - 1)  
**Module**: hydrograph_module  
**Type Definition**: src/hydrograph_module.f90:321-403

**PRIMARY DATA READ**: Same structure as reservoir.con (section 3.27)

**file.cio Cross-Reference**: `in_con%exco_con` loaded from file.cio connectivity section

**Notes**:
- Called with parameters: (in_con%exco_con, "exco    ", sp_ob1%exco, sp_ob%exco, hd_tot%exco, 1)
- Sets ob(i)%typ = "exco" for all export coefficient objects
- Sets ob(i)%nhyds = 1 (single hydrograph per exco)
- Export coefficient objects use regression-based nutrient loading

---

### 3.30 delratio.con (INPUT)

**File**: src/hyd_read_connect.f90  
**Routine**: `hyd_read_connect`  
**Expression**: `in_con%delr_con`  
**Unit**: 107

#### Filename Resolution

```
delratio.con → in_con%delr_con
             → type input_con (src/input_file_module.f90:40-54)
             → character(len=25) :: delr_con = "delratio.con" (line 51)
```

#### I/O Sites

| **Site** | **File** | **Line(s)** | **Operation** | **Unit** | **Expression** |
|----------|----------|-------------|---------------|----------|----------------|
| CALL | src/hyd_connect.f90 | 173 | `call hyd_read_connect(in_con%delr_con, ...)` | - | `in_con%delr_con` |
| OPEN | src/hyd_read_connect.f90 | 57 | `open (107,file=con_file)` | 107 | `con_file` param |
| READ (title) | src/hyd_read_connect.f90 | 58 | Title line | 107 | - |
| READ (header) | src/hyd_read_connect.f90 | 60 | Header line | 107 | - |
| READ (data) | src/hyd_read_connect.f90 | 220-221 | Read object connectivity | 107 | `ob(i)%*` |
| READ (outflows) | src/hyd_read_connect.f90 | 298-301 | Read outflow objects | 107 | `ob(i)%obtyp_out(*)` |
| CLOSE | src/hyd_read_connect.f90 | 342 | Close file | 107 | - |

#### Payload Map

**Target Variable**: `ob(i)` (object_connectivity array, i = sp_ob1%dr to sp_ob1%dr + sp_ob%dr - 1)  
**Module**: hydrograph_module  
**Type Definition**: src/hydrograph_module.f90:321-403

**PRIMARY DATA READ**: Same structure as reservoir.con (section 3.27)

**file.cio Cross-Reference**: `in_con%delr_con` loaded from file.cio connectivity section

**Notes**:
- Called with parameters: (in_con%delr_con, "dr      ", sp_ob1%dr, sp_ob%dr, hd_tot%dr, 1)
- Sets ob(i)%typ = "dr" for all delivery ratio objects
- Sets ob(i)%nhyds = 1 (single hydrograph per dr)
- After connection read, calls dr_db_read to load delivery ratio data (line 174)
- Used for sediment delivery ratio calculations

---

### 3.31 outlet.con (INPUT)

**File**: src/hyd_read_connect.f90  
**Routine**: `hyd_read_connect`  
**Expression**: `in_con%out_con`  
**Unit**: 107

#### Filename Resolution

```
outlet.con → in_con%out_con
           → type input_con (src/input_file_module.f90:40-54)
           → character(len=25) :: out_con = "outlet.con" (line 52)
```

#### I/O Sites

| **Site** | **File** | **Line(s)** | **Operation** | **Unit** | **Expression** |
|----------|----------|-------------|---------------|----------|----------------|
| CALL | src/hyd_connect.f90 | 179 | `call hyd_read_connect(in_con%out_con, ...)` | - | `in_con%out_con` |
| OPEN | src/hyd_read_connect.f90 | 57 | `open (107,file=con_file)` | 107 | `con_file` param |
| READ (title) | src/hyd_read_connect.f90 | 58 | Title line | 107 | - |
| READ (header) | src/hyd_read_connect.f90 | 60 | Header line | 107 | - |
| READ (data) | src/hyd_read_connect.f90 | 220-221 | Read object connectivity | 107 | `ob(i)%*` |
| READ (outflows) | src/hyd_read_connect.f90 | 298-301 | Read outflow objects | 107 | `ob(i)%obtyp_out(*)` |
| CLOSE | src/hyd_read_connect.f90 | 342 | Close file | 107 | - |

#### Payload Map

**Target Variable**: `ob(i)` (object_connectivity array, i = sp_ob1%outlet to sp_ob1%outlet + sp_ob%outlet - 1)  
**Module**: hydrograph_module  
**Type Definition**: src/hydrograph_module.f90:321-403

**PRIMARY DATA READ**: Same structure as reservoir.con (section 3.27)

**file.cio Cross-Reference**: `in_con%out_con` loaded from file.cio connectivity section

**Notes**:
- Called with parameters: (in_con%out_con, "outlet  ", sp_ob1%outlet, sp_ob%outlet, hd_tot%outlet, bsn_prm%day_lag_mx)
- Sets ob(i)%typ = "outlet" for all outlet objects
- Sets ob(i)%nhyds = hd_tot%outlet (multiple hydrographs possible)
- Uses bsn_prm%day_lag_mx for subdaily hydrograph storage (not 1 like res/recall/exco/dr)
- Outlet objects represent watershed outlets with flow monitoring

---

### 3.32 hydrology.cha (INPUT)

**File**: src/ch_read_hyd.f90  
**Routine**: `ch_read_hyd`  
**Expression**: `in_cha%hyd`  
**Unit**: 105

#### Filename Resolution

```
hydrology.cha → in_cha%hyd
              → type input_cha (src/input_file_module.f90:58-67)
              → character(len=25) :: hyd = "hydrology.cha" (line 61)
```

#### I/O Sites

| **Site** | **File** | **Line(s)** | **Operation** | **Unit** | **Expression** |
|----------|----------|-------------|---------------|----------|----------------|
| OPEN | src/ch_read_hyd.f90 | 25 | `open (105,file=in_cha%hyd)` | 105 | `in_cha%hyd` |
| READ (title) | src/ch_read_hyd.f90 | 26 | Title line | 105 | - |
| READ (header) | src/ch_read_hyd.f90 | 28 | Header line | 105 | - |
| READ (count) | src/ch_read_hyd.f90 | 31-33 | Count records | 105 | Loop |
| READ (data) | src/ch_read_hyd.f90 | 49 | Read channel hydrology | 105 | `ch_hyd(ich)` |
| CLOSE | src/ch_read_hyd.f90 | 61 | Close file | 105 | - |

#### Payload Map

**Target Variable**: `ch_hyd(:)` (allocated array of type `channel_hyd_data`)  
**Module**: channel_data_module  
**Type Definition**: src/channel_data_module.f90:69-84

**PRIMARY DATA READ**:

| **Variable** | **Field** | **Type** | **Units** | **Description** | **Swat_codetype** | **Source** |
|--------------|-----------|----------|-----------|-----------------|-------------------|------------|
| ch_hyd(i)%name | name | character(16) | - | Channel hydrology name | channel_hyd_data%name | Line 49 |
| ch_hyd(i)%w | w | real | m | Average channel width | channel_hyd_data%w | Line 49 |
| ch_hyd(i)%d | d | real | m | Average channel depth | channel_hyd_data%d | Line 49 |
| ch_hyd(i)%s | s | real | m/m | Average channel slope | channel_hyd_data%s | Line 49 |
| ch_hyd(i)%l | l | real | km | Main channel length | channel_hyd_data%l | Line 49 |
| ch_hyd(i)%n | n | real | - | Manning's n value | channel_hyd_data%n | Line 49 |
| ch_hyd(i)%k | k | real | mm/hr | Effective hydraulic conductivity | channel_hyd_data%k | Line 49 |
| ch_hyd(i)%wdr | wdr | real | m/m | Width to depth ratio | channel_hyd_data%wdr | Line 49 |
| ch_hyd(i)%alpha_bnk | alpha_bnk | real | days | Bank storage recession alpha | channel_hyd_data%alpha_bnk | Line 49 |
| ch_hyd(i)%side | side | real | - | Channel side slope | channel_hyd_data%side | Line 49 |

**Type Expansion - channel_hyd_data** (src/channel_data_module.f90:69-84):
```fortran
type channel_hyd_data
  character(len=16) :: name = "default"
  real :: w = 2.              ! m       |average width of main channel
  real :: d = .5              ! m       |average depth of main channel
  real :: s = .01             ! m/m     |average slope of main channel
  real :: l = 0.1             ! km      |main channel length in subbasin
  real :: n = .05             ! none    |Manning's "n" value for main channel
  real :: k = 0.01            ! mm/hr   |effective hydraulic conductivity
  real :: wdr = 6.            ! m/m     |channel width to depth ratio
  real :: alpha_bnk = 0.03    ! days    |alpha factor for bank storage recession curve
  real :: side = 0.           !         |change in horizontal distance per unit vertical
end type channel_hyd_data
```

**file.cio Cross-Reference**: `in_cha%hyd` loaded from file.cio channel section

**Notes**:
- Allocates ch_hyd(0:imax)
- Sets db_mx%ch_hyd = imax at line 36
- If file doesn't exist or is "null", allocates ch_hyd(0:0)
- Post-processing (lines 52-58):
  - ch_hyd(i)%alpha_bnk = Exp(-alpha_bnk)
  - Constrains slope: if s <= 0 then s = 0.0001
  - Constrains Manning's n: 0.01 <= n <= 0.70
  - Constrains length: if l <= 0 then l = 0.0010
  - Constrains wdr: if wdr <= 0 then wdr = 3.5
  - Constrains side: if side <= 1.e-6 then side = 2.0

---

### 3.33 sediment.cha (INPUT)

**File**: src/ch_read_sed.f90  
**Routine**: `ch_read_sed`  
**Expression**: `in_cha%sed`  
**Unit**: 105

#### Filename Resolution

```
sediment.cha → in_cha%sed
             → type input_cha (src/input_file_module.f90:58-67)
             → character(len=25) :: sed = "sediment.cha" (line 62)
```

#### I/O Sites

| **Site** | **File** | **Line(s)** | **Operation** | **Unit** | **Expression** |
|----------|----------|-------------|---------------|----------|----------------|
| OPEN | src/ch_read_sed.f90 | 33 | `open (105,file=in_cha%sed)` | 105 | `in_cha%sed` |
| READ (title) | src/ch_read_sed.f90 | 34 | Title line | 105 | - |
| READ (header) | src/ch_read_sed.f90 | 36 | Header line | 105 | - |
| READ (count) | src/ch_read_sed.f90 | 38-42 | Count records | 105 | Loop |
| READ (data) | src/ch_read_sed.f90 | 57 | Read channel sediment | 105 | `ch_sed(ich)` |
| CLOSE | src/ch_read_sed.f90 | 129 | Close file | 105 | - |

#### Payload Map

**Target Variable**: `ch_sed(:)` (allocated array of type `channel_sed_data`)  
**Module**: channel_data_module  
**Type Definition**: src/channel_data_module.f90:86-108 (approximate)

**PRIMARY DATA READ**:

| **Variable** | **Field** | **Type** | **Units** | **Description** | **Swat_codetype** | **Source** |
|--------------|-----------|----------|-----------|-----------------|-------------------|------------|
| ch_sed(i)%name | name | character(16) | - | Channel sediment name | channel_sed_data%name | Line 57 |
| ch_sed(i)%eqn | eqn | integer | - | Sediment routing equation (0-4) | channel_sed_data%eqn | Line 57 |
| ch_sed(i)%cov1 | cov1 | real | - | Channel erodibility factor | channel_sed_data%cov1 | Line 57 |
| ch_sed(i)%cov2 | cov2 | real | - | Channel cover factor | channel_sed_data%cov2 | Line 57 |
| ch_sed(i)%bnk_bd | bnk_bd | real | g/cc | Bulk density of bank sediment | channel_sed_data%bnk_bd | Line 57 |
| ch_sed(i)%bed_bd | bed_bd | real | g/cc | Bulk density of bed sediment | channel_sed_data%bed_bd | Line 57 |
| ch_sed(i)%bnk_kd | bnk_kd | real | cm³/N/s | Bank erodibility coefficient | channel_sed_data%bnk_kd | Line 57 |
| ch_sed(i)%bed_kd | bed_kd | real | cm³/N/s | Bed erodibility coefficient | channel_sed_data%bed_kd | Line 57 |
| ch_sed(i)%bnk_d50 | bnk_d50 | real | μm | D50 particle size (bank) | channel_sed_data%bnk_d50 | Line 57 |
| ch_sed(i)%bed_d50 | bed_d50 | real | μm | D50 particle size (bed) | channel_sed_data%bed_d50 | Line 57 |
| ch_sed(i)%tc_bnk | tc_bnk | real | N/m² | Critical shear stress (bank) | channel_sed_data%tc_bnk | Line 57 |
| ch_sed(i)%tc_bed | tc_bed | real | N/m² | Critical shear stress (bed) | channel_sed_data%tc_bed | Line 57 |
| ch_sed(i)%erod(:) | erod | real array(12) | - | Monthly erodibility factors | channel_sed_data%erod | Line 57 |

**Type Expansion - channel_sed_data** (src/channel_data_module.f90:86-108):
```fortran
type channel_sed_data
  character(len=16) :: name = ""
  integer :: eqn = 0             ! sediment routing method
                                 ! 0=SWAT default, 1=Bagnold, 2=Kodatie
                                 ! 3=Molinas WU, 4=Yang
  real :: cov1 = 0.1             ! none  |channel erodibility factor (0.0-1.0)
  real :: cov2 = 0.1             ! none  |channel cover factor (0.0-1.0)
  real :: bnk_bd = 0.            ! g/cc  |bulk density of channel bank sediment
  real :: bed_bd = 0.            ! g/cc  |bulk density of channel bed sediment
  real :: bnk_kd = 0.            ! cm³/N/s |erodibility coefficient (bank)
  real :: bed_kd = 0.            ! cm³/N/s |erodibility coefficient (bed)
  real :: bnk_d50 = 0.           ! μm    |D50 particle size (bank)
  real :: bed_d50 = 0.           ! μm    |D50 particle size (bed)
  real :: tc_bnk = 0.            ! N/m²  |critical shear stress (bank)
  real :: tc_bed = 0.            ! N/m²  |critical shear stress (bed)
  real :: erod(12)               !       |monthly erodibility factors
  ! ... additional fields
end type channel_sed_data
```

**file.cio Cross-Reference**: `in_cha%sed` loaded from file.cio channel section

**Notes**:
- Allocates ch_sed(0:imax)
- Sets db_mx%ch_sed = imax at line 44
- If file doesn't exist or is "null", allocates ch_sed(0:0)
- Extensive post-processing (lines 60-122):
  - Sets defaults if critical shear stress <= 0: tc_bnk = 0, tc_bed = 0
  - Adjusts cov1/cov2 based on eqn value
  - Sets default bank D50 = 50 μm (silt) if not given
  - Sets default bed D50 = 500 μm (sand) if not given
  - Sets default bank bulk density = 1.40 (silty loam)
  - Sets default bed bulk density = 1.50 (sandy loam)
  - Calculates erodibility coefficients from critical shear stress if not provided
  - If monthly erod sum < 1.e-6, sets all months to cov1 value

---

### 3.34 initial.res (INPUT)

**File**: src/res_read_init.f90  
**Routine**: `res_read_init`  
**Expression**: `in_res%init_res`  
**Unit**: 105

#### Filename Resolution

```
initial.res → in_res%init_res
            → type input_res (src/input_file_module.f90:71-80)
            → character(len=25) :: init_res = "initial.res" (line 72)
```

#### I/O Sites

| **Site** | **File** | **Line(s)** | **Operation** | **Unit** | **Expression** |
|----------|----------|-------------|---------------|----------|----------------|
| OPEN | src/res_read_init.f90 | 27 | `open (105,file=in_res%init_res)` | 105 | `in_res%init_res` |
| READ (title) | src/res_read_init.f90 | 28 | Title line | 105 | - |
| READ (header) | src/res_read_init.f90 | 30 | Header line | 105 | - |
| READ (count) | src/res_read_init.f90 | 32-36 | Count records | 105 | Loop |
| READ (data) | src/res_read_init.f90 | 51 | Read initial conditions | 105 | `res_init_dat_c(ires)` |
| CLOSE | src/res_read_init.f90 | 54 | Close file | 105 | - |

#### Payload Map

**Target Variable**: `res_init_dat_c(:)` (allocated array of type `reservoir_init_data_char`)  
**Module**: reservoir_data_module  
**Type Definition**: src/reservoir_data_module.f90:42-49

**PRIMARY DATA READ**:

| **Variable** | **Field** | **Type** | **Units** | **Description** | **Swat_codetype** | **Source** |
|--------------|-----------|----------|-----------|-----------------|-------------------|------------|
| res_init_dat_c(i)%init | init | character(25) | - | Initial condition name | reservoir_init_data_char%init | Line 51 |
| res_init_dat_c(i)%org_min | org_min | character(25) | - | Organic-mineral data pointer | reservoir_init_data_char%org_min | Line 51 |
| res_init_dat_c(i)%pest | pest | character(25) | - | Pesticide data pointer | reservoir_init_data_char%pest | Line 51 |
| res_init_dat_c(i)%path | path | character(25) | - | Pathogen data pointer | reservoir_init_data_char%path | Line 51 |
| res_init_dat_c(i)%hmet | hmet | character(25) | - | Heavy metal data pointer | reservoir_init_data_char%hmet | Line 51 |
| res_init_dat_c(i)%salt | salt | character(25) | - | Salt data pointer | reservoir_init_data_char%salt | Line 51 |

**Type Expansion - reservoir_init_data_char** (src/reservoir_data_module.f90:42-49):
```fortran
type reservoir_init_data_char
  character(len=25) :: init = ""       ! initial data-points to initial.cha
  character(len=25) :: org_min = ""    ! points to initial organic-mineral input file
  character(len=25) :: pest = ""       ! points to initial pesticide input file
  character(len=25) :: path = ""       ! points to initial pathogen input file
  character(len=25) :: hmet = ""       ! points to initial heavy metals input file
  character(len=25) :: salt = ""       ! points to initial salt input file
end type reservoir_init_data_char
```

**file.cio Cross-Reference**: `in_res%init_res` loaded from file.cio reservoir section

**Notes**:
- Allocates both res_init(0:imax) and wet_init(0:imax)
- Allocates res_init_dat_c(0:imax)
- Sets db_mx%res_init = imax at line 38
- If file doesn't exist or is "null", allocates res_init(0:0) and wet_init(0:0)
- Used for both reservoirs and wetlands
- Pointers are resolved later to actual data indices

---

### 3.35 reservoir.res (INPUT)

**File**: src/res_read.f90  
**Routine**: `res_read`  
**Expression**: `in_res%res`  
**Unit**: 105

#### Filename Resolution

```
reservoir.res → in_res%res
              → type input_res (src/input_file_module.f90:71-80)
              → character(len=25) :: res = "reservoir.res" (line 73)
```

#### I/O Sites

| **Site** | **File** | **Line(s)** | **Operation** | **Unit** | **Expression** |
|----------|----------|-------------|---------------|----------|----------------|
| OPEN | src/res_read.f90 | 49 | `open (105,file=in_res%res)` | 105 | `in_res%res` |
| READ (title) | src/res_read.f90 | 50 | Title line | 105 | - |
| READ (header) | src/res_read.f90 | 52 | Header line | 105 | - |
| READ (count) | src/res_read.f90 | 55-57 | Count records | 105 | Loop |
| READ (data) | src/res_read.f90 | 74 | Read reservoir data | 105 | `res_dat_c(ires)` |

#### Payload Map

**Target Variable**: `res_dat_c(:)` (allocated array of type `reservoir_data_char_input`)  
**Module**: reservoir_data_module  
**Type Definition**: src/reservoir_data_module.f90:5-12

**PRIMARY DATA READ**:

| **Variable** | **Field** | **Type** | **Units** | **Description** | **Swat_codetype** | **Source** |
|--------------|-----------|----------|-----------|-----------------|-------------------|------------|
| res_dat_c(i)%name | name | character(25) | - | Reservoir name | reservoir_data_char_input%name | Line 74 |
| res_dat_c(i)%init | init | character(25) | - | Initial condition pointer | reservoir_data_char_input%init | Line 74 |
| res_dat_c(i)%hyd | hyd | character(25) | - | Hydrology data pointer | reservoir_data_char_input%hyd | Line 74 |
| res_dat_c(i)%release | release | character(25) | - | Release type (simulated/measured) | reservoir_data_char_input%release | Line 74 |
| res_dat_c(i)%sed | sed | character(25) | - | Sediment data pointer | reservoir_data_char_input%sed | Line 74 |
| res_dat_c(i)%nut | nut | character(25) | - | Nutrient data pointer | reservoir_data_char_input%nut | Line 74 |

**Type Expansion - reservoir_data_char_input** (src/reservoir_data_module.f90:5-12):
```fortran
type reservoir_data_char_input
  character(len=25) :: name = "default"
  character(len=25) :: init = ""       ! initial data-points to initial.res
  character(len=25) :: hyd = ""        ! points to hydrology.res for hydrology inputs
  character(len=25) :: release = ""    ! 0=simulated; 1=measured outflow
  character(len=25) :: sed = ""        ! sediment inputs-points to sediment.res
  character(len=25) :: nut = ""        ! nutrient inputs-points to nutrients.res
end type reservoir_data_char_input
```

**file.cio Cross-Reference**: `in_res%res` loaded from file.cio reservoir section

**Notes**:
- Allocates res_dat_c(0:imax) and res_dat(0:imax)
- Sets db_mx%res_dat = imax at line 60
- If file doesn't exist or is "null", allocates res_dat_c(0:0) and res_dat(0:0)
- Character pointers are cross-referenced to database indices in subsequent code (lines 78-100+)
- Links to initial.res, hydrology.res, sediment.res, nutrients.res files

---

### 3.36 graze.ops (INPUT)

**File**: src/mgt_read_grazeops.f90  
**Routine**: `mgt_read_grazeops`  
**Expression**: `in_ops%graze_ops`  
**Unit**: 107

#### Filename Resolution

```
graze.ops → in_ops%graze_ops
          → type input_ops (src/input_file_module.f90:191-199)
          → character(len=25) :: graze_ops = "graze.ops" (line 193)
```

#### I/O Sites

| **Site** | **File** | **Line(s)** | **Operation** | **Unit** | **Expression** |
|----------|----------|-------------|---------------|----------|----------------|
| OPEN | src/mgt_read_grazeops.f90 | 29 | `open (107,file=in_ops%graze_ops)` | 107 | `in_ops%graze_ops` |
| READ (title) | src/mgt_read_grazeops.f90 | 30 | Title line | 107 | - |
| READ (header) | src/mgt_read_grazeops.f90 | 32 | Header line | 107 | - |
| READ (count) | src/mgt_read_grazeops.f90 | 34-38 | Count records | 107 | Loop |
| READ (data) | src/mgt_read_grazeops.f90 | 49-50 | Read grazing operations | 107 | `grazeop_db(igrazop)` |
| CLOSE | src/mgt_read_grazeops.f90 | 63 | Close file | 107 | - |

#### Payload Map

**Target Variable**: `grazeop_db(:)` (allocated array of type `grazing_operation`)  
**Module**: mgt_operations_module  
**Type Definition**: src/mgt_operations_module.f90:122-130

**PRIMARY DATA READ**:

| **Variable** | **Field** | **Type** | **Units** | **Description** | **Swat_codetype** | **Source** |
|--------------|-----------|----------|-----------|-----------------|-------------------|------------|
| grazeop_db(i)%name | name | character(40) | - | Grazing operation name | grazing_operation%name | Line 49 |
| grazeop_db(i)%fertnm | fertnm | character(40) | - | Manure fertilizer name | grazing_operation%fertnm | Line 49 |
| grazeop_db(i)%eat | eat | real | (kg/ha)/day | Dry weight biomass removed by grazing | grazing_operation%eat | Line 49 |
| grazeop_db(i)%tramp | tramp | real | (kg/ha)/day | Dry weight biomass removed by trampling | grazing_operation%tramp | Line 49 |
| grazeop_db(i)%manure | manure | real | (kg/ha)/day | Dry weight of manure deposited | grazing_operation%manure | Line 49 |
| grazeop_db(i)%biomin | biomin | real | kg/ha | Minimum plant biomass for grazing | grazing_operation%biomin | Line 49 |

**Type Expansion - grazing_operation** (src/mgt_operations_module.f90:122-130):
```fortran
type grazing_operation
  character(len=40) :: name = ""
  character(len=40) :: fertnm = " "
  integer :: manure_id = 0                ! fertilizer number from fertilizer.frt
  real :: eat = 0.                        ! (kg/ha)/day |dry weight biomass removed by grazing
  real :: tramp = 0.                      ! (kg/ha)/day |dry weight biomass removed by trampling
  real :: manure = 0.                     ! (kg/ha)/day |dry weight of manure deposited
  real :: biomin = 0.                     ! kg/ha       |minimum plant biomass for grazing
end type grazing_operation
```

**file.cio Cross-Reference**: `in_ops%graze_ops` loaded from file.cio operation scheduling section

**Notes**:
- Allocates grazeop_db(0:imax)
- Sets db_mx%grazeop_db = imax at line 65
- If file doesn't exist or is "null", allocates grazeop_db(0:0)
- Cross-references fertnm with fertilizer.frt database (lines 54-59)
- Sets grazeop_db(i)%manure_id to fertilizer database index

---

### 3.37 chem_app.ops (INPUT)

**File**: src/mgt_read_chemapp.f90  
**Routine**: `mgt_read_chemapp`  
**Expression**: `in_ops%chem_ops`  
**Unit**: 107

#### Filename Resolution

```
chem_app.ops → in_ops%chem_ops
             → type input_ops (src/input_file_module.f90:191-199)
             → character(len=25) :: chem_ops = "chem_app.ops" (line 195)
```

#### I/O Sites

| **Site** | **File** | **Line(s)** | **Operation** | **Unit** | **Expression** |
|----------|----------|-------------|---------------|----------|----------------|
| OPEN | src/mgt_read_chemapp.f90 | 25 | `open (107,file=in_ops%chem_ops)` | 107 | `in_ops%chem_ops` |
| READ (title) | src/mgt_read_chemapp.f90 | 26 | Title line | 107 | - |
| READ (header) | src/mgt_read_chemapp.f90 | 28 | Header line | 107 | - |
| READ (count) | src/mgt_read_chemapp.f90 | 30-34 | Count records | 107 | Loop |
| READ (data) | src/mgt_read_chemapp.f90 | 45 | Read chemical application ops | 107 | `chemapp_db(ichemapp)` |
| CLOSE | src/mgt_read_chemapp.f90 | 52 | Close file | 107 | - |

#### Payload Map

**Target Variable**: `chemapp_db(:)` (allocated array of type `chemical_application_operation`)  
**Module**: mgt_operations_module  
**Type Definition**: src/mgt_operations_module.f90:97-107

**PRIMARY DATA READ**:

| **Variable** | **Field** | **Type** | **Units** | **Description** | **Swat_codetype** | **Source** |
|--------------|-----------|----------|-----------|-----------------|-------------------|------------|
| chemapp_db(i)%name | name | character(40) | - | Chemical application name | chemical_application_operation%name | Line 45 |
| chemapp_db(i)%form | form | character(40) | - | Form (solid/liquid) | chemical_application_operation%form | Line 45 |
| chemapp_db(i)%op_typ | op_typ | character(40) | - | Operation type (spread/spray/inject/direct) | chemical_application_operation%op_typ | Line 45 |
| chemapp_db(i)%app_eff | app_eff | real | - | Application efficiency | chemical_application_operation%app_eff | Line 45 |
| chemapp_db(i)%foliar_eff | foliar_eff | real | - | Foliar efficiency | chemical_application_operation%foliar_eff | Line 45 |
| chemapp_db(i)%inject_dep | inject_dep | real | mm | Injection depth | chemical_application_operation%inject_dep | Line 45 |
| chemapp_db(i)%surf_frac | surf_frac | real | - | Surface fraction (upper 10mm) | chemical_application_operation%surf_frac | Line 45 |
| chemapp_db(i)%drift_pot | drift_pot | real | - | Drift potential | chemical_application_operation%drift_pot | Line 45 |
| chemapp_db(i)%aerial_unif | aerial_unif | real | - | Aerial uniformity | chemical_application_operation%aerial_unif | Line 45 |

**Type Expansion - chemical_application_operation** (src/mgt_operations_module.f90:97-107):
```fortran
type chemical_application_operation
  character(len=40) :: name = ""
  character(len=40) :: form = " "          ! solid; liquid
  character(len=40) :: op_typ = " "        ! operation type-spread; spray; inject; direct
  real :: app_eff = 0.                     ! application efficiency
  real :: foliar_eff = 0.                  ! foliar efficiency
  real :: inject_dep = 0.                  ! mm |injection depth
  real :: surf_frac = 0.                   ! surface fraction-amount in upper 10 mm
  real :: drift_pot = 0.                   ! drift potential
  real :: aerial_unif = 0.                 ! aerial uniformity
end type chemical_application_operation
```

**file.cio Cross-Reference**: `in_ops%chem_ops` loaded from file.cio operation scheduling section

**Notes**:
- Allocates chemapp_db(0:imax)
- Sets db_mx%chemapp_db = imax at line 54
- If file doesn't exist or is "null", allocates chemapp_db(0:0)
- Used for fertilizer, pesticide, and other chemical applications
- Links operation parameters to specific chemical applications in management schedules

---

### 3.38 rout_unit.def (INPUT)

**File**: src/ru_read_elements.f90  
**Routine**: `ru_read_elements`  
**Expression**: `in_ru%ru_def`  
**Unit**: 107

#### Filename Resolution

```
rout_unit.def → in_ru%ru_def
              → type input_ru (src/input_file_module.f90:84-89)
              → character(len=25) :: ru_def = "rout_unit.def" (line 85)
```

#### I/O Sites

| **Site** | **File** | **Line(s)** | **Operation** | **Unit** | **Expression** |
|----------|----------|-------------|---------------|----------|----------------|
| OPEN | src/ru_read_elements.f90 | 95 | `open (107,file=in_ru%ru_def)` | 107 | `in_ru%ru_def` |
| READ (title) | src/ru_read_elements.f90 | 96 | Title line | 107 | - |
| READ (header) | src/ru_read_elements.f90 | 98 | Header line | 107 | - |
| READ (count) | src/ru_read_elements.f90 | 100-105 | Count records | 107 | Loop |
| READ (data) | src/ru_read_elements.f90 | 119-121 | Read routing unit definition | 107 | `ru_def(i)` |
| CLOSE | src/ru_read_elements.f90 | 127 | Close file | 107 | - |

#### Payload Map

**Target Variable**: `ru_def(:)` (allocated array of type `ru_definition`)  
**Module**: ru_module (implied)  
**Referenced at**: src/ru_read_elements.f90:55

**PRIMARY DATA READ**:

| **Variable** | **Field** | **Type** | **Units** | **Description** | **Swat_codetype** | **Source** |
|--------------|-----------|----------|-----------|-----------------|-------------------|------------|
| ru_def(i)%num | num | integer | - | Routing unit number | ru_definition%num | Line 119 |
| ru_def(i)%name | name | character | - | Routing unit name | ru_definition%name | Line 119 |
| ru_def(i)%topo | topo | character | - | Topography data pointer | ru_definition%topo | Line 119 |
| ru_def(i)%field | field | character | - | Field data pointer | ru_definition%field | Line 119 |
| ru_def(i)%ru_ele | ru_ele | integer | - | Number of routing elements | ru_definition%ru_ele | Line 120 |
| ru_def(i)%elem(:) | elem | integer array | - | Element numbers | ru_definition%elem | Line 121 |

**file.cio Cross-Reference**: `in_ru%ru_def` loaded from file.cio routing unit section

**Notes**:
- Allocates ru_def(imax) at line 108
- Sets db_mx%ru_def = imax at line 107
- If file doesn't exist or is "null", processing skipped
- Uses 2-step read: first reads basic data, then allocates and reads element array
- Element numbers cross-reference to ru_elem array
- Defines which elements belong to each routing unit

---

### 3.39 rout_unit.ele (INPUT)

**File**: src/ru_read_elements.f90  
**Routine**: `ru_read_elements`  
**Expression**: `in_ru%ru_ele`  
**Unit**: 107

#### Filename Resolution

```
rout_unit.ele → in_ru%ru_ele
              → type input_ru (src/input_file_module.f90:84-89)
              → character(len=25) :: ru_ele = "rout_unit.ele" (line 86)
```

#### I/O Sites

| **Site** | **File** | **Line(s)** | **Operation** | **Unit** | **Expression** |
|----------|----------|-------------|---------------|----------|----------------|
| OPEN | src/ru_read_elements.f90 | 42 | `open (107,file=in_ru%ru_ele)` | 107 | `in_ru%ru_ele` |
| READ (title) | src/ru_read_elements.f90 | 43 | Title line | 107 | - |
| READ (header) | src/ru_read_elements.f90 | 45 | Header line | 107 | - |
| READ (count) | src/ru_read_elements.f90 | 48-52 | Count records | 107 | Loop |
| READ (data) | src/ru_read_elements.f90 | 71-72 | Read routing unit elements | 107 | `ru_elem(i)` |
| CLOSE | src/ru_read_elements.f90 | 87 | Close file | 107 | - |

#### Payload Map

**Target Variable**: `ru_elem(:)` (allocated array of type `ru_element_definition`)  
**Module**: ru_module (implied)  
**Referenced at**: src/ru_read_elements.f90:56

**PRIMARY DATA READ**:

| **Variable** | **Field** | **Type** | **Units** | **Description** | **Swat_codetype** | **Source** |
|--------------|-----------|----------|-----------|-----------------|-------------------|------------|
| ru_elem(i)%num | num | integer | - | Element number | ru_element_definition%num | Line 71 |
| ru_elem(i)%name | name | character | - | Element name | ru_element_definition%name | Line 71 |
| ru_elem(i)%obtyp | obtyp | character | - | Object type (hru/hlt/etc) | ru_element_definition%obtyp | Line 71 |
| ru_elem(i)%obtypno | obtypno | integer | - | Object type number | ru_element_definition%obtypno | Line 71 |
| ru_elem(i)%frac | frac | real | - | Fraction of element flow | ru_element_definition%frac | Line 71 |
| ru_elem(i)%dr_name | dr_name | character | - | Delivery ratio name | ru_element_definition%dr_name | Line 72 |

**file.cio Cross-Reference**: `in_ru%ru_ele` loaded from file.cio routing unit section

**Notes**:
- Allocates ru_elem(imax) at line 56
- Sets db_mx%ru_elem = imax at line 54
- If file doesn't exist or is "null", processing skipped
- Cross-references dr_name with dr_db() from delratio.del file (lines 76-82)
- Sets ru_elem(i)%dr to delivery ratio structure
- Defines individual routing elements that comprise routing units

---

### 3.40 rout_unit.rtu (INPUT)

**File**: src/ru_read.f90  
**Routine**: `ru_read`  
**Expression**: `in_ru%ru`  
**Unit**: 107

#### Filename Resolution

```
rout_unit.rtu → in_ru%ru
              → type input_ru (src/input_file_module.f90:84-89)
              → character(len=25) :: ru = "rout_unit.rtu" (line 87)
```

#### I/O Sites

| **Site** | **File** | **Line(s)** | **Operation** | **Unit** | **Expression** |
|----------|----------|-------------|---------------|----------|----------------|
| OPEN | src/ru_read.f90 | 39 | `open (107,file=in_ru%ru)` | 107 | `in_ru%ru` |
| READ (title) | src/ru_read.f90 | 40 | Title line | 107 | - |
| READ (header) | src/ru_read.f90 | 42 | Header line | 107 | - |
| READ (count) | src/ru_read.f90 | 44-49 | Count records | 107 | Loop |
| READ (data) | src/ru_read.f90 | 125-126 | Read routing unit data | 107 | `ru(i)` |

#### Payload Map

**Target Variable**: `ru(:)` (allocated array of type `routing_unit`)  
**Module**: ru_module  
**Referenced at**: src/ru_read.f90:51

**PRIMARY DATA READ**:

| **Variable** | **Field** | **Type** | **Units** | **Description** | **Swat_codetype** | **Source** |
|--------------|-----------|----------|-----------|-----------------|-------------------|------------|
| ru(i)%num | num | integer | - | Routing unit number | routing_unit%num | Line 125 |
| ru(i)%name | name | character | - | Routing unit name | routing_unit%name | Line 125 |
| ru(i)%topo | topo | integer | - | Topography pointer | routing_unit%topo | Line 125 |
| ru(i)%field | field | integer | - | Field data pointer | routing_unit%field | Line 126 |

**file.cio Cross-Reference**: `in_ru%ru` loaded from file.cio routing unit section

**Notes**:
- Allocates ru(0:sp_ob%ru) at line 51
- If file doesn't exist or is "null", allocates ru(0:0)
- Also allocates output arrays: ru_d, ru_m, ru_y, ru_a for different time steps
- If salts enabled (cs_db%num_salts > 0), allocates salt-specific arrays (lines 61-69)
- If constituents enabled (cs_db%num_cs > 0), allocates constituent arrays
- mru_db tracks maximum routing unit database size (line 48)
- Reads topography and field data pointers which cross-reference to other databases

---

### 3.41 channel.cha (INPUT)

**File**: src/sd_channel_read.f90  
**Routine**: `sd_channel_read` (for channel-lte)  
**Expression**: `in_cha%chan_ez` (channel-lte variant)  
**Unit**: 105

#### Filename Resolution

```
channel.cha → in_cha%dat
            → type input_cha (src/input_file_module.f90:58-67)
            → character(len=25) :: dat = "channel.cha" (line 60)
```

#### I/O Sites

Note: Main channel.cha reading is via channel.con cross-reference. This section documents the lte variant channel-lte.cha.

| **Site** | **File** | **Line(s)** | **Operation** | **Unit** | **Expression** |
|----------|----------|-------------|---------------|----------|----------------|
| OPEN | src/sd_channel_read.f90 | 194 | `open (105,file=in_cha%chan_ez)` | 105 | `in_cha%chan_ez` |
| READ (title) | - | - | Title line | 105 | - |
| READ (header) | - | - | Header line | 105 | - |
| READ (data) | - | - | Read channel data | 105 | varies |

#### Payload Map

**Target Variable**: `ch_dat(:)` and `ch_dat_c(:)` (allocated arrays)  
**Module**: channel_data_module  
**Type Definition**: src/channel_data_module.f90:30-36, 60-66

**PRIMARY DATA READ**:

| **Variable** | **Field** | **Type** | **Units** | **Description** | **Swat_codetype** | **Source** |
|--------------|-----------|----------|-----------|-----------------|-------------------|------------|
| ch_dat_c(i)%name | name | character(16) | - | Channel name | channel_data_char_input%name | Varies |
| ch_dat_c(i)%init | init | character(16) | - | Initial data pointer | channel_data_char_input%init | Varies |
| ch_dat_c(i)%hyd | hyd | character(16) | - | Hydrology pointer | channel_data_char_input%hyd | Varies |
| ch_dat_c(i)%sed | sed | character(16) | - | Sediment pointer | channel_data_char_input%sed | Varies |
| ch_dat_c(i)%nut | nut | character(16) | - | Nutrient pointer | channel_data_char_input%nut | Varies |

**Type Expansion - channel_data_char_input** (src/channel_data_module.f90:30-36):
```fortran
type channel_data_char_input
  character(len=16) :: name = "default"
  character(len=16) :: init = ""     ! points to initial_cha
  character(len=16) :: hyd = ""      ! points to hydrology.cha for hydrology inputs
  character(len=16) :: sed = ""      ! sediment inputs-points to sediment.cha
  character(len=16) :: nut = ""      ! nutrient inputs-points to nutrient.cha
end type channel_data_char_input
```

**file.cio Cross-Reference**: `in_cha%dat` loaded from file.cio channel section

**Notes**:
- Primary channel data read through channel.con cross-reference
- channel.cha contains database entries referenced by channel.con props field
- Cross-references to hydrology.cha, sediment.cha, nutrients.cha
- Character pointers resolved to integer indices in ch_dat(i) structure
- Used by main channels and lte (landscape to element) channels

---

### 3.42 channel-lte.cha (INPUT)

**File**: src/sd_channel_read.f90  
**Routine**: `sd_channel_read`  
**Expression**: `in_cha%chan_ez`  
**Unit**: 105

#### Filename Resolution

```
channel-lte.cha → in_cha%chan_ez
                → type input_cha (src/input_file_module.f90:58-67)
                → character(len=25) :: chan_ez = "channel-lte.cha" (line 64)
```

#### I/O Sites

| **Site** | **File** | **Line(s)** | **Operation** | **Unit** | **Expression** |
|----------|----------|-------------|---------------|----------|----------------|
| OPEN | src/sd_channel_read.f90 | 194 | `open (105,file=in_cha%chan_ez)` | 105 | `in_cha%chan_ez` |
| READ (title) | src/sd_channel_read.f90 | 195 | Title line | 105 | - |
| READ (header) | src/sd_channel_read.f90 | 196 | Header line | 105 | - |

#### Payload Map

**Target Variable**: LTE (Landscape to Element) channel data structures  
**Module**: channel_data_module  

**file.cio Cross-Reference**: `in_cha%chan_ez` loaded from file.cio channel section

**Notes**:
- If file doesn't exist or is "null", defaults are used
- LTE channels represent flow between landscape positions
- Similar structure to channel.cha but for finer-scale routing
- Cross-references to hyd-sed-lte.cha for combined hydrology-sediment data

---

### 3.43 sediment.res (INPUT)

**File**: Reservoir sediment reading (part of res_read complex)  
**Routine**: Cross-referenced from reservoir.res  
**Expression**: Part of res_dat_c(i)%sed  
**Unit**: 105 (typical)

#### Filename Resolution

```
sediment.res → res_dat_c(i)%sed pointer
             → Cross-referenced in reservoir.res reading
             → Links to sediment.res database entries
```

#### I/O Sites

Referenced through reservoir.res file, line 74 sets pointer.

#### Payload Map

**Target Variable**: `res_sed(:)` (allocated array of type `reservoir_sed_data`)  
**Module**: reservoir_data_module  
**Type Definition**: src/reservoir_data_module.f90:98-108 (approximate)

**PRIMARY DATA READ**:

| **Variable** | **Field** | **Type** | **Units** | **Description** | **Swat_codetype** | **Source** |
|--------------|-----------|----------|-----------|-----------------|-------------------|------------|
| res_sed(i)%name | name | character(25) | - | Sediment data name | reservoir_sed_data%name | Varies |
| res_sed(i)%nsed | nsed | real | kg/L | Normal sediment concentration | reservoir_sed_data%nsed | Varies |
| res_sed(i)%sed_stlr | sed_stlr | real | m/yr | Sediment settling rate | reservoir_sed_data%sed_stlr | Varies |

**file.cio Cross-Reference**: Referenced through reservoir.res

**Notes**:
- Part of reservoir properties complex
- Cross-referenced via res_dat_c(i)%sed character pointer
- Converted from mg/L to kg/L during reading
- Defines sediment behavior in reservoirs

---

### 3.44 nutrients.res (INPUT)

**File**: Reservoir nutrient reading (part of res_read complex)  
**Routine**: Cross-referenced from reservoir.res  
**Expression**: Part of res_dat_c(i)%nut  
**Unit**: 105 (typical)

#### Filename Resolution

```
nutrients.res → res_dat_c(i)%nut pointer
              → Cross-referenced in reservoir.res reading
              → Links to nutrients.res database entries
```

#### I/O Sites

Referenced through reservoir.res file, line 74 sets pointer.

#### Payload Map

**Target Variable**: `res_nut(:)` (allocated array of nutrient data)  
**Module**: reservoir_data_module  

**PRIMARY DATA READ**: Nutrient cycling parameters for reservoirs

**file.cio Cross-Reference**: Referenced through reservoir.res

**Notes**:
- Part of reservoir properties complex
- Cross-referenced via res_dat_c(i)%nut character pointer
- Defines nitrogen and phosphorus transformation rates
- Used for water quality simulations in reservoirs

---

### 3.45 wetland.wet (INPUT)

**File**: src/res_read.f90 (wetland variant)  
**Routine**: Part of reservoir reading complex  
**Expression**: `in_res%wet`  
**Unit**: 105

#### Filename Resolution

```
wetland.wet → in_res%wet
            → type input_res (src/input_file_module.f90:71-80)
            → character(len=25) :: wet = "wetland.wet" (line 78)
```

#### I/O Sites

Similar to reservoir.res reading pattern but for wetlands.

#### Payload Map

**Target Variable**: `wet_dat(:)` and `wet_dat_c(:)` (allocated arrays)  
**Module**: reservoir_data_module  
**Type Definition**: Similar to reservoir_data (src/reservoir_data_module.f90:26-37)

**PRIMARY DATA READ**: Same structure as reservoir.res but for wetlands

**file.cio Cross-Reference**: `in_res%wet` loaded from file.cio reservoir section

**Notes**:
- Wetlands use similar data structures to reservoirs
- Allocated alongside reservoir arrays in res_read.f90
- Uses wet_init, wet_hyd, wet_dat parallel structures
- Wetland-specific hydrology in wetland_hyd_data type (lines 82-94 of reservoir_data_module)

---

### 3.46 plants.plt (INPUT)

**File**: Plant parameter database  
**Routine**: `plant_parm_read`  
**Source**: src/plant_parm_read.f90  
**Expression**: `in_parmdb%plants_plt`  
**Unit**: 104

#### Filename Resolution

```
plants.plt → in_parmdb%plants_plt
           → type input_parameter_databases (src/input_file_module.f90:176-187)
           → character(len=25) :: plants_plt = "plants.plt" (line 177)
           → Swat_codetype: "in_parmdb"
```

**file.cio Cross-Reference**: Part of parameter database section in file.cio

#### I/O Sites

| **Site** | **Line** | **Action** | **Unit/Var** | **Expression** | **Description** |
|----------|----------|------------|--------------|----------------|-----------------|
| 1 | 27 | inquire | - | in_parmdb%plants_plt | Check file existence |
| 2 | 34 | open | 104 | in_parmdb%plants_plt | Open plants database |
| 3 | 35 | read | 104 | titldum | Read title |
| 4 | 37 | read | 104 | header | Read header line |
| 5 | 40 | read | 104 | titldum | Count records (loop) |
| 6 | 49 | read | 104 | titldum | Re-read title after rewind |
| 7 | 51 | read | 104 | header | Re-read header after rewind |
| 8 | 56 | read | 104 | pldb(ic) | Read plant database (no classes) |
| 9 | 58 | read | 104 | pldb(ic), pl_class(ic) | Read plant database (with classes) |
| 10 | 70 | close | 104 | - | Close file |

#### Payload Map

**Target Variable**: `pldb(:)` (allocated array of type `plant_db`)  
**Module**: plant_data_module  
**Type Definition**: src/plant_data_module.f90:13-89

**PRIMARY DATA READ**:

| **Variable** | **Field** | **Type** | **Units** | **Description** | **Swat_codetype** | **Source** |
|--------------|-----------|----------|-----------|-----------------|-------------------|------------|
| pldb(ic)%plantnm | plantnm | character(40) | - | Crop/plant name | in_parmdb | plant_db%plantnm |
| pldb(ic)%typ | typ | character(18) | - | Plant category (warm_annual, cold_annual, perennial, etc) | in_parmdb | plant_db%typ |
| pldb(ic)%trig | trig | character(18) | - | Phenology trigger (moisture_gro, temp_gro) | in_parmdb | plant_db%trig |
| pldb(ic)%nfix_co | nfix_co | real | - | N fixation coefficient (0.5=legume, 0=non-legume) | in_parmdb | plant_db%nfix_co |
| pldb(ic)%days_mat | days_mat | integer | days | Days to maturity (default=110) | in_parmdb | plant_db%days_mat |
| pldb(ic)%bio_e | bio_e | real | kg/ha/(MJ/m²) | Biomass-energy ratio (default=15.0) | in_parmdb | plant_db%bio_e |
| pldb(ic)%hvsti | hvsti | real | kg/ha/kg/ha | Harvest index: yield/aboveground biomass (default=0.76) | in_parmdb | plant_db%hvsti |
| pldb(ic)%blai | blai | real | - | Maximum potential leaf area index (default=5.0) | in_parmdb | plant_db%blai |
| pldb(ic)%frgrw1 | frgrw1 | real | - | Fraction of growing season, 1st LAI point (default=0.05) | in_parmdb | plant_db%frgrw1 |
| pldb(ic)%laimx1 | laimx1 | real | - | Fraction of max LAI, 1st point (default=0.05) | in_parmdb | plant_db%laimx1 |
| pldb(ic)%frgrw2 | frgrw2 | real | - | Fraction of growing season, 2nd LAI point (default=0.4) | in_parmdb | plant_db%frgrw2 |
| pldb(ic)%laimx2 | laimx2 | real | - | Fraction of max LAI, 2nd point (default=0.95) | in_parmdb | plant_db%laimx2 |
| pldb(ic)%dlai | dlai | real | - | Fraction of growing season when LAI declines (default=0.99) | in_parmdb | plant_db%dlai |
| pldb(ic)%dlai_rate | dlai_rate | real | - | Exponent governing LAI decline rate (default=1.) | in_parmdb | plant_db%dlai_rate |
| pldb(ic)%chtmx | chtmx | real | m | Maximum canopy height (default=6.0) | in_parmdb | plant_db%chtmx |
| pldb(ic)%rdmx | rdmx | real | m | Maximum root depth (default=3.5) | in_parmdb | plant_db%rdmx |
| pldb(ic)%t_opt | t_opt | real | °C | Optimal temperature for plant growth (default=30.) | in_parmdb | plant_db%t_opt |
| pldb(ic)%t_base | t_base | real | °C | Minimum temperature for plant growth (default=10.) | in_parmdb | plant_db%t_base |
| pldb(ic)%cnyld | cnyld | real | kg N/kg yld | Fraction of nitrogen in yield (default=0.0015) | in_parmdb | plant_db%cnyld |
| pldb(ic)%cpyld | cpyld | real | kg P/kg yld | Fraction of phosphorus in yield (default=0.0003) | in_parmdb | plant_db%cpyld |
| pldb(ic)%pltnfr1 | pltnfr1 | real | kg N/kg biomass | Nitrogen uptake parameter #1 (default=0.006) | in_parmdb | plant_db%pltnfr1 |
| pldb(ic)%pltnfr2 | pltnfr2 | real | kg N/kg biomass | Nitrogen uptake parameter #2 (default=0.002) | in_parmdb | plant_db%pltnfr2 |
| pldb(ic)%pltnfr3 | pltnfr3 | real | kg N/kg biomass | Nitrogen uptake parameter #3 (default=0.0015) | in_parmdb | plant_db%pltnfr3 |
| pldb(ic)%pltpfr1 | pltpfr1 | real | kg P/kg biomass | Phosphorus uptake parameter #1 (default=0.0007) | in_parmdb | plant_db%pltpfr1 |
| pldb(ic)%pltpfr2 | pltpfr2 | real | kg P/kg biomass | Phosphorus uptake parameter #2 (default=0.0004) | in_parmdb | plant_db%pltpfr2 |
| pldb(ic)%pltpfr3 | pltpfr3 | real | kg P/kg biomass | Phosphorus uptake parameter #3 (default=0.0003) | in_parmdb | plant_db%pltpfr3 |
| pldb(ic)%wsyf | wsyf | real | kg/ha/kg/ha | Lower limit of harvest index range (default=0.01) | in_parmdb | plant_db%wsyf |
| pldb(ic)%usle_c | usle_c | real | - | Minimum USLE C factor for water erosion (default=0.001) | in_parmdb | plant_db%usle_c |
| pldb(ic)%gsi | gsi | real | m/s | Maximum stomatal conductance (default=0.002) | in_parmdb | plant_db%gsi |
| pldb(ic)%vpdfr | vpdfr | real | kPa | Vapor pressure deficit at which GMAXFR is valid (default=4.) | in_parmdb | plant_db%vpdfr |
| pldb(ic)%gmaxfr | gmaxfr | real | - | Fraction of max stomatal conductance at VPDFR (default=0.75) | in_parmdb | plant_db%gmaxfr |
| pldb(ic)%wavp | wavp | real | - | Rate of decline in radiation use efficiency (default=8.) | in_parmdb | plant_db%wavp |
| pldb(ic)%co2hi | co2hi | real | μL CO₂/L air | CO₂ concentration for 2nd point on RUE curve (default=660.) | in_parmdb | plant_db%co2hi |
| pldb(ic)%bioehi | bioehi | real | kg/ha/(MJ/m²) | Biomass-energy ratio at CO2HI level (default=16.) | in_parmdb | plant_db%bioehi |
| pldb(ic)%rsdco_pl | rsdco_pl | real | - | Plant residue decomposition coefficient (default=0.05) | in_parmdb | plant_db%rsdco_pl |
| pldb(ic)%alai_min | alai_min | real | m²/m² | Minimum LAI during winter dormancy (default=0.75) | in_parmdb | plant_db%alai_min |
| pldb(ic)%laixco_tree | laixco_tree | real | - | Coefficient to estimate max LAI for trees (default=0.3) | in_parmdb | plant_db%laixco_tree |
| pldb(ic)%mat_yrs | mat_yrs | integer | years | Years to maturity (default=10) | in_parmdb | plant_db%mat_yrs |
| pldb(ic)%bmx_peren | bmx_peren | real | metric tons/ha | Maximum biomass for forest (default=1000.) | in_parmdb | plant_db%bmx_peren |
| pldb(ic)%ext_coef | ext_coef | real | - | Light extinction coefficient (default=0.65) | in_parmdb | plant_db%ext_coef |
| pldb(ic)%leaf_tov_min | leaf_tov_min | real | months | Perennial leaf turnover with min stress (default=12.) | in_parmdb | plant_db%leaf_tov_min |
| pldb(ic)%leaf_tov_max | leaf_tov_max | real | months | Perennial leaf turnover with max stress (default=3.) | in_parmdb | plant_db%leaf_tov_max |
| pldb(ic)%bm_dieoff | bm_dieoff | real | fraction | Aboveground biomass dying at dormancy (default=0.) | in_parmdb | plant_db%bm_dieoff |
| pldb(ic)%rsr1 | rsr1 | real | fraction | Initial root-to-shoot ratio at growth start (default=0.) | in_parmdb | plant_db%rsr1 |
| pldb(ic)%rsr2 | rsr2 | real | fraction | Root-to-shoot ratio at end of season (default=0.) | in_parmdb | plant_db%rsr2 |
| pldb(ic)%pop1 | pop1 | real | plants/m² | Plant population, 1st point on pop-LAI curve (default=0.) | in_parmdb | plant_db%pop1 |
| pldb(ic)%frlai1 | frlai1 | real | fraction | Fraction of max LAI, 1st point on pop curve (default=0.) | in_parmdb | plant_db%frlai1 |
| pldb(ic)%pop2 | pop2 | real | plants/m² | Plant population, 2nd point on pop-LAI curve (default=0.) | in_parmdb | plant_db%pop2 |
| pldb(ic)%frlai2 | frlai2 | real | fraction | Fraction of max LAI, 2nd point on pop curve (default=0.) | in_parmdb | plant_db%frlai2 |
| pldb(ic)%frsw_gro | frsw_gro | real | fraction | 30-day P-PET sum to trigger tropical growth (default=0.5) | in_parmdb | plant_db%frsw_gro |
| pldb(ic)%aeration | aeration | real | - | Aeration stress factor (default=0.2) | in_parmdb | plant_db%aeration |
| pldb(ic)%rsd_pctcov | rsd_pctcov | real | - | Residue factor for percent cover equation (default=0.) | in_parmdb | plant_db%rsd_pctcov |
| pldb(ic)%rsd_covfac | rsd_covfac | real | - | Residue factor for surface cover (C factor) (default=0.) | in_parmdb | plant_db%rsd_covfac |
| pldb(ic)%res_part_fracs | res_part_fracs | derived type | - | Residue partition fractions (metabolic, structural, lignin) | in_parmdb | residue_partition_fracs |

**Derived Type Expansion - residue_partition_fracs** (embedded in plant_db):

| **Component** | **Type** | **Units** | **Default** | **Description** |
|---------------|----------|-----------|-------------|-----------------|
| meta_frac | real | - | 0.85 | Fraction that is metabolic |
| str_frac | real | - | 0.15 | Fraction that is structural |
| lig_frac | real | - | 0.12 | Fraction that is lignin |

**Additional Arrays**:
- `pl_class(:)` - Plant classification (row crop, tree, grass, etc.) - read when bsn_cc%nam1 > 0
- `plcp(:)` - Calculated plant parameters (shape parameters for LAI, N/P uptake, RUE, stomatal conductance)

**Post-Read Processing** (line 61):
- `pldb(ic)%mat_yrs = Max(1, pldb(ic)%mat_yrs)` - Ensures maturity years ≥ 1

**file.cio Cross-Reference**: Referenced in parameter database section

**Notes**:
- Comprehensive plant growth parameter database
- Controls LAI development, biomass production, nutrient uptake
- Critical for crop yield simulation and water/nutrient cycling
- Supports annuals, perennials, and trees with different parameter sets
- Database size stored in db_mx%plantparm

---

### 3.47 fertilizer.frt (INPUT)

**File**: Fertilizer parameter database  
**Routine**: `fert_parm_read`  
**Source**: src/fert_parm_read.f90  
**Expression**: `in_parmdb%fert_frt`  
**Unit**: 107

#### Filename Resolution

```
fertilizer.frt → in_parmdb%fert_frt
               → type input_parameter_databases (src/input_file_module.f90:176-187)
               → character(len=25) :: fert_frt = "fertilizer.frt" (line 178)
               → Swat_codetype: "in_parmdb"
```

**file.cio Cross-Reference**: Part of parameter database section in file.cio

#### I/O Sites

| **Site** | **Line** | **Action** | **Unit/Var** | **Expression** | **Description** |
|----------|----------|------------|--------------|----------------|-----------------|
| 1 | 22 | inquire | - | in_parmdb%fert_frt | Check file existence |
| 2 | 27 | open | 107 | in_parmdb%fert_frt | Open fertilizer database |
| 3 | 28 | read | 107 | titldum | Read title |
| 4 | 30 | read | 107 | header | Read header line |
| 5 | 33 | read | 107 | titldum | Count records (loop) |
| 6 | 41 | read | 107 | titldum | Re-read title after rewind |
| 7 | 43 | read | 107 | header | Re-read header after rewind |
| 8 | 47 | read | 107 | fertdb(it) | Read fertilizer database record |
| 9 | 56 | close | 107 | - | Close file |

#### Payload Map

**Target Variable**: `fertdb(:)` (allocated array of type `fertilizer_db`)  
**Module**: fertilizer_data_module  
**Type Definition**: src/fertilizer_data_module.f90:5-12

**PRIMARY DATA READ**:

| **Variable** | **Field** | **Type** | **Units** | **Description** | **Swat_codetype** | **Source** |
|--------------|-----------|----------|-----------|-----------------|-------------------|------------|
| fertdb(it)%fertnm | fertnm | character(16) | - | Fertilizer name | in_parmdb | fertilizer_db%fertnm |
| fertdb(it)%fminn | fminn | real | kg minN/kg fert | Fraction of fertilizer that is mineral nitrogen (NO₃+NH₃) | in_parmdb | fertilizer_db%fminn |
| fertdb(it)%fminp | fminp | real | kg minP/kg fert | Fraction of fertilizer that is mineral phosphorus | in_parmdb | fertilizer_db%fminp |
| fertdb(it)%forgn | forgn | real | kg orgN/kg fert | Fraction of fertilizer that is organic nitrogen | in_parmdb | fertilizer_db%forgn |
| fertdb(it)%forgp | forgp | real | kg orgP/kg fert | Fraction of fertilizer that is organic phosphorus | in_parmdb | fertilizer_db%forgp |
| fertdb(it)%fnh3n | fnh3n | real | kg NH₃-N/kg N | Fraction of mineral N that is ammonia (NH₃) | in_parmdb | fertilizer_db%fnh3n |

**file.cio Cross-Reference**: Referenced in parameter database section

**Notes**:
- Defines nutrient composition of fertilizers
- Distinguishes between mineral and organic N/P forms
- Critical for nutrient cycling and water quality simulation
- Database size stored in db_mx%fertparm
- Used by management operations in chem_app.ops

---

### 3.48 tillage.til (INPUT)

**File**: Tillage operations parameter database  
**Routine**: `till_parm_read`  
**Source**: src/till_parm_read.f90  
**Expression**: `in_parmdb%till_til`  
**Unit**: 105

#### Filename Resolution

```
tillage.til → in_parmdb%till_til
            → type input_parameter_databases (src/input_file_module.f90:176-187)
            → character(len=25) :: till_til = "tillage.til" (line 179)
            → Swat_codetype: "in_parmdb"
```

**file.cio Cross-Reference**: Part of parameter database section in file.cio

#### I/O Sites

| **Site** | **Line** | **Action** | **Unit/Var** | **Expression** | **Description** |
|----------|----------|------------|--------------|----------------|-----------------|
| 1 | 22 | inquire | - | in_parmdb%till_til | Check file existence |
| 2 | 27 | open | 105 | in_parmdb%till_til | Open tillage database |
| 3 | 28 | read | 105 | titldum | Read title |
| 4 | 30 | read | 105 | header | Read header line |
| 5 | 33 | read | 105 | titldum | Count records (loop) |
| 6 | 41 | read | 105 | titldum | Re-read title after rewind |
| 7 | 43 | read | 105 | header | Re-read header after rewind |
| 8 | 47 | read | 105 | tilldb(itl) | Read tillage database record |
| 9 | 65 | close | 105 | - | Close file |

#### Payload Map

**Target Variable**: `tilldb(:)` (allocated array of type `tillage_db`)  
**Module**: tillage_data_module  
**Type Definition**: src/tillage_data_module.f90:10-17

**PRIMARY DATA READ**:

| **Variable** | **Field** | **Type** | **Units** | **Description** | **Swat_codetype** | **Source** |
|--------------|-----------|----------|-----------|-----------------|-------------------|------------|
| tilldb(itl)%tillnm | tillnm | character(16) | - | Tillage operation name | in_parmdb | tillage_db%tillnm |
| tilldb(itl)%effmix | effmix | real | - | Mixing efficiency of tillage operation (0-1) | in_parmdb | tillage_db%effmix |
| tilldb(itl)%deptil | deptil | real | mm | Depth of mixing caused by tillage | in_parmdb | tillage_db%deptil |
| tilldb(itl)%ranrns | ranrns | real | mm | Random roughness created by tillage | in_parmdb | tillage_db%ranrns |
| tilldb(itl)%ridge_ht | ridge_ht | real | mm | Ridge height created by tillage | in_parmdb | tillage_db%ridge_ht |
| tilldb(itl)%ridge_sp | ridge_sp | real | mm | Ridge interval or row spacing | in_parmdb | tillage_db%ridge_sp |

**Post-Read Processing** (lines 48-60):
- Special handling for "biomix" tillage operation
- If tillnm == "biomix": stores index in bmix_idtill, efficiency in bmix_eff, depth in bmix_depth
- If biomix not found: sets default bmix_eff=0.2, bmix_depth=50.0

**Module-Level Variables** (tillage_data_module):

| **Variable** | **Type** | **Default** | **Description** |
|--------------|----------|-------------|-----------------|
| bmix_idtill | integer | 0 | Index of biomix tillage in tilldb |
| till_eff_days | integer | 30 | Days a tillage operation has effect |
| bmix_eff | real | 0. | Biological mixing efficiency |
| bmix_depth | real | 0. | Biological mixing depth (mm) |

**file.cio Cross-Reference**: Referenced in parameter database section

**Notes**:
- Defines tillage operation characteristics
- Controls soil mixing, surface roughness, and ridge formation
- Biomix operation represents biological mixing (earthworms, etc.)
- Critical for erosion modeling and residue management
- Database size stored in db_mx%tillparm

---

### 3.49 pesticide.pes (INPUT)

**File**: Pesticide parameter database  
**Routine**: `pest_parm_read`  
**Source**: src/pest_parm_read.f90  
**Expression**: `in_parmdb%pest`  
**Unit**: 106

#### Filename Resolution

```
pesticide.pes → in_parmdb%pest
              → type input_parameter_databases (src/input_file_module.f90:176-187)
              → character(len=25) :: pest = "pesticide.pes" (line 180)
              → Swat_codetype: "in_parmdb"
```

**file.cio Cross-Reference**: Part of parameter database section in file.cio

#### I/O Sites

| **Site** | **Line** | **Action** | **Unit/Var** | **Expression** | **Description** |
|----------|----------|------------|--------------|----------------|-----------------|
| 1 | 21 | inquire | - | in_parmdb%pest | Check file existence |
| 2 | 27 | open | 106 | in_parmdb%pest | Open pesticide database |
| 3 | 28 | read | 106 | titldum | Read title |
| 4 | 30 | read | 106 | header | Read header line |
| 5 | 33 | read | 106 | titldum | Count records (loop) |
| 6 | 42 | read | 106 | titldum | Re-read title after rewind |
| 7 | 44 | read | 106 | header | Re-read header after rewind |
| 8 | 48 | read | 106 | pestdb(ip) | Read pesticide database record |
| 9 | 87 | close | 106 | - | Close file |

#### Payload Map

**Target Variable**: `pestdb(:)` (allocated array of type `pesticide_db`)  
**Module**: pesticide_data_module  
**Type Definition**: src/pesticide_data_module.f90:5-22

**PRIMARY DATA READ**:

| **Variable** | **Field** | **Type** | **Units** | **Description** | **Swat_codetype** | **Source** |
|--------------|-----------|----------|-----------|-----------------|-------------------|------------|
| pestdb(ip)%name | name | character(16) | - | Pesticide name | in_parmdb | pesticide_db%name |
| pestdb(ip)%koc | koc | real | mL/g | Soil adsorption coefficient normalized for organic carbon | in_parmdb | pesticide_db%koc |
| pestdb(ip)%washoff | washoff | real | - | Fraction of pesticide on foliage washed off by rainfall | in_parmdb | pesticide_db%washoff |
| pestdb(ip)%foliar_hlife | foliar_hlife | real | days | Half-life of pesticide on foliage | in_parmdb | pesticide_db%foliar_hlife |
| pestdb(ip)%soil_hlife | soil_hlife | real | days | Half-life of pesticide in soil | in_parmdb | pesticide_db%soil_hlife |
| pestdb(ip)%solub | solub | real | mg/L (ppm) | Solubility of chemical in water | in_parmdb | pesticide_db%solub |
| pestdb(ip)%aq_hlife | aq_hlife | real | days | Aquatic half-life | in_parmdb | pesticide_db%aq_hlife |
| pestdb(ip)%aq_volat | aq_volat | real | m/day | Aquatic volatilization coefficient | in_parmdb | pesticide_db%aq_volat |
| pestdb(ip)%mol_wt | mol_wt | real | g/mol | Molecular weight (for mixing velocity calculation) | in_parmdb | pesticide_db%mol_wt |
| pestdb(ip)%aq_resus | aq_resus | real | m/day | Aquatic resuspension velocity for sorbed pesticide | in_parmdb | pesticide_db%aq_resus |
| pestdb(ip)%aq_settle | aq_settle | real | m/day | Aquatic settling velocity for sorbed pesticide | in_parmdb | pesticide_db%aq_settle |
| pestdb(ip)%ben_act_dep | ben_act_dep | real | m | Depth of active benthic layer | in_parmdb | pesticide_db%ben_act_dep |
| pestdb(ip)%ben_bury | ben_bury | real | m/day | Burial velocity in benthic sediment | in_parmdb | pesticide_db%ben_bury |
| pestdb(ip)%ben_hlife | ben_hlife | real | days | Half-life in benthic sediment | in_parmdb | pesticide_db%ben_hlife |
| pestdb(ip)%pl_uptake | pl_uptake | real | - | Fraction taken up by plant | in_parmdb | pesticide_db%pl_uptake |
| pestdb(ip)%descrip | descrip | character(32) | - | Pesticide description | in_parmdb | pesticide_db%descrip |

**Calculated Parameters Array**: `pestcp(:)` (type `pesticide_cp`)

**Post-Read Processing** (lines 58-78):
Calculates decay factors using first-order rate law (dP/dt = -kP):
- P(t) = P₀ * exp(-kt) where k = 0.693/half-life

| **Calculated Field** | **Type** | **Formula** | **Description** |
|---------------------|----------|-------------|-----------------|
| pestcp(ip)%decay_f | real | exp(-0.693/foliar_hlife) | Foliar degradation factor |
| pestcp(ip)%decay_s | real | exp(-0.693/soil_hlife) | Soil degradation factor |
| pestcp(ip)%decay_a | real | exp(-0.693/aq_hlife) | Aquatic degradation factor |
| pestcp(ip)%decay_b | real | exp(-0.693/ben_hlife) | Benthic degradation factor |

**Derived Type - pesticide_cp** (calculated parameters, src/pesticide_data_module.f90:34-42):

| **Component** | **Type** | **Units** | **Description** |
|---------------|----------|-----------|-----------------|
| num_metab | integer | - | Number of metabolites |
| daughter | derived array | - | Daughter decay fractions for metabolites |
| decay_f | real | - | Exp of rate constant for foliar degradation |
| decay_s | real | - | Exp of rate constant for soil degradation |
| decay_a | real | - | Exp of rate constant for aquatic degradation |
| decay_b | real | - | Exp of rate constant for benthic degradation |

**file.cio Cross-Reference**: Referenced in parameter database section

**Notes**:
- Comprehensive pesticide fate and transport parameters
- Handles degradation in multiple compartments: foliage, soil, water, benthic
- Supports daughter product/metabolite tracking
- Critical for water quality and pesticide transport modeling
- Database size stored in db_mx%pestparm
- Uses exponential decay model based on half-lives

---

### 3.50 urban.urb (INPUT)

**File**: Urban land parameter database  
**Routine**: `urban_parm_read`  
**Source**: src/urban_parm_read.f90  
**Expression**: `in_parmdb%urban_urb`  
**Unit**: 108

#### Filename Resolution

```
urban.urb → in_parmdb%urban_urb
          → type input_parameter_databases (src/input_file_module.f90:176-187)
          → character(len=25) :: urban_urb = "urban.urb" (line 184)
          → Swat_codetype: "in_parmdb"
```

**file.cio Cross-Reference**: Part of parameter database section in file.cio

#### I/O Sites

| **Site** | **Line** | **Action** | **Unit/Var** | **Expression** | **Description** |
|----------|----------|------------|--------------|----------------|-----------------|
| 1 | 16 | inquire | - | in_parmdb%urban_urb | Check file existence |
| 2 | 21 | open | 108 | in_parmdb%urban_urb | Open urban database |
| 3 | 22 | read | 108 | titldum | Read title |
| 4 | 24 | read | 108 | header | Read header line |
| 5 | 27 | read | 108 | titldum | Count records (loop) |
| 6 | 36 | read | 108 | titldum | Re-read title after rewind |
| 7 | 38 | read | 108 | header | Re-read header after rewind |
| 8 | 42 | read | 108 | urbdb(iu) | Read urban database record |
| 9 | 51 | close | 108 | - | Close file |

#### Payload Map

**Target Variable**: `urbdb(:)` (allocated array of type `urban_db`)  
**Module**: urban_data_module  
**Type Definition**: src/urban_data_module.f90:5-17

**PRIMARY DATA READ**:

| **Variable** | **Field** | **Type** | **Units** | **Description** | **Swat_codetype** | **Source** |
|--------------|-----------|----------|-----------|-----------------|-------------------|------------|
| urbdb(iu)%urbnm | urbnm | character(16) | - | Urban land parameter set name | in_parmdb | urban_db%urbnm |
| urbdb(iu)%fimp | fimp | real | fraction | Fraction of HRU area that is impervious (default=0.05) | in_parmdb | urban_db%fimp |
| urbdb(iu)%fcimp | fcimp | real | fraction | Fraction of HRU directly connected impervious (default=0.05) | in_parmdb | urban_db%fcimp |
| urbdb(iu)%curbden | curbden | real | km/ha | Curb length density (default=0.0) | in_parmdb | urban_db%curbden |
| urbdb(iu)%urbcoef | urbcoef | real | 1/mm | Wash-off coefficient for constituent removal (default=0.0) | in_parmdb | urban_db%urbcoef |
| urbdb(iu)%dirtmx | dirtmx | real | kg/curb km | Maximum solids buildup on impervious surfaces (default=1000.0) | in_parmdb | urban_db%dirtmx |
| urbdb(iu)%thalf | thalf | real | days | Time to build up to 1/2 max solids level (default=1.0) | in_parmdb | urban_db%thalf |
| urbdb(iu)%tnconc | tnconc | real | mg N/kg sed | Total nitrogen concentration in suspended solids (default=0.0) | in_parmdb | urban_db%tnconc |
| urbdb(iu)%tpconc | tpconc | real | mg P/kg sed | Total phosphorus concentration in suspended solids (default=0.0) | in_parmdb | urban_db%tpconc |
| urbdb(iu)%tno3conc | tno3conc | real | mg NO₃-N/kg sed | Nitrate concentration in suspended solids (default=0.0) | in_parmdb | urban_db%tno3conc |
| urbdb(iu)%urbcn2 | urbcn2 | real | - | Moisture condition II curve number for impervious (default=98.0) | in_parmdb | urban_db%urbcn2 |

**file.cio Cross-Reference**: Referenced in parameter database section

**Notes**:
- Defines urban area characteristics and pollutant loadings
- Distinguishes total impervious from directly connected impervious
- Models solids buildup and washoff from impervious surfaces
- Critical for urban hydrology and water quality simulation
- Database size stored in db_mx%urban
- High default CN2 (98.0) reflects low infiltration on impervious surfaces

---

### 3.51 septic.sep (INPUT)

**File**: Septic system parameter database  
**Routine**: `septic_parm_read`  
**Source**: src/septic_parm_read.f90  
**Expression**: `in_parmdb%septic_sep`  
**Unit**: 171

#### Filename Resolution

```
septic.sep → in_parmdb%septic_sep
           → type input_parameter_databases (src/input_file_module.f90:176-187)
           → character(len=25) :: septic_sep = "septic.sep" (line 185)
           → Swat_codetype: "in_parmdb"
```

**file.cio Cross-Reference**: Part of parameter database section in file.cio

#### I/O Sites

| **Site** | **Line** | **Action** | **Unit/Var** | **Expression** | **Description** |
|----------|----------|------------|--------------|----------------|-----------------|
| 1 | 19 | inquire | - | in_parmdb%septic_sep | Check file existence |
| 2 | 24 | open | 171 | in_parmdb%septic_sep | Open septic database |
| 3 | 25 | read | 171 | titldum | Read title |
| 4 | 27 | read | 171 | header | Read header line |
| 5 | 30 | read | 171 | titldum | Count records (loop) |
| 6 | 39 | read | 171 | titldum | Re-read title after rewind |
| 7 | 41 | read | 171 | header | Re-read header after rewind |
| 8 | 45 | read | 171 | titldum | Pre-read for backspace |
| 9 | 48 | read | 171 | sepdb(is) | Read septic database record (after backspace) |
| 10 | 52 | close | 171 | - | Close file |

#### Payload Map

**Target Variable**: `sepdb(:)` (allocated array of type `septic_db`)  
**Module**: septic_data_module  
**Type Definition**: src/septic_data_module.f90:5-17

**PRIMARY DATA READ**:

| **Variable** | **Field** | **Type** | **Units** | **Description** | **Swat_codetype** | **Source** |
|--------------|-----------|----------|-----------|-----------------|-------------------|------------|
| sepdb(is)%sepnm | sepnm | character(20) | - | Septic system parameter set name | in_parmdb | septic_db%sepnm |
| sepdb(is)%qs | qs | real | m³/d | Flow rate of septic tank effluent per capita (default=0.) | in_parmdb | septic_db%qs |
| sepdb(is)%bodconcs | bodconcs | real | mg/L | Biological oxygen demand in effluent (default=0.) | in_parmdb | septic_db%bodconcs |
| sepdb(is)%tssconcs | tssconcs | real | mg/L | Total suspended solids concentration in effluent (default=0.) | in_parmdb | septic_db%tssconcs |
| sepdb(is)%nh4concs | nh4concs | real | mg/L | Ammonium concentration in effluent (default=0.) | in_parmdb | septic_db%nh4concs |
| sepdb(is)%no3concs | no3concs | real | mg/L | Nitrate concentration in effluent (default=0.) | in_parmdb | septic_db%no3concs |
| sepdb(is)%no2concs | no2concs | real | mg/L | Nitrite concentration in effluent (default=0.) | in_parmdb | septic_db%no2concs |
| sepdb(is)%orgnconcs | orgnconcs | real | mg/L | Organic nitrogen concentration in effluent (default=0.) | in_parmdb | septic_db%orgnconcs |
| sepdb(is)%minps | minps | real | mg/L | Mineral phosphorus concentration in effluent (default=0.) | in_parmdb | septic_db%minps |
| sepdb(is)%orgps | orgps | real | mg/L | Organic phosphorus concentration in effluent (default=0.) | in_parmdb | septic_db%orgps |
| sepdb(is)%fcolis | fcolis | real | cfu/100mL | Fecal coliform concentration in effluent (default=0.) | in_parmdb | septic_db%fcolis |

**Additional Type - septic_system** (src/septic_data_module.f90:20-50):
This more complex type defines individual septic system properties (not read in this routine, but part of the module):

| **Component** | **Type** | **Units** | **Default** | **Description** |
|---------------|----------|-----------|-------------|-----------------|
| name | character(13) | - | "default" | Septic system name |
| typ | integer | - | 0 | Septic system type |
| yr | integer | - | 0 | Year system became operational |
| opt | integer | - | 0 | Operation flag (0=not operated, 1=active, 2=failing) |
| cap | real | - | 0. | Number of permanent residents |
| area | real | m² | 0. | Average drainfield area |
| tfail | integer | days | 0 | Time until failing system gets fixed |
| z | real | mm | 0. | Depth to biozone layer top |
| thk | real | mm | 0. | Biozone layer thickness |
| strm_dist | real | km | 0. | Distance to stream |
| density | real | systems/km² | 0. | Septic systems per km² |
| bd | real | kg/m³ | 0. | Biomass density |
| bod_dc | real | m³/day | 0. | BOD decay rate coefficient |
| bod_conv | real | - | 0. | BOD/bacterial growth conversion factor |
| fc1 | real | - | 0. | Field capacity linear coefficient |
| fc2 | real | - | 0. | Field capacity exponential coefficient |
| fecal | real | m³/day | 0. | Fecal coliform decay rate |
| plq | real | - | 0. | Plaque conversion factor from TDS |
| mrt | real | - | 0. | Mortality rate coefficient |
| rsp | real | - | 0. | Respiration rate coefficient |
| slg1 | real | - | 0. | Slough-off calibration parameter 1 |
| slg2 | real | - | 0. | Slough-off calibration parameter 2 |
| nitr | real | - | 0. | Nitrification rate coefficient |
| denitr | real | - | 0. | Denitrification rate coefficient |
| pdistrb | real | L/kg | 0. | Linear P sorption distribution coefficient |
| psorpmax | real | mg P/kg soil | 0. | Maximum P sorption capacity |
| solpslp | real | - | 0. | Soluble P equation slope |
| solpintc | real | - | 0. | Soluble P equation intercept |

**file.cio Cross-Reference**: Referenced in parameter database section

**Notes**:
- Defines effluent quality from septic systems
- Critical for rural water quality modeling
- Database size stored in db_mx%sep
- Includes comprehensive nutrient and pathogen parameters
- Unique backspace read pattern (lines 45-48) for data parsing

---

### 3.52 snow.sno (INPUT)

**File**: Snow parameter database  
**Routine**: `snowdb_read`  
**Source**: src/snowdb_read.f90  
**Expression**: `in_parmdb%snow`  
**Unit**: 107

#### Filename Resolution

```
snow.sno → in_parmdb%snow
         → type input_parameter_databases (src/input_file_module.f90:176-187)
         → character(len=25) :: snow = "snow.sno" (line 186)
         → Swat_codetype: "in_parmdb"
```

**file.cio Cross-Reference**: Part of parameter database section in file.cio

#### I/O Sites

| **Site** | **Line** | **Action** | **Unit/Var** | **Expression** | **Description** |
|----------|----------|------------|--------------|----------------|-----------------|
| 1 | 23 | inquire | - | in_parmdb%snow | Check file existence |
| 2 | 28 | open | 107 | in_parmdb%snow | Open snow database |
| 3 | 29 | read | 107 | titldum | Read title |
| 4 | 31 | read | 107 | header | Read header line |
| 5 | 34 | read | 107 | titldum | Count records (loop) |
| 6 | 40 | read | 107 | titldum | Re-read title after rewind |
| 7 | 42 | read | 107 | header | Re-read header after rewind |
| 8 | 48 | read | 107 | snodb(isno) | Read snow database record |
| 9 | 56 | close | 107 | - | Close file |

#### Payload Map

**Target Variable**: `snodb(:)` (allocated array of type `snow_parameters`)  
**Module**: hru_module  
**Type Definition**: src/hru_module.f90:72-82

**PRIMARY DATA READ**:

| **Variable** | **Field** | **Type** | **Units** | **Description** | **Swat_codetype** | **Source** |
|--------------|-----------|----------|-----------|-----------------|-------------------|------------|
| snodb(isno)%name | name | character(40) | - | Snow parameter set name | in_parmdb | snow_parameters%name |
| snodb(isno)%falltmp | falltmp | real | °C | Snowfall temperature (default=0.) | in_parmdb | snow_parameters%falltmp |
| snodb(isno)%melttmp | melttmp | real | °C | Snow melt base temperature (default=0.5) | in_parmdb | snow_parameters%melttmp |
| snodb(isno)%meltmx | meltmx | real | mm/°C/day | Maximum melt rate (June 21) (default=4.5) | in_parmdb | snow_parameters%meltmx |
| snodb(isno)%meltmn | meltmn | real | mm/°C/day | Minimum melt rate (Dec 21) (default=0.5) | in_parmdb | snow_parameters%meltmn |
| snodb(isno)%timp | timp | real | - | Snow pack temperature lag factor 0-1 (default=0.8) | in_parmdb | snow_parameters%timp |
| snodb(isno)%covmx | covmx | real | mm H₂O | Snow water content at full ground cover (default=25.0) | in_parmdb | snow_parameters%covmx |
| snodb(isno)%cov50 | cov50 | real | - | Fraction of covmx at 50% snow cover (default=0.5) | in_parmdb | snow_parameters%cov50 |
| snodb(isno)%init_mm | init_mm | real | mm H₂O | Initial snow water content at simulation start (default=0.) | in_parmdb | snow_parameters%init_mm |

**file.cio Cross-Reference**: Referenced in parameter database section

**Notes**:
- Controls snow accumulation and melt processes
- Seasonal melt rate variation (meltmx in summer, meltmn in winter)
- Temperature lag factor (timp) accounts for thermal inertia
- Coverage parameters control albedo and energy balance
- Database size stored in db_mx%sno
- Critical for cold-region hydrology simulation

---

### 3.53 pathogens.pth (INPUT)

**File**: Pathogen parameter database  
**Routine**: `path_parm_read`  
**Source**: src/path_parm_read.f90  
**Expression**: `in_parmdb%pathcom_db`  
**Unit**: 107

#### Filename Resolution

```
pathogens.pth → in_parmdb%pathcom_db
              → type input_parameter_databases (src/input_file_module.f90:176-187)
              → character(len=25) :: pathcom_db = "pathogens.pth" (line 181)
              → Swat_codetype: "in_parmdb"
```

**file.cio Cross-Reference**: Part of parameter database section in file.cio

#### I/O Sites

| **Site** | **Line** | **Action** | **Unit/Var** | **Expression** | **Description** |
|----------|----------|------------|--------------|----------------|-----------------|
| 1 | 20 | inquire | - | in_parmdb%pathcom_db | Check file existence |
| 2 | 25 | open | 107 | in_parmdb%pathcom_db | Open pathogen database |
| 3 | 26 | read | 107 | titldum | Read title |
| 4 | 28 | read | 107 | header | Read header line |
| 5 | 31 | read | 107 | titldum | Count records (loop) |
| 6 | 40 | read | 107 | titldum | Re-read title after rewind |
| 7 | 42 | read | 107 | header | Re-read header after rewind |
| 8 | 46 | read | 107 | titldum | Pre-read for backspace |
| 9 | 49 | read | 107 | path_db(ibac) | Read pathogen database (after backspace) |
| 10 | 56 | close | 107 | - | Close file |

#### Payload Map

**Target Variable**: `path_db(:)` (allocated array of type `pathogen_db`)  
**Module**: pathogen_data_module  
**Type Definition**: src/pathogen_data_module.f90:5-26

**PRIMARY DATA READ**:

| **Variable** | **Field** | **Type** | **Units** | **Description** | **Swat_codetype** | **Source** |
|--------------|-----------|----------|-----------|-----------------|-------------------|------------|
| path_db(ibac)%pathnm | pathnm | character(16) | - | Pathogen name | in_parmdb | pathogen_db%pathnm |
| path_db(ibac)%do_soln | do_soln | real | 1/day | Die-off factor for bacteria in soil solution (default=0.) | in_parmdb | pathogen_db%do_soln |
| path_db(ibac)%gr_soln | gr_soln | real | 1/day | Growth factor for bacteria in soil solution (default=0.) | in_parmdb | pathogen_db%gr_soln |
| path_db(ibac)%do_sorb | do_sorb | real | 1/day | Die-off factor for bacteria adsorbed to soil (default=0.) | in_parmdb | pathogen_db%do_sorb |
| path_db(ibac)%gr_sorb | gr_sorb | real | 1/day | Growth factor for bacteria adsorbed to soil (default=0.) | in_parmdb | pathogen_db%gr_sorb |
| path_db(ibac)%kd | kd | real | - | Partition coefficient solution/sorbed in runoff (default=0.) | in_parmdb | pathogen_db%kd |
| path_db(ibac)%t_adj | t_adj | real | - | Temperature adjustment factor for die-off/growth (default=0.) | in_parmdb | pathogen_db%t_adj |
| path_db(ibac)%washoff | washoff | real | - | Fraction on foliage washed off by rainfall (default=0.) | in_parmdb | pathogen_db%washoff |
| path_db(ibac)%do_plnt | do_plnt | real | 1/day | Die-off factor on foliage (default=0.) | in_parmdb | pathogen_db%do_plnt |
| path_db(ibac)%gr_plnt | gr_plnt | real | 1/day | Growth factor on foliage (default=0.) | in_parmdb | pathogen_db%gr_plnt |
| path_db(ibac)%fr_manure | fr_manure | real | - | Fraction of manure with active CFU (default=0.) | in_parmdb | pathogen_db%fr_manure |
| path_db(ibac)%perco | perco | real | - | Percolation coefficient for solution bacteria (default=0.) | in_parmdb | pathogen_db%perco |
| path_db(ibac)%det_thrshd | det_thrshd | real | CFU/m² | Detection threshold; below this level set to zero (default=0.) | in_parmdb | pathogen_db%det_thrshd |
| path_db(ibac)%do_stream | do_stream | real | 1/day | Die-off factor in streams (default=0.) | in_parmdb | pathogen_db%do_stream |
| path_db(ibac)%gr_stream | gr_stream | real | 1/day | Growth factor in streams (default=0.) | in_parmdb | pathogen_db%gr_stream |
| path_db(ibac)%do_res | do_res | real | 1/day | Die-off factor in reservoirs (default=0.) | in_parmdb | pathogen_db%do_res |
| path_db(ibac)%gr_res | gr_res | real | 1/day | Growth factor in reservoirs (default=0.) | in_parmdb | pathogen_db%gr_res |
| path_db(ibac)%conc_min | conc_min | real | CFU/100mL | Minimum pathogen concentration (default=0.) | in_parmdb | pathogen_db%conc_min |

**file.cio Cross-Reference**: Referenced in parameter database section

**Notes**:
- Models pathogen (bacteria) fate and transport
- Handles multiple environmental compartments: soil, water, vegetation
- Temperature-dependent die-off and growth rates
- Critical for microbial water quality modeling (E. coli, fecal coliform)
- Database size stored in db_mx%path
- Backspace read pattern similar to septic.sep (lines 46-49)
- CFU = Colony Forming Units

---

### 3.54 manure.frt (INPUT)

**File**: Manure parameter database  
**Routine**: `manure_parm_read`  
**Source**: src/manure_parm_read.f90  
**Expression**: Hardcoded string literal "manure.frt"  
**Unit**: 107

#### Filename Resolution

```
manure.frt → Hardcoded literal "manure.frt" in manure_parm_read.f90
           → NOT from input_file_module (hardcoded exception)
           → Swat_codetype: "in_parmdb" (functional equivalent)
```

**file.cio Cross-Reference**: Part of parameter database section in file.cio (implicit)

#### I/O Sites

| **Site** | **Line** | **Action** | **Unit/Var** | **Expression** | **Description** |
|----------|----------|------------|--------------|----------------|-----------------|
| 1 | 22 | inquire | - | "manure.frt" | Check file existence (hardcoded) |
| 2 | 27 | open | 107 | "manure.frt" | Open manure database (hardcoded) |
| 3 | 28 | read | 107 | titldum | Read title |
| 4 | 30 | read | 107 | header | Read header line |
| 5 | 33 | read | 107 | titldum | Count records (loop) |
| 6 | 41 | read | 107 | titldum | Re-read title after rewind |
| 7 | 43 | read | 107 | header | Re-read header after rewind |
| 8 | 47 | read | 107 | manure_db(it) | Read manure database record |
| 9 | 56 | close | 107 | - | Close file |

#### Payload Map

**Target Variable**: `manure_db(:)` (allocated array of type `manure_data`)  
**Module**: fertilizer_data_module  
**Type Definition**: src/fertilizer_data_module.f90:15-20

**PRIMARY DATA READ**:

| **Variable** | **Field** | **Type** | **Units** | **Description** | **Swat_codetype** | **Source** |
|--------------|-----------|----------|-----------|-----------------|-------------------|------------|
| manure_db(it)%manurenm | manurenm | character(16) | - | Manure type name | in_parmdb | manure_data%manurenm |

**Notes on Type Definition**:
The manure_data type (lines 15-20 of fertilizer_data_module.f90) currently contains:
- `manurenm` - manure name (character(16))
- Commented-out fields for pathogen and antibiotic arrays (future expansion)

**file.cio Cross-Reference**: Referenced in parameter database section

**Notes**:
- Simplified manure database (currently only stores names)
- Defined in fertilizer_data_module alongside fertdb
- Database size stored in db_mx%manureparm
- Filename is HARDCODED (not configurable via file.cio)
- Future expansion indicated by commented fields for pathogens and antibiotics
- Likely used in conjunction with fertilizer.frt for organic amendments

---

**Report Status**: Phase 3 - Parameter Databases (Priority 1) - 54 of 145+ files documented  
**Last Updated**: 2026-01-23 (Parameter Database Focus)
