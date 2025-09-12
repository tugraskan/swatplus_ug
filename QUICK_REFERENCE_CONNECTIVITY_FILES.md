# Quick Reference: SWAT+ HRU Connectivity Files

## Configuration Files (Input)

### Essential Connectivity Files

| File | Purpose | Key Information |
|------|---------|-----------------|
| `object.cnt` | Model structure summary | Total counts of each object type |
| `hru.con` | HRU basic properties | HRU locations, areas, weather stations |
| `rout_unit.con` | Routing unit connections | Outlet connections and flow types |
| `rout_unit.def` | HRU groupings | Which HRUs belong to each routing unit |
| `ls_unit.ele` | Landscape elements | HRU fractions within routing units |

### Additional Connection Files

| File | Purpose | When Present |
|------|---------|--------------|
| `chandeg.con` | Channel connections | Models with channels |
| `aquifer.con` | Aquifer connections | Models with groundwater |
| `recall.con` | External inflows | Models with diversions/inflows |
| `aqu_catunit.ele` | HRU-Aquifer links | Groundwater interaction models |

## Source Code Files (Fortran)

### Core Connectivity Code

| File | Key Functions | Purpose |
|------|---------------|---------|
| `hyd_connect.f90` | `hyd_connect()` | Sets up all object connectivity |
| `hyd_read_connect.f90` | `hyd_read_connect()` | Reads connection files |
| `hru_control.f90` | Main simulation loop | Routes flows between HRUs |
| `ru_control.f90` | `ru_control()` | Aggregates flows in routing units |

### Flow Routing Code

| File | Key Functions | Purpose |
|------|---------------|---------|
| `rls_routesurf.f90` | `rls_routesurf()` | Surface flow routing |
| `rls_routesoil.f90` | `rls_routesoil()` | Lateral soil flow routing |
| `rls_routeaqu.f90` | `rls_routeaqu()` | Aquifer flow routing |
| `rls_routetile.f90` | `rls_routetile()` | Tile drainage routing |

### Burn Operation Code

| File | Key Functions | Purpose |
|------|---------------|---------|
| `pl_burnop.f90` | `pl_burnop()` | Implements fire/burn effects |
| `mgt_operatn.f90` | `mgt_operatn()` | Schedules management operations |

## File Format Examples

### object.cnt
```
name                   ls_area      tot_area       obj       hru      lhru       rtu       mfl       aqu       cha       res       rec      exco       dlr       can       pmp       out      lcha     aqu2d       
Osu                      10             10          4         1         0         1         0         1         0         0         0         0         0         0         0         0         1         0         
```

### hru.con
```
      id  name                gis_id          area           lat           lon          elev       hru               wst       cst      ovfl      rule   out_tot  
       1  hru0001                  1       10.0000      35.52014     127.32787     113.51276         1    s35610n127290e         0         0         0         0    
```

### rout_unit.def
```
      id              name  elem_tot  elements  
       1             rtu001         1      1      
```

### rout_unit.con
```
      id  name                gis_id          area           lat           lon          elev       rtu               wst       cst      ovfl      rule   out_tot       obj_typ    obj_id       hyd_typ          frac  
       1  rtu001                   1       10.0000      35.52014     127.32787     113.51276         1    s35610n127290e         0         0         0         2           sdc         1           tot       1.00000           aqu         1           rhg       1.00000  
```

## Key Variables and Concepts

### Object Types
- `hru` - Hydrologic Response Unit (basic simulation unit)
- `rtu`/`ru` - Routing Unit (groups multiple HRUs)
- `cha`/`sdc` - Channel/Stream (routes water downstream)
- `aqu` - Aquifer (groundwater interaction)
- `res` - Reservoir
- `rec` - Recall (external inflow/diversion)

### Flow Types
- `tot` - Total flow (surface + lateral + groundwater)
- `sur` - Surface runoff only
- `lat` - Lateral soil flow only
- `rhg` - Recharge/groundwater flow only
- `til` - Tile drainage flow only

### Key Arrays in Code
```fortran
! Object connectivity (hyd_connect.f90)
ob(i)%obj_out(ii)     ! Downstream object numbers
ob(i)%obtyp_out(ii)   ! Downstream object types
ob(i)%htyp_out(ii)    ! Flow type to downstream object
ob(i)%frac_in(ii)     ! Fraction of flow received

! Flow routing (hru_control.f90)
ob(icmd)%hin_sur      ! Incoming surface flow
ob(icmd)%hin_lat      ! Incoming lateral flow
ob(icmd)%hin_aqu      ! Incoming aquifer flow
```

## Tracing Connectivity Steps

### 1. Start with object.cnt
- Identify how many HRUs, routing units, channels etc.

### 2. Check rout_unit.def
- See which HRUs are grouped together

### 3. Check rout_unit.con  
- See where routing units discharge to

### 4. Follow the chain
```
HRU → Routing Unit → Channel → Outlet
    ↓
  Aquifer
```

### 5. Check code execution
- `hru_control.f90`: Individual HRU simulation
- `ru_control.f90`: Routing unit aggregation
- Flow routing subroutines: Inter-HRU transport

## Burn Effect Propagation

### 1. Local Effect (pl_burnop.f90)
```fortran
cn2(j) = cn2(j) + fire_db(iburn)%cn2_upd  ! Increases curve number
```

### 2. Increased Runoff (surface.f90)
Higher CN2 → More surface runoff from same rainfall

### 3. Routing (hru_control.f90)
```fortran
call rls_routesurf(icmd, tile_fr_surf)  ! Route to downstream HRUs
```

### 4. Downstream Effects
Increased inflow affects water balance of receiving HRUs

## Output Files for Monitoring

| File | Content | Use for Burn Analysis |
|------|---------|----------------------|
| `hru_wb_aa.txt` | HRU water balance | Track SURQ, WYLD changes |
| `ru_aa.txt` | Routing unit flows | Aggregated effects |
| `hydout_aa.txt` | Outlet flows | Watershed-scale impacts |
| `basin_wb_aa.txt` | Basin summary | Overall water balance changes |