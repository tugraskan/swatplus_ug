# SWAT+ Access Database Schema Integration Analysis

## Overview

This document analyzes how the **Access_DB_Schema.txt** file relates to both the **modular database spreadsheet** and the **Fortran source code** architecture. The Access database schema serves as the relational database foundation that mirrors the parameter structure defined in the modular spreadsheet and implemented in the source code.

## Three-Layer Architecture

SWAT+ implements a sophisticated three-layer parameter management system:

```
Access Database Schema ↔ Modular Database CSV ↔ Fortran Source Code
     (Structure)              (Mapping)            (Implementation)
```

### Layer 1: Access Database Schema (Structure)
- **File**: `Access_DB_Schema.txt`
- **Purpose**: Defines relational database tables and field types
- **Contains**: 142 database tables with 2,677+ fields
- **Role**: Provides normalized database structure for parameter storage

### Layer 2: Modular Database CSV (Mapping)
- **File**: `Modular Database_5_15_24_nbs.csv` 
- **Purpose**: Maps between database schema, input files, and source code
- **Contains**: 3,330 parameter definitions with full metadata
- **Role**: Central registry linking all representations

### Layer 3: Fortran Source Code (Implementation)
- **Files**: 645+ `.f90` source files
- **Purpose**: Implements the model calculations using parameters
- **Contains**: Data structures, file readers, and computational routines
- **Role**: Executes the watershed modeling algorithms

## Detailed Integration Example: Plant Parameters

### 1. Access Database Schema Definition

From `Access_DB_Schema.txt` (lines 572-629):

```
Table: plant_db
----------------------------------------------------
name (String, Nullable)
plnt_code (String, Nullable)  
description_db (String, Nullable)
plnt_typ (String, Nullable)
trig (String, Nullable)
nfix_co (Double, Nullable)
days_mat (Double, Nullable)
bm_e (Double, Nullable)          ← biomass-energy ratio
harv_idx (Double, Nullable)      ← harvest index
lai_pot (Double, Nullable)       ← potential leaf area index
...
```

The `plant_db` table defines the structure for storing plant parameters in the Access database.

### 2. Modular Database CSV Mapping

From `Modular Database_5_15_24_nbs.csv` (line 98):

```csv
ID: 194
Classification: SIMULATION
SWAT_File: file.cio
Database_Table: file_cio
Field_Name: plant_db
Position: 2
Line: 19  
Description: Plant parameters
Default: plants.plt
```

This entry maps the database reference to the actual input file.

### 3. Source Code Implementation

#### A. File Structure Definition (`input_file_module.f90`)

```fortran
type input_parameter_databases
  character(len=25) :: plants_plt = "plants.plt"
  character(len=25) :: fert_frt = "fertilizer.frt"
  character(len=25) :: till_til = "tillage.til"
  ...
end type input_parameter_databases
type (input_parameter_databases) :: in_parmdb
```

#### B. Data Structure Definition (`plant_data_module.f90`)

```fortran
type plant_db
  character(len=40) :: plantnm = ""    ! crop name
  character(len=18) :: typ = ""        ! plant category
  real :: bio_e = 15.0                 ! biomass-energy ratio (kg/ha/(MJ/m**2))
  real :: hvsti = 0.76                 ! harvest index (kg/ha)/(kg/ha)
  real :: blai = 5.0                   ! max potential leaf area index
  ...
end type plant_db
```

#### C. File Reading Implementation (`plant_parm_read.f90`)

```fortran
subroutine plant_parm_read
  inquire (file=in_parmdb%plants_plt, exist=i_exist)
  if (.not. i_exist .or. in_parmdb%plants_plt == " null") then
    allocate (pldb(0:0))
  else
    open (104,file=in_parmdb%plants_plt)
    read (104,*,iostat=eof) titldum     ! title
    read (104,*,iostat=eof) header      ! headers
    do ic = 1, imax
      read (104,*,iostat=eof) pldb(ic)  ! plant parameters
    end do
  endif
end subroutine plant_parm_read
```

#### D. Master Configuration Reader (`readcio_read.f90`)

```fortran
subroutine readcio_read 
  open (107,file="file.cio")
  read (107,*) titldum
  do i = 1, 31
    read (107,*,iostat=eof) name, in_sim     ! line 2
    read (107,*,iostat=eof) name, in_basin   ! line 3
    ...
    read (107,*,iostat=eof) name, in_parmdb  ! line 19 (plants.plt)
    ...
  enddo
end subroutine readcio_read
```

## Complete Parameter Flow

### 1. Database Schema → Input Files
```
Access Table: plant_db
├── Field: bm_e (Double)
└── Maps to Input File: plants.plt
    └── Column Header: bm_e
        └── Data Values: 20.00000, 15.50000, etc.
```

### 2. Input Files → Source Code
```
plants.plt → in_parmdb%plants_plt → pldb(ic)%bio_e
```

### 3. Source Code → Model Calculations
```fortran
! In growth calculations:
bio_mass = potential_biomass * pldb(plant_id)%bio_e * radiation_use_efficiency
```

## Key Integration Points

### 1. Naming Consistency
- **Database Field**: `bm_e` (biomass-energy ratio)
- **CSV Description**: "biomass-energy ratio"  
- **Fortran Variable**: `bio_e`
- **Input File Header**: `bm_e`

### 2. Data Type Mapping
- **Access Schema**: `Double, Nullable`
- **CSV Metadata**: Units, ranges, defaults
- **Fortran Declaration**: `real :: bio_e = 15.0`

### 3. File Organization
- **Database Table**: Groups related parameters
- **Input File**: Contains all plant species data
- **Source Module**: Defines data structures and readers

## Database Tables and Source Code Modules

| Access Table | Input File | Source Module | Purpose |
|--------------|------------|---------------|---------|
| `file_cio` | `file.cio` | `input_file_module.f90` | Master configuration |
| `plant_db` | `plants.plt` | `plant_data_module.f90` | Plant parameters |
| `hru_dat` | `hru-data.hru` | `hru_module.f90` | HRU characteristics |
| `cha_dat` | `channel.cha` | `channel_module.f90` | Channel properties |
| `res_dat` | `reservoir.res` | `reservoir_module.f90` | Reservoir parameters |
| `soils_db` | `soils.sol` | `soil_module.f90` | Soil properties |

## Benefits of Three-Layer Architecture

### 1. **Modularity**
- Each layer serves a specific purpose
- Changes in one layer don't break others
- Easy to maintain and extend

### 2. **Validation**
- Database schema enforces data types
- CSV provides ranges and units
- Source code implements bounds checking

### 3. **Documentation**
- Schema documents structure
- CSV provides parameter descriptions
- Source code contains implementation details

### 4. **Flexibility**
- Database can be queried relationally
- CSV enables parameter analysis
- Source code allows algorithmic access

## Validation and Quality Assurance

### 1. **Schema Validation**
```sql
-- Access database enforces:
CHECK (bm_e >= 0 AND bm_e <= 100)  -- Example constraint
```

### 2. **CSV Validation**
```csv
Minimum_Range: 0.01
Maximum_Range: 100.0
Units: (kg/ha)/(MJ/m**2)
```

### 3. **Source Code Validation**
```fortran
if (pldb(ic)%bio_e < 0.01 .or. pldb(ic)%bio_e > 100.0) then
  write(*,*) "Invalid biomass-energy ratio:", pldb(ic)%bio_e
  stop
endif
```

## Development Workflow

### 1. **Adding New Parameters**
1. Update Access database schema with new table/field
2. Add entry to modular database CSV with mapping
3. Update Fortran data structures and readers
4. Implement parameter usage in calculations

### 2. **Modifying Existing Parameters**
1. Update field constraints in Access schema
2. Modify ranges/units in CSV documentation  
3. Update default values in source code
4. Test parameter validation

### 3. **Database Migration**
1. Schema changes flow to CSV updates
2. CSV changes guide source code modifications
3. Source code changes validate against schema

## Conclusion

The Access database schema, modular database CSV, and Fortran source code form an integrated parameter management ecosystem. This three-layer architecture provides:

- **Structural integrity** through database normalization
- **Comprehensive documentation** through CSV metadata  
- **Computational efficiency** through optimized source code

Understanding these relationships is essential for SWAT+ model development, parameter management, and system maintenance. The schema serves as the blueprint, the CSV as the translation layer, and the source code as the implementation engine of the complete watershed modeling system.