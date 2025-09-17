# SWAT+ Water Allocation Logic Documentation

## Overview

The SWAT+ water allocation module provides a comprehensive framework for simulating water transfers between different sources and demand objects within a watershed. This system allows for realistic modeling of irrigation, municipal water supply, inter-basin transfers, and other water management scenarios while respecting physical constraints and water rights priorities.

> **Note**: This document supplements the existing "Water Allocation Working Document.docx" with detailed technical documentation of the current implementation. For the latest working notes and development updates, refer to both documents.

## Key Concepts

### Water Sources
Water can be sourced from multiple locations with different availability constraints:
- **Channels (cha)**: Surface water from streams/rivers with minimum flow requirements
- **Reservoirs (res)**: Storage water with minimum pool level constraints  
- **Aquifers (aqu)**: Groundwater with maximum drawdown limits
- **Unlimited sources (unl)**: Theoretical unlimited water supply (e.g., large rivers/lakes)

### Demand Objects
Water demands are categorized by use type:
- **HRU irrigation (hru)**: Agricultural irrigation demand based on crop water needs
- **Municipal (muni)**: Urban water supply for domestic/commercial use
- **Inter-basin diversions (divert)**: Water transfers between basins

### Water Rights
The system supports water rights prioritization:
- **Senior rights (sr)**: Higher priority allocations that are satisfied first
- **Junior rights (jr)**: Lower priority allocations satisfied after senior rights

## Core Components

### 1. Water Allocation Control (`wallo_control.f90`)

This is the main orchestration module that:
- Loops through all water allocation objects
- Processes each demand object in priority order
- Coordinates the demand-withdraw-transfer sequence
- Handles compensation mechanisms when sources are unavailable
- Tracks total system-wide water balance

**Key Algorithm Flow:**
```
For each water allocation object:
  For each demand object:
    1. Calculate demand amount
    2. Check water availability from each source
    3. Process withdrawals respecting constraints
    4. Handle compensation from alternative sources
    5. Transfer water to receiving object
    6. Update irrigation/municipal use accounting
```

### 2. Demand Calculation (`wallo_demand.f90`)

Determines water demand based on object type:

**Municipal Demand:**
- Fixed daily amount (m³/day) specified in input files
- Can use decision tables for variable demand patterns
- May incorporate recall data for historical demand patterns

**Irrigation Demand:**
- Calculated from crop water stress and soil moisture deficit
- Considers irrigation efficiency and application losses
- Uses HRU-specific crop and soil parameters
- Can be overridden with fixed amounts for specific scenarios

**Inter-basin Diversions:**
- Uses decision tables to determine transfer amounts
- Based on flow conditions and operational rules
- Can incorporate environmental flow requirements

### 3. Water Withdrawal (`wallo_withdraw.f90`)

Handles the actual water extraction from sources with physical constraints:

**Channel Withdrawals:**
```fortran
! Calculate available water above minimum flow
available_flow = channel_flow - minimum_flow_limit
if (demand < available_flow) then
    withdraw_amount = demand
    update_channel_flow()
else
    withdraw_amount = available_flow
    unmet_demand = demand - available_flow
end if
```

**Reservoir Withdrawals:**
```fortran
! Check if withdrawal maintains minimum pool level
remaining_volume = reservoir_volume - demand
if (remaining_volume > minimum_volume) then
    withdraw_amount = demand
    update_reservoir_storage()
else
    withdraw_amount = reservoir_volume - minimum_volume
    unmet_demand = demand - withdraw_amount
end if
```

**Aquifer Withdrawals:**
- Standard SWAT+ aquifer: Based on water table depth and specific yield
- GWFlow integration: Uses detailed groundwater flow modeling for realistic pumping
- Considers sustainable yield limits and drawdown constraints

### 4. Water Transfer (`wallo_transfer.f90`)

Delivers withdrawn water to receiving objects:

**Irrigation Transfers:**
- Converts m³ to mm depth over HRU area
- Applies irrigation efficiency factors
- Calculates surface runoff from irrigation
- Updates soil moisture and plant water stress
- Handles salt and constituent mass balance

**Reservoir/Aquifer Transfers:**
- Direct volume additions to storage
- Maintains water quality constituent concentrations
- Updates hydrologic balance

**Treatment/Use Objects:**
- Routes water through treatment processes
- Applies treatment efficiency factors
- Generates effluent discharge

## Input File Structure

### Water Allocation File (`water_allocation.wro`)

The main configuration file defines:
- Allocation object names and types
- Source and demand object specifications
- Priority rules and constraints
- Conveyance system properties

**Example Structure:**
```
water_allocation.wro
10                           ! number of allocation objects

name        rule_typ  src_obs  dmd_obs  cha_ob
irrigation1    priority     3       2       0

! Source objects
src_obj  src_typ  src_num  lim_typ   lim_val1  lim_val2  ...
cha      cha      1        mon_lim   2.0       1.5       ...
res      res      1        mon_lim   0.3       0.3       ...
aqu      aqu      1        mon_lim   10.0      8.0       ...

! Demand objects  
dmd_obj  dmd_typ  dmd_num  withdr    amount   right  treat_typ
hru      hru      1        irrig     0.0      sr     null
muni     muni     1        ave_day   1000.0   jr     treat1
```

### Key Parameters:
- **rule_typ**: Allocation methodology (priority, proportional, etc.)
- **lim_typ**: How to determine source availability (monthly limits, decision tables, recall data)
- **withdr**: Withdrawal methodology (irrigation-based, average daily, recall data)
- **amount**: Fixed demand amount or scaling factor
- **right**: Water rights priority (sr/jr)

## Practical Configuration Examples

### Example 1: Simple Irrigation System

**Scenario**: Irrigate 100 ha of crops from a nearby river with minimum flow constraints.

```
water_allocation.wro
1                           ! number of allocation objects

! Allocation object definition
name        rule_typ  src_obs  dmd_obs  cha_ob
farm_irrig    priority     1       1       0

! Source definition - river with minimum flow
src_obj  src_typ  src_num  lim_typ   jan   feb   mar   apr   may   jun   jul   aug   sep   oct   nov   dec
river1     cha      1      mon_lim   2.0   1.5   1.0   0.8   0.5   0.3   0.2   0.2   0.3   0.5   1.0   1.5

! Demand definition - HRU irrigation
dmd_obj  dmd_typ  dmd_num  withdr   amount  right  treat_typ  rcv_obj  rcv_num  
field1     hru      1      irrig     0.0     sr      null      hru       1

! Source-demand connections
src_connections
1  1  1.0  n    ! source 1 supplies 100% to demand 1, no compensation
```

### Example 2: Municipal Water Supply with Backup Sources

**Scenario**: City water supply from reservoir with groundwater backup during drought.

```
water_allocation.wro
1                           ! number of allocation objects

! Allocation object
name        rule_typ  src_obs  dmd_obs  cha_ob  
city_water   priority     2       1       0

! Primary source - reservoir
src_obj  src_typ  src_num  lim_typ   jan   feb   mar   apr   may   jun   jul   aug   sep   oct   nov   dec
lake1      res      1      mon_lim   0.3   0.3   0.25  0.25  0.2   0.15  0.15  0.15  0.2   0.25  0.3   0.3

! Backup source - aquifer  
src_obj  src_typ  src_num  lim_typ   jan   feb   mar   apr   may   jun   jul   aug   sep   oct   nov   dec
well1      aqu      1      mon_lim   15.0  15.0  12.0  12.0  10.0  8.0   8.0   8.0   10.0  12.0  15.0  15.0

! Municipal demand
dmd_obj  dmd_typ  dmd_num  withdr   amount  right  treat_typ  rcv_obj  rcv_num
city1      muni     1      ave_day  5000.0   sr     wtp1      use       1

! Source connections
src_connections  
1  1  0.8  n    ! reservoir supplies 80%, no compensation
2  1  0.2  y    ! aquifer supplies 20%, compensates if reservoir fails
```

### Example 3: Complex Multi-User System

**Scenario**: River system serving irrigation, municipal, and environmental needs with water rights.

```
water_allocation.wro
3                           ! number of allocation objects

! Senior irrigation rights
name        rule_typ  src_obs  dmd_obs  cha_ob
sr_irrigation priority    2       2       0

! Municipal water (junior rights)  
name        rule_typ  src_obs  dmd_obs  cha_ob
municipal    priority     2       1       0

! Environmental flows
name        rule_typ  src_obs  dmd_obs  cha_ob  
env_flows    priority     1       1       0

! Shared sources
src_obj  src_typ  src_num  lim_typ   jan   feb   mar   apr   may   jun   jul   aug   sep   oct   nov   dec
river      cha      1      mon_lim   5.0   4.0   3.0   2.5   2.0   1.5   1.0   1.0   1.5   2.0   3.0   4.0
storage    res      1      mon_lim   0.4   0.4   0.3   0.3   0.25  0.2   0.15  0.15  0.2   0.25  0.3   0.4

! Senior irrigation demands
dmd_obj  dmd_typ  dmd_num  withdr   amount  right  treat_typ  rcv_obj  rcv_num
farm_a     hru      5      irrig     0.0     sr      null      hru       5  
farm_b     hru      8      irrig     0.0     sr      null      hru       8

! Municipal demand (junior)
dmd_obj  dmd_typ  dmd_num  withdr   amount  right  treat_typ  rcv_obj  rcv_num
town1      muni     1      ave_day  2000.0   jr     wtp1      use       1

! Environmental flow requirement
dmd_obj  dmd_typ  dmd_num  withdr   amount  right  treat_typ  rcv_obj  rcv_num  
env1       div      1      ave_day  1000.0   sr      null      cha       2
```

## Output Files

The system generates detailed output files at multiple temporal scales:

### Daily Output (`water_allo_day.txt`)
- Real-time water allocation decisions
- Source-specific withdrawals and unmet demands
- Useful for operational analysis and troubleshooting

### Monthly Output (`water_allo_mon.txt`) 
- Monthly summaries of water allocation performance
- Seasonal pattern analysis
- Water rights compliance tracking

### Annual Output (`water_allo_yr.txt`)
- Yearly water balance summaries  
- Long-term sustainability assessment
- Climate impact evaluation

### Average Annual Output (`water_allo_aa.txt`)
- Multi-year average conditions
- System capacity and reliability metrics
- Planning and design applications

## Technical Implementation Details

### Data Structures

The water allocation system uses several key Fortran derived types:

**Water Allocation Object (`water_allocation`):**
```fortran
type water_allocation
  character(len=25) :: name                    ! allocation object name
  character(len=10) :: rule_typ                ! allocation rule type
  integer :: src_obs                           ! number of source objects
  integer :: dmd_obs                           ! number of demand objects
  integer :: cha_ob                           ! associated channel object
  type(water_source_objects), allocatable :: src(:)
  type(water_demand_objects), allocatable :: dmd(:)
end type
```

**Source Output Tracking (`source_output`):**
```fortran
type source_output
  real :: demand = 0.                         ! water demand (m³)
  real :: withdr = 0.                         ! amount withdrawn (m³)
  real :: unmet = 0.                          ! unmet demand (m³)
end type
```

### Allocation Priority Logic

The system processes water allocations in a hierarchical manner:

1. **Senior Rights First**: All senior water rights are processed before junior rights
2. **Source Priority**: Within each demand object, sources are accessed in specified order
3. **Compensation Rules**: Failed sources trigger compensation from designated backup sources

**Priority Processing Algorithm:**
```fortran
! Process all senior rights first
do iwallo = 1, num_wallo_objects
  do idmd = 1, wallo(iwallo)%dmd_obs
    if (wallo(iwallo)%dmd(idmd)%right == "sr") then
      call wallo_demand(iwallo, idmd)
      call wallo_withdraw(iwallo, idmd)
      call wallo_transfer(iwallo, idmd)
    end if
  end do
end do

! Then process junior rights
do iwallo = 1, num_wallo_objects
  do idmd = 1, wallo(iwallo)%dmd_obs  
    if (wallo(iwallo)%dmd(idmd)%right == "jr") then
      call wallo_demand(iwallo, idmd)
      call wallo_withdraw(iwallo, idmd)
      call wallo_transfer(iwallo, idmd)
    end if
  end do
end do
```

### Constraint Handling

**Monthly Varying Constraints:**
Sources can have different availability limits for each month:
```fortran
real, dimension(12) :: limit_mon = 0.
! limit_mon(1) = January constraint
! limit_mon(2) = February constraint
! ... etc.
```

**Dynamic Constraint Evaluation:**
```fortran
select case (constraint_type)
  case ("mon_lim")
    current_limit = source_limit(current_month)
  case ("dtbl") 
    call decision_table_evaluation(dtbl_id, current_limit)
  case ("recall")
    current_limit = recall_data(current_day)
end select
```

## Advanced Features

### Compensation Mechanisms
When primary sources cannot meet demand, the system can:
- Automatically access backup sources marked for compensation
- Maintain water rights priority during compensation
- Track compensation usage for reporting

**Compensation Logic:**
```fortran
! First pass - try primary sources
do isrc = 1, num_sources
  if (source_available(isrc)) then
    call withdraw_water(isrc, remaining_demand)
  end if
end do

! Second pass - compensation sources for unmet demand
do isrc = 1, num_sources
  if (wallo(iwallo)%dmd(idmd)%src(isrc)%comp == "y" .and. remaining_demand > 0) then
    call withdraw_water(isrc, remaining_demand)
  end if
end do
```

### Decision Table Integration
Complex allocation rules can be implemented using decision tables that:
- Incorporate multiple environmental conditions
- Implement adaptive management strategies
- Support stakeholder-negotiated operating rules

**Example Decision Table Logic:**
```
Conditions:
- Stream flow > 10 m³/s AND reservoir level > 80%: Allow full irrigation
- Stream flow 5-10 m³/s OR reservoir level 60-80%: Allow 75% irrigation  
- Stream flow < 5 m³/s AND reservoir level < 60%: Allow 50% irrigation
```

### Water Quality Tracking
The system maintains constituent mass balance for:
- Nutrients (nitrogen, phosphorus)
- Salts and minerals
- User-defined constituents
- Pathogen and heavy metal transport

**Mass Balance Calculations:**
```fortran
! Calculate constituent concentrations in withdrawn water
withdrawal_mass = source_concentration * withdrawal_volume
remaining_mass = source_mass - withdrawal_mass
new_source_concentration = remaining_mass / remaining_volume
```

### GWFlow Integration
Advanced groundwater modeling capabilities:
- 3D groundwater flow simulation
- Realistic well pumping constraints
- Aquifer-stream interaction effects
- Sustainable yield assessment

**GWFlow Pumping Logic:**
```fortran
if (bsn_cc%gwflow == 1) then
  call gwflow_ppag(hru_number, demand_m3, extracted, unmet)
  withdrawal = extracted
  unmet_demand = unmet
else
  ! Use simplified aquifer approach
  available = (max_depth - current_depth) * specific_yield * area
  withdrawal = min(demand, available)
end if
```

## Best Practices

### Model Setup
1. **Start Simple**: Begin with basic source-demand pairs before adding complexity
2. **Validate Constraints**: Ensure minimum flow/level constraints are realistic
3. **Check Water Balance**: Verify that total demands don't exceed available supplies
4. **Test Scenarios**: Run multiple climate/demand scenarios to test robustness

### Calibration

#### Parameter Calibration Steps

1. **Match Observed Withdrawals**: 
   - Compare simulated vs. observed irrigation/municipal use
   - Adjust demand amounts and efficiency factors
   - Validate seasonal irrigation patterns

**Calibration Metrics**:
```
R² > 0.7 for monthly irrigation volumes
NSE > 0.5 for annual municipal withdrawals  
PBIAS < ±25% for total system withdrawals
```

**Calibration Code Example**:
```fortran
! Calculate performance metrics
observed_total = sum(observed_withdrawals)
simulated_total = sum(simulated_withdrawals)
pbias = 100.0 * (simulated_total - observed_total) / observed_total

mean_observed = observed_total / num_years
ss_res = sum((observed_withdrawals - simulated_withdrawals)**2)
ss_tot = sum((observed_withdrawals - mean_observed)**2)
r_squared = 1.0 - (ss_res / ss_tot)
```

2. **Validate Environmental Flows**: 
   - Ensure minimum flow constraints are met
   - Check compliance with environmental flow requirements
   - Verify low-flow period protection

3. **Check Unmet Demands**: 
   - Investigate and resolve excessive unmet demand periods
   - Validate against historical shortage events
   - Ensure reasonable shortage frequency and duration

4. **Assess Water Rights**: 
   - Verify senior rights are properly prioritized  
   - Check junior rights curtailment during shortages
   - Validate against legal/institutional arrangements

#### Sensitivity Analysis

Test model sensitivity to key parameters:

**Critical Parameters**:
- Monthly source constraints (±20%)
- Irrigation efficiency factors (±10%)  
- Municipal demand growth rates (±15%)
- Minimum flow requirements (±30%)

**Sensitivity Testing Code**:
```fortran
! Parameter sensitivity loop
do i = 1, num_parameters
  parameter_value = base_value * (1.0 + sensitivity_range(i))
  call run_model_scenario(parameter_value)
  call calculate_output_metrics()
  sensitivity(i) = (new_metric - base_metric) / base_metric
end do
```

#### Uncertainty Quantification

Assess model uncertainty through:

**Monte Carlo Analysis**:
- Sample parameter distributions
- Run multiple model realizations
- Quantify output uncertainty ranges

**Scenario Analysis**:
- Test climate change scenarios
- Evaluate different demand projections  
- Assess infrastructure expansion impacts

#### Multi-Objective Calibration

Balance competing objectives:
- **Water supply reliability**: Minimize unmet demands
- **Environmental protection**: Maintain minimum flows
- **Economic efficiency**: Maximize beneficial use
- **Equity**: Fair allocation among users

**Pareto Optimization Approach**:
```
Objective 1: Minimize(unmet_demand_penalty)
Objective 2: Minimize(environmental_flow_violations)  
Objective 3: Maximize(economic_benefits)
Subject to: Physical and legal constraints
```

### Troubleshooting
Common issues and solutions:

#### 1. Excessive Unmet Demand
**Symptoms**: Large unmet demands in output files, especially during dry periods
**Causes**: 
- Source constraints too restrictive
- Insufficient water availability
- Incorrect demand calculations

**Solutions**:
- Review monthly limit constraints for realism
- Check if total demands exceed basin water availability  
- Verify irrigation demand calculations match crop needs
- Consider adding backup sources with compensation

**Debugging Code Example**:
```fortran
! Add debug output to wallo_withdraw.f90
write(*,*) 'Source availability check:'
write(*,*) 'Source type:', wallo(iwallo)%dmd(idmd)%src_ob(isrc)%ob_typ
write(*,*) 'Available water:', available_water
write(*,*) 'Demand:', trn_m3
write(*,*) 'Constraint limit:', constraint_limit
```

#### 2. Unrealistic Withdrawals
**Symptoms**: Withdrawals exceed physical source capacity or violate constraints
**Causes**:
- Incorrect unit conversions (m³ vs mm)
- Missing or incorrect constraint definitions
- Logic errors in withdrawal calculations

**Solutions**:
- Verify all units are consistent (m³ for volumes, m³/s for flows)
- Check that monthly constraints are properly specified
- Validate HRU areas for irrigation calculations
- Test with simplified single-source scenarios first

#### 3. Water Balance Errors  
**Symptoms**: Water appearing or disappearing from the system
**Causes**:
- Missing mass balance accounting
- Incorrect hydrograph updates
- Constituent mass balance errors

**Solutions**:
- Add water balance checks at key points
- Verify hydrograph updates maintain conservation
- Check constituent concentration calculations
- Use simpler scenarios to isolate problems

**Water Balance Check Code**:
```fortran
! Add to wallo_control.f90
total_withdrawal = 0.
total_unmet = 0.  
do itrn = 1, wallo(iwallo)%trn_obs
  total_withdrawal = total_withdrawal + wallo(iwallo)%trn(itrn)%withdr_tot
  total_unmet = total_unmet + wallo(iwallo)%trn(itrn)%unmet_m3
end do
write(*,*) 'Total demand:', total_withdrawal + total_unmet
write(*,*) 'Total withdrawal:', total_withdrawal  
write(*,*) 'Total unmet:', total_unmet
```

#### 4. Performance Issues
**Symptoms**: Long simulation times, memory problems
**Causes**:
- Too many allocation objects or sources
- Complex decision table evaluations
- Inefficient loops or calculations

**Solutions**:
- Simplify allocation structure where possible
- Reduce decision table complexity
- Combine similar demand objects
- Profile code to identify bottlenecks

#### 5. Output File Problems
**Symptoms**: Missing output files, formatting errors
**Causes**:
- Output flags not set correctly
- File path or permission issues
- Format specification errors

**Solutions**:
- Verify print control settings in file.cio
- Check file write permissions in output directory
- Ensure adequate disk space for output files
- Test with single allocation object first

## Future Enhancements

Potential improvements under development:
- **Conveyance losses**: Explicit modeling of canal and pipeline losses
- **Economic optimization**: Cost-based allocation decisions
- **Uncertainty analysis**: Monte Carlo simulation capabilities
- **Climate adaptation**: Dynamic rule adjustment based on climate projections
- **Stakeholder integration**: Web-based interfaces for participatory modeling

## References

1. Arnold, J.G., et al. (2012). SWAT: Model use, calibration, and validation. Transactions of the ASABE, 55(4), 1491-1508.
2. Bieger, K., et al. (2017). Introduction to SWAT+, a completely restructured version of the Soil and Water Assessment Tool. Journal of the American Water Resources Association, 53(1), 115-130.
3. Wagner, P.D., et al. (2019). Dynamic integration of land use changes in a hydrologic assessment of a rapidly developing Indian catchment. Science of the Total Environment, 693, 133613.

## Contact and Support

For technical support and questions about the water allocation module:
- SWAT+ Development Team: swatplus@tamu.edu
- Documentation Issues: [GitHub Issues](https://github.com/swat-model/swatplus/issues)
- User Forum: [SWAT Community](https://swat.tamu.edu/community/)