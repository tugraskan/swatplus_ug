# SWAT+ Manure Constituent System: Initialization, Loading, and Application

## Overview

The SWAT+ manure constituent system provides comprehensive tracking and application of pesticides, pathogens, heavy metals, salts, and other constituents associated with fertilizer and manure applications. The system integrates seamlessly with the existing SWAT+ fertilizer application framework while providing sophisticated environmental fate modeling and layered soil distribution.

## System Architecture

### 1. Database Structure

The system uses a three-tier database structure:

#### Tier 1: Fertilizer Database (`fertilizer_ext.frt`)
- Primary fertilizer properties (NPK content, etc.)
- Constituent linkage names for crosswalking
- Organic matter linkage via `om_name` field

#### Tier 2: Constituent Concentration Files (`*.man`)
- `pest.man` - Pesticide concentrations by fertilizer type
- `path.man` - Pathogen concentrations by fertilizer type  
- `hmet.man` - Heavy metal concentrations by fertilizer type
- `salt.man` - Salt concentrations by fertilizer type
- `cs.man` - Other constituent concentrations by fertilizer type

#### Tier 3: Constituent Database (`constituents_man.cs`)
- Master list of all constituents to be simulated
- Links constituent names to parameter databases
- Enables/disables constituent types

### 2. Key Data Structures

#### `manure_db` (fertilizer_data_module.f90)
```fortran
type manure_database
    type(fertilizer_db) :: base           ! Base NPK properties
    character(len=16) :: name             ! Fertilizer name
    character(len=25) :: om_name          ! Organic matter linkage
    character(len=16) :: pest, path, salt, hmet, cs  ! Constituent names
    integer :: pest_idx, path_idx, salt_idx, hmet_idx, cs_idx  ! Pre-computed indices
end type manure_database
```

#### Constituent Arrays (constituent_mass_module.f90)
```fortran
type(cs_fert_init_concentrations), allocatable :: pest_fert_ini(:)
type(cs_fert_init_concentrations), allocatable :: path_fert_ini(:)
type(cs_fert_init_concentrations), allocatable :: hmet_fert_ini(:)
type(cs_fert_init_concentrations), allocatable :: salt_fert_ini(:)
type(cs_fert_init_concentrations), allocatable :: cs_fert_ini(:)
```

## Initialization and Loading Process

### Phase 1: Database Initialization (`proc_db.f90`)

```fortran
call fert_parm_read()        ! Load fertilizer_ext.frt
call manure_parm_read()      ! Load manure_om.man  
call constit_man_db_read()   ! Load constituents_man.cs and all *.man files
```

### Phase 2: Constituent Database Loading (`constit_man_db_read.f90`)

1. **Read Master Constituent List**:
   ```fortran
   ! Read constituents_man.cs
   read(106,*) cs_man_db%num_pests
   read(106,*) (cs_man_db%pests(i), i = 1, cs_man_db%num_pests)
   read(106,*) cs_man_db%num_paths  
   read(106,*) (cs_man_db%paths(i), i = 1, cs_man_db%num_paths)
   ! Continue for metals, salts, cs...
   ```

2. **Load Constituent Concentration Files**:
   ```fortran
   if (cs_man_db%num_pests > 0) then
       call fert_constituent_file_read("pest.man", cs_man_db%num_pests)
       call MOVE_ALLOC(fert_arr, pest_fert_ini)
   end if
   ```

3. **Crosswalk Fertilizer Names** (`fert_constituent_crosswalk`):
   ```fortran
   do ifrt = 1, size(manure_db)
       if (manure_db(ifrt)%pest /= '') then
           do i = 1, size(pest_fert_ini)
               if (trim(manure_db(ifrt)%pest) == trim(pest_fert_ini(i)%name)) then
                   manure_db(ifrt)%pest_idx = i  ! Pre-compute index
                   exit
               end if
           end do
       end if
   end do
   ```

### Phase 3: Runtime Optimization

Pre-computed indices eliminate string matching during fertilizer applications:
- `manure_db(ifrt)%pest_idx` → Direct access to `pest_fert_ini(idx)`
- `manure_db(ifrt)%path_idx` → Direct access to `path_fert_ini(idx)`
- etc.

## Application Process

### Entry Point: `pl_fert.f90`

After applying NPK nutrients, the system applies associated constituents:

```fortran
subroutine pl_fert(ifrt, frt_kg, fertop)
    ! ... Apply NPK nutrients first ...
    
    ! Apply constituents associated with this fertilizer
    if (ifrt > 0) then
        call fert_constituents_apply(j, ifrt, frt_kg, fertop)
    end if
end subroutine
```

### Main Application Engine: `fert_constituents_apply`

```fortran
subroutine fert_constituents_apply(j, ifrt, frt_kg, fertop)
    ! Input validation
    if (j <= 0 .or. j > nhru) return
    if (ifrt <= 0 .or. ifrt > size(manure_db)) return
    if (frt_kg <= 0.0) return

    ! Apply constituent types if enabled and configured
    if (cs_man_db%num_pests > 0) call apply_pesticide_constituents(j, ifrt, frt_kg, fertop)
    if (cs_man_db%num_paths > 0) call apply_pathogen_constituents(j, ifrt, frt_kg, fertop)
    if (cs_man_db%num_salts > 0) call apply_salt_constituents(j, ifrt, frt_kg, fertop)
    if (cs_man_db%num_metals > 0) call apply_heavy_metal_constituents(j, ifrt, frt_kg, fertop)
    if (cs_man_db%num_cs > 0) call apply_other_constituents(j, ifrt, frt_kg, fertop)
end subroutine
```

### Constituent-Specific Application

Each constituent type has specialized application logic:

#### Pesticides (`apply_pesticide_constituents`)
- **Distribution**: 70-95% surface application based on `fertop`
- **Environmental Factors**: Temperature, moisture, and pH effectiveness
- **Soil Layers**: Applied to top 3 soil layers with realistic distribution
- **Calculation**:
  ```fortran
  pest_loading_kg_ha = frt_kg * pest_fert_ini(manure_db(ifrt)%pest_idx)%ppm(ipest)
  call calculate_pesticide_environmental_factors(j, temp_factor, moisture_factor, ph_factor)
  env_factor = temp_factor * moisture_factor * ph_factor
  pest_mass_layer = pest_loading_kg_ha * surface_fraction * env_factor
  ```

#### Pathogens (`apply_pathogen_constituents`)
- **Distribution**: 80-95% surface preference for survival
- **Environmental Factors**: Temperature and moisture-based survival calculations
- **Soil Layers**: Mainly top 2 layers (pathogens don't survive deep)
- **Survival Factors**: Lower survival in hot/dry conditions

#### Salts (`apply_salt_constituents`)
- **Distribution**: Exponential distribution through 5 soil layers
- **Mobility**: High leaching potential based on soil permeability
- **Calculation**:
  ```fortran
  distribution_fraction = exp(-0.4 * real(soil_layer - 1)) * leaching_factor
  ```

#### Heavy Metals (`apply_heavy_metal_constituents`)
- **Distribution**: 80-90% surface binding with organic matter
- **Sorption**: pH and clay content affect binding
- **Soil Layers**: Limited mobility, mainly top 3 layers

#### Generic Constituents (`apply_other_constituents`)
- **Distribution**: Configurable using `chemapp_db(fertop)%surf_frac`
- **Soil Layers**: Applied to top 4 layers with decreasing concentration

## Role of `fertilizer_ext.frt` (fert_ext)

### Purpose and Structure

The `fertilizer_ext.frt` file serves as the central linkage hub between fertilizer applications and constituent concentrations. It extends the basic fertilizer database with constituent information.

### Key Fields

1. **Base Fertilizer Properties**:
   - `name` - Fertilizer identifier used in management operations
   - `fminn`, `fminp`, `forgn`, `forgp` - NPK content
   - `fnh3n` - Ammonia fraction

2. **Constituent Linkage Names**:
   - `pest` - References name in `pest.man`
   - `path` - References name in `path.man`
   - `salt` - References name in `salt.man`
   - `hmet` - References name in `hmet.man`  
   - `cs` - References name in `cs.man`

3. **Organic Matter Linkage**:
   - `om_name` - References name in `manure_om.man`

### Linkage Process

1. **Management File Reference**:
   ```
   # In management (.mgt) file:
   fert    apply_fert    corn_fert_program    150    1
   ```

2. **fertilizer_ext.frt Lookup**:
   ```
   name                pest        path        salt    hmet    cs      om_name
   corn_fert_program   corn_pest   dairy_path  std_salt high_met generic_cs  dairy_manure
   ```

3. **Constituent Concentration Lookup**:
   ```
   # pest.man file:
   corn_pest
   atrazine     2.5
   glyphosate   1.8
   
   # path.man file:  
   dairy_path
   e_coli       150
   salmonella   75
   ```

4. **Application Calculation**:
   ```fortran
   ! For 150 kg/ha of corn_fert_program:
   atrazine_loading = 150 * 2.5 = 375 kg/ha  
   e_coli_loading = 150 * 150 = 22,500 CFU/ha
   ```

### Flexibility and Configuration

- **Optional Constituents**: Any constituent field can be blank ("") to skip that type
- **Shared Concentration Tables**: Multiple fertilizers can reference the same constituent concentration profile
- **Type-Specific Parameters**: Each constituent type gets specialized environmental and distribution modeling

## Environmental Factor Integration

### Temperature Effects
```fortran
if (soil_temp < 10.0) then
    temp_factor = 1.0      ! Stable in cold
else if (soil_temp < 30.0) then
    temp_factor = 0.7      ! Moderate degradation  
else
    temp_factor = 0.4      ! Rapid degradation in heat
endif
```

### Moisture Effects
```fortran
if (soil_moisture < 0.2) then
    moisture_factor = 0.6   ! Limited effectiveness when dry
else if (soil_moisture < 0.8) then
    moisture_factor = 1.0   ! Optimal moisture range
else
    moisture_factor = 0.8   ! Some leaching when very wet
endif
```

### pH Effects
```fortran
if (soil_ph < 5.5) then
    ph_factor = 0.7        ! Reduced effectiveness in very acidic soils
else if (soil_ph < 8.0) then
    ph_factor = 1.0        ! Optimal pH range
else
    ph_factor = 0.8        ! Reduced effectiveness in alkaline soils
endif
```

## Performance Optimizations

### 1. Pre-computed Indices
- Crosswalking done once during initialization
- Direct array access during applications eliminates string matching

### 2. Conditional Processing
- Only enabled constituent types are processed
- Early returns for missing data

### 3. Layered Application Logic
- Realistic soil distribution without complex transport modeling
- Computationally efficient environmental factor calculations

## Integration with Existing SWAT+ Infrastructure

### Balance Tracking (Ready for Implementation)
```fortran
! Daily balance updates (structure prepared):
! hcsb_d(j)%cs(ipest)%fert = hcsb_d(j)%cs(ipest)%fert + pest_mass_layer

! Annual balance updates (structure prepared):
! hcsb_a(j)%cs(ipest)%fert = hcsb_a(j)%cs(ipest)%fert + pest_mass_layer
```

### Output Integration
- Compatible with existing output modules
- Layer-specific tracking available for detailed analysis

### Management Integration  
- Uses existing management file format
- Compatible with all fertilizer application types (`fertop`)
- Works with existing scheduling and rotation systems

## Error Handling and Validation

### Input Validation
```fortran
! HRU bounds checking
if (j <= 0 .or. j > nhru) return

! Fertilizer database bounds checking  
if (ifrt <= 0 .or. ifrt > size(manure_db)) return

! Application rate validation
if (frt_kg <= 0.0) return
```

### Missing Data Handling
```fortran
! Graceful handling of missing constituent arrays
if (.not. allocated(pest_fert_ini)) return

! Skip fertilizers without constituent links
if (manure_db(ifrt)%pest_idx <= 0) return
```

### File Existence Checking
```fortran
inquire(file=constituent_name, exist=i_exist)
if (i_exist) then
    ! Process file
else
    ! Allocate empty arrays
    allocate(cs_man_db%pests(0:0))
end if
```

## Summary

The SWAT+ manure constituent system provides a comprehensive, scientifically-based approach to modeling constituent fate and transport in agricultural systems. The three-tier database structure allows for flexible configuration while maintaining optimal performance through pre-computed indices and efficient data structures. The system integrates seamlessly with existing SWAT+ infrastructure while providing the sophisticated environmental modeling needed for accurate constituent simulation.