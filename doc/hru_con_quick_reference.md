# Quick Answer: HRU.CON File in SWAT+

## What is hru.con?
The `hru.con` file is a connectivity file that defines the basic spatial properties and connections of Hydrologic Response Units (HRUs) in SWAT+.

## Where is it read?
1. **Primary reading**: `src/hyd_read_connect.f90` - reads spatial and connectivity data
2. **Secondary usage**: `src/gwflow_read.f90` - reads for groundwater flow HUC12 linkage
3. **File specification**: Listed in the "connect" section of `file.cio`

## What attributes are in hru.con?

| Column | Description |
|--------|-------------|
| `id` | Unique HRU identifier number |
| `name` | HRU name (e.g., "hru0001") |
| `gis_id` | GIS identification number |
| `area` | HRU area in hectares |
| `lat` | Latitude in decimal degrees |
| `lon` | Longitude in decimal degrees |
| `elev` | Elevation in meters |
| `hru` | HRU database pointer/reference |
| `wst` | Weather station identifier |
| `cst` | Constituent set identifier |
| `ovfl` | Overflow/overbank option |
| `rule` | Rule set name for flow control |
| `out_tot` | Number of outlet connections |

Plus additional columns for outlet specifications when `out_tot > 0`.

## Example File Content
```
hru.con: AMES
      id  name                gis_id          area           lat           lon          elev       hru               wst       cst      ovfl      rule   out_tot  
       1  hru0001                  1       1.005           41.20        -96.63         347.5         1            wgn_01         0         0         0         0    
       2  hru0002                  1       1.005           41.20        -96.63         347.5         2            wgn_01         0         0         0         0    
```

For complete technical documentation, see [hru_con_documentation.md](hru_con_documentation.md).