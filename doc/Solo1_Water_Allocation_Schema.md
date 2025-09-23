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
| 4 | ave_day | 200.0 | stor 1 | pipe 4 | use 1 | Storage to domestic use (200 m³/day) |
| 5 | ave_day | 300.0 | stor 1 | pipe 5 | use 2 | Storage to industrial use (300 m³/day) |
| 6 | dtbl_irr | 0.0 | stor 1 | pipe 6 | hru 2 | Storage to irrigation |
| 7 | outflo | 0.0 | use 1 | pipe 7 | wtp 2 | Domestic use wastewater to treatment plant 2 |
| 8 | outflo | 0.0 | use 2 | pipe 8 | wtp 2 | Industrial use wastewater to treatment plant 2 |
| 9 | outflo | 0.0 | wtp 2 | pipe 9 | cha 1 | Treatment plant 2 to channel 1 (50%) |
| 10 | outflo | 0.0 | wtp 2 | pipe 10 | wtp 3 | Treatment plant 2 to treatment plant 3 (50%) |
| 11 | outflo | 0.0 | wtp 3 | pipe 11 | cha 2 | Treatment plant 3 to channel 2 (50%) |
| 12 | outflo | 0.0 | wtp 3 | pipe 12 | stor 1 | Treatment plant 3 recycle to storage (50%) |
| 13 | dtbl_irr | 0.0 | res 1 + aqu 2 | pipe 13 + pump 1 | hru 3 | Dual-source irrigation with compensation |
| 14 | dtbl_irr | 0.0 | res 1 + aqu 2 | pipe 13 + pump 1 | hru 1 | Dual-source irrigation with compensation |

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
      │                                                 │   STOR 1    │←┐
      │                                                 │  (Storage)  │ │ TRN12
      │                                                 └─────────────┘ │ recycle
      │                                                         │       │
      │                                     ┌───────────────────┼───────────────────┐
      │                                     │ TRN4              │ TRN5              │ TRN6
      │                                     │ 200 m³/day        │ 300 m³/day        │ irrigation
      │                                     ▼                   ▼                   ▼
      │                             ┌─────────────┐     ┌─────────────┐     ┌─────────────┐
      │                             │    USE 1    │     │    USE 2    │     │    HRU 2    │
      │                             │ (Domestic)  │     │(Industrial) │     │(Irrigation) │
      │                             └─────────────┘     └─────────────┘     └─────────────┘
      │                                     │                   │
      │                                     │ TRN7              │ TRN8
      │                                     │ wastewater        │ wastewater
      │                                     ▼                   ▼
      │                                     └───────────┬───────────┘
      │                                                 ▼
      │                                         ┌─────────────┐
      │                                         │    WTP 2    │
      │                                         │(Treatment L2)│
      │                                         └─────────────┘
      │                                                 │
      │                                 ┌───────────────┼───────────────┐
      │                                 │ TRN9          │ TRN10         │
      │                                 │ (50%)         │ (50%)         │
      │                                 ▼               ▼               │
      │                         ┌─────────────┐ ┌─────────────┐         │
      │                         │    CHA 1    │ │    WTP 3    │         │
      │                         │ (Channel)   │ │(Treatment L3)│         │
      │                         └─────────────┘ └─────────────┘         │
      │                                                 │               │
      │                                 ┌───────────────┼───────────────┘
      │                                 │ TRN11         │
      │                                 │ (50%)         │
      │                                 ▼               │
      │                         ┌─────────────┐         │
      │                         │    CHA 2    │         │
      │                         │ (Channel)   │         │
      │                         └─────────────┘         │
      │                                                 │
      │ TRN13,14 (with compensation)                    │
      │ ┌─────────────┐                                 │
      └→│   AQU 2     │──TRN13,14─→┌─────────────┐──────→┌─────────────┐
        │ (Aquifer)   │  (backup)  │   dtbl_irr  │       │  HRU 1,3    │
        │ (Backup)    │            │ irrigation  │       │(Irrigation) │
        └─────────────┘            └─────────────┘       └─────────────┘
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

### Wastewater Treatment Chain
- **USE 1** → **WTP 2** (TRN7): Domestic wastewater to treatment plant 2
- **USE 2** → **WTP 2** (TRN8): Industrial wastewater to treatment plant 2
- **WTP 2** splits output (50/50):
  - To **CHA 1** (TRN9): Direct discharge to channel 1
  - To **WTP 3** (TRN10): Further treatment at plant 3
- **WTP 3** splits output (50/50):
  - To **CHA 2** (TRN11): Final treated discharge to channel 2
  - To **STOR 1** (TRN12): Recycled water back to storage

### Multi-Source Irrigation
- **TRN 13**: Primary from RES 1, backup from AQU 2 → HRU 3
- **TRN 14**: Primary from RES 1, backup from AQU 2 → HRU 1
- Compensation enabled: If reservoir cannot meet demand, aquifer automatically provides backup
- Both transfers use pipe 13 and pump 1 for aquifer access

### Water Recycling
- **WTP 3** → **STOR 1** (TRN12): Treated wastewater returns to storage system

## Object Summary

**Sources**: 3 total
- 1 Reservoir (RES 1)
- 1 Aquifer (AQU 2) 
- 1 Outside Source (OSRC 1)

**Receivers**: 10 total
- 1 Reservoir (RES 1)
- 3 Treatment Plants (WTP 1, 2, 3)
- 1 Storage Tower (STOR 1)
- 2 Use Objects (USE 1, 2)
- 3 Irrigation HRUs (HRU 1, 2, 3)
- 2 Channels (CHA 1, 2)

**Transfer Objects**: 14 total
- 3 Fixed daily transfers (TRN 2, 4, 5)
- 9 Variable outflow transfers (TRN 1, 3, 7, 8, 9, 10, 11, 12)
- 3 Irrigation transfers with decision table control (TRN 6, 13, 14)

**Infrastructure**: 
- 13 Pipes (pipe 1-13, with pipe 13 shared by TRN 13&14)
- 1 Pump (pump 1 for aquifer access)

This schema represents a comprehensive municipal water supply system with wastewater treatment, recycling, irrigation, storage, and environmental discharge capabilities, designed to serve multiple demand types while maintaining water reuse and environmental flows.