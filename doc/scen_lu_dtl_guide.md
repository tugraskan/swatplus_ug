# Scenario Decision Table Guide: `scen_lu.dtl`

This guide explains how to use scenario decision tables (`scen_lu.dtl`) to
perform land use changes, fire/burn operations, and plant recovery in SWAT+
using **input files only** — no source code modifications required.

## Overview

SWAT+ evaluates scenario decision tables against **every HRU** on each time
step. Each table has:

- **Conditions** — determine which HRUs are eligible (year, day, land use, probability)
- **Actions** — operations to apply when all conditions are met (`lu_change`, `burn`, `plant_kill`, `grow_init`)

Two input files are required:

| File | Purpose |
|------|---------|
| `scen_lu.dtl` | Decision tables with conditions and actions |
| `scen_dtl.upd` | Lists which tables to activate during simulation |

---

## Complete Working Example

This example demonstrates 6 decision tables that perform a land use change,
two fire events with different severity, reforestation, and two recovery rates.

### `scen_dtl.upd`

```
scenario decision table used in simulation - scen_dtl.upd
6
num_hits     name      dtable
1            scen_lu   forest_to_grass
2            scen_lu   fire_jan_2016
3            scen_lu   fire_june_2016
4            scen_lu   recovery_slow_2017
5            scen_lu   recovery_fast_2017
6            scen_lu   reforest_2017
```

### `scen_lu.dtl`

```
scen_lu.dtl: written by SWAT+ editor v3.1.0
6

name                     conds      alts      acts       !changing forest hru to grass hru (70%) on January 1, 2012
forest_to_grass              4         1         1  
var                        obj   obj_num           lim_var            lim_op     lim_const      alt1  
year_cal                  null         0              null                 -    2012.00000         =  
jday                      null         0              null                 -       1.00000         =  
land_use                   hru         0          frst_lum                 -       0.00000         =
prob                      null         0              null                 -       0.70000         <
act_typ                    obj   obj_num              name            option         const        const2                fp  outcome           
lu_change                  hru         0      frst_to_rnge              null       0.00000       0.00000          rnge_lum  y   

name                     conds      alts      acts       !Moderate fire (40% kill) on January 1, 2016
fire_jan_2016                2         1         2  
var                        obj   obj_num           lim_var            lim_op     lim_const      alt1  
year_cal                  null         0              null                 -    2016.00000         =  
jday                      null         0              null                 -       1.00000         =  
act_typ                    obj   obj_num              name            option         const        const2                fp  outcome           
plant_kill                 hru         0              null              null       0.40000       0.00000              null  y   
burn                       hru         0              null             grass       0.00000       0.00000              null  y   

name                     conds      alts      acts       !High severity fire (70% kill) on June 1, 2016
fire_june_2016               2         1         2  
var                        obj   obj_num           lim_var            lim_op     lim_const      alt1  
year_cal                  null         0              null                 -    2016.00000         =  
jday                      null         0              null                 -     152.00000         =  
act_typ                    obj   obj_num              name            option         const        const2                fp  outcome           
plant_kill                 hru         0              null              null       0.70000       0.00000              null  y   
burn                       hru         0              null      tree_intense       0.00000       0.00000              null  y   

name                     conds      alts      acts       !changing grass to forest (80%) on January 1, 2017
reforest_2017                2         1         1  
var                        obj   obj_num           lim_var            lim_op     lim_const      alt1  
year_cal                  null         0              null                 -    2017.00000         =  
jday                      null         0              null                 -       1.00000         =  
act_typ                    obj   obj_num              name            option         const        const2                fp  outcome           
lu_change                  hru         0      rnge_to_frst              null       0.80000       0.00000          frst_lum  y   

name                     conds      alts      acts       !HRUs recover faster (60%)
recovery_fast_2017           2         1         1  
var                        obj   obj_num           lim_var            lim_op     lim_const      alt1  
year_cal                  null         0              null                 -    2017.00000         =  
jday                      null         0              null                 -       1.00000         =  
act_typ                    obj   obj_num              name            option         const        const2                fp  outcome           
grow_init                  hru         0              null              null       0.60000       0.00000              null  y   

name                     conds      alts      acts       !HRUs recover slower (30%)
recovery_slow_2017           2         1         1  
var                        obj   obj_num           lim_var            lim_op     lim_const      alt1  
year_cal                  null         0              null                 -    2017.00000         =  
jday                      null         0              null                 -     152.00000         =  
act_typ                    obj   obj_num              name            option         const        const2                fp  outcome           
grow_init                  hru         0              null              null       0.30000       0.00000              null  y   
```

### `fire.ops` (required for burn operations)

The `burn` action requires a fire type defined in `fire.ops`. The `option`
field in the decision table must match one of these names:

```
fire.ops: written by SWAT+ editor v2.2.0
name                   chg_cn2     frac_burn  description
grass                  8.00000       1.00000  
tree_intense           8.00000       0.90000  
tree_low               6.00000       0.70000
```

---

## Table-by-Table Explanation

### 1. `forest_to_grass` — Land Use Change (70% of Forest HRUs)

**Goal:** On January 1, 2012, convert ~70% of all forest HRUs to rangeland.

| Condition   | Value        | Meaning                                    |
|-------------|-------------|---------------------------------------------|
| `year_cal`  | `2012`      | Only triggers in calendar year 2012         |
| `jday`      | `1`         | Only triggers on Julian day 1 (January 1)   |
| `land_use`  | `frst_lum`  | Only matches forest HRUs                    |
| `prob`      | `0.70`, `<` | Each forest HRU has 70% chance of selection |

| Action Field | Value          | Meaning                              |
|-------------|----------------|---------------------------------------|
| `act_typ`   | `lu_change`    | Change the HRU's land use             |
| `name`      | `frst_to_rnge` | Descriptive label for the operation   |
| `const`     | `0.0`          | No fractional area change             |
| `fp`        | `rnge_lum`     | New land use (must exist in `landuse.lum`) |

**How it works:** The `land_use` condition filters to only forest HRUs. The
`prob < 0.70` condition randomly selects ~70% of those. Selected HRUs have
their land use changed to `rnge_lum` (rangeland).

> **Note:** `const = 0.0` means the HRU keeps its full area. If `const` were
> between 0 and 1 (e.g., `0.80`), the HRU's area would be scaled by that fraction.

### 2. `fire_jan_2016` — Moderate Fire (40% Kill + Full Burn)

**Goal:** On January 1, 2016, apply a moderate fire to **all** HRUs: kill 40%
of above-ground biomass, then burn remaining residue.

| Condition   | Value    | Meaning                          |
|-------------|---------|-----------------------------------|
| `year_cal`  | `2016`  | Only triggers in 2016             |
| `jday`      | `1`     | Only triggers on Julian day 1 (January 1)|

This table has **2 actions** that execute in sequence:

| # | Action | `option` | `const` | Effect |
|---|--------|----------|---------|--------|
| 1 | `plant_kill` | `null` | `0.40` | Kill 40% of above-ground biomass, transfer to surface residue |
| 2 | `burn` | `grass` | — | Burn 100% of remaining biomass and residue (from `fire.ops`) |

**How it works:** First, `plant_kill` kills 40% of the above-ground plant
biomass and transfers it to the surface residue pool. Then `burn` with
`option = grass` burns 100% of the remaining above-ground biomass, surface
residue, and soil carbon using the `grass` fire type from `fire.ops` (which
also increases the curve number by 8).

> **Important:** The `burn` action requires a valid fire type in the `option`
> field. Set `option` to one of the names defined in `fire.ops` (e.g., `grass`,
> `tree_intense`, `tree_low`). If `option = null`, the burn will not execute.

### 3. `fire_june_2016` — High Severity Fire (70% Kill + Intense Burn)

**Goal:** On June 1, 2016 (Julian day 152), apply a high severity fire to
**all** HRUs: kill 70% of biomass, then burn remaining with 90% intensity.

| Condition   | Value    | Meaning                          |
|-------------|---------|-----------------------------------|
| `year_cal`  | `2016`  | Only triggers in 2016             |
| `jday`      | `152`   | Only triggers on Julian day 152 (June 1) |

| # | Action | `option` | `const` | Effect |
|---|--------|----------|---------|--------|
| 1 | `plant_kill` | `null` | `0.70` | Kill 70% of above-ground biomass |
| 2 | `burn` | `tree_intense` | — | Burn 90% of remaining biomass and residue |

### 4. `reforest_2017` — Land Use Change Back to Forest (80% Area)

**Goal:** On January 1, 2017, change all HRUs to forest and reduce their
area to 80% of the original.

| Condition   | Value    | Meaning                          |
|-------------|---------|-----------------------------------|
| `year_cal`  | `2017`  | Only triggers in 2017             |
| `jday`      | `1`     | Only triggers on Julian day 1 (January 1)|

| Action Field | Value          | Meaning                                |
|-------------|----------------|----------------------------------------|
| `act_typ`   | `lu_change`    | Change land use                        |
| `name`      | `rnge_to_frst` | Descriptive label                      |
| `const`     | `0.80`         | Reduce HRU area to 80% of current     |
| `fp`        | `frst_lum`     | New land use (forest)                  |

**How it works:** The `lu_change` action changes the land use to `frst_lum` and
scales the HRU area by `const = 0.80` (reducing it to 80% of its current area).

### 5. `recovery_fast_2017` — Fast Recovery (60% Growth)

**Goal:** On January 1, 2017, initialize plant growth at 60% for all HRUs.

| Condition   | Value    | Meaning                          |
|-------------|---------|-----------------------------------|
| `year_cal`  | `2017`  | Only triggers in 2017             |
| `jday`      | `1`     | Only triggers on Julian day 1 (January 1)|

| Action Field | Value       | Meaning                              |
|-------------|-------------|---------------------------------------|
| `act_typ`   | `grow_init` | Initialize growing season             |
| `const`     | `0.60`      | Start growth at 60% of potential      |

### 6. `recovery_slow_2017` — Slow Recovery (30% Growth)

**Goal:** On June 1, 2017 (Julian day 152), set plant growth to 30% for all HRUs.

| Condition   | Value    | Meaning                          |
|-------------|---------|-----------------------------------|
| `year_cal`  | `2017`  | Only triggers in 2017             |
| `jday`      | `152`   | Only triggers on Julian day 152 (June 1) |

| Action Field | Value       | Meaning                              |
|-------------|-------------|---------------------------------------|
| `act_typ`   | `grow_init` | Initialize growing season             |
| `const`     | `0.30`      | Start growth at 30% of potential      |

---

## Additional Examples

### Example A: Burn 40% of Forest HRUs Only

To burn only ~40% of **forest** HRUs, add `land_use` and `prob` conditions:

```
name                     conds      alts      acts       !burn ~40% of forest HRUs on Jan 1, 2016
burn_forest_40               4         1         2  
var                        obj   obj_num           lim_var            lim_op     lim_const      alt1  
year_cal                  null         0              null                 -    2016.00000         =  
jday                      null         0              null                 -       1.00000         =  
land_use                   hru         0          frst_lum                 -       0.00000         =
prob                      null         0              null                 -       0.40000         <
act_typ                    obj   obj_num              name            option         const        const2                fp  outcome           
plant_kill                 hru         0              null              null       0.70000       0.00000              null  y   
burn                       hru         0              null          tree_low       0.00000       0.00000              null  y   
```

**How it works:**

1. `land_use = frst_lum` — filters to only forest HRUs
2. `prob < 0.40` — randomly selects ~40% of those forest HRUs
3. `plant_kill` with `const = 0.70` — kills 70% of above-ground biomass
4. `burn` with `option = tree_low` — burns 70% of remaining biomass/residue (from `fire.ops`) and increases CN by 6

### Example B: Burn Specific HRUs by Number

To burn a **specific HRU** (e.g., HRU 5), set `obj_num` in the action lines:

```
name                     conds      alts      acts       !burn specific HRU 5 on Jan 1, 2016
burn_hru5                    2         1         2  
var                        obj   obj_num           lim_var            lim_op     lim_const      alt1  
year_cal                  null         0              null                 -    2016.00000         =  
jday                      null         0              null                 -       1.00000         =  
act_typ                    obj   obj_num              name            option         const        const2                fp  outcome           
plant_kill                 hru         5              null              null       0.50000       0.00000              null  y   
burn                       hru         5              null             grass       0.00000       0.00000              null  y   
```

**How it works:**

- `obj_num = 5` in both actions — targets only HRU 5
- `plant_kill` with `const = 0.50` — kills 50% of biomass in HRU 5
- `burn` with `option = grass` — burns 100% of remaining biomass/residue in HRU 5

> **Note:** When `obj_num = 0`, the action applies to whichever HRU the loop
> is currently evaluating (all HRUs that pass the conditions). When `obj_num`
> is a specific number, only that HRU is affected.

---

## Action Reference

### `lu_change` — Land Use Change

Changes the HRU's land use management type.

| Field    | Purpose                                            |
|----------|----------------------------------------------------|
| `name`   | Descriptive label (e.g., `frst_to_rnge`)           |
| `const`  | Fractional area change (0 = no change, 0.8 = reduce to 80%) |
| `fp`     | Target land use name (must exist in `landuse.lum`)  |

When `const` is between 0 and 1 (exclusive), the HRU's area is scaled by that
fraction. When `const` is 0, only the land use is changed without area change.

### `plant_kill` — Partial Plant Kill

Kills a fraction of above-ground plant biomass and transfers it to the surface
residue pool.

| Field    | Purpose                                            |
|----------|----------------------------------------------------|
| `const`  | Kill fraction (0.0 to 1.0). 0.40 = kill 40% of biomass |

Does **not** update the curve number or burn soil carbon. Use before `burn`
to simulate a fire that first kills plants, then burns the dead material.

### `burn` — Full Burn Operation

Burns above-ground plant biomass, surface residue, and soil carbon. Updates the
curve number. Requires a fire type from the `fire.ops` database.

| Field    | Purpose                                            |
|----------|----------------------------------------------------|
| `option` | Fire type name from `fire.ops` (**required**, e.g., `grass`, `tree_low`, `tree_intense`) |

The fire type determines:
- `frac_burn` — fraction of biomass and residue burned
- `chg_cn2` — curve number increase after fire

> **Important:** The `option` field **must** match a name in `fire.ops`.
> If `option = null`, the burn action will not execute.

### `grow_init` — Initialize Plant Growth

Sets the initial plant growth index for the HRU.

| Field    | Purpose                                            |
|----------|----------------------------------------------------|
| `const`  | Initial growth fraction (0.0 to 1.0)               |

Use after fire/recovery scenarios to control how quickly vegetation recovers.
A value of `0.60` starts plants at 60% of their full growth potential.

---

## Condition Reference

| Condition      | Purpose                                              | Key Fields |
|----------------|------------------------------------------------------|------------|
| `year_cal`     | Match calendar year                                  | `lim_const` = year |
| `jday`         | Match Julian day of year                             | `lim_const` = day (1-365) |
| `land_use`     | Match HRU land use name                              | `lim_var` = land use name (e.g., `frst_lum`) |
| `prob`         | Random selection (each HRU independent)              | `lim_const` = probability, `alt1` = `<` |

### How `prob` Works

For each HRU, a random number between 0 and 1 is generated. If the random
number is less than `lim_const`, the condition is met. With `lim_const = 0.70`
and `alt1 = <`, approximately 70% of HRUs will be selected.

### How `land_use` Works

Matches HRUs whose current `land_use_mgt_c` equals the value in `lim_var`.
This is evaluated dynamically — if an HRU's land use was changed by a previous
table, subsequent tables see the updated land use.

---

## `fire.ops` Reference

The `burn` action requires a fire type from this database. Default entries:

| Name | `chg_cn2` | `frac_burn` | Description |
|------|-----------|-------------|-------------|
| `grass` | 8.0 | 1.00 | Complete burn (grassland fire) |
| `tree_intense` | 8.0 | 0.90 | High intensity tree fire (90% burned) |
| `tree_low` | 6.0 | 0.70 | Low intensity tree fire (70% burned) |

You can add custom fire types to `fire.ops` to match your specific scenario.

---

## Summary

| Goal | Method |
|------|--------|
| Change ~70% of forest HRUs to range | `land_use = frst_lum` + `prob < 0.70` + `lu_change` with `fp = rnge_lum` |
| Moderate fire (40% kill) on all HRUs | `plant_kill` with `const = 0.40` + `burn` with `option = grass` |
| High severity fire (70% kill) | `plant_kill` with `const = 0.70` + `burn` with `option = tree_intense` |
| Reforest with 80% area | `lu_change` with `const = 0.80` and `fp = frst_lum` |
| Fast recovery (60%) | `grow_init` with `const = 0.60` |
| Slow recovery (30%) | `grow_init` with `const = 0.30` |
| Burn ~40% of forest HRUs | `land_use = frst_lum` + `prob < 0.40` + `plant_kill` + `burn` |
| Burn a specific HRU | Set `obj_num` in the action to the HRU number |
