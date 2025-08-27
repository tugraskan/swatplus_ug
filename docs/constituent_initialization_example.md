# Example: CS, PEST, and PATH Initialization Walkthrough

This document provides a concrete example of how constituents are read and initialized into HRUs in SWAT+.

## Example Scenario

Let's trace through the initialization of:
- 2 pesticides: "atrazine" and "metolachlor"  
- 1 pathogen: "e_coli"
- 1 other constituent: "selenium"

For 2 HRUs with different soil and plant characteristics.

## Step 1: Constituent Database Definition

**File: `constituents.cs`**
```
Constituent Database for Example Watershed
2                              ! num_pests
atrazine metolachlor          ! pesticide names
1                              ! num_paths  
e_coli                        ! pathogen names
0                              ! num_metals (none in this example)
0                              ! num_salts (none in this example)
1                              ! num_cs
selenium                      ! constituent names
```

**Result in memory:**
```fortran
cs_db%num_pests = 2
cs_db%pests(1) = "atrazine"
cs_db%pests(2) = "metolachlor"
cs_db%num_paths = 1  
cs_db%paths(1) = "e_coli"
cs_db%num_cs = 1
cs_db%cs(1) = "selenium"
```

## Step 2: Soil-Plant Initialization Links

**File: `soil_plant_ini`**
```
Example Soil Plant Initialization
name                sw_frac   nutc        pestc       pathc       saltc   hmetc   csc
agricultural_soil   0.5       nut_ag      pest_ag     path_ag     salt1   hmet1   cs_ag
forest_soil         0.7       nut_for     pest_for    path_for    salt1   hmet1   cs_for
```

**Result in memory:**
```fortran
sol_plt_ini(1)%name = "agricultural_soil"
sol_plt_ini(1)%pestc = "pest_ag"
sol_plt_ini(1)%pathc = "path_ag"  
sol_plt_ini(1)%csc = "cs_ag"

sol_plt_ini(2)%name = "forest_soil"
sol_plt_ini(2)%pestc = "pest_for"
sol_plt_ini(2)%pathc = "path_for"
sol_plt_ini(2)%csc = "cs_for"
```

## Step 3: Pesticide Initial Concentrations

**File: `pest_soil.ini`**
```
Pesticide Initial Concentrations
name
pest_ag
atrazine     5.0    0.1     ! 5 mg/kg soil, 0.1 mg/kg plant
metolachlor  3.0    0.05    ! 3 mg/kg soil, 0.05 mg/kg plant
pest_for  
atrazine     0.5    0.01    ! 0.5 mg/kg soil, 0.01 mg/kg plant
metolachlor  0.0    0.0     ! 0 mg/kg soil, 0 mg/kg plant
```

**Result in memory:**
```fortran
pest_soil_ini(1)%name = "pest_ag"
pest_soil_ini(1)%soil(1) = 5.0      ! atrazine in soil
pest_soil_ini(1)%plt(1) = 0.1       ! atrazine on plants
pest_soil_ini(1)%soil(2) = 3.0      ! metolachlor in soil  
pest_soil_ini(1)%plt(2) = 0.05      ! metolachlor on plants

pest_soil_ini(2)%name = "pest_for"
pest_soil_ini(2)%soil(1) = 0.5      ! atrazine in soil
pest_soil_ini(2)%plt(1) = 0.01      ! atrazine on plants
pest_soil_ini(2)%soil(2) = 0.0      ! metolachlor in soil
pest_soil_ini(2)%plt(2) = 0.0       ! metolachlor on plants
```

## Step 4: Pathogen Initial Concentrations

**File: `path_soil.ini`**
```
Pathogen Initial Concentrations
header
path_ag
dummy_data  1000000  500     ! 1e6 CFU/g soil, 500 CFU/g plant
path_for
dummy_data  100000   50      ! 1e5 CFU/g soil, 50 CFU/g plant
```

**Result in memory:**
```fortran
path_soil_ini(1)%name = "path_ag"
path_soil_ini(1)%soil(1) = 1000000   ! e_coli in soil
path_soil_ini(1)%plt(1) = 500        ! e_coli on plants

path_soil_ini(2)%name = "path_for"  
path_soil_ini(2)%soil(1) = 100000    ! e_coli in soil
path_soil_ini(2)%plt(1) = 50         ! e_coli on plants
```

## Step 5: Other Constituent Initial Concentrations

**File: `cs_hru.ini`**
```
Constituent Initial Concentrations
header1
header2
header3  
header4
cs_ag
10.0                        ! selenium dissolved concentration (g/m³)
0.5                         ! selenium in plants (g/m³)
cs_for
2.0                         ! selenium dissolved concentration (g/m³)
0.1                         ! selenium in plants (g/m³)
```

**Result in memory:**
```fortran
cs_soil_ini(1)%name = "cs_ag"
cs_soil_ini(1)%soil(1) = 10.0        ! selenium dissolved
cs_soil_ini(1)%plt(1) = 0.5          ! selenium in plants

cs_soil_ini(2)%name = "cs_for"
cs_soil_ini(2)%soil(1) = 2.0         ! selenium dissolved  
cs_soil_ini(2)%plt(1) = 0.1          ! selenium in plants
```

## Step 6: HRU Definition and Linkage

**From HRU input files:**
```fortran
! HRU 1 (agricultural field)
hru(1)%dbs%soil_plant_init = 1  ! points to sol_plt_ini(1) = "agricultural_soil"

! HRU 2 (forest area)  
hru(2)%dbs%soil_plant_init = 2  ! points to sol_plt_ini(2) = "forest_soil"
```

**Linkage resolution:**
```fortran
! For HRU 1:
isp_ini = hru(1)%dbs%soil_plant_init = 1
sol_plt_ini(1)%pestc = "pest_ag"     → pest_soil_ini(1) 
sol_plt_ini(1)%pathc = "path_ag"     → path_soil_ini(1)
sol_plt_ini(1)%csc = "cs_ag"         → cs_soil_ini(1)

! For HRU 2:
isp_ini = hru(2)%dbs%soil_plant_init = 2  
sol_plt_ini(2)%pestc = "pest_for"    → pest_soil_ini(2)
sol_plt_ini(2)%pathc = "path_for"    → path_soil_ini(2) 
sol_plt_ini(2)%csc = "cs_for"        → cs_soil_ini(2)
```

## Step 7: HRU Initialization Calculations

### HRU 1 (Agricultural) Properties:
- Area: 10 hectares
- Soil layers: 2
- Layer 1: thickness=20cm, bulk_density=1.3 g/cm³, water_content=25%
- Layer 2: thickness=30cm, bulk_density=1.4 g/cm³, water_content=20%
- Plants: corn (LAI=3.0), weeds (LAI=1.0), total LAI=4.0

### Pesticide Initialization for HRU 1:

**Atrazine in soil:**
```fortran
! Layer 1: 
wt1 = 1.3 * 20 / 100 = 0.26  ! conversion factor
cs_soil(1)%ly(1)%pest(1) = 5.0 * 0.26 = 1.3 kg/ha

! Layer 2:
wt1 = 1.4 * 30 / 100 = 0.42
cs_soil(1)%ly(2)%pest(1) = 5.0 * 0.42 = 2.1 kg/ha
```

**Atrazine on plants:**
```fortran
! Corn (75% of total LAI):
pl_frac = 3.0 / 4.0 = 0.75
cs_pl(1)%pl_on(1)%pest(1) = 0.75 * 0.1 = 0.075 kg/ha

! Weeds (25% of total LAI):  
pl_frac = 1.0 / 4.0 = 0.25
cs_pl(1)%pl_on(2)%pest(1) = 0.25 * 0.1 = 0.025 kg/ha
```

**Metolachlor** follows the same pattern with its initial concentrations.

### Pathogen Initialization for HRU 1:

```fortran
! Only top soil layer gets pathogens:
cs_soil(1)%ly(1)%path(1) = 1000000 CFU/g  ! e_coli
cs_soil(1)%ly(2)%path(1) = 0              ! no pathogens in layer 2

! Plant pathogen balance:
hpath_bal(1)%path(1)%plant = 500 CFU/g
```

### Constituent Initialization for HRU 1:

**Selenium dissolved mass:**
```fortran
! Layer 1:
hru_area_m2 = 10 * 10000 = 100000 m²
water_volume = (0.25 m³/m³) * 100000 m² * 0.2 m = 5000 m³  
cs_soil(1)%ly(1)%cs(1) = (10.0 g/m³ / 1000) * 5000 m³ / 10 ha = 5.0 kg/ha

! Layer 2:  
water_volume = (0.20 m³/m³) * 100000 m² * 0.3 m = 6000 m³
cs_soil(1)%ly(2)%cs(1) = (10.0 g/m³ / 1000) * 6000 m³ / 10 ha = 6.0 kg/ha
```

## Step 8: Final Memory State

After initialization, the memory contains:

```fortran
! HRU 1 (Agricultural):
cs_soil(1)%ly(1)%pest(1) = 1.3     ! atrazine kg/ha
cs_soil(1)%ly(1)%pest(2) = 0.78    ! metolachlor kg/ha  
cs_soil(1)%ly(1)%path(1) = 1000000 ! e_coli CFU/g
cs_soil(1)%ly(1)%cs(1) = 5.0       ! selenium kg/ha

cs_soil(1)%ly(2)%pest(1) = 2.1     ! atrazine kg/ha
cs_soil(1)%ly(2)%pest(2) = 1.26    ! metolachlor kg/ha
cs_soil(1)%ly(2)%path(1) = 0       ! no e_coli
cs_soil(1)%ly(2)%cs(1) = 6.0       ! selenium kg/ha

cs_pl(1)%pl_on(1)%pest(1) = 0.075  ! atrazine on corn kg/ha
cs_pl(1)%pl_on(2)%pest(1) = 0.025  ! atrazine on weeds kg/ha

! HRU 2 (Forest): 
cs_soil(2)%ly(1)%pest(1) = 0.13    ! lower atrazine kg/ha
cs_soil(2)%ly(1)%pest(2) = 0.0     ! no metolachlor kg/ha
cs_soil(2)%ly(1)%path(1) = 100000  ! lower e_coli CFU/g
cs_soil(2)%ly(1)%cs(1) = 1.4       ! lower selenium kg/ha
... (similar pattern for layer 2)
```

## Summary

This example demonstrates how:

1. **Constituent types** are defined globally in the constituent database
2. **Initial concentrations** are defined for different soil-plant scenarios  
3. **HRUs are linked** to appropriate initialization data through the soil_plant_init system
4. **Concentrations are converted** to appropriate mass units using soil physical properties
5. **Plant constituents are distributed** across multiple plant communities based on LAI
6. **Different HRUs** can have completely different initial conditions

The system provides maximum flexibility for representing spatial heterogeneity in constituent concentrations while maintaining computational efficiency through the linkage system.