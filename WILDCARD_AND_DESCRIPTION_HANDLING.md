# Wildcard Row and Description-Only Change Handling

## Overview

The schema extraction tool now implements enhanced handling for wildcard rows and description-only changes per new requirements.

## 1. Wildcard Row Preservation

### What are Wildcard Rows?

Rows where `Line_in_file = "*"` OR `Position_in_File = "*"` are considered **wildcard rows**. These are logical/metadata rows, not tied to a specific line or position in the file.

**Examples:**
- ID fields (Row 2032: hyd-sed-lte.cha, id field with `*|*`)
- Description fields (Row 2038: "Description, not used in the model")
- Output connection fields (Rows 1210-1222: hru.con output connections with `*` positions)
- Header-like metadata fields

### Behavior

**Never Remove Wildcard Rows:**
- Even if not found in extracted schema
- Marked as `action=unchanged`
- Notes: "wildcard row; keep even if not mapped to read structure"

**Matching Logic:**
- Try to match by (SWAT_File + Position_in_File) when position is a number
- Try to match by (SWAT_File + DATABASE_FIELD_NAME)
- If no match found, still keep the row

### Example Evidence

```csv
action,schema_key,swat_file,line_in_file,position_in_file,notes
unchanged,hru.con|*|14,hru.con,0,14,in_con,obtyp_out,,,wildcard row; keep even if not mapped to read structure
unchanged,hru.con|*|15,hru.con,0,15,in_con,obtyno_out,,,wildcard row; keep even if not mapped to read structure
unchanged,hru.con|*|16,hru.con,0,16,in_con,htyp_out,,,wildcard row; keep even if not mapped to read structure
```

## 2. Removal Rule

**Only Remove Positional Rows:**

Removal is ONLY allowed when:
1. `Line_in_file` is a real number (not `*`)
2. AND `Position_in_File` is a real number (not `*`)
3. AND the field cannot be found in the mapped read structure for that file

**Result:** Wildcard rows are never removed, even if they don't match the extracted schema.

## 3. Description-Only Change Filtering

### Structural vs Non-Structural Fields

**Structural Fields** (real changes):
- `Line_in_file`
- `Position_in_File`
- `SWAT_Code_Variable_Name`
- `Data_Type`
- `Number_Decimal_Places`

**Non-Structural Fields** (informational only):
- `Description`
- `Units`

### Behavior

**If ONLY non-structural fields changed:**
- Action: `info` (informational)
- Master CSV: NOT updated (baseline values preserved)
- Evidence: Reports the difference with note "description change only; not applied"
- Rationale: Avoid churning the spreadsheet for minor wording/case/punctuation differences

**If ANY structural field changed:**
- Action: `updated`
- Master CSV: Updated with new values (including any description/units changes)
- Evidence: Reports all changes including structural ones

### Example Evidence

**Description-only changes (not applied):**
```csv
action,field_changed,notes
info,time.sim|3|1,time.sim,3,1,time,day_start,Description,description change only; not applied
info,time.sim|3|2,time.sim,3,2,time,yrc_start,Description,description change only; not applied
```

**Structural changes (applied):**
```csv
action,field_changed
updated,hru.con|3|1,hru.con,3,1,ob,num,SWAT_Code_Variable_Name
updated,hyd-sed-lte.cha|3|2,hyd-sed-lte.cha,3,2,sd_chd,order,Data_Type
```

## Results Comparison

### Before New Guidance

```
time.sim: 6 baseline, 5 extracted
  - Updated: 5 (all description changes)
  - Removed: 1 (wildcard row)

hru.con: 18 baseline, 13 extracted
  - Updated: 9 (including description-only)
  - Removed: 5 (including wildcard rows)
```

### After New Guidance

```
time.sim: 6 baseline, 5 extracted
  - Updated: 0 ✅ (no structural changes)
  - Info: 5 ✅ (description-only, not applied)
  - Removed: 0 ✅ (wildcard row preserved)
  - Unchanged: 1 ✅ (wildcard row)

hru.con: 18 baseline, 13 extracted
  - Updated: 6 ✅ (only structural changes)
  - Info: 3 ✅ (description-only, not applied)
  - Removed: 0 ✅ (no removals)
  - Unchanged: 9 ✅ (includes wildcard rows)
```

## Summary Statistics

| Metric | Before | After |
|--------|--------|-------|
| Total updates | 22 | 17 |
| Removals | 18 | 0 |
| Info actions | 0 | 25 |
| Unchanged (wildcard) | 0 | 11+ |

## Implementation Details

### Helper Functions

**`is_wildcard_row(row: Dict) -> bool`**
- Checks if Line_in_file or Position_in_File is `*`
- Returns True for wildcard rows

**`is_description_only_change(changes: List[str]) -> bool`**
- Checks if changes list contains only non-structural fields
- Returns True if only Description/Units changed
- Returns False if any structural field changed

### Evidence Actions

- `unchanged`: Row not changed (includes wildcard preservation)
- `updated`: Structural fields changed, applied to CSV
- `added`: New row added from code (not used in pilot)
- `removed`: Row removed (only for non-wildcard positional rows)
- `info`: Non-structural change detected but not applied

## Benefits

1. **Preserves Metadata:** Wildcard rows (ID, description fields) are never lost
2. **Reduces Churn:** Minor description wording changes don't update the master CSV
3. **Clear Evidence:** All changes documented with appropriate action types
4. **Stable Output:** Only real structural changes update the spreadsheet
5. **Better Traceability:** Can see both applied updates and informational changes

## Compliance

✅ Wildcard rows never removed
✅ Removal only for positional rows (both line and position are numbers)
✅ Description-only changes not applied to master CSV
✅ Structural changes still correctly applied
✅ Full evidence tracking with new "info" action type
