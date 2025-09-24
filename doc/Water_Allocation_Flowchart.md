# SWAT+ Water Allocation System Flowchart

This document contains flowchart diagrams showing the program flow of the SWAT+ water allocation system.

## Overall System Flowchart

```mermaid
flowchart TD
    A[Main Program<br/>main.f90.in] --> B[Initialize System]
    B --> C[Read Input Files<br/>water_allocation_read]
    C --> D[Begin Simulation<br/>time_control]
    
    D --> E{For each day in<br/>simulation period}
    E -->|Daily Loop| F[Initialize Daily Conditions]
    F --> G{Water allocation<br/>objects exist?}
    
    G -->|Yes| H{For each water<br/>allocation object}
    G -->|No| T[Continue with other<br/>daily processes]
    
    H --> I[wallo_control<br/>iwallo]
    I --> J[Process Allocation Object]
    J --> K{More allocation<br/>objects?}
    K -->|Yes| H
    K -->|No| L[water_allocation_output<br/>Generate Output Files]
    
    L --> M{Last day of<br/>simulation?}
    M -->|No| E  
    M -->|Yes| N[End Simulation]
    
    T --> M

    style A fill:#e1f5fe
    style I fill:#f3e5f5
    style L fill:#e8f5e8
```

## Detailed Water Allocation Control Flow

```mermaid
flowchart TD
    A[wallo_control iwallo<br/>Main Control Subroutine] --> B[Initialize allocation object totals<br/>wallo.tot = walloz]
    
    B --> C{For each demand object<br/>itrn = 1 to wallo.trn_obs}
    
    C --> D[Zero demand/withdrawal/unmet<br/>for each source]
    D --> E[Compute flow from<br/>outside sources]
    E --> F[wallo_demand<br/>iwallo, itrn, isrc<br/>Calculate Demand]
    
    F --> G{Demand > 0?<br/>wallod_out.trn_flo > 0}
    
    G -->|Yes| H[Initialize withdrawal totals<br/>wdraw_om_tot = hz]
    G -->|No| W[Sum totals for<br/>allocation object]
    
    H --> I{For each source<br/>isrc = 1 to src_num}
    I --> J{trn_m3 > 1.e-6?}
    J -->|Yes| K[wallo_withdraw<br/>iwallo, itrn, isrc<br/>Withdraw Water]
    J -->|No| L{More sources?}
    
    K --> L
    L -->|Yes| I
    L -->|No| M[Check compensation sources]
    
    M --> N{For each source with<br/>compensation allowed}
    N --> O{Unmet demand > 1.e-6?}
    O -->|Yes| P[wallo_withdraw<br/>iwallo, itrn, isrc<br/>Compensate from source]
    O -->|No| Q{More compensation<br/>sources?}
    
    P --> Q
    Q -->|Yes| N
    Q -->|No| R[Compute total withdrawal<br/>from all sources]
    
    R --> S[wallo_transfer<br/>iwallo, itrn<br/>Apply Conveyance Losses]
    
    S --> T[Apply water to receiving object<br/>Based on object type]
    T --> U{Receiving object type}
    
    U -->|hru| U1[Apply irrigation water<br/>irrig.applied = irr_mm * irr_eff<br/>irrig.runoff = amount * surq<br/>Salt/CS mass accounting]
    U -->|res| U2[Add to reservoir<br/>res = res + h_tot]
    U -->|aqu| U3[Add to aquifer<br/>aqu = aqu + h_tot]
    U -->|wtp| U4[Send to treatment plant<br/>wtp_om_stor += h_tot<br/>wallo_treatment]
    U -->|use| U5[Send to water use<br/>wuse_om_stor += h_tot<br/>wallo_use]
    U -->|stor| U6[Add to water tower<br/>wtow_om_stor += h_tot]
    U -->|canal| U7[Add to canal storage<br/>canal_om_stor += h_tot]
    
    U1 --> V[Sum organics and constituents]
    U2 --> V
    U3 --> V
    U4 --> V
    U5 --> V
    U6 --> V
    U7 --> V
    
    V --> W[Sum demand, withdrawal, unmet<br/>for entire allocation object]
    W --> X{More demand<br/>objects?}
    X -->|Yes| C
    X -->|No| Y[Return to time_control]

    style A fill:#e1f5fe
    style F fill:#f3e5f5
    style K fill:#f3e5f5
    style P fill:#f3e5f5
    style S fill:#f3e5f5
    style U4 fill:#fff3e0
    style U5 fill:#fff3e0
```

## Water Demand Calculation Flow

```mermaid
flowchart TD
    A[wallo_demand<br/>iwallo, itrn, isrc] --> B[Initialize transfer flow<br/>wallod_out.trn_flo = 0]
    
    B --> C{Transfer Type<br/>wallo.trn.trn_typ}
    
    C -->|outflo| D{Source Type}
    D -->|out| D1[Out-of-basin source<br/>osrc_om_out.flo]
    D -->|wtp| D2[Water treatment plant<br/>wtp_om_out.flo]  
    D -->|use| D3[Water use<br/>wuse_om_out.flo]
    
    C -->|ave_day| E[Average daily transfer<br/>86400s/d * amount m3/s]
    
    C -->|rec| F{Recall Type}
    F -->|1| F1[Daily recall<br/>recall.hd day,yrs.flo]
    F -->|2| F2[Monthly recall<br/>recall.hd mo,yrs.flo]
    F -->|3| F3[Annual recall<br/>recall.hd 1,yrs.flo]
    
    C -->|dtbl_con| G[Decision table conditions<br/>call conditions<br/>call actions<br/>trn_m3]
    
    C -->|dtbl_lum| H{HRU irrigation demand}
    H --> H1{irrig.demand > 0?}
    H1 -->|Yes| H2{hru.irr_hmax > 0?}
    H2 -->|Yes| H3[Use irrigation demand<br/>irrig.demand m3]
    H2 -->|No| H4[Use allocation amount<br/>amount * area_ha * 10]
    H1 -->|No| H5[No demand<br/>trn_flo = 0]
    
    D1 --> I[Initialize unmet demand<br/>unmet_m3 = trn_flo]
    D2 --> I
    D3 --> I
    E --> I
    F1 --> I
    F2 --> I
    F3 --> I
    G --> I
    H3 --> I
    H4 --> I
    H5 --> I
    
    I --> J[Compute source demand<br/>src.demand = src.frac * trn_flo]
    J --> K[Return to wallo_control]

    style A fill:#e1f5fe
    style C fill:#fff3e0
    style H fill:#e8f5e8
```

## Water Withdrawal Flow

```mermaid
flowchart TD
    A[wallo_withdraw<br/>iwallo, itrn, isrc] --> B[Initialize withdrawal hydrograph<br/>wdraw_om = hz]
    
    B --> C{Source Type<br/>wallo.trn.src.typ}
    
    C -->|cha| D[Channel Source]
    D --> D1[Calculate minimum flow<br/>cha_min = limit_mon * 86400]
    D1 --> D2[Calculate available diversion<br/>cha_div = ht2.flo - cha_min]
    D2 --> D3{trn_m3 < cha_div?}
    D3 -->|Yes| D4[Withdraw requested amount<br/>rto = trn_m3 / ht2.flo<br/>Update channel flow]
    D3 -->|No| D5[Record unmet demand<br/>unmet += trn_m3]
    
    C -->|res| E[Reservoir Source]
    E --> E1[Calculate minimum volume<br/>res_min = limit_mon * pvol]
    E1 --> E2[Check remaining volume<br/>res_vol = res.flo - trn_m3]
    E2 --> E3{res_vol > res_min?}
    E3 -->|Yes| E4[Withdraw requested amount<br/>rto = trn_m3 / res.flo<br/>Update reservoir]
    E3 -->|No| E5[Record unmet demand<br/>unmet += trn_m3]
    
    C -->|aqu| F{Groundwater flow active?<br/>bsn_cc.gwflow}
    F -->|No| F1[Original aquifer code]
    F1 --> F2[Calculate available water<br/>avail = limit_mon - dep_wt * spyld * area]
    F2 --> F3{trn_m3 < avail?}
    F3 -->|Yes| F4[Withdraw from aquifer<br/>Update storage and nutrients]
    F3 -->|No| F5[Record unmet demand<br/>unmet += trn_m3]
    
    F -->|Yes| G[MODFLOW-based withdrawal]
    G --> G1[Call gwflow_ppag<br/>hru_demand, extracted, unmet]
    G1 --> G2[Record withdrawal and unmet<br/>Based on gwflow results]
    
    C -->|unl| H[Unlimited Source]
    H --> H1[Provide full demand<br/>withdr += trn_m3]
    
    D4 --> I[Add to total withdrawal<br/>h_tot += src.hd]
    D5 --> I
    E4 --> I
    E5 --> I
    F4 --> I
    F5 --> I
    G2 --> I
    H1 --> I
    
    I --> J[Update unmet demand<br/>unmet_m3 -= withdr]
    J --> K[Return to wallo_control]

    style A fill:#e1f5fe
    style D fill:#e3f2fd
    style E fill:#e8f5e8
    style F fill:#fff3e0
    style H fill:#f3e5f5
```

## Water Treatment Flow

```mermaid
flowchart TD
    A[wallo_treatment<br/>iwallo, itrt] --> B[Get treatment parameters<br/>wtp_om_treat itrt]
    
    B --> C[Apply treatment efficiency<br/>outflo_om.flo = efficiency * wdraw_om_tot.flo]
    
    C --> D[Convert concentration to mass<br/>call hyd_convert_conc_to_mass]
    
    D --> E[Store treated water output<br/>wtp_om_out itrt = outflo_om]
    
    E --> F[Treat constituents<br/>call hydcsout_conc_mass<br/>wtp_cs_treat, outflo_cs]
    
    F --> G[Return to wallo_control]

    A2[wallo_use<br/>iwallo, iuse] --> B2[Get water use parameters<br/>wuse_om_effluent iom]
    
    B2 --> C2[Apply use efficiency<br/>outflo_om.flo = efficiency * wdraw_om_tot.flo]
    
    C2 --> D2[Convert concentration to mass<br/>call hyd_convert_conc_to_mass]
    
    D2 --> E2[Store water use output<br/>wuse_om_out iuse = outflo_om]
    
    E2 --> F2[Process constituent effluent<br/>call hydcsout_conc_mass<br/>wuse_cs_effluent, outflo_cs]
    
    F2 --> G2[Return to wallo_control]

    style A fill:#e1f5fe
    style A2 fill:#e1f5fe
```

## Water Transfer Flow

```mermaid
flowchart TD
    A[wallo_transfer<br/>iwallo, itrn] --> B{For each source<br/>isrc = 1 to src_num}
    
    B --> C[Get conveyance object<br/>iconv = src.conv_num]
    
    C --> D{Conveyance Type<br/>src.conv_typ}
    
    D -->|pipe| E[Apply pipe losses<br/>ht5 = pipe.loss_fr * ht5]
    D -->|pump| F[Apply pump losses<br/>Future implementation]
    
    E --> G{More sources?}
    F --> G
    G -->|Yes| B
    G -->|No| H[Return to wallo_control]

    style A fill:#e1f5fe
```

## Integration with Main SWAT+ Components

```mermaid
flowchart LR
    A[time_control<br/>Daily Loop] --> B{Water Allocation<br/>Objects Exist?}
    
    B -->|Yes| C[wallo_control<br/>For each object]
    B -->|No| D[Continue Daily<br/>Processing]
    
    C --> E[Channel Routing<br/>ch_rtday]
    C --> F[HRU Processing<br/>hru_control]
    C --> G[Reservoir Operations<br/>res_control]
    C --> H[Aquifer Processing<br/>aqu_control]
    
    E --> I[Water Balance<br/>Updates]
    F --> I
    G --> I
    H --> I
    
    I --> J[Output Generation<br/>water_allocation_output]
    J --> K[End of Day<br/>Processing]
    
    D --> K

    style C fill:#e1f5fe
    style J fill:#e8f5e8
```

These flowcharts provide a comprehensive visual representation of the SWAT+ water allocation system's program flow, showing the relationships between subroutines and the decision logic within each component.