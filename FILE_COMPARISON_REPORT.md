# File List Comparison Report

**Date:** 2026-02-08  
**Comparison:** Provided List vs ALL_INPUTS.md

---

## Executive Summary

| Metric | Count |
|--------|-------|
| Files in provided list | 159 |
| Files in ALL_INPUTS.md | 181 |
| **Matched (in both)** | **138** |
| Only in provided list | 21 |
| Only in ALL_INPUTS.md | 43 |
| **Match rate** | **86.8%** |

---

## Section 1: Files in Provided List BUT NOT in ALL_INPUTS.md (21 files)

These files were in your provided list but are **missing** from ALL_INPUTS.md.

### Analysis by Category:

#### 1. Typos or Naming Issues (5 files)
These appear to be slight variations in naming:

| Provided | Should Be | Notes |
|----------|-----------|-------|
| `atmo.cli` | `atmodep.cli` | Missing "dep" suffix |
| `cons_prac.lum` | `cons_practice.lum` | Abbreviated vs full word |
| `path_hru_ini` | `path_hru.ini` | Missing dot before extension |
| `salt_hru_ini` | `salt_hru.ini` | Missing dot before extension |
| `transfer.wro` | N/A | Should be `water_allocation.wro`? |

#### 2. Key Files (.key extension) - 4 files
These files are NOT in ALL_INPUTS.md:

- ❌ `cha.key`
- ❌ `hru_sub.key`
- ❌ `mgt.key`
- ❌ `res.key`

**Note:** These may be output/lookup files rather than inputs.

#### 3. Constituent Database Files (.cst extension) - 4 files
These files are NOT in ALL_INPUTS.md:

- ❌ `metl.cst` (should be `metals.mtl` in ALL_INPUTS.md)
- ❌ `path.cst`
- ❌ `pest.cst`
- ❌ `salt.cst` (should be `salt.slt` in ALL_INPUTS.md)

**Note:** Extension mismatch - .cst vs .mtl/.slt

#### 4. Recall Data Files (.dat extension) - 2 files
These are NOT in ALL_INPUTS.md:

- ❌ `recann.dat`
- ❌ `recday.dat`

**Note:** These may be output files, not inputs.

#### 5. Other Missing Files - 6 files

- ❌ `amt_mm` - No extension, unclear what this is
- ❌ `management.sch` - Scheduling file (not in ALL_INPUTS.md)
- ❌ `modflow.con` - MODFLOW connection (not in ALL_INPUTS.md)
- ❌ `object.cnt` - Object count (should be in ALL_INPUTS.md as configurable)
- ❌ `res.dtl` - Reservoir detail (should be `res_rel.dtl`)
- ❌ `wind-dir.cli` - Wind direction (commented out in source)

---

## Section 2: Files in ALL_INPUTS.md BUT NOT in Provided List (43 files)

These files are in ALL_INPUTS.md but were **not** in your provided list.

### By Category:

#### New Module Files (15 files)

**GWFLOW Module:**
- ➕ `gwflow.con`
- ➕ `looping.con`
- ➕ `out.key`

**Constituent System:**
- ➕ `cs_aqu.ini`
- ➕ `cs_atmo.cli`
- ➕ `cs_channel.ini`
- ➕ `cs_hru.ini`
- ➕ `cs_recall.rec`

**Salt Module:**
- ➕ `salt_aqu.ini`
- ➕ `salt_atmo.cli`
- ➕ `salt_channel.ini`
- ➕ `salt_hru.ini`
- ➕ `salt_recall.rec`

**Other:**
- ➕ `co2_yr.dat`
- ➕ `pest_metabolite.pes`

#### Water Allocation Module (8 files)
- ➕ `om_osrc.wal`
- ➕ `om_treat.wal`
- ➕ `om_use.wal`
- ➕ `outside_src.wal`
- ➕ `water_pipe.wal`
- ➕ `water_tower.wal`
- ➕ `water_treat.wal`
- ➕ `water_use.wal`

#### Calibration Files (5 files)
- ➕ `hru-lte-new.cal`
- ➕ `hru-lte-out.cal`
- ➕ `hru-new.cal`
- ➕ `hru-out.cal`
- ➕ `hydrology-cal.hyd`
- ➕ `plant_parms.cal`

#### Database/Specialized Files (8 files)
- ➕ `manure.frt`
- ➕ `recall_db.rec`
- ➕ `res_conds.dat`
- ➕ `soil_lyr_depths.sol`
- ➕ `transplant.plt`
- ➕ `puddle.ops`
- ➕ `satbuffer.str`

#### Corrected Names (7 files)
These are in ALL_INPUTS.md with correct naming:
- ➕ `atmodep.cli` (vs `atmo.cli`)
- ➕ `cons_practice.lum` (vs `cons_prac.lum`)
- ➕ `metals.mtl` (vs `metl.cst`)
- ➕ `object.prt` (vs `object.cnt` - different purpose)
- ➕ `path_hru.ini` (vs `path_hru_ini`)
- ➕ `res_rel.dtl` (vs `res.dtl`)
- ➕ `salt.slt` (vs `salt.cst`)

---

## Section 3: Matched Files (138 files)

These files appear in **both** lists (86.8% match rate):

### Sample (first 30):
- ✓ animal.hrd
- ✓ aqu_catunit.def
- ✓ aqu_catunit.ele
- ✓ aqu_cha.lin
- ✓ aqu_reg.def
- ✓ aquifer.aqu
- ✓ aquifer.con
- ✓ aquifer2d.con
- ✓ bmpuser.str
- ✓ cal_parms.cal
- ✓ calibration.cal
- ✓ ch_catunit.def
- ✓ ch_catunit.ele
- ✓ ch_reg.def
- ✓ ch_sed_budget.sft
- ✓ ch_sed_parms.sft
- ✓ chan-surf.lin
- ✓ chandeg.con
- ✓ channel-lte.cha
- ✓ channel.cha
- ✓ channel.con
- ✓ chem_app.ops
- ✓ cntable.lum
- ✓ codes.bsn
- ✓ codes.sft
- ✓ constituents.cs
- ✓ delratio.con
- ✓ delratio.del
- ✓ dr_hmet.del
- ✓ dr_om.del

*(and 108 more)*

---

## Detailed Analysis

### 1. Naming Issues to Fix

| Issue | Provided | Correct |
|-------|----------|---------|
| Missing "dep" | `atmo.cli` | `atmodep.cli` |
| Abbreviated | `cons_prac.lum` | `cons_practice.lum` |
| Wrong extension | `metl.cst` | `metals.mtl` |
| Wrong extension | `salt.cst` | `salt.slt` |
| Missing dot | `path_hru_ini` | `path_hru.ini` |
| Missing dot | `salt_hru_ini` | `salt_hru.ini` |
| Abbreviated | `res.dtl` | `res_rel.dtl` |

### 2. Files That May Be Outputs (Not Inputs)

These files in your list might be **output files**, not inputs:

- `recann.dat` - Annual recall output
- `recday.dat` - Daily recall output
- `cha.key` - Channel key/lookup
- `hru_sub.key` - HRU sub-basin key
- `mgt.key` - Management key
- `res.key` - Reservoir key

### 3. New Features in SWAT+ Not in Original List

Your provided list appears to be from an older version. ALL_INPUTS.md includes:

**New in SWAT+ (43 new files):**
- Constituent transport system (8 files)
- Salt module enhancements (5 files)
- Water allocation module (8 files)
- GWFLOW groundwater system (3 files)
- Enhanced calibration outputs (6 files)
- New specialized databases (13 files)

### 4. Questionable Entries

- `amt_mm` - Unknown file with no extension
- `NEEDS WORK` - Not a file, removed from analysis
- `modflow.con` - MODFLOW coupling (may be legacy)
- `wind-dir.cli` - Commented out in source code

---

## Recommendations

### Priority 1: Fix Naming Issues (7 files)
Update these in your list to match SWAT+ naming:
1. `atmo.cli` → `atmodep.cli`
2. `cons_prac.lum` → `cons_practice.lum`
3. `metl.cst` → `metals.mtl`
4. `salt.cst` → `salt.slt`
5. `path_hru_ini` → `path_hru.ini`
6. `salt_hru_ini` → `salt_hru.ini`
7. `res.dtl` → `res_rel.dtl`

### Priority 2: Add Missing Input Files (36 files)
Add these NEW input files that are in ALL_INPUTS.md:
- 8 Constituent system files
- 8 Water allocation files
- 5 Salt module files
- 3 GWFLOW files
- 6 Calibration files
- 6 Specialized database files

### Priority 3: Remove/Clarify Output Files (6 files)
These may be outputs, not inputs:
- `recann.dat`, `recday.dat`
- `*.key` files (4 files)

### Priority 4: Investigate Unknown Files (3 files)
- `amt_mm` - What is this?
- `modflow.con` - Still used?
- `wind-dir.cli` - Commented out in code

---

## Summary Table

| Category | Count | Action |
|----------|-------|--------|
| Perfect matches | 138 | ✅ Keep as-is |
| Naming issues | 7 | 🔧 Fix names |
| New features to add | 36 | ➕ Add to list |
| Possible outputs | 6 | ❓ Verify purpose |
| Unknown/questionable | 4 | ⚠️ Investigate |

---

*Generated by compare_file_lists.py*  
*Repository: tugraskan/swatplus_ug*
