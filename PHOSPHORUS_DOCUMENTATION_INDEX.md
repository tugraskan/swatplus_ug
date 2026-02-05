# SWAT+ Phosphorus Documentation - Master Index

This repository contains comprehensive documentation for soil phosphorus (P) modeling in SWAT+, specifically focusing on labile phosphorus and the dynamic P model options.

---

## Documentation Files

### 1. **Labile P (lab_p) Core Documentation**

#### **SOIL_LAB_P_DOCUMENTATION.md** ⭐ Start Here for lab_p
- Overview of labile phosphorus parameter
- Where lab_p is defined, read, and used
- Depth distribution across soil layers
- Input/output file formats
- Summary tables and quick reference

#### **LAB_P_COMPLETE_REFERENCE.md** 📚 Detailed Reference
- Line-by-line code reference for all 69 occurrences
- Complete listing of all 21 files using labile P
- Organized by operation type (initialization, transformation, addition, removal, etc.)
- Specific line numbers and code snippets

#### **LAB_P_VERIFICATION_SUMMARY.md** ✅ Verification Results
- Confirms labile P is ONLY used in documented locations
- No hidden or undocumented uses
- Complete phosphorus cycle accounting
- Search methodology and results

#### **LAB_P_LAYER_CLARIFICATION.md** 📋 Layer Distribution Explained
- Answers: "Is lab_P only set for the first layer?"
- Code evidence showing loop through ALL layers
- Example calculations for multi-layer profile
- Common misconceptions addressed

#### **LAB_P_ALL_LAYERS_VISUAL.md** 📊 Visual Diagrams
- Visual proof that ALL layers get lab_P values
- Soil profile diagrams with concentrations
- Loop flow diagrams
- Comparison: what code does vs doesn't do
- Storage structure visualization

---

### 2. **codes.bsn P Model Options Documentation**

#### **CODES_BSN_P_MODEL_DOCUMENTATION.md** ⭐ Start Here for P Models
- Complete guide to sol_P_model flag in codes.bsn
- Two options: 0 (Original SWAT) vs 1 (Vadas & White 2010)
- How each option affects labile P initialization
- How each option affects daily P transformations
- Detailed equations and algorithms
- Comparison tables
- Decision guide for choosing the right model

#### **CODES_BSN_P_MODEL_QUICK_REFERENCE.md** 🚀 Quick Lookup
- Condensed summary of P model options
- Key equations and differences
- Visual comparisons
- When to use each option
- Code file references

---

## Quick Navigation

### **I need to understand...**

| Topic | Read This |
|-------|-----------|
| What is labile P and where is it used? | SOIL_LAB_P_DOCUMENTATION.md |
| All code locations using labile P | LAB_P_COMPLETE_REFERENCE.md |
| Proof that all uses are documented | LAB_P_VERIFICATION_SUMMARY.md |
| Is lab_P only set for first layer? | LAB_P_LAYER_CLARIFICATION.md |
| Visual proof of all-layer initialization | LAB_P_ALL_LAYERS_VISUAL.md |
| P model options in codes.bsn | CODES_BSN_P_MODEL_DOCUMENTATION.md |
| Quick comparison of P models | CODES_BSN_P_MODEL_QUICK_REFERENCE.md |

---

## Key Questions Answered

### **Question 1: "Tell me about soil lab_p, where is it read in at, used, is it hardcoded to a specific layer"**

**Answer:** See **SOIL_LAB_P_DOCUMENTATION.md**

**Summary:**
- **Defined:** `src/soil_data_module.f90` (default = 5.0 ppm)
- **Read from:** `nutrients.sol` via `solt_db_read.f90`
- **Used in:** 21 source files, 69 total references
- **Layer assignment:** NOT hardcoded to single layer - applied to ALL layers with exponential depth decay
- **Depth function:** `concentration(depth) = lab_p × exp(-exp_co × depth)`

### **Question 2: "So labile P in soil surface is only used in these places; there are no other types or components subroutines that calculate or use it in the program"**

**Answer:** See **LAB_P_VERIFICATION_SUMMARY.md**

**Confirmed:** ✅ YES, labile P is ONLY used in the documented locations. Comprehensive search found:
- 69 references to `soil1%mp%lab`
- 21 unique source files
- All sources, sinks, and transformations accounted for
- No hidden or undocumented uses

### **Question 3: "In the codes.bsn tell me about options flag set for the dynamic P model; what are the options how does this effect labile P"**

**Answer:** See **CODES_BSN_P_MODEL_DOCUMENTATION.md** and **CODES_BSN_P_MODEL_QUICK_REFERENCE.md**

**Summary:**
- **Flag name:** `sol_P_model` (column 20 in codes.bsn, line 3)
- **Options:**
  - **0** = Original SWAT model (simple, fixed rates)
  - **1** = Vadas & White (2010) model (dynamic, time-dependent)
- **Effects on labile P:**
  - Initialization: Fixed vs dynamic PSP and SSP calculations
  - Daily transformations: Fixed rates (10%/60%) vs time-dependent rates (0.1-0.5)
  - Soil chemistry feedback: None vs daily PSP recalculation from clay, organic C, solution P

### **Question 4: "So is lab_P ever just set for the first layer"**

**Answer:** See **LAB_P_LAYER_CLARIFICATION.md** and **LAB_P_ALL_LAYERS_VISUAL.md**

**NO - lab_P is ALWAYS set for ALL layers:**
- Code uses loop: `do ly = 1, nly` (processes every layer)
- Each layer gets unique value based on depth: `lab_P(ly) = lab_p_input × exp(-exp_co × depth(ly))`
- Surface layer has highest concentration (e.g., 5.0 ppm)
- Concentration decreases exponentially with depth (e.g., 1.5 ppm at 1200mm)
- Example 5-layer profile: all 5 layers initialized with different values
- Visual diagrams show distribution across entire soil profile

---

## Phosphorus Pools in SWAT+

```
┌─────────────────────────────────────────────────────────────┐
│                   SOIL PHOSPHORUS POOLS                     │
│                                                             │
│  ┌──────────────┐    ┌──────────────┐    ┌──────────────┐ │
│  │   LABILE P   │◄──►│   ACTIVE P   │◄──►│  STABLE P    │ │
│  │  (lab_p)     │    │              │    │              │ │
│  │ Solution P   │    │ Mineral P    │    │ Mineral P    │ │
│  └──────────────┘    └──────────────┘    └──────────────┘ │
│        ▲                                                    │
│        │                                                    │
│        ├─ Fertilizer (pl_fert.f90)                         │
│        ├─ Manure (pl_manure.f90, pl_graze.f90)             │
│        ├─ Irrigation (gwflow_ppag.f90)                     │
│        ├─ Decomposition (rsd_decomp.f90, cbn_zhang2.f90)   │
│        │                                                    │
│        ├─ Plant Uptake (pl_pup.f90)                        │
│        ├─ Runoff Loss (nut_solp.f90)                       │
│        ├─ Leaching (nut_solp.f90)                          │
│        └─ Tile Drainage (nut_solp.f90)                     │
│                                                             │
│  Transformations: nut_pminrl.f90 OR nut_pminrl2.f90        │
│  (Selected by sol_P_model flag in codes.bsn)               │
└─────────────────────────────────────────────────────────────┘
```

---

## Code File Organization

### **Input/Reading**
- `src/solt_db_read.f90` - Reads `nutrients.sol` with lab_p values
- `src/basin_read_cc.f90` - Reads `codes.bsn` with sol_P_model flag

### **Initialization**
- `src/soil_nutcarb_init.f90` - Sets up initial P pools for all layers

### **Daily Calculations**
- `src/hru_control.f90` - Main HRU loop, selects P model
- `src/nut_pminrl.f90` - Original SWAT P transformations (if sol_P_model=0)
- `src/nut_pminrl2.f90` - Vadas & White P transformations (if sol_P_model=1)

### **P Additions**
- `src/pl_fert.f90` - Fertilizer application
- `src/pl_manure.f90` - Manure application
- `src/pl_graze.f90` - Grazing deposition
- `src/gwflow_ppag.f90` - Irrigation additions
- `src/rsd_decomp.f90` - Residue decomposition
- `src/cbn_zhang2.f90` - Zhang decomposition model
- `src/nut_nminrl.f90` - N mineralization (releases P)

### **P Removals/Losses**
- `src/pl_pup.f90` - Plant uptake
- `src/nut_solp.f90` - Runoff, leaching, tile drainage
- `src/sep_biozone.f90` - Biozone treatment

### **Other Processes**
- `src/mgt_newtillmix_wet.f90` - Tillage mixing
- `src/cal_parm_select.f90` - Calibration adjustments

---

## Scientific References

1. **Vadas, P.A. and White, M.J. (2010).** "Validating soil phosphorus routines in the SWAT model." 
   *Transactions of the ASABE*, 53(5), 1469-1476.

2. **Sharpley, A.N. (2004).** Phosphorus chemistry in soils and links to water quality.

3. **Vadas, P.A., Krogstad, T., and Sharpley, A.N. (2006).** "Modeling phosphorus transfer between labile and nonlabile soil pools: Updating the EPIC model."
   *Soil Science Society of America Journal*, 70, 736-743.

---

## Data Files

### Input Files
- `data/*/nutrients.sol` - Soil nutrient parameters including lab_p
- `data/*/codes.bsn` - Basin control codes including sol_P_model flag
- `data/*/soils.sol` - Soil physical properties (clay, organic C)

### Output Files  
- Various output files track `lab_min_p` (labile→active transformation rate)
- HRU and basin nutrient balance files

---

## Summary Statistics

| Statistic | Value |
|-----------|-------|
| Total documentation files | 8 files |
| Total labile P references in code | 69 |
| Files using labile P | 21 |
| P model options | 2 (original, Vadas & White) |
| Soil layers affected by lab_P | All layers (not hardcoded to one) |
| Default lab_p value | 5.0 ppm |
| PSP range (Vadas & White) | 0.10 to 0.70 |
| SSP range (Vadas & White) | 1.0 to 7.0 |

---

## Contributing

To update this documentation:
1. Update individual documentation files as needed
2. Update this master index to reflect changes
3. Ensure all cross-references are accurate
4. Maintain consistent formatting

---

## Document Version

- **Created:** 2026-02-05
- **Repository:** tugraskan/swatplus_ug
- **SWAT+ Version:** Based on rev.60.5.4
- **Last Updated:** 2026-02-05

---

## Contact

For questions about SWAT+ phosphorus modeling, refer to:
- SWAT+ documentation
- Original publications (Vadas & White 2010, etc.)
- SWAT+ development team
