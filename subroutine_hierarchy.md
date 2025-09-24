# SWAT+ Water Allocation Subroutine Hierarchy

## Call Tree Diagram

```mermaid
graph TD
    subgraph "🚀 SIMULATION STARTUP"
        MAIN[Main Program] --> INIT[Initialization Phase]
        INIT --> READ["📖 water_allocation_read()<br/>• Read .wal files<br/>• Load demand/source objects<br/>• Setup allocation rules"]
        INIT --> HEADER["📊 header_water_allocation()<br/>• Open output files<br/>• Write file headers<br/>• Setup file handles"]
    end
    
    subgraph "🔄 DAILY SIMULATION LOOP"
        MAIN --> TIMELOOP[time_control]
        TIMELOOP --> COMMAND[command]
        COMMAND --> CHANNEL[sd_channel_control3]
        CHANNEL --> WALLOCHECK{Water Allocation<br/>Object Present?}
        
        WALLOCHECK -->|Yes| CONTROL["🎯 wallo_control(iwallo)<br/>MAIN ALLOCATION CONTROL<br/><br/>• Initialize totals<br/>• Loop through demand objects<br/>• Coordinate all sub-processes<br/>• Sum final results"]
        
        CONTROL --> DEMAND["💧 wallo_demand(iwallo,itrn,isrc)<br/>DEMAND CALCULATION<br/><br/>• Calculate water needs by type<br/>• Handle irrigation, municipal, industrial<br/>• Use recall data or decision tables<br/>• Set unmet = total demand"]
        
        DEMAND --> WITHDRAW["🏗️ wallo_withdraw(iwallo,itrn,isrc)<br/>WATER WITHDRAWAL<br/><br/>• Check source availability<br/>• Respect physical/legal limits<br/>• Update source water balances<br/>• Record withdrawal amounts"]
        
        WITHDRAW --> TRANSFER["🚰 wallo_transfer(iwallo,itrn)<br/>WATER TRANSFER<br/><br/>• Account for conveyance losses<br/>• Handle pipe/pump efficiency<br/>• Move water to receiving objects"]
        
        TRANSFER --> APPLY[Apply Water to Receivers]
        
        APPLY --> TREATMENT_CHECK{Treatment<br/>Required?}
        TREATMENT_CHECK -->|Yes| TREATMENT["🧪 wallo_treatment(iwallo,j)<br/>WATER TREATMENT<br/><br/>• Apply treatment efficiency<br/>• Update water quality<br/>• Handle constituent removal<br/>• Calculate outflow"]
        
        TREATMENT_CHECK -->|No| NEXT_DEMAND
        TREATMENT --> NEXT_DEMAND[Next Demand Object]
        
        NEXT_DEMAND --> MORE_DEMANDS{More Demand<br/>Objects?}
        MORE_DEMANDS -->|Yes| DEMAND
        MORE_DEMANDS -->|No| OUTPUT_CALL
        
        OUTPUT_CALL --> OUTPUT["📈 water_allocation_output(iwallo)<br/>OUTPUT GENERATION<br/><br/>• Write daily results<br/>• Accumulate monthly/yearly<br/>• Generate summary reports<br/>• Update all output files"]
    end
    
    WALLOCHECK -->|No| NEXT_OBJECT[Next Object]
    NEXT_OBJECT --> WALLOCHECK
    OUTPUT --> NEXT_OBJECT
    
    classDef startup fill:#E3F2FD,stroke:#1976D2,stroke-width:2px
    classDef mainloop fill:#F3E5F5,stroke:#7B1FA2,stroke-width:2px
    classDef subroutine fill:#E8F5E8,stroke:#388E3C,stroke-width:3px
    classDef decision fill:#FFF3E0,stroke:#F57C00,stroke-width:2px
    classDef process fill:#FAFAFA,stroke:#616161,stroke-width:1px
    
    class MAIN,INIT startup
    class TIMELOOP,COMMAND,CHANNEL,APPLY,NEXT_DEMAND,NEXT_OBJECT mainloop
    class READ,HEADER,CONTROL,DEMAND,WITHDRAW,TRANSFER,TREATMENT,OUTPUT subroutine
    class WALLOCHECK,TREATMENT_CHECK,MORE_DEMANDS decision
```

## Simplified Call Sequence

```
Main Program
├── Initialization
│   ├── water_allocation_read()     ← Read input files
│   └── header_water_allocation()   ← Setup outputs
│
└── Daily Loop (time_control)
    └── Command Processing
        └── Channel Processing (sd_channel_control3)
            └── IF water allocation object exists:
                ├── wallo_control(iwallo)           ← MAIN CONTROL
                │   ├── wallo_demand(...)           ← Calculate demands  
                │   ├── wallo_withdraw(...)         ← Extract water
                │   ├── wallo_transfer(...)         ← Move water
                │   └── wallo_treatment(...) [opt]  ← Treat water
                └── water_allocation_output(...)    ← Write results
```

## Module Dependencies

```mermaid
graph TB
    subgraph "Core Modules"
        WAM[water_allocation_module<br/>• Data structures<br/>• Object definitions<br/>• Output arrays]
        HYD[hydrograph_module<br/>• Water flow data<br/>• Transfer objects<br/>• Flow routing]
        
        WAM --> HYD
    end
    
    subgraph "Object Modules"
        HRU[hru_module<br/>• Irrigation targets<br/>• Crop demands<br/>• Field application]
        
        RES[reservoir_module<br/>• Storage levels<br/>• Release rules<br/>• Water balance]
        
        AQU[aquifer_module<br/>• Groundwater<br/>• Pumping limits<br/>• Storage updates]
        
        CHAN[sd_channel_module<br/>• Stream flow<br/>• Diversions<br/>• Min flow limits]
    end
    
    subgraph "Support Modules"
        TIME[time_module<br/>• Simulation timing<br/>• Date handling]
        
        BASIN[basin_module<br/>• Watershed data<br/>• Global settings]
        
        COND[conditional_module<br/>• Decision tables<br/>• Rule evaluation]
    end
    
    WAM --> HRU
    WAM --> RES  
    WAM --> AQU
    WAM --> CHAN
    WAM --> TIME
    WAM --> BASIN
    WAM --> COND
    
    classDef core fill:#4CAF50,stroke:#2E7D32,stroke-width:2px,color:#fff
    classDef object fill:#2196F3,stroke:#1565C0,stroke-width:2px,color:#fff
    classDef support fill:#FF9800,stroke:#E65100,stroke-width:2px,color:#fff
    
    class WAM,HYD core
    class HRU,RES,AQU,CHAN object
    class TIME,BASIN,COND support
```

## Key Points for New Users

### 🎯 **Main Entry Point**
- `wallo_control()` is the central orchestrator
- Called once per day for each water allocation object
- Coordinates all sub-processes in logical order

### 📚 **Initialization (Once per simulation)**
1. `water_allocation_read()` - Load all configuration
2. `header_water_allocation()` - Prepare output files

### 🔄 **Daily Processing (Every simulation day)**
1. `wallo_demand()` - Calculate water needs
2. `wallo_withdraw()` - Extract available water  
3. `wallo_transfer()` - Move water to users
4. `wallo_treatment()` - Apply treatment (if needed)
5. `water_allocation_output()` - Record results

### 📊 **Data Flow**
- Input files → Module data structures → Processing → Output files
- Water balance tracking throughout all steps
- Constituent and quality tracking parallel to water

### ⚠️ **Important Notes**
- Each subroutine updates global data structures
- Water balance is maintained at each step
- Source limits are enforced during withdrawal
- Treatment is optional based on object configuration
- Output frequency is user-configurable