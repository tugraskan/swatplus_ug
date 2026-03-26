# `file.cio` — Master Input File Reference

`file.cio` is the master control file that tells SWAT+ the name of every other input file used in a simulation. The model reads this file first when it starts, so every file you want to use must be listed here.

## Overview

- **One line per section.** Each line begins with a section keyword (e.g., `simulation`, `basin`, `chg`) followed by file names in a fixed positional order.
- **Use `null`** in any position where the corresponding file is not needed or does not exist. The model silently skips that feature.
- **Default file names.** When a position is not `null`, the value is simply the name of the file expected in the same directory as `file.cio` (or a path relative to it). The defaults shown in the tables below are the names the SWAT+ Editor assigns automatically.
- **Title line.** The very first line of the file is a free-text title/comment (e.g., `file.cio: written by SWAT+ editor v2.2.0 ...`). It is read and ignored.

## Complete Section Reference

### Line 1 — `simulation`

Controls the simulation run configuration.

| Position | Default file | Description |
|----------|-------------|-------------|
| 1 | `time.sim` | Simulation time period (start/end dates, time step) |
| 2 | `print.prt` | Print/output control: which variables to write and at what frequency |
| 3 | `object.prt` | Object-level print control (rarely used; set to `null` to skip) |
| 4 | `object.cnt` | Object count file — lists all simulation objects |
| 5 | `constituents.cs` | Constituent simulation database (required only when running salt, heavy metal, or pathogen modules) |

**What to change:** Nearly always keep `time.sim`, `print.prt`, and `object.cnt`. Set positions 3 and/or 5 to `null` if you are not using object-level output or the constituents module.

---

### Line 2 — `basin`

Basin-wide code and parameter settings.

| Position | Default file | Description |
|----------|-------------|-------------|
| 1 | `codes.bsn` | Basin simulation codes (routing method, ET method, etc.) |
| 2 | `parameters.bsn` | Basin-level calibration parameters (SURLAG, MSK, etc.) |

**What to change:** Both files are always required. Change the values inside them, not the file names themselves.

---

### Line 3 — `climate`

Points SWAT+ to all climate input files.

| Position | Default file | Description |
|----------|-------------|-------------|
| 1 | `weather-sta.cli` | Weather station locations and file pointers |
| 2 | `weather-wgn.cli` | Weather generator statistics (used for gap-filling or synthetic weather) |
| 3 | `pet.cli` | Pre-computed potential ET input file. Use `null` to have SWAT+ compute PET internally |
| 4 | `pcp.cli` | Precipitation station list |
| 5 | `tmp.cli` | Temperature station list |
| 6 | `slr.cli` | Solar radiation station list (use `null` to generate from lat/daylength) |
| 7 | `hmd.cli` | Relative humidity station list (use `null` to generate) |
| 8 | `wnd.cli` | Wind speed station list (use `null` to generate) |
| 9 | `atmodep.cli` | Atmospheric deposition (wet/dry N and P inputs; use `null` if not needed) |

**What to change:** Positions 3, 6, 7, 8, and 9 are commonly set to `null`. Positions 1, 2, 4, and 5 are nearly always required.

---

### Line 4 — `connect`

Defines the connections between all simulation objects.

| Position | Default file | Description |
|----------|-------------|-------------|
| 1 | `hru.con` | HRU connections |
| 2 | `hru-lte.con` | HRU-LTE (long-term average) connections |
| 3 | `rout_unit.con` | Routing unit connections |
| 4 | `gwflow.con` | MODFLOW/GWFLOW groundwater connections (set `null` unless using GWFLOW) |
| 5 | `aquifer.con` | Aquifer connections |
| 6 | `aquifer2d.con` | 2D aquifer connections (set `null` unless using the 2D aquifer module) |
| 7 | `channel.con` | Channel connections |
| 8 | `reservoir.con` | Reservoir connections |
| 9 | `recall.con` | Recall (point source) connections |
| 10 | `exco.con` | Exco (export coefficient) connections |
| 11 | `delratio.con` | Delivery ratio connections |
| 12 | `outlet.con` | Outlet connections |
| 13 | `chandeg.con` | Channel degradation connections |

**What to change:** Set any position to `null` for object types not present in your watershed. For example, use `null` for `reservoir.con` if there are no reservoirs.

---

### Line 5 — `channel`

Channel property and initial condition files.

| Position | Default file | Description |
|----------|-------------|-------------|
| 1 | `initial.cha` | Channel initial conditions |
| 2 | `channel.cha` | Channel geometry and data |
| 3 | `hydrology.cha` | Channel hydrology parameters |
| 4 | `sediment.cha` | Channel sediment parameters |
| 5 | `nutrients.cha` | Channel nutrient parameters |
| 6 | `channel-lte.cha` | Channel LTE (simplified) data |
| 7 | `hyd-sed-lte.cha` | Combined hydrology-sediment LTE data |
| 8 | `temperature.cha` | Channel temperature parameters |

**What to change:** Set to `null` any features not used (e.g., set position 8 to `null` if not simulating stream temperature). If your watershed has no channels, all positions can be `null`.

---

### Line 6 — `reservoir`

Reservoir, pond, and wetland files.

| Position | Default file | Description |
|----------|-------------|-------------|
| 1 | `initial.res` | Reservoir initial conditions |
| 2 | `reservoir.res` | Reservoir geometry and management data |
| 3 | `hydrology.res` | Reservoir hydrology parameters |
| 4 | `sediment.res` | Reservoir sediment parameters |
| 5 | `nutrients.res` | Reservoir nutrient parameters |
| 6 | `weir.res` | Weir/dam structure data |
| 7 | `wetland.wet` | Wetland/pond data |
| 8 | `hydrology.wet` | Wetland hydrology parameters |

**What to change:** Set all to `null` if there are no reservoirs or wetlands. Positions 7 and 8 are for wetlands/ponds embedded in the landscape (not main-channel reservoirs).

---

### Line 7 — `routing_unit`

Routing unit (landscape unit) definition files.

| Position | Default file | Description |
|----------|-------------|-------------|
| 1 | `rout_unit.def` | Routing unit definitions (which HRUs belong to which routing unit) |
| 2 | `rout_unit.ele` | Routing unit element list |
| 3 | `rout_unit.rtu` | Routing unit parameters |
| 4 | `rout_unit.dr` | Routing unit delivery ratio |

**What to change:** Position 4 is set to `null` when not using delivery ratios.

---

### Line 8 — `hru`

HRU data files.

| Position | Default file | Description |
|----------|-------------|-------------|
| 1 | `hru-data.hru` | HRU physical properties (area, slope, soil, land use, etc.) |
| 2 | `hru-lte.hru` | HRU-LTE (long-term average HRU) properties |

**What to change:** Position 2 is `null` unless you are running HRU-LTE objects.

---

### Line 9 — `exco`

Export coefficient (constant loading) files.

| Position | Default file | Description |
|----------|-------------|-------------|
| 1 | `exco.exc` | Exco water and sediment |
| 2 | `exco_om.exc` | Exco organic matter |
| 3 | `exco_pest.exc` | Exco pesticides |
| 4 | `exco_path.exc` | Exco pathogens |
| 5 | `exco_hmet.exc` | Exco heavy metals |
| 6 | `exco_salt.exc` | Exco salt |

**What to change:** Set all to `null` if not using export coefficient objects. Use only the positions corresponding to the constituents being simulated.

---

### Line 10 — `recall`

Recall (time-series loading) files.

| Position | Default file | Description |
|----------|-------------|-------------|
| 1 | `recall.rec` | Recall time-series data (daily, monthly, or annual) |

**What to change:** Set to `null` if there are no point sources or upstream inputs modeled as recall objects.

---

### Line 11 — `dr`

Delivery ratio files.

| Position | Default file | Description |
|----------|-------------|-------------|
| 1 | `delratio.del` | Delivery ratio (main) |
| 2 | `dr_om.del` | Delivery ratio for organic matter |
| 3 | `dr_pest.del` | Delivery ratio for pesticides |
| 4 | `dr_path.del` | Delivery ratio for pathogens |
| 5 | `dr_hmet.del` | Delivery ratio for heavy metals |
| 6 | `dr_salt.del` | Delivery ratio for salt |

**What to change:** Typically all `null` unless the delivery ratio module is active.

---

### Line 12 — `aquifer`

Aquifer files.

| Position | Default file | Description |
|----------|-------------|-------------|
| 1 | `initial.aqu` | Aquifer initial conditions |
| 2 | `aquifer.aqu` | Aquifer parameters (depth, recharge fraction, etc.) |

**What to change:** Both are nearly always required when HRU objects are present (aquifers receive recharge from HRUs). Set to `null` only in simplified LTE-only setups.

---

### Line 13 — `herd`

Animal herd files (for manure and grazing).

| Position | Default file | Description |
|----------|-------------|-------------|
| 1 | `animal.hrd` | Animal type database |
| 2 | `herd.hrd` | Herd definitions |
| 3 | `ranch.hrd` | Ranch/grazing area definitions |

**What to change:** Set all to `null` when not simulating manure management or feedlots.

---

### Line 14 — `water_rights`

Water rights and allocation files.

| Position | Default file | Description |
|----------|-------------|-------------|
| 1 | `water_allocation.wro` | Water allocation via decision tables |
| 2 | `element.wro` | Water rights element list |
| 3 | `water_rights.wro` | Water rights definitions (2-source approach, used for some international applications) |

**What to change:** Set all to `null` unless simulating water rights or allocation.

---

### Line 15 — `link`

Object linkage files.

| Position | Default file | Description |
|----------|-------------|-------------|
| 1 | `chan-surf.lin` | Channel-to-surface water link |
| 2 | `aqu_cha.lin` | Aquifer-to-channel link |

**What to change:** Typically `null` unless the linkage module is active.

---

### Line 16 — `hydrology`

HRU-level hydrology parameter files.

| Position | Default file | Description |
|----------|-------------|-------------|
| 1 | `hydrology.hyd` | HRU hydrology parameters (ESCO, EPCO, CN2, lateral flow, etc.) |
| 2 | `topography.hyd` | Topography parameters (slope, slope length, etc.) |
| 3 | `field.fld` | Field geometry parameters (length, width, angle — used for sediment routing) |

**What to change:** All three are commonly required. Set position 3 to `null` if not using field-scale sediment routing.

---

### Line 17 — `structural`

BMP and structural control files.

| Position | Default file | Description |
|----------|-------------|-------------|
| 1 | `tiledrain.str` | Tile drain parameters |
| 2 | `septic.str` | Septic system parameters |
| 3 | `filterstrip.str` | Filter strip parameters |
| 4 | `grassedww.str` | Grassed waterway parameters |
| 5 | `bmpuser.str` | User-defined BMP parameters |

**What to change:** Set to `null` any structural feature not used in the simulation.

---

### Line 18 — `hru_parm_db`

HRU parameter database files.

| Position | Default file | Description |
|----------|-------------|-------------|
| 1 | `plants.plt` | Plant growth parameter database |
| 2 | `fertilizer.frt` | Fertilizer composition database |
| 3 | `tillage.til` | Tillage operation database |
| 4 | `pesticide.pes` | Pesticide properties database |
| 5 | `pathogens.pth` | Pathogen database |
| 6 | `metals.mtl` | Heavy metals database |
| 7 | `salt.slt` | Salt ion database |
| 8 | `urban.urb` | Urban land use parameters |
| 9 | `septic.sep` | Septic system database |
| 10 | `snow.sno` | Snow parameters |

**What to change:** Positions 1–4, 8, 9, and 10 are typically always required. Positions 5–7 are only needed when simulating pathogens, heavy metals, or salt.

---

### Line 19 — `ops`

Agricultural operation scheduling files.

| Position | Default file | Description |
|----------|-------------|-------------|
| 1 | `harv.ops` | Harvest/kill operations |
| 2 | `graze.ops` | Grazing operations |
| 3 | `irr.ops` | Irrigation operations |
| 4 | `chem_app.ops` | Fertilizer/pesticide application operations |
| 5 | `fire.ops` | Fire operations |
| 6 | `sweep.ops` | Sweep/removal operations |

**What to change:** All six are typically required even if some operations are not active, because the databases must exist for the scheduler to reference. Use `null` only for operations that are explicitly not defined anywhere in the simulation.

---

### Line 20 — `lum`

Land use management files.

| Position | Default file | Description |
|----------|-------------|-------------|
| 1 | `landuse.lum` | Land use definitions and properties |
| 2 | `management.sch` | Management schedule (planting, harvesting, fertilizing, etc.) |
| 3 | `cntable.lum` | Curve number table |
| 4 | `cons_practice.lum` | Conservation practice table (USLE P factor) |
| 5 | `ovn_table.lum` | Overland Manning's n table |

**What to change:** All five are typically required. These files define the core land-use properties for the simulation.

---

### Line 21 — `chg`

Calibration change files — both hard calibration and soft calibration.

> **See [`doc/soft_cal_files.md`](soft_cal_files.md) for full details on each file's format and content.**

| Position | Default file | Description |
|----------|-------------|-------------|
| 1 | `cal_parms.cal` | Calibration parameter database (allowed min/max for every parameter) |
| 2 | `calibration.cal` | Hard calibration: direct parameter adjustments applied before the run |
| 3 | `codes.sft` | Soft calibration activation codes (formerly `codes.cal`) |
| 4 | `wb_parms.sft` | Water balance soft calibration parameter ranges (formerly `ls_parms.cal`) |
| 5 | `water_balance.sft` | Landscape water balance targets (formerly `ls_regions.cal`) |
| 6 | `ch_sed_budget.sft` | Channel sediment budget targets (formerly `ch_orders.cal`) |
| 7 | `ch_sed_parms.sft` | Channel sediment calibration parameter ranges (formerly `ch_parms.cal`) |
| 8 | `plant_parms.sft` | Plant calibration parameter adjustments (formerly `pl_parms.cal`) |
| 9 | `plant_gro.sft` | Plant growth calibration targets (formerly `pl_regions.cal`) |

**What to change:**
- To run with **no calibration**: set all nine positions to `null`.
- To run **hard calibration only**: provide positions 1 and 2; set 3–9 to `null`.
- To run **soft water-balance calibration**: provide positions 1, 3, 4, and 5; set others as needed.

---

### Line 22 — `init`

Initial condition files for soil and water chemistry.

| Position | Default file | Description |
|----------|-------------|-------------|
| 1 | `plant.ini` | Plant initial conditions (growth stage, biomass, etc.) |
| 2 | `soil_plant.ini` | Soil-plant nutrient initial conditions |
| 3 | `om_water.ini` | Organic matter initial conditions in water |
| 4 | `pest_hru.ini` | Pesticide initial conditions in HRU soil |
| 5 | `pest_water.ini` | Pesticide initial conditions in water |
| 6 | `path_hru.ini` | Pathogen initial conditions in HRU soil |
| 7 | `path_water.ini` | Pathogen initial conditions in water |
| 8 | `hmet_hru.ini` | Heavy metal initial conditions in HRU soil |
| 9 | `hmet_water.ini` | Heavy metal initial conditions in water |
| 10 | `salt_hru.ini` | Salt initial conditions in HRU soil |
| 11 | `salt_water.ini` | Salt initial conditions in water |

**What to change:** Positions 1 and 2 are almost always required. Positions 3–11 are only needed when simulating the corresponding constituent (pesticides, pathogens, heavy metals, or salt).

---

### Line 23 — `soils`

Soil property files.

| Position | Default file | Description |
|----------|-------------|-------------|
| 1 | `soils.sol` | Soil layer properties (texture, hydraulic properties, organic carbon, etc.) |
| 2 | `nutrients.sol` | Soil nutrient initial conditions (N, P pools) |
| 3 | `soils_lte.sol` | Soil properties for HRU-LTE objects |

**What to change:** Positions 1 and 2 are always required. Position 3 is `null` unless using HRU-LTE objects.

---

### Line 24 — `decision_table`

Decision table files for conditional actions.

| Position | Default file | Description |
|----------|-------------|-------------|
| 1 | `lum.dtl` | Land use management decision table (auto-irrigation, auto-fertilization, etc.) |
| 2 | `res_rel.dtl` | Reservoir release decision table |
| 3 | `scen_lu.dtl` | Scenario-based land use change decision table |
| 4 | `flo_con.dtl` | Flow control decision table |

**What to change:** Position 1 (`lum.dtl`) is almost always required because it drives the management scheduler. Positions 2–4 are `null` unless those features are active.

---

### Line 25 — `regions`

Region definition files for landscape, channel, aquifer, reservoir, and recall objects.

| Position | Default file | Description |
|----------|-------------|-------------|
| 1 | `ls_unit.ele` | Landscape unit elements |
| 2 | `ls_unit.def` | Landscape unit definitions |
| 3 | `ls_reg.ele` | Landscape region elements |
| 4 | `ls_reg.def` | Landscape region definitions |
| 5 | `ls_cal.reg` | Landscape calibration regions |
| 6 | `ch_catunit.ele` | Channel catchment unit elements |
| 7 | `ch_catunit.def` | Channel catchment unit definitions |
| 8 | `ch_reg.def` | Channel region definitions |
| 9 | `aqu_catunit.ele` | Aquifer catchment unit elements |
| 10 | `aqu_catunit.def` | Aquifer catchment unit definitions |
| 11 | `aqu_reg.def` | Aquifer region definitions |
| 12 | `res_catunit.ele` | Reservoir catchment unit elements |
| 13 | `res_catunit.def` | Reservoir catchment unit definitions |
| 14 | `res_reg.def` | Reservoir region definitions |
| 15 | `rec_catunit.ele` | Recall catchment unit elements |
| 16 | `rec_catunit.def` | Recall catchment unit definitions |
| 17 | `rec_reg.def` | Recall region definitions |

**What to change:** Positions 1 and 2 (`ls_unit.ele`, `ls_unit.def`) are required for landscape unit output. Positions 3–5 support regional output and soft calibration by landscape region. Positions 6–17 support regional output and calibration for channels, aquifers, reservoirs, and recall objects; set to `null` when those object types are not used or when regional grouping is not needed.

---

### Lines 26–30 — Weather data paths

Optional path prefixes for weather input files (useful when weather files are stored in a separate directory).

| Line keyword | Default | Description |
|--------------|---------|-------------|
| `pcp_path` | `null` | Directory path prepended to all precipitation file names |
| `tmp_path` | `null` | Directory path prepended to all temperature file names |
| `slr_path` | `null` | Directory path prepended to all solar radiation file names |
| `hmd_path` | `null` | Directory path prepended to all humidity file names |
| `wnd_path` | `null` | Directory path prepended to all wind speed file names |

**What to change:** Leave as `null` when weather files are in the same directory as `file.cio`. Set to a folder name (e.g., `weather/`) when weather data files are in a subdirectory.

---

## Annotated Example

Below is the `file.cio` from the `Osu_1hru` test dataset, with inline comments explaining each line:

```
file.cio: written by SWAT+ editor v2.2.0 on 2023-03-22 04:25 for SWAT+ rev.60.5.4
simulation        time.sim          print.prt         null              object.cnt        null
basin             codes.bsn         parameters.bsn
climate           weather-sta.cli   weather-wgn.cli   null              pcp.cli           tmp.cli           slr.cli           null              wnd.cli           null
connect           hru.con           null              rout_unit.con     null              aquifer.con       null              null              null              recall.con        null              null              null              chandeg.con
channel           initial.cha       null              null              null              nutrients.cha     channel-lte.cha   hyd-sed-lte.cha   null
reservoir         initial.res       null              null              sediment.res      nutrients.res     weir.res          wetland.wet       hydrology.wet
routing_unit      rout_unit.def     rout_unit.ele     rout_unit.rtu     null
hru               hru-data.hru      null
exco              null              null              null              null              null              null
recall            recall.rec
dr                null              null              null              null              null              null
aquifer           initial.aqu       aquifer.aqu
herd              null              null              null
water_rights      null              null              null
link              null              null
hydrology         hydrology.hyd     topography.hyd    field.fld
structural        tiledrain.str     septic.str        filterstrip.str   grassedww.str     bmpuser.str
hru_parm_db       plants.plt        fertilizer.frt    tillage.til       pesticide.pes     null              null              null              urban.urb         septic.sep        snow.sno
ops               harv.ops          graze.ops         irr.ops           chem_app.ops      fire.ops          sweep.ops
lum               landuse.lum       management.sch    cntable.lum       cons_practice.lum ovn_table.lum
chg               cal_parms.cal     calibration.cal   null              null              null              null              null              null              null
init              plant.ini         soil_plant.ini    om_water.ini      null              null              null              null              null              null              null              null
soils             soils.sol         nutrients.sol     null
decision_table    lum.dtl           res_rel.dtl       null              null
regions           ls_unit.ele       ls_unit.def       null              null              null              null              null              null              aqu_catunit.ele   null              null              null              null              null              null              null              null
pcp_path          null
tmp_path          null
slr_path          null
hmd_path          null
wnd_path          null
```

Key observations from this example:
- **`connect` line**: `hru-lte.con` (position 2) is `null` — no HRU-LTE objects; `gwflow.con` (position 4) is `null` — not using GWFLOW.
- **`chg` line**: positions 3–9 are all `null` — only hard calibration (`calibration.cal`) is used, not soft calibration.
- **`hru_parm_db` line**: positions 5–7 are `null` — pathogens, metals, and salt modules are not active.
- **`regions` line**: most positions are `null` — only landscape units and one aquifer element file are defined.

## Quick-Reference: Common Scenarios

| Goal | Section to edit | What to change |
|------|----------------|----------------|
| Change simulation years | `simulation` position 1 | Edit `time.sim` |
| Change which outputs are written | `simulation` position 2 | Edit `print.prt` |
| Add reservoir simulation | `connect` position 8; `reservoir` | Replace `null` with `reservoir.con`; provide `reservoir.res`, etc. |
| Enable hard calibration | `chg` position 2 | Replace `null` with `calibration.cal` |
| Enable soft water-balance calibration | `chg` positions 3, 4, 5 | Replace `null` with `codes.sft`, `wb_parms.sft`, `water_balance.sft` |
| Use pesticide simulation | `hru_parm_db` position 4; `init` positions 4–5 | Provide `pesticide.pes`, `pest_hru.ini`, `pest_water.ini` |
| Simulate salt transport | `hru_parm_db` position 7; `init` positions 10–11 | Provide `salt.slt`, `salt_hru.ini`, `salt_water.ini` |
| Store weather files in a subfolder | `pcp_path`, `tmp_path`, etc. | Replace `null` with the folder name (e.g., `weather/`) |
