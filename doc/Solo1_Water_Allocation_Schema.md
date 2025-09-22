# Solo1 Water Allocation Schema

## Overview
This schema shows the actual connections and object relationships defined in the `data/solo_1/water_allocation.wro` configuration file.

## Source Objects

| Source ID | Type | Object # | Description | Constraints |
|-----------|------|----------|-------------|-------------|
| 1 | res | 1 | Reservoir 1 | Min 50% pool level year-round |
| 2 | aqu | 2 | Aquifer 2 | Max 13m drawdown year-round |
| 3 | osrc | 1 | Outside Source 1 | Variable: 80% (wet), 50% (dry) |

## Transfer Objects and Connections

| TRN# | Type | Amount | Source(s) | Pipe/Pump | Receiving Object | Description |
|------|------|---------|-----------|-----------|------------------|-------------|
| 1 | outflo | 0.0 | osrc 1 | pipe 1 | res 1 | Outside source fills reservoir |
| 2 | ave_day | 1000.0 | res 1 | pipe 2 | wtp 1 | Reservoir feeds treatment plant |
| 3 | outflo | 0.0 | wtp 1 | pipe 3 | stor 1 | Treatment plant fills storage |
| 4 | ave_day | 200.0 | stor 1 | pipe 4 | use 1 | Storage to domestic use (70%) |
| 5 | ave_day | 300.0 | stor 1 | pipe 5 | use 2 | Storage to industrial use (30%) |
| 6 | dtbl_irr | 0.0 | stor 1 | pipe 6 | hru 2 | Storage to irrigation |
| 7 | outflo | 0.0 | wtp 2 | pipe 5 | cha 1 | Treatment plant 2 to channel 1 (50%) |
| 8 | outflo | 0.0 | wtp 2 | pipe 5 | wtp 3 | Treatment plant 2 to treatment plant 3 (50%) |
| 9 | outflo | 0.0 | wtp 3 | pipe 5 | cha 2 | Treatment plant 3 to channel 2 (50%) |
| 10 | outflo | 0.0 | use 3 | pipe 5 | stor 1 | Residential use recycle to storage (50%) |
| 11 | dtbl_irr | 0.0 | res 1 + aqu 2 | pipe 6 + pump 1 | hru 3 | Dual-source irrigation with compensation |
| 12 | dtbl_irr | 0.0 | res 1 + aqu 2 | pipe 7 + pump 1 | hru 4 | Dual-source irrigation with compensation |

## Connection Schema

```
SOURCES                    TRANSFERS                     RECEIVERS
┌─────────────┐           ┌─────────────┐               ┌─────────────┐
│   OSRC 1    │──TRN1────→│   outflo    │──────────────→│    RES 1    │
│ (Outside)   │           │             │               │ (Reservoir) │
└─────────────┘           └─────────────┘               └─────────────┘
                                                                │
                                                                │ TRN2 (1000 m³/day)
                                                                ▼
┌─────────────┐                                         ┌─────────────┐
│    RES 1    │──TRN2────→┌─────────────┐──────────────→│    WTP 1    │
│ (Reservoir) │           │   ave_day   │               │ (Treatment) │
└─────────────┘           │ 1000 m³/day │               └─────────────┘
      │                   └─────────────┘                       │
      │                                                         │ TRN3
      │                                                         ▼
      │                                                 ┌─────────────┐
      │                                                 │   STOR 1    │
      │                                                 │  (Storage)  │
      │                                                 └─────────────┘
      │                                                         │
      │                                     ┌───────────────────┼───────────────────┐
      │                                     │ TRN4              │ TRN5              │ TRN6
      │                                     │ 200 m³/day        │ 300 m³/day        │ irrigation
      │                                     ▼                   ▼                   ▼
      │                             ┌─────────────┐     ┌─────────────┐     ┌─────────────┐
      │                             │    USE 1    │     │    USE 2    │     │    HRU 2    │
      │                             │ (Domestic)  │     │(Industrial) │     │(Irrigation) │
      │                             └─────────────┘     └─────────────┘     └─────────────┘
      │
      │ TRN11,12 (with compensation)
      │ ┌─────────────┐
      └→│   AQU 2     │──TRN11,12──→┌─────────────┐──────→┌─────────────┐
        │ (Aquifer)   │  (backup)   │   dtbl_irr  │       │  HRU 3,4    │
        │ (Backup)    │             │ irrigation  │       │(Irrigation) │
        └─────────────┘             └─────────────┘       └─────────────┘

TREATMENT CHAIN:
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│    WTP 2    │───→│    WTP 3    │───→│    CHA 2    │
│(Treatment L2)│    │(Treatment L3)│    │ (Channel)   │
└─────────────┘    └─────────────┘    └─────────────┘
       │                                       
       ▼                                       
┌─────────────┐                                
│    CHA 1    │                                
│ (Channel)   │                                
└─────────────┘                                

RECYCLING:
┌─────────────┐    ┌─────────────┐
│    USE 3    │───→│   STOR 1    │
│(Residential)│    │  (Storage)  │
└─────────────┘    └─────────────┘
```

## Key Features

### Primary Water Supply Chain
1. **OSRC 1** → **RES 1** (TRN1): Outside source fills reservoir
2. **RES 1** → **WTP 1** (TRN2): Reservoir supplies treatment plant (1000 m³/day)
3. **WTP 1** → **STOR 1** (TRN3): Treated water goes to storage
4. **STOR 1** splits to:
   - **USE 1** (TRN4): Domestic use (200 m³/day)
   - **USE 2** (TRN5): Industrial use (300 m³/day)
   - **HRU 2** (TRN6): Irrigation (decision table controlled)

### Multi-Source Irrigation
- **TRN 11**: Primary from RES 1, backup from AQU 2 → HRU 3
- **TRN 12**: Primary from RES 1, backup from AQU 2 → HRU 4
- Compensation enabled: If reservoir cannot meet demand, aquifer automatically provides backup

### Treatment Plant Cascade
- **WTP 2** splits output (50/50):
  - To **CHA 1** (TRN7): Direct discharge
  - To **WTP 3** (TRN8): Further treatment
- **WTP 3** → **CHA 2** (TRN9): Final treated discharge

### Water Recycling
- **USE 3** → **STOR 1** (TRN10): Residential use returns to storage

## Object Summary

**Sources**: 3 total
- 1 Reservoir (RES 1)
- 1 Aquifer (AQU 2) 
- 1 Outside Source (OSRC 1)

**Receivers**: 11 total
- 1 Reservoir (RES 1)
- 3 Treatment Plants (WTP 1, 2, 3)
- 1 Storage Tower (STOR 1)
- 3 Use Objects (USE 1, 2, 3)
- 3 Irrigation HRUs (HRU 2, 3, 4)
- 2 Channels (CHA 1, 2)

**Transfer Objects**: 12 total
- 3 Fixed daily transfers (TRN 2, 4, 5)
- 6 Variable outflow transfers (TRN 1, 3, 7, 8, 9, 10)
- 3 Irrigation transfers with decision table control (TRN 6, 11, 12)

**Infrastructure**: 
- 13 Pipes (pipe 1-7, pipe 5 shared)
- 1 Pump (pump 1 for aquifer)

This schema represents a comprehensive municipal water supply system with irrigation, treatment, storage, and recycling capabilities, designed to serve multiple demand types while maintaining environmental flows.