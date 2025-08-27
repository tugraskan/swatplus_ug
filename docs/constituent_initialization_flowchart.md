# Constituent Initialization Flow Diagram

This document provides a visual representation of how CS, PEST, and PATH are initialized in SWAT+ HRUs.

## Overall Process Flow

```
┌─────────────────┐
│    main.f90     │
│                 │
│ 1. proc_read    │──┐
│ 2. proc_hru     │  │
└─────────────────┘  │
                     │
                     ▼
┌────────────────────────────────────────────────────────────┐
│                    PHASE 1: READING                       │
│                   (proc_read.f90)                         │
└────────────────────────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐
│ constit_db_read │  │ soil_plant_init │  │ pest_hru_aqu_   │
│                 │  │                 │  │     _read       │
│ constituents.cs │  │ soil_plant_ini  │  │ pest_soil.ini   │
│                 │  │                 │  │                 │
│  cs_db ←────────┘  │ sol_plt_ini ←───┘  │ pest_soil_ini ←─┘
└─────────────────┘  └─────────────────┘  └─────────────────┘
                     │
                     ▼
┌─────────────────┐  ┌─────────────────┐
│ path_hru_aqu_   │  │   cs_hru_read   │
│     _read       │  │                 │
│ path_soil.ini   │  │   cs_hru.ini    │
│                 │  │                 │
│ path_soil_ini ←─┘  │ cs_soil_ini ←───┘
└─────────────────┘  └─────────────────┘
                     │
                     ▼
┌────────────────────────────────────────────────────────────┐
│                  PHASE 2: INITIALIZATION                  │
│                     (proc_hru.f90)                        │
└────────────────────────────────────────────────────────────┘
                     │
                     ▼
          ┌─────────────────────┐
          │   For each HRU:     │
          │                     │
          │ if (num_pests > 0)  │──┐
          │   pesticide_init    │  │
          │                     │  │
          │ if (num_paths > 0)  │  │
          │   pathogen_init     │  │
          │                     │  │
          │ if (num_cs > 0)     │  │
          │   cs_hru_init       │  │
          └─────────────────────┘  │
                     │             │
                     ▼             │
        ┌─────────────────────────┐│
        │    HRU Constituents     ││
        │      Initialized        ││
        │                         ││
        │ cs_soil(ihru)%ly()%*    ││
        │ cs_pl(ihru)%*           ││
        │ cs_irr(ihru)%*          ││
        └─────────────────────────┘│
                                  │
                                  ▼
                     ┌─────────────────┐
                     │   Model Ready   │
                     │   for Execution │
                     └─────────────────┘
```

## Data Flow Diagram

```
Input Files                 Memory Structures              HRU Arrays
─────────────────          ──────────────────            ────────────────

constituents.cs     ──────▶ cs_db
                            ├── num_pests
                            ├── pests()
                            ├── num_paths  
                            ├── paths()
                            ├── num_cs
                            └── cs()

soil_plant_ini      ──────▶ sol_plt_ini()
                            ├── name
                            ├── pestc ─────────┐
                            ├── pathc ─────────┼─┐
                            └── csc ───────────┼─┼─┐

pest_soil.ini       ──────▶ pest_soil_ini()   │ │ │    ┌─▶ cs_soil(ihru)%ly()%pest()
                            ├── name          │ │ │    │
                            ├── soil() ───────┘ │ │    ├─▶ cs_pl(ihru)%pl_on()%pest()
                            └── plt()           │ │    │
                                               │ │    └─▶ cs_irr(ihru)%pest()
path_soil.ini       ──────▶ path_soil_ini()   │ │
                            ├── name          │ │    ┌─▶ cs_soil(ihru)%ly()%path()
                            ├── soil() ───────┘ │    │
                            └── plt()           │    └─▶ cs_pl(ihru)%pl_on()%path()
                                               │
cs_hru.ini          ──────▶ cs_soil_ini()     │    ┌─▶ cs_soil(ihru)%ly()%cs()
                            ├── name          │    │
                            ├── soil() ───────┘    ├─▶ cs_soil(ihru)%ly()%csc()
                            └── plt()              │
                                                  ├─▶ cs_soil(ihru)%ly()%cs_sorb()
                                                  │
                                                  └─▶ cs_soil(ihru)%ly()%csc_sorb()
```

## HRU Linkage System

```
HRU Definition               Initialization Data
─────────────────           ───────────────────

hru(1)%dbs%soil_plant_init ──▶ sol_plt_ini(1)
                                ├── pestc ──▶ pest_soil_ini(X)
                                ├── pathc ──▶ path_soil_ini(Y) 
                                └── csc ────▶ cs_soil_ini(Z)

hru(2)%dbs%soil_plant_init ──▶ sol_plt_ini(1)  (same as HRU 1)
                                ├── pestc ──▶ pest_soil_ini(X)
                                ├── pathc ──▶ path_soil_ini(Y)
                                └── csc ────▶ cs_soil_ini(Z)

hru(3)%dbs%soil_plant_init ──▶ sol_plt_ini(2)  (different initialization)
                                ├── pestc ──▶ pest_soil_ini(A)
                                ├── pathc ──▶ path_soil_ini(B)
                                └── csc ────▶ cs_soil_ini(C)
```

## Concentration to Mass Conversion Process

```
Input Concentrations              Conversion Process                Final HRU Storage
───────────────────              ──────────────────               ─────────────────

Pesticides:
mg/kg (soil)        ──▶  × bulk_density × thickness / 100  ──▶  kg/ha (mass)
mg/kg (plant)       ──▶  × LAI fraction                    ──▶  kg/ha (mass)

Pathogens:
CFU (soil)          ──▶  Direct assignment to top layer    ──▶  CFU (count)
CFU (plant)         ──▶  Balance tracking                  ──▶  CFU (count)

Other Constituents:
g/m³ (dissolved)    ──▶  × water_volume / area            ──▶  kg/ha (mass)
mg/kg (sorbed)      ──▶  × soil_mass / area / 1e6         ──▶  kg/ha (mass)
```

## Memory Layout for Multiple Constituents

```
For HRU i with N soil layers and M plants:

cs_soil(i)
├── ly(1)
│   ├── pest(1..num_pests)     ┐
│   ├── path(1..num_paths)     │ Layer 1
│   └── cs(1..num_cs)          ┘
├── ly(2)
│   ├── pest(1..num_pests)     ┐
│   ├── path(1..num_paths)     │ Layer 2  
│   └── cs(1..num_cs)          ┘
└── ...

cs_pl(i)
├── pl_on(1)
│   ├── pest(1..num_pests)     ┐
│   └── path(1..num_paths)     │ Plant 1
├── pl_on(2)                   ┘
│   ├── pest(1..num_pests)     ┐
│   └── path(1..num_paths)     │ Plant 2
└── ...                        ┘

cs_irr(i)
├── pest(1..num_pests)
├── path(1..num_paths)
└── cs(1..num_cs)
```

This hierarchical structure allows the model to track multiple constituents across multiple soil layers and plant communities within each HRU, providing the foundation for detailed constituent fate and transport modeling during simulation.