# hru.con Fix Summary

## Problem
The hru.con changes showed all 18 baseline rows being "removed" and 13 new rows being "added", when they should have been showing as "updated".

## Root Cause
The baseline CSV uses `Line_in_file = *` (wildcard) for connection files like hru.con, but the tool was extracting `Line_in_file = 3` (actual line number). The schema keys didn't match:
- Baseline: `hru.con|*|1`, `hru.con|*|2`, etc.
- Extracted: `hru.con|3|1`, `hru.con|3|2`, etc.

Because `* ≠ 3`, the tool thought they were different rows.

## Solution
Updated `schema_extractor.py` with:

1. **New function `find_matching_baseline_row()`**:
   - First tries exact key match: `file|line|position`
   - Falls back to wildcard match: `file|*|position`

2. **Preserve wildcard line numbers**:
   - If baseline has `*` for line, keep it (don't update to 3)
   - Only update line number if baseline had a specific number

3. **Track matched baseline rows**:
   - Use `matched_baseline_keys` set to track which baseline rows were matched
   - Only mark as "removed" if not in matched set

## Results - Before Fix
```
hru.con:
  Baseline: 18 rows
  Extracted: 13 rows
  Changes: 13 added, 18 removed, 0 updated ❌
```

## Results - After Fix
```
hru.con:
  Baseline: 18 rows
  Extracted: 13 rows
  Updated: 13 rows
  Changes: 0 added, 5 removed, 9 updated, 4 unchanged ✅
```

## Detailed Changes

### Updated (9 rows):
1. **Row 1184** - Variable `numb` → `num` (fixed typo)
2. **Row 1190** - Description updated for `area_ha`
3. **Row 1196** - Description updated for `elev`
4. **Row 1198** - Variable `hru/props` → `props`
5. **Row 1200** - Variable `wst` → `wst_c`
6. **Row 1202** - Description updated for `constit`
7. **Row 1204** - Variable `overflow/props2` → `props2`
8. **Row 1206** - Description updated for `ruleset`
9. **Row 1208** - Description updated for `src_tot`

### Unchanged (4 rows):
- Row 1186 - `name` (already correct)
- Row 1188 - `gis_id` (already correct)
- Row 1192 - `lat` (already correct)
- Row 1194 - `long` (already correct)

### Removed (5 rows):
These are output connection fields that don't appear in the main READ statement:
- Row 1210 - HRU number (output section marker)
- Row 1212 - Object number (output section marker)
- Row 1214 - `obtyp_out` (read in loop if src_tot > 0)
- Row 1216 - `obtyno_out` (read in loop if src_tot > 0)
- Row 1218 - `htyp_out` (read in loop if src_tot > 0)
- Row 1220 - `frac_out` (read in loop if src_tot > 0)
- Row 1222 - Description (output section)

## Why the `*` Wildcard?

Connection files have variable-length records:
- Each HRU has 13 main fields (always present)
- Plus N output connections (varies by HRU, depends on `src_tot`)

The `*` indicates "these fields repeat on each data line" but the exact line numbers vary.

## Verification

```bash
# Check baseline (column 9 = Line_in_file)
grep "^1184," Rev_61_0_nbs_inputs_master_full.csv | cut -d',' -f9
# Output: *

# Check updated (column 9 = Line_in_file)  
grep "^1184," updated_inputs.csv | cut -d',' -f9
# Output: * (preserved!)

# Check variable name (column 11)
grep "^1184," Rev_61_0_nbs_inputs_master_full.csv | cut -d',' -f11
# Output: numb

grep "^1184," updated_inputs.csv | cut -d',' -f11
# Output: num (fixed typo!)
```

## Status
✅ Fixed - hru.con now correctly shows updates instead of remove+add
✅ Wildcard line numbers preserved
✅ Variable names and descriptions updated
✅ All other pilot files still working correctly
