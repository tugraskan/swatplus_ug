# Soft Calibration Files in SWAT+

SWAT+ supports two complementary calibration approaches: **hard calibration** and **soft calibration**. This document focuses on the soft calibration files — their purpose, format, and usage.

## Overview

**Hard calibration** directly adjusts individual model parameters (e.g., CN2, ESCO, AWC) by absolute value, absolute change, or percent change, specified in `cal_parms.cal` and `calibration.cal`.

**Soft calibration** adjusts parameters iteratively to match user-supplied landscape-, channel-, and plant-level budgets (water balance ratios, sediment fluxes, crop yields, etc.) derived from observed or literature data. The model runs multiple internal iterations, adjusting parameters until the simulated budgets match the soft targets within acceptable tolerances.

The soft calibration system is controlled by a family of input files referenced in the **`chg`** section of `file.cio`.

---

## Specifying Calibration Files in `file.cio`

The `chg` section of `file.cio` accepts up to nine file names in the following order:

```
chg  <cal_parms.cal>  <calibration.cal>  <codes.sft>  <wb_parms.sft>  <water_balance.sft>  <ch_sed_budget.sft>  <ch_sed_parms.sft>  <plant_parms.sft>  <plant_gro.sft>
```

Use `null` for any file that is not needed. Example:

```
chg   cal_parms.cal   calibration.cal   codes.sft   wb_parms.sft   water_balance.sft   null   null   null   null
```

> **Note on file naming:** The soft calibration files were previously named with a `.cal` extension (e.g., `codes.cal`, `ls_parms.cal`, `ls_regions.cal`, `ch_orders.cal`, `ch_parms.cal`, `pl_parms.cal`, `pl_regions.cal`). They have been renamed to use the `.sft` extension to distinguish them from hard calibration files. Both names are functionally equivalent if the file name in `file.cio` matches the actual file on disk.

---

## Hard Calibration Files

### `cal_parms.cal` — Calibration Parameter Database

Defines the allowable range (absolute min/max) for each calibration parameter. Used by both hard and soft calibration.

**Format:**

```
<title line>
<number of parameters>
name                    obj_typ   abs_min   abs_max   units
<name>                  <obj>     <min>     <max>     <units>
...
```

- `name`: parameter name (e.g., `cn2`, `esco`, `awc`)
- `obj_typ`: object type the parameter belongs to (`hru`, `sol`, `bsn`, `swq`, `rte`, `res`, `aqu`, `hlt`, `pst`)
- `abs_min` / `abs_max`: absolute physical limits of the parameter
- `units`: units of the parameter

### `calibration.cal` — Hard Calibration Updates

Specifies direct parameter changes applied before the simulation runs. Changes can target specific object types, soil layers, years, or days.

**Format:**

```
<title line>
<number of changes>
NAME        CHG_TYP   VAL   CONDS   LYR1   LYR2   YEAR1   YEAR2   DAY1   DAY2   OBJ_TOT
<name>      <typ>     <val> <cond>  <l1>   <l2>   <y1>    <y2>    <d1>   <d2>   <obj_list>
...
```

- `NAME`: parameter name (must exist in `cal_parms.cal`)
- `CHG_TYP`: type of change — `absval` (set to value), `abschg` (add value), or `pctchg` (percent change)
- `VAL`: magnitude of change
- `CONDS`: number of conditions restricting which objects are changed (0 = apply to all)
- `LYR1` / `LYR2`: soil layer range (0 = all layers)
- `YEAR1` / `YEAR2`: year range (0 = all years)
- `DAY1` / `DAY2`: day-of-year range (0 = all days)
- `OBJ_TOT`: number of specific object identifiers that follow on the same line (0 = apply to all objects of that type)

---

## Soft Calibration Files

### `codes.sft` — Soft Calibration Activation Codes

Controls which soft calibration processes are active. Read by `calsoft_read_codes`.

**Format:**

```
<title line>
HYD_HRU   HYD_HRUL   PLT   SED   NUT   CHSED   CHNUT   RES
<hyd_hru> <hyd_hrul> <plt> <sed> <nut> <chsed> <chnut> <res>
```

| Variable  | Values | Description |
|-----------|--------|-------------|
| `HYD_HRU` | `n` / `b` / `a` / `y` | Calibrate HRU hydrologic balance. `n` = off; `b` = calibrate total water yield and baseflow fraction only; `a` = calibrate all components (surface runoff, lateral flow, percolation, ET); `y` = same as `b` (legacy) |
| `HYD_HRUL` | `y` / `n` | Calibrate HRU-LTE (long-term average) hydrologic balance |
| `PLT` | `y` / `n` | Calibrate plant growth by land use in each region |
| `SED` | `y` / `n` | Calibrate sediment yield by land use in each region |
| `NUT` | `y` / `n` | Calibrate nutrient balance by land use |
| `CHSED` | `y` / `n` | Calibrate channel widening and bank accretion by stream order |
| `CHNUT` | `y` / `n` | Calibrate channel nutrient balance by stream order |
| `RES` | `y` / `n` | Calibrate reservoir budgets by reservoir |

**Example:**

```
soft calibration codes
HYD_HRU   HYD_HRUL   PLT   SED   NUT   CHSED   CHNUT   RES
b         n          n     n     n     n        n       n
```

---

### `water_balance.sft` — Landscape Water Balance Targets

*(formerly `ls_regions.cal`)*

Provides observed (or estimated) landscape-scale water balance ratios and fluxes for each region and land use. Read by `lcu_read_softcal`. Used when `HYD_HRU` ≠ `n` in `codes.sft`.

SWAT+ iterates model parameters until the simulated annual average water balance matches these targets within tolerance.

**Format:**

```
<title line>
<number of regions>
<region name>   <number of land uses>
NAME   SRR   LFR   PCR   ETR   TFR   PET   SED   WYR   BFR   SOLP
<lum_name>  <srr> <lfr> <pcr> <etr> <tfr> <pet> <sed> <wyr> <bfr> <solp>
...
```

Repeat the region block for each region.

**Column descriptions:**

| Variable | Units | Description |
|----------|-------|-------------|
| `NAME` | — | Land use name (must match a name in `landuse.lum`) or `basin` to apply to the entire basin |
| `SRR` | fraction | Surface runoff ratio: surface runoff / precipitation *(used when `HYD_HRU = a`)* |
| `LFR` | fraction | Lateral flow ratio: soil lateral flow / precipitation *(used when `HYD_HRU = a`)* |
| `PCR` | fraction | Percolation ratio: deep percolation / precipitation *(used when `HYD_HRU = a`)* |
| `ETR` | fraction | Evapotranspiration ratio: ET / precipitation *(used when `HYD_HRU = a`)* |
| `TFR` | fraction | Tile drain flow ratio: tile flow / total runoff *(used when `HYD_HRU = a`)* |
| `PET` | mm/yr | Average annual potential evapotranspiration |
| `SED` | t/ha | Average annual sediment yield |
| `WYR` | fraction | Water yield ratio: total water yield / precipitation *(used when `HYD_HRU = b` or `y`)* |
| `BFR` | fraction | Baseflow fraction of total water yield: baseflow / total water yield *(used when `HYD_HRU = b` or `y`)* |
| `SOLP` | kg/ha | Average annual soluble phosphorus yield |

> **Important:** When `HYD_HRU` = `b` or `y`, only `WYR` (water yield ratio) and `BFR` (baseflow fraction of water yield) are read and used. SWAT+ internally converts them to ratios as fractions of precipitation: `SRR = WYR × (1 − BFR)` and the new `BFR = WYR × BFR`. Values of `SRR`, `LFR`, `PCR`, `ETR`, and `TFR` in the file are ignored. When `HYD_HRU` = `a`, all ratio components must be provided directly as fractions of precipitation.

**Example:**

```
water balance soft calibration targets - ls_regions
1
basin    1
NAME         SRR    LFR    PCR    ETR    TFR    PET     SED     WYR    BFR    SOLP
corn_soybean 0.15   0.08   0.22   0.55   0.00   850.0   1.50   0.45   0.35   0.10
```

---

### `wb_parms.sft` — Water Balance Calibration Parameters

*(formerly `ls_parms.cal`)*

Defines the parameters adjusted during HRU water balance soft calibration and their allowable change ranges. Read by `ls_read_lsparms_cal`.

**Format:**

```
<title line>
<number of parameters>
NAME   CHG_TYP   NEG   POS   LO   UP
<name> <typ>     <neg> <pos> <lo> <up>
...
```

| Column | Description |
|--------|-------------|
| `NAME` | Parameter name (e.g., `cn2`, `esco`, `latq_co`, `petco`, `perco`) |
| `CHG_TYP` | Change type: `absval`, `abschg`, or `pctchg` |
| `NEG` | Maximum negative adjustment allowed per iteration |
| `POS` | Maximum positive adjustment allowed per iteration |
| `LO` | Absolute lower bound for the parameter |
| `UP` | Absolute upper bound for the parameter |

The following parameters can be adjusted during HRU water balance soft calibration:

| Index | Parameter | Role |
|-------|-----------|------|
| 1 | `cn2` | Curve number — controls surface runoff |
| 2 | `petco` | ET coefficient — controls evapotranspiration |
| 3 | `latq_co` | Lateral flow coefficient |
| 4 | `perco` | Percolation coefficient |
| 5 | `esco` | Soil evaporation compensation factor |
| 6 | `lat_len` | Lateral flow soil length |
| 7 | `cn3_swf` | CN3 soil water factor |
| 8 | `revapc` | Revap coefficient |

**Example:**

```
water balance soft calibration parameters - ls_parms
8
NAME     CHG_TYP  NEG    POS    LO     UP
cn2      pctchg   -20.0  20.0   35.0   98.0
petco    pctchg   -50.0  50.0   0.5    1.5
latq_co  pctchg   -50.0  50.0   0.0    1.0
perco    pctchg   -50.0  50.0   0.0    1.0
esco     pctchg   -50.0  50.0   0.0    1.0
lat_len  pctchg   -50.0  50.0   1.0    150.0
cn3_swf  pctchg   -50.0  50.0   0.0    1.0
revapc   pctchg   -50.0  50.0   0.02   0.2
```

---

### `ch_sed_budget.sft` — Channel Sediment Budget Targets

*(formerly `ch_orders.cal`)*

Provides observed (or estimated) channel morphology data for soft calibration by stream order and region. Read by `ch_read_orders_cal`. Used when `CHSED` = `y` in `codes.sft`.

**Format:**

```
<title line>
<number of regions>
<region name>   <number of stream orders>   [<nspu>  <element list>]
NAME     CHW    CHD    HC     FPD
<order_name>  <chw>  <chd>  <hc>  <fpd>
...
```

Repeat the region and order blocks for each region. If `nspu` = 0, all channels are included in the region.

**Channel budget column descriptions:**

| Variable | Units | Description |
|----------|-------|-------------|
| `NAME` | — | Stream order name (e.g., `1st`, `2nd`, `3rd`) |
| `CHW` | mm/yr | Average annual channel widening rate |
| `CHD` | mm/yr | Average annual channel downcutting or accretion rate |
| `HC` | m/yr | Average annual headcut advance rate |
| `FPD` | mm/yr | Average annual flood plain accretion rate |

---

### `ch_sed_parms.sft` — Channel Sediment Calibration Parameters

*(formerly `ch_parms.cal`)*

Defines the parameters adjusted during channel sediment soft calibration and their allowable change ranges. Read by `ch_read_parms_cal`. Same format as `wb_parms.sft`.

**Format:**

```
<title line>
<number of parameters>
NAME   CHG_TYP   NEG   POS   LO   UP
<name> <typ>     <neg> <pos> <lo> <up>
...
```

Parameters typically adjusted include channel cover (`cov`), channel erodibility (`cherod`), bank shear coefficient (`shear_bnk`), and headcut erodibility (`hc_erod`).

---

### `plant_gro.sft` — Plant Growth Calibration Targets

*(formerly `pl_regions.cal`)*

Provides observed (or estimated) plant growth metrics for soft calibration by region and land use. Read by `pl_read_regions_cal`. Used when `PLT` = `y` in `codes.sft`.

**Format:**

```
<title line>
<number of regions>
<region name>   <number of land uses>   [<nspu>  <element list>]
NAME     YIELD   NPP     LAI_MX   WSTRESS   ASTRESS   TSTRESS
<lum_name>  <yield>  <npp>  <lai_mx>  <wstress>  <astress>  <tstress>
...
```

If `nspu` = 0, all HRUs are included in the region.

**Plant growth column descriptions:**

| Variable | Units | Description |
|----------|-------|-------------|
| `NAME` | — | Land use name (must match a name in `landuse.lum`) |
| `YIELD` | t/ha | Average annual crop yield (dry weight) |
| `NPP` | t/ha | Average annual net primary productivity (total biomass, dry weight) |
| `LAI_MX` | — | Average maximum leaf area index |
| `WSTRESS` | — | Average annual water (drought) stress sum |
| `ASTRESS` | — | Average annual aeration (water-logging) stress sum |
| `TSTRESS` | — | Average annual temperature stress sum |

---

### `plant_parms.sft` — Plant Calibration Parameters

*(formerly `pl_parms.cal`)*

Defines plant-specific parameter adjustments used during plant soft calibration. Read by `pl_read_parms_cal`.

**Format:**

```
<title line>
<number of regions>
<region name>   <number of land uses>   <number of parameters>   [<nspu>  <element list>]
NAME   VAR   CHG_TYP   INIT_VAL
<plant_name>  <var>  <typ>  <val>
...
```

The data block (one row per land use × parameter combination) follows a header line.

**Adjustable plant parameters:**

| Variable | Description |
|----------|-------------|
| `epco` | Plant water uptake compensation factor (0–1) |
| `lai_pot` | Potential (maximum) leaf area index |
| `harv_idx` | Harvest index |
| `pest_stress` | Insect/disease stress factor |

---

## Calibration Workflow

When soft calibration files are provided, SWAT+ follows this sequence during each simulation year:

1. **Read control codes** (`codes.sft`) — determine which calibration modules are active.
2. **Read parameter ranges** (`wb_parms.sft`, `ch_sed_parms.sft`, `plant_parms.sft`).
3. **Read target budgets** (`water_balance.sft`, `ch_sed_budget.sft`, `plant_gro.sft`).
4. **Run the simulation** and accumulate water balance, sediment, and plant growth outputs by region and land use.
5. **Compare simulated outputs to targets** and adjust parameters within the specified ranges.
6. **Repeat** until convergence or the maximum number of iterations is reached.
7. **Write updated parameter files** — the calibrated parameter values are saved to `hru-new.cal` (hard calibration format), which can be used as `calibration.cal` in subsequent runs.

The process is orchestrated by `proc_cal` and `calsoft_control` in the source code.

---

## Tips and Common Issues

- **File naming:** The `.sft` extension is the current standard. Files named with the old `.cal` extension (e.g., `codes.cal`) will still work as long as the name in the `file.cio` chg section matches exactly.
- **Region names:** Region and land use names in the soft calibration files must exactly match names defined in `landuse.lum` and the region definition files (`ls_unit.ele`, `ls_unit.def`). Use `basin` as the region/land use name to apply targets to the whole watershed.
- **Unused columns:** If calibrating only water yield and baseflow (`HYD_HRU = b`), values of `SRR`, `LFR`, `PCR`, `ETR`, and `TFR` in `water_balance.sft` are ignored. The model derives them internally from `WYR` and `BFR`.
- **Output files:** After soft calibration, SWAT+ writes `hru-new.cal` and `hru-out.cal` containing the calibrated parameter values and simulated-vs-target budget comparisons, respectively.
- **Combining hard and soft calibration:** Hard calibration (`calibration.cal`) is applied first, before the soft calibration iterations begin.
