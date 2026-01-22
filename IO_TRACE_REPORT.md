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

| Position in File | Local (Y/N) | Derived Type Name | Component (or Var Name if Local) | Type | Default | Units | Description | Line in File |
|------------------|-------------|-------------------|-----------------------------------|------|---------|-------|-------------|--------------|
| 1 | Y | N/A | k | integer | 0 | none | Aquifer index/ID | src/aqu_read.f90:18 |
| 2 | N | aqudb | aqunm | character(len=16) | "" | N/A | Aquifer name | src/aquifer_module.f90:6 |
| 3 | N | aqudb | aqu_ini | character(len=16) | "" | N/A | Initial aquifer data - points to name in initial.aqu | src/aquifer_module.f90:7 |
| 4 | N | aqudb | flo | real | 0.05 | mm | Flow from aquifer in current time step | src/aquifer_module.f90:8 |
| 5 | N | aqudb | dep_bot | real | 0. | m | Depth from mid-slope surface to bottom of aquifer | src/aquifer_module.f90:9 |
| 6 | N | aqudb | dep_wt | real | 0. | m | Depth from mid-slope surface to water table (initial) | src/aquifer_module.f90:10 |
| 7 | N | aqudb | no3 | real | 0. | ppm NO3-N | Nitrate-N concentration in aquifer (initial) | src/aquifer_module.f90:11 |
| 8 | N | aqudb | minp | real | 0. | ppm P | Mineral phosphorus concentration in aquifer (initial) | src/aquifer_module.f90:12 |
| 9 | N | aqudb | cbn | real | 0.5 | percent | Organic carbon in aquifer (initial) | src/aquifer_module.f90:13 |
| 10 | N | aqudb | flo_dist | real | 50. | m | Average flow distance to stream or object | src/aquifer_module.f90:14 |
| 11 | N | aqudb | bf_max | real | 0. | mm | Maximum daily baseflow - when all channels are contributing | src/aquifer_module.f90:15 |
| 12 | N | aqudb | alpha | real | 0. | 1/days | Lag factor for groundwater recession curve | src/aquifer_module.f90:16 |
| 13 | N | aqudb | revap_co | real | 0. | dimensionless | Revap coefficient - evap=pet*revap_co | src/aquifer_module.f90:17 |
| 14 | N | aqudb | seep | real | 0. | frac | Fraction of recharge that seeps from aquifer | src/aquifer_module.f90:18 |
| 15 | N | aqudb | spyld | real | 0. | m³/m³ | Specific yield of aquifer | src/aquifer_module.f90:19 |
| 16 | N | aqudb | hlife_n | real | 30. | days | Half-life of nitrogen in groundwater | src/aquifer_module.f90:20 |
| 17 | N | aqudb | flo_min | real | 0. | m | Water table depth for return flow to occur | src/aquifer_module.f90:21 |
| 18 | N | aqudb | revap_min | real | 0. | m | Water table depth for revap to occur | src/aquifer_module.f90:22 |


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

| Position in File | Local (Y/N) | Derived Type Name | Component (or Var Name if Local) | Type | Default | Units | Description | Line in File |
|------------------|-------------|-------------------|-----------------------------------|------|---------|-------|-------------|--------------|
| 1 | N | bsn | name | character(len=25) | "" | N/A | Basin name | src/basin_module.f90:10 |
| 2 | N | bsn | area_ls_ha | real | 0. | ha | Land surface area | src/basin_module.f90:11 |
| 3 | N | bsn | area_tot_ha | real | 0. | ha | Total area | src/basin_module.f90:12 |
| 4 | N | sp_ob | objs | integer | 0 | none | Number of objects or 1st object command | src/hydrograph_module.f90:452 |
| 5 | N | sp_ob | hru | integer | 0 | none | Number of HRUs or 1st HRU command | src/hydrograph_module.f90:453 |
| 6 | N | sp_ob | hru_lte | integer | 0 | none | Number of HRU_LTEs or 1st HRU_LTE command | src/hydrograph_module.f90:454 |
| 7 | N | sp_ob | ru | integer | 0 | none | Number of routing units or 1st RU command | src/hydrograph_module.f90:456 |
| 8 | N | sp_ob | gwflow | integer | 0 | none | Number of gwflow objects or 1st gwflow command | src/hydrograph_module.f90:457 |
| 9 | N | sp_ob | aqu | integer | 0 | none | Number of aquifers or 1st aquifer command | src/hydrograph_module.f90:458 |
| 10 | N | sp_ob | chan | integer | 0 | none | Number of channels or 1st channel command | src/hydrograph_module.f90:459 |
| 11 | N | sp_ob | res | integer | 0 | none | Number of reservoirs or 1st reservoir command | src/hydrograph_module.f90:460 |
| 12 | N | sp_ob | recall | integer | 0 | none | Number of recall points or 1st recall command | src/hydrograph_module.f90:461 |
| 13 | N | sp_ob | exco | integer | 0 | none | Number of export coefficients or 1st exco command | src/hydrograph_module.f90:462 |
| 14 | N | sp_ob | dr | integer | 0 | none | Number of delivery ratios or 1st DR command | src/hydrograph_module.f90:463 |
| 15 | N | sp_ob | canal | integer | 0 | none | Number of canals or 1st canal command | src/hydrograph_module.f90:464 |
| 16 | N | sp_ob | pump | integer | 0 | none | Number of pumps or 1st pump command | src/hydrograph_module.f90:465 |
| 17 | N | sp_ob | outlet | integer | 0 | none | Number of outlets or 1st outlet command | src/hydrograph_module.f90:466 |
| 18 | N | sp_ob | chandeg | integer | 0 | none | Number of SWAT-DEG channels or 1st SWAT-DEG channel command | src/hydrograph_module.f90:467 |
| 19 | N | sp_ob | aqu2d | integer | 0 | none | Not currently used (number of 2D aquifers) | src/hydrograph_module.f90:468 |
| 20 | N | sp_ob | herd | integer | 0 | none | Not currently used (number of herds) | src/hydrograph_module.f90:469 |
| 21 | N | sp_ob | wro | integer | 0 | none | Not currently used (number of water rights) | src/hydrograph_module.f90:470 |


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

| Position in Output | Variable Name | Type | Units | Description | Line in File |
|--------------------|---------------|------|-------|-------------|--------------|
| 1 | j | integer | none | HRU number (object number) | src/mgt_sched.f90:62 |
| 2 | time%yrc | integer | year | Calendar year | src/time_module.f90 |
| 3 | time%mo | integer | month | Month (1-12) | src/time_module.f90 |
| 4 | time%day_mo | integer | day | Day of month (1-31) | src/time_module.f90 |
| 5 | pldb(idp)%plantnm | character(len=16) | N/A | Plant name or operation identifier | src/plant_data_module.f90 |
| 6 | operation_literal | character | N/A | Operation type (e.g., "PLANT", "HARVEST", "TILLAGE", "FERT") | Literal string |
| 7 | phubase(j) | real | heat units | Base plant heat units for HRU | src/hru_module.f90 |
| 8 | pcom(j)%plcur(ipl)%phuacc | real | heat units | Accumulated plant heat units | src/plant_module.f90 |
| 9 | soil(j)%sw | real | mm | Soil water content | src/soil_module.f90 |
| 10 | pl_mass(j)%tot(ipl)%m | real | kg/ha | Total plant biomass | src/organic_mineral_mass_module.f90 |
| 11 | pl_mass(j)%rsd_tot%m | real | kg/ha | Surface residue mass | src/organic_mineral_mass_module.f90 |
| 12 | sol_sumno3(j) | real | kg/ha | Total soil NO3-N | src/hru_module.f90 |
| 13 | sol_sumsolp(j) | real | kg/ha | Total soil soluble P | src/hru_module.f90 |
| 14+ | operation_specific_vars | real/integer | varies | Operation-specific variables (varies by operation type) | Various files |

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

| Position in Output | Local (Y/N) | Derived Type Name | Component (or Var Name if Local) | Type | Units | Description | Line in File |
|--------------------|-------------|-------------------|-----------------------------------|------|-------|-------------|--------------|
| 1 | Y | N/A | time%day | integer | day of year | Julian day (1-366) | src/time_module.f90 |
| 2 | Y | N/A | time%mo | integer | month | Month (1-12) | src/time_module.f90 |
| 3 | Y | N/A | time%day_mo | integer | day | Day of month (1-31) | src/time_module.f90 |
| 4 | Y | N/A | time%yrc | integer | year | Calendar year | src/time_module.f90 |
| 5 | Y | N/A | iaq | integer | none | Aquifer number/ID | src/aquifer_output.f90:10 |
| 6 | Y | N/A | ob(iob)%gis_id | integer*8 | none | GIS identifier for object | src/hydrograph_module.f90:342 |
| 7 | Y | N/A | ob(iob)%name | character(len=16) | N/A | Object name | src/hydrograph_module.f90:322 |
| 8 | N | aqu_d | flo | real | mm | Lateral flow from aquifer | src/aquifer_module.f90:37 |
| 9 | N | aqu_d | dep_wt | real | m | Average depth from average surface elevation to water table | src/aquifer_module.f90:38 |
| 10 | N | aqu_d | stor | real | mm | Average water storage in aquifer in timestep | src/aquifer_module.f90:39 |
| 11 | N | aqu_d | rchrg | real | mm | Recharge entering aquifer from other objects | src/aquifer_module.f90:40 |
| 12 | N | aqu_d | seep | real | mm | Seepage from bottom of aquifer | src/aquifer_module.f90:41 |
| 13 | N | aqu_d | revap | real | mm | Plant water uptake and evaporation | src/aquifer_module.f90:42 |
| 14 | N | aqu_d | no3_st | real | kg/ha N | Current total NO3-N mass in aquifer | src/aquifer_module.f90:43 |
| 15 | N | aqu_d | minp | real | kg/ha P | Mineral phosphorus transported in return (lateral) flow | src/aquifer_module.f90:44 |
| 16 | N | aqu_d | cbn | real | percent | Organic carbon in aquifer - currently static | src/aquifer_module.f90:45 |
| 17 | N | aqu_d | orgn | real | kg/ha P | Organic nitrogen in aquifer - currently static | src/aquifer_module.f90:46 |
| 18 | N | aqu_d | no3_rchg | real | kg/ha N | Nitrate NO3-N flowing into aquifer from another object | src/aquifer_module.f90:47 |
| 19 | N | aqu_d | no3_loss | real | kg/ha | Nitrate NO3-N loss | src/aquifer_module.f90:48 |
| 20 | N | aqu_d | no3_lat | real | kg/ha N | Nitrate loading to reach in groundwater | src/aquifer_module.f90:49 |
| 21 | N | aqu_d | no3_seep | real | kg/ha N | Seepage of NO3 to next object | src/aquifer_module.f90:50 |
| 22 | N | aqu_d | flo_cha | real | mm H2O | Surface runoff flowing into channels | src/aquifer_module.f90:51 |
| 23 | N | aqu_d | flo_res | real | mm H2O | Surface runoff flowing into reservoirs | src/aquifer_module.f90:52 |
| 24 | N | aqu_d | flo_ls | real | mm H2O | Surface runoff flowing into a landscape element (HRU or RU) | src/aquifer_module.f90:53 |

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

**Overview**: file.cio contains 31 configuration records, each reading a derived type that holds input filenames for different model components. Each record format: `<label> <filename_structure>`

The table below shows the sequence of reads. Each derived type contains multiple character(len=25) or character(len=80) components representing individual input filenames.

| Position | Local (Y/N) | Label Variable | Derived Type Name | Type Instance | Components Count | Line in File | Declared At |
|----------|-------------|----------------|-------------------|---------------|------------------|--------------|-------------|
| 0 | Y | titldum | N/A | N/A | N/A | src/readcio_read.f90:23 | src/readcio_read.f90:8 |
| 1 | Y | name | N/A | N/A | N/A | src/readcio_read.f90:25 | src/readcio_read.f90:9 |
| 1 | N | N/A | input_sim | in_sim | 5 | src/readcio_read.f90:25 | src/input_file_module.f90:8-15 |
| 2 | Y | name | N/A | N/A | N/A | src/readcio_read.f90:27 | src/readcio_read.f90:9 |
| 2 | N | N/A | input_basin | in_basin | 2 | src/readcio_read.f90:27 | src/input_file_module.f90:18-22 |
| 3 | Y | name | N/A | N/A | N/A | src/readcio_read.f90:29 | src/readcio_read.f90:9 |
| 3 | N | N/A | input_cli | in_cli | 10 | src/readcio_read.f90:29 | src/input_file_module.f90:25-37 |
| 4 | Y | name | N/A | N/A | N/A | src/readcio_read.f90:31 | src/readcio_read.f90:9 |
| 4 | N | N/A | input_con | in_con | 13 | src/readcio_read.f90:31 | src/input_file_module.f90:40-55 |
| 5 | Y | name | N/A | N/A | N/A | src/readcio_read.f90:33 | src/readcio_read.f90:9 |
| 5 | N | N/A | input_cha | in_cha | 8 | src/readcio_read.f90:33 | src/input_file_module.f90:58-68 |
| 6 | Y | name | N/A | N/A | N/A | src/readcio_read.f90:35 | src/readcio_read.f90:9 |
| 6 | N | N/A | input_res | in_res | 8 | src/readcio_read.f90:35 | src/input_file_module.f90:71-81 |
| 7 | Y | name | N/A | N/A | N/A | src/readcio_read.f90:37 | src/readcio_read.f90:9 |
| 7 | N | N/A | input_ru | in_ru | 4 | src/readcio_read.f90:37 | src/input_file_module.f90:84-90 |
| 8 | Y | name | N/A | N/A | N/A | src/readcio_read.f90:39 | src/readcio_read.f90:9 |
| 8 | N | N/A | input_hru | in_hru | 2 | src/readcio_read.f90:39 | src/input_file_module.f90:93-97 |
| 9 | Y | name | N/A | N/A | N/A | src/readcio_read.f90:41 | src/readcio_read.f90:9 |
| 9 | N | N/A | input_exco | in_exco | 6 | src/readcio_read.f90:41 | src/input_file_module.f90:100-108 |
| 10 | Y | name | N/A | N/A | N/A | src/readcio_read.f90:43 | src/readcio_read.f90:9 |
| 10 | N | N/A | input_rec | in_rec | 1 | src/readcio_read.f90:43 | src/input_file_module.f90:111-114 |
| 11 | Y | name | N/A | N/A | N/A | src/readcio_read.f90:45 | src/readcio_read.f90:9 |
| 11 | N | N/A | input_delr | in_delr | 6 | src/readcio_read.f90:45 | src/input_file_module.f90:117-125 |
| 12 | Y | name | N/A | N/A | N/A | src/readcio_read.f90:47 | src/readcio_read.f90:9 |
| 12 | N | N/A | input_aqu | in_aqu | 2 | src/readcio_read.f90:47 | src/input_file_module.f90:128-132 |
| 13 | Y | name | N/A | N/A | N/A | src/readcio_read.f90:49 | src/readcio_read.f90:9 |
| 13 | N | N/A | input_herd | in_herd | 3 | src/readcio_read.f90:49 | src/input_file_module.f90:135-140 |
| 14 | Y | name | N/A | N/A | N/A | src/readcio_read.f90:51 | src/readcio_read.f90:9 |
| 14 | N | N/A | input_water_rights | in_watrts | 3 | src/readcio_read.f90:51 | src/input_file_module.f90:143-148 |
| 15 | Y | name | N/A | N/A | N/A | src/readcio_read.f90:53 | src/readcio_read.f90:9 |
| 15 | N | N/A | input_link | in_link | 2 | src/readcio_read.f90:53 | src/input_file_module.f90:151-155 |
| 16 | Y | name | N/A | N/A | N/A | src/readcio_read.f90:55 | src/readcio_read.f90:9 |
| 16 | N | N/A | input_hydrology | in_hyd | 3 | src/readcio_read.f90:55 | src/input_file_module.f90:158-163 |
| 17 | Y | name | N/A | N/A | N/A | src/readcio_read.f90:57 | src/readcio_read.f90:9 |
| 17 | N | N/A | input_structural | in_str | 5 | src/readcio_read.f90:57 | src/input_file_module.f90:166-173 |
| 18 | Y | name | N/A | N/A | N/A | src/readcio_read.f90:59 | src/readcio_read.f90:9 |
| 18 | N | N/A | input_parameter_databases | in_parmdb | 10 | src/readcio_read.f90:59 | src/input_file_module.f90:176-188 |
| 19 | Y | name | N/A | N/A | N/A | src/readcio_read.f90:61 | src/readcio_read.f90:9 |
| 19 | N | N/A | input_ops | in_ops | 6 | src/readcio_read.f90:61 | src/input_file_module.f90:191-199 |
| 20 | Y | name | N/A | N/A | N/A | src/readcio_read.f90:63 | src/readcio_read.f90:9 |
| 20 | N | N/A | input_lum | in_lum | 5 | src/readcio_read.f90:63 | src/input_file_module.f90:202-209 |
| 21 | Y | name | N/A | N/A | N/A | src/readcio_read.f90:65 | src/readcio_read.f90:9 |
| 21 | N | N/A | input_chg | in_chg | 9 | src/readcio_read.f90:65 | src/input_file_module.f90:212-223 |
| 22 | Y | name | N/A | N/A | N/A | src/readcio_read.f90:67 | src/readcio_read.f90:9 |
| 22 | N | N/A | input_init | in_init | 11 | src/readcio_read.f90:67 | src/input_file_module.f90:226-239 |
| 23 | Y | name | N/A | N/A | N/A | src/readcio_read.f90:69 | src/readcio_read.f90:9 |
| 23 | N | N/A | input_soils | in_sol | 3 | src/readcio_read.f90:69 | src/input_file_module.f90:242-247 |
| 24 | Y | name | N/A | N/A | N/A | src/readcio_read.f90:71 | src/readcio_read.f90:9 |
| 24 | N | N/A | input_condition | in_cond | 4 | src/readcio_read.f90:71 | src/input_file_module.f90:250-256 |
| 25 | Y | name | N/A | N/A | N/A | src/readcio_read.f90:73 | src/readcio_read.f90:9 |
| 25 | N | N/A | input_regions | in_regs | 17 | src/readcio_read.f90:73 | src/input_file_module.f90:259-278 |
| 26 | Y | name | N/A | N/A | N/A | src/readcio_read.f90:76 | src/readcio_read.f90:9 |
| 26 | N | N/A | input_path_pcp | in_path_pcp | 1 | src/readcio_read.f90:76 | src/input_file_module.f90:280-283 |
| 27 | Y | name | N/A | N/A | N/A | src/readcio_read.f90:78 | src/readcio_read.f90:9 |
| 27 | N | N/A | input_path_tmp | in_path_tmp | 1 | src/readcio_read.f90:78 | src/input_file_module.f90:285-288 |
| 28 | Y | name | N/A | N/A | N/A | src/readcio_read.f90:80 | src/readcio_read.f90:9 |
| 28 | N | N/A | input_path_slr | in_path_slr | 1 | src/readcio_read.f90:80 | src/input_file_module.f90:290-293 |
| 29 | Y | name | N/A | N/A | N/A | src/readcio_read.f90:82 | src/readcio_read.f90:9 |
| 29 | N | N/A | input_path_hmd | in_path_hmd | 1 | src/readcio_read.f90:82 | src/input_file_module.f90:295-298 |
| 30 | Y | name | N/A | N/A | N/A | src/readcio_read.f90:84 | src/readcio_read.f90:9 |
| 30 | N | N/A | input_path_wnd | in_path_wnd | 1 | src/readcio_read.f90:84 | src/input_file_module.f90:300-303 |
| 31 | Y | line_buffer | N/A | N/A | N/A | src/readcio_read.f90:89 | src/readcio_read.f90:11 |

**Note**: Position 0 is the title line. Positions 1-30 each read a label (name) followed by a derived type structure. Position 31 reads the output path using formatted I/O to handle spaces in paths.

**Total Components**: The 30 derived types contain 145+ individual filename components in total.

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
