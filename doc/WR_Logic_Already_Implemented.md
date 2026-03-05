# Water Right Logic: Already Implemented in the SWAT+ Model

This document maps the logic described in `WR_Logi_Code.pptx` (OWRD water right data → water
allocation model) to the specific source files and line numbers where that logic already exists
in the SWAT+ codebase.

---

## 1. Data Structures and Input Parameters

### Source Object Types (channel, reservoir, aquifer, outside-basin, unlimited)
Defined in the `transfer_source_objects` type.

| Field | Description | File | Line |
|---|---|---|---|
| `typ` | Source type: `cha`, `res`, `aqu`, `osrc`, `osrc_a`, `wtp`, `use`, `stor`, `can`, `unl` | `src/water_allocation_module.f90` | 10–18 |
| `num` | Number/ID of the source object | `src/water_allocation_module.f90` | 11 |

### Minimum Source Volume (Slide 2 – "Minimum Source Volume")
The `wdraw_lim` field acts as the minimum allowable volume or flow for each source:
- **Channel**: minimum flow rate (m³/s) — multiplied by 86400 to get m³/day
- **Reservoir**: fraction of principal volume that acts as the dead level
- **Aquifer**: maximum allowed depth to water table (m)
- **Canal**: fraction of current storage

| Field | Description | File | Line |
|---|---|---|---|
| `wdraw_lim` | Withdrawal limit / minimum source volume | `src/water_allocation_module.f90` | 15 |

### Source Fraction (Slide 2 – multiple sources per POD)
| Field | Description | File | Line |
|---|---|---|---|
| `frac` | Fraction of demand supplied by this source | `src/water_allocation_module.f90` | 16 |

### Compensation Source (Slide 2 – "Compensation options: Absence / Exist")
| Field | Description | File | Line |
|---|---|---|---|
| `comp` | `"y"` if this source can compensate for shortfalls from other sources | `src/water_allocation_module.f90` | 17 |

### Water Right Field (Slide 2 – "Priority Date" / senior vs. junior)
| Field | Description | File | Line |
|---|---|---|---|
| `right` | Water right type: `"sr"` (senior) or `"jr"` (junior) | `src/water_allocation_module.f90` | 44 |

Read from the input file at:

| File | Lines |
|---|---|
| `src/water_allocation_read.f90` | 93, 140 |

### Demand, Withdrawal, and Unmet Demand Tracking
The `source_output` type captures the three key flow accounting values per source:

| Field | Description | File | Line |
|---|---|---|---|
| `demand` | Demand from this source (ha-m / m³) | `src/water_allocation_module.f90` | 62 |
| `withdr` | Actual withdrawal (ha-m / m³) | `src/water_allocation_module.f90` | 63 |
| `unmet` | Unmet demand (ha-m / m³) | `src/water_allocation_module.f90` | 64 |

Per-transfer-object totals:

| Field | Description | File | Line |
|---|---|---|---|
| `unmet_m3` | Total unmet demand for the transfer object (m³) | `src/water_allocation_module.f90` | 53 |
| `withdr_tot` | Total withdrawal from all sources (m³) | `src/water_allocation_module.f90` | 54 |
| `tot` | Allocation-level totals (demand, withdrawal, unmet) | `src/water_allocation_module.f90` | 74 |

### Irrigation Parameters (Slides 4, 8 – Irrigation Duty / efficiency)
| Field | Description | File | Line |
|---|---|---|---|
| `irr_eff` | In-field irrigation efficiency | `src/water_allocation_module.f90` | 55 |
| `surq` | Surface runoff ratio (fraction of applied water that becomes runoff) | `src/water_allocation_module.f90` | 56 |

---

## 2. Input File Reading

The water allocation objects are read from `water_allocation.wro` (default filename):

| File | Lines | What is read |
|---|---|---|
| `src/input_file_module.f90` | 144, 148 | Default filename `water_allocation.wro` stored in `in_watrts%transfer_wro` |
| `src/water_allocation_read.f90` | 42–170 | Reads allocation objects, transfer types, source objects, receiving objects, and cross-walks with decision tables |
| `src/water_allocation_read.f90` | 93 | Reads `amount`, `right` (sr/jr), `src_num` for each transfer object |
| `src/water_allocation_read.f90` | 140–142 | Reads full source array including `typ`, `num`, `conv_typ`, `wdraw_lim`, `frac`, `comp` |

---

## 3. Demand Calculation (`wallo_demand.f90`)

The subroutine `wallo_demand` calculates how much water the transfer object needs on a given day.
This corresponds to the "For Day in operation period" loop in Slides 3, 6, 7, 8, 9.

| Transfer type | What it does | File | Lines |
|---|---|---|---|
| `"outflo"` | Demand equals the full outflow of the source object | `src/wallo_demand.f90` | 23–73 |
| `"ave_day"` | Demand = `amount × 86400` (constant daily m³) | `src/wallo_demand.f90` | 76–79 |
| `"div_min"` | Demand = channel flow minus a minimum; diverts everything above the minimum | `src/wallo_demand.f90` | 81–84 |
| `"div_frac"` | Demand = fraction of channel flow | `src/wallo_demand.f90` | 86–89 |
| `"dtbl_con"` | Demand set by a flow-control decision table | `src/wallo_demand.f90` | 91–99 |
| `"dtbl_lum"` | Demand set by an irrigation land-use decision table | `src/wallo_demand.f90` | 100–113 |

---

## 4. Withdrawal from Each Source Type (`wallo_withdraw.f90`)

The subroutine `wallo_withdraw` checks availability and deducts water. This is the core
`If SWAT_flowout(day, source_id) >= demand` logic from Slides 3, 6, 7, 8, 9.

### Channel source – Implement 1, 4, 5 (Slides 3, 8, 9)
```
cha_min = wdraw_lim × 86400            ! minimum required flow (m³)
cha_div = channel_flow − cha_min       ! maximum divertible water
```
If demand ≥ available, take all available; otherwise take only what is needed.
Channel flow (`ht2%flo`) is reduced by the withdrawal ratio `rto`.

| File | Lines |
|---|---|
| `src/wallo_withdraw.f90` | 117–141 |

### Canal source
Same minimum-volume logic as channel, applied to canal storage.

| File | Lines |
|---|---|
| `src/wallo_withdraw.f90` | 145–160 |

### Reservoir source – Implement 3 (Slide 7)
```
res_min = wdraw_lim × principal_volume   ! dead level (m³)
res_vol = reservoir_volume − demand
```
Only withdraws if `res_vol > res_min`.  Reservoir state (`res(j)`) is updated.

| File | Lines |
|---|---|
| `src/wallo_withdraw.f90` | 162–178 |

### Aquifer source (standard 1-D aquifer)
```
avail = (wdraw_lim − water_table_depth) × specific_yield × area
```
Only withdraws if demand < available. Updates `aqu_d(j)%stor`, `no3_st`, and `minp`.

| File | Lines |
|---|---|
| `src/wallo_withdraw.f90` | 180–198 |

### Aquifer source (gwflow 2-D module)
When `bsn_cc%gwflow == 1`, calls `gwflow_ppag` to distribute pumping across grid cells.

| File | Lines |
|---|---|
| `src/wallo_withdraw.f90` | 200–207 |
| `src/gwflow_ppag.f90` | (full subroutine) |

### Outside-basin flowing source (`osrc` — recall file)
Reads daily/monthly/yearly flow from a recall object; takes min(demand, available).

| File | Lines |
|---|---|
| `src/wallo_withdraw.f90` | 39–82 |

### Outside-basin constant source (`osrc_a` — exco file)
Same logic as `osrc`, but uses an average annual constant from the exco database.

| File | Lines |
|---|---|
| `src/wallo_withdraw.f90` | 56–72 |

### Water treatment plant (`wtp`), water use effluent (`use`)
Takes the plant/use outflow as the withdrawal amount.

| File | Lines |
|---|---|
| `src/wallo_withdraw.f90` | 83–96 |

### Water tower storage (`stor`)
Checks storage; withdraws demand or all remaining storage, whichever is smaller.

| File | Lines |
|---|---|
| `src/wallo_withdraw.f90` | 97–115 |

### Unlimited source (`unl`)
Always fulfils the full demand — no availability check.

| File | Lines |
|---|---|
| `src/wallo_withdraw.f90` | 218–220 |

---

## 5. Compensation Logic (Slide 2 – "Compensation options")

After the first pass through all sources, a second loop checks any source flagged `comp = "y"`.
If unmet demand remains, that source is called again to try to cover the shortfall.

| File | Lines | Description |
|---|---|---|
| `src/wallo_control.f90` | 70–78 | Second-pass loop over sources; passes remaining `unmet_m3` as new demand |

---

## 6. Water Delivery to Receiving Objects (`wallo_control.f90`)

After withdrawal, the collected water is routed to its receiving object.
This is the "Updating the channel/reservoir flow" step in Slides 3, 6, 7, 8, 9.

| Receiving type | Action | File | Lines |
|---|---|---|---|
| `"hru"` (irrigation) | Converts m³ → mm, applies `irr_eff` and `surq`, adds to HRU irrigation | `src/wallo_control.f90` | 94–125 |
| `"cha"` (channel diversion) | Sets `ob(iob)%trans` for downstream routing | `src/wallo_control.f90` | 126–129 |
| `"res"` (reservoir refill) | Adds water to `res(j)` | `src/wallo_control.f90` | 130–136 |
| `"aqu"` (aquifer recharge) | Adds water to `aqu(j)` | `src/wallo_control.f90` | 137–141 |
| `"wtp"` (water treatment plant) | Adds to plant storage; calls `wallo_treatment` | `src/wallo_control.f90` | 142–147 |
| `"use"` (domestic/industrial/commercial) | Adds to use storage; calls `wallo_use` | `src/wallo_control.f90` | 148–153 |
| `"stor"` (water tower) | Adds to tower storage | `src/wallo_control.f90` | 154–157 |
| `"can"` (canal) | Adds to canal storage; calls `wallo_canal` | `src/wallo_control.f90` | 158–163 |
| `"orcv"` (outside-basin receiver) | Adds to external receive buffer | `src/wallo_control.f90` | 164–167 |

---

## 7. Irrigation Water Quality Tracking

When water is applied to an HRU, salt and custom constituent mass is tracked:

| File | Lines | Description |
|---|---|---|
| `src/wallo_control.f90` | 104–113 | Calls `salt_irrig` and `cs_irrig` for water quality accounting |
| `src/salt_irrig.f90` | (full subroutine) | Salt mass transferred with irrigation water |
| `src/cs_irrig.f90` | (full subroutine) | Custom constituent mass transferred with irrigation water |

---

## 8. Output Reporting

Daily, monthly, yearly, and average-annual output for each allocation object:

| File | Description |
|---|---|
| `src/header_water_allocation.f90` | Opens output files and writes column headers (lines 1–80) |
| `src/wallo_allo_output.f90` | Writes allocation-level demand, withdrawal, unmet (lines 1–124) |
| `src/wallo_trn_output.f90` | Writes transfer-object-level output |
| `src/wallo_use_output.f90` | Writes water-use object output |
| `src/wallo_treat_output.f90` | Writes water-treatment output |

Output files produced: `water_allo_day.txt/.csv`, `water_allo_mon.txt/.csv`,
`water_allo_yr.txt/.csv`, `water_allo_aa.txt/.csv`.

---

## 9. Simulation Loop Integration

`wallo_control` is called from two places in the daily routing loop:

| File | Lines | Context |
|---|---|---|
| `src/command.f90` | 83–86 | Non-channel-source transfers — called during general object routing |
| `src/command.f90` | 430–433 | Channel-source transfers — called after channel routing step |

The `trn_cur` counter advances through each transfer object in turn each day, resetting to 1
at the start of each new allocation cycle.

---

## Summary Table

| Feature from Presentation | Already in Model | Primary File(s) |
|---|---|---|
| Source types: channel, reservoir, aquifer, outside-basin, unlimited | ✅ | `water_allocation_module.f90`, `wallo_withdraw.f90` |
| Minimum source volume / dead level / min flow | ✅ | `wallo_withdraw.f90` lines 119, 147, 164, 183 |
| Multiple sources per POD with fractional allocation | ✅ | `water_allocation_module.f90` line 16 |
| Compensation source (alternative when primary is depleted) | ✅ | `wallo_control.f90` lines 70–78 |
| Senior / junior water right flag (sr/jr) | ✅ (stored) | `water_allocation_module.f90` line 44 |
| Demand calculation (daily, fraction, decision table, irrigation) | ✅ | `wallo_demand.f90` |
| Channel withdrawal with minimum-flow constraint | ✅ | `wallo_withdraw.f90` lines 117–141 |
| Reservoir withdrawal with dead-level constraint | ✅ | `wallo_withdraw.f90` lines 162–178 |
| Aquifer withdrawal with water-table depth limit | ✅ | `wallo_withdraw.f90` lines 180–207 |
| Deficit / unmet demand tracking per source and per object | ✅ | `water_allocation_module.f90` lines 53–54, 62–64 |
| Irrigation delivery to HRU with efficiency and runoff fraction | ✅ | `wallo_control.f90` lines 94–125 |
| Domestic / industrial / commercial water use receiving object | ✅ | `wallo_control.f90` lines 148–153 |
| Water treatment plant receiving object | ✅ | `wallo_control.f90` lines 142–147 |
| Canal receiving / source object | ✅ | `wallo_control.f90` lines 158–163, `wallo_withdraw.f90` lines 145–160 |
| Outside-basin source (recall file or constant) | ✅ | `wallo_withdraw.f90` lines 39–72 |
| Water quality tracking with irrigation (salt, constituents) | ✅ | `wallo_control.f90` lines 104–113 |
| Daily/monthly/yearly/average-annual output files | ✅ | `header_water_allocation.f90`, `wallo_allo_output.f90` |
