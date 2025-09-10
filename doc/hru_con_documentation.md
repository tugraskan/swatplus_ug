# HRU.CON File Documentation for SWAT+

## Overview

The `hru.con` file is a critical connectivity file in SWAT+ that defines the spatial and hydrological properties of Hydrologic Response Units (HRUs) and their connections within the watershed system. This file specifies the basic parameters and connectivity information for each HRU in the simulation.

## File Location and Usage

### Where hru.con is Used
- Listed in the **connect** section of `file.cio` configuration file
- Read by the hydrological connectivity system in SWAT+
- Processed by `hyd_read_connect.f90` subroutine

### Key Source Code Files
- **Reading Function**: `src/hyd_read_connect.f90` - Main subroutine that reads the hru.con file
- **Connection Logic**: `src/hyd_connect.f90` - Handles hydrological connectivity setup
- **Groundwater Flow**: `src/gwflow_read.f90` - Uses hru.con for HUC12 subwatershed linkage
- **File References**: `src/input_file_module.f90` - Defines file name (in_con%hru_con = "hru.con")
- **Data Structures**: `src/hydrograph_module.f90` - Contains object (ob) arrays that store HRU data

### Reading Process
The `hru.con` file is read in multiple contexts:

1. **Primary Reading** - `hyd_read_connect` subroutine:
   - Opens the file specified by `in_con%hru_con` (typically "hru.con")
   - Reads title and header lines
   - For each HRU, reads connectivity and spatial data
   - Allocates memory for hydrograph arrays and constituent tracking
   - Sets up outflow connections to other objects (channels, routing units, etc.)

2. **Groundwater Flow Module** - `gwflow_read` subroutine:
   - Also reads hru.con to link HRUs to HUC12 subwatersheds
   - Uses the gis_id column to establish watershed hierarchy

## File Format

### Header Structure
```
Line 1: Title/comment line (e.g., "hru.con: written by SWAT+ editor v2.2.0...")
Line 2: Column headers with attribute names
Line 3+: Data rows, one per HRU
```

### Column Attributes

| Attribute | Variable Name | Type | Units | Description |
|-----------|---------------|------|-------|-------------|
| **id** | `ob(i)%num` | integer | - | Unique HRU identifier number |
| **name** | `ob(i)%name` | string | - | HRU name (e.g., "hru0001") |
| **gis_id** | `ob(i)%gis_id` | integer*8 | - | GIS identification number for spatial reference |
| **area** | `ob(i)%area_ha` | real | ha | HRU area in hectares |
| **lat** | `ob(i)%lat` | real | degrees | Latitude coordinate |
| **lon** | `ob(i)%long` | real | degrees | Longitude coordinate |
| **elev** | `ob(i)%elev` | real | m | Elevation above sea level |
| **hru** | `ob(i)%props` | integer | - | HRU database pointer/reference |
| **wst** | `ob(i)%wst_c` | string | - | Weather station identifier (e.g., "wgn_01") |
| **cst** | `ob(i)%constit` | integer | - | Constituent set identifier (0 = none) |
| **ovfl** | `ob(i)%props2` | integer | - | Overflow/overbank option (0 = no overflow) |
| **rule** | `ob(i)%ruleset` | string | - | Rule set name (decision table for flow control) |
| **out_tot** | `ob(i)%src_tot` | integer | - | Total number of outlet connections |

### Additional Outlet Specification
If `out_tot > 0`, additional columns specify outlet connections:
- **obj_typ**: Object type receiving flow ("cha", "res", "ru", etc.)
- **obj_id**: Object ID number
- **hyd_typ**: Hydrograph type
- **frac**: Fraction of flow going to this outlet

## Example File Content

```
hru.con: AMES
      id  name                gis_id          area           lat           lon          elev       hru               wst       cst      ovfl      rule   out_tot  
       1  hru0001                  1       1.005           41.20        -96.63         347.5         1            wgn_01         0         0         0         0    
       2  hru0002                  1       1.005           41.20        -96.63         347.5         2            wgn_01         0         0         0         0    
       3  hru0003                  1       1.005           41.20        -96.63         347.5         3            wgn_01         0         0         0         0    
```

## Relationship with Other Files

### HRU-Data.hru vs hru.con
- **hru.con**: Connectivity and basic spatial properties
- **hru-data.hru**: Detailed HRU database parameters (land use, soil, hydrology parameters)
- The `hru` column in hru.con points to entries in the HRU database files

### File.cio Configuration
In `file.cio`, the hru.con file is specified in the connect section:
```
connect           hru.con           null              rout_unit.con     ...
```

## Data Structures in Code

### Object Array (ob)
Each HRU is stored in the `ob` array (`object_connectivity` type) with the following key components:
- `ob(i)%num`: HRU number (unique spatial object number)
- `ob(i)%name`: HRU name (character string, e.g., "hru0001")
- `ob(i)%gis_id`: GIS identifier (integer*8 for database purposes)
- `ob(i)%area_ha`: Area in hectares (input drainage area)
- `ob(i)%lat`, `ob(i)%long`: Latitude and longitude coordinates
- `ob(i)%elev`: Elevation in meters
- `ob(i)%typ`: Object type ("hru")
- `ob(i)%props`: Properties pointer (HRU database reference number)
- `ob(i)%wst_c`: Weather station character ID
- `ob(i)%wst`: Weather station number (after crosswalking)
- `ob(i)%constit`: Constituent data pointer (pesticides, pathogens, metals, salts)
- `ob(i)%props2`: Secondary properties (overflow/overbank connectivity)
- `ob(i)%ruleset`: Rule set name for flow control
- `ob(i)%src_tot`: Number of outlet connections
- `ob(i)%obtyp_out()`, `ob(i)%obtypno_out()`: Outlet object types and numbers
- `ob(i)%htyp_out()`, `ob(i)%frac_out()`: Outlet hydrograph types and flow fractions

### Memory Allocation
The reading process allocates:
- Hydrograph arrays for water balance tracking
- Constituent tracking arrays (pesticides, nutrients, salts, etc.)
- Outlet connection arrays for flow routing
- Time series arrays for subdaily simulation

## Technical Notes

### Coordinate System
- Latitude and longitude should be in decimal degrees
- Elevation is in meters above sea level
- Ensure consistency with GIS data and other spatial files

### Weather Station Linkage
- Weather station IDs (`wst` column) must match entries in weather-sta.cli
- Crosswalking occurs in `hyd_read_connect` using the `search` subroutine

### Flow Routing
- HRUs with `out_tot = 0` represent watershed outlets or sinks
- Non-zero `out_tot` requires additional outlet specification columns
- Flow fractions should sum to 1.0 for proper mass balance

### Error Handling
- Missing files are handled gracefully (objects set to null)
- Invalid weather station references are reported to error log (unit 9001)
- Connectivity validation occurs during the reading process

## Summary

The `hru.con` file is a fundamental connectivity file in SWAT+ that serves multiple purposes:
1. **Primary Function**: Defines spatial properties and connectivity for HRUs
2. **Hydrological Modeling**: Links HRUs to weather stations, constituent sets, and outlet objects
3. **Groundwater Flow**: Provides HUC12 subwatershed linkage for groundwater modeling
4. **Model Structure**: Establishes the basic spatial framework for watershed simulation

This file is essential for setting up any SWAT+ simulation and must be properly configured for the model to function correctly.