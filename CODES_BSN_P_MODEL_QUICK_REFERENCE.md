# Quick Reference: codes.bsn sol_P_model Flag

## Question
**"In the codes.bsn tell me about options flag set for the dynamic P model; what are the options how does this effect labile P"**

---

## Answer Summary

### The Flag: **sol_P_model** (also called **soil_p** in codes.bsn)

**Location in codes.bsn:** Column 20, Line 3  
**Default Value:** 0

---

## Two Options Available

### **Option 0: Original SWAT Model** (Default)
- Simple, static phosphorus calculations
- Fixed PSP (Phosphorus Sorption Probability) from input file
- Fixed transformation rates: 10% forward, 60% backward
- Stable P = 4 × Active P (hardcoded)

### **Option 1: Vadas & White (2010) Model**
- Advanced, dynamic phosphorus calculations  
- PSP calculated daily from soil properties (clay, organic C, solution P)
- Time-dependent transformation rates (0.1 to 0.5)
- Dynamic Stable P from Sharpley (2004) equation

---

## Effect on Labile P

| Aspect | Option 0 | Option 1 |
|--------|----------|----------|
| **Initialization** | Uses fixed PSP | Calculates PSP from soil chemistry |
| **Daily Updates** | Simple 10%/60% rates | Time-dependent rates based on days since fertilizer |
| **Fertilizer Response** | Pool size changes only | PSP increases, transformation rate adjusts |
| **Soil Chemistry** | No feedback | Clay, organic C affect PSP daily |
| **Complexity** | Low | High |

---

## Key Equations

### **Option 0: Original Model**
```fortran
! Fixed from input
PSP = hru%nut%psp  

! Simple imbalance
rmp1 = (labile_P - active_P * PSP/(1-PSP))

! Fixed rates
if (rmp1 > 0) rmp1 = rmp1 * 0.1   ! Labile → Active
if (rmp1 < 0) rmp1 = rmp1 * 0.6   ! Active → Labile

! Fixed stable pool
stable_P = 4 × active_P
```

### **Option 1: Vadas & White Model**
```fortran
! Dynamic PSP (recalculated daily)
PSP = -0.045×log(clay%) + 0.001×(solution_P) - 0.035×(org_C%) + 0.43
! Constrained: 0.10 ≤ PSP ≤ 0.70

! Time-dependent rate (decreases after fertilizer)
if (P_excess) then
  vara = 0.918 × exp(-4.603 × PSP)
  varb = (-0.238 × log(vara)) - 1.126
  rate = vara × (days_since_application)^varb
  ! Constrained: 0.1 ≤ rate ≤ 0.5
end if

! Dynamic stable pool (Sharpley 2004)
SSP = 25.044 × (active_P + labile_P)^(-0.3833)
stable_P = SSP × (active_P + labile_P)
! Constrained: 1.0 ≤ SSP ≤ 7.0
```

---

## How It Affects Labile P Behavior

### **After Fertilizer Application:**

**Option 0 (Original):**
1. Labile P increases
2. Fixed 10% transfers to active pool daily
3. Same rate every day
4. Predictable, simple response

**Option 1 (Vadas & White):**
1. Labile P increases
2. PSP increases (more solution P)
3. High transformation rate initially
4. Rate decreases over time (realistic sorption kinetics)
5. Responds to soil properties

### **Visual Comparison:**
```
Option 0: Fertilizer → Labile ══10%══> Active (constant rate)
                              ══60%══< 

Option 1: Fertilizer → Labile ═══50%══> Active (day 1, high rate)
                              ═══20%══> Active (day 7, slower)
                              ═══10%══> Active (day 30, slowest)
          (PSP adjusts daily based on clay%, org_C%, solution_P)
```

---

## Code References

**Flag Definition:**
- File: `src/basin_module.f90` (line 61-62)

**Read from codes.bsn:**
- File: `src/basin_read_cc.f90` (line 24)

**Initialization Impact:**
- File: `src/soil_nutcarb_init.f90` (lines 78-112)

**Daily Calculations:**
- File: `src/hru_control.f90` (line 371-375) - selects subroutine
- Option 0: `src/nut_pminrl.f90`
- Option 1: `src/nut_pminrl2.f90`

---

## How to Set It

**Edit codes.bsn, Line 3, Column 20:**

For Original Model:
```
null  null  1  0  0  1  0  0  0  1  0  0  0  0  0  1  0  0  0  0  0  a  0  0
                                                              ↑
```

For Vadas & White Model:
```
null  null  1  0  0  1  0  0  0  1  0  0  0  0  0  1  0  0  0  1  0  a  0  0
                                                              ↑
```

---

## When to Use Each Option

### Use **Option 0** if:
- ✅ Standard SWAT+ application
- ✅ Limited soil data
- ✅ Computational speed matters
- ✅ Simple P management

### Use **Option 1** if:
- ✅ Detailed P cycling study
- ✅ Good soil chemistry data
- ✅ Fertilizer management comparison
- ✅ Research-grade accuracy needed
- ✅ Variable soil properties

---

## References

- **Vadas, P.A. and White, M.J. (2010).** Validating soil phosphorus routines in the SWAT model. *Transactions of the ASABE*, 53(5), 1469-1476.
- **Sharpley, A.N. (2004).** Phosphorus chemistry relationships.
- **Vadas, P.A. et al. (2006).** Modeling phosphorus transfer between labile and nonlabile soil pools. *SSSAJ*, 70, 736-743.

---

## Related Documentation

For complete details, see:
- **CODES_BSN_P_MODEL_DOCUMENTATION.md** - Full technical documentation
- **SOIL_LAB_P_DOCUMENTATION.md** - General labile P overview  
- **LAB_P_COMPLETE_REFERENCE.md** - All labile P code locations
