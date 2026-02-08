# Schema Extraction - Example Comparisons

## time.sim

### Before (Baseline CSV)
| Position | Swat_code type | Variable | Description |
|----------|----------------|----------|-------------|
| 1 | in_sim | day_start | Beginning Julian day of simulation |
| 2 | in_sim | yrc_start | Beginning year of simulation (for example, 1980) |
| 3 | in_sim | day_end | Ending Julian day of simulation |
| 4 | in_sim | yrc_end | Ending Year of simulation |
| 5 | in_sim | step | Timestep of simulation |

### After (Code-Extracted)
| Position | Swat_code type | Variable | Description |
|----------|----------------|----------|-------------|
| 1 | **time** | day_start | **! beginning julian day of simulation** |
| 2 | **time** | yrc_start | **! starting calendar year** |
| 3 | **time** | day_end | **! input ending julian day of simulation** |
| 4 | **time** | yrc_end | **! ending calendar year** |
| 5 | **time** | step | **! number of time steps in a day for rainfall, runoff and routing** |

**Changes:**
- Swat_code type: `in_sim` → `time` (matches actual code: `time%day_start`, not `in_sim%day_start`)
- Descriptions: Updated from type definition comments in `time_module.f90`

**Code Reference:** `time_read.f90`, line 28:
```fortran
read (107,*,iostat=eof) time%day_start, time%yrc_start, time%day_end, time%yrc_end, time%step
```

---

## hru.con

### Before (Baseline CSV)
| Position | Swat_code type | Variable | Description | Data Type |
|----------|----------------|----------|-------------|-----------|
| 1 | in_con | numb | HRU number | integer |
| 2 | in_con | name | HRU name | string |
| 3 | in_con | gis_id | HRU GIS id | string |
| ... | ... | ... | ... | ... |

### After (Code-Extracted)
| Position | Swat_code type | Variable | Description | Data Type |
|----------|----------------|----------|-------------|-----------|
| 1 | **ob** | **num** | HRU number | integer |
| 2 | **ob** | name | HRU name | string |
| 3 | **ob** | gis_id | HRU GIS id | string |
| 4 | **ob** | **area_ha** | **HRU area** | **numeric** |
| 5 | **ob** | **lat** | **Latitude** | **numeric** |
| 6 | **ob** | **long** | **Longitude** | **numeric** |
| 7 | **ob** | **elev** | **Elevation** | **numeric** |
| 8 | **ob** | **props** | **HRU properties pointer** | **string** |
| 9 | **ob** | **wst_c** | **Weather station pointer** | **string** |
| 10 | **ob** | **constit** | **Constituent pointer** | **string** |
| 11 | **ob** | **props2** | **Properties 2 pointer** | **string** |
| 12 | **ob** | **ruleset** | **Ruleset pointer** | **string** |
| 13 | **ob** | **src_tot** | **Total number of sources** | **integer** |

**Changes:**
- Complete schema replacement (18 old rows → 13 new rows)
- Swat_code type: `in_con` → `ob` (matches code structure)
- Variable names: `numb` → `num` (matches actual code variable)
- Added fields: area_ha, lat, long, elev, props, wst_c, constit, props2, ruleset, src_tot

**Code Reference:** `hyd_read_connect.f90`, lines 220-221:
```fortran
read (107,*,iostat=eof) ob(i)%num, ob(i)%name, ob(i)%gis_id, ob(i)%area_ha, ob(i)%lat, ob(i)%long, &
  ob(i)%elev, ob(i)%props, ob(i)%wst_c, ob(i)%constit, ob(i)%props2, ob(i)%ruleset, ob(i)%src_tot
```

---

## plant.ini

### Before (Baseline CSV)
Incomplete schema - only 12 rows representing community header fields.

### After (Code-Extracted)

**Community Header (Line 3):**
| Position | Swat_code type | Variable | Description | Data Type |
|----------|----------------|----------|-------------|-----------|
| 1 | pcomdb | name | Plant community name | string |
| 2 | pcomdb | plants_com | Number of plants in community | integer |
| 3 | pcomdb | rot_yr_ini | Initial rotation year | integer |

**Plant Details (Line 4, repeated for each plant):**
| Position | Swat_code type | Variable | Description | Data Type |
|----------|----------------|----------|-------------|-----------|
| 1 | pcomdb%pl | cpnm | Plant name | string |
| 2 | pcomdb%pl | igro | Land cover status code | integer |
| 3 | pcomdb%pl | lai | Initial leaf area index | numeric |
| 4 | pcomdb%pl | bioms | Initial biomass | numeric |
| 5 | pcomdb%pl | phuacc | Initial accumulated heat units | numeric |
| 6 | pcomdb%pl | pop | Initial plant population | numeric |
| 7 | pcomdb%pl | fr_yrmat | Fraction of years to maturity | numeric |
| 8 | pcomdb%pl | rsdin | Initial residue | numeric |

**Changes:**
- Two-level schema structure now properly represented
- Community header vs plant detail distinction
- `pcomdb` for community, `pcomdb%pl` for plant items

**Code Reference:** `readpcom.f90`, lines 62, 68-70:
```fortran
read (113,*,iostat=eof) pcomdb(icom)%name, pcomdb(icom)%plants_com, pcomdb(icom)%rot_yr_ini

read (113,*,iostat=eof) pcomdb(icom)%pl(iplt)%cpnm, pcomdb(icom)%pl(iplt)%igro, &
  pcomdb(icom)%pl(iplt)%lai, pcomdb(icom)%pl(iplt)%bioms, pcomdb(icom)%pl(iplt)%phuacc, &
  pcomdb(icom)%pl(iplt)%pop, pcomdb(icom)%pl(iplt)%fr_yrmat, pcomdb(icom)%pl(iplt)%rsdin
```

---

## hyd-sed-lte.cha

### Before (Baseline CSV)
Incomplete schema - 24 rows but missing proper variable mapping.

### After (Code-Extracted)

All 20 fields from `swatdeg_hydsed_data` type:

| Position | Variable | Description | Units | Data Type |
|----------|----------|-------------|-------|-----------|
| 1 | name | | | string |
| 2 | order | | | integer |
| 3 | chw | channel width | m | numeric |
| 4 | chd | channel depth | m | numeric |
| 5 | chs | channel slope | m/m | numeric |
| 6 | chl | channel length | km | numeric |
| 7 | chn | channel Manning's n | | numeric |
| 8 | chk | channel bottom conductivity | mm/h | numeric |
| 9 | bank_exp | bank erosion exponent | | numeric |
| 10 | cov | channel cover factor | 0-1 | numeric |
| 11 | sinu | sinuousity | none | numeric |
| 12 | vcr_coef | critical velocity coefficient | | numeric |
| 13 | d50 | channel median sediment size | mm | numeric |
| 14 | ch_clay | clay percent of bank and bed | % | numeric |
| 15 | carbon | carbon percent of bank and bed | % | numeric |
| 16 | ch_bd | dry bulk density | t/m3 | numeric |
| 17 | chss | channel side slope | | numeric |
| 18 | bankfull_flo | bank full flow rate | | numeric |
| 19 | fps | flood plain slope | m/m | numeric |
| 20 | fpn | flood plain Manning's n | | numeric |

**Changes:**
- Complete schema with proper field order from type definition
- Units extracted from inline comments in `sd_channel_module.f90`
- Descriptions from type definition comments
- Swat_code type: `sd_chd` (matches `sd_chd(idb)` structure read)

**Code Reference:** `sd_hydsed_read.f90`, line 61:
```fortran
read (1,*,iostat=eof) sd_chd(idb)
```

This reads the entire `swatdeg_hydsed_data` structure defined in `sd_channel_module.f90`.

---

## Summary

The schema extractor successfully:
1. ✅ Extracted schemas directly from Fortran source code
2. ✅ Mapped variable types correctly (time%field, ob%field, pcomdb%field, sd_chd%field)
3. ✅ Preserved descriptions and units from inline comments
4. ✅ Maintained data type mappings (integer, string, numeric)
5. ✅ Handled multi-level structures (plant.ini community vs plants)
6. ✅ Replaced outdated baseline rows with current code schema
