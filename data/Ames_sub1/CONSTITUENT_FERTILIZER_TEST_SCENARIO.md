# Constituent Fertilizer Test Scenario

This document describes the comprehensive test scenario implemented for validating the fertilizer constituent functionality in SWAT+.

## Test Fertilizers

Three fertilizers have been configured in `fertilizer_ext.frt` to test different constituent application scenarios:

### 1. **urea** - Synthetic Fertilizer with Pest + CS
- **NPK Content**: 46% N, 0% P, 0% K  
- **Pest Table**: `test_pest_mix1` (roundup, aatrex, dual)
- **Path Table**: `low_pathogen` (ecoli, salmonella at low levels)
- **CS Table**: `test_cs_mix1` (seo4, seo3, boron)
- **OM Name**: `null` (synthetic fertilizer, no manure crosswalk)

### 2. **beef_fr** - Manure Fertilizer with Pest + Path + CS  
- **NPK Content**: 1% N, 0.4% P, 3% org_N, 0.7% org_P
- **Pest Table**: `test_pest_mix1` (roundup, aatrex, dual)
- **Path Table**: `fresh_manure` (high ecoli, salmonella levels)
- **CS Table**: `test_cs_mix2` (higher seo4, seo3, boron concentrations)
- **OM Name**: `beef_fresh` (crosswalks to manure organic matter data)

### 3. **trkey_fr** - Poultry Manure with Pest + Path + CS
- **NPK Content**: 0.7% N, 0.3% P, 4.5% org_N, 1.6% org_P  
- **Pest Table**: `test_pest_mix2` (higher roundup, aatrex, dual levels)
- **Path Table**: `fresh_manure` (high ecoli, salmonella levels)
- **CS Table**: `test_cs_mix2` (higher seo4, seo3, boron concentrations)
- **OM Name**: `turkey_fresh` (crosswalks to poultry manure organic matter data)

## Management Schedule Integration

The first management unit (`mgt_01`) has been modified to use these test fertilizers:

- **Line 8**: `urea` application on June 1st (181.4 kg/ha) - Tests pest + pathogen + cs application for synthetic fertilizer
- **Line 10**: `beef_fr` application on October 9th (142.7 kg/ha) - Tests pest + pathogen + cs application for beef manure  
- **Line 18**: `trkey_fr` application on November 14th (336.0 kg/ha) - Tests pest + pathogen + cs application for poultry manure

## Testing Framework

This scenario tests the complete constituent application pathway:

1. **Constituent Database Reading**: `constituents_man.cs` defines available constituents
2. **Linkage Table Reading**: `pest.man`, `path.man`, `cs.man` define fertilizer-constituent concentrations
3. **Manure OM Crosswalking**: `manure_om.man` provides organic matter data for manure fertilizers
4. **Early Crosswalking**: Fertilizer-constituent linkages are pre-computed during initialization
5. **Application**: `fert_constituents_apply()` distributes pesticides, pathogens, and generic constituents

## Expected Outcomes

- **urea**: Should apply pesticides (roundup, aatrex, dual), low pathogens (ecoli, salmonella), and constituents (seo4, seo3, boron) without manure organic matter effects
- **beef_fr**: Should apply pesticides, high pathogen loads, constituents, plus beef manure organic matter (nutrients and carbon) with solid manure unit conversions (500 ppm factor)
- **trkey_fr**: Should apply higher pesticide levels, high pathogen loads, constituents, plus poultry manure organic matter with solid manure unit conversions

## Validation

Use output files and simulation diagnostics to verify that:
1. All three fertilizers are applied on their scheduled dates
2. Constituent loads are properly distributed to soil/water systems
3. Manure organic matter is correctly applied with unit conversions
4. No crosswalking errors occur during simulation