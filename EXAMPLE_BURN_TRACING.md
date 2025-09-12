# Example: Tracing Burn Effects Through HRU Connectivity

This example demonstrates how to trace burn effects through SWAT+ connectivity using real model files.

## Step 1: Understanding Your Model Structure

First, examine the basic model structure:

```bash
# Check the overall model structure
cat object.cnt
```

Example output from Osu_1hru:
```
object.cnt: written by SWAT+ editor v2.2.0 on 2023-03-22 04:25 for SWAT+ rev.60.5.4
name                   ls_area      tot_area       obj       hru      lhru       rtu       mfl       aqu       cha       res       rec      exco       dlr       can       pmp       out      lcha     aqu2d       
Osu                      10             10          4         1         0         1         0         1         0         0         0         0         0         0         0         0         1         0         
```

This shows:
- 1 HRU 
- 1 Routing Unit (rtu)
- 1 Aquifer (aqu) 
- 1 Channel (lcha)

## Step 2: Examine HRU Properties

```bash
# Check HRU basic properties
cat hru.con
```

Example from Osu_1hru:
```
hru.con: written by SWAT+ editor v2.2.0 on 2023-03-22 04:25 for SWAT+ rev.60.5.4
      id  name                gis_id          area           lat           lon          elev       hru               wst       cst      ovfl      rule   out_tot  
       1  hru0001                  1       10.0000      35.52014     127.32787     113.51276         1    s35610n127290e         0         0         0         0    
```

## Step 3: Examine Routing Unit Connections

```bash
# Check which HRUs are grouped in routing units
cat rout_unit.def

# Check routing unit outlet connections  
cat rout_unit.con
```

From Osu_1hru rout_unit.con:
```
rout_unit.con: written by SWAT+ editor v2.2.0 on 2023-03-22 04:25 for SWAT+ rev.60.5.4
      id  name                gis_id          area           lat           lon          elev       rtu               wst       cst      ovfl      rule   out_tot       obj_typ    obj_id       hyd_typ          frac  
       1  rtu001                   1       10.0000      35.52014     127.32787     113.51276         1    s35610n127290e         0         0         0         2           sdc         1           tot       1.00000           aqu         1           rhg       1.00000  
```

This shows:
- Routing Unit 1 contains HRU 1
- It has 2 outlets:
  - `sdc` (stream/channel) connection to object 1 with total flow (`tot`)  
  - `aqu` (aquifer) connection to object 1 with recharge flow (`rhg`)

## Step 4: Trace Burn Effects

### Scenario: Fire Occurs in HRU 1

When a burn operation is triggered in HRU 1:

#### 4.1 Direct Effects on HRU 1 (pl_burnop.f90)
```fortran
! CN2 increases from ~65 to ~80 (example)
cnop = cn2(j) + fire_db(iburn)%cn2_upd
cn2(1) = 65 + 15 = 80  ! Higher CN = more runoff, less infiltration
```

#### 4.2 Increased Surface Runoff Generation
With higher CN2, the same rainfall produces more surface runoff:
- Before burn: CN=65 → SURQ = 5 mm (example)
- After burn: CN=80 → SURQ = 12 mm (example)

#### 4.3 Flow Routing Through Connectivity

**Step A: HRU 1 → Routing Unit 1**
```fortran
! ru_control.f90 aggregates flow from HRU 1
ru_d(1)%flo = ru_d(1)%flo + hru_outflow(1) * expansion_factor
```

**Step B: Routing Unit 1 → Downstream Objects**
Based on the connection file, increased flow goes to:

1. **Stream Channel (sdc 1)**:
   ```fortran
   ! Channel receives increased surface flow
   channel_inflow(1) = channel_inflow(1) + ru_outflow(1) * frac_total
   ```

2. **Aquifer (aqu 1)** - Recharge component:
   ```fortran
   ! Aquifer receives reduced recharge (due to less infiltration)
   aquifer_recharge(1) = aquifer_recharge(1) + ru_outflow(1) * frac_recharge
   ```

#### 4.4 Downstream Propagation

If the channel connects to other HRUs downstream:
```fortran
! hru_control.f90 - incoming channel flow affects downstream HRUs
if (ob(icmd)%hin_sur%flo > 1.e-6) then
  call rls_routesurf(icmd, tile_fr_surf)
  ! This adds to effective precipitation in downstream HRU
  precip_eff = precip_eff + ls_overq
end if
```

## Step 5: Monitor Effects in Model Output

### Key Output Files to Check:

1. **HRU Water Balance** (`hru_wb_aa.txt`):
   ```
   HRU     YEAR    SURQ    LATQ    GWQ     REVAP   PERC    ET      WYLD
   1       2015    12.5    2.3     1.2     0.1     8.5     425.6   16.0
   ```
   - SURQ increases after burn
   - WYLD (water yield) = SURQ + LATQ + GWQ increases

2. **Routing Unit Output** (`ru_aa.txt`):
   ```
   RU      YEAR    SURQ    LATQ    GWQ     WYLD    SEDYLD
   1       2015    12.5    2.3     1.2     16.0    2.8
   ```
   - Shows aggregated flow from all HRUs in the routing unit

3. **Channel/Outlet Flow** (`hydout_aa.txt`):
   ```
   UNIT    YEAR    FLOS    SEDOS   ORGNS   ORGPS   NO3S    NH4S    NO2S    MINPS
   1       2015    16.0    2.8     0.1     0.05    2.1     0.3     0.02    0.8
   ```
   - FLOS (flow) increases due to upstream burn

## Step 6: Spatial Relationships

### Simple Model (like Osu_1hru):
```
HRU 1 (burned) → Routing Unit 1 → Channel 1 → Outlet
                               → Aquifer 1
```

### Complex Model (multiple HRUs):
```
HRU 1 (burned) ─┐
HRU 2 ──────────┼→ Routing Unit 1 → Channel 1 → Routing Unit 2 ─┐
HRU 3 ──────────┘                                                ├→ Outlet
                                                                   │
HRU 4 (affected) → Routing Unit 2 ──────────────────────────────┘
```

In this case:
- Burn in HRU 1 increases flows through Routing Unit 1
- Channel 1 carries increased flow to Routing Unit 2
- HRU 4 receives increased inflow, affecting its water balance

## Step 7: Code Locations for Detailed Analysis

### Burn Operation:
- `src/pl_burnop.f90` lines 33-38: CN2 update
- `src/pl_burnop.f90` lines 47-85: Vegetation and litter burning

### Flow Routing:
- `src/hru_control.f90` lines 398-408: Surface flow routing
- `src/rls_routesurf.f90` lines 32-38: Overland flow routing
- `src/ru_control.f90` lines 78-120: Routing unit aggregation

### Connectivity Setup:
- `src/hyd_connect.f90` lines 218-295: Object connection parsing
- `src/hyd_read_connect.f90` lines 66-85: HRU connection reading

## Summary

Burn effects propagate through SWAT+ via:
1. **Local effects**: Increased CN2 → more surface runoff in burned HRU
2. **Routing aggregation**: Routing units collect and route flows downstream
3. **Network propagation**: Channels and aquifers carry effects to downstream HRUs
4. **Feedback effects**: Increased inflows to downstream HRUs affect their water balance

The key is understanding the connectivity network defined in your `.con` and `.def` files, then tracing the flow path through the routing algorithms in the source code.