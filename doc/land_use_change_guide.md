# SWAT+ Land Use Change System: A Complete Guide

## Overview

SWAT+ provides a flexible decision table system for implementing land use changes during simulation. This system allows you to define complex scenarios where land use can change based on various conditions such as time, environmental conditions, or management practices.

## Key Components

### 1. Decision Tables (`scen_lu.dtl`)

The `scen_lu.dtl` file contains decision tables that define **when** and **how** land use changes should occur. Each decision table consists of:

- **Conditions**: Define when the change should happen (e.g., specific year, day, current land use)
- **Alternatives**: How conditions are evaluated (e.g., equal to, greater than, less than)
- **Actions**: What should happen when conditions are met (e.g., change land use)

### 2. Scenario Control (`scen_dtl.upd`)

The `scen_dtl.upd` file controls **how many times** each decision table can be executed during the simulation. This prevents infinite loops and controls the frequency of applications.

### 3. Land Use Management Database (`landuse.lum`)

Contains the definitions of different land use and management systems that can be applied during land use changes.

## How Land Use Changes Work

### Step 1: Initialization
During model initialization:
1. `dtbl_scen_read.f90` reads the `scen_lu.dtl` file
2. `cal_cond_read.f90` reads the `scen_dtl.upd` file
3. Decision tables are linked with land use management definitions

### Step 2: Daily Evaluation
Each simulation day:
1. **Condition Checking** (`conditions.f90`):
   - Evaluates each condition in active decision tables
   - Checks calendar date, land use, environmental conditions, etc.
   - Sets `act_hit` flags for each alternative

2. **Action Execution** (`actions.f90`):
   - If all conditions are met, executes the land use change action
   - Updates HRU land use and management properties
   - Reinitializes plant communities, soil parameters, etc.
   - Logs the change to `lu_change_out.txt`

### Step 3: HRU Updates
When a land use change occurs:
1. Previous land use is stored for logging
2. New land use management is assigned to the HRU
3. Plant community is reinitialized (`plant_init`)
4. Soil curve numbers are recalculated (`cn2_init`)
5. USLE parameters are updated
6. HRU land use management parameters are reinitialized (`hru_lum_init`)

## File Structure and Syntax

### scen_lu.dtl Format

```
scen_lu.dtl: description of the scenario file
[number_of_decision_tables]

name                     conds      alts      acts       ![description]
[decision_table_name]         [n_conditions] [n_alternatives] [n_actions]

var                        obj   obj_num           lim_var            lim_op     lim_const      alt1  
[condition_variable]       [object] [object_number] [limit_variable]   [operator] [limit_value]  [alternative]

act_typ                    obj   obj_num              name            option         const        const2                fp  outcome           
[action_type]              [object] [object_number]  [action_name]   [option]       [constant]   [constant2]           [file_pointer] [outcome]
```

### Example Decision Table

Here's a breakdown of your forest-to-grass conversion example:

```
name                     conds      alts      acts       !changing all forest to grass on January 1, 2005
frsd_tecf_sb_to_grass         3         1         1  

var                        obj   obj_num           lim_var            lim_op     lim_const      alt1  
year_cal                  null         0              null                 -    2005.00000         =       !year 2005
jday                      null         0              null                 -       1.00000         =       !January 1
land_use                   hru         0  frsd_tecf_sb_lum                 -       0.00000         =       !current land use must match

act_typ                    obj   obj_num              name            option         const        const2                fp  outcome           
lu_change                  hru         0      frsd_to_gras              null       0.00000       0.00000       gras_sb_lum  y   
```

**Breakdown:**
- **name**: `frsd_tecf_sb_to_grass` - unique identifier for this decision table
- **conds**: `3` - three conditions must be met
- **alts**: `1` - one alternative (all conditions use "=" operator)
- **acts**: `1` - one action will be executed

**Conditions:**
1. `year_cal = 2005` - Change occurs in calendar year 2005
2. `jday = 1` - Change occurs on January 1st (julian day 1)
3. `land_use = frsd_tecf_sb_lum` - Only apply to HRUs with forest land use

**Action:**
- `lu_change` - Change the land use and management
- `file_pointer`: `gras_sb_lum` - New land use management from landuse.lum

### scen_dtl.upd Format

```
scen_dtl.upd: scenario control file
[number_of_scenarios]

max_hits    typ         dtbl
[max_applications] [type] [decision_table_name]
```

Example:
```
1    lu_change    frsd_tecf_sb_to_grass
```

This means the `frsd_tecf_sb_to_grass` decision table can be executed a maximum of 1 time for each HRU.

## Common Condition Variables

| Variable | Description | Example Use |
|----------|-------------|-------------|
| `year_cal` | Calendar year | Schedule changes for specific years |
| `jday` | Julian day of year (1-365/366) | Schedule seasonal changes |
| `month` | Month (1-12) | Monthly scheduling |
| `land_use` | Current land use | Apply only to specific land uses |
| `w_stress` | Water stress | Change based on drought conditions |
| `soil_water` | Soil water content | Moisture-dependent changes |
| `phu_plant` | Plant heat units | Crop development stage |
| `prob` | Random probability | Stochastic applications |

## Common Action Types

| Action Type | Description | Parameters |
|-------------|-------------|------------|
| `lu_change` | Complete land use change | `file_pointer`: new land use from landuse.lum |
| `hru_fr_update` | Update HRU area fractions | `option`: new lsu_unit.ele, `file_pointer`: rout_unit.ele |
| `plant` | Plant a crop | `name`: plant name, `file_pointer`: plant database entry |
| `harvest` | Harvest operation | Various harvest parameters |
| `irrigate` | Apply irrigation | `const`: irrigation amount |

## Best Practices

### 1. Planning Land Use Change Scenarios

1. **Define your objectives**: What changes do you want to simulate?
2. **Identify target HRUs**: Which areas should be affected?
3. **Set timing**: When should changes occur?
4. **Prepare land use definitions**: Ensure target land uses exist in landuse.lum

### 2. Condition Design

- **Be specific with conditions**: Use multiple conditions to target exact HRUs
- **Test with simple scenarios first**: Start with time-based changes
- **Use land_use conditions**: Prevent unintended changes to wrong land uses
- **Consider environmental conditions**: Add water stress, soil conditions, etc.

### 3. Action Configuration

- **Verify land use names**: Ensure `file_pointer` matches entries in landuse.lum
- **Set appropriate limits**: Use `const2` to limit number of applications
- **Test incrementally**: Start with small changes before complex scenarios

### 4. Troubleshooting

- **Check output files**: Monitor `lu_change_out.txt` for actual changes
- **Verify conditions**: Ensure all conditions can be satisfied simultaneously
- **Review land use database**: Confirm target land uses are properly defined
- **Check timing**: Verify Julian day calculations and year specifications

## Output and Monitoring

### lu_change_out.txt
This file logs all land use changes that occur during simulation:

```
hru    year    month    day    operation    lu_before    lu_after
1      2005    1        1      LU_CHANGE    frsd_tecf_sb_lum    gras_sb_lum
```

### Diagnostic Tips

1. **No changes occurring**: Check if conditions are too restrictive
2. **Too many changes**: Verify max_hits in scen_dtl.upd
3. **Wrong HRUs affected**: Review land_use conditions
4. **Timing issues**: Verify calendar year and julian day settings

## Advanced Features

### Probability-Based Changes
Use `prob` conditions for stochastic land use changes:

```
var                        obj   obj_num           lim_var            lim_op     lim_const      alt1  
prob                      null         0              null                 -       0.10000         <       !10% probability
```

### Environmental Triggers
Combine environmental conditions with time:

```
var                        obj   obj_num           lim_var            lim_op     lim_const      alt1  
year_cal                  null         0              null                 -    2010.00000         =
w_stress                   hru         0              null                 -       0.80000         >       !high water stress
soil_water                 hru         0                fc                 *       0.50000         <       !soil water < 50% of field capacity
```

### Multiple Alternative Actions
Define different actions based on conditions:

```
name                     conds      alts      acts       !drought response with multiple options
drought_response              2         2         2

var                        obj   obj_num           lim_var            lim_op     lim_const      alt1    alt2
w_stress                   hru         0              null                 -       0.80000         >       >
soil_water                 hru         0                fc                 *       0.30000         <       >

act_typ                    obj   obj_num              name            option         const        const2                fp  outcome    outcome2
lu_change                  hru         0      severe_drought           null       0.00000       0.00000       drought_crop1  y          n
lu_change                  hru         0      mild_drought             null       0.00000       0.00000       drought_crop2  n          y
```

This comprehensive system allows SWAT+ users to simulate complex land use change scenarios that respond to both planned management decisions and environmental conditions.