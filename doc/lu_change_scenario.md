# Land Use Change Scenarios with `scen_lu.dtl` and `scen_dtl.upd`

This guide explains how to change a fraction (e.g., 70%) of a particular HRU's
land use using the scenario decision table system.

## Overview

SWAT+ supports land use change scenarios through two input files:

- **`scen_lu.dtl`** — Defines decision tables with conditions and actions
- **`scen_dtl.upd`** — Lists which decision tables to activate during simulation

## Approach: Achieving a 70% Land Use Change Without Source Code Modifications

With the **unmodified** SWAT+ source code, `lu_change` converts the **entire**
HRU's land use. To convert only 70% of a particular land use area, you need to
**split the HRU into two parts during model setup**:

1. One HRU representing **70%** of the original area (to be converted)
2. One HRU representing **30%** of the original area (to remain unchanged)

Both HRUs share the same soil, topography, and initial land use. The `lu_change`
action then targets only the 70%-area HRU for conversion.

---

### Step 1: Split the Forest HRU in Model Setup

Suppose your original model has a forest HRU (HRU 5) with `bsn_frac = 0.20` and
land use `frst_lum`. To convert 70% of it to rangeland:

**Original `ls_unit.ele`:**
```
lsu_unit.ele
ID  NAME     OBJ_TYP  OBJ_TYP_NO  BSN_FRAC  RU_FRAC
 5  hru0005  hru      5           0.20      0.0
```

**Split into two HRUs** — the 70% portion gets a new HRU number:

**Updated `ls_unit.ele`:**
```
lsu_unit.ele
ID  NAME     OBJ_TYP  OBJ_TYP_NO  BSN_FRAC  RU_FRAC
 5  hru0005  hru      5           0.14      0.0
13  hru0013  hru     13           0.06      0.0
```

Here:
- `0.14 = 0.70 × 0.20` — the portion to be converted to rangeland
- `0.06 = 0.30 × 0.20` — remains as forest

**Updated `hru-data.hru`** — add the new HRU with the same physical properties:
```
id  name       topo        hydro    soil        lu_mgt    soil_plant_init  surf_stor  snow     field
 5  hru0005    topohru005  hyd005   soil_05     frst_lum  soilplant1       null       snow001  null
13  hru0013    topohru005  hyd005   soil_05     frst_lum  soilplant1       null       snow001  null
```

> **Note:** You must also update `object.cnt`, `hru.con`, and `rout_unit.ele` to
> include the new HRU. The new HRU must use the same topography, hydrology, and
> soil as the original.

### Step 2: Create `scen_lu.dtl`

Define a decision table that targets only HRU 5 (the 70% portion) for conversion:

```
scen_lu.dtl: land use change scenario
1

name                     conds      alts      acts       !change 70% forest HRU to range on Jan 1, 2012
forest_to_grass              2         1         1
var                        obj   obj_num           lim_var            lim_op     lim_const      alt1
year_cal                  null         0              null                 -    2012.00000         =
jday                      null         0              null                 -       1.00000         =
act_typ                    obj   obj_num              name            option         const        const2                fp  outcome
lu_change                  hru         5              null              null       0.00000       0.00000          rnge_lum  y
```

**Key fields:**
| Field     | Value      | Meaning                                                |
|-----------|------------|--------------------------------------------------------|
| `obj_num` | `5`        | Target specific HRU 5 (the 70% portion)                |
| `fp`      | `rnge_lum` | New land use management (must exist in `landuse.lum`)  |

> **Note:** Setting `obj_num = 0` would apply the action to whichever HRU the
> loop is currently evaluating. Use a specific number to target only one HRU.

### Step 3: Create `scen_dtl.upd`

```
scenario decision table used in simulation - scen_dtl.upd
1
num_hits     name      dtable
1            scen_lu   forest_to_grass
```

### Step 4: Ensure Target Land Use Exists

The target `rnge_lum` must be defined in `landuse.lum` with plant community,
management schedule, curve number lookup, etc.

---

## Using `land_use` Condition to Filter by Current Land Use

Instead of targeting a specific HRU number, you can use the **`land_use`** condition
to match all HRUs with a given land use name. This is useful when multiple HRUs
share the same land use and you want to convert all of them:

```
name                     conds      alts      acts
forest_to_grass              3         1         1
var                        obj   obj_num           lim_var            lim_op     lim_const      alt1
year_cal                  null         0              null                 -    2012.00000         =
jday                      null         0              null                 -       1.00000         =
land_use                   hru         0          frst_lum                 -       0.00000         =
act_typ                    obj   obj_num              name            option         const        const2                fp  outcome
lu_change                  hru         0              null              null       0.00000       0.00000          rnge_lum  y
```

The `land_use` condition with `lim_var = frst_lum` and `alt1 = =` ensures the
action only fires for HRUs whose current `land_use_mgt_c` equals `frst_lum`.

> **Important:** With `obj_num = 0` and a `land_use` condition, **all** matching
> HRUs will be changed. If you split forest into a 70% HRU and a 30% HRU, give
> the 30% HRU a different land use name (e.g., `frst_keep`) so it does not match.

---

## Using `hru_fr_update` for Mid-Simulation Area Changes

If you need to change HRU area fractions **during** the simulation, use the
`hru_fr_update` action. This reads updated `ls_unit.ele` and `rout_unit.ele` files:

```
name                     conds      alts      acts
adjust_fractions             2         1         1
var                        obj   obj_num           lim_var            lim_op     lim_const      alt1
year_cal                  null         0              null                 -    2012.00000         =
jday                      null         0              null                 -       1.00000         =
act_typ                    obj   obj_num              name            option         const        const2                fp  outcome
hru_fr_update              hru         0              null    ls_unit_upd.ele       0.00000       0.00000   ru_elem_upd.ele  y
```

| Field    | Value             | Meaning                                    |
|---------|-------------------|--------------------------------------------|
| `option`| `ls_unit_upd.ele` | File with updated `bsn_frac` values        |
| `fp`    | `ru_elem_upd.ele` | File with updated routing unit fractions    |

The `ls_unit_upd.ele` file uses the same format as the original `ls_unit.ele`.

> **Note:** `hru_fr_update` only changes area fractions — it does NOT change land
> use. Combine it with `lu_change` in separate actions or decision tables if you
> need both.

---

## Complete Example: Forest to Range with Recovery

### Model Setup

Split a forest HRU (original `bsn_frac = 0.20`) into:
- HRU 5: `bsn_frac = 0.14` (70%, to be converted) with `lu_mgt = frst_lum`
- HRU 13: `bsn_frac = 0.06` (30%, stays forest) with `lu_mgt = frst_lum`

### `scen_dtl.upd`

```
scenario decision table used in simulation - scen_dtl.upd
2
num_hits     name      dtable
1            scen_lu   forest_to_grass
1            scen_lu   reforest_2017
```

### `scen_lu.dtl`

```
scen_lu.dtl: land use change scenarios
2

name                     conds      alts      acts       !change forest HRU 5 to range on Jan 1, 2012
forest_to_grass              2         1         1
var                        obj   obj_num           lim_var            lim_op     lim_const      alt1
year_cal                  null         0              null                 -    2012.00000         =
jday                      null         0              null                 -       1.00000         =
act_typ                    obj   obj_num              name            option         const        const2                fp  outcome
lu_change                  hru         5              null              null       0.00000       0.00000          rnge_lum  y

name                     conds      alts      acts       !change HRU 5 back to forest on Jan 1, 2017
reforest_2017                2         1         1
var                        obj   obj_num           lim_var            lim_op     lim_const      alt1
year_cal                  null         0              null                 -    2017.00000         =
jday                      null         0              null                 -       1.00000         =
act_typ                    obj   obj_num              name            option         const        const2                fp  outcome
lu_change                  hru         5              null              null       0.00000       0.00000          frst_lum  y
```

---

## Summary

| Goal | Input-Only Method |
|------|-------------------|
| Convert 70% of a land use | Split HRU into 70%/30% during model setup, then use `lu_change` on the 70% HRU |
| Target by current land use | Add `land_use` condition with `lim_var` = land use name |
| Target specific HRU | Set `obj_num` to the HRU number in the action |
| Adjust area fractions mid-simulation | Use `hru_fr_update` with updated element files |
| Combine multiple changes | List multiple decision tables in `scen_dtl.upd` |
