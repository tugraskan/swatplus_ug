# Water Allocation Network Implementation Guide

This directory provides sample input files and documentation for implementing a comprehensive water allocation network in SWAT+ based on the specified requirements.

## Problem Statement Implementation

The water allocation network implements the following system as described in the problem statement:

### Complete Network Summary

**Objects (Total: 15)**
- 3 HRUs (HRU1, HRU2, HRU3)
- 2 Aquifers (Aqu1, Aqu2) 
- 1 Reservoir (Res1)
- 1 Source (Src1)
- 2 Storages (Stor1, Stor2)
- 3 Water Treatment Plants (WTP1, WTP2, WTP3)  
- 2 Users (I_Use1, D_Use1)
- 2 Channels (Cha1, Cha2)

**Routing Connections**
1. HRU1 → Res1 (total); HRU1 → Aqu1 (recharge)
2. Aqu1 → Res1 (total)
3. HRU2: no routing; Stor1 → HRU2 (Irr_Lawn)
4. HRU3 → Aqu2 (recharge); Res1 → HRU3 (Irr_Ag)
5. Src1 → Res1

**Treatment Pipeline**
6. Res1 → WTP1 (Pipe1)
7. WTP1 → Stor1 (Pipe2)

**Storage Distribution**
8. Stor1 → I_Use1 (Pipe3)
9. Stor1 → D_Use1 (Pipe4)
10. Stor1 → WTP3 (Pipe8)
11. Stor1 → HRU2 (Irr_Lawn)

**User Treatment Loop**
12. I_Use1 → WTP2 (Pipe5)
13. D_Use1 → WTP2 (Pipe6)  
14. WTP2 → Cha1 (Pipe7)

**Secondary Treatment**
15. WTP3 → Cha2 (Pipe10)
16. WTP3 → Stor2 (Pipe9)

**Irrigation Loops**
- Stor1 → HRU2 (Irr_Lawn)
- Res1 → HRU3 (Irr_Ag)

## File Structure and Implementation

### Core Configuration Files

1. **water_allocation.wro** - Main allocation object definition
   - Defines water sources (reservoirs, aquifers, unlimited sources)
   - Specifies demand objects (HRUs, treatment plants, users)
   - Sets up conveyance through pipes
   - Establishes priority-based allocation rules

2. **Supporting Infrastructure Files**
   - `water_treat.wal` - Treatment plant specifications
   - `water_use.wal` - User facility parameters  
   - `water_pipe.wal` - Pipe network configuration
   - `water_tower.wal` - Storage facility specifications
   - `om_treat.wal` - Organic matter treatment parameters
   - `om_use.wal` - Organic matter use parameters

3. **Hydrologic Connection Files**
   - `hru.con` - HRU definitions and connections
   - `aquifer.con` - Aquifer network connections
   - `reservoir.con` - Reservoir configuration
   - `channel.con` - Channel network setup

### Key Implementation Features

#### Water Sources
- **Reservoir (res)**: Primary water storage with regulated outflow
- **Aquifer (aqu)**: Groundwater sources with depth limitations
- **Unlimited (unl)**: External water supply source

#### Demand Objects  
- **HRU**: Hydrologic response units requiring irrigation
- **WTP**: Water treatment plants processing various flows
- **Industrial/Domestic Use**: Urban water demands
- **Storage**: Intermediate storage and distribution points

#### Conveyance System
- **Pipes**: Physical water transport infrastructure
- **Flow fractions**: Proportional allocation to multiple destinations
- **Lag times**: Transport delays and treatment processing time
- **Loss rates**: System inefficiencies and evaporation

#### Priority System
- **Senior rights (sr)**: First priority for water allocation
- **Junior rights (jr)**: Secondary priority allocation
- **Compensation**: Alternative source utilization when primary sources are limited

## Usage Instructions

### 1. File Setup
Copy all `.wro`, `.wal`, and `.con` files to your SWAT+ model directory.

### 2. Integration with file.cio
Update your `file.cio` to reference the water allocation files:
```
water_allocation.wro    ! water allocation objects
water_treat.wal         ! treatment plants  
water_use.wal          ! use facilities
water_pipe.wal         ! pipe network
water_tower.wal        ! storage towers
```

### 3. Object Numbering
Ensure consistency between water allocation object numbers and your model's:
- HRU numbers match hru.con definitions
- Aquifer numbers align with aquifer.con
- Reservoir numbers correspond to reservoir.con
- Channel numbers match channel.con

### 4. Decision Tables (Optional)
For dynamic allocation rules, create decision tables to:
- Control seasonal irrigation demands
- Adjust treatment plant operations
- Modify user consumption patterns
- Implement drought response protocols

## Network Flow Visualization

```
                    Water Allocation Network Flow
                    
    Src1 ─────────────────┐
                          ▼
    HRU1 ──(total)──► Res1 ◄──(total)── Aqu1 ◄──(recharge)── HRU1
      │                 │                 ▲
      └─(recharge)──────┘                 │
                        │                 │
                   (Pipe1)            (recharge)
                        │                 │
                        ▼                 │
                       WTP1               │
                        │                 │
                   (Pipe2)               │
                        │                 │
                        ▼                 │
    HRU2 ◄─(Irr_Lawn)─ Stor1             │
      ▲                ╱ │ ╲              │
      │          (Pipe3) │ (Pipe4)       │
      │               ╱  │  ╲            │
      │              ▼   │   ▼           │
    (no routing)   I_Use1│ D_Use1        │
                     │   │   │           │
                (Pipe5)  │ (Pipe6)       │
                     │   │   │           │
                     ▼   │   ▼           │
                    WTP2 ◄───┘            │
                     │              (Pipe8)
                (Pipe7)                  │
                     │                   ▼
                     ▼                 WTP3
                   Cha1             ╱       ╲
                               (Pipe9)   (Pipe10)
                                  ▼           ▼
    Res1 ──(Irr_Ag)──► HRU3   Stor2       Cha2
      │                  │
      └──(recharge)──► Aqu2
```

## Example Scenarios

### 1. Normal Operations
- Src1 supplies base flow to Res1
- HRU1 contributes surface flow and groundwater recharge
- Res1 feeds primary treatment (WTP1) and agricultural irrigation (HRU3)
- Treated water stored in Stor1 for urban distribution
- Urban users return wastewater to secondary treatment (WTP2)

### 2. Drought Conditions  
- Unlimited source (Src1) maintains reservoir levels
- Priority allocation favors senior water rights
- Agricultural irrigation (HRU3) may be reduced
- Storage systems buffer supply variations

### 3. Peak Demand Periods
- Multiple treatment plants operate in parallel
- Storage facilities provide surge capacity
- Pipe network distributes loads across infrastructure
- Groundwater sources supplement surface water

## Advanced Features

### Treatment Plant Configurations
- **WTP1**: Primary treatment with high capacity (1000 m³)
- **WTP2**: Secondary treatment for wastewater (800 m³)  
- **WTP3**: Tertiary treatment with extended retention (1200 m³)

### Storage Management
- **Stor1**: Primary distribution hub (5000 m³)
- **Stor2**: Secondary storage for treated overflow (3000 m³)
- Configurable lag times and loss rates

### Pipe Network Design
- 10 distinct pipe segments with individual characteristics
- Minimal loss rates (2%) for efficient transport
- Lag times representing physical transport delays

### Organic Matter Management
- Treatment efficiency parameters for nutrient removal
- User consumption patterns affecting effluent quality
- Seasonal variation capabilities through decision tables

This implementation provides a comprehensive framework for water allocation modeling in SWAT+, demonstrating advanced features including multiple treatment levels, storage systems, user interactions, and complex routing networks.