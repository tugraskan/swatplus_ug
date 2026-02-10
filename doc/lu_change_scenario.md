# Land Use Change Scenarios with `scen_lu.dtl` and `scen_dtl.upd`

This guide explains how to change a fraction of HRUs (e.g., 70% of all forest
HRUs) to a different land use using the scenario decision table system — using
**input files only**, without modifying the SWAT+ source code.

## Overview

SWAT+ supports land use change scenarios through two input files:

- **`scen_lu.dtl`** — Defines decision tables with conditions and actions
- **`scen_dtl.upd`** — Lists which decision tables to activate during simulation

The simulation loop in `time_control.f90` evaluates each decision table against
**every HRU** on each time step. Conditions determine which HRUs are eligible,
and actions are applied only when all conditions are met.

---

## Changing 70% of All Forest HRUs to Rangeland

To convert approximately 70% of all forest (`frst_lum`) HRUs to rangeland
(`rnge_lum`) on a specific date, use three conditions together:

1. **`year_cal`** — triggers on the target year
2. **`land_use`** — filters to only forest HRUs
3. **`prob`** — randomly selects ~70% of those HRUs

### `scen_lu.dtl`

```
scen_lu.dtl: written by SWAT+ editor v3.1.0
1

name                     conds      alts      acts       !change 70% of all forest HRUs to range on Jan 1, 2012
forest_to_range              3         1         1
var                        obj   obj_num           lim_var            lim_op     lim_const      alt1
year_cal                  null         0              null                 -    2012.00000         =
jday                      null         0              null                 -       1.00000         =
land_use                   hru         0          frst_lum                 -       0.00000         =
act_typ                    obj   obj_num              name            option         const        const2                fp  outcome
lu_change                  hru         0              null              null       0.00000       0.00000          rnge_lum  y
```

### `scen_dtl.upd`

```
scenario decision table used in simulation - scen_dtl.upd
1
num_hits     name      dtable
1            scen_lu   forest_to_range
```

### How It Works

The decision table has 3 conditions and 1 action:

| Condition   | Meaning                                                  |
|-------------|----------------------------------------------------------|
| `year_cal`  | Only triggers in calendar year 2012                      |
| `jday`      | Only triggers on Julian day 1 (January 1)                |
| `land_use`  | Only matches HRUs whose current `land_use_mgt_c` = `frst_lum` |

| Action      | Meaning                                                  |
|-------------|----------------------------------------------------------|
| `lu_change` | Changes the HRU's land use to `rnge_lum`                 |

With `obj_num = 0` in both the `land_use` condition and the `lu_change` action,
the table is evaluated for every HRU in the model. The `land_use` condition
filters to only forest HRUs. **All matching forest HRUs** will be converted
to rangeland.

> **Note:** This changes **100%** of forest HRUs. See the next section for
> selecting only a fraction.

---

## Selecting a Fraction of HRUs Using the `prob` Condition

To change only ~70% of forest HRUs (randomly selected), add a **`prob`**
condition. The `prob` condition generates a random number for each HRU and
compares it to `lim_const`. Each forest HRU independently has a 70% chance
of being selected.

### `scen_lu.dtl` with `prob` condition

```
scen_lu.dtl: written by SWAT+ editor v3.1.0
1

name                     conds      alts      acts       !change ~70% of all forest HRUs to range on Jan 1, 2012
forest_to_range              4         1         1
var                        obj   obj_num           lim_var            lim_op     lim_const      alt1
year_cal                  null         0              null                 -    2012.00000         =
jday                      null         0              null                 -       1.00000         =
land_use                   hru         0          frst_lum                 -       0.00000         =
prob                      null         0              null                 -       0.70000         <
act_typ                    obj   obj_num              name            option         const        const2                fp  outcome
lu_change                  hru         0              null              null       0.00000       0.00000          rnge_lum  y
```

### Key Addition: The `prob` Condition

| Field       | Value   | Meaning                                        |
|-------------|---------|------------------------------------------------|
| `var`       | `prob`  | Probabilistic condition                        |
| `lim_const` | `0.70`  | Threshold probability (70%)                    |
| `lim_op`    | `-`     | Not used                                       |
| `alt1`      | `<`     | Action fires when random number < 0.70         |

For each HRU, a random number between 0 and 1 is generated. If it is less than
0.70, the condition is met and the HRU is selected. Over many forest HRUs, this
gives approximately 70% conversion.

> **Note:** Because `prob` is stochastic, the exact percentage may vary slightly
> from run to run. With many HRUs, the result converges to 70%.

---

## Using `prob_unif_lu` for Distributed Selection Over Time

For scenarios where you want the 70% conversion to happen **gradually across a
time window** (not all on one day), use the `prob_unif_lu` condition. This
distributes the selection uniformly across a window of Julian days.

```
name                     conds      alts      acts       !change ~70% of forest HRUs over days 1-30
forest_to_range              2         1         1
var                        obj   obj_num           lim_var            lim_op     lim_const      alt1
land_use                   hru         0          frst_lum                 -       0.00000         =
prob_unif_lu              null         1              null                 -      30.00000         =
act_typ                    obj   obj_num              name            option         const        const2                fp  outcome
lu_change                  hru         0              null              null       0.00000       0.00000          rnge_lum  y
```

| Field       | Value          | Meaning                                      |
|-------------|----------------|----------------------------------------------|
| `var`       | `prob_unif_lu` | Uniform distribution across land use HRUs    |
| `obj_num`   | `1`            | Start day of window (Julian day)             |
| `lim_const` | `30.0`         | End day of window (Julian day)               |

The `prob_unif_lu` condition uses the `hru_lu` count (number of forest HRUs)
to distribute selections uniformly. Each forest HRU is selected on approximately
one day within the window.

> **Note:** `prob_unif_lu` requires the `land_use` condition in the same table
> to count the matching HRUs.

---

## Changing All Forest HRUs (100%)

To convert **all** forest HRUs to rangeland (not just a fraction), simply use
the `land_use` condition without `prob`:

```
name                     conds      alts      acts       !change ALL forest HRUs to range
forest_to_range              3         1         1
var                        obj   obj_num           lim_var            lim_op     lim_const      alt1
year_cal                  null         0              null                 -    2012.00000         =
jday                      null         0              null                 -       1.00000         =
land_use                   hru         0          frst_lum                 -       0.00000         =
act_typ                    obj   obj_num              name            option         const        const2                fp  outcome
lu_change                  hru         0              null              null       0.00000       0.00000          rnge_lum  y
```

---

## Burning 40% of All HRUs

To burn approximately 40% of all HRUs on a specific date, use the `burn`
action with the `prob` condition. The `burn` action uses a fire type from the
`fire.ops` database which controls burn fraction, curve number update, and
soil carbon effects.

### `scen_lu.dtl`

```
scen_lu.dtl: burn 40% of all HRUs
1

name                     conds      alts      acts       !burn ~40% of all HRUs on Jan 1, 2016
burn_40pct_all               3         1         1
var                        obj   obj_num           lim_var            lim_op     lim_const      alt1
year_cal                  null         0              null                 -    2016.00000         =
jday                      null         0              null                 -       1.00000         =
prob                      null         0              null                 -       0.40000         <
act_typ                    obj   obj_num              name            option         const        const2                fp  outcome
burn                       hru         0              null             grass       0.00000       0.00000              null  y
```

### `scen_dtl.upd`

```
scenario decision table used in simulation - scen_dtl.upd
1
num_hits     name      dtable
1            scen_lu   burn_40pct_all
```

### How It Works

| Condition   | Meaning                                              |
|-------------|------------------------------------------------------|
| `year_cal`  | Triggers in 2016                                     |
| `jday`      | Triggers on January 1                                |
| `prob`      | Each HRU has a 40% chance of being selected          |

| Action Field | Value   | Meaning                                        |
|-------------|---------|------------------------------------------------|
| `act_typ`   | `burn`  | Full burn operation using fire database         |
| `option`    | `grass` | Fire type from `fire.ops` (100% burn, CN +8)    |

The `prob < 0.40` condition randomly selects ~40% of all HRUs. The `burn`
action applies the fire type from `fire.ops`, which burns biomass, residue,
and soil carbon, and updates the curve number.

---

## Burning 40% of All Forest HRUs

To burn approximately 40% of forest HRUs only, add a `land_use` condition to
filter to forest HRUs before applying the `prob` selection:

### `scen_lu.dtl`

```
scen_lu.dtl: burn 40% of forest HRUs
1

name                     conds      alts      acts       !burn ~40% of forest HRUs on Jan 1, 2016
burn_40pct_frst              4         1         1
var                        obj   obj_num           lim_var            lim_op     lim_const      alt1
year_cal                  null         0              null                 -    2016.00000         =
jday                      null         0              null                 -       1.00000         =
land_use                   hru         0          frst_lum                 -       0.00000         =
prob                      null         0              null                 -       0.40000         <
act_typ                    obj   obj_num              name            option         const        const2                fp  outcome
burn                       hru         0              null          tree_low       0.00000       0.00000              null  y
```

### How It Works

| Condition   | Meaning                                              |
|-------------|------------------------------------------------------|
| `year_cal`  | Triggers in 2016                                     |
| `jday`      | Triggers on January 1                                |
| `land_use`  | Only forest HRUs (`frst_lum`) match                  |
| `prob`      | Each forest HRU has a 40% chance of being selected   |

| Action Field | Value      | Meaning                                      |
|-------------|------------|----------------------------------------------|
| `act_typ`   | `burn`     | Full burn operation using fire database       |
| `option`    | `tree_low` | Fire type from `fire.ops` (70% burn, CN +6)   |

Only forest HRUs pass the `land_use` filter. Of those, ~40% are randomly
selected by `prob`. The selected HRUs are burned using the `tree_low` fire
type, which burns 70% of biomass and increases the curve number by 6.

---

## Using `plant_kill` as a Simple Alternative to `burn`

For scenarios where you only need to kill plant biomass without updating the
curve number or burning soil carbon, use the `plant_kill` action. The `const`
field directly controls the kill fraction (0 to 1).

### Example: Kill 70% of biomass in ~40% of forest HRUs

```
name                     conds      alts      acts       !kill 70% biomass in ~40% of forest HRUs
kill_40pct_frst              4         1         1
var                        obj   obj_num           lim_var            lim_op     lim_const      alt1
year_cal                  null         0              null                 -    2016.00000         =
jday                      null         0              null                 -       1.00000         =
land_use                   hru         0          frst_lum                 -       0.00000         =
prob                      null         0              null                 -       0.40000         <
act_typ                    obj   obj_num              name            option         const        const2                fp  outcome
plant_kill                 hru         0              null              null       0.70000       0.00000              null  y
```

---

## The `fire.ops` Database

The `burn` action requires a fire type defined in the `fire.ops` database file.
Each fire type controls how much biomass is burned and how the curve number changes.

### Example `fire.ops`

```
fire.ops: fire operations database
name                   chg_cn2     frac_burn  description
grass                  8.00000       1.00000
tree_intense           8.00000       0.90000
tree_low               6.00000       0.70000
```

| Field       | Meaning                                            |
|-------------|----------------------------------------------------|
| `name`      | Fire type name (referenced in `option` field)      |
| `chg_cn2`   | Curve number increase after fire                   |
| `frac_burn` | Fraction of biomass and residue burned             |

The `burn` action references a fire type by name in the `option` field. When
the action executes, `pl_burnop` uses the fire type's `frac_burn` to burn
that fraction of above-ground biomass, surface residue, and soil carbon. It
also increases the curve number by `chg_cn2`.

---

## Comparison: `burn` vs `plant_kill`

| Feature | `burn` | `plant_kill` |
|---------|--------|-------------|
| Burns biomass | ✅ via `frac_burn` in `fire.ops` | ✅ via `const` (0 to 1) |
| Updates curve number | ✅ via `chg_cn2` in `fire.ops` | ❌ |
| Burns soil residue/carbon | ✅ | ❌ (biomass → surface residue) |
| Tracks carbon emissions | ✅ | ❌ |
| Works from `scen_lu.dtl` | ✅ (requires `fire.ops`) | ✅ |
| Burn fraction control | Via fire type in `fire.ops` | Direct (`const` = 0 to 1) |

**Recommended:** Use `burn` for fire scenarios — it provides the full fire
effects including curve number update, soil carbon burning, and carbon emission
tracking. Use `plant_kill` only when you need a simple biomass reduction without
fire effects.

---

## Complete Example: Fire and Recovery Scenario

### `scen_dtl.upd`

```
scenario decision table used in simulation - scen_dtl.upd
3
num_hits     name      dtable
1            scen_lu   forest_to_range
1            scen_lu   fire_2016
1            scen_lu   reforest_2017
```

### `scen_lu.dtl`

```
scen_lu.dtl: land use change scenarios
3

name                     conds      alts      acts       !change ~70% of forest HRUs to range on Jan 1, 2012
forest_to_range              4         1         1
var                        obj   obj_num           lim_var            lim_op     lim_const      alt1
year_cal                  null         0              null                 -    2012.00000         =
jday                      null         0              null                 -       1.00000         =
land_use                   hru         0          frst_lum                 -       0.00000         =
prob                      null         0              null                 -       0.70000         <
act_typ                    obj   obj_num              name            option         const        const2                fp  outcome
lu_change                  hru         0              null              null       0.00000       0.00000          rnge_lum  y

name                     conds      alts      acts       !burn on Jan 1, 2016
fire_2016                    3         1         1
var                        obj   obj_num           lim_var            lim_op     lim_const      alt1
year_cal                  null         0              null                 -    2016.00000         =
jday                      null         0              null                 -       1.00000         =
land_use                   hru         0          rnge_lum                 -       0.00000         =
act_typ                    obj   obj_num              name            option         const        const2                fp  outcome
lu_change                  hru         0              null              null       0.00000       0.00000          frst_lum  y

name                     conds      alts      acts       !reforest on Jan 1, 2017
reforest_2017                3         1         1
var                        obj   obj_num           lim_var            lim_op     lim_const      alt1
year_cal                  null         0              null                 -    2017.00000         =
jday                      null         0              null                 -       1.00000         =
land_use                   hru         0          rnge_lum                 -       0.00000         =
act_typ                    obj   obj_num              name            option         const        const2                fp  outcome
lu_change                  hru         0              null              null       0.00000       0.00000          frst_lum  y
```

---

## Condition Reference

| Condition      | Purpose                                              | Key Fields |
|----------------|------------------------------------------------------|------------|
| `year_cal`     | Match calendar year                                  | `lim_const` = year |
| `jday`         | Match Julian day of year                             | `lim_const` = day |
| `land_use`     | Match HRU land use name                              | `lim_var` = land use name |
| `prob`         | Random selection (each HRU independent)              | `lim_const` = probability threshold |
| `prob_unif_lu` | Distribute selections across land use HRUs over window | `obj_num` = start day, `lim_const` = end day |

## Action Reference

| Action         | Purpose                                      | Key Fields |
|----------------|----------------------------------------------|------------|
| `lu_change`    | Change HRU land use management               | `fp` = target land use name |
| `plant_kill`   | Kill fraction of above-ground plant biomass  | `const` = kill fraction (0-1) |
| `burn`         | Full fire: burn biomass, update CN, soil C   | `option` = fire type from `fire.ops` |

## Summary

| Goal | Method |
|------|--------|
| Change ALL forest HRUs | `land_use` condition with `lim_var = frst_lum` |
| Change ~70% of forest HRUs | Add `prob` condition with `lim_const = 0.70` and `alt1 = <` |
| Burn ~40% of ALL HRUs | `prob < 0.40` + `burn` with `option` = fire type |
| Burn ~40% of forest HRUs | `land_use = frst_lum` + `prob < 0.40` + `burn` |
| Simple biomass kill | `plant_kill` with `const` = kill fraction |
| Target specific HRU | Set `obj_num` in the action line |
| Distribute changes over time | Use `prob_unif_lu` condition |
