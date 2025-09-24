# SWAT+ Water Allocation Program Flow and Timeline

This document explains how the water allocation system is integrated into the SWAT+ program execution and provides a detailed timeline of the allocation process.

## Program Integration Overview

The water allocation system is called at two specific points during the daily simulation loop:

1. **Early in the day** - for water allocation objects not associated with channels (`cha_ob == "n"`)
2. **During channel routing** - for water allocation objects associated with channels (`cha_ob == "y"`)

## Initialization Phase

### Program Startup (`main.f90.in`)
```fortran
! Lines 94-100 in main.f90.in
call om_treat_read
call om_use_read  
call water_treatment_read
call water_use_read
call water_tower_read
call water_pipe_read
call water_allocation_read    ! Read water allocation configuration
```

**Purpose**: Load all water allocation configuration files during model initialization.

## Daily Simulation Loop

### 1. Early Day Water Allocation (`time_control.f90`)

**Location**: `time_control.f90`, line 239
**Timing**: Early in the daily loop, before channel routing

```fortran
!! allocate water for water rights objects
if (db_mx%wallo_db > 0) then
  do iwallo = 1, db_mx%wallo_db
    !! if a channel is not an object, call at beginning of day
    j = iwallo
    if (wallo(iwallo)%cha_ob == "n") call wallo_control (j)
  end do
end if
```

**Applies to**: Water allocation objects where `cha_ob = "n"` in configuration
**Examples**: Municipal water systems, irrigation systems not dependent on channel flow

### 2. Channel-Associated Water Allocation (`sd_channel_control.f90`)

**Location**: `sd_channel_control.f90`, line 734
**Timing**: During channel routing, after channel flow calculations

```fortran
!! check decision table for water allocation
if (sd_ch(isdch)%wallo > 0) then
  call wallo_control (sd_ch(isdch)%wallo)
end if
```

**Applies to**: Water allocation objects where `cha_ob = "y"` in configuration
**Examples**: Channel diversions, flow-dependent allocations

## Water Allocation Process Flow

### Core Algorithm Timeline (`wallo_control.f90`)

```
1. Initialize allocation object → wallo(iwallo)%tot = walloz
2. For each transfer object (itrn = 1 to trn_obs):
   a. Zero source outputs → wallod_out(iwallo)%trn(itrn)%src(isrc) = walloz
   b. Compute outside source flows → osrc_om_out(iosrc)%flo = limit_mon(time%mo)
   c. Calculate demand → call wallo_demand (iwallo, itrn)
   d. Withdraw water → call wallo_withdraw (iwallo, itrn)
   e. Transfer water → call wallo_transfer (iwallo, itrn)
3. Output results → call water_allocation_output (iwallo)
```

## Detailed Process Flowchart

```
┌─────────────────────────────────────────────────────────────────┐
│                    SWAT+ DAILY SIMULATION LOOP                 │
└─────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────┐
│              EARLY DAY WATER ALLOCATION                         │
│                (time_control.f90:239)                          │
│                                                                 │
│  For each water allocation object where cha_ob = "n":          │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │              call wallo_control(iwallo)                 │   │
│  └─────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────┐
│                    CHANNEL ROUTING                              │
│              (sd_channel_control.f90)                          │
└─────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────┐
│           CHANNEL-BASED WATER ALLOCATION                       │
│                (sd_channel_control.f90:734)                    │
│                                                                 │
│  For each channel with associated allocation:                   │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │        call wallo_control(sd_ch(isdch)%wallo)           │   │
│  └─────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────┐
│                 WALLO_CONTROL ALGORITHM                         │
│                  (wallo_control.f90)                           │
│                                                                 │
│  1. Initialize: wallo(iwallo)%tot = walloz                     │
│                                                                 │
│  2. For each transfer object (itrn):                           │
│     ┌─────────────────────────────────────────────────────┐   │
│     │  a. Zero outputs: wallod_out = walloz              │   │
│     │  b. Compute outside sources                        │   │
│     │  c. Calculate demand: call wallo_demand(iwallo,itrn)│   │
│     │  d. Withdraw water: call wallo_withdraw(iwallo,itrn)│   │
│     │  e. Transfer water: call wallo_transfer(iwallo,itrn)│   │
│     └─────────────────────────────────────────────────────┘   │
│                                                                 │
│  3. Output results: call water_allocation_output(iwallo)       │
└─────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────┐
│              DETAILED TRANSFER PROCESS                          │
│                                                                 │
│  ┌─────────────────┐    ┌─────────────────┐    ┌──────────────┐│
│  │  WALLO_DEMAND   │───▶│ WALLO_WITHDRAW  │───▶│ WALLO_TRANSFER││
│  │                 │    │                 │    │              ││
│  │• Calculate water│    │• Check source   │    │• Move water  ││
│  │  demand based   │    │  availability   │    │  to receiver ││
│  │  on transfer    │    │• Apply          │    │• Update      ││
│  │  type (ave_day, │    │  constraints    │    │  hydrographs ││
│  │  dtbl_irr, etc.)│    │• Withdraw water │    │• Apply       ││
│  │• Set unmet      │    │• Update unmet   │    │  treatments  ││
│  │  demand         │    │  demand         │    │              ││
│  └─────────────────┘    └─────────────────┘    └──────────────┘│
└─────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────┐
│                    OUTPUT GENERATION                            │
│              (water_allocation_output.f90)                     │
│                                                                 │
│  • Daily outputs (if pco%water_allo%d = "y")                   │
│  • Monthly summaries (if pco%water_allo%m = "y")               │
│  • Yearly summaries (if pco%water_allo%y = "y")                │
│  • Average annual (if pco%water_allo%a = "y")                  │
└─────────────────────────────────────────────────────────────────┘
```

## Transfer Type Processing

### Different Transfer Types and Their Timing

1. **`ave_day`** - Fixed daily amount allocation
   - **Timing**: Processed every day during wallo_control call
   - **Logic**: Direct allocation of specified amount (m³/day)

2. **`dtbl_irr`** - Decision table controlled irrigation
   - **Timing**: Evaluated based on decision table conditions
   - **Logic**: Uses decision tables like `irr_str8_dmd` to determine irrigation needs

3. **`outflo`** - Outflow transfers (treatment, disposal)
   - **Timing**: Processed as available water flows through system
   - **Logic**: Transfers available water based on flow fractions

## Water Source Processing Order

1. **Outside Sources** (`osrc`) - Computed first based on monthly limits
2. **Internal Sources** - Processed by availability:
   - Reservoirs (`res`) - Based on storage and minimum levels
   - Aquifers (`aqu`) - Based on depth constraints
   - Channels (`cha`) - Based on flow availability

## Integration Points

### Hydrologic Model Connection
- Water allocation occurs **after** hydrologic processes (runoff, ET, etc.)
- **Before** channel routing for non-channel allocations
- **During** channel routing for channel-based allocations

### Decision Table Integration
- Decision tables evaluated during `wallo_demand` phase
- Conditions checked against current state (soil moisture, date, etc.)
- Actions executed if conditions are met

### Output Integration
- Results integrated into SWAT+ output system
- Multiple temporal scales (daily, monthly, yearly, average annual)
- Coordinated with existing SWAT+ print control system

## Performance Considerations

### Computational Sequence
1. **Most efficient**: Non-channel allocations processed once per day
2. **Channel-dependent**: Processed during channel routing (once per channel)
3. **Transfer processing**: Sequential by transfer number (priority implicit)

### Memory Management
- Temporary variables zeroed each iteration: `wallod_out = walloz`
- Cumulative totals maintained: `wallom_out`, `walloy_out`, `walloa_out`
- Output arrays allocated based on configuration: `db_mx%wallo_db`

## Configuration Impact on Timing

### `cha_ob` Parameter Controls When Allocation Occurs:
- **`cha_ob = "n"`**: Early day processing in `time_control.f90`
- **`cha_ob = "y"`**: Channel routing processing in `sd_channel_control.f90`

### Transfer Priority:
- Processing order determined by `TRN_NUM` sequence in configuration
- Lower numbers processed first (implicit priority system)

This timeline ensures that water allocation integrates seamlessly with SWAT+'s hydrologic processes while maintaining computational efficiency and allowing for both flow-independent and flow-dependent allocation strategies.