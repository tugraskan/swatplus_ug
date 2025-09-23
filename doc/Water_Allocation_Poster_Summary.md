# SWAT+ Water Allocation System - Poster Summary

## New Water Allocation Capabilities in SWAT+

### Overview
Enhanced SWAT+ with comprehensive water allocation system for realistic modeling of water transfers, municipal supply, irrigation, and water rights management.

---

## What Changed

### **New Core Components**
- **4 New Fortran Modules**: `wallo_control.f90`, `wallo_demand.f90`, `wallo_withdraw.f90`, `wallo_transfer.f90`
- **Integration Points**: Daily simulation loop, channel routing, initialization sequence
- **Decision Table Support**: Dynamic allocation rules based on environmental conditions
- **Water Rights Framework**: Senior/junior priority system with compensation mechanisms

### **Enhanced Model Architecture**
- **Multi-Source Allocation**: Single demand can draw from multiple sources with backup/compensation
- **Advanced Constraints**: Monthly limits, decision tables, recall data for source availability
- **Water Quality Integration**: Full constituent mass balance through all transfers
- **GWFlow Compatibility**: Realistic groundwater pumping with 3D flow simulation

---

## New Input Files

| File | Purpose | Key Features |
|------|---------|--------------|
| **`water_allocation.wro`** | Main configuration | Sources, transfers, allocation rules, water rights |
| **`water_pipe.wal`** | Conveyance infrastructure | Pipe capacities, losses, lag times |
| **`water_treat.wal`** | Treatment plants | Efficiency, storage, water quality modification |
| **`water_use.wal`** | Municipal/industrial use | Consumption, return flows, water quality changes |
| **`water_tower.wal`** | Storage facilities | Capacity, losses, operational parameters |

### **Input Features**
- **Flexible Configuration**: Mix-and-match sources and demands
- **Seasonal Constraints**: Monthly varying limits for all sources
- **Decision Table Integration**: Complex conditional allocation rules
- **Compensation Logic**: Automatic backup source activation

---

## New Output Files

### **Multi-Temporal Outputs**
- **Daily**: `water_allo_day.txt/.csv` - Real-time allocation decisions
- **Monthly**: `water_allo_mon.txt/.csv` - Seasonal performance analysis  
- **Yearly**: `water_allo_yr.txt/.csv` - Annual water balance summaries
- **Average Annual**: `water_allo_aa.txt/.csv` - Long-term system performance

### **Output Content**
- **Source Performance**: Withdrawals, availability, constraint compliance
- **Demand Tracking**: Total demand, met demand, unmet demand by source
- **Water Rights Compliance**: Senior vs. junior rights performance
- **System Efficiency**: Overall allocation success rates

---

## New Logic and Objects

### **Water Source Objects**
- **Channels**: Surface water with minimum flow protection
- **Reservoirs**: Storage water with minimum pool level constraints
- **Aquifers**: Groundwater with sustainable yield limits
- **Outside Sources**: External supplies with variable availability
- **Unlimited Sources**: Theoretical unlimited supply for planning scenarios

### **Demand Objects** 
- **HRU Irrigation**: Crop-based water demand with efficiency factors
- **Municipal Use**: Fixed or variable urban water demand
- **Inter-basin Diversions**: Water transfers between watersheds
- **Treatment Plants**: Water processing with quality modification
- **Storage Systems**: Water towers and reservoirs for supply buffering

### **Transfer Logic**
```
Daily Allocation Sequence:
1. Calculate demands (crop stress, municipal needs, diversions)
2. Check source availability (constraints, water rights)
3. Allocate water (priority order, compensation logic)
4. Transfer water (conveyance losses, treatment)
5. Update receiving objects (irrigation, storage, discharge)
```

### **Advanced Features**
- **Multi-Source Irrigation**: Primary + backup sources with automatic switching
- **Wastewater Treatment**: Collection → Treatment → Recycling/Discharge
- **Water Recycling**: Treated wastewater returning to potable supply
- **Compensation Logic**: Secondary sources activated when primary sources insufficient

---

## Real-World Application: Solo1 Case Study

### **System Configuration**
- **3 Sources**: Reservoir, Aquifer, Outside Source
- **14 Transfer Objects**: Municipal supply, irrigation, wastewater treatment
- **10 Receiving Objects**: Uses, treatment plants, storage, irrigation, channels

### **Key Capabilities Demonstrated**
- **Primary Supply Chain**: Outside Source → Reservoir → Treatment → Storage → Distribution
- **Wastewater Management**: Collection → Secondary Treatment → Tertiary Treatment → Recycle/Discharge
- **Multi-Source Irrigation**: Reservoir primary, Aquifer backup with compensation
- **Advanced Water Reuse**: Treated wastewater returning to potable storage

---

## Benefits and Applications

### **Enhanced Modeling Capabilities**
- **Realistic Water Management**: Actual allocation decisions with constraints
- **Water Rights Modeling**: Legal/institutional water allocation frameworks
- **Climate Adaptation**: Variable source availability and demand scenarios
- **Infrastructure Planning**: Storage, treatment, and conveyance system design

### **Research Applications**
- **Water Scarcity Analysis**: Shortage frequency, duration, and severity
- **Policy Evaluation**: Water rights, allocation rules, infrastructure investments
- **Climate Impact Assessment**: Drought/flood impacts on water supply systems
- **Sustainability Studies**: Long-term water balance and system reliability

### **Management Applications**
- **Operational Planning**: Daily/seasonal allocation decisions
- **Infrastructure Design**: System capacity and redundancy requirements
- **Regulatory Compliance**: Environmental flow maintenance, water rights adherence
- **Emergency Response**: Drought contingency and shortage management

---

## Technical Innovation

### **Integration with SWAT+ Core**
- **Seamless Hydrologic Coupling**: Allocation affects runoff, ET, groundwater
- **Water Quality Conservation**: Mass balance maintained through all transfers
- **Spatial Distribution**: HRU-level irrigation with area-weighted application
- **Temporal Flexibility**: Daily decisions with seasonal/annual summaries

### **Computational Efficiency**
- **Optimized Algorithms**: Efficient source-demand matching
- **Modular Design**: Independent allocation objects for scalability
- **Memory Management**: Dynamic allocation based on configuration
- **Output Control**: User-selectable temporal resolution

This comprehensive water allocation system transforms SWAT+ from a natural hydrology model into a complete water management decision support tool, enabling realistic simulation of human water systems within the natural hydrologic cycle.