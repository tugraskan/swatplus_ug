# Water Allocation Network Sample

This directory contains sample input files for a comprehensive water allocation network in SWAT+ as specified in the problem statement.

## System Components

### Hydrologic Response Units (HRUs)
- **HRU1**: Connected to Res1 (total flow) and Aqu1 (recharge)
- **HRU2**: No routing, receives irrigation from Stor1 (Irr_Lawn)
- **HRU3**: Connected to Aqu2 (recharge), receives irrigation from Res1 (Irr_Ag)

### Aquifers
- **Aqu1**: Receives recharge from HRU1, supplies water to Res1
- **Aqu2**: Receives recharge from HRU3

### Reservoir and Source
- **Res1**: Central reservoir receiving water from Aqu1 and Src1, supplies WTP1 and HRU3 irrigation
- **Src1**: Unlimited source supplying Res1

### Water Treatment Plants
- **WTP1**: Primary treatment (Res1 → WTP1 → Stor1 via Pipe1 and Pipe2)
- **WTP2**: Secondary treatment for user wastewater (I_Use1 + D_Use1 → WTP2 → Cha1 via Pipes 5,6,7)
- **WTP3**: Tertiary treatment (Stor1 → WTP3 → Stor2/Cha2 via Pipes 8,9,10)

### Storage Systems
- **Stor1**: Primary storage after WTP1, distributes to users and WTP3
- **Stor2**: Secondary storage from WTP3

### Water Users
- **I_Use1**: Industrial use (Stor1 → I_Use1 → WTP2 via Pipes 3,5)
- **D_Use1**: Domestic use (Stor1 → D_Use1 → WTP2 via Pipes 4,6)

### Channels
- **Cha1**: Receives treated water from WTP2
- **Cha2**: Receives treated water from WTP3

## Pipe Network (10 Pipes Total)

1. **Pipe1**: Res1 → WTP1
2. **Pipe2**: WTP1 → Stor1
3. **Pipe3**: Stor1 → I_Use1
4. **Pipe4**: Stor1 → D_Use1
5. **Pipe5**: I_Use1 → WTP2
6. **Pipe6**: D_Use1 → WTP2
7. **Pipe7**: WTP2 → Cha1
8. **Pipe8**: Stor1 → WTP3
9. **Pipe9**: WTP3 → Stor2
10. **Pipe10**: WTP3 → Cha2

## Irrigation Loops
- **Stor1 → HRU2**: Lawn irrigation
- **Res1 → HRU3**: Agricultural irrigation

## File Structure

- `water_allocation.wro`: Main water allocation configuration
- `water_treat.wal`: Water treatment plant parameters
- `water_use.wal`: Water use facility parameters
- `water_pipe.wal`: Pipe network configuration
- `water_tower.wal`: Storage tower parameters
- `om_treat.wal`: Organic matter treatment parameters
- `om_use.wal`: Organic matter use parameters
- `*.con`: Connection files for HRUs, aquifers, reservoir, and channels

## Usage

Copy these files to your SWAT+ model directory and update the file.cio to reference the water allocation files. The network demonstrates a complex water management system with treatment, storage, distribution, and reuse components.

## Network Flow Summary

```
Src1 → Res1 ← Aqu1 ← HRU1
       ↓      ↑
     WTP1   Aqu2 ← HRU3
       ↓      ↑
     Stor1 → HRU2 (Irr_Lawn)
     ↙ ↓ ↘
  I_Use1 D_Use1 WTP3
     ↘ ↙      ↙ ↘
     WTP2   Stor2 Cha2
       ↓
     Cha1
```

This network provides a comprehensive example of water allocation, treatment, storage, and distribution in SWAT+.