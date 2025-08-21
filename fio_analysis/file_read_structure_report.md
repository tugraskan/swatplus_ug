# File Read Structure Analysis Report

This report analyzes the read structure of files opened with string literals in SWAT+ UG.

## Summary

- **Files analyzed with open statements:** 77
- **Total open statements with string literals:** 758

### Read Operation Types
- **Header reads:** 139
- **Data reads:** 376
- **Title/Skip lines:** 0

## Detailed Analysis

### File: `soils_init.f90`

**Filename:** `soil_lyr_depths.sol` (Unit: 107)
**Line 170:** `open (107,file="soil_lyr_depths.sol")`

**Read Structure:**
1. **Line 171** (data, free_format): `read (107,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
2. **Line 173** (header, free_format): `read (107,*,iostat=eof) header`
   - Variables: header
   - Data types: character
3. **Line 175** (data, free_format): `read (107,*,iostat=eof) units`
   - Variables: units
   - Data types: unknown
4. **Line 179** (data, free_format): `read (107,*,iostat=eof) csld`
   - Variables: csld
   - Data types: character
5. **Line 208** (data, free_format): `read (107,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
6. **Line 209** (header, free_format): `read (107,*,iostat=eof) header`
   - Variables: header
   - Data types: character
7. **Line 210** (data, free_format): `read (107,*,iostat=eof) units`
   - Variables: units
   - Data types: unknown
8. **Line 216** (data, free_format): `read (107,*,iostat=eof) csld`
   - Variables: csld
   - Data types: character

---

### File: `salt_aqu_read.f90`

**Filename:** `salt_aqu.ini` (Unit: 107)
**Line 23:** `open (107,file="salt_aqu.ini")`

**Read Structure:**
1. **Line 24** (data, free_format): `read (107,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
2. **Line 26** (header, free_format): `read (107,*,iostat=eof) header`
   - Variables: header
   - Data types: character
3. **Line 28** (header, free_format): `read (107,*,iostat=eof) header`
   - Variables: header
   - Data types: character
4. **Line 30** (header, free_format): `read (107,*,iostat=eof) header`
   - Variables: header
   - Data types: character
5. **Line 35** (data, free_format): `read (107,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
6. **Line 53** (data, free_format): `read (107,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
7. **Line 55** (header, free_format): `read (107,*,iostat=eof) header`
   - Variables: header
   - Data types: character
8. **Line 57** (header, free_format): `read (107,*,iostat=eof) header`
   - Variables: header
   - Data types: character
9. **Line 59** (header, free_format): `read (107,*,iostat=eof) header`
   - Variables: header
   - Data types: character
10. **Line 63** (data, free_format): `read (107,*,iostat=eof) salt_aqu_ini(isalt)%name,salt_aqu_ini(isalt)%conc,salt_aqu_ini(isalt)%frac`
   - Variables: salt_aqu_ini(isalt)%name, salt_aqu_ini(isalt)%conc, salt_aqu_ini(isalt)%frac
   - Data types: unknown, character

---

### File: `cs_hru_read.f90`

**Filename:** `cs_hru.ini` (Unit: 107)
**Line 23:** `open (107,file="cs_hru.ini")`

**Read Structure:**
1. **Line 24** (data, free_format): `read (107,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
2. **Line 26** (header, free_format): `read (107,*,iostat=eof) header`
   - Variables: header
   - Data types: character
3. **Line 28** (header, free_format): `read (107,*,iostat=eof) header`
   - Variables: header
   - Data types: character
4. **Line 30** (header, free_format): `read (107,*,iostat=eof) header`
   - Variables: header
   - Data types: character
5. **Line 32** (header, free_format): `read (107,*,iostat=eof) header`
   - Variables: header
   - Data types: character
6. **Line 37** (data, free_format): `read (107,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
7. **Line 39** (data, free_format): `read (107,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
8. **Line 41** (data, free_format): `read (107,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
9. **Line 56** (data, free_format): `read (107,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
10. **Line 58** (header, free_format): `read (107,*,iostat=eof) header`
   - Variables: header
   - Data types: character
11. **Line 60** (header, free_format): `read (107,*,iostat=eof) header`
   - Variables: header
   - Data types: character
12. **Line 62** (header, free_format): `read (107,*,iostat=eof) header`
   - Variables: header
   - Data types: character
13. **Line 64** (header, free_format): `read (107,*,iostat=eof) header`
   - Variables: header
   - Data types: character
14. **Line 68** (data, free_format): `read (107,*,iostat=eof) cs_soil_ini(ics)%name`
   - Variables: cs_soil_ini(ics)%name
   - Data types: character
15. **Line 70** (data, free_format): `read (107,*,iostat=eof) cs_soil_ini(ics)%soil`
   - Variables: cs_soil_ini(ics)%soil
   - Data types: character
16. **Line 72** (data, free_format): `read (107,*,iostat=eof) cs_soil_ini(ics)%plt`
   - Variables: cs_soil_ini(ics)%plt
   - Data types: character

---

### File: `salt_plant_read.f90`

**Filename:** `salt_plants` (Unit: 107)
**Line 23:** `open(107,file="salt_plants")`

**Read Structure:**
1. **Line 24** (data, free_format): `read(107,*) titldum`
   - Variables: titldum
   - Data types: unknown
2. **Line 27** (header, free_format): `read(107,*) header`
   - Variables: header
   - Data types: character
3. **Line 28** (data, free_format): `read(107,*) salt_tds_ec`
   - Variables: salt_tds_ec
   - Data types: unknown
4. **Line 31** (data, free_format): `read(107,*)`
   - Data types: unknown
5. **Line 32** (data, free_format): `read(107,*) salt_tol_sim !flag to simulate salt effect on plant growth`
   - Variables: salt_tol_sim !flag to simulate salt effect on plant growth
   - Data types: integer
6. **Line 33** (data, free_format): `read(107,*) salt_soil_type !soil type (1 = CaSO4 soils; 2 = NaCl soils)`
   - Variables: salt_soil_type !soil type (1 = CaSO4 soils; 2 = NaCl soils)
   - Data types: character
7. **Line 34** (data, free_format): `read(107,*) salt_effect !method for applying salt stress: 1 = applied after other stresses; 2 = included with other stresses (min)`
   - Variables: salt_effect !method for applying salt stress: 1 = applied after other stresses; 2 = included with other stresses (min)
   - Data types: unknown
8. **Line 35** (data, free_format): `read(107,*)`
   - Data types: unknown
9. **Line 36** (data, free_format): `read(107,*)`
   - Data types: unknown
10. **Line 37** (data, free_format): `read(107,*)`
   - Data types: unknown
11. **Line 38** (data, free_format): `read(107,*)`
   - Data types: unknown
12. **Line 39** (header, free_format): `read(107,*) header`
   - Variables: header
   - Data types: character
13. **Line 43** (data, free_format): `read(107,*) plant_name,salt_stress_a(iplant),salt_stress_b(iplant)`
   - Variables: plant_name, salt_stress_a(iplant), salt_stress_b(iplant)
   - Data types: unknown, character

---

### File: `cs_fert_read.f90`

**Filename:** `fertilizer.frt_cs` (Unit: 107)
**Line 26:** `open (107,file="fertilizer.frt_cs")`

**Read Structure:**
1. **Line 27** (data, free_format): `read (107,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
2. **Line 28** (header, free_format): `read (107,*,iostat=eof) header`
   - Variables: header
   - Data types: character
3. **Line 38** (data, free_format): `read (107,*) fert_cs(icsi)`
   - Variables: fert_cs(icsi)
   - Data types: unknown

---

### File: `salt_roadsalt_read.f90`

**Filename:** `salt_road` (Unit: 5051)
**Line 48:** `open(5051,file='salt_road')`

**Read Structure:**
1. **Line 49** (data, free_format): `read(5051,*)`
   - Data types: unknown
2. **Line 50** (data, free_format): `read(5051,*)`
   - Data types: unknown
3. **Line 51** (data, free_format): `read(5051,*)`
   - Data types: unknown
4. **Line 52** (data, free_format): `read(5051,*)`
   - Data types: unknown
5. **Line 65** (data, free_format): `read(5051,*) station_name !station name --> already read in cli_read_atmodep`
   - Variables: station_name !station name --> already read in cli_read_atmodep
   - Data types: character
6. **Line 67** (data, free_format): `read(5051,*) salt_ion,rdapp_salt(iadep)%salt(isalt)%road`
   - Variables: salt_ion, rdapp_salt(iadep)%salt(isalt)%road
   - Data types: unknown, real
7. **Line 73** (data, free_format): `read(5051,*) station_name !station name`
   - Variables: station_name !station name
   - Data types: character
8. **Line 76** (data, free_format): `read(5051,*) salt_ion,(rdapp_salt(iadep)%salt(isalt)%roadmo(imo),imo=1,atmodep_cont%num)`
   - Variables: salt_ion, (rdapp_salt(iadep)%salt(isalt)%roadmo(imo), imo=1, atmodep_cont%num)
   - Data types: integer, unknown
9. **Line 82** (data, free_format): `read(5051,*) station_name !station name`
   - Variables: station_name !station name
   - Data types: character
10. **Line 85** (data, free_format): `read(5051,*) salt_ion,(rdapp_salt(iadep)%salt(isalt)%roadyr(iyr),iyr=1,atmodep_cont%num)`
   - Variables: salt_ion, (rdapp_salt(iadep)%salt(isalt)%roadyr(iyr), iyr=1, atmodep_cont%num)
   - Data types: integer, unknown

---

### File: `header_aquifer.f90`

**Filename:** `aquifer_day.txt` (Unit: 2520)
**Line 11:** `open (2520,file="aquifer_day.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `aquifer_day.csv` (Unit: 2524)
**Line 17:** `open (2524,file="aquifer_day.csv",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `aquifer_mon.txt` (Unit: 2521)
**Line 28:** `open (2521,file="aquifer_mon.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `aquifer_mon.csv` (Unit: 2525)
**Line 34:** `open (2525,file="aquifer_mon.csv",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `aquifer_yr.txt` (Unit: 2522)
**Line 45:** `open (2522,file="aquifer_yr.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `aquifer_yr.csv` (Unit: 2526)
**Line 51:** `open (2526,file="aquifer_yr.csv",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `aquifer_aa.txt` (Unit: 2523)
**Line 62:** `open (2523,file="aquifer_aa.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `aquifer_aa.csv` (Unit: 2527)
**Line 68:** `open (2527,file="aquifer_aa.csv",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

### File: `aqu_read_init_cs.f90`

**Filename:** `initial.aqu_cs` (Unit: 105)
**Line 47:** `open (105,file="initial.aqu_cs")`

**Read Structure:**
1. **Line 48** (data, free_format): `read (105,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
2. **Line 50** (header, free_format): `read (105,*,iostat=eof) header`
   - Variables: header
   - Data types: character
3. **Line 53** (data, free_format): `read (105,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
4. **Line 63** (data, free_format): `read (105,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
5. **Line 65** (header, free_format): `read (105,*,iostat=eof) header`
   - Variables: header
   - Data types: character
6. **Line 68** (data, free_format): `read (105,*,iostat=eof) aqu_init_dat_c_cs(iaqu)`
   - Variables: aqu_init_dat_c_cs(iaqu)
   - Data types: unknown

---

### File: `header_snutc.f90`

**Filename:** `hru_orgc.txt` (Unit: 2610)
**Line 10:** `open (2610,file="hru_orgc.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_totc.txt` (Unit: 2611)
**Line 18:** `open (2611,file="hru_totc.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_totc.txt` (Unit: 2613)
**Line 26:** `open (2613,file="basin_totc.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

### File: `res_read_conds.f90`

**Filename:** `res_conds.dat` (Unit: 100)
**Line 21:** `open (100,file="res_conds.dat")`

**Read Structure:**
1. **Line 22** (data, free_format): `read (100,*,iostat=eof) title`
   - Variables: title
   - Data types: character
2. **Line 24** (data, free_format): `read (100,*,iostat=eof) max_table`
   - Variables: max_table
   - Data types: integer
3. **Line 32** (data, free_format): `read (100,*) ctbl(ictbl)%name, ctbl(ictbl)%num_conds, ctbl(ictbl)%num_modules`
   - Variables: ctbl(ictbl)%name, ctbl(ictbl)%num_conds, ctbl(ictbl)%num_modules
   - Data types: integer, character
4. **Line 39** (data, free_format): `read (100,*) isub_con`
   - Variables: isub_con
   - Data types: integer
5. **Line 42** (data, free_format): `read (100,*) ctbl(ictbl)%conds(ii)%num_conds, (ctbl(ictbl)%conds(ii)%scon(icc), icc = 1, isub_con),    &`
   - Variables: ctbl(ictbl)%conds(ii)%num_conds, (ctbl(ictbl)%conds(ii)%scon(icc), icc = 1, isub_con), &
   - Data types: integer, unknown
6. **Line 48** (data, free_format): `read (100,*) tnum_conds`
   - Variables: tnum_conds
   - Data types: integer
7. **Line 54** (data, free_format): `read (100,*) isub_con`
   - Variables: isub_con
   - Data types: integer
8. **Line 57** (data, free_format): `read (100,*) ctbl(ictbl)%mods(imod)%con(ii)%num_conds, (ctbl(ictbl)%mods(imod)%con(ii)%scon(icc), icc = 1, isub_con),  &`
   - Variables: ctbl(ictbl)%mods(imod)%con(ii)%num_conds, (ctbl(ictbl)%mods(imod)%con(ii)%scon(icc), icc = 1, isub_con), &
   - Data types: integer, unknown

---

### File: `sat_buff_read.f90`

**Filename:** `satbuffer.str` (Unit: 107)
**Line 30:** `open (107,file="satbuffer.str")`

**Read Structure:**
1. **Line 31** (data, free_format): `read (107,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
2. **Line 33** (header, free_format): `read (107,*,iostat=eof) header`
   - Variables: header
   - Data types: character
3. **Line 36** (data, free_format): `read (107,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
4. **Line 42** (data, free_format): `read (107,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
5. **Line 44** (header, free_format): `read (107,*,iostat=eof) header`
   - Variables: header
   - Data types: character
6. **Line 51** (data, free_format): `read (107,*,iostat=eof) satbuff_db(ibuff)`
   - Variables: satbuff_db(ibuff)
   - Data types: unknown

---

### File: `proc_bsn.f90`

**Filename:** `files_out.out` (Unit: 9000)
**Line 8:** `open (9000,file="files_out.out")`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `diagnostics.out` (Unit: 9001)
**Line 11:** `open (9001,file="diagnostics.out", recl=8000)  !!ext to 8000 recl per email 8/2/21 - Kai-Uwe`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `area_calc.out` (Unit: 9004)
**Line 14:** `open (9004,file="area_calc.out", recl=8000)`

**Read Structure:** No read operations found (likely output file)

---

### File: `rte_read_nut.f90`

**Filename:** `nutrients.rte` (Unit: 105)
**Line 29:** `open (105,file="nutrients.rte")`

**Read Structure:**
1. **Line 30** (data, free_format): `read (105,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
2. **Line 32** (header, free_format): `read (105,*,iostat=eof) header`
   - Variables: header
   - Data types: character
3. **Line 35** (data, free_format): `read (105,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
4. **Line 42** (data, free_format): `read (105,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
5. **Line 44** (header, free_format): `read (105,*,iostat=eof) header`
   - Variables: header
   - Data types: character
6. **Line 48** (data, free_format): `read (105,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
7. **Line 51** (data, free_format): `read (105,*,iostat=eof) rte_nut(ich)`
   - Variables: rte_nut(ich)
   - Data types: real

---

### File: `cs_plant_read.f90`

**Filename:** `cs_plants_boron` (Unit: 107)
**Line 22:** `open(107,file="cs_plants_boron")`

**Read Structure:**
1. **Line 23** (data, free_format): `read(107,*) titldum`
   - Variables: titldum
   - Data types: unknown
2. **Line 26** (data, free_format): `read(107,*)`
   - Data types: unknown
3. **Line 27** (data, free_format): `read(107,*) bor_tol_sim !flag to simulate boron effect on plant growth`
   - Variables: bor_tol_sim !flag to simulate boron effect on plant growth
   - Data types: integer
4. **Line 28** (header, free_format): `read(107,*) header`
   - Variables: header
   - Data types: character
5. **Line 29** (header, free_format): `read(107,*) header`
   - Variables: header
   - Data types: character
6. **Line 30** (header, free_format): `read(107,*) header`
   - Variables: header
   - Data types: character
7. **Line 31** (header, free_format): `read(107,*) header`
   - Variables: header
   - Data types: character
8. **Line 35** (data, free_format): `read(107,*) plant_name,bor_stress_a(iplant),bor_stress_b(iplant)`
   - Variables: plant_name, bor_stress_a(iplant), bor_stress_b(iplant)
   - Data types: unknown, character

---

### File: `readcio_read.f90`

**Filename:** `file.cio` (Unit: 107)
**Line 18:** `open (107,file="file.cio")`

**Read Structure:**
1. **Line 19** (data, free_format): `read (107,*) titldum`
   - Variables: titldum
   - Data types: unknown
2. **Line 21** (data, free_format): `read (107,*,iostat=eof) name, in_sim`
   - Variables: name, in_sim
   - Data types: integer
3. **Line 23** (data, free_format): `read (107,*,iostat=eof) name, in_basin`
   - Variables: name, in_basin
   - Data types: integer
4. **Line 25** (data, free_format): `read (107,*,iostat=eof) name, in_cli`
   - Variables: name, in_cli
   - Data types: integer
5. **Line 27** (data, free_format): `read (107,*,iostat=eof) name, in_con`
   - Variables: name, in_con
   - Data types: integer
6. **Line 29** (data, free_format): `read (107,*,iostat=eof) name, in_cha`
   - Variables: name, in_cha
   - Data types: integer
7. **Line 31** (data, free_format): `read (107,*,iostat=eof) name, in_res`
   - Variables: name, in_res
   - Data types: integer
8. **Line 33** (data, free_format): `read (107,*,iostat=eof) name, in_ru`
   - Variables: name, in_ru
   - Data types: integer
9. **Line 35** (data, free_format): `read (107,*,iostat=eof) name, in_hru`
   - Variables: name, in_hru
   - Data types: integer
10. **Line 37** (data, free_format): `read (107,*,iostat=eof) name, in_exco`
   - Variables: name, in_exco
   - Data types: integer
11. **Line 39** (data, free_format): `read (107,*,iostat=eof) name, in_rec`
   - Variables: name, in_rec
   - Data types: integer
12. **Line 41** (data, free_format): `read (107,*,iostat=eof) name, in_delr`
   - Variables: name, in_delr
   - Data types: integer
13. **Line 43** (data, free_format): `read (107,*,iostat=eof) name, in_aqu`
   - Variables: name, in_aqu
   - Data types: integer
14. **Line 45** (data, free_format): `read (107,*,iostat=eof) name, in_herd`
   - Variables: name, in_herd
   - Data types: integer
15. **Line 47** (data, free_format): `read (107,*,iostat=eof) name, in_watrts`
   - Variables: name, in_watrts
   - Data types: integer
16. **Line 49** (data, free_format): `read (107,*,iostat=eof) name, in_link`
   - Variables: name, in_link
   - Data types: integer
17. **Line 51** (data, free_format): `read (107,*,iostat=eof) name, in_hyd`
   - Variables: name, in_hyd
   - Data types: integer
18. **Line 53** (data, free_format): `read (107,*,iostat=eof) name, in_str`
   - Variables: name, in_str
   - Data types: integer
19. **Line 55** (data, free_format): `read (107,*,iostat=eof) name, in_parmdb`
   - Variables: name, in_parmdb
   - Data types: integer
20. **Line 57** (data, free_format): `read (107,*,iostat=eof) name, in_ops`
   - Variables: name, in_ops
   - Data types: integer
21. **Line 59** (data, free_format): `read (107,*,iostat=eof) name, in_lum`
   - Variables: name, in_lum
   - Data types: integer
22. **Line 61** (data, free_format): `read (107,*,iostat=eof) name, in_chg`
   - Variables: name, in_chg
   - Data types: integer
23. **Line 63** (data, free_format): `read (107,*,iostat=eof) name, in_init`
   - Variables: name, in_init
   - Data types: integer
24. **Line 65** (data, free_format): `read (107,*,iostat=eof) name, in_sol`
   - Variables: name, in_sol
   - Data types: integer
25. **Line 67** (data, free_format): `read (107,*,iostat=eof) name, in_cond`
   - Variables: name, in_cond
   - Data types: integer

---

### File: `header_write.f90`

**Filename:** `flow_duration_curve.out` (Unit: 6000)
**Line 15:** `open (6000,file="flow_duration_curve.out", recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru-out.cal` (Unit: 4999)
**Line 24:** `open (4999,file="hru-out.cal", recl = 800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru-new.cal` (Unit: 5000)
**Line 33:** `open (5000,file="hru-new.cal", recl = 800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hydrology-cal.hyd` (Unit: 5001)
**Line 39:** `open (5001,file="hydrology-cal.hyd", recl = 800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_aqu_day.txt` (Unit: 2090)
**Line 59:** `open (2090,file="basin_aqu_day.txt", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_aqu_day.csv` (Unit: 2094)
**Line 65:** `open (2094,file="basin_aqu_day.csv", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_aqu_mon.txt` (Unit: 2091)
**Line 74:** `open (2091,file="basin_aqu_mon.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_aqu_mon.csv` (Unit: 2095)
**Line 80:** `open (2095,file="basin_aqu_mon.csv",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_aqu_yr.txt` (Unit: 2092)
**Line 89:** `open (2092,file="basin_aqu_yr.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_aqu_yr.csv` (Unit: 2096)
**Line 95:** `open (2096,file="basin_aqu_yr.csv",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_aqu_aa.txt` (Unit: 2093)
**Line 104:** `open (2093,file="basin_aqu_aa.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_aqu_aa.csv` (Unit: 2097)
**Line 110:** `open (2097,file="basin_aqu_aa.csv",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_res_day.txt` (Unit: 2100)
**Line 121:** `open (2100,file="basin_res_day.txt", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_res_day.csv` (Unit: 2104)
**Line 127:** `open (2104,file="basin_res_day.csv", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_res_mon.txt` (Unit: 2101)
**Line 136:** `open (2101,file="basin_res_mon.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_res_mon.csv` (Unit: 2105)
**Line 142:** `open (2105,file="basin_res_mon.csv",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_res_yr.txt` (Unit: 2102)
**Line 151:** `open (2102,file="basin_res_yr.txt", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_res_yr.csv` (Unit: 2106)
**Line 157:** `open (2106,file="basin_res_yr.csv", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_res_aa.txt` (Unit: 2103)
**Line 166:** `open (2103,file="basin_res_aa.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_res_aa.csv` (Unit: 2107)
**Line 172:** `open (2107,file="basin_res_aa.csv",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `recall_day.txt` (Unit: 4600)
**Line 183:** `open (4600,file="recall_day.txt", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `recall_day.csv` (Unit: 4604)
**Line 189:** `open (4604,file="recall_day.csv", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `recall_mon.txt` (Unit: 4601)
**Line 198:** `open (4601,file="recall_mon.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `recall_mon.csv` (Unit: 4605)
**Line 204:** `open (4605,file="recall_mon.csv",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `recall_yr.txt` (Unit: 4602)
**Line 213:** `open (4602,file="recall_yr.txt", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `recall_yr.csv` (Unit: 4606)
**Line 219:** `open (4606,file="recall_yr.csv", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `recall_aa.txt` (Unit: 4603)
**Line 228:** `open (4603,file="recall_aa.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `recall_aa.csv` (Unit: 4607)
**Line 234:** `open (4607,file="recall_aa.csv",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_cha_day.txt` (Unit: 2110)
**Line 246:** `open (2110,file="basin_cha_day.txt", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_cha_day.csv` (Unit: 2114)
**Line 252:** `open (2114,file="basin_cha_day.csv", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_cha_mon.txt` (Unit: 2111)
**Line 261:** `open (2111,file="basin_cha_mon.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_cha_mon.csv` (Unit: 2115)
**Line 267:** `open (2115,file="basin_cha_mon.csv",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_cha_yr.txt` (Unit: 2112)
**Line 276:** `open (2112,file="basin_cha_yr.txt", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_cha_yr.csv` (Unit: 2116)
**Line 282:** `open (2116,file="basin_cha_yr.csv", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_cha_aa.txt` (Unit: 2113)
**Line 291:** `open (2113,file="basin_cha_aa.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_cha_aa.csv` (Unit: 2117)
**Line 297:** `open (2117,file="basin_cha_aa.csv",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_sd_cha_day.txt` (Unit: 4900)
**Line 308:** `open (4900,file="basin_sd_cha_day.txt", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_sd_cha_day.csv` (Unit: 4904)
**Line 314:** `open (4904,file="basin_sd_cha_day.csv", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_sd_cha_mon.txt` (Unit: 4901)
**Line 323:** `open (4901,file="basin_sd_cha_mon.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_sd_cha_mon.csv` (Unit: 4905)
**Line 329:** `open (4905,file="basin_sd_cha_mon.csv",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_sd_cha_yr.txt` (Unit: 4902)
**Line 338:** `open (4902,file="basin_sd_cha_yr.txt", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_sd_cha_yr.csv` (Unit: 4906)
**Line 344:** `open (4906,file="basin_sd_cha_yr.csv", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_sd_cha_aa.txt` (Unit: 4903)
**Line 353:** `open (4903,file="basin_sd_cha_aa.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_sd_cha_aa.csv` (Unit: 4907)
**Line 359:** `open (4907,file="basin_sd_cha_aa.csv",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_sd_chamorph_day.txt` (Unit: 2120)
**Line 371:** `open (2120,file="basin_sd_chamorph_day.txt", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_sd_chamorph_day.csv` (Unit: 2124)
**Line 377:** `open (2124,file="basin_sd_chamorph_day.csv", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_sd_chamorph_mon.txt` (Unit: 2121)
**Line 386:** `open (2121,file="basin_sd_chamorph_mon.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_sd_chamorph_mon.csv` (Unit: 2125)
**Line 392:** `open (2125,file="basin_sd_chamorph_mon.csv",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_sd_chamorph_yr.txt` (Unit: 2122)
**Line 401:** `open (2122,file="basin_sd_chamorph_yr.txt", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_sd_chamorph_yr.csv` (Unit: 2126)
**Line 407:** `open (2126,file="basin_sd_chamorph_yr.csv", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_sd_chamorph_aa.txt` (Unit: 2123)
**Line 416:** `open (2123,file="basin_sd_chamorph_aa.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_sd_chamorph_aa.csv` (Unit: 2127)
**Line 422:** `open (2127,file="basin_sd_chamorph_aa.csv",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_sd_chanbud_day.txt` (Unit: 2128)
**Line 433:** `open (2128,file="basin_sd_chanbud_day.txt", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_sd_chanbud_day.csv` (Unit: 2132)
**Line 439:** `open (2132,file="basin_sd_chanbud_day.csv", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_sd_chanbud_mon.txt` (Unit: 2129)
**Line 448:** `open (2129,file="basin_sd_chanbud_mon.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_sd_chanbud_mon.csv` (Unit: 2133)
**Line 454:** `open (2133,file="basin_sd_chanbud_mon.csv",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_sd_chanbud_yr.txt` (Unit: 2130)
**Line 463:** `open (2130,file="basin_sd_chanbud_yr.txt", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_sd_chanbud_yr.csv` (Unit: 2134)
**Line 469:** `open (2134,file="basin_sd_chanbud_yr.csv", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_sd_chanbud_aa.txt` (Unit: 2131)
**Line 478:** `open (2131,file="basin_sd_chanbud_aa.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_sd_chanbud_aa.csv` (Unit: 2135)
**Line 484:** `open (2135,file="basin_sd_chanbud_aa.csv",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_psc_day.txt` (Unit: 4500)
**Line 496:** `open (4500,file="basin_psc_day.txt", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_psc_day.csv` (Unit: 4504)
**Line 502:** `open (4504,file="basin_psc_day.csv", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_psc_mon.txt` (Unit: 4501)
**Line 511:** `open (4501,file="basin_psc_mon.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_psc_mon.csv` (Unit: 4505)
**Line 517:** `open (4505,file="basin_psc_mon.csv",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_psc_yr.txt` (Unit: 4502)
**Line 526:** `open (4502,file="basin_psc_yr.txt", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_psc_yr.csv` (Unit: 4506)
**Line 532:** `open (4506,file="basin_psc_yr.csv", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_psc_aa.txt` (Unit: 4503)
**Line 541:** `open (4503,file="basin_psc_aa.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_psc_aa.csv` (Unit: 4507)
**Line 547:** `open (4507,file="basin_psc_aa.csv",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `ru_day.txt` (Unit: 2600)
**Line 559:** `open (2600,file="ru_day.txt", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `ru_day.csv` (Unit: 2604)
**Line 565:** `open (2604,file="ru_day.csv", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `ru_mon.txt` (Unit: 2601)
**Line 574:** `open (2601,file="ru_mon.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `ru_mon.csv` (Unit: 2605)
**Line 580:** `open (2605,file="ru_mon.csv",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `ru_yr.txt` (Unit: 2602)
**Line 589:** `open (2602,file="ru_yr.txt", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `ru_yr.csv` (Unit: 2606)
**Line 595:** `open (2606,file="ru_yr.csv", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `ru_aa.txt` (Unit: 2603)
**Line 604:** `open (2603,file="ru_aa.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `ru_aa.csv` (Unit: 2607)
**Line 610:** `open (2607,file="ru_aa.csv",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

### File: `header_mgt.f90`

**Filename:** `mgt_out.txt` (Unit: 2612)
**Line 8:** `open (2612,file="mgt_out.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

### File: `cal_cond_read.f90`

**Filename:** `scen_dtl.upd` (Unit: 107)
**Line 43:** `open (107,file="scen_dtl.upd")`

**Read Structure:**
1. **Line 44** (data, free_format): `read (107,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
2. **Line 46** (data, free_format): `read (107,*,iostat=eof) num_dtls`
   - Variables: num_dtls
   - Data types: integer
3. **Line 52** (header, free_format): `read (107,*,iostat=eof) header`
   - Variables: header
   - Data types: character
4. **Line 56** (data, free_format): `read (107,*,iostat=eof) upd_cond(i)%max_hits, upd_cond(i)%typ, upd_cond(i)%dtbl`
   - Variables: upd_cond(i)%max_hits, upd_cond(i)%typ, upd_cond(i)%dtbl
   - Data types: unknown

---

### File: `manure_parm_read.f90`

**Filename:** `manure.frt` (Unit: 107)
**Line 27:** `open (107,file="manure.frt")`

**Read Structure:**
1. **Line 28** (data, free_format): `read (107,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
2. **Line 30** (header, free_format): `read (107,*,iostat=eof) header`
   - Variables: header
   - Data types: character
3. **Line 33** (data, free_format): `read (107,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
4. **Line 41** (data, free_format): `read (107,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
5. **Line 43** (header, free_format): `read (107,*,iostat=eof) header`
   - Variables: header
   - Data types: character
6. **Line 47** (data, free_format): `read (107,*,iostat=eof) manure_db(it)`
   - Variables: manure_db(it)
   - Data types: integer

---

### File: `salt_hru_read.f90`

**Filename:** `salt_hru.ini` (Unit: 107)
**Line 23:** `open (107,file='salt_hru.ini')`

**Read Structure:**
1. **Line 24** (data, free_format): `read (107,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
2. **Line 26** (header, free_format): `read (107,*,iostat=eof) header`
   - Variables: header
   - Data types: character
3. **Line 28** (header, free_format): `read (107,*,iostat=eof) header`
   - Variables: header
   - Data types: character
4. **Line 30** (header, free_format): `read (107,*,iostat=eof) header`
   - Variables: header
   - Data types: character
5. **Line 32** (header, free_format): `read (107,*,iostat=eof) header`
   - Variables: header
   - Data types: character
6. **Line 37** (data, free_format): `read (107,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
7. **Line 39** (data, free_format): `read (107,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
8. **Line 41** (data, free_format): `read (107,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
9. **Line 55** (data, free_format): `read (107,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
10. **Line 57** (header, free_format): `read (107,*,iostat=eof) header`
   - Variables: header
   - Data types: character
11. **Line 59** (header, free_format): `read (107,*,iostat=eof) header`
   - Variables: header
   - Data types: character
12. **Line 61** (header, free_format): `read (107,*,iostat=eof) header`
   - Variables: header
   - Data types: character
13. **Line 63** (header, free_format): `read (107,*,iostat=eof) header`
   - Variables: header
   - Data types: character
14. **Line 67** (data, free_format): `read (107,*,iostat=eof) salt_soil_ini(isalti)%name`
   - Variables: salt_soil_ini(isalti)%name
   - Data types: character
15. **Line 69** (data, free_format): `read (107,*,iostat=eof) salt_soil_ini(isalti)%soil`
   - Variables: salt_soil_ini(isalti)%soil
   - Data types: unknown
16. **Line 71** (data, free_format): `read (107,*,iostat=eof) salt_soil_ini(isalti)%plt`
   - Variables: salt_soil_ini(isalti)%plt
   - Data types: unknown

---

### File: `res_read_csdb.f90`

**Filename:** `cs_res` (Unit: 105)
**Line 29:** `open (105,file="cs_res")`

**Read Structure:**
1. **Line 30** (data, free_format): `read (105,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
2. **Line 31** (data, free_format): `read (105,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
3. **Line 33** (data, free_format): `read(105,*)`
   - Data types: unknown
4. **Line 37** (header, free_format): `read (105,*,iostat=eof) header`
   - Variables: header
   - Data types: character
5. **Line 40** (data, free_format): `read (105,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
6. **Line 49** (data, free_format): `read (105,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
7. **Line 51** (data, free_format): `read (105,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
8. **Line 53** (data, free_format): `read(105,*)`
   - Data types: unknown
9. **Line 55** (header, free_format): `read (105,*,iostat=eof) header`
   - Variables: header
   - Data types: character
10. **Line 59** (data, free_format): `read (105,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
11. **Line 62** (data, free_format): `read (105,*,iostat=eof) res_cs_data(ires)`
   - Variables: res_cs_data(ires)
   - Data types: real

---

### File: `soil_plant_init_cs.f90`

**Filename:** `soil_plant.ini_cs` (Unit: 107)
**Line 21:** `open (107,file="soil_plant.ini_cs")`

**Read Structure:**
1. **Line 22** (data, free_format): `read (107,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
2. **Line 23** (header, free_format): `read (107,*,iostat=eof) header`
   - Variables: header
   - Data types: character
3. **Line 26** (data, free_format): `read (107,*,iostat=eof) sol_plt_ini_cs(ii)%name,sol_plt_ini_cs(ii)%pestc,sol_plt_ini_cs(ii)%pathc, &`
   - Variables: sol_plt_ini_cs(ii)%name, sol_plt_ini_cs(ii)%pestc, sol_plt_ini_cs(ii)%pathc, &
   - Data types: unknown, character

---

### File: `treat_read_om.f90`

**Filename:** `treatment.trt` (Unit: 107)
**Line 27:** `open (107,file="treatment.trt")`

**Read Structure:**
1. **Line 28** (data, free_format): `read (107,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
2. **Line 30** (data, free_format): `read (107,*,iostat=eof) imax`
   - Variables: imax
   - Data types: integer
3. **Line 32** (header, free_format): `read (107,*,iostat=eof) header`
   - Variables: header
   - Data types: character
4. **Line 34** (header, free_format): `read (107,*,iostat=eof) header`
   - Variables: header
   - Data types: character
5. **Line 44** (data, free_format): `read (107,*,iostat=eof) trt_om_name(ii), trt(ii)`
   - Variables: trt_om_name(ii), trt(ii)
   - Data types: unknown, character

---

### File: `ch_read_init_cs.f90`

**Filename:** `initial.cha_cs` (Unit: 105)
**Line 27:** `open (105,file="initial.cha_cs")`

**Read Structure:**
1. **Line 28** (data, free_format): `read (105,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
2. **Line 30** (header, free_format): `read (105,*,iostat=eof) header`
   - Variables: header
   - Data types: character
3. **Line 33** (data, free_format): `read (105,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
4. **Line 42** (data, free_format): `read (105,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
5. **Line 44** (header, free_format): `read (105,*,iostat=eof) header`
   - Variables: header
   - Data types: character
6. **Line 48** (data, free_format): `read (105,*,iostat=eof) ch_init_cs(ich)`
   - Variables: ch_init_cs(ich)
   - Data types: character

---

### File: `carbon_read.f90`

**Filename:** `basins_carbon.tes` (Unit: 104)
**Line 22:** `open (104,file='basins_carbon.tes')`

**Read Structure:**
1. **Line 23** (data, free_format): `read (104,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
2. **Line 25** (header, free_format): `read (104,*,iostat=eof) header`
   - Variables: header
   - Data types: character
3. **Line 28** (data, free_format): `read (104,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
4. **Line 34** (data, free_format): `read (104,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
5. **Line 36** (header, free_format): `read (104,*,iostat=eof) header`
   - Variables: header
   - Data types: character
6. **Line 40** (data, free_format): `read (104,*,iostat=eof) cbn_tes`
   - Variables: cbn_tes
   - Data types: character

---

### File: `basin_read_cc.f90`

**Filename:** `pet.cli` (Unit: 140)
**Line 31:** `open (140,file = 'pet.cli')`

**Read Structure:**
1. **Line 33** (data, free_format): `read (140,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
2. **Line 35** (header, free_format): `read (140,*,iostat=eof) header`
   - Variables: header
   - Data types: character
3. **Line 37** (data, free_format): `read (140,*,iostat = eof) titldum`
   - Variables: titldum
   - Data types: unknown

---

### File: `cs_uptake_read.f90`

**Filename:** `cs_uptake` (Unit: 5054)
**Line 39:** `open(5054,file='cs_uptake')`

**Read Structure:**
1. **Line 40** (header, free_format): `read(5054,*) header`
   - Variables: header
   - Data types: character
2. **Line 41** (header, free_format): `read(5054,*) header`
   - Variables: header
   - Data types: character
3. **Line 42** (header, free_format): `read(5054,*) header`
   - Variables: header
   - Data types: character
4. **Line 50** (data, free_format): `read(5054,*) name,(cs_uptake_kg(i,j),j=1,cs_db%num_cs)`
   - Variables: name, (cs_uptake_kg(i, j), j=1, cs_db%num_cs)
   - Data types: integer, unknown

---

### File: `header_cs.f90`

**Filename:** `hydin_pests_day.txt` (Unit: 2708)
**Line 16:** `open (2708,file="hydin_pests_day.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hydin_pests_day.csv` (Unit: 2724)
**Line 21:** `open (2724,file="hydin_pests_day.csv",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hydin_paths_day.txt` (Unit: 2712)
**Line 29:** `open (2712,file="hydin_paths_day.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hydin_paths_day.csv` (Unit: 2728)
**Line 34:** `open (2728,file="hydin_paths_day.csv",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hydin_metals_day.txt` (Unit: 2716)
**Line 42:** `open (2716,file="hydin_metals_day.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hydin_metals_day.csv` (Unit: 2732)
**Line 47:** `open (2732,file="hydin_metals_day.csv",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hydin_salts_day.txt` (Unit: 2720)
**Line 55:** `open (2720,file="hydin_salts_day.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hydin_salts_day.csv` (Unit: 2736)
**Line 60:** `open (2736,file="hydin_salts_day.csv",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hydin_pests_mon.txt` (Unit: 2709)
**Line 71:** `open (2709,file="hydin_pests_mon.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hydin_pests_mon.csv` (Unit: 2725)
**Line 76:** `open (2725,file="hydin_pests_mon.csv",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hydin_paths_mon.txt` (Unit: 2713)
**Line 85:** `open (2713,file="hydin_paths_mon.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hydin_paths_mon.csv` (Unit: 2729)
**Line 90:** `open (2729,file="hydin_paths_mon.csv",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hydin_metals_mon.txt` (Unit: 2717)
**Line 98:** `open (2717,file="hydin_metals_mon.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hydin_metals_mon.csv` (Unit: 2733)
**Line 103:** `open (2733,file="hydin_metals_mon.csv",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hydin_salts_mon.txt` (Unit: 2721)
**Line 111:** `open (2721,file="hydin_salts_mon.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hydin_salts_mon.csv` (Unit: 2737)
**Line 116:** `open (2737,file="hydin_salts_mon.csv",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hydin_pests_yr.txt` (Unit: 2710)
**Line 128:** `open (2710,file="hydin_pests_yr.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hydin_pests_yr.csv` (Unit: 2726)
**Line 133:** `open (2726,file="hydin_pests_yr.csv",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hydin_paths_yr.txt` (Unit: 2714)
**Line 141:** `open (2714,file="hydin_paths_yr.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hydin_paths_yr.csv` (Unit: 2730)
**Line 146:** `open (2730,file="hydin_paths_yr.csv",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hydin_metals_yr.txt` (Unit: 2718)
**Line 154:** `open (2718,file="hydin_metals_yr.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hydin_metals_yr.csv` (Unit: 2734)
**Line 159:** `open (2734,file="hydin_metals_yr.csv",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hydin_salts_yr.txt` (Unit: 2722)
**Line 167:** `open (2722,file="hydin_salts_yr.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hydin_salts_yr.csv` (Unit: 2738)
**Line 172:** `open (2738,file="hydin_salts_yr.csv",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hydin_pests_aa.txt` (Unit: 2711)
**Line 183:** `open (2711,file="hydin_pests_aa.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hydin_pests_aa.csv` (Unit: 2727)
**Line 188:** `open (2727,file="hydin_pests_aa.csv",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hydin_paths_aa.txt` (Unit: 2715)
**Line 196:** `open (2715,file="hydin_paths_aa.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hydin_paths_aa.csv` (Unit: 2731)
**Line 201:** `open (2731,file="hydin_paths_aa.csv",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hydin_metals_aa.txt` (Unit: 2719)
**Line 209:** `open (2719,file="hydin_metals_aa.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hydin_metals_aa.csv` (Unit: 2735)
**Line 214:** `open (2735,file="hydin_metals_aa.csv",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hydin_salts_aa.txt` (Unit: 2723)
**Line 222:** `open (2723,file="hydin_salts_aa.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hydin_salts_aa.csv` (Unit: 2739)
**Line 227:** `open (2739,file="hydin_salts_aa.csv",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hydout_pests_day.txt` (Unit: 2740)
**Line 238:** `open (2740,file="hydout_pests_day.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hydout_pests_day.csv` (Unit: 2756)
**Line 243:** `open (2756,file="hydout_pests_day.csv")`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hydout_paths_day.txt` (Unit: 2744)
**Line 251:** `open (2744,file="hydout_paths_day.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hydout_paths_day.csv` (Unit: 2760)
**Line 256:** `open (2760,file="hydout_paths_day.csv")`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hydout_metals_day.txt` (Unit: 2748)
**Line 264:** `open (2748,file="hydout_metals_day.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hydout_metals_day.csv` (Unit: 2764)
**Line 269:** `open (2764,file="hydout_metals_day.csv")`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hydout_salts_day.txt` (Unit: 2752)
**Line 277:** `open (2752,file="hydout_salts_day.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hydout_salts_day.csv` (Unit: 2768)
**Line 282:** `open (2768,file="hydout_salts_day.csv")`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hydout_pests_mon.txt` (Unit: 2741)
**Line 293:** `open (2741,file="hydout_pests_mon.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hydout_pests_mon.csv` (Unit: 2757)
**Line 298:** `open (2757,file="hydout_pests_mon.csv",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hydout_paths_mon.txt` (Unit: 2745)
**Line 306:** `open (2745,file="hydout_paths_mon.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hydout_paths_mon.csv` (Unit: 2761)
**Line 311:** `open (2761,file="hydout_paths_mon.csv")`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hydout_metals_mon.txt` (Unit: 2749)
**Line 319:** `open (2749,file="hydout_metals_mon.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hydout_metals_mon.csv` (Unit: 2765)
**Line 324:** `open (2765,file="hydout_metals_mon.csv")`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hydout_salts_mon.txt` (Unit: 2753)
**Line 332:** `open (2753,file="hydout_salts_mon.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hydout_salts_mon.csv` (Unit: 2769)
**Line 337:** `open (2769,file="hydout_salts_mon.csv",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hydout_pests_yr.txt` (Unit: 2742)
**Line 349:** `open (2742,file="hydout_pests_yr.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hydout_pests_yr.csv` (Unit: 2758)
**Line 354:** `open (2758,file="hydout_pests_yr.csv",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hydout_paths_yr.txt` (Unit: 2746)
**Line 362:** `open (2746,file="hydout_paths_yr.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hydout_paths_yr.csv` (Unit: 2762)
**Line 367:** `open (2762,file="hydout_paths_yr.csv",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hydout_metals_yr.txt` (Unit: 2750)
**Line 375:** `open (2750,file="hydout_metals_yr.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hydout_metals_yr.csv` (Unit: 2766)
**Line 380:** `open (2766,file="hydout_metals_yr.csv",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hydout_salts_yr.txt` (Unit: 2754)
**Line 388:** `open (2754,file="hydout_salts_yr.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hydout_salts_yr.csv` (Unit: 2770)
**Line 393:** `open (2770,file="hydout_salts_yr.csv",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hydout_pests_aa.txt` (Unit: 2743)
**Line 404:** `open (2743,file="hydout_pests_aa.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hydout_pests_aa.csv` (Unit: 2759)
**Line 409:** `open (2759,file="hydout_pests_aa.csv",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hydout_paths_aa.txt` (Unit: 2747)
**Line 417:** `open (2747,file="hydout_paths_aa.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hydout_paths_aa.csv` (Unit: 2763)
**Line 422:** `open (2763,file="hydout_paths_aa.csv",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hydout_metals_aa.txt` (Unit: 2751)
**Line 430:** `open (2751,file="hydout_metals_aa.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hydout_metals_aa.csv` (Unit: 2767)
**Line 435:** `open (2767,file="hydout_metals_aa.csv",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hydout_salts_aa.txt` (Unit: 2755)
**Line 443:** `open (2755,file="hydout_salts_aa.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hydout_salts_aa.csv` (Unit: 2771)
**Line 448:** `open (2771,file="hydout_salts_aa.csv",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

### File: `header_hyd.f90`

**Filename:** `hydcon.out` (Unit: 7000)
**Line 9:** `open (7000,file="hydcon.out")`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hydcon.csv` (Unit: 7001)
**Line 12:** `open (7001,file="hydcon.csv")`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hydout_day.txt` (Unit: 2580)
**Line 19:** `open (2580,file="hydout_day.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hydout_day.csv` (Unit: 2584)
**Line 25:** `open (2584,file="hydout_day.csv",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hydout_mon.txt` (Unit: 2581)
**Line 34:** `open (2581,file="hydout_mon.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hydout_mon.csv` (Unit: 2585)
**Line 40:** `open (2585,file="hydout_mon.csv",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hydout_yr.txt` (Unit: 2582)
**Line 49:** `open (2582,file="hydout_yr.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hydout_yr.csv` (Unit: 2586)
**Line 55:** `open (2586,file="hydout_yr.csv",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hydout_aa.txt` (Unit: 2583)
**Line 64:** `open (2583,file="hydout_aa.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hydout_aa.csv` (Unit: 2587)
**Line 70:** `open (2587,file="hydout_aa.csv",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hydin_day.txt` (Unit: 2560)
**Line 81:** `open (2560,file="hydin_day.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hydin_day.csv` (Unit: 2564)
**Line 87:** `open (2564,file="hydin_day.csv",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hydin_mon.txt` (Unit: 2561)
**Line 96:** `open (2561,file="hydin_mon.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hydin_mon.csv` (Unit: 2565)
**Line 102:** `open (2565,file="hydin_mon.csv",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hydin_yr.txt` (Unit: 2562)
**Line 111:** `open (2562,file="hydin_yr.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hydin_yr.csv` (Unit: 2566)
**Line 117:** `open (2566,file="hydin_yr.csv",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hydin_aa.txt` (Unit: 2563)
**Line 126:** `open (2563,file="hydin_aa.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hydin_aa.csv` (Unit: 2567)
**Line 132:** `open (2567,file="hydin_aa.csv",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `deposition_day.txt` (Unit: 2700)
**Line 143:** `open (2700,file="deposition_day.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `deposition_day.csv` (Unit: 2704)
**Line 149:** `open (2704,file="deposition_day.csv",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `deposition_mon.txt` (Unit: 2701)
**Line 159:** `open (2701,file="deposition_mon.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `deposition_mon.csv` (Unit: 2705)
**Line 165:** `open (2705,file="deposition_mon.csv",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `deposition_yr.txt` (Unit: 2702)
**Line 175:** `open (2702,file="deposition_yr.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `deposition_yr.csv` (Unit: 2706)
**Line 181:** `open (2706,file="deposition_yr.csv",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `deposition_aa.txt` (Unit: 2703)
**Line 191:** `open (2703,file="deposition_aa.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `deposition_aa.csv` (Unit: 2707)
**Line 197:** `open (2707,file="deposition_aa.csv",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

### File: `pl_write_parms_cal.f90`

**Filename:** `plant_parms.cal` (Unit: 107)
**Line 20:** `open (107,file="plant_parms.cal",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

### File: `salt_irr_read.f90`

**Filename:** `salt_irrigation` (Unit: 107)
**Line 23:** `open (107,file="salt_irrigation")`

**Read Structure:**
1. **Line 24** (data, free_format): `read (107,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
2. **Line 26** (header, free_format): `read (107,*,iostat=eof) header`
   - Variables: header
   - Data types: character
3. **Line 33** (data, free_format): `read (107,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
4. **Line 46** (data, free_format): `read (107,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
5. **Line 48** (header, free_format): `read (107,*,iostat=eof) header`
   - Variables: header
   - Data types: character
6. **Line 51** (data, free_format): `read (107,*,iostat=eof) salt_water_irr(isalti)%name,salt_water_irr(isalti)%water`
   - Variables: salt_water_irr(isalti)%name, salt_water_irr(isalti)%water
   - Data types: unknown, character

---

### File: `salt_cha_read.f90`

**Filename:** `salt_channel.ini` (Unit: 107)
**Line 27:** `open (107,file="salt_channel.ini")`

**Read Structure:**
1. **Line 28** (data, free_format): `read (107,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
2. **Line 30** (header, free_format): `read (107,*,iostat=eof) header`
   - Variables: header
   - Data types: character
3. **Line 34** (data, free_format): `read (107,*,iostat=eof) titldum   !name and concentrations`
   - Variables: titldum   !name and concentrations
   - Data types: character
4. **Line 48** (data, free_format): `read (107,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
5. **Line 51** (header, free_format): `read (107,*,iostat=eof) header`
   - Variables: header
   - Data types: character
6. **Line 54** (data, free_format): `read (107,*,iostat=eof) salt_cha_ini(isalti)%name,salt_cha_ini(isalti)%conc`
   - Variables: salt_cha_ini(isalti)%name, salt_cha_ini(isalti)%conc
   - Data types: unknown, character

---

### File: `recall_read.f90`

**Filename:** `pest.com` (Unit: 107)
**Line 205:** `open (107,file="pest.com")`

**Read Structure:**
1. **Line 206** (data, free_format): `read (107,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
2. **Line 208** (header, free_format): `read (107,*,iostat=eof) header`
   - Variables: header
   - Data types: character
3. **Line 212** (data, free_format): `read (107,*,iostat=eof) i`
   - Variables: i
   - Data types: integer
4. **Line 219** (data, free_format): `read (107,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
5. **Line 221** (header, free_format): `read (107,*,iostat=eof) header`
   - Variables: header
   - Data types: character
6. **Line 225** (data, free_format): `read (107,*,iostat=eof) ipestcom_db   !pointer to pestcom_db - fix***`
   - Variables: ipestcom_db   !pointer to pestcom_db - fix***
   - Data types: integer
7. **Line 229** (data, free_format): `read (107,*,iostat=eof) i`
   - Variables: i
   - Data types: integer
8. **Line 232** (data, free_format): `read (107,*,iostat = eof) k, rec_pest(i)%name, rec_pest(i)%typ, rec_pest(i)%filename`
   - Variables: k, rec_pest(i)%name, rec_pest(i)%typ, rec_pest(i)%filename
   - Data types: integer, real

---

### File: `salt_urban_read.f90`

**Filename:** `salt_urban` (Unit: 5054)
**Line 28:** `open(5054,file='salt_urban')`

**Read Structure:**
1. **Line 29** (header, free_format): `read(5054,*) header`
   - Variables: header
   - Data types: character
2. **Line 30** (header, free_format): `read(5054,*) header`
   - Variables: header
   - Data types: character
3. **Line 37** (data, free_format): `read (5054,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
4. **Line 48** (header, free_format): `read(5054,*) header`
   - Variables: header
   - Data types: character
5. **Line 49** (header, free_format): `read(5054,*) header`
   - Variables: header
   - Data types: character
6. **Line 51** (data, free_format): `read(5054,*) urb_type`
   - Variables: urb_type
   - Data types: character
7. **Line 56** (data, free_format): `read(5054,*) urb_type,(salt_urban_conc(iu,isalt),isalt=1,cs_db%num_salts)`
   - Variables: urb_type, (salt_urban_conc(iu, isalt), isalt=1, cs_db%num_salts)
   - Data types: integer, unknown, character

---

### File: `swift_output.f90`

**Filename:** `SWIFT/file_cio.swf` (Unit: 107)
**Line 60:** `open (107,file="SWIFT/file_cio.swf",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `SWIFT/precip.swf` (Unit: 107)
**Line 89:** `open (107,file="SWIFT/precip.swf",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `SWIFT/hru_dat.swf` (Unit: 107)
**Line 102:** `open (107,file="SWIFT/hru_dat.swf",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `SWIFT/hru_exco.swf` (Unit: 107)
**Line 114:** `open (107,file="SWIFT/hru_exco.swf",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `SWIFT/hru_wet.swf` (Unit: 107)
**Line 152:** `open (107,file="SWIFT/hru_wet.swf",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `SWIFT/chan_dat.swf` (Unit: 107)
**Line 172:** `open (107,file="SWIFT/chan_dat.swf",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `SWIFT/chan_dr.swf` (Unit: 107)
**Line 184:** `open (107,file="SWIFT/chan_dr.swf",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `SWIFT/aqu_dr.swf` (Unit: 107)
**Line 204:** `open (107,file="SWIFT/aqu_dr.swf",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `SWIFT/res_dat.swf` (Unit: 107)
**Line 218:** `open (107,file="SWIFT/res_dat.swf",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `SWIFT/res_dr.swf` (Unit: 107)
**Line 230:** `open (107,file="SWIFT/res_dr.swf",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `SWIFT/recall.swf` (Unit: 107)
**Line 244:** `open (107,file="SWIFT/recall.swf",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `SWIFT/` (Unit: 108)
**Line 250:** `open (108,file="SWIFT/" // trim(adjustl(recall(irec)%name)),recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `SWIFT/object_prt.swf` (Unit: 108)
**Line 265:** `open (108,file="SWIFT/object_prt.swf",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

### File: `gwflow_chan_read.f90`

**Filename:** `gwflow.chancells` (Unit: 1280)
**Line 35:** `open(1280,file='gwflow.chancells')`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `gwflow.con` (Unit: 1281)
**Line 36:** `open(1281,file='gwflow.con')`

**Read Structure:** No read operations found (likely output file)

---

### File: `cs_urban_read.f90`

**Filename:** `cs_urban` (Unit: 5054)
**Line 28:** `open(5054,file='cs_urban')`

**Read Structure:**
1. **Line 29** (header, free_format): `read(5054,*) header`
   - Variables: header
   - Data types: character
2. **Line 30** (header, free_format): `read(5054,*) header`
   - Variables: header
   - Data types: character
3. **Line 37** (data, free_format): `read (5054,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
4. **Line 48** (header, free_format): `read(5054,*) header`
   - Variables: header
   - Data types: character
5. **Line 49** (header, free_format): `read(5054,*) header`
   - Variables: header
   - Data types: character
6. **Line 51** (data, free_format): `read(5054,*) urb_type`
   - Variables: urb_type
   - Data types: character
7. **Line 56** (data, free_format): `read(5054,*) urb_type,(cs_urban_conc(iu,ics),ics=1,cs_db%num_cs)`
   - Variables: urb_type, (cs_urban_conc(iu, ics), ics=1, cs_db%num_cs)
   - Data types: integer, unknown, character

---

### File: `sd_hydsed_read.f90`

**Filename:** `sed_nut.cha` (Unit: 1)
**Line 74:** `open (1,file="sed_nut.cha")`

**Read Structure:**
1. **Line 75** (data, free_format): `read (1,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
2. **Line 77** (header, free_format): `read (1,*,iostat=eof) header`
   - Variables: header
   - Data types: character
3. **Line 80** (data, free_format): `read (1,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
4. **Line 90** (data, free_format): `read (1,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
5. **Line 92** (header, free_format): `read (1,*,iostat=eof) header`
   - Variables: header
   - Data types: character
6. **Line 96** (data, free_format): `read (1,*,iostat=eof) sd_chd1(idb)`
   - Variables: sd_chd1(idb)
   - Data types: integer

---

### File: `header_lu_change.f90`

**Filename:** `lu_change_out.txt` (Unit: 3612)
**Line 7:** `open (3612,file="lu_change_out.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

### File: `wet_read_hyd.f90`

**Filename:** `gwflow.wetland` (Unit: in_wet_cell)
**Line 72:** `open(in_wet_cell,file='gwflow.wetland')`

**Read Structure:**
1. **Line 73** (header, free_format): `read(in_wet_cell,*) header`
   - Variables: header
   - Data types: character
2. **Line 74** (header, free_format): `read(in_wet_cell,*) header`
   - Variables: header
   - Data types: character
3. **Line 75** (header, free_format): `read(in_wet_cell,*) header`
   - Variables: header
   - Data types: character
4. **Line 76** (header, free_format): `read(in_wet_cell,*) header`
   - Variables: header
   - Data types: character
5. **Line 78** (header, free_format): `read(in_wet_cell,*) header`
   - Variables: header
   - Data types: character
6. **Line 80** (data, free_format): `read(in_wet_cell,*) dum1,wet_thick(ires)`
   - Variables: dum1, wet_thick(ires)
   - Data types: unknown, real

---

### File: `basin_read_objs.f90`

**Filename:** `gwflow.chancells` (Unit: 107)
**Line 52:** `open(107,file='gwflow.chancells')`

**Read Structure:**
1. **Line 53** (header, free_format): `read(107,*,iostat=eof) header`
   - Variables: header
   - Data types: character
2. **Line 55** (data, free_format): `read(107,*,iostat=eof)`
   - Data types: unknown
3. **Line 56** (header, free_format): `read(107,*,iostat=eof) header`
   - Variables: header
   - Data types: character
4. **Line 62** (data, free_format): `read (107,*,iostat=eof) riv_id`
   - Variables: riv_id
   - Data types: integer

---

**Filename:** `gwflow_record` (Unit: out_gw)
**Line 85:** `open(out_gw,file='gwflow_record')`

**Read Structure:** No read operations found (likely output file)

---

### File: `salt_uptake_read.f90`

**Filename:** `salt_uptake` (Unit: 5054)
**Line 39:** `open(5054,file='salt_uptake')`

**Read Structure:**
1. **Line 40** (header, free_format): `read(5054,*) header`
   - Variables: header
   - Data types: character
2. **Line 41** (header, free_format): `read(5054,*) header`
   - Variables: header
   - Data types: character
3. **Line 42** (header, free_format): `read(5054,*) header`
   - Variables: header
   - Data types: character
4. **Line 50** (data, free_format): `read(5054,*) name,(salt_uptake_kg(i,j),j=1,cs_db%num_salts)`
   - Variables: name, (salt_uptake_kg(i, j), j=1, cs_db%num_salts)
   - Data types: integer, unknown

---

### File: `cs_irr_read.f90`

**Filename:** `cs_irrigation` (Unit: 107)
**Line 24:** `open (107,file="cs_irrigation")`

**Read Structure:**
1. **Line 25** (data, free_format): `read (107,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
2. **Line 27** (header, free_format): `read (107,*,iostat=eof) header`
   - Variables: header
   - Data types: character
3. **Line 33** (data, free_format): `read (107,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
4. **Line 47** (data, free_format): `read (107,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
5. **Line 49** (header, free_format): `read (107,*,iostat=eof) header`
   - Variables: header
   - Data types: character
6. **Line 52** (data, free_format): `read (107,*,iostat=eof) cs_water_irr(icsi)%name,cs_water_irr(icsi)%water`
   - Variables: cs_water_irr(icsi)%name, cs_water_irr(icsi)%water
   - Data types: character

---

### File: `carbon_coef_read.f90`

**Filename:** `carb_coefs.cbn` (Unit: 107)
**Line 40:** `open (107,file='carb_coefs.cbn', iostat=eof)`

**Read Structure:**
1. **Line 42** (data, free_format): `read (107,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
2. **Line 45** (data, free_format): `read (107,*,iostat=eof) var_name`
   - Variables: var_name
   - Data types: character
3. **Line 51** (data, free_format): `read (107,*,iostat=eof) var_name, carbdb(1)%hp_rate,carbdb(2)%hp_rate`
   - Variables: var_name, carbdb(1)%hp_rate, carbdb(2)%hp_rate
   - Data types: character
4. **Line 54** (data, free_format): `read (107,*,iostat=eof) var_name, carbdb(1)%hs_rate,carbdb(2)%hs_rate`
   - Variables: var_name, carbdb(1)%hs_rate, carbdb(2)%hs_rate
   - Data types: character
5. **Line 57** (data, free_format): `read (107,*,iostat=eof) var_name, carbdb(1)%microb_rate,carbdb(2)%microb_rate`
   - Variables: var_name, carbdb(1)%microb_rate, carbdb(2)%microb_rate
   - Data types: character
6. **Line 60** (data, free_format): `read (107,*,iostat=eof) var_name, carbdb(1)%meta_rate,carbdb(2)%meta_rate`
   - Variables: var_name, carbdb(1)%meta_rate, carbdb(2)%meta_rate
   - Data types: character
7. **Line 63** (data, free_format): `read (107,*,iostat=eof) var_name, carbdb(1)%str_rate,carbdb(2)%str_rate`
   - Variables: var_name, carbdb(1)%str_rate, carbdb(2)%str_rate
   - Data types: character
8. **Line 66** (data, free_format): `read (107,*,iostat=eof) var_name, carbdb(1)%microb_top_rate,carbdb(2)%microb_top_rate`
   - Variables: var_name, carbdb(1)%microb_top_rate, carbdb(2)%microb_top_rate
   - Data types: character
9. **Line 69** (data, free_format): `read (107,*,iostat=eof) var_name, carbdb(1)%hs_hp,carbdb(2)%hs_hp`
   - Variables: var_name, carbdb(1)%hs_hp, carbdb(2)%hs_hp
   - Data types: character
10. **Line 72** (data, free_format): `read (107,*,iostat=eof) var_name, org_allo(1)%a1co2,org_allo(2)%a1co2`
   - Variables: var_name, org_allo(1)%a1co2, org_allo(2)%a1co2
   - Data types: unknown, character
11. **Line 75** (data, free_format): `read (107,*,iostat=eof) var_name, org_allo(1)%asco2,org_allo(2)%asco2`
   - Variables: var_name, org_allo(1)%asco2, org_allo(2)%asco2
   - Data types: unknown, character
12. **Line 78** (data, free_format): `read (107,*,iostat=eof) var_name, org_allo(1)%apco2,org_allo(2)%apco2`
   - Variables: var_name, org_allo(1)%apco2, org_allo(2)%apco2
   - Data types: unknown, character
13. **Line 81** (data, free_format): `read (107,*,iostat=eof) var_name, org_allo(1)%abco2,org_allo(2)%abco2`
   - Variables: var_name, org_allo(1)%abco2, org_allo(2)%abco2
   - Data types: unknown, character
14. **Line 84** (data, free_format): `read (107,*,iostat=eof) var_name, cb_wtr_coef%prmt_21`
   - Variables: var_name, cb_wtr_coef%prmt_21
   - Data types: character
15. **Line 87** (data, free_format): `read (107,*,iostat=eof) var_name, cb_wtr_coef%prmt_44`
   - Variables: var_name, cb_wtr_coef%prmt_44
   - Data types: character
16. **Line 90** (data, free_format): `read (107,*,iostat=eof) var_name, till_eff_days`
   - Variables: var_name, till_eff_days
   - Data types: unknown, character

---

### File: `res_read_cs.f90`

**Filename:** `cs.res` (Unit: 105)
**Line 29:** `open (105,file="cs.res")`

**Read Structure:**
1. **Line 30** (data, free_format): `read (105,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
2. **Line 31** (data, free_format): `read (105,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
3. **Line 33** (data, free_format): `read(105,*)`
   - Data types: unknown
4. **Line 37** (header, free_format): `read (105,*,iostat=eof) header`
   - Variables: header
   - Data types: character
5. **Line 40** (data, free_format): `read (105,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
6. **Line 49** (data, free_format): `read (105,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
7. **Line 51** (data, free_format): `read (105,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
8. **Line 53** (data, free_format): `read(105,*)`
   - Data types: unknown
9. **Line 55** (header, free_format): `read (105,*,iostat=eof) header`
   - Variables: header
   - Data types: character
10. **Line 59** (data, free_format): `read (105,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
11. **Line 62** (data, free_format): `read (105,*,iostat=eof) res_cs_data(ires)`
   - Variables: res_cs_data(ires)
   - Data types: real

---

### File: `wet_read_salt_cs.f90`

**Filename:** `wetland.wet_cs` (Unit: 105)
**Line 31:** `open(105,file="wetland.wet_cs")`

**Read Structure:**
1. **Line 32** (header, free_format): `read(105,*) header`
   - Variables: header
   - Data types: character
2. **Line 33** (header, free_format): `read(105,*) header`
   - Variables: header
   - Data types: character
3. **Line 40** (data, free_format): `read (105,*,iostat=eof) i`
   - Variables: i
   - Data types: integer
4. **Line 43** (data, free_format): `read (105,*,iostat=eof) k, wet_dat_c_cs(iwet)`
   - Variables: k, wet_dat_c_cs(iwet)
   - Data types: integer, unknown

---

### File: `pest_metabolite_read.f90`

**Filename:** `pest_metabolite.pes` (Unit: 106)
**Line 29:** `open (106,file="pest_metabolite.pes")`

**Read Structure:**
1. **Line 30** (data, free_format): `read (106,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
2. **Line 32** (header, free_format): `read (106,*,iostat=eof) header`
   - Variables: header
   - Data types: character
3. **Line 35** (data, free_format): `read (106,*,iostat=eof) titldum, num_metab`
   - Variables: titldum, num_metab
   - Data types: integer, unknown
4. **Line 37** (data, free_format): `read (106,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
5. **Line 44** (data, free_format): `read (106,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
6. **Line 46** (header, free_format): `read (106,*,iostat=eof) header`
   - Variables: header
   - Data types: character
7. **Line 50** (data, free_format): `read (106,*,iostat=eof) parent_name, num_metab`
   - Variables: parent_name, num_metab
   - Data types: integer, character
8. **Line 60** (data, free_format): `read (106,*,iostat=eof) pestcp(ip)%daughter(imeta)%name,        &`
   - Variables: pestcp(ip)%daughter(imeta)%name, &
   - Data types: unknown, character

---

### File: `co2_read.f90`

**Filename:** `co2.out` (Unit: 2222)
**Line 34:** `open (2222,file="co2.out")`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `co2_yr.dat` (Unit: 107)
**Line 44:** `open (107,file="co2_yr.dat")`

**Read Structure:**
1. **Line 46** (data, free_format): `read (107,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
2. **Line 48** (data, free_format): `read (107,*,iostat=eof) co2_inc%yrs`
   - Variables: co2_inc%yrs
   - Data types: character
3. **Line 50** (header, free_format): `read (107,*,iostat=eof) header`
   - Variables: header
   - Data types: character
4. **Line 56** (data, free_format): `read (107,*,iostat=eof) co2_inc%co2_yr(itot)`
   - Variables: co2_inc%co2_yr(itot)
   - Data types: character

---

### File: `header_salt.f90`

**Filename:** `basin_salt_day.txt` (Unit: 5080)
**Line 17:** `open (5080,file="basin_salt_day.txt", recl = 2000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_salt_mon.txt` (Unit: 5082)
**Line 59:** `open (5082,file="basin_salt_mon.txt", recl = 2000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_salt_yr.txt` (Unit: 5084)
**Line 101:** `open (5084,file="basin_salt_yr.txt", recl = 2000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_salt_aa.txt` (Unit: 5086)
**Line 143:** `open (5086,file="basin_salt_aa.txt", recl = 2000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_salt_day.txt` (Unit: 5021)
**Line 185:** `open (5021,file="hru_salt_day.txt", recl = 3000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_salt_day.csv` (Unit: 5022)
**Line 216:** `open (5022,file="hru_salt_day.csv", recl = 3000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_salt_mon.txt` (Unit: 5023)
**Line 225:** `open (5023,file="hru_salt_mon.txt", recl = 3000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_salt_mon.csv` (Unit: 5024)
**Line 256:** `open (5024,file="hru_salt_mon.csv", recl = 3000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_salt_yr.txt` (Unit: 5025)
**Line 265:** `open (5025,file="hru_salt_yr.txt", recl = 3000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_salt_yr.csv` (Unit: 5026)
**Line 296:** `open (5026,file="hru_salt_yr.csv", recl = 3000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_salt_aa.txt` (Unit: 5027)
**Line 305:** `open (5027,file="hru_salt_aa.txt", recl = 3000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_salt_aa.csv` (Unit: 5028)
**Line 336:** `open (5028,file="hru_salt_aa.csv", recl = 3000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `aquifer_salt_day.txt` (Unit: 5060)
**Line 346:** `open (5060,file="aquifer_salt_day.txt",recl=2000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `aquifer_salt_day.csv` (Unit: 5061)
**Line 365:** `open (5061,file="aquifer_salt_day.csv",recl=2000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `aquifer_salt_mon.txt` (Unit: 5062)
**Line 376:** `open (5062,file="aquifer_salt_mon.txt",recl=2000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `aquifer_salt_mon.csv` (Unit: 5063)
**Line 395:** `open (5063,file="aquifer_salt_mon.csv",recl=2000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `aquifer_salt_yr.txt` (Unit: 5064)
**Line 406:** `open (5064,file="aquifer_salt_yr.txt",recl=2000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `aquifer_salt_yr.csv` (Unit: 5065)
**Line 425:** `open (5065,file="aquifer_salt_yr.csv",recl=2000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `aquifer_salt_aa.txt` (Unit: 5066)
**Line 436:** `open (5066,file="aquifer_salt_aa.txt",recl=2000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `aquifer_salt_aa.csv` (Unit: 5067)
**Line 455:** `open (5067,file="aquifer_salt_aa.csv",recl=2000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `channel_salt_day.txt` (Unit: 5030)
**Line 466:** `open (5030,file="channel_salt_day.txt",recl=4000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `channel_salt_day.csv` (Unit: 5031)
**Line 485:** `open (5031,file="channel_salt_day.csv",recl=2000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `channel_salt_mon.txt` (Unit: 5032)
**Line 495:** `open (5032,file="channel_salt_mon.txt",recl=4000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `channel_salt_mon.csv` (Unit: 5033)
**Line 514:** `open (5033,file="channel_salt_mon.csv",recl=2000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `channel_salt_yr.txt` (Unit: 5034)
**Line 524:** `open (5034,file="channel_salt_yr.txt",recl=4000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `channel_salt_yr.csv` (Unit: 5035)
**Line 543:** `open (5035,file="channel_salt_yr.csv",recl=2000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `channel_salt_aa.txt` (Unit: 5036)
**Line 553:** `open (5036,file="channel_salt_aa.txt",recl=4000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `channel_salt_aa.csv` (Unit: 5037)
**Line 572:** `open (5037,file="channel_salt_aa.csv",recl=2000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `reservoir_salt_day.txt` (Unit: 5040)
**Line 582:** `open (5040,file="reservoir_salt_day.txt",recl=2000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `reservoir_salt_day.csv` (Unit: 5041)
**Line 602:** `open (5041,file="reservoir_salt_day.csv",recl=2000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `reservoir_salt_mon.txt` (Unit: 5042)
**Line 612:** `open (5042,file="reservoir_salt_mon.txt",recl=2000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `reservoir_salt_mon.csv` (Unit: 5043)
**Line 632:** `open (5043,file="reservoir_salt_mon.csv",recl=2000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `reservoir_salt_yr.txt` (Unit: 5044)
**Line 642:** `open (5044,file="reservoir_salt_yr.txt",recl=2000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `reservoir_salt_yr.csv` (Unit: 5045)
**Line 662:** `open (5045,file="reservoir_salt_yr.csv",recl=2000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `reservoir_salt_aa.txt` (Unit: 5046)
**Line 672:** `open (5046,file="reservoir_salt_aa.txt",recl=2000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `reservoir_salt_aa.csv` (Unit: 5047)
**Line 692:** `open (5047,file="reservoir_salt_aa.csv",recl=2000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `rout_unit_salt_day.txt` (Unit: 5070)
**Line 702:** `open (5070,file="rout_unit_salt_day.txt",recl=2000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `rout_unit_salt_day.csv` (Unit: 5071)
**Line 729:** `open (5071,file="rout_unit_salt_day.csv",recl=2000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `rout_unit_salt_mon.txt` (Unit: 5072)
**Line 740:** `open (5072,file="rout_unit_salt_mon.txt",recl=2000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `rout_unit_salt_mon.csv` (Unit: 5073)
**Line 767:** `open (5073,file="rout_unit_salt_mon.csv",recl=2000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `rout_unit_salt_yr.txt` (Unit: 5074)
**Line 778:** `open (5074,file="rout_unit_salt_yr.txt",recl=2000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `rout_unit_salt_yr.csv` (Unit: 5075)
**Line 805:** `open (5075,file="rout_unit_salt_yr.csv",recl=2000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `rout_unit_salt_aa.txt` (Unit: 5076)
**Line 816:** `open (5076,file="rout_unit_salt_aa.txt",recl=2000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `rout_unit_salt_aa.csv` (Unit: 5077)
**Line 843:** `open (5077,file="rout_unit_salt_aa.csv",recl=2000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `wetland_salt_day.txt` (Unit: 5090)
**Line 854:** `open (5090,file="wetland_salt_day.txt",recl=2000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `wetland_salt_day.csv` (Unit: 5091)
**Line 874:** `open (5091,file="wetland_salt_day.csv",recl=2000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `wetland_salt_mon.txt` (Unit: 5092)
**Line 884:** `open (5092,file="wetland_salt_mon.txt",recl=2000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `wetland_salt_mon.csv` (Unit: 5093)
**Line 904:** `open (5093,file="wetland_salt_mon.csv",recl=2000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `wetland_salt_yr.txt` (Unit: 5094)
**Line 914:** `open (5094,file="wetland_salt_yr.txt",recl=2000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `wetland_salt_yr.csv` (Unit: 5095)
**Line 934:** `open (5095,file="wetland_salt_yr.csv",recl=2000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `wetland_salt_aa.txt` (Unit: 5096)
**Line 944:** `open (5096,file="wetland_salt_aa.txt",recl=2000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `wetland_salt_aa.csv` (Unit: 5097)
**Line 964:** `open (5097,file="wetland_salt_aa.csv",recl=2000)`

**Read Structure:** No read operations found (likely output file)

---

### File: `cli_read_atmodep_salt.f90`

**Filename:** `salt_atmo.cli` (Unit: 5050)
**Line 38:** `open(5050,file='salt_atmo.cli')`

**Read Structure:**
1. **Line 39** (data, free_format): `read(5050,*)`
   - Data types: unknown
2. **Line 40** (data, free_format): `read(5050,*)`
   - Data types: unknown
3. **Line 41** (data, free_format): `read(5050,*)`
   - Data types: unknown
4. **Line 42** (data, free_format): `read(5050,*)`
   - Data types: unknown
5. **Line 43** (data, free_format): `read(5050,*)`
   - Data types: unknown
6. **Line 44** (data, free_format): `read(5050,*)`
   - Data types: unknown
7. **Line 57** (data, free_format): `read(5050,*) station_name !station name --> already read in cli_read_atmodep`
   - Variables: station_name !station name --> already read in cli_read_atmodep
   - Data types: character
8. **Line 60** (data, free_format): `read(5050,*) salt_ion,atmodep_salt(iadep)%salt(isalt)%rf`
   - Variables: salt_ion, atmodep_salt(iadep)%salt(isalt)%rf
   - Data types: unknown
9. **Line 64** (data, free_format): `read(5050,*) salt_ion,atmodep_salt(iadep)%salt(isalt)%dry`
   - Variables: salt_ion, atmodep_salt(iadep)%salt(isalt)%dry
   - Data types: unknown
10. **Line 70** (data, free_format): `read(5050,*) station_name !station name`
   - Variables: station_name !station name
   - Data types: character
11. **Line 73** (data, free_format): `read(5050,*) salt_ion,(atmodep_salt(iadep)%salt(isalt)%rfmo(imo),imo=1,atmodep_cont%num)`
   - Variables: salt_ion, (atmodep_salt(iadep)%salt(isalt)%rfmo(imo), imo=1, atmodep_cont%num)
   - Data types: integer, unknown
12. **Line 77** (data, free_format): `read(5050,*) salt_ion,(atmodep_salt(iadep)%salt(isalt)%drymo(imo),imo=1,atmodep_cont%num)`
   - Variables: salt_ion, (atmodep_salt(iadep)%salt(isalt)%drymo(imo), imo=1, atmodep_cont%num)
   - Data types: integer, unknown
13. **Line 83** (data, free_format): `read(5050,*) station_name !station name`
   - Variables: station_name !station name
   - Data types: character
14. **Line 86** (data, free_format): `read(5050,*) salt_ion,(atmodep_salt(iadep)%salt(isalt)%rfyr(iyr),iyr=1,atmodep_cont%num)`
   - Variables: salt_ion, (atmodep_salt(iadep)%salt(isalt)%rfyr(iyr), iyr=1, atmodep_cont%num)
   - Data types: integer, unknown

---

### File: `cs_aqu_read.f90`

**Filename:** `cs_aqu.ini` (Unit: 107)
**Line 23:** `open (107,file="cs_aqu.ini")`

**Read Structure:**
1. **Line 24** (data, free_format): `read (107,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
2. **Line 26** (header, free_format): `read (107,*,iostat=eof) header`
   - Variables: header
   - Data types: character
3. **Line 28** (header, free_format): `read (107,*,iostat=eof) header`
   - Variables: header
   - Data types: character
4. **Line 32** (data, free_format): `read (107,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
5. **Line 47** (data, free_format): `read (107,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
6. **Line 49** (header, free_format): `read (107,*,iostat=eof) header`
   - Variables: header
   - Data types: character
7. **Line 51** (header, free_format): `read (107,*,iostat=eof) header`
   - Variables: header
   - Data types: character
8. **Line 55** (data, free_format): `read (107,*,iostat=eof) cs_aqu_ini(ics)%name,cs_aqu_ini(ics)%aqu`
   - Variables: cs_aqu_ini(ics)%name, cs_aqu_ini(ics)%aqu
   - Data types: character

---

### File: `header_channel.f90`

**Filename:** `channel_day.txt` (Unit: 2480)
**Line 25:** `open (2480,file="channel_day.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `channel_day.csv` (Unit: 2484)
**Line 31:** `open (2484,file="channel_day.csv",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `channel_mon.txt` (Unit: 2481)
**Line 42:** `open (2481,file="channel_mon.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `channel_mon.csv` (Unit: 2485)
**Line 48:** `open (2485,file="channel_mon.csv",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `channel_yr.txt` (Unit: 2482)
**Line 59:** `open (2482,file="channel_yr.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `channel_yr.csv` (Unit: 2486)
**Line 65:** `open (2486,file="channel_yr.csv",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `channel_aa.txt` (Unit: 2483)
**Line 76:** `open (2483,file="channel_aa.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `channel_aa.csv` (Unit: 2487)
**Line 82:** `open (2487,file="channel_aa.csv",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

### File: `recall_read_salt.f90`

**Filename:** `salt_recall.rec` (Unit: 107)
**Line 47:** `open (107,file="salt_recall.rec")`

**Read Structure:**
1. **Line 48** (data, free_format): `read (107,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
2. **Line 50** (header, free_format): `read (107,*,iostat=eof) header`
   - Variables: header
   - Data types: character
3. **Line 56** (data, free_format): `read (107,*,iostat=eof) i`
   - Variables: i
   - Data types: integer

---

### File: `output_landscape_init.f90`

**Filename:** `hru_wb_day.txt` (Unit: 2000)
**Line 17:** `open (2000,file="hru_wb_day.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_wb_day.csv` (Unit: 2004)
**Line 24:** `open (2004,file="hru_wb_day.csv",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_wb_mon.txt` (Unit: 2001)
**Line 34:** `open (2001,file="hru_wb_mon.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_wb_mon.csv` (Unit: 2005)
**Line 41:** `open (2005,file="hru_wb_mon.csv",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_wb_yr.txt` (Unit: 2002)
**Line 51:** `open (2002,file="hru_wb_yr.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_wb_yr.csv` (Unit: 2006)
**Line 57:** `open (2006,file="hru_wb_yr.csv",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_wb_aa.txt` (Unit: 2003)
**Line 67:** `open (2003,file="hru_wb_aa.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_wb_aa.csv` (Unit: 2007)
**Line 73:** `open (2007,file="hru_wb_aa.csv",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_nb_day.txt` (Unit: 2020)
**Line 83:** `open (2020,file="hru_nb_day.txt", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_nb_day.csv` (Unit: 2024)
**Line 89:** `open (2024,file="hru_nb_day.csv", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_ncycle_day.txt` (Unit: 3333)
**Line 99:** `open (3333,file="hru_ncycle_day.txt", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_ncycle_day.csv` (Unit: 3334)
**Line 105:** `open (3334,file="hru_ncycle_day.csv", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_ncycle_mon.txt` (Unit: 3335)
**Line 114:** `open (3335,file="hru_ncycle_mon.txt", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_ncycle_mon.csv` (Unit: 3336)
**Line 120:** `open (3336,file="hru_ncycle_mon.csv", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_ncycle_yr.txt` (Unit: 3337)
**Line 129:** `open (3337,file="hru_ncycle_yr.txt", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_ncycle_yr.csv` (Unit: 3338)
**Line 135:** `open (3338,file="hru_ncycle_yr.csv", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_ncycle_aa.txt` (Unit: 3339)
**Line 144:** `open (3339,file="hru_ncycle_aa.txt", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_ncycle_aa.csv` (Unit: 3340)
**Line 150:** `open (3340,file="hru_ncycle_aa.csv", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_nb_mon.txt` (Unit: 2021)
**Line 160:** `open (2021,file="hru_nb_mon.txt", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_nb_mon.csv` (Unit: 2025)
**Line 166:** `open (2025,file="hru_nb_mon.csv", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_nb_yr.txt` (Unit: 2022)
**Line 175:** `open (2022,file="hru_nb_yr.txt", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_nb_yr.csv` (Unit: 2026)
**Line 181:** `open (2026,file="hru_nb_yr.csv", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_nb_aa.txt` (Unit: 2023)
**Line 190:** `open (2023,file="hru_nb_aa.txt", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_nb_aa.csv` (Unit: 2027)
**Line 196:** `open (2027,file="hru_nb_aa.csv", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_soilcarb_day.txt` (Unit: 4520)
**Line 206:** `open (4520,file="hru_soilcarb_day.txt", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_soilcarb_day.csv` (Unit: 4524)
**Line 212:** `open (4524,file="hru_soilcarb_day.csv", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_soilcarb_mon.txt` (Unit: 4521)
**Line 221:** `open (4521,file="hru_soilcarb_mon.txt", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_soilcarb_mon.csv` (Unit: 4525)
**Line 227:** `open (4525,file="hru_soilcarb_mon.csv", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_soilcarb_yr.txt` (Unit: 4522)
**Line 236:** `open (4522,file="hru_soilcarb_yr.txt", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_soilcarb_yr.csv` (Unit: 4526)
**Line 242:** `open (4526,file="hru_soilcarb_yr.csv", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_soilcarb_aa.txt` (Unit: 4523)
**Line 251:** `open (4523,file="hru_soilcarb_aa.txt", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_soilcarb_aa.csv` (Unit: 4527)
**Line 257:** `open (4527,file="hru_soilcarb_aa.csv", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_rescarb_day.txt` (Unit: 4530)
**Line 269:** `open (4530,file="hru_rescarb_day.txt", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_rescarb_day.csv` (Unit: 4534)
**Line 275:** `open (4534,file="hru_rescarb_day.csv", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_rescarb_mon.txt` (Unit: 4531)
**Line 284:** `open (4531,file="hru_rescarb_mon.txt", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_rescarb_mon.csv` (Unit: 4535)
**Line 290:** `open (4535,file="hru_rescarb_mon.csv", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_rescarb_yr.txt` (Unit: 4532)
**Line 299:** `open (4532,file="hru_rescarb_yr.txt", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_rescarb_yr.csv` (Unit: 4536)
**Line 305:** `open (4536,file="hru_rescarb_yr.csv", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_rescarb_aa.txt` (Unit: 4533)
**Line 314:** `open (4533,file="hru_rescarb_aa.txt", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_rescarb_aa.csv` (Unit: 4537)
**Line 320:** `open (4537,file="hru_rescarb_aa.csv", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_plcarb_day.txt` (Unit: 4540)
**Line 332:** `open (4540,file="hru_plcarb_day.txt", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_plcarb_day.csv` (Unit: 4544)
**Line 338:** `open (4544,file="hru_plcarb_day.csv", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_plcarb_mon.txt` (Unit: 4541)
**Line 347:** `open (4541,file="hru_plcarb_mon.txt", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_plcarb_mon.csv` (Unit: 4545)
**Line 353:** `open (4545,file="hru_plcarb_mon.csv", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_plcarb_yr.txt` (Unit: 4542)
**Line 362:** `open (4542,file="hru_plcarb_yr.txt", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_plcarb_yr.csv` (Unit: 4546)
**Line 368:** `open (4546,file="hru_plcarb_yr.csv", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_plcarb_aa.txt` (Unit: 4543)
**Line 377:** `open (4543,file="hru_plcarb_aa.txt", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_plcarb_aa.csv` (Unit: 4547)
**Line 383:** `open (4547,file="hru_plcarb_aa.csv", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_scf_day.txt` (Unit: 4550)
**Line 395:** `open (4550,file="hru_scf_day.txt", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_scf_day.csv` (Unit: 4554)
**Line 401:** `open (4554,file="hru_scf_day.csv", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_scf_mon.txt` (Unit: 4551)
**Line 410:** `open (4551,file="hru_scf_mon.txt", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_scf_mon.csv` (Unit: 4555)
**Line 416:** `open (4555,file="hru_scf_mon.csv", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_scf_yr.txt` (Unit: 4552)
**Line 425:** `open (4552,file="hru_scf_yr.txt", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_scf_yr.csv` (Unit: 4556)
**Line 431:** `open (4556,file="hru_scf_yr.csv", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_scf_aa.txt` (Unit: 4553)
**Line 440:** `open (4553,file="hru_scf_aa.txt", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_scf_aa.csv` (Unit: 4557)
**Line 446:** `open (4557,file="hru_scf_aa.csv", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_cbn_lyr.txt` (Unit: 4548)
**Line 461:** `open (4548,file = "hru_cbn_lyr.txt", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_cbn_lyr.csv` (Unit: 4549)
**Line 467:** `open (4549,file="hru_cbn_lyr.csv", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_seq_lyr.txt` (Unit: 4558)
**Line 474:** `open (4558,file = "hru_seq_lyr.txt", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_seq_lyr.csv` (Unit: 4559)
**Line 480:** `open (4559,file="hru_seq_lyr.csv", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_plc_stat.txt` (Unit: 4560)
**Line 488:** `open (4560,file = "hru_plc_stat.txt", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_plc_stat.csv` (Unit: 4563)
**Line 494:** `open (4563,file="hru_plc_stat.csv", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_rsdc_stat.txt` (Unit: 4561)
**Line 502:** `open (4561,file = "hru_rsdc_stat.txt", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_rsdc_stat.csv` (Unit: 4564)
**Line 508:** `open (4564,file="hru_rsdc_stat.csv", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_soilc_stat.txt` (Unit: 4562)
**Line 515:** `open (4562,file = "hru_soilc_stat.txt", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_soilc_stat.csv` (Unit: 4565)
**Line 521:** `open (4565,file="hru_soilc_stat.csv", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_cflux_stat.txt` (Unit: 4567)
**Line 528:** `open (4567,file = "hru_cflux_stat.txt", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_cflux_stat.csv` (Unit: 4568)
**Line 534:** `open (4568,file="hru_cflux_stat.csv", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_soilcarb_mb_stat.txt` (Unit: 4570)
**Line 541:** `open (4570,file = "hru_soilcarb_mb_stat.txt", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_soilcarb_mb_stat.csv` (Unit: 4571)
**Line 547:** `open (4571,file="hru_soilcarb_mb_stat.csv", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_cpool_stat.txt` (Unit: 4572)
**Line 554:** `open (4572,file = "hru_cpool_stat.txt", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_cpool_stat.csv` (Unit: 4573)
**Line 560:** `open (4573,file="hru_cpool_stat.csv", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_n_p_pool_stat.txt` (Unit: 4582)
**Line 567:** `open (4582,file = "hru_n_p_pool_stat.txt", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_n_p_pool_stat.csv` (Unit: 4583)
**Line 573:** `open (4583,file="hru_n_p_pool_stat.csv", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_org_trans_vars.txt` (Unit: 4580)
**Line 580:** `open (4580,file = "hru_org_trans_vars.txt", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_org_trans_vars.csv` (Unit: 4581)
**Line 586:** `open (4581,file="hru_org_trans_vars.csv", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_carbvars.txt` (Unit: 4574)
**Line 599:** `open (4574,file = "hru_carbvars.txt", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_carbvars.csv` (Unit: 4575)
**Line 604:** `open (4575,file="hru_carbvars.csv", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_org_allo_vars.txt` (Unit: 4576)
**Line 615:** `open (4576,file = "hru_org_allo_vars.txt", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_org_allo_vars.csv` (Unit: 4577)
**Line 620:** `open (4577,file="hru_org_allo_vars.csv", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_org_ratio_vars.txt` (Unit: 4578)
**Line 631:** `open (4578,file = "hru_org_ratio_vars.txt", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_org_ratio_vars.csv` (Unit: 4579)
**Line 636:** `open (4579,file="hru_org_ratio_vars.csv", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_endsim_soil_prop.txt` (Unit: 4584)
**Line 647:** `open (4584,file = "hru_endsim_soil_prop.txt", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_endsim_soil_prop.csv` (Unit: 4585)
**Line 652:** `open (4585,file="hru_endsim_soil_prop.csv", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_carbon_all.txt` (Unit: 4566)
**Line 662:** `open (4566,file = "basin_carbon_all.txt", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_ls_day.txt` (Unit: 2030)
**Line 674:** `open (2030,file="hru_ls_day.txt", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_ls_day.csv` (Unit: 2034)
**Line 680:** `open (2034,file="hru_ls_day.csv", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_nut_carb_gl_day.txt` (Unit: 3341)
**Line 691:** `open (3341,file="hru_nut_carb_gl_day.txt", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_nut_carb_gl_day.csv` (Unit: 3342)
**Line 697:** `open (3342,file="hru_nut_carb_gl_day.csv", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_nut_carb_gl_mon.txt` (Unit: 3343)
**Line 706:** `open (3343,file="hru_nut_carb_gl_mon.txt", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_nut_carb_gl_mon.csv` (Unit: 3344)
**Line 712:** `open (3344,file="hru_nut_carb_gl_mon.csv", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_nut_carb_gl_yr.txt` (Unit: 3345)
**Line 721:** `open (3345,file="hru_nut_carb_gl_yr.txt", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_nut_carb_gl_yr.csv` (Unit: 3346)
**Line 727:** `open (3346,file="hru_nut_carb_gl_yr.csv", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_nut_carb_gl_aa.txt` (Unit: 3347)
**Line 736:** `open (3347,file="hru_nut_carb_gl_aa.txt", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_nut_carb_gl_aa.csv` (Unit: 3348)
**Line 742:** `open (3348,file="hru_nut_carb_gl_aa.csv", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_ls_mon.txt` (Unit: 2031)
**Line 752:** `open (2031,file="hru_ls_mon.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_ls_mon.csv` (Unit: 2035)
**Line 758:** `open (2035,file="hru_ls_mon.csv",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_ls_yr.txt` (Unit: 2032)
**Line 767:** `open (2032,file="hru_ls_yr.txt", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_ls_yr.csv` (Unit: 2036)
**Line 773:** `open (2036,file="hru_ls_yr.csv", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_ls_aa.txt` (Unit: 2033)
**Line 782:** `open (2033,file="hru_ls_aa.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_ls_aa.csv` (Unit: 2037)
**Line 788:** `open (2037,file="hru_ls_aa.csv",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_pw_day.txt` (Unit: 2040)
**Line 798:** `open (2040,file="hru_pw_day.txt", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_pw_day.csv` (Unit: 2044)
**Line 804:** `open (2044,file="hru_pw_day.csv", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_pw_mon.txt` (Unit: 2041)
**Line 813:** `open (2041,file="hru_pw_mon.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_pw_mon.csv` (Unit: 2045)
**Line 819:** `open (2045,file="hru_pw_mon.csv",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_pw_yr.txt` (Unit: 2042)
**Line 828:** `open (2042,file="hru_pw_yr.txt", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_pw_yr.csv` (Unit: 2046)
**Line 834:** `open (2046,file="hru_pw_yr.csv", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_pw_aa.txt` (Unit: 2043)
**Line 843:** `open (2043,file="hru_pw_aa.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_pw_aa.csv` (Unit: 2047)
**Line 849:** `open (2047,file="hru_pw_aa.csv",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru-lte_wb_day.txt` (Unit: 2300)
**Line 862:** `open (2300,file="hru-lte_wb_day.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru-lte_wb_day.csv` (Unit: 2304)
**Line 868:** `open (2304,file="hru-lte_wb_day.csv",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru-lte_wb_mon.txt` (Unit: 2301)
**Line 878:** `open (2301,file="hru-lte_wb_mon.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru-lte_wb_mon.csv` (Unit: 2305)
**Line 884:** `open (2305,file="hru-lte_wb_mon.csv",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru-lte_wb_yr.txt` (Unit: 2302)
**Line 895:** `open (2302,file="hru-lte_wb_yr.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru-lte_wb_yr.csv` (Unit: 2306)
**Line 901:** `open (2306,file="hru-lte_wb_yr.csv",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru-lte_wb_aa.txt` (Unit: 2303)
**Line 912:** `open (2303,file="hru-lte_wb_aa.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru-lte_wb_aa.csv` (Unit: 2307)
**Line 918:** `open (2307,file="hru-lte_wb_aa.csv",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru-lte_ls_day.txt` (Unit: 2440)
**Line 940:** `open (2440,file="hru-lte_ls_day.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru-lte_ls_day.csv` (Unit: 2444)
**Line 946:** `open (2444,file="hru-lte_ls_day.csv",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru-lte_ls_mon.txt` (Unit: 2441)
**Line 955:** `open (2441,file="hru-lte_ls_mon.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru-lte_ls_mon.csv` (Unit: 2445)
**Line 961:** `open (2445,file="hru-lte_ls_mon.csv",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru-lte_ls_yr.txt` (Unit: 2442)
**Line 970:** `open (2442,file="hru-lte_ls_yr.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru-lte_ls_yr.csv` (Unit: 2446)
**Line 976:** `open (2446,file="hru-lte_ls_yr.csv",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru-lte_ls_aa.txt` (Unit: 2443)
**Line 985:** `open (2443,file="hru-lte_ls_aa.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru-lte_ls_aa.csv` (Unit: 2447)
**Line 991:** `open (2447,file="hru-lte_ls_aa.csv",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru-lte_pw_day.txt` (Unit: 2460)
**Line 1002:** `open (2460,file="hru-lte_pw_day.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru-lte_pw_day.csv` (Unit: 2464)
**Line 1008:** `open (2464,file="hru-lte_pw_day.csv",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru-lte_pw_mon.txt` (Unit: 2461)
**Line 1017:** `open (2461,file="hru-lte_pw_mon.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru-lte_pw_mon.csv` (Unit: 2465)
**Line 1023:** `open (2465,file="hru-lte_pw_mon.csv",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru-lte_pw_yr.txt` (Unit: 2462)
**Line 1032:** `open (2462,file="hru-lte_pw_yr.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru-lte_pw_yr.csv` (Unit: 2466)
**Line 1038:** `open (2466,file="hru-lte_pw_yr.csv",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru-lte_pw_aa.txt` (Unit: 2463)
**Line 1047:** `open (2463,file="hru-lte_pw_aa.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru-lte_pw_aa.csv` (Unit: 2467)
**Line 1053:** `open (2467,file="hru-lte_pw_aa.csv",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `lsunit_wb_day.txt` (Unit: 2140)
**Line 1065:** `open (2140,file="lsunit_wb_day.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `lsunit_wb_day.csv` (Unit: 2144)
**Line 1071:** `open (2144,file="lsunit_wb_day.csv",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `lsunit_wb_mon.txt` (Unit: 2141)
**Line 1081:** `open (2141,file="lsunit_wb_mon.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `lsunit_wb_mon.csv` (Unit: 2145)
**Line 1087:** `open (2145,file="lsunit_wb_mon.csv",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `lsunit_wb_yr.txt` (Unit: 2142)
**Line 1097:** `open (2142,file="lsunit_wb_yr.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `lsunit_wb_yr.csv` (Unit: 2146)
**Line 1103:** `open (2146,file="lsunit_wb_yr.csv",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `lsunit_wb_aa.txt` (Unit: 2143)
**Line 1113:** `open (2143,file="lsunit_wb_aa.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `lsunit_wb_aa.csv` (Unit: 2147)
**Line 1119:** `open (2147,file="lsunit_wb_aa.csv",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `lsunit_nb_day.txt` (Unit: 2150)
**Line 1129:** `open (2150,file="lsunit_nb_day.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `lsunit_nb_day.csv` (Unit: 2154)
**Line 1135:** `open (2154,file="lsunit_nb_day.csv",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `lsunit_nb_mon.txt` (Unit: 2151)
**Line 1144:** `open (2151,file="lsunit_nb_mon.txt", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `lsunit_nb_mon.csv` (Unit: 2155)
**Line 1150:** `open (2155,file="lsunit_nb_mon.csv", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `lsunit_nb_yr.txt` (Unit: 2152)
**Line 1159:** `open (2152,file="lsunit_nb_yr.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `lsunit_nb_yr.csv` (Unit: 2156)
**Line 1165:** `open (2156,file="lsunit_nb_yr.csv",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `lsunit_nb_aa.txt` (Unit: 2153)
**Line 1174:** `open (2153,file="lsunit_nb_aa.txt", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `lsunit_nb_aa.csv` (Unit: 2157)
**Line 1180:** `open (2157,file="lsunit_nb_aa.csv", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `lsunit_ls_day.txt` (Unit: 2160)
**Line 1190:** `open (2160,file="lsunit_ls_day.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `lsunit_ls_day.csv` (Unit: 2164)
**Line 1196:** `open (2164,file="lsunit_ls_day.csv",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `lsunit_ls_mon.txt` (Unit: 2161)
**Line 1205:** `open (2161,file="lsunit_ls_mon.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `lsunit_ls_mon.csv` (Unit: 2165)
**Line 1211:** `open (2165,file="lsunit_ls_mon.csv",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `lsunit_ls_yr.txt` (Unit: 2162)
**Line 1220:** `open (2162,file="lsunit_ls_yr.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `lsunit_ls_yr.csv` (Unit: 2166)
**Line 1226:** `open (2166,file="lsunit_ls_yr.csv",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `lsunit_ls_aa.txt` (Unit: 2163)
**Line 1235:** `open (2163,file="lsunit_ls_aa.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `lsunit_ls_aa.csv` (Unit: 2167)
**Line 1241:** `open (2167,file="lsunit_ls_aa.csv",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `lsunit_pw_day.txt` (Unit: 2170)
**Line 1251:** `open (2170,file="lsunit_pw_day.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `lsunit_pw_day.csv` (Unit: 2174)
**Line 1257:** `open (2174,file="lsunit_pw_day.csv",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `lsunit_pw_mon.txt` (Unit: 2171)
**Line 1267:** `open (2171,file="lsunit_pw_mon.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `lsunit_pw_mon.csv` (Unit: 2175)
**Line 1273:** `open (2175,file="lsunit_pw_mon.csv",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `lsunit_pw_yr.txt` (Unit: 2172)
**Line 1282:** `open (2172,file="lsunit_pw_yr.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `lsunit_pw_yr.csv` (Unit: 2176)
**Line 1288:** `open (2176,file="lsunit_pw_yr.csv",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `lsunit_pw_aa.txt` (Unit: 2173)
**Line 1297:** `open (2173,file="lsunit_pw_aa.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `lsunit_pw_aa.csv` (Unit: 2177)
**Line 1303:** `open (2177,file="lsunit_pw_aa.csv",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_wb_day.txt` (Unit: 2050)
**Line 1314:** `open (2050,file="basin_wb_day.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_wb_day.csv` (Unit: 2054)
**Line 1320:** `open (2054,file="basin_wb_day.csv",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_wb_mon.txt` (Unit: 2051)
**Line 1329:** `open (2051,file="basin_wb_mon.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_wb_mon.csv` (Unit: 2055)
**Line 1335:** `open (2055,file="basin_wb_mon.csv",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_wb_yr.txt` (Unit: 2052)
**Line 1344:** `open (2052,file="basin_wb_yr.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_wb_yr.csv` (Unit: 2056)
**Line 1350:** `open (2056,file="basin_wb_yr.csv",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_wb_aa.txt` (Unit: 2053)
**Line 1359:** `open (2053,file="basin_wb_aa.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_wb_aa.csv` (Unit: 2057)
**Line 1365:** `open (2057,file="basin_wb_aa.csv",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_nb_day.txt` (Unit: 2060)
**Line 1375:** `open (2060,file="basin_nb_day.txt", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_nb_day.csv` (Unit: 2064)
**Line 1381:** `open (2064,file="basin_nb_day.csv", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_nb_mon.txt` (Unit: 2061)
**Line 1390:** `open (2061,file="basin_nb_mon.txt", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_nb_mon.csv` (Unit: 2065)
**Line 1396:** `open (2065,file="basin_nb_mon.csv", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_nb_yr.txt` (Unit: 2062)
**Line 1405:** `open (2062,file="basin_nb_yr.txt", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_nb_yr.csv` (Unit: 2066)
**Line 1411:** `open (2066,file="basin_nb_yr.csv", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_nb_aa.txt` (Unit: 2063)
**Line 1420:** `open (2063,file="basin_nb_aa.txt", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_nb_aa.csv` (Unit: 2067)
**Line 1426:** `open (2067,file="basin_nb_aa.csv", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_ls_day.txt` (Unit: 2070)
**Line 1436:** `open (2070,file="basin_ls_day.txt", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_ls_day.csv` (Unit: 2074)
**Line 1442:** `open (2074,file="basin_ls_day.csv", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_ls_mon.txt` (Unit: 2071)
**Line 1451:** `open (2071,file="basin_ls_mon.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_ls_mon.csv` (Unit: 2075)
**Line 1457:** `open (2075,file="basin_ls_mon.csv",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_ls_yr.txt` (Unit: 2072)
**Line 1466:** `open (2072,file="basin_ls_yr.txt", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_ls_yr.csv` (Unit: 2076)
**Line 1472:** `open (2076,file="basin_ls_yr.csv", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_ls_aa.txt` (Unit: 2073)
**Line 1481:** `open (2073,file="basin_ls_aa.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_ls_aa.csv` (Unit: 2077)
**Line 1487:** `open (2077,file="basin_ls_aa.csv",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_pw_day.txt` (Unit: 2080)
**Line 1497:** `open (2080,file="basin_pw_day.txt", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_pw_day.csv` (Unit: 2084)
**Line 1503:** `open (2084,file="basin_pw_day.csv", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_pw_mon.txt` (Unit: 2081)
**Line 1512:** `open (2081,file="basin_pw_mon.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_pw_mon.csv` (Unit: 2085)
**Line 1518:** `open (2085,file="basin_pw_mon.csv",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_pw_yr.txt` (Unit: 2082)
**Line 1527:** `open (2082,file="basin_pw_yr.txt", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_pw_yr.csv` (Unit: 2086)
**Line 1533:** `open (2086,file="basin_pw_yr.csv", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_pw_aa.txt` (Unit: 2083)
**Line 1542:** `open (2083,file="basin_pw_aa.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_pw_aa.csv` (Unit: 2087)
**Line 1548:** `open (2087,file="basin_pw_aa.csv",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `crop_yld_yr.txt` (Unit: 4010)
**Line 1559:** `open (4010,file="crop_yld_yr.txt", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `crop_yld_yr.csv` (Unit: 4011)
**Line 1564:** `open (4011,file="crop_yld_yr.csv")`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `crop_yld_aa.txt` (Unit: 4008)
**Line 1573:** `open (4008,file="crop_yld_aa.txt", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `crop_yld_aa.csv` (Unit: 4009)
**Line 1578:** `open (4009,file="crop_yld_aa.csv")`

**Read Structure:** No read operations found (likely output file)

---

### File: `hyd_connect.f90`

**Filename:** `looping.con` (Unit: 9002)
**Line 417:** `open (9002,file="looping.con",recl = 8000)`

**Read Structure:** No read operations found (likely output file)

---

### File: `gwflow_read.f90`

**Filename:** `gwflow.input` (Unit: in_gw)
**Line 172:** `open(in_gw,file='gwflow.input')`

**Read Structure:**
1. **Line 173** (header, free_format): `read(in_gw,*) header`
   - Variables: header
   - Data types: character
2. **Line 174** (header, free_format): `read(in_gw,*) header`
   - Variables: header
   - Data types: character
3. **Line 178** (data, free_format): `read(in_gw,*) grid_type                       !structured or unstructured`
   - Variables: grid_type                       !structured or unstructured
   - Data types: integer
4. **Line 180** (data, free_format): `read(in_gw,*) cell_size                     !area (m2) of each grid cell`
   - Variables: cell_size                     !area (m2) of each grid cell
   - Data types: integer
5. **Line 181** (data, free_format): `read(in_gw,*) grid_nrow,grid_ncol           !number of rows and columns in the gwflow grid`
   - Variables: grid_nrow, grid_ncol           !number of rows and columns in the gwflow grid
   - Data types: integer
6. **Line 183** (data, free_format): `read(in_gw,*) ncell                         !number of gwflow cells`
   - Variables: ncell                         !number of gwflow cells
   - Data types: integer
7. **Line 185** (data, free_format): `read(in_gw,*) bc_type                         !boundary condition type`
   - Variables: bc_type                         !boundary condition type
   - Data types: character
8. **Line 186** (data, free_format): `read(in_gw,*) conn_type                       !connection type (HRU or LSU)`
   - Variables: conn_type                       !connection type (HRU or LSU)
   - Data types: character
9. **Line 187** (data, free_format): `read(in_gw,*) gw_soil_flag                    !flag to simulate groundwater-soil interactions`
   - Variables: gw_soil_flag                    !flag to simulate groundwater-soil interactions
   - Data types: integer
10. **Line 188** (data, free_format): `read(in_gw,*) gw_satx_flag                    !flag to simulate saturation excess routing`
   - Variables: gw_satx_flag                    !flag to simulate saturation excess routing
   - Data types: integer
11. **Line 189** (data, free_format): `read(in_gw,*) gw_pumpex_flag                  !flag to simulate specified groundwater pumping`
   - Variables: gw_pumpex_flag                  !flag to simulate specified groundwater pumping
   - Data types: integer
12. **Line 190** (data, free_format): `read(in_gw,*) gw_tile_flag                    !flag to simulate tile drainage outflow`
   - Variables: gw_tile_flag                    !flag to simulate tile drainage outflow
   - Data types: integer
13. **Line 191** (data, free_format): `read(in_gw,*) gw_res_flag                     !flag to simulate groundwater-reservoir exchange`
   - Variables: gw_res_flag                     !flag to simulate groundwater-reservoir exchange
   - Data types: integer
14. **Line 192** (data, free_format): `read(in_gw,*) gw_wet_flag                     !flag to simulate groundwater-wetland exchange`
   - Variables: gw_wet_flag                     !flag to simulate groundwater-wetland exchange
   - Data types: integer
15. **Line 193** (data, free_format): `read(in_gw,*) gw_fp_flag                      !flag to simulate groundwater-floodplain exchange`
   - Variables: gw_fp_flag                      !flag to simulate groundwater-floodplain exchange
   - Data types: integer
16. **Line 194** (data, free_format): `read(in_gw,*) gw_canal_flag                   !flag to simulate canal seepage to groundwater`
   - Variables: gw_canal_flag                   !flag to simulate canal seepage to groundwater
   - Data types: integer
17. **Line 195** (data, free_format): `read(in_gw,*) gw_solute_flag                  !flag to simulate solute transport in groundwater`
   - Variables: gw_solute_flag                  !flag to simulate solute transport in groundwater
   - Data types: integer
18. **Line 196** (data, free_format): `read(in_gw,*) gw_time_step                    !user-specified time step`
   - Variables: gw_time_step                    !user-specified time step
   - Data types: unknown
19. **Line 197** (data, free_format): `read(in_gw,*) gwflag_day,gwflag_yr,gwflag_aa  !flags for writing balance files`
   - Variables: gwflag_day, gwflag_yr, gwflag_aa  !flags for writing balance files
   - Data types: integer
20. **Line 198** (data, free_format): `read(in_gw,*) out_cols                        !number of columns in output files`
   - Variables: out_cols                        !number of columns in output files
   - Data types: integer

---

**Filename:** `gwflow_state_obs_head` (Unit: out_gwobs)
**Line 657:** `open(out_gwobs,file='gwflow_state_obs_head')`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `usgs_annual_head` (Unit: in_usgs_head)
**Line 687:** `open(in_usgs_head,file='usgs_annual_head')`

**Read Structure:**
1. **Line 688** (data, free_format): `read(in_usgs_head,*)`
   - Data types: unknown
2. **Line 692** (data, free_format): `read(in_usgs_head,*) usgs_site_id,usgs_lat,usgs_long,(head_vals(j),j=1,101)`
   - Variables: usgs_site_id, usgs_lat, usgs_long, (head_vals(j), j=1, 101)
   - Data types: integer, unknown

---

**Filename:** `gwflow_state_obs_head_usgs` (Unit: out_gwobs_usgs)
**Line 702:** `open(out_gwobs_usgs,file='gwflow_state_obs_head_usgs')`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `gwflow_flux_rech` (Unit: out_gw_rech)
**Line 788:** `open(out_gw_rech,file='gwflow_flux_rech')`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `gwflow_flux_gwet` (Unit: out_gw_et)
**Line 796:** `open(out_gw_et,file='gwflow_flux_gwet')`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `gwflow_flux_gwsw` (Unit: out_gwsw)
**Line 814:** `open(out_gwsw,file='gwflow_flux_gwsw')`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `gwflow_flux_soil` (Unit: out_gw_soil)
**Line 846:** `open(out_gw_soil,file='gwflow_flux_soil')`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `gwflow_flux_satx` (Unit: out_gw_satex)
**Line 901:** `open(out_gw_satex,file='gwflow_flux_satx')`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `gwflow_flux_ppag` (Unit: out_gw_pumpag)
**Line 908:** `open(out_gw_pumpag,file='gwflow_flux_ppag')`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `gwflow_flux_pumping_deficient` (Unit: out_gw_pumpdef)
**Line 911:** `open(out_gw_pumpdef,file='gwflow_flux_pumping_deficient')`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `gwflow_flux_pumping_hru_yr` (Unit: out_hru_pump_yr)
**Line 924:** `open(out_hru_pump_yr,file='gwflow_flux_pumping_hru_yr')`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `gwflow_flux_pumping_hru_mo` (Unit: out_hru_pump_mo)
**Line 927:** `open(out_hru_pump_mo,file='gwflow_flux_pumping_hru_mo')`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `gwflow.hru_pump_observe` (Unit: in_hru_pump_obs)
**Line 932:** `open(in_hru_pump_obs,file='gwflow.hru_pump_observe')`

**Read Structure:**
1. **Line 933** (data, free_format): `read(in_hru_pump_obs,*)`
   - Data types: unknown
2. **Line 934** (data, free_format): `read(in_hru_pump_obs,*) num_hru_pump_obs`
   - Variables: num_hru_pump_obs
   - Data types: integer
3. **Line 937** (data, free_format): `read(in_hru_pump_obs,*) hru_pump_ids(i)`
   - Variables: hru_pump_ids(i)
   - Data types: integer

---

**Filename:** `gwflow_flux_pumping_hru_obs` (Unit: out_hru_pump_obs)
**Line 941:** `open(out_hru_pump_obs,file='gwflow_flux_pumping_hru_obs')`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `gwflow.pumpex` (Unit: in_gw)
**Line 952:** `open(in_gw,file='gwflow.pumpex')`

**Read Structure:**
1. **Line 953** (header, free_format): `read(in_gw,*) header`
   - Variables: header
   - Data types: character
2. **Line 954** (data, free_format): `read(in_gw,*) gw_npumpex !number of pumps`
   - Variables: gw_npumpex !number of pumps
   - Data types: integer
3. **Line 963** (data, free_format): `read(in_gw,*)`
   - Data types: unknown
4. **Line 964** (data, free_format): `read(in_gw,*) pumpex_cell,gw_pumpex_nperiods(i)`
   - Variables: pumpex_cell, gw_pumpex_nperiods(i)
   - Data types: unknown
5. **Line 971** (data, free_format): `read(in_gw,*) gw_pumpex_dates(i,1,j),gw_pumpex_dates(i,2,j),gw_pumpex_rates(i,j)`
   - Variables: gw_pumpex_dates(i, 1, j), gw_pumpex_dates(i, 2, j), gw_pumpex_rates(i, j)
   - Data types: integer, unknown

---

**Filename:** `gwflow_flux_ppex` (Unit: out_gw_pumpex)
**Line 977:** `open(out_gw_pumpex,file='gwflow_flux_ppex')`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `gwflow.tiles` (Unit: in_gw)
**Line 990:** `open(in_gw,file='gwflow.tiles')`

**Read Structure:**
1. **Line 991** (header, free_format): `read(in_gw,*) header`
   - Variables: header
   - Data types: character
2. **Line 993** (data, free_format): `read(in_gw,*) gw_tile_depth`
   - Variables: gw_tile_depth
   - Data types: real
3. **Line 994** (data, free_format): `read(in_gw,*) gw_tile_drain_area`
   - Variables: gw_tile_drain_area
   - Data types: real
4. **Line 995** (data, free_format): `read(in_gw,*) gw_tile_K`
   - Variables: gw_tile_K
   - Data types: unknown
5. **Line 996** (data, free_format): `read(in_gw,*) gw_tile_group_flag`
   - Variables: gw_tile_group_flag
   - Data types: integer
6. **Line 999** (data, free_format): `read(in_gw,*) gw_tile_num_group`
   - Variables: gw_tile_num_group
   - Data types: integer
7. **Line 1002** (data, free_format): `read(in_gw,*)`
   - Data types: unknown
8. **Line 1003** (data, free_format): `read(in_gw,*) num_tile_cells(i)`
   - Variables: num_tile_cells(i)
   - Data types: integer
9. **Line 1005** (data, free_format): `read(in_gw,*) gw_tile_groups(i,j)`
   - Variables: gw_tile_groups(i, j)
   - Data types: integer, unknown

---

**Filename:** `gwflow_tile_cell_groups` (Unit: out_tile_cells)
**Line 1008:** `open(out_tile_cells,file='gwflow_tile_cell_groups')`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `gwflow_flux_tile` (Unit: out_gw_tile)
**Line 1052:** `open(out_gw_tile,file='gwflow_flux_tile')`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `gwflow.rescells` (Unit: in_res_cell)
**Line 1064:** `open(in_res_cell,file='gwflow.rescells')`

**Read Structure:**
1. **Line 1065** (header, free_format): `read(in_res_cell,*) header`
   - Variables: header
   - Data types: character
2. **Line 1066** (header, free_format): `read(in_res_cell,*) header`
   - Variables: header
   - Data types: character
3. **Line 1068** (data, free_format): `read(in_res_cell,*) res_thick`
   - Variables: res_thick
   - Data types: real
4. **Line 1069** (data, free_format): `read(in_res_cell,*) res_K`
   - Variables: res_K
   - Data types: real
5. **Line 1073** (data, free_format): `read(in_res_cell,*) num_res_cells`
   - Variables: num_res_cells
   - Data types: integer
6. **Line 1074** (header, free_format): `read(in_res_cell,*) header`
   - Variables: header
   - Data types: character
7. **Line 1076** (data, free_format): `read(in_res_cell,*) res_cell,res_id,res_stage`
   - Variables: res_cell, res_id, res_stage
   - Data types: integer, real
8. **Line 1090** (header, free_format): `read(in_res_cell,*) header`
   - Variables: header
   - Data types: character
9. **Line 1091** (header, free_format): `read(in_res_cell,*) header`
   - Variables: header
   - Data types: character
10. **Line 1092** (data, free_format): `read(in_res_cell,*) res_thick`
   - Variables: res_thick
   - Data types: real
11. **Line 1093** (data, free_format): `read(in_res_cell,*) res_K`
   - Variables: res_K
   - Data types: real
12. **Line 1094** (data, free_format): `read(in_res_cell,*) num_res_cells`
   - Variables: num_res_cells
   - Data types: integer
13. **Line 1095** (header, free_format): `read(in_res_cell,*) header`
   - Variables: header
   - Data types: character
14. **Line 1097** (data, free_format): `read(in_res_cell,*) res_cell,res_id,res_stage`
   - Variables: res_cell, res_id, res_stage
   - Data types: integer, real

---

**Filename:** `gwflow_flux_resv` (Unit: out_gw_res)
**Line 1110:** `open(out_gw_res,file='gwflow_flux_resv')`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `gwflow_flux_wetland` (Unit: out_gw_wet)
**Line 1124:** `open(out_gw_wet,file='gwflow_flux_wetland')`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `gwflow.floodplain` (Unit: in_fp_cell)
**Line 1135:** `open(in_fp_cell,file='gwflow.floodplain')`

**Read Structure:**
1. **Line 1136** (header, free_format): `read(in_fp_cell,*) header`
   - Variables: header
   - Data types: character
2. **Line 1137** (data, free_format): `read(in_fp_cell,*) gw_fp_ncells !number of floodplain cells`
   - Variables: gw_fp_ncells !number of floodplain cells
   - Data types: integer
3. **Line 1145** (header, free_format): `read(in_fp_cell,*) header`
   - Variables: header
   - Data types: character
4. **Line 1147** (data, free_format): `read(in_fp_cell,*) gw_fp_cellid(i),gw_fp_chanid(i),gw_fp_K(i),gw_fp_area(i)`
   - Variables: gw_fp_cellid(i), gw_fp_chanid(i), gw_fp_K(i), gw_fp_area(i)
   - Data types: integer, unknown, real

---

**Filename:** `gwflow_flux_floodplain` (Unit: out_gw_fp)
**Line 1182:** `open(out_gw_fp,file='gwflow_flux_floodplain')`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `gwflow.canals` (Unit: in_canal_cell)
**Line 1195:** `open(in_canal_cell,file='gwflow.canals')`

**Read Structure:**
1. **Line 1196** (header, free_format): `read(in_canal_cell,*) header`
   - Variables: header
   - Data types: character
2. **Line 1201** (data, free_format): `read(in_canal_cell,*) gw_ncanal`
   - Variables: gw_ncanal
   - Data types: unknown
3. **Line 1202** (data, free_format): `read(in_canal_cell,*)`
   - Data types: unknown
4. **Line 1206** (data, free_format): `read(in_canal_cell,*) canal,channel,width,depth,thick,day_beg,day_end`
   - Variables: canal, channel, width, depth, thick, day_beg, day_end
   - Data types: integer, unknown, character, real
5. **Line 1230** (header, free_format): `read(in_canal_cell,*) header`
   - Variables: header
   - Data types: character
6. **Line 1231** (data, free_format): `read(in_canal_cell,*) gw_ncanal`
   - Variables: gw_ncanal
   - Data types: unknown
7. **Line 1232** (data, free_format): `read(in_canal_cell,*)`
   - Data types: unknown
8. **Line 1234** (data, free_format): `read(in_canal_cell,*) canal,channel,width,depth,thick,day_beg,day_end`
   - Variables: canal, channel, width, depth, thick, day_beg, day_end
   - Data types: integer, unknown, character, real

---

**Filename:** `gwflow_flux_canl` (Unit: out_gw_canal)
**Line 1341:** `open(out_gw_canal,file='gwflow_flux_canl')`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `gwflow.solutes` (Unit: in_gw)
**Line 1358:** `open(in_gw,file='gwflow.solutes')`

**Read Structure:**
1. **Line 1396** (header, free_format): `read(in_gw,*) header`
   - Variables: header
   - Data types: character
2. **Line 1397** (header, free_format): `read(in_gw,*) header`
   - Variables: header
   - Data types: character
3. **Line 1398** (data, free_format): `read(in_gw,*) num_ts_transport`
   - Variables: num_ts_transport
   - Data types: integer
4. **Line 1399** (data, free_format): `read(in_gw,*) gw_long_disp`
   - Variables: gw_long_disp
   - Data types: unknown
5. **Line 1403** (header, free_format): `read(in_gw,*) header`
   - Variables: header
   - Data types: character
6. **Line 1405** (data, free_format): `read(in_gw,*) name,gwsol_sorb(s),gwsol_rctn(s),canal_out_conc(s)`
   - Variables: name, gwsol_sorb(s), gwsol_rctn(s), canal_out_conc(s)
   - Data types: integer, unknown, character

---

**Filename:** `gwflow.solutes.minerals` (Unit: in_gw_minl)
**Line 1446:** `open(in_gw_minl,file='gwflow.solutes.minerals')`

**Read Structure:**
1. **Line 1447** (header, free_format): `read(in_gw_minl,*) header`
   - Variables: header
   - Data types: character
2. **Line 1448** (data, free_format): `read(in_gw_minl,*) gw_nminl`
   - Variables: gw_nminl
   - Data types: unknown
3. **Line 1455** (header, free_format): `read(in_gw_minl,*) header`
   - Variables: header
   - Data types: character
4. **Line 1459** (header, free_format): `read(in_gw_minl,*) header`
   - Variables: header
   - Data types: character
5. **Line 1460** (data, free_format): `read(in_gw_minl,*) read_type`
   - Variables: read_type
   - Data types: real
6. **Line 1462** (data, free_format): `read(in_gw_minl,*) single_value`
   - Variables: single_value
   - Data types: unknown
7. **Line 1466** (data, free_format): `read(in_gw_minl,*) (grid_val(i,j),j=1,grid_ncol)`
   - Variables: (grid_val(i, j), j=1, grid_ncol)
   - Data types: integer
8. **Line 1480** (data, free_format): `read(in_gw_minl,*) (gwsol_minl_state(i)%fract(m),m=1,gw_nminl)`
   - Variables: (gwsol_minl_state(i)%fract(m), m=1, gw_nminl)
   - Data types: integer, unknown

---

**Filename:** `gwflow_mass_rech` (Unit: out_sol_rech)
**Line 1597:** `open(out_sol_rech,file='gwflow_mass_rech')`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `gwflow_mass_gwsw` (Unit: out_sol_gwsw)
**Line 1604:** `open(out_sol_gwsw,file='gwflow_mass_gwsw')`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `gwflow_mass_soil` (Unit: out_sol_soil)
**Line 1608:** `open(out_sol_soil,file='gwflow_mass_soil')`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `gwflow_mass_satx` (Unit: out_sol_satx)
**Line 1615:** `open(out_sol_satx,file='gwflow_mass_satx')`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `gwflow_mass_ppag` (Unit: out_sol_ppag)
**Line 1619:** `open(out_sol_ppag,file='gwflow_mass_ppag')`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `gwflow_mass_ppex` (Unit: out_sol_ppex)
**Line 1623:** `open(out_sol_ppex,file='gwflow_mass_ppex')`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `gwflow_mass_tile` (Unit: out_sol_tile)
**Line 1628:** `open(out_sol_tile,file='gwflow_mass_tile')`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `gwflow_mass_resv` (Unit: out_sol_resv)
**Line 1633:** `open(out_sol_resv,file='gwflow_mass_resv')`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `gwflow_mass_wetl` (Unit: out_sol_wetl)
**Line 1638:** `open(out_sol_wetl,file='gwflow_mass_wetl')`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `gwflow_mass_fpln` (Unit: out_sol_fpln)
**Line 1643:** `open(out_sol_fpln,file='gwflow_mass_fpln')`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `gwflow_mass_canl` (Unit: out_sol_canl)
**Line 1648:** `open(out_sol_canl,file='gwflow_mass_canl')`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `gwflow_flux_reaction` (Unit: out_gw_chem)
**Line 1652:** `open(out_gw_chem,file='gwflow_flux_reaction')`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `gwflow_state_obs_conc` (Unit: out_gwobs_sol)
**Line 1655:** `open(out_gwobs_sol,file='gwflow_state_obs_conc')`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `gwflow.lsucell` (Unit: in_lsu_cell)
**Line 1674:** `open(in_lsu_cell,file='gwflow.lsucell')`

**Read Structure:**
1. **Line 1675** (header, free_format): `read(in_lsu_cell,*) header`
   - Variables: header
   - Data types: character
2. **Line 1677** (data, free_format): `read(in_lsu_cell,*) nlsu !number of LSUs in the model`
   - Variables: nlsu !number of LSUs in the model
   - Data types: integer
3. **Line 1678** (data, free_format): `read(in_lsu_cell,*) nlsu_connected !number of LSUs spatially connected to grid cells`
   - Variables: nlsu_connected !number of LSUs spatially connected to grid cells
   - Data types: integer
4. **Line 1682** (data, free_format): `read(in_lsu_cell,*) lsu_id`
   - Variables: lsu_id
   - Data types: integer
5. **Line 1686** (header, free_format): `read(in_lsu_cell,*) header`
   - Variables: header
   - Data types: character
6. **Line 1687** (header, free_format): `read(in_lsu_cell,*) header`
   - Variables: header
   - Data types: character
7. **Line 1700** (data, free_format): `read(in_lsu_cell,*) lsu,lsu_area,lsu_cells(k,cell_count),poly_area`
   - Variables: lsu, lsu_area, lsu_cells(k, cell_count), poly_area
   - Data types: unknown, character, real
8. **Line 1709** (data, free_format): `read(in_lsu_cell,*,end=25) lsu`
   - Variables: lsu
   - Data types: unknown

---

**Filename:** `out.key` (Unit: 5100)
**Line 1724:** `open(5100,file='out.key')`

**Read Structure:**
1. **Line 1726** (data, free_format): `read(5100,*)`
   - Data types: unknown
2. **Line 1727** (data, free_format): `read(5100,*)`
   - Data types: unknown
3. **Line 1729** (data, free_format): `read(5100,*) dum1,huc12(k)`
   - Variables: dum1, huc12(k)
   - Data types: unknown

---

**Filename:** `gwflow.hrucell` (Unit: in_hru_cell)
**Line 1755:** `open(in_hru_cell,file='gwflow.hrucell')`

**Read Structure:**
1. **Line 1756** (data, free_format): `read(in_hru_cell,*)`
   - Data types: unknown
2. **Line 1757** (data, free_format): `read(in_hru_cell,*)`
   - Data types: unknown
3. **Line 1758** (data, free_format): `read(in_hru_cell,*)`
   - Data types: unknown
4. **Line 1760** (data, free_format): `read(in_hru_cell,*) nhru_connected !number of HRUs spatially connected to grid cells`
   - Variables: nhru_connected !number of HRUs spatially connected to grid cells
   - Data types: integer
5. **Line 1764** (data, free_format): `read(in_hru_cell,*) hru_id`
   - Variables: hru_id
   - Data types: integer
6. **Line 1768** (data, free_format): `read(in_hru_cell,*)`
   - Data types: unknown
7. **Line 1769** (data, free_format): `read(in_hru_cell,*)`
   - Data types: unknown
8. **Line 1783** (data, free_format): `read(in_hru_cell,*) hru_id,hru_area,hru_cells(k,cell_count),poly_area`
   - Variables: hru_id, hru_area, hru_cells(k, cell_count), poly_area
   - Data types: integer, unknown, character, real
9. **Line 1796** (data, free_format): `read(in_hru_cell,*,end=10) hru_id`
   - Variables: hru_id
   - Data types: integer

---

**Filename:** `gwflow.huc12cell` (Unit: in_huc_cell)
**Line 1808:** `open(in_huc_cell,file='gwflow.huc12cell')`

**Read Structure:**
1. **Line 1809** (data, free_format): `read(in_huc_cell,*)`
   - Data types: unknown
2. **Line 1810** (data, free_format): `read(in_huc_cell,*)`
   - Data types: unknown
3. **Line 1812** (data, free_format): `read(in_huc_cell,*)`
   - Data types: unknown
4. **Line 1814** (data, free_format): `read(in_huc_cell,*) huc12_dum,huc12_connect(k)`
   - Variables: huc12_dum, huc12_connect(k)
   - Data types: unknown
5. **Line 1823** (data, free_format): `read(in_huc_cell,*)`
   - Data types: unknown
6. **Line 1824** (data, free_format): `read(in_huc_cell,*)`
   - Data types: unknown
7. **Line 1827** (data, free_format): `read(in_huc_cell,*) huc12_id`
   - Variables: huc12_id
   - Data types: integer
8. **Line 1831** (data, free_format): `read(in_huc_cell,*) huc12_id,cell_num`
   - Variables: huc12_id, cell_num
   - Data types: integer
9. **Line 1854** (data, free_format): `read(in_huc_cell,*,end=20) huc12_id`
   - Variables: huc12_id
   - Data types: integer

---

**Filename:** `gwflow.cellhru` (Unit: in_cell_hru)
**Line 1869:** `open(in_cell_hru,file='gwflow.cellhru')`

**Read Structure:**
1. **Line 1870** (data, free_format): `read(in_cell_hru,*)`
   - Data types: unknown
2. **Line 1871** (data, free_format): `read(in_cell_hru,*)`
   - Data types: unknown
3. **Line 1872** (data, free_format): `read(in_cell_hru,*) num_unique !number of cells that intersect HRUs`
   - Variables: num_unique !number of cells that intersect HRUs
   - Data types: integer
4. **Line 1873** (data, free_format): `read(in_cell_hru,*)`
   - Data types: unknown
5. **Line 1875** (data, free_format): `read(in_cell_hru,*) hru_cell`
   - Variables: hru_cell
   - Data types: unknown
6. **Line 1884** (data, free_format): `read(in_cell_hru,*) cell_num,hru_id,cell_area,poly_area`
   - Variables: cell_num, hru_id, cell_area, poly_area
   - Data types: integer, real
7. **Line 1890** (data, free_format): `read(in_cell_hru,*,end=30) cell_num`
   - Variables: cell_num
   - Data types: integer

---

**Filename:** `gwflow_balance_gw_day` (Unit: out_gwbal)
**Line 1910:** `open(out_gwbal,file='gwflow_balance_gw_day')`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `gwflow_balance_gw_yr` (Unit: out_gwbal_yr)
**Line 1949:** `open(out_gwbal_yr,file='gwflow_balance_gw_yr')`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `gwflow_balance_gw_aa` (Unit: out_gwbal_aa)
**Line 1982:** `open(out_gwbal_aa,file='gwflow_balance_gw_aa')`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `gwflow_balance_huc12` (Unit: out_huc12wb)
**Line 2016:** `open(out_huc12wb,file='gwflow_balance_huc12')`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `gwflow_balance_huc12_mon` (Unit: out_huc12wb_mo)
**Line 2044:** `open(out_huc12wb_mo,file='gwflow_balance_huc12_mon')`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `gwflow_state_head` (Unit: out_gwheads)
**Line 2321:** `open(out_gwheads,file='gwflow_state_head')`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `gwflow_state_conc` (Unit: out_gwconc)
**Line 2340:** `open(out_gwconc,file='gwflow_state_conc')`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `gwflow_state_head_mo` (Unit: out_head_mo)
**Line 2365:** `open(out_head_mo,file='gwflow_state_head_mo')`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `gwflow_state_head_yr` (Unit: out_head_yr)
**Line 2366:** `open(out_head_yr,file='gwflow_state_head_yr')`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `gwflow_state_conc_mo` (Unit: out_conc_mo)
**Line 2375:** `open(out_conc_mo,file='gwflow_state_conc_mo')`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `gwflow_state_conc_yr` (Unit: out_conc_yr)
**Line 2376:** `open(out_conc_yr,file='gwflow_state_conc_yr')`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `gwflow.streamobs` (Unit: in_str_obs)
**Line 2387:** `open(in_str_obs,file='gwflow.streamobs')`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `gwflow_state_obs_flow` (Unit: out_strobs)
**Line 2388:** `open(out_strobs,file='gwflow_state_obs_flow')`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `gwflow_state_hydsep` (Unit: out_hyd_sep)
**Line 2420:** `open(out_hyd_sep,file='gwflow_state_hydsep')`

**Read Structure:** No read operations found (likely output file)

---

### File: `plant_transplant_read.f90`

**Filename:** `transplant.plt` (Unit: 104)
**Line 24:** `open (104,file="transplant.plt")`

**Read Structure:**
1. **Line 25** (data, free_format): `read (104,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
2. **Line 27** (header, free_format): `read (104,*,iostat=eof) header`
   - Variables: header
   - Data types: character
3. **Line 30** (data, free_format): `read (104,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
4. **Line 37** (data, free_format): `read (104,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
5. **Line 39** (header, free_format): `read (104,*,iostat=eof) header`
   - Variables: header
   - Data types: character
6. **Line 43** (data, free_format): `read (104,*,iostat=eof) transpl(ic)`
   - Variables: transpl(ic)
   - Data types: unknown

---

### File: `header_yield.f90`

**Filename:** `yield.out` (Unit: 4700)
**Line 10:** `open (4700,file="yield.out", recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `yield.csv` (Unit: 4701)
**Line 13:** `open (4701,file="yield.csv", recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_crop_yld_yr.txt` (Unit: 5100)
**Line 21:** `open (5100,file="basin_crop_yld_yr.txt", recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_crop_yld_aa.txt` (Unit: 5101)
**Line 25:** `open (5101,file="basin_crop_yld_aa.txt", recl=800)`

**Read Structure:** No read operations found (likely output file)

---

### File: `header_reservoir.f90`

**Filename:** `reservoir_sed.txt` (Unit: 7777)
**Line 10:** `open (7777,file="reservoir_sed.txt",recl=1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `reservoir_day.txt` (Unit: 2540)
**Line 14:** `open (2540,file="reservoir_day.txt",recl=1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `reservoir_day.csv` (Unit: 2544)
**Line 20:** `open (2544,file="reservoir_day.csv",recl=1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `reservoir_mon.txt` (Unit: 2541)
**Line 29:** `open (2541,file="reservoir_mon.txt",recl=1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `reservoir_mon.csv` (Unit: 2545)
**Line 35:** `open (2545,file="reservoir_mon.csv",recl=1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `reservoir_yr.txt` (Unit: 2542)
**Line 44:** `open (2542,file="reservoir_yr.txt",recl=1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `reservoir_yr.csv` (Unit: 2546)
**Line 50:** `open (2546,file="reservoir_yr.csv",recl=1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `reservoir_aa.txt` (Unit: 2543)
**Line 59:** `open (2543,file="reservoir_aa.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `reservoir_aa.csv` (Unit: 2547)
**Line 65:** `open (2547,file="reservoir_aa.csv",recl=1500)`

**Read Structure:** No read operations found (likely output file)

---

### File: `res_read_salt.f90`

**Filename:** `salt_res` (Unit: 105)
**Line 31:** `open (105,file="salt_res")`

**Read Structure:**
1. **Line 32** (data, free_format): `read (105,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
2. **Line 33** (data, free_format): `read (105,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
3. **Line 35** (data, free_format): `read(105,*)`
   - Data types: unknown
4. **Line 39** (header, free_format): `read (105,*,iostat=eof) header`
   - Variables: header
   - Data types: character
5. **Line 42** (data, free_format): `read (105,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
6. **Line 54** (data, free_format): `read (105,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
7. **Line 56** (data, free_format): `read (105,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
8. **Line 58** (data, free_format): `read(105,*)`
   - Data types: unknown
9. **Line 60** (header, free_format): `read (105,*,iostat=eof) header`
   - Variables: header
   - Data types: character
10. **Line 64** (data, free_format): `read (105,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
11. **Line 67** (data, free_format): `read (105,*,iostat=eof) res_salt_data(ires)%name,res_salt_data(ires)%c_init`
   - Variables: res_salt_data(ires)%name, res_salt_data(ires)%c_init
   - Data types: real

---

### File: `manure_allocation_read.f90`

**Filename:** `manure_allo.mnu` (Unit: 107)
**Line 39:** `open (107,file="manure_allo.mnu")`

**Read Structure:**
1. **Line 40** (data, free_format): `read (107,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
2. **Line 42** (data, free_format): `read (107,*,iostat=eof) imax`
   - Variables: imax
   - Data types: integer
3. **Line 49** (header, free_format): `read (107,*,iostat=eof) header`
   - Variables: header
   - Data types: character
4. **Line 51** (data, free_format): `read (107,*,iostat=eof) mallo(imro)%name, mallo(imro)%rule_typ, mallo(imro)%src_obs, &`
   - Variables: mallo(imro)%name, mallo(imro)%rule_typ, mallo(imro)%src_obs, &
   - Data types: integer, unknown
5. **Line 54** (header, free_format): `read (107,*,iostat=eof) header`
   - Variables: header
   - Data types: character
6. **Line 63** (data, free_format): `read (107,*,iostat=eof) i`
   - Variables: i
   - Data types: integer
7. **Line 67** (data, free_format): `read (107,*,iostat=eof) k, mallo(imro)%src(i)%mois_typ, mallo(imro)%src(i)%manure_typ,      &`
   - Variables: k, mallo(imro)%src(i)%mois_typ, mallo(imro)%src(i)%manure_typ, &
   - Data types: integer, unknown
8. **Line 81** (header, free_format): `read (107,*,iostat=eof) header`
   - Variables: header
   - Data types: character

---

### File: `header_water_allocation.f90`

**Filename:** `water_allo_day.txt` (Unit: 3110)
**Line 12:** `open (3110,file="water_allo_day.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `water_allo_day.csv` (Unit: 3114)
**Line 18:** `open (3114,file="water_allo_day.csv",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `water_allo_mon.txt` (Unit: 3111)
**Line 29:** `open (3111,file="water_allo_mon.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `water_allo_mon.csv` (Unit: 3115)
**Line 35:** `open (3115,file="water_allo_mon.csv",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `water_allo_yr.txt` (Unit: 3112)
**Line 46:** `open (3112,file="water_allo_yr.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `water_allo_yr.csv` (Unit: 3116)
**Line 52:** `open (3116,file="water_allo_yr.csv",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `water_allo_aa.txt` (Unit: 3113)
**Line 63:** `open (3113,file="water_allo_aa.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `water_allo_aa.csv` (Unit: 3117)
**Line 69:** `open (3117,file="water_allo_aa.csv",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

### File: `cs_cha_read.f90`

**Filename:** `cs_channel.ini` (Unit: 107)
**Line 28:** `open (107,file="cs_channel.ini")`

**Read Structure:**
1. **Line 29** (data, free_format): `read (107,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
2. **Line 31** (header, free_format): `read (107,*,iostat=eof) header`
   - Variables: header
   - Data types: character
3. **Line 35** (data, free_format): `read (107,*,iostat=eof) titldum   !name`
   - Variables: titldum   !name
   - Data types: character
4. **Line 49** (data, free_format): `read (107,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
5. **Line 52** (header, free_format): `read (107,*,iostat=eof) header`
   - Variables: header
   - Data types: character
6. **Line 55** (data, free_format): `read (107,*,iostat=eof) cs_cha_ini(icsi)%name,cs_cha_ini(icsi)%conc`
   - Variables: cs_cha_ini(icsi)%name, cs_cha_ini(icsi)%conc
   - Data types: character

---

**Filename:** `cs_streamobs` (Unit: 107)
**Line 66:** `open(107,file='cs_streamobs')`

**Read Structure:**
1. **Line 67** (data, free_format): `read(107,*)`
   - Data types: unknown
2. **Line 68** (data, free_format): `read(107,*) cs_str_nobs`
   - Variables: cs_str_nobs
   - Data types: character
3. **Line 71** (data, free_format): `read(107,*) cs_str_obs(i)`
   - Variables: cs_str_obs(i)
   - Data types: character

---

**Filename:** `cs_streamobs_output` (Unit: 8200)
**Line 74:** `open(8200,file='cs_streamobs_output')`

**Read Structure:** No read operations found (likely output file)

---

### File: `res_read_salt_cs.f90`

**Filename:** `reservoir.res_cs` (Unit: 105)
**Line 31:** `open(105,file="reservoir.res_cs")`

**Read Structure:**
1. **Line 32** (header, free_format): `read(105,*) header`
   - Variables: header
   - Data types: character
2. **Line 33** (header, free_format): `read(105,*) header`
   - Variables: header
   - Data types: character
3. **Line 40** (data, free_format): `read (105,*,iostat=eof) ires`
   - Variables: ires
   - Data types: integer
4. **Line 43** (data, free_format): `read (105,*,iostat=eof) k, res_dat_c_cs(ires)`
   - Variables: k, res_dat_c_cs(ires)
   - Data types: integer, real

---

### File: `ch_read_elements.f90`

**Filename:** `element.ccu` (Unit: 107)
**Line 143:** `open (107,file="element.ccu")`

**Read Structure:**
1. **Line 144** (data, free_format): `read (107,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
2. **Line 146** (header, free_format): `read (107,*,iostat=eof) header`
   - Variables: header
   - Data types: character
3. **Line 150** (data, free_format): `read (107,*,iostat=eof) i`
   - Variables: i
   - Data types: integer
4. **Line 158** (data, free_format): `read (107,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
5. **Line 160** (header, free_format): `read (107,*,iostat=eof) header`
   - Variables: header
   - Data types: character
6. **Line 164** (data, free_format): `read (107,*,iostat=eof) i`
   - Variables: i
   - Data types: integer
7. **Line 167** (data, free_format): `read (107,*,iostat=eof) k, ccu_elem(i)%name, ccu_elem(i)%obtyp, ccu_elem(i)%obtypno,      &`
   - Variables: k, ccu_elem(i)%name, ccu_elem(i)%obtyp, ccu_elem(i)%obtypno, &
   - Data types: integer, unknown, character

---

### File: `proc_hru.f90`

**Filename:** `erosion.out` (Unit: 4001)
**Line 46:** `open (4001,file = "erosion.out",recl=1200)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `checker.out` (Unit: 4000)
**Line 52:** `open (4000,file = "checker.out",recl=1200)`

**Read Structure:** No read operations found (likely output file)

---

### File: `cli_read_atmodep_cs.f90`

**Filename:** `cs_atmo.cli` (Unit: 5050)
**Line 37:** `open(5050,file='cs_atmo.cli')`

**Read Structure:**
1. **Line 38** (data, free_format): `read(5050,*)`
   - Data types: unknown
2. **Line 39** (data, free_format): `read(5050,*)`
   - Data types: unknown
3. **Line 40** (data, free_format): `read(5050,*)`
   - Data types: unknown
4. **Line 53** (data, free_format): `read(5050,*) station_name !station name --> already read in cli_read_atmodep`
   - Variables: station_name !station name --> already read in cli_read_atmodep
   - Data types: character
5. **Line 56** (data, free_format): `read(5050,*) atmodep_cs(iadep)%cs(ics)%rf`
   - Variables: atmodep_cs(iadep)%cs(ics)%rf
   - Data types: unknown
6. **Line 60** (data, free_format): `read(5050,*) atmodep_cs(iadep)%cs(ics)%dry`
   - Variables: atmodep_cs(iadep)%cs(ics)%dry
   - Data types: unknown
7. **Line 66** (data, free_format): `read(5050,*) station_name !station name`
   - Variables: station_name !station name
   - Data types: character
8. **Line 72** (data, free_format): `read(5050,*) (atmodep_cs(iadep)%cs(ics)%rfmo(imo),imo=1,atmodep_cont%num)`
   - Variables: (atmodep_cs(iadep)%cs(ics)%rfmo(imo), imo=1, atmodep_cont%num)
   - Data types: integer, unknown
9. **Line 79** (data, free_format): `read(5050,*) (atmodep_cs(iadep)%cs(ics)%drymo(imo),imo=1,atmodep_cont%num)`
   - Variables: (atmodep_cs(iadep)%cs(ics)%drymo(imo), imo=1, atmodep_cont%num)
   - Data types: integer, unknown
10. **Line 85** (data, free_format): `read(5050,*) station_name !station name`
   - Variables: station_name !station name
   - Data types: character

---

### File: `header_path.f90`

**Filename:** `hru_path_day.txt` (Unit: 2790)
**Line 11:** `open (2790,file="hru_path_day.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_path_day.csv` (Unit: 2794)
**Line 17:** `open (2794,file="hru_path_day.csv",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_path_mon.txt` (Unit: 2791)
**Line 26:** `open (2791,file="hru_path_mon.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_path_mon.csv` (Unit: 2795)
**Line 32:** `open (2795,file="hru_path_mon.csv",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_path_yr.txt` (Unit: 2792)
**Line 41:** `open (2792,file="hru_path_yr.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_path_yr.csv` (Unit: 2796)
**Line 47:** `open (2796,file="hru_path_yr.csv",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_path_aa.txt` (Unit: 2793)
**Line 56:** `open (2793,file="hru_path_aa.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_path_aa.csv` (Unit: 2797)
**Line 62:** `open (2797,file="hru_path_aa.csv",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

### File: `header_const.f90`

**Filename:** `basin_cs_day.txt` (Unit: 6080)
**Line 17:** `open (6080,file="basin_cs_day.txt", recl = 2000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_cs_mon.txt` (Unit: 6082)
**Line 60:** `open (6082,file="basin_cs_mon.txt", recl = 2000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_cs_yr.txt` (Unit: 6084)
**Line 103:** `open (6084,file="basin_cs_yr.txt", recl = 2000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_cs_aa.txt` (Unit: 6086)
**Line 146:** `open (6086,file="basin_cs_aa.txt", recl = 2000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_cs_day.txt` (Unit: 6021)
**Line 189:** `open (6021,file="hru_cs_day.txt", recl = 3000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_cs_day.csv` (Unit: 6022)
**Line 221:** `open (6022,file="hru_cs_day.csv", recl = 3000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_cs_mon.txt` (Unit: 6023)
**Line 230:** `open (6023,file="hru_cs_mon.txt", recl = 3000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_cs_mon.csv` (Unit: 6024)
**Line 262:** `open (6024,file="hru_cs_mon.csv", recl = 3000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_cs_yr.txt` (Unit: 6025)
**Line 271:** `open (6025,file="hru_cs_yr.txt", recl = 3000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_cs_yr.csv` (Unit: 6026)
**Line 303:** `open (6026,file="hru_cs_yr.csv", recl = 3000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_cs_aa.txt` (Unit: 6027)
**Line 312:** `open (6027,file="hru_cs_aa.txt", recl = 3000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_cs_aa.csv` (Unit: 6028)
**Line 344:** `open (6028,file="hru_cs_aa.csv", recl = 3000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `aquifer_cs_day.txt` (Unit: 6060)
**Line 354:** `open (6060,file="aquifer_cs_day.txt",recl=2000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `aquifer_cs_day.csv` (Unit: 6061)
**Line 375:** `open (6061,file="aquifer_cs_day.csv",recl=2000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `aquifer_cs_mon.txt` (Unit: 6062)
**Line 386:** `open (6062,file="aquifer_cs_mon.txt",recl=2000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `aquifer_cs_mon.csv` (Unit: 6063)
**Line 407:** `open (6063,file="aquifer_cs_mon.csv",recl=2000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `aquifer_cs_yr.txt` (Unit: 6064)
**Line 418:** `open (6064,file="aquifer_cs_yr.txt",recl=2000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `aquifer_cs_yr.csv` (Unit: 6065)
**Line 439:** `open (6065,file="aquifer_cs_yr.csv",recl=2000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `aquifer_cs_aa.txt` (Unit: 6066)
**Line 450:** `open (6066,file="aquifer_cs_aa.txt",recl=2000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `aquifer_cs_aa.csv` (Unit: 6067)
**Line 471:** `open (6067,file="aquifer_cs_aa.csv",recl=2000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `channel_cs_day.txt` (Unit: 6030)
**Line 482:** `open (6030,file="channel_cs_day.txt",recl=2000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `channel_cs_day.csv` (Unit: 6031)
**Line 501:** `open (6031,file="channel_cs_day.csv",recl=2000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `channel_cs_mon.txt` (Unit: 6032)
**Line 511:** `open (6032,file="channel_cs_mon.txt",recl=2000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `channel_cs_mon.csv` (Unit: 6033)
**Line 530:** `open (6033,file="channel_cs_mon.csv",recl=2000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `channel_cs_yr.txt` (Unit: 6034)
**Line 540:** `open (6034,file="channel_cs_yr.txt",recl=2000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `channel_cs_yr.csv` (Unit: 6035)
**Line 559:** `open (6035,file="channel_cs_yr.csv",recl=2000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `channel_cs_aa.txt` (Unit: 6036)
**Line 569:** `open (6036,file="channel_cs_aa.txt",recl=2000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `channel_cs_aa.csv` (Unit: 6037)
**Line 588:** `open (6037,file="channel_cs_aa.csv",recl=2000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `reservoir_cs_day.txt` (Unit: 6040)
**Line 598:** `open (6040,file="reservoir_cs_day.txt",recl=2000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `reservoir_cs_day.csv` (Unit: 6041)
**Line 621:** `open (6041,file="reservoir_cs_day.csv",recl=2000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `reservoir_cs_mon.txt` (Unit: 6042)
**Line 631:** `open (6042,file="reservoir_cs_mon.txt",recl=2000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `reservoir_cs_mon.csv` (Unit: 6043)
**Line 654:** `open (6043,file="reservoir_cs_mon.csv",recl=2000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `reservoir_cs_yr.txt` (Unit: 6044)
**Line 664:** `open (6044,file="reservoir_cs_yr.txt",recl=2000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `reservoir_cs_yr.csv` (Unit: 6045)
**Line 687:** `open (6045,file="reservoir_cs_yr.csv",recl=2000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `reservoir_cs_aa.txt` (Unit: 6046)
**Line 697:** `open (6046,file="reservoir_cs_aa.txt",recl=2000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `reservoir_cs_aa.csv` (Unit: 6047)
**Line 720:** `open (6047,file="reservoir_cs_aa.csv",recl=2000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `rout_unit_cs_day.txt` (Unit: 6070)
**Line 730:** `open (6070,file="rout_unit_cs_day.txt",recl=2000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `rout_unit_cs_day.csv` (Unit: 6071)
**Line 757:** `open (6071,file="rout_unit_cs_day.csv",recl=2000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `rout_unit_cs_mon.txt` (Unit: 6072)
**Line 768:** `open (6072,file="rout_unit_cs_mon.txt",recl=2000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `rout_unit_cs_mon.csv` (Unit: 6073)
**Line 795:** `open (6073,file="rout_unit_cs_mon.csv",recl=2000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `rout_unit_cs_yr.txt` (Unit: 6074)
**Line 806:** `open (6074,file="rout_unit_cs_yr.txt",recl=2000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `rout_unit_cs_yr.csv` (Unit: 6075)
**Line 833:** `open (6075,file="rout_unit_cs_yr.csv",recl=2000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `rout_unit_cs_aa.txt` (Unit: 6076)
**Line 844:** `open (6076,file="rout_unit_cs_aa.txt",recl=2000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `rout_unit_cs_aa.csv` (Unit: 6077)
**Line 871:** `open (6077,file="rout_unit_cs_aa.csv",recl=2000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `wetland_cs_day.txt` (Unit: 6090)
**Line 882:** `open (6090,file="wetland_cs_day.txt",recl=2000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `wetland_cs_day.csv` (Unit: 6091)
**Line 904:** `open (6091,file="wetland_cs_day.csv",recl=2000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `wetland_cs_mon.txt` (Unit: 6092)
**Line 914:** `open (6092,file="wetland_cs_mon.txt",recl=2000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `wetland_cs_mon.csv` (Unit: 6093)
**Line 936:** `open (6093,file="wetland_cs_mon.csv",recl=2000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `wetland_cs_yr.txt` (Unit: 6094)
**Line 946:** `open (6094,file="wetland_cs_yr.txt",recl=2000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `wetland_cs_yr.csv` (Unit: 6095)
**Line 968:** `open (6095,file="wetland_cs_yr.csv",recl=2000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `wetland_cs_aa.txt` (Unit: 6096)
**Line 978:** `open (6096,file="wetland_cs_aa.txt",recl=2000)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `wetland_cs_aa.csv` (Unit: 6097)
**Line 1000:** `open (6097,file="wetland_cs_aa.csv",recl=2000)`

**Read Structure:** No read operations found (likely output file)

---

### File: `header_pest.f90`

**Filename:** `hru_pest_day.txt` (Unit: 2800)
**Line 17:** `open (2800,file="hru_pest_day.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_pest_day.csv` (Unit: 2804)
**Line 23:** `open (2804,file="hru_pest_day.csv",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_pest_mon.txt` (Unit: 2801)
**Line 32:** `open (2801,file="hru_pest_mon.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_pest_mon.csv` (Unit: 2805)
**Line 38:** `open (2805,file="hru_pest_mon.csv",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_pest_yr.txt` (Unit: 2802)
**Line 47:** `open (2802,file="hru_pest_yr.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_pest_yr.csv` (Unit: 2806)
**Line 53:** `open (2806,file="hru_pest_yr.csv",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_pest_aa.txt` (Unit: 2803)
**Line 62:** `open (2803,file="hru_pest_aa.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `hru_pest_aa.csv` (Unit: 2807)
**Line 68:** `open (2807,file="hru_pest_aa.csv",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `channel_pest_day.txt` (Unit: 2808)
**Line 81:** `open (2808,file="channel_pest_day.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `channel_pest_day.csv` (Unit: 2812)
**Line 87:** `open (2812,file="channel_pest_day.csv",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `channel_pest_mon.txt` (Unit: 2809)
**Line 96:** `open (2809,file="channel_pest_mon.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `channel_pest_mon.csv` (Unit: 2813)
**Line 102:** `open (2813,file="channel_pest_mon.csv",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `channel_pest_yr.txt` (Unit: 2810)
**Line 111:** `open (2810,file="channel_pest_yr.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `channel_pest_yr.csv` (Unit: 2814)
**Line 117:** `open (2814,file="channel_pest_yr.csv",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `channel_pest_aa.txt` (Unit: 2811)
**Line 126:** `open (2811,file="channel_pest_aa.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `channel_pest_aa.csv` (Unit: 2815)
**Line 132:** `open (2815,file="channel_pest_aa.csv",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `reservoir_pest_day.txt` (Unit: 2816)
**Line 145:** `open (2816,file="reservoir_pest_day.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `reservoir_pest_day.csv` (Unit: 2820)
**Line 151:** `open (2820,file="reservoir_pest_day.csv",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `reservoir_pest_mon.txt` (Unit: 2817)
**Line 160:** `open (2817,file="reservoir_pest_mon.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `reservoir_pest_mon.csv` (Unit: 2821)
**Line 166:** `open (2821,file="reservoir_pest_mon.csv",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `reservoir_pest_yr.txt` (Unit: 2818)
**Line 175:** `open (2818,file="reservoir_pest_yr.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `reservoir_pest_yr.csv` (Unit: 2822)
**Line 181:** `open (2822,file="reservoir_pest_yr.csv",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `reservoir_pest_aa.txt` (Unit: 2819)
**Line 190:** `open (2819,file="reservoir_pest_aa.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `reservoir_pest_aa.csv` (Unit: 2823)
**Line 196:** `open (2823,file="reservoir_pest_aa.csv",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_aqu_pest_day.txt` (Unit: 3000)
**Line 209:** `open (3000,file="basin_aqu_pest_day.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_aqu_pest_day.csv` (Unit: 3004)
**Line 215:** `open (3004,file="basin_aqu_pest_day.csv",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_aqu_pest_mon.txt` (Unit: 3001)
**Line 224:** `open (3001,file="basin_aqu_pest_mon.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_aqu_pest_mon.csv` (Unit: 3005)
**Line 230:** `open (3005,file="basin_aqu_pest_mon.csv",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_aqu_pest_yr.txt` (Unit: 3002)
**Line 239:** `open (3002,file="basin_aqu_pest_yr.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_aqu_pest_yr.csv` (Unit: 3006)
**Line 245:** `open (3006,file="basin_aqu_pest_yr.csv",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_aqu_pest_aa.txt` (Unit: 3003)
**Line 254:** `open (3003,file="basin_aqu_pest_aa.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_aqu_pest_aa.csv` (Unit: 3007)
**Line 260:** `open (3007,file="basin_aqu_pest_aa.csv",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `aquifer_pest_day.txt` (Unit: 3008)
**Line 273:** `open (3008,file="aquifer_pest_day.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `aquifer_pest_day.csv` (Unit: 3012)
**Line 279:** `open (3012,file="aquifer_pest_day.csv",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `aquifer_pest_mon.txt` (Unit: 3009)
**Line 288:** `open (3009,file="aquifer_pest_mon.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `aquifer_pest_mon.csv` (Unit: 3013)
**Line 294:** `open (3013,file="aquifer_pest_mon.csv",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `aquifer_pest_yr.txt` (Unit: 3010)
**Line 303:** `open (3010,file="aquifer_pest_yr.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `aquifer_pest_yr.csv` (Unit: 3014)
**Line 309:** `open (3014,file="aquifer_pest_yr.csv",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `aquifer_pest_aa.txt` (Unit: 3011)
**Line 318:** `open (3011,file="aquifer_pest_aa.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `aquifer_pest_aa.csv` (Unit: 3015)
**Line 324:** `open (3015,file="aquifer_pest_aa.csv",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_ch_pest_day.txt` (Unit: 2832)
**Line 337:** `open (2832,file="basin_ch_pest_day.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_ch_pest_day.csv` (Unit: 2836)
**Line 343:** `open (2836,file="basin_ch_pest_day.csv",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_ch_pest_mon.txt` (Unit: 2833)
**Line 352:** `open (2833,file="basin_ch_pest_mon.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_ch_pest_mon.csv` (Unit: 2837)
**Line 358:** `open (2837,file="basin_ch_pest_mon.csv",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_ch_pest_yr.txt` (Unit: 2834)
**Line 367:** `open (2834,file="basin_ch_pest_yr.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_ch_pest_yr.csv` (Unit: 2838)
**Line 373:** `open (2838,file="basin_ch_pest_yr.csv",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_ch_pest_aa.txt` (Unit: 2835)
**Line 382:** `open (2835,file="basin_ch_pest_aa.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_ch_pest_aa.csv` (Unit: 2839)
**Line 388:** `open (2839,file="basin_ch_pest_aa.csv",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_res_pest_day.txt` (Unit: 2848)
**Line 401:** `open (2848,file="basin_res_pest_day.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_res_pest_day.csv` (Unit: 2852)
**Line 407:** `open (2852,file="basin_res_pest_day.csv",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_res_pest_mon.txt` (Unit: 2849)
**Line 416:** `open (2849,file="basin_res_pest_mon.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_res_pest_mon.csv` (Unit: 2853)
**Line 422:** `open (2853,file="basin_res_pest_mon.csv",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_res_pest_yr.txt` (Unit: 2850)
**Line 431:** `open (2850,file="basin_res_pest_yr.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_res_pest_yr.csv` (Unit: 2854)
**Line 437:** `open (2854,file="basin_res_pest_yr.csv",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_res_pest_aa.txt` (Unit: 2851)
**Line 446:** `open (2851,file="basin_res_pest_aa.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_res_pest_aa.csv` (Unit: 2855)
**Line 452:** `open (2855,file="basin_res_pest_aa.csv",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_ls_pest_day.txt` (Unit: 2864)
**Line 465:** `open (2864,file="basin_ls_pest_day.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_ls_pest_day.csv` (Unit: 2868)
**Line 471:** `open (2868,file="basin_ls_pest_day.csv",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_ls_pest_mon.txt` (Unit: 2865)
**Line 480:** `open (2865,file="basin_ls_pest_mon.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_ls_pest_mon.csv` (Unit: 2869)
**Line 486:** `open (2869,file="basin_ls_pest_mon.csv",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_ls_pest_yr.txt` (Unit: 2866)
**Line 495:** `open (2866,file="basin_ls_pest_yr.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_ls_pest_yr.csv` (Unit: 2870)
**Line 501:** `open (2870,file="basin_ls_pest_yr.csv",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_ls_pest_aa.txt` (Unit: 2867)
**Line 510:** `open (2867,file="basin_ls_pest_aa.txt",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `basin_ls_pest_aa.csv` (Unit: 2871)
**Line 516:** `open (2871,file="basin_ls_pest_aa.csv",recl=800)`

**Read Structure:** No read operations found (likely output file)

---

### File: `recall_read_cs.f90`

**Filename:** `cs_recall.rec` (Unit: 107)
**Line 47:** `open (107,file="cs_recall.rec")`

**Read Structure:**
1. **Line 48** (data, free_format): `read (107,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
2. **Line 50** (header, free_format): `read (107,*,iostat=eof) header`
   - Variables: header
   - Data types: character
3. **Line 56** (data, free_format): `read (107,*,iostat=eof) i`
   - Variables: i
   - Data types: integer

---

### File: `cs_reactions_read.f90`

**Filename:** `cs_reactions` (Unit: 107)
**Line 34:** `open(107,file="cs_reactions")`

**Read Structure:**
1. **Line 35** (data, free_format): `read(107,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
2. **Line 42** (header, free_format): `read(107,*) header`
   - Variables: header
   - Data types: character
3. **Line 43** (data, free_format): `read(107,*) num_rct,num_groups`
   - Variables: num_rct, num_groups
   - Data types: integer
4. **Line 46** (data, free_format): `read(107,*) (rct(icount,igroup),igroup=1,num_groups)`
   - Variables: (rct(icount, igroup), igroup=1, num_groups)
   - Data types: integer, unknown
5. **Line 50** (header, free_format): `read(107,*) header`
   - Variables: header
   - Data types: character
6. **Line 51** (data, free_format): `read(107,*) num_geol_shale`
   - Variables: num_geol_shale
   - Data types: integer
7. **Line 54** (data, free_format): `read(107,*) (rct_shale(icount,irct),irct=1,3)`
   - Variables: (rct_shale(icount, irct), irct=1, 3)
   - Data types: integer, unknown
8. **Line 58** (header, free_format): `read(107,*) header`
   - Variables: header
   - Data types: character
9. **Line 64** (data, free_format): `read(107,*) hru_dum,group,(shale_fractions(ishale),ishale=1,num_geol_shale)`
   - Variables: hru_dum, group, (shale_fractions(ishale), ishale=1, num_geol_shale)
   - Data types: integer, unknown
10. **Line 82** (header, free_format): `read(107,*) header`
   - Variables: header
   - Data types: character

---

### File: `res_read_saltdb.f90`

**Filename:** `salt_res` (Unit: 105)
**Line 31:** `open (105,file="salt_res")`

**Read Structure:**
1. **Line 32** (data, free_format): `read (105,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
2. **Line 33** (data, free_format): `read (105,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
3. **Line 35** (data, free_format): `read(105,*)`
   - Data types: unknown
4. **Line 39** (header, free_format): `read (105,*,iostat=eof) header`
   - Variables: header
   - Data types: character
5. **Line 42** (data, free_format): `read (105,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
6. **Line 54** (data, free_format): `read (105,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
7. **Line 56** (data, free_format): `read (105,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
8. **Line 58** (data, free_format): `read(105,*)`
   - Data types: unknown
9. **Line 60** (header, free_format): `read (105,*,iostat=eof) header`
   - Variables: header
   - Data types: character
10. **Line 64** (data, free_format): `read (105,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
11. **Line 67** (data, free_format): `read (105,*,iostat=eof) res_salt_data(ires)%name,res_salt_data(ires)%c_init`
   - Variables: res_salt_data(ires)%name, res_salt_data(ires)%c_init
   - Data types: real

---

### File: `salt_fert_read.f90`

**Filename:** `salt_fertilizer.frt` (Unit: 107)
**Line 26:** `open (107,file="salt_fertilizer.frt")`

**Read Structure:**
1. **Line 27** (data, free_format): `read (107,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
2. **Line 28** (header, free_format): `read (107,*,iostat=eof) header`
   - Variables: header
   - Data types: character
3. **Line 38** (data, free_format): `read (107,*) fert_salt(isalti)`
   - Variables: fert_salt(isalti)
   - Data types: unknown

---

### File: `mgt_read_puddle.f90`

**Filename:** `puddle.ops` (Unit: 104)
**Line 23:** `open (104,file="puddle.ops")`

**Read Structure:**
1. **Line 24** (data, free_format): `read (104,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
2. **Line 26** (header, free_format): `read (104,*,iostat=eof) header`
   - Variables: header
   - Data types: character
3. **Line 29** (data, free_format): `read (104,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
4. **Line 36** (data, free_format): `read (104,*,iostat=eof) titldum`
   - Variables: titldum
   - Data types: unknown
5. **Line 38** (header, free_format): `read (104,*,iostat=eof) header`
   - Variables: header
   - Data types: character
6. **Line 42** (data, free_format): `read (104,*,iostat=eof) pudl_db(ic)`
   - Variables: pudl_db(ic)
   - Data types: unknown

---

### File: `header_wetland.f90`

**Filename:** `wetland_day.txt` (Unit: 2548)
**Line 11:** `open (2548,file="wetland_day.txt",recl=1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `wetland_day.csv` (Unit: 2552)
**Line 17:** `open (2552,file="wetland_day.csv",recl=1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `wetland_mon.txt` (Unit: 2549)
**Line 27:** `open (2549,file="wetland_mon.txt",recl=1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `wetland_mon.csv` (Unit: 2553)
**Line 33:** `open (2553,file="wetland_mon.csv",recl=1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `wetland_yr.txt` (Unit: 2550)
**Line 43:** `open (2550,file="wetland_yr.txt",recl=1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `wetland_yr.csv` (Unit: 2554)
**Line 49:** `open (2554,file="wetland_yr.csv",recl=1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `wetland_aa.txt` (Unit: 2551)
**Line 60:** `open (2551,file="wetland_aa.txt",recl=1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `wetland_aa.csv` (Unit: 2555)
**Line 66:** `open (2555,file="wetland_aa.csv",recl=1500)`

**Read Structure:** No read operations found (likely output file)

---

### File: `header_sd_channel.f90`

**Filename:** `channel_sd_subday.txt` (Unit: 2508)
**Line 14:** `open (2508,file="channel_sd_subday.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `channel_sd_subday.csv` (Unit: 4814)
**Line 20:** `open (4814,file="channel_sd_subday.csv",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `channel_sd_day.txt` (Unit: 2500)
**Line 29:** `open (2500,file="channel_sd_day.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `channel_sd_day.csv` (Unit: 2504)
**Line 41:** `open (2504,file="channel_sd_day.csv",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `channel_sd_mon.txt` (Unit: 2501)
**Line 58:** `open (2501,file="channel_sd_mon.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `channel_sd_mon.csv` (Unit: 2505)
**Line 71:** `open (2505,file="channel_sd_mon.csv",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `channel_sd_yr.txt` (Unit: 2502)
**Line 88:** `open (2502,file="channel_sd_yr.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `channel_sd_yr.csv` (Unit: 2506)
**Line 101:** `open (2506,file="channel_sd_yr.csv",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `channel_sd_aa.txt` (Unit: 2503)
**Line 118:** `open (2503,file="channel_sd_aa.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `channel_sd_aa.csv` (Unit: 2507)
**Line 131:** `open (2507,file="channel_sd_aa.csv",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `channel_sdmorph_day.txt` (Unit: 4800)
**Line 150:** `open (4800,file="channel_sdmorph_day.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `channel_sdmorph_day.csv` (Unit: 4804)
**Line 156:** `open (4804,file="channel_sdmorph_day.csv",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `channel_sdmorph_mon.txt` (Unit: 4801)
**Line 167:** `open (4801,file="channel_sdmorph_mon.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `channel_mon_sdmorph.csv` (Unit: 4805)
**Line 173:** `open (4805,file="channel_mon_sdmorph.csv",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `channel_sdmorph_yr.txt` (Unit: 4802)
**Line 184:** `open (4802,file="channel_sdmorph_yr.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `channel_sdmorph_yr.csv` (Unit: 4806)
**Line 190:** `open (4806,file="channel_sdmorph_yr.csv",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `channel_sdmorph_aa.txt` (Unit: 4803)
**Line 201:** `open (4803,file="channel_sdmorph_aa.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `channel_sdmorph_aa.csv` (Unit: 4807)
**Line 207:** `open (4807,file="channel_sdmorph_aa.csv",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `sd_chanbud_day.txt` (Unit: 4808)
**Line 219:** `open (4808,file="sd_chanbud_day.txt", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `sd_chanbud_day.csv` (Unit: 4812)
**Line 225:** `open (4812,file="sd_chanbud_day.csv", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `sd_chanbud_mon.txt` (Unit: 4809)
**Line 234:** `open (4809,file="sd_chanbud_mon.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `sd_chanbud_mon.csv` (Unit: 4813)
**Line 240:** `open (4813,file="sd_chanbud_mon.csv",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `sd_chanbud_yr.txt` (Unit: 4810)
**Line 249:** `open (4810,file="sd_chanbud_yr.txt", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `sd_chanbud_yr.csv` (Unit: 4814)
**Line 255:** `open (4814,file="sd_chanbud_yr.csv", recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `sd_chanbud_aa.txt` (Unit: 4811)
**Line 264:** `open (4811,file="sd_chanbud_aa.txt",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

**Filename:** `sd_chanbud_aa.csv` (Unit: 4815)
**Line 270:** `open (4815,file="sd_chanbud_aa.csv",recl = 1500)`

**Read Structure:** No read operations found (likely output file)

---

