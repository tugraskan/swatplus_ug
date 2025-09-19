# SWAT+ Water Allocation Inputs and Outputs

## Overview

The SWAT+ water allocation system uses a comprehensive set of input files to define water sources, demands, infrastructure, and allocation rules. It generates detailed output files at multiple temporal scales to track water allocation performance, unmet demands, and system water balance.

## Input Files

### 1. Primary Configuration Files

#### `water_allocation.wro` - Main Water Allocation Configuration
**Purpose**: Defines the complete water allocation system including sources, transfer objects, and allocation rules.

**Structure**:
```
Water Allocation Configuration for [dataset name]
[number_of_allocation_objects]

Water Allocation Rule Definition    Source Transfer Out_Src Out_Rcv Wtp Uses Stor Pipe Canal Pump Cha_Src
[name] [rule_type] [src_count] [trn_count] [outsrc_count] [outrcv_count] [wtp_count] [use_count] [stor_count] [pipe_count] [canal_count] [pump_count] [channel_source]

Source OBJ_TYP OBJ_NUM LIM_TYP LIM_NAME (JAN_MIN-DEC_MIN)
[src_id] [object_type] [object_number] [limit_type] [limit_name] [jan_limit] [feb_limit] ... [dec_limit]

TRN_NUM TRN_TYP TRN_TYP_NAME AMOUNT RIGHT SRC_NUM DTBL_SRC (SRC_OBJECTS) RCV_OBJECT
[trn_id] [transfer_type] [type_name] [amount] [water_right] [source_count] [decision_table] [source_specs] [receiving_object]
```

**Key Parameters**:
- **rule_type**: Water allocation methodology (`priority`, `proportional`, `high_right_first_serve`)
- **object_type**: Source type (`res`=reservoir, `aqu`=aquifer, `cha`=channel, `osrc`=outside source, `unl`=unlimited)
- **limit_type**: Constraint method (`mon_lim`=monthly limits, `dtbl`=decision table, `recall`=recall data)
- **transfer_type**: Demand type (`ave_day`=fixed daily, `dtbl_irr`=irrigation table, `outflo`=outflow)
- **water_right**: Priority level (`sr`=senior rights, `jr`=junior rights)

**Example**:
```
Water Allocation Configuration for solo_1 dataset
1
Water Allocation Rule Definition       Source  Transfer  Out_Src  Out_Rcv  Wtp   Uses  Stor  Pipe  Canal  Pump  Cha_Src
 07080209 high_right_first_serve         3       12        1        0      3     2      1    13     0     1       n

Source OBJ_TYP OBJ_NUM LIM_TYP LIM_NAME                        (JAN_MIN-DEC_MIN)
  1    res        1    mon_lim  null     0.5     0.5     0.5     0.5     0.5     0.5     0.5     0.5     0.5     0.5     0.5     0.5
  2    aqu        2    mon_lim  null     13.     13      13      13      13      13      13      13      13      13      13      13
  3    osrc       1    mon_lim  null     0.8     0.8     0.8     0.8     0.5     0.5     0.5     0.5     0.5     0.8     0.8     0.8

TRN_NUM TRN_TYP  TRN_TYP_NAME  AMOUNT RIGHT SRC_NUM DTBL_SRC  (SRC_OBJECTS)                 RCV_OBJECT
  1     outflo      null        0.0    sr    1        null    osrc 1 pipe 1  1.0 n        res  1
  2     ave_day     null     1000.0    sr    1        null    res  1 pipe 2  1.0 n        wtp  1
```

#### `water_pipe.wal` - Conveyance Infrastructure
**Purpose**: Defines pipe/canal conveyance systems with flow capacities, losses, and connections.

**Structure**:
```
water_pipe.wal -- water pipes 
[number_of_pipes]   number of pipes
id   name      flomax_cms   lag_days   loss_fr    aquifers     aquifer_num1  loss_frac1  ...
[id] [name]    [max_flow]   [lag]      [loss_%]   [aqu_count]  [aqu_id]      [loss_frac] ...
```

**Parameters**:
- **flomax_cms**: Maximum flow capacity (m³/s)
- **lag_days**: Transport lag time (days)
- **loss_fr**: Transmission loss fraction (0.0-1.0)
- **aquifers**: Number of connected aquifers for loss accounting
- **aquifer_num**: Connected aquifer ID numbers
- **loss_frac**: Fraction of losses going to each aquifer

### 2. Infrastructure Support Files

#### `water_treat.wal` - Water Treatment Plants
**Purpose**: Defines treatment plant capacities, efficiencies, and water quality modifications.

**Structure**:
```
water_treat.wal -- concentrations after water treatment
[number_of_treatments]   number of treatments
id   name      stormax_m3     lag_days   loss_fr    org_min   pests_ppm  paths_cfu  salts_ppm    constit_ppm   description
[id] [name]    [storage]      [lag]      [loss_%]   [om_name] [pest_conc] [path_conc] [salt_conc] [cs_conc]    [description]
```

#### `water_use.wal` - Water Use Objects
**Purpose**: Defines municipal, industrial, and domestic water use characteristics.

**Structure**:
```
water_use.wal -- concentrations after water use
[number_of_uses]   number of uses
id  name      stormax_m3     lag_days   loss_fr    org_min     pests_ppm  paths_cfu  salts_ppm    constit_ppm   description
[id] [name]   [storage]      [lag]      [loss_%]   [om_name]   [pest_conc] [path_conc] [salt_conc] [cs_conc]    [description]
```

#### `water_tower.wal` - Storage Infrastructure
**Purpose**: Defines water storage towers and their capacities.

**Structure**:
```
water_tower.wal -- water tower storage 
[number_of_towers]   number of towers
id   name      stormax_m3     lag_days   loss_fr 
[id] [name]    [storage]      [lag]      [loss_%]
```

### 3. Decision Table Integration

#### Decision Tables (`*.dtl` files)
Water allocation can use decision tables for:
- **Irrigation scheduling**: `irr_str8_dmd` and similar tables control irrigation timing and amounts
- **Variable demands**: Municipal demands based on seasonal or climatic conditions
- **Source availability**: Dynamic source constraints based on environmental conditions
- **Transfer rules**: Conditional water transfer based on multiple criteria

### 4. Configuration Integration

#### `file.cio` - Master Configuration
The water allocation system is activated through the main configuration file:
```
print.prt             ! print control file
codes.bsn             ! watershed configuration codes
```

Where `codes.bsn` includes water allocation control flags and `print.prt` controls output generation.

#### Print Control Settings
Water allocation outputs are controlled by print codes:
- **daily**: `pco%water_allo%d = "y"`
- **monthly**: `pco%water_allo%m = "y"` 
- **yearly**: `pco%water_allo%y = "y"`
- **average annual**: `pco%water_allo%a = "y"`

## Output Files

### 1. Daily Output Files

#### `water_allo_day.txt` / `water_allo_day.csv`
**Purpose**: Daily water allocation performance tracking.

**Content**:
- Date information (day, month, year)
- Demand object details and amounts
- Source-specific withdrawals and availability
- Unmet demand tracking
- Water rights compliance
- Transfer object performance

**Format**:
```
DAY  MON  DAY  YR   DMD_ID  DMD_TYPE    DMD_NUM  SRC_COUNT  RCV_TYPE  RCV_NUM  SRC1_TYPE  SRC1_NUM  DEMAND1   WITHDR1   UNMET1  SRC2_TYPE...
1    1    1    2000    1     hru          5        2        hru        5       res        1        150.5     145.2     5.3     aqu...
```

**Use Cases**:
- Real-time operational analysis
- Troubleshooting allocation problems
- Validation against observed data
- Short-term water management decisions

### 2. Monthly Output Files

#### `water_allo_mon.txt` / `water_allo_mon.csv`
**Purpose**: Monthly aggregated water allocation summaries.

**Content**:
- Monthly totals for demands, withdrawals, and unmet needs
- Source reliability statistics
- Seasonal allocation patterns
- Water rights performance tracking
- System efficiency metrics

**Use Cases**:
- Seasonal pattern analysis
- Monthly water budget assessments
- Drought response evaluation
- Regulatory compliance reporting

### 3. Annual Output Files

#### `water_allo_yr.txt` / `water_allo_yr.csv`
**Purpose**: Annual water allocation summaries and performance metrics.

**Content**:
- Annual water balance for each allocation object
- Source utilization statistics
- Unmet demand frequency and magnitude
- Water rights compliance summary
- System reliability metrics

**Use Cases**:
- Long-term planning and management
- Climate impact assessment
- System capacity evaluation
- Annual reporting and compliance

### 4. Average Annual Output Files

#### `water_allo_aa.txt` / `water_allo_aa.csv`
**Purpose**: Multi-year average conditions for system planning and design.

**Content**:
- Average annual demands, withdrawals, and shortages
- Source reliability under normal conditions
- System capacity utilization
- Long-term sustainability metrics
- Design performance indicators

**Use Cases**:
- System design and planning
- Capacity expansion analysis
- Sustainability assessment
- Policy development and evaluation

## Advanced Input Features

### 1. Compensation Mechanisms
Sources can be designated for compensation when primary sources fail:
```
TRN_NUM TRN_TYP ... (SRC_OBJECTS)
11      dtbl_irr ... res 1 pipe 6 1.0 n    aqu 2 pump 1 0.0 y
                     ^primary source      ^backup with compensation=yes
```

### 2. Multi-Source Allocations
Transfer objects can draw from multiple sources with priority order:
- Primary sources accessed first
- Backup sources with compensation flags activated when needed
- Proportional allocation from multiple sources

### 3. Dynamic Constraints
Source availability can vary by:
- **Monthly limits**: Seasonal constraints (e.g., minimum reservoir levels)
- **Decision tables**: Complex conditional constraints
- **Recall data**: Historical or forecasted availability patterns

### 4. Water Quality Integration
All transfer objects maintain constituent mass balance for:
- **Nutrients**: Nitrogen and phosphorus species
- **Salts**: Total dissolved solids and specific ions
- **Pathogens**: Bacterial and viral indicators
- **Pesticides**: Applied chemical concentrations
- **User-defined constituents**: Custom water quality parameters

## Input File Relationships

The water allocation input files form an integrated system:

```
water_allocation.wro (main config)
├── References: water_pipe.wal (conveyance)
├── References: water_treat.wal (treatment)
├── References: water_use.wal (end uses)
├── References: water_tower.wal (storage)
├── Uses: decision tables (*.dtl)
├── Integrates with: file.cio (control)
└── Outputs to: water_allo_*.txt/csv files
```

## Best Practices for Input Configuration

### 1. Start Simple
- Begin with basic source-demand pairs
- Add complexity incrementally
- Test each component before integration

### 2. Validate Constraints
- Ensure source limits are realistic and achievable
- Check that total demands don't exceed available supplies
- Verify pipe capacities match expected flows

### 3. Water Balance Checks
- Sum demands across all users
- Compare to total available supply
- Account for losses and inefficiencies

### 4. Seasonal Considerations
- Set appropriate monthly limits for sources
- Consider seasonal demand variations
- Account for climate and hydrologic variability

### 5. Water Rights Hierarchy
- Clearly define senior vs. junior rights
- Ensure proper priority ordering
- Test curtailment scenarios

This comprehensive input/output system enables detailed water allocation modeling while providing extensive monitoring and analysis capabilities for water management decision-making.