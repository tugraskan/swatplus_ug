# SWAT+ Fertilizer Constituent Testing Summary

## Test Files Created for Ames Dataset

This document summarizes the test files created to validate the new SWAT+ fertilizer constituent functionality for cs (constituents), pest (pesticides), and apsth (pathogens).

### ✅ Files Successfully Created

1. **`fertilizer.frt_cs`** - Direct constituent concentrations for all 59 fertilizers
   - Contains seo4, seo3, boron loads (kg/ha) 
   - Used by cs_fert.f90 when fert_cs_flag = 1

2. **`pest.man`** - Pesticide-fertilizer linkage table
   - 3 test mixtures: test_pest_mix1, test_pest_mix2, low_pest
   - Links fertilizers to roundup, aatrex, dual pesticides

3. **`path.man`** - Pathogen-fertilizer linkage table  
   - 3 pathogen sources: fresh_manure, ceap_manure, low_pathogen
   - Links fertilizers to E. coli and Salmonella loads

4. **`cs.man`** - Generic constituent-fertilizer linkage table
   - 3 constituent mixtures: test_cs_mix1, test_cs_mix2, low_cs
   - Links fertilizers to seo4, seo3, boron loads

5. **`fertilizer_ext.frt.backup`** - Extended fertilizer format (backup)
   - Supports full constituent integration via linkage tables
   - Links specific fertilizers to pest, path, and cs tables

6. **`cs_hru.ini`** - HRU constituent initialization
   - 3 concentration levels: low_cs, med_cs, high_cs
   - Initial soil and plant constituent concentrations

7. **`cs_aqu.ini`** - Aquifer constituent initialization
   - Initial constituent concentrations in groundwater

8. **`cs_channel.ini`** - Channel constituent initialization  
   - Initial constituent concentrations in surface water

9. **`constituents.cs`** - Constituent database file
   - Defines which constituents are available for simulation
   - Contains 3 pesticides: roundup, aatrex, dual
   - Contains 2 pathogens: ecoli, salmonella
   - Contains 3 constituents: seo4, seo3, boron
   - **Required** for constituent system to function

### 🔧 Integration Points

The test files integrate with SWAT+ at these code points:

- **cs_fert.f90** - Applies constituent loads from fertilizers to soil
- **cs_fert_wet.f90** - Applies constituent loads to wetlands
- **fert_constituents.f90** - Integrates pest, path, cs with fertilizers
- **pest_apply.f90** - Distributes pesticide loads 
- **path_apply.f90** - Distributes pathogen loads
- **cs_apply.f90** - Distributes generic constituent loads

### 🧪 Testing Scenarios

#### Scenario 1: Direct Constituent Application
- Use `fertilizer.frt_cs` for direct constituent loads
- Tests cs_fert.f90 functionality
- Verifies soil layer distribution

#### Scenario 2: Linked Constituent Application  
- Use `fertilizer_ext.frt` + constituent tables
- Tests fert_constituents.f90 integration
- Verifies pest/path/cs linkage system

#### Scenario 3: Mixed Application Testing
- Apply fertilizers with multiple constituent types
- Tests surface vs subsurface distribution
- Verifies mass balance tracking

### 📊 Expected Results

When working correctly, the system should:

1. **Load constituent data** during initialization
2. **Apply constituent loads** during fertilizer operations
3. **Distribute loads** between soil layers based on surf_frac
4. **Track mass balance** in constituent balance arrays
5. **Generate output** showing constituent transfers

### 🚀 Usage Instructions

1. **Validation**: Run `validate_constituent_tests.py` to verify files
2. **Enable constituents**: Ensure cs_db%num_cs > 0 in simulation
3. **Run SWAT+**: Execute with constituent system enabled
4. **Check outputs**: Look for constituent balance tracking

### 📝 Implementation Notes

- **Constituent system**: Supports 3 constituents (seo4, seo3, boron)
- **Application method**: Uses surf_frac for soil layer distribution  
- **Mass balance**: Tracked in hcsb_d, hpestb_d, hpath_bal arrays
- **Integration**: Automatic when fertilizer.frt_cs or fertilizer_ext.frt present

### 🔍 Debugging Tips

If issues arise:

1. Check fert_cs_flag = 1 for direct constituent loads
2. Verify cs_db%num_cs > 0 for constituent system
3. Ensure file formats match expected structure
4. Review fertilizer name consistency between files
5. Check constituent initialization values

### 📚 Documentation

- `README_CONSTITUENT_TESTING.md` - Detailed technical documentation
- Source code comments in cs_*.f90 modules  
- SWAT+ user manual constituent sections

### ✨ Summary

These test files provide a comprehensive testing framework for the new SWAT+ fertilizer constituent functionality. They demonstrate integration of constituents (cs), pesticides (pest), and pathogens (apsth) with the fertilizer application system, enabling validation of:

- Direct constituent fertilizer loads
- Linked constituent table system
- Mass balance tracking
- Multi-constituent applications
- Soil/plant/water distribution

The validation script confirms all files are properly formatted and ready for testing the enhanced SWAT+ constituent capabilities.