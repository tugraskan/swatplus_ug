# SWAT+ Water Allocation Subroutine Logic Flow

## Overview

The SWAT+ water allocation system is implemented through a structured hierarchy of Fortran subroutines that handle initialization, daily allocation decisions, and output generation. This document describes the complete subroutine flow, where each routine is located in the code, and when they are executed during the simulation.

## Initialization Phase

### 1. Model Startup and Input Reading (`main.f90.in`)

**Location**: `src/main.f90.in` (lines 94-100)
**Execution**: Once at model startup, before simulation loop

```fortran
! read water treatment and water allocation files - before hru lum tables
call om_treat_read          ! Read treatment plant data
call om_use_read           ! Read water use object data  
call water_treatment_read  ! Read treatment parameters
call water_use_read        ! Read use parameters
call water_tower_read      ! Read storage tower data
call water_pipe_read       ! Read conveyance system data
call water_allocation_read ! Read main allocation configuration
```

**Purpose**: Loads all water allocation configuration files and initializes data structures before the simulation begins.

### 2. Water Allocation Configuration Reader (`water_allocation_read.f90`)

**Location**: `src/water_allocation_read.f90`
**Execution**: Once during initialization
**Called from**: `main.f90.in`

```fortran
subroutine water_allocation_read
```

**Key Functions**:
1. **File Validation**: Checks for existence of `water_allocation.wro`
2. **Memory Allocation**: Allocates arrays for water allocation objects
3. **Configuration Parsing**: Reads allocation rules, sources, and transfer objects
4. **Data Structure Population**: Fills `wallo()` array with configuration data
5. **Output Arrays Initialization**: Sets up daily, monthly, yearly, and average annual output arrays
6. **Cross-referencing**: Links allocation objects to HRUs, channels, and other model objects

**Data Structures Created**:
- `wallo()`: Main water allocation object array
- `wallod_out()`, `wallom_out()`, `walloy_out()`, `walloa_out()`: Output tracking arrays
- Source and transfer object linkages

### 3. Output Header Generation (`header_water_allocation.f90`)

**Location**: `src/header_water_allocation.f90`
**Execution**: Once during initialization, after input reading
**Called from**: Initialization sequence in main program

```fortran
subroutine header_water_allocation
```

**Output Files Created**:
- `water_allo_day.txt` (daily output)
- `water_allo_mon.txt` (monthly output)  
- `water_allo_yr.txt` (yearly output)
- `water_allo_aa.txt` (average annual output)
- Corresponding `.csv` files if CSV output is enabled

## Daily Simulation Phase

### 4. Time Control Integration (`time_control.f90`)

**Location**: `src/time_control.f90` (lines 235-241)
**Execution**: Every simulation day, early in daily loop
**Called from**: Main simulation time loop

```fortran
!! allocate water for water rights objects
if (db_mx%wallo_db > 0) then
  do iwallo = 1, db_mx%wallo_db
    !! if a channel is not an object, call at beginning of day
    j = iwallo    ! to avoid a compiler warning
    if (wallo(iwallo)%cha_ob == "n") call wallo_control (j)
  end do
end if
```

**Logic**:
- Loops through all water allocation objects
- Calls `wallo_control` for objects not tied to specific channels
- Executes early in the daily simulation before most hydrologic processes

### 5. Channel-Based Water Allocation (`sd_channel_control.f90`)

**Location**: `src/sd_channel_control.f90` (lines 733-735)
**Execution**: Every simulation day, during channel processing
**Called from**: Channel control routine for each stream channel

```fortran
!! check decision table for water allocation
if (sd_ch(isdch)%wallo > 0) then
  call wallo_control (sd_ch(isdch)%wallo)
end if
```

**Logic**:
- Executes for water allocation objects tied to specific channels
- Called during channel routing, after flow calculations
- Allows allocation based on current channel flow conditions

## Core Water Allocation Logic

### 6. Main Allocation Control (`wallo_control.f90`)

**Location**: `src/wallo_control.f90`
**Execution**: Daily, for each water allocation object
**Called from**: `time_control.f90` or `sd_channel_control.f90`

```fortran
subroutine wallo_control (iwallo)
```

**Algorithm Flow**:
```
For each water allocation object:
  1. Zero demand, withdrawal, and unmet for entire allocation object
  2. For each transfer object (demand) in priority order:
     a. Zero demand/withdrawal/unmet for each source
     b. Compute flow from outside sources (if any)
     c. Set demand for the object → call wallo_demand()
     d. If demand > 0:
        - For each source in priority order:
          * Check availability and withdraw → call wallo_withdraw()
        - For sources with compensation enabled:
          * Try to meet remaining unmet demand → call wallo_withdraw()
        - Transfer water to receiving object → call wallo_transfer()
     e. Sum totals for entire allocation object
  3. Output results → call water_allocation_output()
```

**Key Variables**:
- `iwallo`: Water allocation object number
- `itrn`: Transfer object (demand) number  
- `isrc`: Source object number
- `wallo(iwallo)`: Main allocation object data structure

### 7. Demand Calculation (`wallo_demand.f90`)

**Location**: `src/wallo_demand.f90`
**Execution**: Daily, for each transfer object with demand
**Called from**: `wallo_control.f90`

```fortran
subroutine wallo_demand (iwallo, itrn, isrc)
```

**Demand Types Handled**:

**Municipal Demand (`muni`)**:
```fortran
case ("muni")
  if (wallo(iwallo)%trn(itrn)%trn_typ == "ave_day") then
    wallod_out(iwallo)%trn(itrn)%trn_flo = wallo(iwallo)%trn(itrn)%amount
  else
    ! Use decision table for variable demand
    call conditions (ich, id)
    call actions (ich, icmd, id)
    wallod_out(iwallo)%trn(itrn)%trn_flo = trans_m3
  end if
```

**Irrigation Demand (`hru`)**:
```fortran
case ("hru")
  j = wallo(iwallo)%trn(itrn)%rcv%num
  if (irrig(j)%demand > 0.) then
    if (hru(j)%irr_hmax > 0.) then
      ! Paddy/wetland irrigation based on target ponding depth
      demand = irrig(j)%demand
    else
      ! Standard irrigation based on water stress
      demand = wallo(iwallo)%trn(itrn)%amount * hru(j)%area_ha * 10.
    endif
  end if
```

**Decision Table Integration**:
- Links to irrigation decision tables (e.g., `irr_str8_dmd`)
- Evaluates conditions based on plant stress, soil moisture, climate
- Determines timing and amount of water application

### 8. Water Withdrawal (`wallo_withdraw.f90`)

**Location**: `src/wallo_withdraw.f90`
**Execution**: Daily, for each source with demand > 0
**Called from**: `wallo_control.f90`

```fortran
subroutine wallo_withdraw (iwallo, itrn, isrc)
```

**Source-Specific Withdrawal Logic**:

**Channel Sources (`cha`)**:
```fortran
case ("cha")
  j = wallo(iwallo)%trn(itrn)%src(isrc)%num
  cha_min = monthly_limit * 86400.  ! m3/s to m3/day
  cha_div = current_flow - cha_min  ! available above minimum
  if (demand < cha_div) then
    ! Can meet full demand
    withdraw_amount = demand
    update_channel_hydrograph()
  else
    ! Partial fulfillment only
    withdraw_amount = cha_div
    unmet_demand = demand - cha_div
  end if
```

**Reservoir Sources (`res`)**:
```fortran
case ("res")
  j = wallo(iwallo)%trn(itrn)%src(isrc)%num
  res_min = monthly_limit * reservoir_principal_volume
  res_vol_after = current_volume - demand
  if (res_vol_after > res_min) then
    ! Can meet demand without violating minimum level
    withdraw_amount = demand
    update_reservoir_storage()
  else
    ! Limited by minimum pool constraint
    withdraw_amount = current_volume - res_min
    unmet_demand = demand - withdraw_amount
  end if
```

**Aquifer Sources (`aqu`)**:
```fortran
case ("aqu")
  if (bsn_cc%gwflow == 0) then
    ! Standard SWAT+ aquifer
    avail = (max_depth - current_depth) * specific_yield * area
    withdraw_amount = min(demand, avail)
  else
    ! GWFlow integration - realistic pumping
    call gwflow_ppag(hru_number, demand, extracted, unmet)
    withdraw_amount = extracted
    unmet_demand = unmet
  end if
```

**Unlimited Sources (`unl`)**:
```fortran
case ("unl")
  ! Always meets full demand
  withdraw_amount = demand
  unmet_demand = 0.0
```

### 9. Water Transfer (`wallo_transfer.f90`)

**Location**: `src/wallo_transfer.f90`
**Execution**: Daily, after successful withdrawal
**Called from**: `wallo_control.f90`

```fortran
subroutine wallo_transfer (iwallo, itrn)
```

**Transfer Types**:

**Irrigation Transfer (`hru`)**:
```fortran
case ("hru")
  j = wallo(iwallo)%trn(itrn)%rcv%num
  irr_mm = total_withdrawal / (hru(j)%area_ha * 10.)  ! m3 to mm
  irrig(j)%applied = irr_mm * efficiency * (1 - runoff_fraction)
  irrig(j)%runoff = irr_mm * runoff_fraction
  ! Update salt and constituent mass balance
  if (cs_db%num_salts > 0) call salt_irrig(iwallo, itrn, j)
  if (cs_db%num_cs > 0) call cs_irrig(iwallo, itrn, j)
```

**Municipal/Treatment Transfer (`wtp`, `use`, `stor`)**:
```fortran
case ("wtp")
  j = wallo(iwallo)%trn(itrn)%rcv%num
  wtp_om_stor(j) = wtp_om_stor(j) + withdrawn_hydrograph
  call wallo_treatment (iwallo, j)  ! Apply treatment processes

case ("use")
  j = wallo(iwallo)%trn(itrn)%rcv%num
  wuse_om_stor(j) = wuse_om_stor(j) + withdrawn_hydrograph
  call wallo_use (iwallo, j)  ! Apply use processes
```

### 10. Treatment and Use Processing (`wallo_treatment.f90`, `wallo_use.f90`)

**Location**: `src/wallo_treatment.f90`, `src/wallo_use.f90`
**Execution**: When water is transferred to treatment or use objects
**Called from**: `wallo_transfer.f90`

**Treatment Processing**:
- Applies treatment efficiency factors
- Modifies water quality constituents
- Generates treated effluent for discharge
- Accounts for treatment losses and lag times

**Use Processing**:
- Applies use efficiency factors
- Generates return flows and wastewater
- Tracks water consumption vs. return
- Handles constituent fate during use

## Output Generation

### 11. Water Allocation Output (`water_allocation_output.f90`)

**Location**: `src/water_allocation_output.f90`
**Execution**: Daily, monthly, yearly, and average annual intervals
**Called from**: `wallo_control.f90` and time-based output routines

```fortran
subroutine water_allocation_output (iwallo)
```

**Output Processing**:
1. **Daily**: Accumulates daily values for each source and demand
2. **Monthly**: Sums daily values at month end, writes monthly output
3. **Yearly**: Sums monthly values at year end, writes yearly output  
4. **Average Annual**: Averages yearly values over simulation period

**Output Variables Tracked**:
- `wallod_out()`: Daily output arrays
- `wallom_out()`: Monthly output arrays  
- `walloy_out()`: Yearly output arrays
- `walloa_out()`: Average annual output arrays

## Integration with SWAT+ Model Components

### Hydrologic Integration
- **Channel Routing**: Water allocation affects channel flows through diversions
- **Reservoir Operations**: Withdrawals modify reservoir storage and releases
- **Groundwater**: Pumping affects aquifer storage and water table depths
- **Irrigation**: Applied water affects soil moisture, evapotranspiration, and runoff

### Water Quality Integration
- **Constituent Transport**: All transfers maintain mass balance for nutrients, salts, pesticides
- **Treatment Effects**: Water treatment modifies constituent concentrations
- **Agricultural Applications**: Irrigation carries constituents to soil and groundwater

### Timing and Sequencing
```
Daily Simulation Order:
1. Climate and Weather Generation
2. Early Water Allocation (time_control.f90)
   - Non-channel allocation objects processed
3. Hydrologic Processes (HRU level)
   - Runoff, percolation, ET calculated
4. Channel Routing and Late Allocation
   - Channel flows calculated
   - Channel-based allocation objects processed
5. Reservoir Operations
6. Output Generation
```

## Error Handling and Debugging

### Common Issues and Diagnostic Points
1. **Insufficient Water**: Check source availability vs. total demands
2. **Unmet Demands**: Review constraint limits and compensation settings
3. **Mass Balance Errors**: Verify withdrawal and transfer calculations
4. **Performance Issues**: Optimize decision table complexity

### Debug Output Locations
- **Daily tracking**: `wallod_out()` arrays
- **Source diagnostics**: Individual source withdrawal records
- **Transfer diagnostics**: Individual transfer object performance
- **System totals**: Allocation object summary statistics

## File Dependencies and Build Integration

### Source File Compilation Order
```
1. water_allocation_module.f90     (data structures)
2. water_allocation_read.f90       (initialization)
3. wallo_demand.f90                (demand calculation)
4. wallo_withdraw.f90              (water extraction)
5. wallo_transfer.f90              (water delivery)
6. wallo_treatment.f90             (treatment processing)
7. wallo_control.f90               (main control logic)
8. water_allocation_output.f90     (output generation)
9. header_water_allocation.f90     (output file headers)
```

### Module Dependencies
- `water_allocation_module`: Core data structures
- `hydrograph_module`: Water balance and constituent tracking
- `time_module`: Simulation timing and calendar
- `conditional_module`: Decision table integration
- `hru_module`: HRU irrigation interface
- `reservoir_module`: Reservoir operations interface
- `aquifer_module`: Groundwater interface

This comprehensive subroutine flow enables flexible, efficient water allocation modeling while maintaining integration with all SWAT+ model components and providing detailed performance monitoring capabilities.