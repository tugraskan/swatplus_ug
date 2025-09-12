# SWAT+ HRU Burn Operations and Downstream Water Yield Effects

## Overview

This guide explains how burn operations in one Hydrologic Response Unit (HRU) can affect water yield downstream in other HRUs through SWAT+'s connectivity and routing mechanisms.

## Key Concepts

### 1. HRU Connectivity Framework

SWAT+ uses a hierarchical spatial organization where water, sediment, and nutrients are routed between different spatial units:

- **HRUs** (Hydrologic Response Units) - Basic land use simulation units
- **Routing Units** - Collect flows from multiple HRUs 
- **Channels** - Route flows downstream
- **Aquifers** - Provide groundwater interactions

### 2. Burn Operation Effects

When a burn operation occurs in an HRU (via `pl_burnop.f90`), it affects multiple hydrologic processes:

#### Direct Effects on the Burned HRU:
- **Curve Number (CN) Changes**: Burns increase the CN2 parameter, reducing infiltration and increasing surface runoff
- **Vegetation Removal**: Reduces interception, transpiration, and soil protection
- **Soil Surface Changes**: Affects surface roughness and infiltration rates
- **Residue/Litter Reduction**: Removes surface protection leading to increased erosion potential

#### Key Code Locations:
```fortran
! In pl_burnop.f90 - CN update after fire
cnop = cn2(j) + fire_db(iburn)%cn2_upd
if (cnop > 98.0) then
  cnop = 98.0
end if
call curno(cnop, j)
```

## Connectivity and Routing Mechanisms

### 1. Surface Flow Routing (`hru_control.f90` and `rls_routesurf.f90`)

Surface runoff generated in an upstream HRU due to burn effects flows to downstream units through:

```fortran
! Surface runoff routing in hru_control.f90
if (ob(icmd)%hin_sur%flo > 1.e-6) then
  if (ires > 0) then
    !! add surface runon to wetland
    ht1 = ob(icmd)%hin_sur + tile_fr_surf * ob(icmd)%hin_til
    wet(j) = wet(j) + ht1
  else
    !! route across hru - infiltrate and deposit sediment
    call rls_routesurf (icmd, tile_fr_surf)
  end if
end if
```

**Impact**: Increased surface runoff from burned HRU increases inflow (`ls_overq`) to downstream HRUs, affecting their water balance.

### 2. Lateral Flow Routing

Subsurface lateral flow changes due to altered infiltration patterns:

```fortran
! Lateral flow routing in hru_control.f90
if (ob(icmd)%hin_lat%flo > 0) then
  call rls_routesoil (icmd)
end if
```

### 3. Routing Unit Integration (`ru_control.f90`)

Routing units collect flows from multiple HRUs and aggregate their effects:

```fortran
! Flow aggregation in ru_control.f90
do ielem = 1, ru_def(iru)%num_tot
  ise = ru_def(iru)%num(ielem)
  iob = ru_elem(ise)%obj
  
  ! Calculate expansion factor for each contributing HRU
  if (ob(iob)%typ == "hru" .or. ob(iob)%typ == "hru_lte") then
    if (ef < .99999) then
      ef = ef * ru(iru)%da_km2 / (ob(iob)%area_ha / 100.)
    end if
  end if
end do
```

## Files to Check for HRU Connectivity

### 1. Configuration Files (Input)

**Connection Files (`.con`)**:
- `hru.con` - Defines HRU spatial properties and initial connectivity
- `rout_unit.con` - Defines routing units and their outlet connections  
- `chandeg.con` - Channel routing connections
- `recall.con` - External flow inputs/diversions

**Definition Files (`.def` and `.ele`)**:
- `rout_unit.def` - Lists which HRUs belong to each routing unit
- `ls_unit.ele` - Landscape unit element definitions
- `aqu_catunit.ele` - Aquifer-HRU connections

**Object Count File**:
- `object.cnt` - Summary of all spatial objects in the simulation

### 2. Source Code Files (Fortran)

**Connectivity and Routing**:
- `src/hyd_connect.f90` - Main connectivity setup and object linking
- `src/hyd_read_connect.f90` - Reads connectivity files and sets up routing
- `src/hru_control.f90` - Main HRU simulation and flow routing
- `src/ru_control.f90` - Routing unit flow aggregation and routing
- `src/rls_routesurf.f90` - Surface flow routing between HRUs
- `src/rls_routesoil.f90` - Lateral soil flow routing
- `src/rls_routeaqu.f90` - Aquifer flow routing

**Burn Operations**:
- `src/pl_burnop.f90` - Fire/burn operation implementation
- `src/mgt_operatn.f90` - Management operation scheduling and execution

## Example: Tracing Burn Effects Downstream

### Step 1: Burn Operation in HRU 1
```fortran
! pl_burnop.f90 increases CN2
cn2(hru1) = cn2(hru1) + fire_db(iburn)%cn2_upd  ! Increases from ~65 to ~80
```

### Step 2: Increased Surface Runoff in HRU 1
```fortran
! Higher CN leads to more surface runoff in surface.f90
surfq(hru1) = f(cn2_increased, precipitation, ...)  ! More runoff generated
```

### Step 3: Routing to Downstream HRU 2
```fortran
! hru_control.f90 routes HRU 1 outflow as inflow to HRU 2
ob(hru2)%hin_sur%flo = ob(hru2)%hin_sur%flo + outflow_from_hru1

! rls_routesurf.f90 processes the incoming flow
ls_overq = ob(iob)%hin_sur%flo / (10. * hru(j)%area_ha)  ! Convert to mm
precip_eff = precip_eff + ls_overq  ! Add to effective precipitation
```

### Step 4: Modified Water Balance in HRU 2
- Increased effective precipitation affects infiltration, runoff generation
- May lead to higher water yield from HRU 2 as well
- Effects propagate through entire watershed via routing units and channels

## Checking Connectivity in Your Model

### 1. Examine Configuration Files
```bash
# Check HRU connections
cat hru.con | head -20

# Check routing unit definitions
cat rout_unit.def
cat rout_unit.con

# Check object counts
cat object.cnt
```

### 2. Trace Flow Paths
1. Start with `object.cnt` to understand spatial object hierarchy
2. Use `rout_unit.def` to see which HRUs are grouped together
3. Check `rout_unit.con` to see downstream connections
4. Follow the chain: HRU → Routing Unit → Channel/Outlet

### 3. Model Output Analysis
Monitor these outputs to track burn effects:
- `hru_wb_aa.txt` - HRU water balance (surface runoff, ET, etc.)
- `ru_aa.txt` - Routing unit aggregated flows  
- `basin_wb_aa.txt` - Watershed-scale water balance
- `hydout_aa.txt` - Outflow hydrographs

## Key Hydrologic Variables Affected

- **SURQ** - Surface runoff (mm)
- **LATQ** - Lateral flow (mm) 
- **GWQ** - Groundwater flow (mm)
- **WYLD** - Water yield (mm) = SURQ + LATQ + GWQ
- **ET** - Evapotranspiration (mm)
- **PERC** - Deep percolation (mm)

The burn effects propagate through the connectivity network, with upstream burns potentially increasing water yield throughout the downstream watershed network.