# SWAT+ Fertilizer Constituent Testing Files

## Overview

This directory contains test files for validating the new fertilizer constituent functionality in SWAT+. The constituent system allows fertilizers to carry loads of various constituents including:

- **cs (Constituents)**: seo4, seo3, boron (selenium compounds and boron)  
- **pest (Pesticides)**: Various pesticide compounds
- **path (Pathogens)**: Pathogenic organisms like E. coli and Salmonella

## Test Files Created

### 1. Constituent Fertilizer Files

#### `fertilizer.frt_cs`
- Direct constituent loads for standard fertilizer types
- Contains seo4, seo3, and boron concentrations (kg/ha) for each fertilizer
- Format: name, seo4, seo3, boron
- Used by `cs_fert.f90` when `fert_cs_flag = 1`

#### `fertilizer_ext.frt.backup` 
- Extended fertilizer format supporting full constituent linkage
- Links fertilizers to external constituent tables (pest.man, path.man, cs.man)
- Format includes additional fields: manure_name, csv_name, pest_table, path_table, salt_table, hmet_table, cs_table
- Used when present, automatically detected by `fert_parm_read.f90`

### 2. Constituent Management Tables

#### `pest.man`
- Pesticide concentrations in fertilizers
- Defines pesticide mixtures (test_pest_mix1, test_pest_mix2, low_pest)
- Contains concentrations for roundup, aatrex, dual pesticides
- Referenced from fertilizer_ext.frt via pest_table field

#### `path.man`
- Pathogen concentrations in fertilizers
- Defines pathogen loads (fresh_manure, ceap_manure, low_pathogen)
- Contains concentrations for E. coli and Salmonella
- Referenced from fertilizer_ext.frt via path_table field

#### `cs.man`
- Generic constituent concentrations in fertilizers  
- Defines constituent mixtures (test_cs_mix1, test_cs_mix2, low_cs)
- Contains concentrations for seo4, seo3, boron
- Referenced from fertilizer_ext.frt via cs_table field

### 3. Constituent Database File

#### `constituents.cs`
- Master database file defining which constituents are available for simulation
- Read by `constit_db_read.f90` to populate the global `cs_db` structure
- Format: title, num_pests, pest_names, num_paths, path_names, num_metals, metal_names, num_salts, salt_names, num_cs, cs_names
- **Critical**: This file must be present and define all constituents referenced in *.man tables

### 4. Constituent Initialization Files

#### `cs_hru.ini`
- Initial constituent concentrations in HRU soils and plants
- Defines three concentration levels: low_cs, med_cs, high_cs
- Format: name, soil_concentrations(3), plant_concentrations(3)

#### `cs_aqu.ini` 
- Initial constituent concentrations in aquifers
- Single aquifer definition: cs_aqu_01
- Format: name, concentrations(3)

#### `cs_channel.ini`
- Initial constituent concentrations in channels
- Single channel definition: cs_ch_01  
- Format: name, concentrations(3)

## Integration Points

### Code Integration
The constituent fertilizer system integrates at several points:

1. **`actions.f90`**: Calls `cs_fert()` during fertilizer application
2. **`cs_fert.f90`**: Applies constituent loads to soil layers
3. **`cs_fert_wet.f90`**: Applies constituent loads to wetlands
4. **`fert_constituents.f90`**: Integrates pest, path, and cs loads with fertilizers
5. **`pest_apply.f90`**: Applies pesticide loads
6. **`path_apply.f90`**: Applies pathogen loads
7. **`cs_apply.f90`**: Applies generic constituent loads

### Data Flow
1. Fertilizer application triggers in management operations
2. `fert_constituents_apply()` checks for linked constituent tables
3. For each constituent type, appropriate `*_apply()` function is called
4. Loads are distributed between soil layers and plant canopy based on application method
5. Mass balance tracking occurs in `hcsb_d`, `hpestb_d`, `hpath_bal` arrays

## Testing the Functionality

### Prerequisites
- SWAT+ executable built with constituent support
- Constituent system enabled in simulation

### Test Scenarios

#### Scenario 1: Basic Constituent Fertilizer Application
- Use `fertilizer.frt_cs` to test direct constituent loads
- Apply fertilizers with constituent concentrations
- Verify loads appear in soil profile via `cs_fert.f90`

#### Scenario 2: Integrated Constituent Fertilizer System  
- Use `fertilizer_ext.frt` to test linked constituent tables
- Apply fertilizers that reference pest.man, path.man, cs.man
- Verify loads are distributed via `fert_constituents.f90`

#### Scenario 3: Mixed Application Testing
- Test fertilizers with combined cs, pest, and pathogen loads
- Verify proper partitioning between soil layers and plant canopy
- Check mass balance tracking in output files

### Expected Outputs

When constituent system is working correctly, you should see:
- Constituent balance files (if enabled in print options)
- Mass transfer tracking in balance arrays
- Proper distribution between soil layers based on `surf_frac` parameter
- Updated constituent concentrations in soil, plant, and water bodies

### Debugging

If the system doesn't work as expected:

1. **Check constituent flags**: Ensure `fert_cs_flag = 1` and `cs_db%num_cs > 0`
2. **Verify file formats**: Ensure constituent files match expected formats
3. **Check fertilizer linkages**: Verify fertilizer names match between files  
4. **Review initialization**: Ensure constituent pools are properly initialized
5. **Enable debug output**: Add diagnostic prints to track constituent flows

## File Relationships

```
fertilizer.frt_cs           -> cs_fert.f90 (direct loads)
fertilizer_ext.frt         -> fert_parm_read.f90 -> manure_db
manure_db.pest            -> pest.man -> pest_apply.f90  
manure_db.path            -> path.man -> path_apply.f90
manure_db.cs              -> cs.man -> cs_apply.f90
cs_hru.ini                -> cs_hru_read.f90 -> cs_soil_ini
cs_aqu.ini                -> cs_aqu_read.f90  
cs_channel.ini            -> cs_cha_read.f90
```

## Notes

- The constituent system requires SWAT+ to be compiled with constituent support
- Test values provided are for demonstration purposes and may not represent realistic concentrations
- The system supports up to 3 constituents by default (seo4, seo3, boron)
- Pathogen and pesticide systems can be extended for additional compounds
- Mass balance tracking provides verification of constituent conservation

For more details on the constituent system implementation, see the SWAT+ documentation and source code comments in the cs_* modules.