# Fertilizer Constituent Handling

This repository introduces utilities for reading and applying pesticide,
pathogen, salt, heavy‑metal and other constituent concentrations that are
associated with individual fertilizers.

## Reading constituent files

The helper subroutine `fert_constituent_file_read` resides in
`src/fert_constituent_file_read.f90`.  It reads a constituent file into an array
of `cs_fert_init_concentrations` objects:

```fortran
subroutine fert_constituent_file_read(file_name, imax, nconst, fert_arr, bulk)
```

- `file_name` – name of the `*.man` file (e.g. `pest.man`).
- `imax` – number of fertilizer types.
- `nconst` – number of constituents in the file.
- `fert_arr` – output array holding concentrations for each fertilizer.
- `bulk` (optional) – when `.true.`, the routine reads the entire set of
  constituent values from one record (used by salts and general constituents).

Each HRU‑specific reader (`pest_hru_aqu_read`, `path_hru_aqu_read`,
`hmet_hru_aqu_read`, `salt_hru_aqu_read`, and `cs_hru_read`) now calls this
routine instead of duplicating file‑parsing logic.  The corresponding arrays
`pest_fert_soil_ini`, `path_fert_soil_ini`, `hmet_fert_soil_ini`,
`salt_fert_soil_ini` and `cs_fert_soil_ini` are allocated and populated within
those readers.

## Applying constituents with fertilizers

`src/fert_constituents.f90` defines `fert_constituents_apply`, which is invoked
at the end of both `pl_fert` and `pl_fert_wet` fertilizer application routines:

```fortran
call fert_constituents_apply(j, ifrt, frt_kg, fertop)
```

The subroutine checks the extended fertilizer database (`fertdb_cbn`) for the
names of any associated pesticide, pathogen, salt, heavy‑metal, or other
constituent.  When a match is found, the routine multiplies the fertilizer mass
by the stored concentration from `*_fert_soil_ini` and distributes the resulting
load between plant and soil pools using the same rules as pesticide application
(`pest_apply`).

This design allows a fertilizer to automatically apply its associated
constituents whenever `pl_fert` or `pl_fert_wet` is executed.

## Summary of new files

- `src/fert_constituent_file_read.f90` – generic reader for fertilizer
  constituent tables.
- `src/fert_constituents.f90` – helper to apply constituent loads during a
  fertilizer event.
- Application and reader modules updated to use these routines.
