# SWAT+ Constituent Initialization Documentation

This directory contains comprehensive documentation on how constituents (CS), pesticides (PEST), and pathogens (PATH) are read from input files and initialized into Hydrologic Response Units (HRUs) in the SWAT+ model.

## Documentation Files

### 1. [Constituent Initialization Process](constituent_initialization_process.md)
**Main technical documentation** - Detailed explanation of the entire initialization process including:
- Phase 1: Reading input files (`proc_read.f90`)
- Phase 2: HRU initialization (`proc_hru.f90`)  
- Data structures and memory layout
- File dependencies and linkage systems
- Calculation methods for concentration-to-mass conversions

### 2. [Constituent Initialization Flowchart](constituent_initialization_flowchart.md)
**Visual process flow** - Graphical representation of the initialization process including:
- Overall process flow diagram
- Data flow from input files to memory structures
- HRU linkage system visualization
- Memory layout for multiple constituents
- Concentration to mass conversion process

### 3. [Constituent Initialization Example](constituent_initialization_example.md)
**Practical walkthrough** - Concrete example tracing the initialization of:
- 2 pesticides (atrazine, metolachlor)
- 1 pathogen (e_coli)
- 1 other constituent (selenium)
- Across 2 different HRUs with complete calculations

## Quick Reference

### Key Source Files
- `src/constit_db_read.f90` - Reads constituent database
- `src/soil_plant_init.f90` - Links HRUs to initialization data
- `src/pest_hru_aqu_read.f90` - Reads pesticide concentrations
- `src/path_hru_aqu_read.f90` - Reads pathogen concentrations  
- `src/cs_hru_read.f90` - Reads other constituent concentrations
- `src/pesticide_init.f90` - Initializes pesticides in HRUs
- `src/pathogen_init.f90` - Initializes pathogens in HRUs
- `src/cs_hru_init.f90` - Initializes other constituents in HRUs

### Key Input Files
- `constituents.cs` - Defines which constituents to simulate
- `soil_plant_ini` - Links HRUs to initialization data sets
- `pest_soil.ini` - Pesticide initial concentrations
- `path_soil.ini` - Pathogen initial concentrations
- `cs_hru.ini` - Other constituent initial concentrations

### Key Data Structures
- `cs_db` - Global constituent database
- `sol_plt_ini()` - Soil-plant initialization linkage
- `pest_soil_ini()` - Pesticide concentration arrays
- `path_soil_ini()` - Pathogen concentration arrays  
- `cs_soil_ini()` - Other constituent concentration arrays
- `cs_soil()` - HRU soil constituent storage
- `cs_pl()` - HRU plant constituent storage

## Process Summary

1. **Database Definition**: `constituents.cs` defines which constituents to simulate globally
2. **Concentration Definition**: Separate files define initial concentrations for different scenarios
3. **HRU Linkage**: `soil_plant_ini` links each HRU to appropriate initialization data
4. **Reading Phase**: `proc_read` loads all input data into memory structures
5. **Initialization Phase**: `proc_hru` populates HRU arrays with constituent data
6. **Mass Conversion**: Concentrations are converted to mass units using soil properties
7. **Plant Distribution**: Plant constituents are distributed across multiple plant communities

## Usage

To understand the constituent initialization process:

1. **Start with**: [Constituent Initialization Process](constituent_initialization_process.md) for the complete technical overview
2. **Visualize with**: [Constituent Initialization Flowchart](constituent_initialization_flowchart.md) for graphical understanding  
3. **Learn by example**: [Constituent Initialization Example](constituent_initialization_example.md) for practical application

The documentation is designed to be read sequentially for complete understanding, or individually for specific topics.

## Target Audience

- SWAT+ model developers and contributors
- Researchers implementing constituent transport modeling
- Users setting up constituent simulations
- Anyone debugging constituent initialization issues

## Related Model Components

This initialization process provides the foundation for:
- Constituent fate and transport processes during simulation
- Mass balance tracking and output
- Management operation effects on constituents
- Water quality modeling and assessment