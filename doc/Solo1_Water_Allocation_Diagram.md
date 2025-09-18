# Solo1 Water Allocation System Diagram

## Overview
This diagram illustrates the water allocation system in the `solo_1` test case, showing the flow of water from sources through various treatment and storage facilities to end users.

## System Architecture

```
                           Solo1 Water Allocation System Flow Diagram
                               (High Right First Serve Priority)

   SOURCES                    TRANSFER OBJECTS                    RECEIVING OBJECTS
┌─────────────┐                                                ┌─────────────────┐
│   OSRC 1    │────pipe1──>TRN1(outflo)─────────────────────> │     RES 1       │
│ (Outside    │             0.0 m³/day                        │  (Reservoir)    │
│  Source)    │                                               │   min: 50%     │
│ 0.5-0.8 var │                                               └─────────────────┘
└─────────────┘                                                        │
                                                                       │ pipe2
┌─────────────┐                                                       ▼
│   RES 1     │────pipe2──>TRN2(ave_day)─────────────────────>┌─────────────────┐
│ (Reservoir) │             1000 m³/day                       │     WTP 1       │
│  min: 50%   │                                               │  (Treatment)    │
└─────────────┘                                               │  Level 1        │
                                                              └─────────────────┘
┌─────────────┐                                                        │
│   AQU 2     │─┐                                                      │ pipe3
│ (Aquifer)   │ │                                                      ▼
│  max: 13m   │ │                                              ┌─────────────────┐
│  drawdown   │ │                                              │    STOR 1       │
└─────────────┘ │                                              │  (Water Tower)  │
                │                                              │  10,000 m³      │
                │                                              └─────────────────┘
                │                                                       │
                │                                         ┌─────────────┼─────────────┐
                │                                         │ pipe4       │ pipe5       │
                │                                         │ (70%)       │ (30%)       │
                │                                         │ 200 m³/day  │ 300 m³/day  │
                │                                         ▼             ▼             │
                │                                  ┌─────────────┐ ┌─────────────┐   │
                │                                  │   USE 1     │ │   USE 2     │   │
                │                                  │ (Domestic)  │ │(Industrial) │   │
                │                                  └─────────────┘ └─────────────┘   │
                │                                                                    │
                │                                                      pipe6        │
                │                                                        │          │
                │                                                        ▼          │
                │   ┌────────────>TRN6(dtbl_irr)──────────────────>┌─────────────┐ │
                │   │              irrigation                       │   HRU 2     │ │
                │   │              decision table                   │(Irrigation) │ │
                │   │                                               └─────────────┘ │
                │   │                                                               │
                │   │                  pipe6+7                                     │
                │   │ ┌────────────>TRN11(dtbl_irr)─────────────────>┌─────────────┐ │
                │   │ │             irrigation                        │   HRU 3     │ │
                └───┼─┼─pump1──────>primary: RES1, backup: AQU2      │(Irrigation) │ │
                    │ │             (compensation = yes)             └─────────────┘ │
                    │ │                                                              │
                    │ │                  pipe7                                      │
                    │ │ ┌────────────>TRN12(dtbl_irr)─────────────────>┌─────────────┐ │
                    │ │ │             irrigation                        │   HRU 4     │ │
                    └─┼─┼─pump1──────>primary: RES1, backup: AQU2      │(Irrigation) │ │
                      │ │             (compensation = yes)             └─────────────┘ │
                      │ │                                                              │
                      │ │                                                              │
                      │ └──────────────────────────────────────────────────────────────┘
                      │
                      │  TREATMENT CHAIN & EFFLUENT DISCHARGE:
                      │
                      │  ┌─────────────┐    pipe5     ┌─────────────┐    pipe5     ┌─────────────┐
                      └─>│   WTP 2     │─────────────>│   WTP 3     │─────────────>│   CHA 2     │
                         │(Treatment L2)│   (50%)      │(Treatment L3)│              │ (Channel)   │
                         └─────────────┘              └─────────────┘              └─────────────┘
                                │                                        
                                │ pipe5 (50%)                            
                                ▼                                        
                         ┌─────────────┐                                 
                         │   CHA 1     │                                 
                         │ (Channel)   │                                 
                         └─────────────┘                                 

                         ┌─────────────┐    pipe5     ┌─────────────┐
                         │   USE 3     │─────────────>│   STOR 1    │
                         │(Residential)│   (recycle)  │(Water Tower)│
                         └─────────────┘              └─────────────┘

```

## Transfer Object Details

| TRN# | Type     | Source    | Pipe   | Destination | Amount (m³/day) | Priority | Compensation |
|------|----------|-----------|--------|-------------|-----------------|----------|--------------|
| 1    | outflo   | OSRC 1    | pipe1  | RES 1       | 0.0 (variable)  | sr       | no           |
| 2    | ave_day  | RES 1     | pipe2  | WTP 1       | 1000.0          | sr       | no           |
| 3    | outflo   | WTP 1     | pipe3  | STOR 1      | 0.0 (variable)  | sr       | no           |
| 4    | ave_day  | STOR 1    | pipe4  | USE 1       | 200.0 (70%)     | sr       | no           |
| 5    | ave_day  | STOR 1    | pipe5  | USE 2       | 300.0 (30%)     | sr       | no           |
| 6    | dtbl_irr | STOR 1    | pipe6  | HRU 2       | 0.0 (table)     | sr       | no           |
| 7    | outflo   | WTP 2     | pipe5  | CHA 1       | 0.0 (50%)       | sr       | no           |
| 8    | outflo   | WTP 2     | pipe5  | WTP 3       | 0.0 (50%)       | sr       | no           |
| 9    | outflo   | WTP 3     | pipe5  | CHA 2       | 0.0 (50%)       | sr       | no           |
| 10   | outflo   | USE 3     | pipe5  | STOR 1      | 0.0 (50%)       | sr       | no           |
| 11   | dtbl_irr | RES1+AQU2 | pipe6+pump1 | HRU 3  | 0.0 (table)     | sr       | **yes**      |
| 12   | dtbl_irr | RES1+AQU2 | pipe7+pump1 | HRU 4  | 0.0 (table)     | sr       | **yes**      |

## Source Constraints Summary

| Source | Type      | Object# | Constraint Type | Limit Description              |
|--------|-----------|---------|-----------------|--------------------------------|
| 1      | Reservoir | 1       | mon_lim         | Min 50% pool level year-round  |
| 2      | Aquifer   | 2       | mon_lim         | Max 13m drawdown year-round    |
| 3      | Outside   | 1       | mon_lim         | Variable: 0.5-0.8 seasonal     |

## Pipe Network Summary

| Pipe# | Name   | Max Flow (cms) | Lag (days) | Loss (%) | Connected Aquifer |
|-------|--------|----------------|------------|----------|-------------------|
| 1     | pipe1  | 10.0           | 0          | 2%       | AQU 1             |
| 2     | pipe2  | 15.0           | 0          | 3%       | AQU 1             |
| 3     | pipe3  | 12.0           | 0          | 3%       | AQU 1             |
| 4     | pipe4  | 10.0           | 0          | 2%       | AQU 1             |
| 5     | pipe5  | 15.0           | 0          | 3%       | AQU 1             |
| 6     | pipe6  | 12.0           | 0          | 3%       | AQU 1             |
| 7     | pipe7  | 10.0           | 0          | 2%       | AQU 1             |

## Key Features

### 1. Multi-Source Irrigation (TRN 11, 12)
- **Primary Source**: Reservoir 1 via pipe6/pipe7
- **Backup Source**: Aquifer 2 via pump1 
- **Compensation Logic**: If reservoir cannot meet demand, aquifer automatically provides backup
- **Decision Table**: `irr_str8_dmd` controls irrigation timing and amounts

### 2. Treatment Plant Cascade
- **WTP 1**: Primary treatment for municipal supply
- **WTP 2 → WTP 3**: Advanced treatment chain for effluent polishing
- **Split Discharge**: 50% to CHA 1, 50% through WTP 3 to CHA 2

### 3. Municipal Distribution
- **Storage**: Central 10,000 m³ water tower
- **Split Distribution**: 70% domestic (USE 1), 30% industrial (USE 2)
- **Fixed Demands**: 200 + 300 = 500 m³/day total municipal demand

### 4. Water Rights Priority
- **Rule**: `high_right_first_serve` - all transfers have senior rights (sr)
- **Sequential Processing**: Municipal → Industrial → Irrigation → Environmental
- **Compensation**: Only irrigation transfers (11, 12) have backup source capability

## Water Rights Priority
- **Rule Type**: `high_right_first_serve`
- **All transfers**: Senior rights (sr)
- **Compensation**: HRU 3,4 have aquifer backup when reservoir insufficient

## Allocation Logic Flow

1. **Primary Sources**: Reservoir serves municipal/industrial demands first
2. **Treatment**: Raw water passes through WTP1 for potability
3. **Storage**: Treated water stored in tower for distribution
4. **Distribution**: Split between domestic (70%) and industrial (30%) use
5. **Irrigation**: Served from storage with aquifer backup
6. **Recycling**: Treatment plant chain with effluent discharge
7. **Environmental**: Maintain channel flows through treated discharge

## Physical Constraints

- **Reservoir**: Cannot draw below 50% capacity
- **Aquifer**: Limited to 13m drawdown 
- **Outside Source**: Seasonal availability (50-80%)
- **Pipes**: Flow limits and 2-3% transmission losses
- **Treatment**: 10-day retention with 1% losses
- **Storage**: 10,000 m³ capacity towers

This system demonstrates a comprehensive water allocation network with multiple sources, treatment levels, storage, and end-use flexibility while maintaining environmental flows and backup supply security.