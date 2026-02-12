# Analysis of User's Original Fire Scenario Inputs (burncase branch)

## Overview

This document analyzes the original `scen_dtl.upd` and `scen_lu.dtl` files from the burncase branch to identify what the user was attempting to accomplish and explain the issues preventing their scenario from working correctly in SWAT+.

## What the User Was Trying to Do

Based on the decision table files, the user attempted to simulate a complex fire and recovery scenario:

1. **Forest to Grassland Conversion (2012)**: Convert 70% of forest HRUs to grassland on January 1, 2012
2. **Moderate Fire Event (January 2016)**: Apply a moderate fire with 40% plant kill on January 1, 2016
3. **High Severity Fire Event (June 2016)**: Apply a severe fire with 70% plant kill on June 1, 2016 (day 152)
4. **Reforestation (2017)**: Convert 80% of grass back to forest on January 1, 2017
5. **Recovery Scenarios (2017)**: 
   - Fast recovery at 60% on January 1, 2017
   - Slow recovery at 30% on June 1, 2017 (day 152)

This scenario appears to model:
- Initial land use change from forest to rangeland
- Fire disturbance events of varying severity
- Post-fire recovery at different rates
- Eventual reforestation

## Critical Issues with the Implementation

### Issue #1: `plant_kill` Action Does Not Exist and Kill Doesn't Support Partial Mortality

**Problem**: The user specified `plant_kill` as an action type (lines 18 and 27 in scen_lu.dtl) attempting to kill 40% and 70% of plants:
```
act_typ                    obj   obj_num              name            option         const        const2                fp  outcome           
plant_kill                 hru         0              null              null       0.40000       0.00000              null  y
```

**Two Issues Here**:

**Two Issues Here**:

1. **Invalid Action Name**: The action is called `"kill"`, not `"plant_kill"`
2. **Kill is All-or-Nothing**: The kill action completely kills plants - it does not support partial kill percentages

**Source Code Evidence**: After examining `src/actions.f90`, the valid action for killing plants is simply `"kill"`, not `"plant_kill"`. The supported action case statement is:
```fortran
case ("kill")
  j = d_tbl%act(iac)%ob_num
  if (j == 0) j = ob_cur
  
  if (pcom(j)%dtbl(idtbl)%num_actions(iac) <= Int(d_tbl%act(iac)%const2)) then
    icom = pcom(j)%pcomdb
    pcom(j)%days_kill = 1
    do ipl = 1, pcom(j)%npl
      biomass = pl_mass(j)%tot(ipl)%m
      if (d_tbl%act(iac)%option == pcomdb(icom)%pl(ipl)%cpnm .or. d_tbl%act(iac)%option == "all") then
        pcom(j)%last_kill = pcomdb(icom)%pl(ipl)%cpnm
        call mgt_killop (j, ipl)
```

**Impact**: SWAT+ would not recognize `plant_kill` as a valid action and would either error out or skip these decision tables entirely.

**Correct Action**: Should use `"kill"` instead of `"plant_kill"`

**Correct Syntax**:
```
act_typ                    obj   obj_num              name            option         const        const2                fp  outcome           
kill                       hru         0              null               all       0.00000       1.00000              null  y
```
Where:
- `option` = "all" kills all plants, or use a specific plant community name to target one plant type
- `const` = not used by kill action (can be 0.0)
- `const2` = number of times to apply (1.00 = apply once when conditions met)

**Note**: The kill action completely kills the plant - there is no partial kill percentage. If you want partial mortality (like 40% kill), you would need to combine a burn operation with appropriate fire.ops parameters, or use other plant modification actions.

**What the User Actually Needs**: Since the user wants 40% and 70% mortality (not complete kill), they should use the `burn` action with proper fire.ops configuration rather than kill. See Issue #2 for details on proper burn setup.

### Issue #2: `burn` Action Requires Management Schedule or fire_db Entry

**Problem**: The user attempted to call `burn` directly from the decision table (lines 19 and 28):
```
burn                       hru         0              null              null       1.00000       0.00000              null  y
```

**Source Code Evidence**: Examining `src/dtbl_lum_read.f90` lines 226-232 shows that burn actions require a fire database entry:
```fortran
case ("burn")
  do iburn = 1, db_mx%fireop_db
    if (dtbl_lum(i)%act(iac)%option == fire_db(iburn)%name) then
      dtbl_lum(i)%act_typ(iac) = iburn
      exit
    end if
  end do
```

And in `src/actions.f90` lines 1113-1132, the burn operation requires:
```fortran
case ("burn")
  j = d_tbl%act(iac)%ob_num
  if (j == 0) j = ob_cur
  
  if (pcom(j)%dtbl(idtbl)%num_actions(iac) <= Int(d_tbl%act(iac)%const2)) then
    iburn = d_tbl%act_typ(iac)           !burn type
    do ipl = 1, pcom(j)%npl
      call pl_burnop (j, iburn)
    end do
```

The burn operation needs:
1. A fire database entry in `fire.ops` defining burn parameters (fraction burned, CN update, etc.)
2. The `option` field must reference a valid fire database name (not "null")

**Impact**: With `option` set to "null", the burn action cannot find a corresponding fire database entry and will not execute properly.

**What's Missing**: 
- User needs a `fire.ops` file defining fire operations (e.g., "moderate_fire", "severe_fire")
- The `option` field should reference these fire operation names
- Alternatively, burns can be scheduled in management schedules (lum.dtl) tied to specific land uses

**Example fire.ops file** (based on refdata/Osu_1hru/fire.ops):
```
fire.ops: written by SWAT+ editor v3.1.0
name                   chg_cn2     frac_burn  description
moderate_fire          6.00000       0.40000  moderate fire 40% burn
severe_fire            8.00000       0.70000  severe fire 70% burn
```

Then the burn actions would be:
```
act_typ                    obj   obj_num              name            option         const        const2                fp  outcome           
burn                       hru         0              null      moderate_fire       0.00000       1.00000              null  y
```

### Issue #3: `grow_init` Only Works with hru_lte Objects, Not Regular HRUs

**Problem**: The user attempted to use `grow_init` on HRUs (lines 44 and 52):
```
act_typ                    obj   obj_num              name            option         const        const2                fp  outcome           
grow_init                  hru         0              null              null       0.60000       0.00000              null  y
```

**Source Code Evidence**: From `src/actions.f90` lines 688-696:
```fortran
!initiate growing season for hru_lte
case ("grow_init")
  j = d_tbl%act(iac)%ob_num
  if (j == 0) j = ob_cur
  
  hlt(j)%gro = "y"
  hlt(j)%g = 0.
  hlt(j)%alai = 0.
  hlt(j)%dm = 0.
  hlt(j)%hufh = 0.
```

The code uses `hlt()` which is the **hru_lte** (HRU Long-Term Environmental) module array, NOT the standard `hru()` array. The comment explicitly states: "!initiate growing season for hru_lte"

Looking at `src/hru_lte_module.f90`, hru_lte is a specialized module for long-term environmental tracking, typically used for:
- SWAT-DEG (degradation) simulations
- Long-term carbon and environmental monitoring
- Specific applications requiring simplified HRU tracking

**Impact**: 
- `grow_init` will only work if the simulation is configured to use hru_lte objects
- For regular SWAT+ HRU simulations, this action will either error or have no effect
- The `const` parameter (0.60 or 0.30) is ignored - it doesn't control recovery percentage

**What the User Should Use Instead**:
Instead of `grow_init`, the user should:
1. Use `lu_change` actions to change land use to different management schedules that control recovery
2. Define different forest land uses (e.g., `frst_fast_lum`, `frst_slow_lum`) with management schedules that have different growth parameters
3. Use plant operations in the management schedule (lum.dtl) to control growth

### Issue #4: Mismatched Decision Table Names

**Problem**: In `scen_dtl.upd`, the user referenced:
```
4            scen_lu   recovery_slow_2017
5            scen_lu   recovery_fast_2017
```

But in `scen_lu.dtl`, the decision tables are named:
```
name                     conds      alts      acts       !HRUs recover faster (60%)
recovery_fast                2         1         1

name                     conds      alts      acts       !HRUs recover slower (30%)
recovery_slow                2         1         1
```

**Impact**: SWAT+ cannot find decision tables named "recovery_slow_2017" or "recovery_fast_2017" because they don't exist in the scen_lu.dtl file.

**Fix**: Decision table names must match exactly between scen_dtl.upd and scen_lu.dtl.

### Issue #5: Missing Conditional Targeting

**Problem**: All decision tables use only 2 conditions (year and day):
```
var                        obj   obj_num           lim_var            lim_op     lim_const      alt1  
year_cal                  null         0              null                 -    2012.00000         =  
jday                      null         0              null                 -       1.00000         =
```

**Impact**: 
- Without `land_use` conditions, actions will attempt to apply to ALL HRUs, not just those of specific land use types
- The `const` values (0.70, 0.40, 0.80, 0.60, 0.30) in the actions are being used incorrectly
- For `lu_change`, the `const` should be 0.0 and probability should be controlled by a `prob` condition
- For operations that truly use `const`, there's no targeting to control which HRUs are affected

**What Should Be Done**:
Add land_use targeting conditions, for example:
```
var                        obj   obj_num           lim_var            lim_op     lim_const      alt1  
year_cal                  null         0              null                 -    2012.00000         =  
jday                      null         0              null                 -       1.00000         =  
land_use                   hru         0          frst_lum                 -       0.00000         =
prob                      null         0              null                 -       0.70000         <
```

This ensures only forest HRUs are targeted and 70% probability is properly applied.

### Issue #6: Non-Zero num_hits Values

**Problem**: In `scen_dtl.upd`, all decision tables have non-zero num_hits:
```
num_hits     name      dtable
1            scen_lu   forest_to_grass
2            scen_lu   fire_jan_2016
3            scen_lu   fire_june_2016
4            scen_lu   recovery_slow_2017
5            scen_lu   recovery_fast_2017
6            scen_lu   reforest_2017
```

**Impact**: The num_hits counter tracks how many times each decision table has been applied. Non-zero initial values could:
- Cause decision tables to be skipped if they've "already been applied"
- Lead to unexpected behavior with `const2` parameters that limit number of applications
- Make debugging difficult

**Best Practice**: Initialize all num_hits to 0:
```
num_hits     name      dtable
0            scen_lu   forest_to_grass
0            scen_lu   fire_jan_2016
...
```

## Summary of Required Fixes

To make this fire scenario work correctly, the user needs to:

1. **Replace `plant_kill` with `kill`**: Use the correct action name
   - Set `option` to "all" or specific plant community name to control which plants to kill

2. **Set up fire database properly**:
   - Create a `fire.ops` file with fire operation definitions
   - Reference fire operation names in the `option` field of burn actions
   - OR move burn operations into management schedules in lum.dtl

3. **Remove `grow_init` actions**: This only works with hru_lte, not regular HRUs
   - Replace with `lu_change` actions to different land use management types
   - Define land uses with management schedules that control recovery rates

4. **Fix decision table names**: Ensure names in scen_dtl.upd match exactly with scen_lu.dtl

5. **Add proper conditional targeting**:
   - Add `land_use` conditions to target specific land use types
   - Add `prob` conditions for probabilistic application
   - Set `const` to 0.0 for `lu_change` actions

6. **Set num_hits to 0**: Initialize all counters to zero

## Alternative Approach: Management Schedule Based

A potentially cleaner approach would be to:

1. Define different land use types for different states:
   - `frst_lum` - Original forest
   - `rnge_lum` - Post-conversion grassland  
   - `frst_burned_lum` - Forest after fire (with burn in management schedule)
   - `frst_recovery_fast_lum` - Forest recovering quickly
   - `frst_recovery_slow_lum` - Forest recovering slowly

2. Use `lu_change` actions in decision tables to transition between states

3. Put fire operations and growth management in the lum.dtl management schedules for each land use type

This approach keeps the decision tables simple and moves the complex operations (burns, growth control) into the management schedules where they can be properly configured with all required parameters.

## Conclusion

The user's original intent was sound - simulating fire disturbance and recovery across a landscape. However, the implementation had several fundamental issues:

- **Invalid action names** (`plant_kill` instead of `kill`)
- **Misunderstanding of action requirements** (burn needs fire_db, grow_init only works with hru_lte)
- **Incomplete conditional targeting** (no land_use filtering)
- **Name mismatches** between control and definition files

These issues would prevent the scenario from running or produce unexpected results. The fixes require understanding SWAT+'s object model (HRU vs hru_lte), action requirements (fire database for burns), and proper use of decision table conditions and actions.
