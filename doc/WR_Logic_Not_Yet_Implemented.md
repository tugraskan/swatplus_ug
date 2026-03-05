# Water Right Logic: NOT Yet Implemented in the SWAT+ Model

This document lists every parameter and algorithm described in `WR_Logi_Code.pptx` that is
**absent from the current SWAT+ codebase**, and tracks incremental additions as they are made.

Cross-reference: features that ARE already in the model are documented in
`doc/WR_Logic_Already_Implemented.md`.

---

## 1. Missing Input Parameters (Slide 2)

### 1.1 Water Use Code
The presentation defines **23 OWRD water use categories** that control how demand is calculated,
whether return flow occurs, and whether instream-flow rules apply.

| # | Category |
|---|---|
| 1 | Aesthetics |
| 2 | Agriculture uses |
| 3 | Anadromous and resident fish habitat (instream) |
| 4 | Commercial uses |
| 5 | Domestic |
| 6 | Domestic and livestock |
| 7 | Domestic expanded |
| 8 | Domestic including lawn and garden |
| 9 | Fire protection |
| 10 | Fish culture |
| 11 | Forest management |
| 12 | Human consumption |
| 13 | Industrial/manufacturing uses |
| 14 | Irrigation |
| 15 | Irrigation and domestic |
| 16 | Livestock |
| 17 | Mining |
| 18 | Multiple instream uses |
| 19 | Municipal uses |
| 20 | Pond maintenance |
| 21 | Power development |
| 22 | Storage |
| 23 | Wildlife |

**What is missing:**  There was no `water_use_code` (or equivalent) field in
`water_allocation_module.f90`'s type definitions.

**Partial fix now implemented:** A `use_typ` field (character, 16-char) has been added to the
`water_treatment_use_data` type and is read from the second column of `water_use.wal`.
Supported tokens are:

| Token | Meaning |
|---|---|
| `dom` | Domestic / residential |
| `ind` | Industrial / manufacturing |
| `com` | Commercial |
| `mun` | Municipal |
| `agr` | Agricultural |
| `lsk` | Livestock |
| `pwr` | Power development |
| `rec` | Recreational |
| `oth` | Other / unclassified |

**What is still missing:**  The model stores but does not yet *act on* `use_typ`.  The 23 OWRD
water-use codes from the presentation are not yet mapped to these tokens, and the simulation
logic in `wallo_use.f90` does not branch on `use_typ` to vary demand calculations, return-flow
fractions, or duty caps by use category.

---

### 1.2 Priority Date
The `right` field (`"sr"` / `"jr"`) stores which category a right falls into, but:

* The **actual priority date** (calendar date) is not stored.
* There is **no sort by priority date** before the daily allocation loop.
* The full **`Cut_off()`** algorithm (Slide 4) — which ranks all PODs by date, detects deficits
  of senior rights, and reduces or zeroes junior rights upstream — is entirely absent.

Missing parameters:
- `priority_date` (integer or date field per transfer object)
- `protected_types` list (rights exempt from junior cutoff)

---

### 1.3 Start Date and End Date of the Water Right
The model has no `start_date` / `end_date` fields on the transfer object.  The presentation
uses these to:

1. Gate withdrawals to the legal operation period
   (`if day >= start_date and <= end_date`).
2. Calculate the **daily allowed volume** =
   `Maximum_Volume_Allowed / (end_date - start_date)`.

Currently the model uses a fixed `amount` (m³/day) set directly by the user; there is no way to
derive it automatically from an annual or seasonal maximum volume and a date range.

---

### 1.4 Maximum Volume Allowed (Annual / Seasonal Budget)
A total volumetric cap (acre-feet per season or year) that is divided over the active period to
produce a daily rate.  The logic in Slides 3, 6, 7, 8, and 9 all converge on:

```
daily_demand = Maximum_Volume_Allowed / (end_date - start_date)
```
Here `(end_date - start_date)` is an integer count of days in the legal operation period.

The `amount` field in `water_transfer_objects` is a per-day value typed in directly.  There is
no field for the gross seasonal/annual cap, and no code that computes the daily rate from it.

---

### 1.5 Return Flow Parameters (Slide 5)
Three parameters are entirely absent:

| Parameter | Description |
|---|---|
| `return_delay` | Days between withdrawal and return of water to the system |
| `return_source` | Object ID where return flow re-enters (may differ from withdrawal source) |
| `return_rate` | Fraction of withdrawal that returns to the system (consumptive use = 1 − return_rate) |

---

### 1.6 Domestic Duty and Family Number
Used when `water_use_code ∈ {5, 6, 7, 8}` (domestic categories):

| Parameter | Description |
|---|---|
| `domestic_duty` | Maximum allowable volume per family unit (acre-feet/family) |
| `family_number` | Number of families served by the right |

The `Cut_off()` logic overrides `Maximum_Volume_Allowed` with
`domestic_duty × family_number` when the duty cap is smaller.  Neither field is present in the
model.

---

### 1.7 Irrigation Duty and Irrigation Area
Used when `water_use_code ∈ {14, 15}` (irrigation categories):

| Parameter | Description |
|---|---|
| `irrigation_duty` | Volume per unit irrigated area (acre-feet/acre or acre-feet/foot) |
| `irrigation_area` | Irrigated area (acres) stated in the water right certificate |

The model has `irr_eff` (efficiency) and `surq` (surface runoff ratio), but no per-right duty
cap derived from a certificate area.

---

### 1.8 Livestock Duty, Stock Type, and Number of Livestock
Used when `water_use_code == 16`:

| Parameter | Description |
|---|---|
| `livestock_duty` | Volume per livestock unit (acre-feet/ELU) |
| `stock_type` | Species code (1 = cow/horse, 2 = sheep/goat/swine, …, 7 = mink/fox) |
| `number_livestock` | Head count |
| `ELU` | Equivalent Livestock Unit — species-specific conversion factor |

The ELU table from the presentation:

| Stock type | ELU (acre-feet) |
|---|---|
| Cow or horse | 0.028 |
| Sheep, goat, swine, moose, or elk | 0.0056 |
| Ostrich or emu | 0.0036 |
| Llama | 0.0022 |
| Deer, antelope, bighorn sheep, or mountain goat | 0.0014 |
| Chicken, turkey, chukar, sagehen, or pheasant | 0.00084 |
| Mink or fox (caged) | 0.00005 |

None of these parameters exist in the model.  The `Cut_off()` formula uses:
`Maximum_Volume_Allowed = livestock_duty × ELU × number_livestock`.

---

### 1.9 Deep Aquifer (Source Type 4)
Slide 2 lists Source Types as:
1. Channel
2. Reservoir
3. Aquifer (shallow)
4. **Deep Aquifer**
5. External to watershed

SWAT+ has `aqu` (shallow, 1-D) and the optional `gwflow` (2-D MODFLOW-like module), but there
is no explicit **deep aquifer** source type with its own withdrawal dynamics.

---

## 2. Missing Algorithms

### 2.1 `Cut_off()` — Priority-Based Junior Right Curtailment (Slide 4)

This is the core prior-appropriation enforcement routine.  It is completely absent.

**Algorithm summary:**

```
1. For each use code, replace Maximum_Volume_Allowed with the duty-derived cap if smaller:
     Domestic   → Domestic_Duty × Family_Number
     Irrigation → Irrigation_Duty × Irrigation_Area
     Livestock  → Livestock_Duty × ELU × Number_Livestock

2. Sort all PODs by priority date (senior first → junior last).

3. For each POD_i that has Deficit > 0 (senior right not fully met):
     For each junior POD_j downstream of POD_i (check_if_upstream = True)
       that is not in a protected class (check_if_protected = False):
         If junior allocation ≤ remaining senior deficit:
             zero out the junior allocation entirely
             senior deficit -= junior allocation
         Else:
             reduce junior allocation by the senior deficit
             senior deficit = 0
             stop

4. Return the updated allocation list.
```

Supporting functions not yet present:
- `check_if_upstream(POD_j, POD_i)` — topology test on the channel network
- `check_if_protected(POD_j)` — checks whether a right type is exempt from curtailment
- Sorted POD list by priority date

---

### 2.2 Return Flow Routing (Slide 5)

The return-flow subroutine is entirely absent.  The logic required:

```
Group water_use_code into three return-flow categories:

  Category A (instream, stays in channel — no withdrawal taken):
    codes 1, 3, 10, 18, 21
    Return_Flow = 0  (water is already in-stream; no further action)

  Category B (agricultural/nature, partial infiltration + ET):
    codes 2, 8, 11, 14, 15, 23
    Return_Flow = Withdrawal × Return_Rate
    SWAT_flowout(day + return_delay, source_id) += Return_Flow
    # return_delay is measured in integer days

  Category C (human/industrial consumption, no return):
    codes 4, 5, 6, 7, 9, 12, 13, 16, 17, 19, 20, 22
    Return_Flow = 0
    # Note: code 21 (Power development) belongs to Category A, not here

  Optional Receiving_Source mode (Receiving_Source == 2):
    Return_Flow = Withdrawal  (entire volume returned)
    SWAT_flowout(day + return_delay, return_source_id) += Return_Flow
```

Missing implementation details:
- Delayed return-flow buffer (array indexed by future day).
- Return flow can go to a **different** object than the withdrawal source.
- Consumptive-use tracking = `Withdrawal - Return_Flow`.

---

### 2.3 Instream Flow Rights — Implement 2 (Slide 6)

Water use codes 3 ("Anadromous and resident fish habitat") and 18 ("Multiple instream uses")
represent **instream flow rights** — the water is reserved in the channel, not withdrawn.

The difference from a normal withdrawal:
- No water leaves the reach; the model simply enforces a minimum flow.
- The `Instream_Flow` variable (volume guaranteed to stay in channel) is tracked separately
  from `Withdrawal`.
- The associated `Deficit` tracks how often/how much the instream flow target was not met.

Currently the model has no water-use-code-gated instream reservation logic.

---

### 2.4 Livestock Withdrawal — Implement 5 (Slide 9)

Water use code 16 (Livestock) requires:
1. Computing daily demand as `(livestock_duty × ELU × number_livestock) / (end_date - start_date)`.
2. Applying the same channel-withdrawal logic as domestic or irrigation rights.

There is no livestock-specific demand path in `wallo_demand.f90` or `wallo_control.f90`.

---

### 2.5 Use-Code-Gated Operation Period Check

Every implement (Slides 3, 6, 7, 8, 9) gates withdrawals with:

```
if day >= start_date and day <= end_date:
    # proceed with withdrawal
```

There is no date-range gate in the current `wallo_control.f90` daily loop.  Transfers run
every day the simulation is active, regardless of the legal operation window.

---

## 3. Summary Table

| Feature | In model? | Note |
|---|---|---|
| Use type field on water-use object (`use_typ`) | ✅ | Added to `water_treatment_use_data`; read from `water_use.wal` col 2 |
| Use-type-driven simulation logic (demand, return flow, duty) | ❌ | Field stored but not yet acted upon |
| Water Use Code (23 OWRD categories) mapped to use_typ | ❌ | Mapping and branching logic not implemented |
| Priority Date (calendar date per right) | ❌ | Only sr/jr flag; no actual date |
| `Cut_off()` – priority sort + junior curtailment | ❌ | Entire algorithm missing |
| `check_if_upstream()` spatial check | ❌ | Required by Cut_off |
| `check_if_protected()` exemption check | ❌ | Required by Cut_off |
| Start / End Date of the water right | ❌ | No date-range gate |
| Maximum Volume Allowed (seasonal/annual cap) | ❌ | Only a fixed daily `amount` |
| Daily demand = Max_Vol / (end − start) | ❌ | Derived from missing params |
| Return Delay | ❌ | No delay buffer |
| Return Source (alternate receiving object) | ❌ | No field |
| Return Rate (%) | ❌ | No field |
| Return Flow routing by use-code category | ❌ | Entire sub-routine missing |
| Domestic Duty | ❌ | No field |
| Family Number | ❌ | No field |
| Irrigation Duty | ❌ | No field (irr_eff ≠ duty) |
| Irrigation Area (from certificate) | ❌ | No field |
| Livestock Duty | ❌ | No field |
| Stock Type | ❌ | No field |
| Number of Livestock | ❌ | No field |
| ELU (Equivalent Livestock Unit) | ❌ | No table or constant |
| Instream flow right (use codes 3, 18) | ❌ | No use-code distinction |
| Deep Aquifer source type (type 4) | ❌ | No explicit deep-aquifer type |
| Operation-period date gate per right | ❌ | Transfers run every simulated day |
