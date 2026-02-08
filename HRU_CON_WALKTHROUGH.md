# hru.con Changes Walkthrough

## Issue Overview

The hru.con output shows all rows being "removed" and then "added", when they should be "updated". This is happening because of a mismatch in how line numbers are handled.

## Baseline CSV Structure

The baseline has **18 rows** for hru.con with `Line_in_file = *` (wildcard):

```csv
Row ID | Position | Line | Variable     | Description
-------|----------|------|--------------|---------------------------
1184   | 1        | *    | numb         | HRU number
1186   | 2        | *    | name         | HRU name  
1188   | 3        | *    | gis_id       | HRU GIS id
1190   | 4        | *    | area_ha      | Area
1192   | 5        | *    | lat          | Latitude
1194   | 6        | *    | long         | Longitude
1196   | 7        | *    | elev         | Elevation
1198   | 8        | *    | hru/props    | Pointer to HRU properties
1200   | 9        | *    | wst          | Weather station number
1202   | 10       | *    | constit      | Constituent data pointer
1204   | 11       | *    | overflow     | Overflow/props2
1206   | 12       | *    | ruleset      | Ruleset pointer
1208   | 13       | *    | src_tot      | Total outgoing hydrographs
1210   | *        | *    | *            | HRU number (output section)
1212   | *        | *    | *            | Object number 1-10
1214   | 14       | *    | obtyp_out    | Outflow object type
1216   | 15       | *    | obtyno_out   | Outflow object ID
1218   | 16       | *    | htyp_out     | Outflow hydrograph type
1220   | 17       | *    | frac_out     | Fraction of hydrograph
1222   | *        | *    | *            | Description
```

## Code Analysis

From `hyd_read_connect.f90` lines 220-221:

```fortran
read (107,*,iostat=eof) ob(i)%num, ob(i)%name, ob(i)%gis_id, ob(i)%area_ha, &
  ob(i)%lat, ob(i)%long, ob(i)%elev, ob(i)%props, ob(i)%wst_c, &
  ob(i)%constit, ob(i)%props2, ob(i)%ruleset, ob(i)%src_tot
```

This reads **13 variables** in a single READ statement.

The tool extracts:
- `Line_in_file = 3` (after 2 header lines)
- `Position_in_File = 1, 2, 3, ...13`

## The Mismatch Problem

### Schema Keys Generated:
```
Tool extracts:     hru.con|3|1, hru.con|3|2, ...hru.con|3|13
Baseline has:      hru.con|*|1, hru.con|*|2, ...hru.con|*|13
```

### Result:
Because `3 ≠ *`, the keys **don't match**, so:
- Tool says: "I found 13 new rows at line 3" → **ADDED**
- Tool says: "The 18 baseline rows at line * aren't in code" → **REMOVED**

But this is wrong! They're the same variables, just with different line representations.

## Why Baseline Uses `*`

Connection files (hru.con, hru-lte.con, etc.) have **variable-length** records:

1. **Header lines** (1-2): Title, column headers
2. **Data lines** (3+): Each HRU/object
   - First part: Main HRU data (13 fields)
   - Second part: Output connections (if src_tot > 0)
     - Number of connections varies per HRU
     - Each connection has 5 fields (obtyp_out, obtyno_out, htyp_out, frac_out, description)

The `*` means "these fields appear on each data line" but the exact line number varies by HRU.

## What Should Happen

The tool should recognize that:
- `hru.con|*|1` (baseline) matches `hru.con|3|1` (extracted)
- `hru.con|*|2` (baseline) matches `hru.con|3|2` (extracted)
- etc.

And then **UPDATE** the rows instead of removing/adding them.

## Current Output vs Expected

### Current (WRONG):
```
Baseline: 18 rows
Extracted: 13 rows
Changes: 13 added, 18 removed
```

### Expected (CORRECT):
```
Baseline: 18 rows
Extracted: 13 rows  
Changes: 13 updated, 5 removed (the output connection fields)
```

## Specific Issues

1. **Row 1184** (baseline) should update to match extracted position 1:
   - Variable: `numb` → `num` ✓ (fixing typo)
   - Line: `*` → `3` (should update or keep `*`)
   - Description: Keep baseline or update from code
   
2. **Rows 1210-1222** (output connection fields):
   - These don't appear in the main READ statement
   - They're read later in a loop if src_tot > 0
   - Tool correctly doesn't extract them
   - Should be marked as "removed" or kept with a note

3. **All 13 main fields** should show as "updated", not "added"

## The Fix Needed

Update `schema_extractor.py` to:
1. Handle wildcards in matching: `file|*|position` should match `file|<any>|position`
2. Update Line_in_file appropriately (keep `*` or update to actual line)
3. Show these as updates, not additions
4. Document the wildcard meaning in results

## Summary

**Problem**: Wildcard line numbers (`*`) in baseline don't match literal line numbers (3) from code extraction, causing false "removed" + "added" instead of "updated".

**Impact**: Makes it look like hru.con is being completely replaced when it's actually being updated.

**Solution**: Enhance matching logic to handle wildcard line numbers in baseline.
