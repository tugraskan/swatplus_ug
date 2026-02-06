# vcr_coef Input File Source

## Question
Where is `vcr_coef` read in from, which input file does it come from?

## Answer

### Input File
**`vcr_coef`** (critical velocity coefficient) is read from the **`hyd-sed-lte.cha`** file.

### File Location
The filename is defined in `src/input_file_module.f90`:
```fortran
type input_cha
    ...
    character(len=25) :: hyd_sed = "hyd-sed-lte.cha"
    ...
end type input_cha
```

### Data Flow

1. **Reading**: The file is read in `src/sd_hydsed_read.f90` (subroutine `sd_hydsed_read`)
   - Line 30-35: Opens and reads from `in_cha%hyd_sed`
   - Line 61: Reads the entire `sd_chd(idb)` structure from the file

2. **Structure Definition**: `vcr_coef` is defined in `src/sd_channel_module.f90`
   - Line 182: Defined as part of the `swatdeg_channel_dynamic` type
   - Default value: 0.0
   - Units: m/m (dimensionless)
   - Description: critical velocity coefficient

3. **Initialization**: The value is assigned in `src/sd_hydsed_init.f90`
   - Line 88: `sd_ch(i)%vcr_coef = sd_chd(idb)%vcr_coef`

4. **Usage**: The coefficient is used in `src/sd_channel_sediment3.f90`
   - Line 170: `vel_cr = sd_ch(ich)%vcr_coef * vel_cr`
   - Used to adjust the critical velocity for bank erosion calculations

### File Format Note
The `hyd-sed-lte.cha` file contains channel hydrodynamic and sediment parameters. When Fortran reads the file using:
```fortran
read (1,*,iostat=eof) sd_chd(idb)
```
It reads all fields in the order they are defined in the `swatdeg_channel_dynamic` type structure. The `vcr_coef` field is positioned after `sinu` (sinuosity) and before `d50` (median sediment size) in the structure definition.

### Calibration
The `vcr_coef` parameter can also be modified during calibration via `src/cal_parm_select.f90`:
- Lines 622-624: Allows calibration adjustments to `sd_ch(ielem)%vcr_coef`
