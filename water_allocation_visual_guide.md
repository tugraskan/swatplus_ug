# SWAT+ Water Allocation System - Visual Guide for New Users

## Compact Poster-Ready Flowchart

```mermaid
graph TB
    subgraph " "
        subgraph "📚 INITIALIZATION (Once per simulation)"
            A1["📖 water_allocation_read()<br/>📍 Called from: Input Processing<br/>📄 Load allocation rules<br/>& object definitions"]
            A2["📊 header_water_allocation()<br/>📍 Called from: proc_open(), Line 17<br/>📄 Setup output files<br/>& headers"]
            A1 --> A2
        end
        
        subgraph "🔄 DAILY PROCESSING (Every simulation day)"
            subgraph "⏱️ Time Control Framework"
                TC["⏱️ time_control()<br/>📍 Called from: Main Program<br/>🔄 Daily simulation loop"]
                
                subgraph "🎯 Water Allocation Paths"
                    TC1["🎯 Direct Path:<br/>wallo_control(j)<br/>📍 Called from: time_control(), Line 239<br/>📝 For non-channel objects (cha_ob=='n')"]
                    
                    TC2["📋 Command Path:<br/>command() → sd_channel_control3()<br/>📍 Called from: time_control(), Line 250<br/>📍 Then from: command(), Line 362"]
                    
                    TC3["🎯 Channel Path:<br/>wallo_control(sd_ch%wallo)<br/>📍 Called from: sd_channel_control3(), Line 395<br/>📝 For channel-based allocation"]
                    
                    TC --> TC1
                    TC --> TC2
                    TC2 --> TC3
                end
            end
            
            subgraph "🎯 Main Control Loop"
                B1["🎯 wallo_control(iwallo)<br/>📍 Main allocation orchestrator<br/>📋 Process demand objects sequentially"]
                
                subgraph "💧 Demand Processing"
                    C1["💧 wallo_demand()<br/>📍 Called from: wallo_control(), Line 52<br/>📝 Calculate water needs"]
                    C1a["🌾 Irrigation<br/>(crop-based)"]
                    C1b["🏘️ Municipal<br/>(fixed/recall)"]
                    C1c["🏭 Industrial<br/>(decision table)"]
                    C1 --- C1a
                    C1 --- C1b  
                    C1 --- C1c
                end
                
                subgraph "🏗️ Water Withdrawal"
                    D1["🏗️ wallo_withdraw()<br/>📍 Called from: wallo_control()<br/>📝 Line 62: Primary withdrawal<br/>📝 Line 71: Compensation withdrawal<br/>📄 Extract from sources"]
                    D1a["🌊 Channels<br/>(min flow limits)"]
                    D1b["🏞️ Reservoirs<br/>(min level limits)"]
                    D1c["💧 Aquifers<br/>(depth limits)"]
                    D1d["♾️ Unlimited<br/>(no limits)"]
                    D1 --- D1a
                    D1 --- D1b
                    D1 --- D1c
                    D1 --- D1d
                end
                
                subgraph "🚰 Water Transfer & Treatment"
                    E1["🚰 wallo_transfer()<br/>📍 Called from: wallo_control(), Line 85<br/>📄 Move water to receivers"]
                    E2["🧪 wallo_treatment()<br/>📍 Called from: wallo_control(), Line 133<br/>📝 Optional treatment<br/>(if receiver type == 'wtp')"]
                    E1 --> E2
                end
                
                TC1 --> B1
                TC3 --> B1
                B1 --> C1
                C1 --> D1
                D1 --> E1
            end
        end
        
        subgraph "📈 OUTPUT GENERATION (Various frequencies)"
            F1["📈 water_allocation_output()<br/>📍 Called from: command(), Line 427<br/>📝 Within time check: yrs > nyskip<br/>📄 Write results to files"]
            F1a["📄 Daily<br/>(.day files)<br/>File handles: 3110, 3114"]
            F1b["📄 Monthly<br/>(.mon files)<br/>File handles: 3111, 3115"]
            F1c["📄 Annual<br/>(.yr files)<br/>File handles: 3112, 3116"]
            F1d["📄 Average<br/>(.aa files)<br/>File handles: 3113, 3117"]
            F1 --- F1a
            F1 --- F1b
            F1 --- F1c
            F1 --- F1d
        end
    end
    
    A2 --> TC
    E2 --> F1
    F1 --> TC
    
    classDef init fill:#E3F2FD,stroke:#1976D2,stroke-width:2px
    classDef daily fill:#F3E5F5,stroke:#7B1FA2,stroke-width:2px
    classDef subroutine fill:#E8F5E8,stroke:#388E3C,stroke-width:2px
    classDef output fill:#FFF3E0,stroke:#F57C00,stroke-width:2px
    classDef detail fill:#FAFAFA,stroke:#616161,stroke-width:1px
    classDef callpath fill:#E0F2F1,stroke:#00695C,stroke-width:2px
    
    class A1,A2 init
    class TC,TC2 daily
    class TC1,TC3,B1,C1,D1,E1,E2 subroutine
    class F1 output
    class C1a,C1b,C1c,D1a,D1b,D1c,D1d,F1a,F1b,F1c,F1d detail
```

## Data Flow Architecture

```mermaid
graph LR
    subgraph "📥 INPUTS"
        I1[".wal files<br/>Allocation rules"]
        I2["Recall data<br/>Time series"]
        I3["Decision tables<br/>Conditions"]
    end
    
    subgraph "🔄 CORE PROCESSING"
        P1["water_allocation_module<br/>Data structures & types"]
        P2["hydrograph_module<br/>Water flow management"]
        P3["Object modules<br/>HRU, Reservoir, Aquifer"]
    end
    
    subgraph "📤 OUTPUTS"
        O1["Daily reports<br/>.txt/.csv"]
        O2["Monthly summaries<br/>.txt/.csv"]
        O3["Annual totals<br/>.txt/.csv"]
        O4["Multi-year averages<br/>.txt/.csv"]
    end
    
    I1 --> P1
    I2 --> P1
    I3 --> P1
    P1 --> P2
    P2 --> P3
    P1 --> O1
    P1 --> O2
    P1 --> O3
    P1 --> O4
    
    classDef input fill:#C8E6C9,stroke:#4CAF50,stroke-width:2px
    classDef process fill:#BBDEFB,stroke:#2196F3,stroke-width:2px
    classDef output fill:#FFCDD2,stroke:#F44336,stroke-width:2px
    
    class I1,I2,I3 input
    class P1,P2,P3 process
    class O1,O2,O3,O4 output
```

## System Overview for New Users

### 🎯 **What is Water Allocation?**
The SWAT+ water allocation system simulates realistic water management by:
- Managing competing water demands (irrigation, municipal, industrial)
- Respecting water rights and source limitations
- Tracking water transfers between system components
- Accounting for treatment and conveyance losses

### 🔧 **How Does It Work?**

1. **Setup Phase** (once):
   - Read configuration files defining sources, demands, and rules
   - Initialize output files for results tracking

2. **Daily Processing** (every day):
   - Calculate water demands for all users
   - Check source availability and constraints
   - Withdraw water within legal/physical limits
   - Transfer water to end users
   - Apply treatment if required
   - Update system water balances

3. **Output Phase** (configurable frequency):
   - Generate detailed reports of allocation results
   - Track unmet demands and system performance

### 📊 **Key Components**

| Component | Function | Examples |
|-----------|----------|----------|
| **Sources** | Where water comes from | Rivers, reservoirs, aquifers |
| **Demands** | Who needs water | Farms, cities, industries |
| **Rules** | How allocation decisions are made | Water rights, priority systems |
| **Transfers** | How water moves | Pipes, canals, pumps |
| **Treatment** | How water quality is managed | Treatment plants, quality standards |

### 🌊 **Supported Water Sources**
- **🌊 Channels**: Stream diversions with environmental flow requirements
- **🏞️ Reservoirs**: Storage releases with level management
- **💧 Aquifers**: Groundwater extraction with sustainability limits
- **♾️ Unlimited**: External sources (imports, desalination)

### 💧 **Demand Types**
- **🌾 Irrigation**: Crop water needs based on growth stage and weather
- **🏘️ Municipal**: Urban water supply for domestic use
- **🏭 Industrial**: Manufacturing and processing water needs
- **🚰 Transfer**: Moving water between basins or systems

### 📈 **Output Information**
- **Demand**: How much water was requested
- **Withdrawal**: How much water was actually taken
- **Unmet**: How much demand couldn't be satisfied
- **Sources**: Which sources provided water
- **Efficiency**: How well the system performed

This system enables SWAT+ to model complex water management scenarios including drought response, water rights conflicts, and infrastructure planning.