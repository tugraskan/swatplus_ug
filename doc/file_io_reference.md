# SWAT+ Input/Output File Reference

This document catalogs all input and output files referenced in the SWAT+ source code,
identifies which subroutine each file is opened or written in, and cross-references
against a provided checklist of known files.

*Auto-generated from source code analysis.*

## Table of Contents

1. [Variable-to-Filename Mappings](#variable-to-filename-mappings)
2. [Input Files Referenced in Code](#input-files-referenced-in-code)
3. [Output Files Referenced in Code](#output-files-referenced-in-code)
4. [Other File References](#other-file-references)
5. [Files on Provided List NOT Found in Code](#files-on-provided-list-not-found-in-code)
6. [Files Found in Code NOT on Provided List](#files-found-in-code-not-on-provided-list)
7. [Summary](#summary)

## Variable-to-Filename Mappings

These are defined in `input_file_module.f90`. The variable names are used in `open()` calls
throughout the codebase. Default filenames can be overridden by `file.cio`.

| Variable | Default Filename | Status |
|----------|-----------------|--------|
| `in_aqu%aqu` | `aquifer.aqu` | active |
| `in_aqu%init` | `initial.aqu` | active |
| `in_basin%codes_bas` | `codes.bsn` | active |
| `in_basin%parms_bas` | `parameters.bsn` | active |
| `in_cha%chan_ez` | `channel-lte.cha` | active |
| `in_cha%dat` | `channel.cha` | active |
| `in_cha%hyd` | `hydrology.cha` | active |
| `in_cha%hyd_sed` | `hyd-sed-lte.cha` | active |
| `in_cha%init` | `initial.cha` | active |
| `in_cha%nut` | `nutrients.cha` | active |
| `in_cha%sed` | `sediment.cha` | active |
| `in_cha%temp` | `temperature.cha` | active |
| `in_chg%cal_parms` | `cal_parms.cal` | active |
| `in_chg%cal_upd` | `calibration.cal` | active |
| `in_chg%ch_sed_budget_sft` | `ch_sed_budget.sft` | active |
| `in_chg%ch_sed_parms_sft` | `ch_sed_parms.sft` | active |
| `in_chg%codes_sft` | `codes.sft` | active |
| `in_chg%plant_gro_sft` | `plant_gro.sft` | active |
| `in_chg%plant_parms_sft` | `plant_parms.sft` | active |
| `in_chg%water_balance_sft` | `water_balance.sft` | active |
| `in_chg%wb_parms_sft` | `wb_parms.sft` | active |
| `in_cli%atmo_cli` | `atmodep.cli` | active |
| `in_cli%hmd_cli` | `hmd.cli` | active |
| `in_cli%pcp_cli` | `pcp.cli` | active |
| `in_cli%pet_cli` | `pet.cli` | active |
| `in_cli%slr_cli` | `slr.cli` | active |
| `in_cli%tmp_cli` | `tmp.cli` | active |
| `in_cli%weat_sta` | `weather-sta.cli` | active |
| `in_cli%weat_wgn` | `weather-wgn.cli` | active |
| `in_cli%wind_dir` | `wind-dir.cli` | commented out |
| `in_cli%wnd_cli` | `wnd.cli` | active |
| `in_con%aqu2d_con` | `aquifer2d.con` | active |
| `in_con%aqu_con` | `aquifer.con` | active |
| `in_con%chan_con` | `channel.con` | active |
| `in_con%chandeg_con` | `chandeg.con` | active |
| `in_con%delr_con` | `delratio.con` | active |
| `in_con%exco_con` | `exco.con` | active |
| `in_con%gwflow_con` | `gwflow.con` | active |
| `in_con%hru_con` | `hru.con` | active |
| `in_con%hruez_con` | `hru-lte.con` | active |
| `in_con%out_con` | `outlet.con` | active |
| `in_con%rec_con` | `recall.con` | active |
| `in_con%res_con` | `reservoir.con` | active |
| `in_con%ru_con` | `rout_unit.con` | active |
| `in_cond%dtbl_flo` | `flo_con.dtl` | active |
| `in_cond%dtbl_lum` | `lum.dtl` | active |
| `in_cond%dtbl_res` | `res_rel.dtl` | active |
| `in_cond%dtbl_scen` | `scen_lu.dtl` | active |
| `in_delr%del_ratio` | `delratio.del` | active |
| `in_delr%hmet` | `dr_hmet.del` | active |
| `in_delr%om` | `dr_om.del` | active |
| `in_delr%path` | `dr_path.del` | active |
| `in_delr%pest` | `dr_pest.del` | active |
| `in_delr%salt` | `dr_salt.del` | active |
| `in_exco%exco` | `exco.exc` | active |
| `in_exco%hmet` | `exco_hmet.exc` | active |
| `in_exco%om` | `exco_om.exc` | active |
| `in_exco%path` | `exco_path.exc` | active |
| `in_exco%pest` | `exco_pest.exc` | active |
| `in_exco%salt` | `exco_salt.exc` | active |
| `in_herd%animal` | `animal.hrd` | active |
| `in_herd%herd` | `herd.hrd` | active |
| `in_herd%ranch` | `ranch.hrd` | active |
| `in_hru%hru_data` | `hru-data.hru` | active |
| `in_hru%hru_ez` | `hru-lte.hru` | active |
| `in_hyd%field_fld` | `field.fld` | active |
| `in_hyd%hydrol_hyd` | `hydrology.hyd` | active |
| `in_hyd%topogr_hyd` | `topography.hyd` | active |
| `in_init%hmet_soil` | `hmet_hru.ini` | active |
| `in_init%hmet_water` | `hmet_water.ini` | active |
| `in_init%om_water` | `om_water.ini` | active |
| `in_init%path_soil` | `path_hru.ini` | active |
| `in_init%path_water` | `path_water.ini` | active |
| `in_init%pest_soil` | `pest_hru.ini` | active |
| `in_init%pest_water` | `pest_water.ini` | active |
| `in_init%plant` | `plant.ini` | active |
| `in_init%salt_soil` | `salt_hru.ini` | active |
| `in_init%salt_water` | `salt_water.ini` | active |
| `in_init%soil_plant_ini` | `soil_plant.ini` | active |
| `in_link%aqu_cha` | `aqu_cha.lin` | active |
| `in_link%chan_surf` | `chan-surf.lin` | active |
| `in_lum%cntable_lum` | `cntable.lum` | active |
| `in_lum%cons_prac_lum` | `cons_practice.lum` | active |
| `in_lum%landuse_lum` | `landuse.lum` | active |
| `in_lum%management_sch` | `management.sch` | active |
| `in_lum%ovn_lum` | `ovn_table.lum` | active |
| `in_ops%chem_ops` | `chem_app.ops` | active |
| `in_ops%fire_ops` | `fire.ops` | active |
| `in_ops%graze_ops` | `graze.ops` | active |
| `in_ops%harv_ops` | `harv.ops` | active |
| `in_ops%irr_ops` | `irr.ops` | active |
| `in_ops%sweep_ops` | `sweep.ops` | active |
| `in_parmdb%fert_frt` | `fertilizer.frt` | active |
| `in_parmdb%hmetcom_db` | `metals.mtl` | active |
| `in_parmdb%pathcom_db` | `pathogens.pth` | active |
| `in_parmdb%pest` | `pesticide.pes` | active |
| `in_parmdb%plants_plt` | `plants.plt` | active |
| `in_parmdb%saltcom_db` | `salt.slt` | active |
| `in_parmdb%septic_sep` | `septic.sep` | active |
| `in_parmdb%snow` | `snow.sno` | active |
| `in_parmdb%till_til` | `tillage.til` | active |
| `in_parmdb%urban_urb` | `urban.urb` | active |
| `in_path_hmd%hmd` | ` ` | active |
| `in_path_pcp%pcp` | ` ` | active |
| `in_path_pet%peti` | ` ` | active |
| `in_path_slr%slr` | ` ` | active |
| `in_path_tmp%tmp` | ` ` | active |
| `in_path_wnd%wnd` | ` ` | active |
| `in_rec%recall_rec` | `recall.rec` | active |
| `in_regs%cal_lcu` | `ls_cal.reg` | active |
| `in_regs%def_aqu` | `aqu_catunit.def` | active |
| `in_regs%def_aqu_reg` | `aqu_reg.def` | active |
| `in_regs%def_cha` | `ch_catunit.def` | active |
| `in_regs%def_cha_reg` | `ch_reg.def` | active |
| `in_regs%def_lsu` | `ls_unit.def` | active |
| `in_regs%def_psc` | `rec_catunit.def` | active |
| `in_regs%def_psc_reg` | `rec_reg.def` | active |
| `in_regs%def_reg` | `ls_reg.def` | active |
| `in_regs%def_res` | `res_catunit.def` | active |
| `in_regs%def_res_reg` | `res_reg.def` | active |
| `in_regs%ele_aqu` | `aqu_catunit.ele` | active |
| `in_regs%ele_cha` | `ch_catunit.ele` | active |
| `in_regs%ele_lsu` | `ls_unit.ele` | active |
| `in_regs%ele_psc` | `rec_catunit.ele` | active |
| `in_regs%ele_reg` | `ls_reg.ele` | active |
| `in_regs%ele_res` | `res_catunit.ele` | active |
| `in_res%hyd_res` | `hydrology.res` | active |
| `in_res%hyd_wet` | `hydrology.wet` | active |
| `in_res%init_res` | `initial.res` | active |
| `in_res%nut_res` | `nutrients.res` | active |
| `in_res%res` | `reservoir.res` | active |
| `in_res%sed_res` | `sediment.res` | active |
| `in_res%weir_res` | `weir.res` | active |
| `in_res%wet` | `wetland.wet` | active |
| `in_ru%ru` | `rout_unit.rtu` | active |
| `in_ru%ru_def` | `rout_unit.def` | active |
| `in_ru%ru_dr` | `rout_unit.dr` | active |
| `in_ru%ru_ele` | `rout_unit.ele` | active |
| `in_sim%cs_db` | `constituents.cs` | active |
| `in_sim%object_cnt` | `object.cnt` | active |
| `in_sim%object_prt` | `object.prt` | active |
| `in_sim%prt` | `print.prt` | active |
| `in_sim%time` | `time.sim` | active |
| `in_sol%lte_sol` | `soils_lte.sol` | active |
| `in_sol%nut_sol` | `nutrients.sol` | active |
| `in_sol%soils_sol` | `soils.sol` | active |
| `in_str%bmpuser_str` | `bmpuser.str` | active |
| `in_str%fstrip_str` | `filterstrip.str` | active |
| `in_str%grassww_str` | `grassedww.str` | active |
| `in_str%septic_str` | `septic.str` | active |
| `in_str%tiledrain_str` | `tiledrain.str` | active |
| `in_watrts%element` | `element.wro` | active |
| `in_watrts%transfer_wro` | `water_allocation.wro` | active |
| `in_watrts%water_rights` | `water_rights.wro` | active |

## Input Files Referenced in Code

### `animal.hrd` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 136 | string reference |

### `aqu_catunit.def` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `aqu_read_elements.f90` | `subroutine aqu_read_elements` | 36 | open (via in_regs%def_aqu) |
| `aqu_read_elements.f90` | `subroutine aqu_read_elements` | 89 | open (via in_regs%def_aqu) |
| `input_file_module.f90` | `module input_file_module` | 269 | string reference |

### `aqu_catunit.ele` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `aqu_read_elements.f90` | `subroutine aqu_read_elements` | 149 | open (via in_regs%ele_aqu) |
| `input_file_module.f90` | `module input_file_module` | 268 | string reference |

### `aqu_cha.lin` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `aqu2d_read.f90` | `subroutine aqu2d_read` | 35 | open (via in_link%aqu_cha) |
| `aqu_1d_control.f90` | `subroutine aqu_1d_control` | 184 | string reference |
| `aqu_1d_control.f90` | `subroutine aqu_1d_control` | 232 | string reference |
| `input_file_module.f90` | `module input_file_module` | 153 | string reference |

### `aqu_reg.def` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 270 | string reference |

### `aquifer.aqu` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `aqu_read.f90` | `subroutine aqu_read` | 30 | open (via in_aqu%aqu) |
| `input_file_module.f90` | `module input_file_module` | 130 | string reference |

### `aquifer.con` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 45 | string reference |

### `aquifer2d.con` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 46 | string reference |

### `atmodep.cli` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `cli_read_atmodep.f90` | `subroutine cli_read_atmodep` | 31 | open (via in_cli%atmo_cli) |
| `input_file_module.f90` | `module input_file_module` | 35 | string reference |

### `basins_carbon.tes` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `carbon_read.f90` | `subroutine carbon_read` | 22 | open |

### `bmpuser.str` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 171 | string reference |
| `scen_read_bmpuser.f90` | `subroutine scen_read_bmpuser` | 24 | open (via in_str%bmpuser_str) |

### `cal_parms.cal` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `cal_parm_read.f90` | `subroutine cal_parm_read` | 30 | open (via in_chg%cal_parms) |
| `input_file_module.f90` | `module input_file_module` | 213 | string reference |

### `calibration.cal` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `cal_parmchg_read.f90` | `subroutine cal_parmchg_read` | 57 | open (via in_chg%cal_upd) |
| `input_file_module.f90` | `module input_file_module` | 214 | string reference |

### `carb_coefs.cbn` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `carbon_coef_read.f90` | `subroutine carbon_coef_read` | 25 | open |

### `ch_catunit.def` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `ch_read_elements.f90` | `subroutine ch_read_elements` | 36 | open (via in_regs%def_cha) |
| `input_file_module.f90` | `module input_file_module` | 266 | string reference |

### `ch_catunit.ele` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 265 | string reference |

### `ch_reg.def` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `ch_read_elements.f90` | `subroutine ch_read_elements` | 85 | open (via in_regs%def_cha_reg) |
| `input_file_module.f90` | `module input_file_module` | 267 | string reference |

### `ch_sed_budget.sft` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `ch_read_orders_cal.f90` | `subroutine ch_read_orders_cal` | 40 | open (via in_chg%ch_sed_budget_sft) |
| `input_file_module.f90` | `module input_file_module` | 218 | string reference |

### `ch_sed_parms.sft` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `ch_read_parms_cal.f90` | `subroutine ch_read_parms_cal` | 22 | open (via in_chg%ch_sed_parms_sft) |
| `input_file_module.f90` | `module input_file_module` | 219 | string reference |

### `chan-surf.lin` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 152 | string reference |
| `overbank_read.f90` | `subroutine overbank_read` | 31 | open (via in_link%chan_surf) |

### `chandeg.con` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 53 | string reference |

### `channel-lte.cha` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 64 | string reference |
| `sd_channel_read.f90` | `subroutine sd_channel_read` | 194 | open (via in_cha%chan_ez) |

### `channel.cha` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `ch_read.f90` | `subroutine ch_read` | 38 | open (via in_cha%dat) |
| `input_file_module.f90` | `module input_file_module` | 60 | string reference |

### `channel.con` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 47 | string reference |

### `chem_app.ops` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 195 | string reference |
| `mgt_read_chemapp.f90` | `subroutine mgt_read_chemapp` | 25 | open (via in_ops%chem_ops) |

### `cntable.lum` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `cntbl_read.f90` | `subroutine cntbl_read` | 25 | open (via in_lum%cntable_lum) |
| `input_file_module.f90` | `module input_file_module` | 205 | string reference |

### `co2_yr.dat` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `co2_read.f90` | `subroutine co2_read` | 41 | string reference |
| `co2_read.f90` | `subroutine co2_read` | 42 | string reference |
| `co2_read.f90` | `subroutine co2_read` | 45 | open |

### `codes.bsn` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `basin_read_cc.f90` | `subroutine basin_read_cc` | 19 | open (via in_basin%codes_bas) |
| `input_file_module.f90` | `module input_file_module` | 19 | string reference |

### `codes.sft` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `calsoft_read_codes.f90` | `subroutine calsoft_read_codes` | 29 | open (via in_chg%codes_sft) |
| `input_file_module.f90` | `module input_file_module` | 215 | string reference |

### `cons_practice.lum` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `cons_prac_read.f90` | `subroutine cons_prac_read` | 25 | open (via in_lum%cons_prac_lum) |
| `input_file_module.f90` | `module input_file_module` | 206 | string reference |

### `constituents.cs` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `constit_db_read.f90` | `subroutine constit_db_read` | 33 | open (via in_sim%cs_db) |

### `cs_aqu.ini` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `cs_aqu_read.f90` | `subroutine cs_aqu_read` | 20 | string reference |
| `cs_aqu_read.f90` | `subroutine cs_aqu_read` | 21 | string reference |
| `cs_aqu_read.f90` | `subroutine cs_aqu_read` | 23 | open |

### `cs_atmo.cli` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `cli_read_atmodep_cs.f90` | `subroutine cli_read_atmodep_cs` | 27 | string reference |
| `cli_read_atmodep_cs.f90` | `subroutine cli_read_atmodep_cs` | 32 | open |

### `cs_channel.ini` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `cs_cha_read.f90` | `subroutine cs_cha_read` | 25 | string reference |
| `cs_cha_read.f90` | `subroutine cs_cha_read` | 26 | string reference |
| `cs_cha_read.f90` | `subroutine cs_cha_read` | 28 | open |

### `cs_hru.ini` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `cs_hru_read.f90` | `subroutine cs_hru_read` | 20 | string reference |
| `cs_hru_read.f90` | `subroutine cs_hru_read` | 21 | string reference |
| `cs_hru_read.f90` | `subroutine cs_hru_read` | 23 | open |

### `cs_irrigation` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `cs_irr_read.f90` | `subroutine cs_irr_read` | 24 | open |

### `cs_plants_boron` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `cs_plant_read.f90` | `subroutine cs_plant_read` | 22 | open |

### `cs_reactions` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `cs_reactions_read.f90` | `subroutine cs_reactions_read` | 34 | open |

### `cs_recall.rec` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `recall_read_cs.f90` | `subroutine recall_read_cs` | 40 | string reference |
| `recall_read_cs.f90` | `subroutine recall_read_cs` | 43 | open |

### `cs_res` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `res_read_csdb.f90` | `subroutine res_read_csdb` | 29 | open |

### `cs_streamobs` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `cs_cha_read.f90` | `subroutine cs_cha_read` | 66 | open |

### `cs_streamobs_output` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `cs_cha_read.f90` | `subroutine cs_cha_read` | 74 | open |

### `cs_uptake` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `cs_uptake_read.f90` | `subroutine cs_uptake_read` | 36 | open |

### `cs_urban` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `cs_urban_read.f90` | `subroutine cs_urban_read` | 28 | open |

### `delratio.con` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 51 | string reference |

### `delratio.del` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `dr_db_read.f90` | `subroutine dr_db_read` | 25 | open (via in_delr%del_ratio) |
| `input_file_module.f90` | `module input_file_module` | 118 | string reference |

### `dr_hmet.del` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `dr_read_hmet.f90` | `subroutine dr_read_hmet` | 33 | open (via in_delr%hmet) |
| `input_file_module.f90` | `module input_file_module` | 122 | string reference |

### `dr_om.del` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `dr_read_om.f90` | `subroutine dr_read_om` | 32 | open (via in_delr%om) |
| `input_file_module.f90` | `module input_file_module` | 119 | string reference |

### `dr_path.del` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `dr_path_read.f90` | `subroutine dr_path_read` | 32 | open (via in_delr%path) |
| `input_file_module.f90` | `module input_file_module` | 121 | string reference |

### `dr_pest.del` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `dr_read_pest.f90` | `subroutine dr_read_pest` | 32 | open (via in_delr%pest) |
| `input_file_module.f90` | `module input_file_module` | 120 | string reference |

### `dr_salt.del` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `dr_read_salt.f90` | `subroutine dr_read_salt` | 32 | open (via in_delr%salt) |
| `input_file_module.f90` | `module input_file_module` | 123 | string reference |

### `element.ccu` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `ch_read_elements.f90` | `subroutine ch_read_elements` | 145 | open |

### `element.wro` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 145 | string reference |

### `exco.con` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 50 | string reference |

### `exco.exc` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `exco_db_read.f90` | `subroutine exco_db_read` | 25 | open (via in_exco%exco) |
| `input_file_module.f90` | `module input_file_module` | 101 | string reference |

### `exco_hmet.exc` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `exco_read_hmet.f90` | `subroutine exco_read_hmet` | 32 | open (via in_exco%hmet) |
| `input_file_module.f90` | `module input_file_module` | 105 | string reference |

### `exco_om.exc` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `exco_read_om.f90` | `subroutine exco_read_om` | 31 | open (via in_exco%om) |
| `input_file_module.f90` | `module input_file_module` | 102 | string reference |

### `exco_path.exc` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `exco_read_path.f90` | `subroutine exco_read_path` | 32 | open (via in_exco%path) |
| `input_file_module.f90` | `module input_file_module` | 104 | string reference |

### `exco_pest.exc` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `exco_read_pest.f90` | `subroutine exco_read_pest` | 31 | open (via in_exco%pest) |
| `input_file_module.f90` | `module input_file_module` | 103 | string reference |

### `exco_salt.exc` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `exco_read_salt.f90` | `subroutine exco_read_salt` | 32 | open (via in_exco%salt) |
| `input_file_module.f90` | `module input_file_module` | 106 | string reference |

### `fertilizer.frt` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `fert_parm_read.f90` | `subroutine fert_parm_read` | 27 | open (via in_parmdb%fert_frt) |
| `input_file_module.f90` | `module input_file_module` | 178 | string reference |

### `fertilizer.frt_cs` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `cs_fert_read.f90` | `subroutine cs_fert_read` | 25 | open |

### `field.fld` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `field_read.f90` | `subroutine field_read` | 25 | open (via in_hyd%field_fld) |
| `input_file_module.f90` | `module input_file_module` | 161 | string reference |

### `file.cio` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `readcio_read.f90` | `subroutine readcio_read` | 20 | string reference |
| `readcio_read.f90` | `subroutine readcio_read` | 22 | open |

### `filterstrip.str` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 169 | string reference |
| `scen_read_filtstrip.f90` | `subroutine scen_read_filtstrip` | 25 | open (via in_str%fstrip_str) |

### `fire.ops` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 196 | string reference |
| `mgt_read_fireops.f90` | `subroutine mgt_read_fireops` | 25 | open (via in_ops%fire_ops) |

### `flo_con.dtl` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `dtbl_flocon_read.f90` | `subroutine dtbl_flocon_read` | 31 | open (via in_cond%dtbl_flo) |
| `input_file_module.f90` | `module input_file_module` | 254 | string reference |

### `grassedww.str` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 170 | string reference |
| `scen_read_grwway.f90` | `subroutine scen_read_grwway` | 25 | open (via in_str%grassww_str) |

### `graze.ops` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 193 | string reference |
| `mgt_read_grazeops.f90` | `subroutine mgt_read_grazeops` | 29 | open (via in_ops%graze_ops) |

### `gwflow.canals` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `gwflow_read.f90` | `subroutine gwflow_read` | 1188 | open |

### `gwflow.cellhru` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `gwflow_read.f90` | `subroutine gwflow_read` | 1862 | open |

### `gwflow.chancells` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `basin_read_objs.f90` | `subroutine basin_read_objs` | 52 | open |
| `gwflow_chan_read.f90` | `subroutine gwflow_chan_read` | 31 | open |

### `gwflow.con` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `basin_read_objs.f90` | `subroutine basin_read_objs` | 69 | string reference |
| `gwflow_chan_read.f90` | `subroutine gwflow_chan_read` | 32 | open |
| `input_file_module.f90` | `module input_file_module` | 44 | string reference |

### `gwflow.floodplain` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `gwflow_read.f90` | `subroutine gwflow_read` | 1128 | open |

### `gwflow.hru_pump_observe` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `gwflow_read.f90` | `subroutine gwflow_read` | 925 | open |

### `gwflow.hrucell` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `gwflow_read.f90` | `subroutine gwflow_read` | 1748 | open |

### `gwflow.huc12cell` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `gwflow_read.f90` | `subroutine gwflow_read` | 1801 | open |

### `gwflow.input` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `gwflow_read.f90` | `subroutine gwflow_read` | 165 | open |

### `gwflow.lsucell` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `gwflow_read.f90` | `subroutine gwflow_read` | 1667 | open |

### `gwflow.pumpex` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `gwflow_read.f90` | `subroutine gwflow_read` | 945 | open |

### `gwflow.rescells` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `gwflow_read.f90` | `subroutine gwflow_read` | 1057 | open |

### `gwflow.solutes` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `gwflow_read.f90` | `subroutine gwflow_read` | 1351 | open |

### `gwflow.solutes.minerals` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `gwflow_read.f90` | `subroutine gwflow_read` | 1439 | open |

### `gwflow.streamobs` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `gwflow_read.f90` | `subroutine gwflow_read` | 2380 | open |

### `gwflow.tiles` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `gwflow_read.f90` | `subroutine gwflow_read` | 983 | open |

### `gwflow.wetland` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `wet_read_hyd.f90` | `subroutine wet_read_hyd` | 72 | open |

### `gwflow_balance_gw_aa` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `gwflow_read.f90` | `subroutine gwflow_read` | 1975 | open |

### `gwflow_balance_gw_day` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `gwflow_read.f90` | `subroutine gwflow_read` | 1903 | open |

### `gwflow_balance_gw_yr` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `gwflow_read.f90` | `subroutine gwflow_read` | 1942 | open |

### `gwflow_balance_huc12` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `gwflow_read.f90` | `subroutine gwflow_read` | 2009 | open |

### `gwflow_balance_huc12_mon` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `gwflow_read.f90` | `subroutine gwflow_read` | 2037 | open |

### `gwflow_flux_canl` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `gwflow_read.f90` | `subroutine gwflow_read` | 1334 | open |

### `gwflow_flux_floodplain` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `gwflow_read.f90` | `subroutine gwflow_read` | 1175 | open |

### `gwflow_flux_gwet` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `gwflow_read.f90` | `subroutine gwflow_read` | 789 | open |

### `gwflow_flux_gwsw` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `gwflow_read.f90` | `subroutine gwflow_read` | 807 | open |

### `gwflow_flux_ppag` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `gwflow_read.f90` | `subroutine gwflow_read` | 901 | open |

### `gwflow_flux_ppex` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `gwflow_read.f90` | `subroutine gwflow_read` | 970 | open |

### `gwflow_flux_pumping_deficient` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `gwflow_read.f90` | `subroutine gwflow_read` | 904 | open |

### `gwflow_flux_pumping_hru_mo` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `gwflow_read.f90` | `subroutine gwflow_read` | 920 | open |

### `gwflow_flux_pumping_hru_obs` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `gwflow_read.f90` | `subroutine gwflow_read` | 934 | open |

### `gwflow_flux_pumping_hru_yr` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `gwflow_read.f90` | `subroutine gwflow_read` | 917 | open |

### `gwflow_flux_reaction` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `gwflow_read.f90` | `subroutine gwflow_read` | 1645 | open |

### `gwflow_flux_rech` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `gwflow_read.f90` | `subroutine gwflow_read` | 781 | open |

### `gwflow_flux_resv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `gwflow_read.f90` | `subroutine gwflow_read` | 1103 | open |

### `gwflow_flux_satx` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `gwflow_read.f90` | `subroutine gwflow_read` | 894 | open |

### `gwflow_flux_soil` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `gwflow_read.f90` | `subroutine gwflow_read` | 839 | open |

### `gwflow_flux_tile` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `gwflow_read.f90` | `subroutine gwflow_read` | 1045 | open |

### `gwflow_flux_wetland` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `gwflow_read.f90` | `subroutine gwflow_read` | 1117 | open |

### `gwflow_mass_canl` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `gwflow_read.f90` | `subroutine gwflow_read` | 1641 | open |

### `gwflow_mass_fpln` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `gwflow_read.f90` | `subroutine gwflow_read` | 1636 | open |

### `gwflow_mass_gwsw` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `gwflow_read.f90` | `subroutine gwflow_read` | 1597 | open |

### `gwflow_mass_ppag` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `gwflow_read.f90` | `subroutine gwflow_read` | 1612 | open |

### `gwflow_mass_ppex` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `gwflow_read.f90` | `subroutine gwflow_read` | 1616 | open |

### `gwflow_mass_rech` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `gwflow_read.f90` | `subroutine gwflow_read` | 1590 | open |

### `gwflow_mass_resv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `gwflow_read.f90` | `subroutine gwflow_read` | 1626 | open |

### `gwflow_mass_satx` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `gwflow_read.f90` | `subroutine gwflow_read` | 1608 | open |

### `gwflow_mass_soil` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `gwflow_read.f90` | `subroutine gwflow_read` | 1601 | open |

### `gwflow_mass_tile` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `gwflow_read.f90` | `subroutine gwflow_read` | 1621 | open |

### `gwflow_mass_wetl` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `gwflow_read.f90` | `subroutine gwflow_read` | 1631 | open |

### `gwflow_record` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `basin_read_objs.f90` | `subroutine basin_read_objs` | 85 | open |

### `gwflow_state_conc` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `gwflow_read.f90` | `subroutine gwflow_read` | 2333 | open |

### `gwflow_state_conc_mo` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `gwflow_read.f90` | `subroutine gwflow_read` | 2368 | open |

### `gwflow_state_conc_yr` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `gwflow_read.f90` | `subroutine gwflow_read` | 2369 | open |

### `gwflow_state_head` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `gwflow_read.f90` | `subroutine gwflow_read` | 2314 | open |

### `gwflow_state_head_mo` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `gwflow_read.f90` | `subroutine gwflow_read` | 2358 | open |

### `gwflow_state_head_yr` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `gwflow_read.f90` | `subroutine gwflow_read` | 2359 | open |

### `gwflow_state_hydsep` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `gwflow_read.f90` | `subroutine gwflow_read` | 2413 | open |

### `gwflow_state_obs_conc` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `gwflow_read.f90` | `subroutine gwflow_read` | 1648 | open |

### `gwflow_state_obs_flow` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `gwflow_read.f90` | `subroutine gwflow_read` | 2381 | open |

### `gwflow_state_obs_head` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `gwflow_read.f90` | `subroutine gwflow_read` | 650 | open |

### `gwflow_state_obs_head_usgs` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `gwflow_read.f90` | `subroutine gwflow_read` | 695 | open |

### `gwflow_tile_cell_groups` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `gwflow_read.f90` | `subroutine gwflow_read` | 1001 | open |

### `harv.ops` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 192 | string reference |
| `mgt_read_harvops.f90` | `subroutine mgt_read_harvops` | 25 | open (via in_ops%harv_ops) |

### `herd.hrd` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 137 | string reference |

### `hmd.cli` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `cli_hmeas.f90` | `subroutine cli_hmeas` | 31 | open (via in_cli%hmd_cli) |
| `input_file_module.f90` | `module input_file_module` | 33 | string reference |

### `hmet_hru.ini` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `hmet_hru_aqu_read.f90` | `subroutine hmet_hru_aqu_read` | 24 | open (via in_init%hmet_soil) |
| `input_file_module.f90` | `module input_file_module` | 234 | string reference |

### `hmet_water.ini` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 235 | string reference |

### `hru-data.hru` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `hru_read.f90` | `subroutine hru_read` | 44 | open (via in_hru%hru_data) |
| `input_file_module.f90` | `module input_file_module` | 94 | string reference |

### `hru-lte.con` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 42 | string reference |

### `hru-lte.hru` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `hru_lte_read.f90` | `subroutine hru_lte_read` | 74 | open (via in_hru%hru_ez) |
| `input_file_module.f90` | `module input_file_module` | 95 | string reference |

### `hru-new.cal` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_write.f90` | `subroutine header_write` | 34 | open |

### `hru-out.cal` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_write.f90` | `subroutine header_write` | 25 | open |

### `hru.con` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `gwflow_read.f90` | `subroutine gwflow_read` | 1725 | open (via in_con%hru_con) |
| `input_file_module.f90` | `module input_file_module` | 41 | string reference |

### `hyd-sed-lte.cha` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 65 | string reference |
| `sd_hydsed_read.f90` | `subroutine sd_hydsed_read` | 35 | open (via in_cha%hyd_sed) |

### `hydrology-cal.hyd` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_write.f90` | `subroutine header_write` | 40 | open |

### `hydrology.cha` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `ch_read_hyd.f90` | `subroutine ch_read_hyd` | 25 | open (via in_cha%hyd) |
| `input_file_module.f90` | `module input_file_module` | 61 | string reference |

### `hydrology.hyd` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `hydrol_read.f90` | `subroutine hydrol_read` | 27 | open (via in_hyd%hydrol_hyd) |
| `input_file_module.f90` | `module input_file_module` | 159 | string reference |

### `hydrology.res` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 74 | string reference |
| `res_read_hyd.f90` | `subroutine res_read_hyd` | 25 | open (via in_res%hyd_res) |

### `hydrology.wet` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 79 | string reference |
| `wet_read_hyd.f90` | `subroutine wet_read_hyd` | 28 | open (via in_res%hyd_wet) |

### `initial.aqu` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `aqu_read_init.f90` | `subroutine aqu_read_init` | 32 | open (via in_aqu%init) |
| `input_file_module.f90` | `module input_file_module` | 129 | string reference |

### `initial.aqu_cs` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `aqu_read_init_cs.f90` | `subroutine aqu_read_init_cs` | 42 | open |

### `initial.cha` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `ch_read_init.f90` | `subroutine ch_read_init` | 27 | open (via in_cha%init) |
| `input_file_module.f90` | `module input_file_module` | 59 | string reference |

### `initial.cha_cs` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `ch_read_init_cs.f90` | `subroutine ch_read_init_cs` | 27 | open |

### `initial.res` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 72 | string reference |
| `res_read_init.f90` | `subroutine res_read_init` | 27 | open (via in_res%init_res) |

### `irr.ops` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 194 | string reference |
| `mgt_read_irrops.f90` | `subroutine mgt_read_irrops` | 28 | open (via in_ops%irr_ops) |

### `landuse.lum` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 203 | string reference |
| `landuse_read.f90` | `subroutine landuse_read` | 35 | open (via in_lum%landuse_lum) |

### `looping.con` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `hyd_connect.f90` | `subroutine hyd_connect` | 418 | open |

### `ls_cal.reg` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 264 | string reference |

### `ls_reg.def` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 263 | string reference |
| `reg_read_elements.f90` | `subroutine reg_read_elements` | 42 | open (via in_regs%def_reg) |

### `ls_reg.ele` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 262 | string reference |
| `reg_read_elements.f90` | `subroutine reg_read_elements` | 133 | open (via in_regs%ele_reg) |

### `ls_unit.def` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 261 | string reference |
| `lsu_read_elements.f90` | `subroutine lsu_read_elements` | 34 | open (via in_regs%def_lsu) |

### `ls_unit.ele` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 260 | string reference |
| `lsu_read_elements.f90` | `subroutine lsu_read_elements` | 101 | open (via in_regs%ele_lsu) |

### `lum.dtl` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `dtbl_lum_read.f90` | `subroutine dtbl_lum_read` | 41 | open (via in_cond%dtbl_lum) |
| `input_file_module.f90` | `module input_file_module` | 251 | string reference |

### `management.sch` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `mgt_read_mgtops.f90` | `subroutine mgt_read_mgtops` | 33 | open (via in_lum%management_sch) |

### `manure.frt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `manure_parm_read.f90` | `subroutine manure_parm_read` | 22 | string reference |
| `manure_parm_read.f90` | `subroutine manure_parm_read` | 23 | string reference |
| `manure_parm_read.f90` | `subroutine manure_parm_read` | 27 | open |

### `manure_allo.mnu` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `manure_allocation_read.f90` | `subroutine manure_allocation_read` | 39 | open |

### `metals.mtl` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 182 | string reference |

### `nutrients.cha` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `ch_read_nut.f90` | `subroutine ch_read_nut` | 33 | open (via in_cha%nut) |
| `input_file_module.f90` | `module input_file_module` | 63 | string reference |

### `nutrients.res` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 76 | string reference |
| `res_read_nut.f90` | `subroutine res_read_nut` | 31 | open (via in_res%nut_res) |

### `nutrients.rte` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `rte_read_nut.f90` | `subroutine rte_read_nut` | 29 | open |

### `nutrients.sol` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 244 | string reference |
| `solt_db_read.f90` | `subroutine solt_db_read` | 27 | open (via in_sol%nut_sol) |

### `object.cnt` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `basin_read_objs.f90` | `subroutine basin_read_objs` | 33 | open (via in_sim%object_cnt) |
| `input_file_module.f90` | `module input_file_module` | 12 | string reference |

### `object.prt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 11 | string reference |
| `object_read_output.f90` | `subroutine object_read_output` | 28 | open (via in_sim%object_prt) |

### `om_osrc.wal` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `om_osrc_read.f90` | `subroutine om_osrc_read` | 31 | open |

### `om_treat.wal` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `om_treat_read.f90` | `subroutine om_treat_read` | 30 | open |

### `om_use.wal` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `om_use_read.f90` | `subroutine om_use_read` | 30 | open |

### `om_water.ini` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 229 | string reference |
| `om_water_init.f90` | `subroutine om_water_init` | 29 | open (via in_init%om_water) |

### `outlet.con` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 52 | string reference |

### `outside_src.wal` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `water_osrc_read.f90` | `subroutine water_osrc_read` | 34 | open |

### `ovn_table.lum` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 207 | string reference |
| `overland_n_read.f90` | `subroutine overland_n_read` | 24 | open (via in_lum%ovn_lum) |

### `parameters.bsn` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `basin_read_prm.f90` | `subroutine basin_read_prm` | 19 | open (via in_basin%parms_bas) |
| `input_file_module.f90` | `module input_file_module` | 20 | string reference |

### `path_hru.ini` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 232 | string reference |
| `path_hru_aqu_read.f90` | `subroutine path_hru_aqu_read` | 23 | open (via in_init%path_soil) |

### `path_water.ini` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 233 | string reference |
| `path_cha_res_read.f90` | `subroutine path_cha_res_read` | 27 | open (via in_init%path_water) |

### `pathogens.pth` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 181 | string reference |
| `path_parm_read.f90` | `subroutine path_parm_read` | 25 | open (via in_parmdb%pathcom_db) |

### `pcp.cli` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `cli_pmeas.f90` | `subroutine cli_pmeas` | 38 | open (via in_cli%pcp_cli) |
| `input_file_module.f90` | `module input_file_module` | 30 | string reference |

### `pest.com` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `recall_read.f90` | `subroutine recall_read` | 269 | open |

### `pest_hru.ini` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 230 | string reference |
| `pest_hru_aqu_read.f90` | `subroutine pest_hru_aqu_read` | 23 | open (via in_init%pest_soil) |

### `pest_metabolite.pes` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `pest_metabolite_read.f90` | `subroutine pest_metabolite_read` | 26 | string reference |
| `pest_metabolite_read.f90` | `subroutine pest_metabolite_read` | 29 | open |

### `pest_water.ini` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 231 | string reference |
| `pest_cha_res_read.f90` | `subroutine pest_cha_res_read` | 27 | open (via in_init%pest_water) |

### `pesticide.pes` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 180 | string reference |
| `pest_parm_read.f90` | `subroutine pest_parm_read` | 27 | open (via in_parmdb%pest) |

### `pet.cli` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `basin_read_cc.f90` | `subroutine basin_read_cc` | 31 | open |
| `cli_petmeas.f90` | `subroutine cli_petmeas` | 32 | open (via in_cli%pet_cli) |
| `input_file_module.f90` | `module input_file_module` | 28 | string reference |

### `plant.ini` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 227 | string reference |
| `readpcom.f90` | `subroutine readpcom` | 36 | open (via in_init%plant) |

### `plant_gro.sft` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 221 | string reference |
| `pl_read_regions_cal.f90` | `subroutine pl_read_regions_cal` | 38 | open (via in_chg%plant_gro_sft) |

### `plant_parms.cal` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `pl_write_parms_cal.f90` | `subroutine pl_write_parms_cal` | 20 | open |

### `plant_parms.sft` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 220 | string reference |
| `pl_read_parms_cal.f90` | `subroutine pl_read_parms_cal` | 37 | open (via in_chg%plant_parms_sft) |

### `plants.plt` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 177 | string reference |
| `plant_parm_read.f90` | `subroutine plant_parm_read` | 34 | open (via in_parmdb%plants_plt) |

### `print.prt` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `basin_print_codes_read.f90` | `subroutine basin_print_codes_read` | 23 | open (via in_sim%prt) |
| `input_file_module.f90` | `module input_file_module` | 10 | string reference |

### `puddle.ops` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `mgt_read_puddle.f90` | `subroutine mgt_read_puddle` | 18 | string reference |
| `mgt_read_puddle.f90` | `subroutine mgt_read_puddle` | 19 | string reference |
| `mgt_read_puddle.f90` | `subroutine mgt_read_puddle` | 23 | open |

### `ranch.hrd` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 138 | string reference |

### `rec_catunit.def` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 275 | string reference |
| `rec_read_elements.f90` | `subroutine rec_read_elements` | 33 | open (via in_regs%def_psc) |

### `rec_catunit.ele` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 274 | string reference |
| `rec_read_elements.f90` | `subroutine rec_read_elements` | 136 | open (via in_regs%ele_psc) |

### `rec_reg.def` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 276 | string reference |
| `rec_read_elements.f90` | `subroutine rec_read_elements` | 83 | open (via in_regs%def_psc_reg) |

### `recall.con` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 49 | string reference |

### `recall.rec` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 112 | string reference |
| `recall_read.f90` | `subroutine recall_read` | 113 | open (via in_rec%recall_rec) |

### `recall_db.rec` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `recall_read.f90` | `subroutine recalldb_read` | 19 | string reference |
| `recall_read.f90` | `subroutine recalldb_read` | 20 | string reference |
| `recall_read.f90` | `subroutine recalldb_read` | 22 | open |

### `res_catunit.def` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 272 | string reference |
| `res_read_elements.f90` | `subroutine res_read_elements` | 35 | open (via in_regs%def_res) |

### `res_catunit.ele` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 271 | string reference |
| `res_read_elements.f90` | `subroutine res_read_elements` | 141 | open (via in_regs%ele_res) |

### `res_conds.dat` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `res_read_conds.f90` | `subroutine res_read_conds` | 19 | string reference |
| `res_read_conds.f90` | `subroutine res_read_conds` | 21 | open |

### `res_reg.def` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 273 | string reference |
| `res_read_elements.f90` | `subroutine res_read_elements` | 82 | open (via in_regs%def_res_reg) |

### `res_rel.dtl` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `dtbl_res_read.f90` | `subroutine dtbl_res_read` | 35 | open (via in_cond%dtbl_res) |
| `input_file_module.f90` | `module input_file_module` | 252 | string reference |

### `reservoir.con` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 48 | string reference |

### `reservoir.res` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 73 | string reference |
| `res_read.f90` | `subroutine res_read` | 49 | open (via in_res%res) |

### `reservoir.res_cs` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `res_read_salt_cs.f90` | `subroutine res_read_salt_cs` | 31 | open |

### `rout_unit.con` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 43 | string reference |

### `rout_unit.def` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 85 | string reference |
| `ru_read_elements.f90` | `subroutine ru_read_elements` | 95 | open (via in_ru%ru_def) |

### `rout_unit.dr` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 88 | string reference |

### `rout_unit.ele` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 86 | string reference |
| `ru_read_elements.f90` | `subroutine ru_read_elements` | 42 | open (via in_ru%ru_ele) |

### `rout_unit.rtu` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 87 | string reference |
| `ru_read.f90` | `subroutine ru_read` | 39 | open (via in_ru%ru) |

### `salt.slt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 183 | string reference |

### `salt_aqu.ini` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `salt_aqu_read.f90` | `subroutine salt_aqu_read` | 20 | string reference |
| `salt_aqu_read.f90` | `subroutine salt_aqu_read` | 21 | string reference |
| `salt_aqu_read.f90` | `subroutine salt_aqu_read` | 23 | open |

### `salt_atmo.cli` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `cli_read_atmodep_salt.f90` | `subroutine cli_read_atmodep_salt` | 28 | string reference |
| `cli_read_atmodep_salt.f90` | `subroutine cli_read_atmodep_salt` | 33 | open |

### `salt_channel.ini` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `salt_cha_read.f90` | `subroutine salt_cha_read` | 24 | string reference |
| `salt_cha_read.f90` | `subroutine salt_cha_read` | 25 | string reference |
| `salt_cha_read.f90` | `subroutine salt_cha_read` | 27 | open |

### `salt_fertilizer.frt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `salt_fert_read.f90` | `subroutine salt_fert_read` | 22 | string reference |
| `salt_fert_read.f90` | `subroutine salt_fert_read` | 24 | open |

### `salt_hru.ini` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 236 | string reference |
| `salt_hru_read.f90` | `subroutine salt_hru_read` | 20 | string reference |
| `salt_hru_read.f90` | `subroutine salt_hru_read` | 21 | string reference |
| `salt_hru_read.f90` | `subroutine salt_hru_read` | 23 | open |

### `salt_irrigation` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `salt_irr_read.f90` | `subroutine salt_irr_read` | 22 | open |

### `salt_plants` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `salt_plant_read.f90` | `subroutine salt_plant_read` | 22 | open |

### `salt_recall.rec` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `recall_read_salt.f90` | `subroutine recall_read_salt` | 40 | string reference |
| `recall_read_salt.f90` | `subroutine recall_read_salt` | 41 | string reference |
| `recall_read_salt.f90` | `subroutine recall_read_salt` | 43 | open |

### `salt_res` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `res_read_saltdb.f90` | `subroutine res_read_saltdb` | 31 | open |

### `salt_road` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `salt_roadsalt_read.f90` | `subroutine salt_roadsalt_read` | 40 | open |

### `salt_uptake` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `salt_uptake_read.f90` | `subroutine salt_uptake_read` | 37 | open |

### `salt_urban` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `salt_urban_read.f90` | `subroutine salt_urban_read` | 28 | open |

### `salt_water.ini` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 237 | string reference |

### `satbuffer.str` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `sat_buff_read.f90` | `subroutine sat_buff_read` | 30 | string reference |
| `sat_buff_read.f90` | `subroutine sat_buff_read` | 34 | open |

### `scen_dtl.upd` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `cal_cond_read.f90` | `subroutine cal_cond_read` | 43 | open |

### `scen_lu.dtl` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `dtbl_scen_read.f90` | `subroutine dtbl_scen_read` | 34 | open (via in_cond%dtbl_scen) |
| `input_file_module.f90` | `module input_file_module` | 253 | string reference |

### `sed_nut.cha` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `sd_hydsed_read.f90` | `subroutine sd_hydsed_read` | 69 | string reference |
| `sd_hydsed_read.f90` | `subroutine sd_hydsed_read` | 70 | string reference |
| `sd_hydsed_read.f90` | `subroutine sd_hydsed_read` | 74 | open |

### `sediment.cha` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `ch_read_sed.f90` | `subroutine ch_read_sed` | 33 | open (via in_cha%sed) |
| `input_file_module.f90` | `module input_file_module` | 62 | string reference |

### `sediment.res` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 75 | string reference |
| `res_read_sed.f90` | `subroutine res_read_sed` | 31 | open (via in_res%sed_res) |

### `septic.sep` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 185 | string reference |
| `septic_parm_read.f90` | `subroutine septic_parm_read` | 24 | open (via in_parmdb%septic_sep) |

### `septic.str` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 168 | string reference |
| `sep_read.f90` | `subroutine sep_read` | 24 | open (via in_str%septic_str) |

### `slr.cli` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `cli_smeas.f90` | `subroutine cli_smeas` | 32 | open (via in_cli%slr_cli) |
| `input_file_module.f90` | `module input_file_module` | 32 | string reference |

### `snow.sno` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 186 | string reference |
| `snowdb_read.f90` | `subroutine snowdb_read` | 28 | open (via in_parmdb%snow) |

### `soil_lyr_depths.sol` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `soils_init.f90` | `subroutine soils_init` | 69 | string reference |
| `soils_init.f90` | `subroutine soils_init` | 166 | open |

### `soil_plant.ini` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 228 | string reference |
| `soil_plant_init.f90` | `subroutine soil_plant_init` | 24 | open (via in_init%soil_plant_ini) |

### `soils.sol` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 243 | string reference |
| `soil_db_read.f90` | `subroutine soil_db_read` | 29 | open (via in_sol%soils_sol) |

### `soils_lte.sol` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 245 | string reference |
| `soil_lte_db_read.f90` | `subroutine soil_lte_db_read` | 26 | open (via in_sol%lte_sol) |

### `sweep.ops` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 197 | string reference |
| `mgt_read_sweepops.f90` | `subroutine mgt_read_sweepops` | 27 | open (via in_ops%sweep_ops) |

### `temperature.cha` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `ch_read_temp.f90` | `subroutine ch_read_temp` | 25 | open (via in_cha%temp) |
| `input_file_module.f90` | `module input_file_module` | 66 | string reference |

### `tiledrain.str` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 167 | string reference |
| `sdr_read.f90` | `subroutine sdr_read` | 25 | open (via in_str%tiledrain_str) |

### `tillage.til` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 179 | string reference |
| `till_parm_read.f90` | `subroutine till_parm_read` | 27 | open (via in_parmdb%till_til) |

### `time.sim` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 9 | string reference |
| `time_read.f90` | `subroutine time_read` | 23 | open (via in_sim%time) |

### `tmp.cli` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `cli_tmeas.f90` | `subroutine cli_tmeas` | 40 | open (via in_cli%tmp_cli) |
| `input_file_module.f90` | `module input_file_module` | 31 | string reference |

### `topography.hyd` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 160 | string reference |
| `topo_read.f90` | `subroutine topo_read` | 31 | open (via in_hyd%topogr_hyd) |

### `transplant.plt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `plant_transplant_read.f90` | `subroutine plant_transplant_read` | 19 | string reference |
| `plant_transplant_read.f90` | `subroutine plant_transplant_read` | 20 | string reference |
| `plant_transplant_read.f90` | `subroutine plant_transplant_read` | 24 | open |

### `urban.urb` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 184 | string reference |
| `urban_parm_read.f90` | `subroutine urban_parm_read` | 21 | open (via in_parmdb%urban_urb) |

### `usgs_annual_head` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `gwflow_read.f90` | `subroutine gwflow_read` | 680 | open |

### `water_allocation.wro` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 144 | string reference |
| `water_allocation_read.f90` | `subroutine water_allocation_read` | 48 | open (via in_watrts%transfer_wro) |

### `water_balance.sft` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 217 | string reference |
| `lcu_read_softcal.f90` | `subroutine lcu_read_softcal` | 35 | open (via in_chg%water_balance_sft) |

### `water_pipe.wal` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `water_pipe_read.f90` | `subroutine water_pipe_read` | 32 | open |

### `water_rights.wro` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 146 | string reference |

### `water_tower.wal` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `water_tower_read.f90` | `subroutine water_tower_read` | 32 | open |

### `water_treat.wal` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `water_treatment_read.f90` | `subroutine water_treatment_read` | 31 | open |

### `water_use.wal` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `water_use_read.f90` | `subroutine water_use_read` | 32 | open |

### `wb_parms.sft` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 216 | string reference |
| `ls_read_parms_cal.f90` | `subroutine ls_read_lsparms_cal` | 23 | open (via in_chg%wb_parms_sft) |

### `weather-sta.cli` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `cli_staread.f90` | `subroutine cli_staread` | 34 | open (via in_cli%weat_sta) |
| `input_file_module.f90` | `module input_file_module` | 26 | string reference |

### `weather-wgn.cli` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `cli_wgnread.f90` | `subroutine cli_wgnread` | 44 | open (via in_cli%weat_wgn) |
| `input_file_module.f90` | `module input_file_module` | 27 | string reference |

### `weir.res` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 77 | string reference |
| `res_read_weir.f90` | `subroutine res_read_weir` | 31 | open (via in_res%weir_res) |

### `wetland.wet` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `input_file_module.f90` | `module input_file_module` | 78 | string reference |
| `wet_read.f90` | `subroutine wet_read` | 40 | open (via in_res%wet) |

### `wetland.wet_cs` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `wet_read_salt_cs.f90` | `subroutine wet_read_salt_cs` | 31 | open |

### `wnd.cli` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `cli_wmeas.f90` | `subroutine cli_wmeas` | 31 | open (via in_cli%wnd_cli) |
| `input_file_module.f90` | `module input_file_module` | 34 | string reference |

## Output Files Referenced in Code

### `aquifer_aa.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_aquifer.f90` | `subroutine header_aquifer` | 70 | open_output_file |

### `aquifer_aa.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_aquifer.f90` | `subroutine header_aquifer` | 64 | open_output_file |

### `aquifer_cs_aa.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_const.f90` | `subroutine header_const` | 472 | open_output_file |

### `aquifer_cs_aa.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_const.f90` | `subroutine header_const` | 451 | open_output_file |

### `aquifer_cs_day.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_const.f90` | `subroutine header_const` | 376 | open_output_file |

### `aquifer_cs_day.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_const.f90` | `subroutine header_const` | 355 | open_output_file |

### `aquifer_cs_mon.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_const.f90` | `subroutine header_const` | 408 | open_output_file |

### `aquifer_cs_mon.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_const.f90` | `subroutine header_const` | 387 | open_output_file |

### `aquifer_cs_yr.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_const.f90` | `subroutine header_const` | 440 | open_output_file |

### `aquifer_cs_yr.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_const.f90` | `subroutine header_const` | 419 | open_output_file |

### `aquifer_day.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_aquifer.f90` | `subroutine header_aquifer` | 19 | open_output_file |

### `aquifer_day.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_aquifer.f90` | `subroutine header_aquifer` | 13 | open_output_file |

### `aquifer_mon.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_aquifer.f90` | `subroutine header_aquifer` | 36 | open_output_file |

### `aquifer_mon.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_aquifer.f90` | `subroutine header_aquifer` | 30 | open_output_file |

### `aquifer_pest_aa.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_pest.f90` | `subroutine header_pest` | 325 | open_output_file |

### `aquifer_pest_aa.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_pest.f90` | `subroutine header_pest` | 319 | open_output_file |

### `aquifer_pest_day.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_pest.f90` | `subroutine header_pest` | 280 | open_output_file |

### `aquifer_pest_day.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_pest.f90` | `subroutine header_pest` | 274 | open_output_file |

### `aquifer_pest_mon.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_pest.f90` | `subroutine header_pest` | 295 | open_output_file |

### `aquifer_pest_mon.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_pest.f90` | `subroutine header_pest` | 289 | open_output_file |

### `aquifer_pest_yr.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_pest.f90` | `subroutine header_pest` | 310 | open_output_file |

### `aquifer_pest_yr.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_pest.f90` | `subroutine header_pest` | 304 | open_output_file |

### `aquifer_salt_aa.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_salt.f90` | `subroutine header_salt` | 456 | open_output_file |

### `aquifer_salt_aa.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_salt.f90` | `subroutine header_salt` | 437 | open_output_file |

### `aquifer_salt_day.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_salt.f90` | `subroutine header_salt` | 366 | open_output_file |

### `aquifer_salt_day.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_salt.f90` | `subroutine header_salt` | 347 | open_output_file |

### `aquifer_salt_mon.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_salt.f90` | `subroutine header_salt` | 396 | open_output_file |

### `aquifer_salt_mon.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_salt.f90` | `subroutine header_salt` | 377 | open_output_file |

### `aquifer_salt_yr.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_salt.f90` | `subroutine header_salt` | 426 | open_output_file |

### `aquifer_salt_yr.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_salt.f90` | `subroutine header_salt` | 407 | open_output_file |

### `aquifer_yr.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_aquifer.f90` | `subroutine header_aquifer` | 53 | open_output_file |

### `aquifer_yr.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_aquifer.f90` | `subroutine header_aquifer` | 47 | open_output_file |

### `area_calc.out` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `proc_bsn.f90` | `subroutine proc_bsn` | 18 | open_output_file |

### `basin_aqu_aa.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_write.f90` | `subroutine header_write` | 111 | open_output_file |

### `basin_aqu_aa.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_write.f90` | `subroutine header_write` | 105 | open_output_file |

### `basin_aqu_day.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_write.f90` | `subroutine header_write` | 66 | open_output_file |

### `basin_aqu_day.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_write.f90` | `subroutine header_write` | 60 | open_output_file |

### `basin_aqu_mon.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_write.f90` | `subroutine header_write` | 81 | open_output_file |

### `basin_aqu_mon.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_write.f90` | `subroutine header_write` | 75 | open_output_file |

### `basin_aqu_pest_aa.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_pest.f90` | `subroutine header_pest` | 261 | open_output_file |

### `basin_aqu_pest_aa.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_pest.f90` | `subroutine header_pest` | 255 | open_output_file |

### `basin_aqu_pest_day.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_pest.f90` | `subroutine header_pest` | 216 | open_output_file |

### `basin_aqu_pest_day.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_pest.f90` | `subroutine header_pest` | 210 | open_output_file |

### `basin_aqu_pest_mon.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_pest.f90` | `subroutine header_pest` | 231 | open_output_file |

### `basin_aqu_pest_mon.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_pest.f90` | `subroutine header_pest` | 225 | open_output_file |

### `basin_aqu_pest_yr.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_pest.f90` | `subroutine header_pest` | 246 | open_output_file |

### `basin_aqu_pest_yr.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_pest.f90` | `subroutine header_pest` | 240 | open_output_file |

### `basin_aqu_yr.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_write.f90` | `subroutine header_write` | 96 | open_output_file |

### `basin_aqu_yr.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_write.f90` | `subroutine header_write` | 90 | open_output_file |

### `basin_carbon_all.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 680 | open_output_file |

### `basin_ch_pest_aa.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_pest.f90` | `subroutine header_pest` | 389 | open_output_file |

### `basin_ch_pest_aa.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_pest.f90` | `subroutine header_pest` | 383 | open_output_file |

### `basin_ch_pest_day.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_pest.f90` | `subroutine header_pest` | 344 | open_output_file |

### `basin_ch_pest_day.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_pest.f90` | `subroutine header_pest` | 338 | open_output_file |

### `basin_ch_pest_mon.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_pest.f90` | `subroutine header_pest` | 359 | open_output_file |

### `basin_ch_pest_mon.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_pest.f90` | `subroutine header_pest` | 353 | open_output_file |

### `basin_ch_pest_yr.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_pest.f90` | `subroutine header_pest` | 374 | open_output_file |

### `basin_ch_pest_yr.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_pest.f90` | `subroutine header_pest` | 368 | open_output_file |

### `basin_cha_aa.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_write.f90` | `subroutine header_write` | 298 | open_output_file |

### `basin_cha_aa.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_write.f90` | `subroutine header_write` | 292 | open_output_file |

### `basin_cha_day.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_write.f90` | `subroutine header_write` | 253 | open_output_file |

### `basin_cha_day.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_write.f90` | `subroutine header_write` | 247 | open_output_file |

### `basin_cha_mon.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_write.f90` | `subroutine header_write` | 268 | open_output_file |

### `basin_cha_mon.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_write.f90` | `subroutine header_write` | 262 | open_output_file |

### `basin_cha_yr.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_write.f90` | `subroutine header_write` | 283 | open_output_file |

### `basin_cha_yr.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_write.f90` | `subroutine header_write` | 277 | open_output_file |

### `basin_crop_yld_aa.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_yield.f90` | `subroutine header_yield` | 26 | open_output_file |

### `basin_crop_yld_yr.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_yield.f90` | `subroutine header_yield` | 22 | open_output_file |

### `basin_cs_aa.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_const.f90` | `subroutine header_const` | 147 | open_output_file |

### `basin_cs_day.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_const.f90` | `subroutine header_const` | 18 | open_output_file |

### `basin_cs_mon.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_const.f90` | `subroutine header_const` | 61 | open_output_file |

### `basin_cs_yr.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_const.f90` | `subroutine header_const` | 104 | open_output_file |

### `basin_ls_aa.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 1505 | open_output_file |

### `basin_ls_aa.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 1499 | open_output_file |

### `basin_ls_day.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 1460 | open_output_file |

### `basin_ls_day.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 1454 | open_output_file |

### `basin_ls_mon.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 1475 | open_output_file |

### `basin_ls_mon.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 1469 | open_output_file |

### `basin_ls_pest_aa.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_pest.f90` | `subroutine header_pest` | 517 | open_output_file |

### `basin_ls_pest_aa.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_pest.f90` | `subroutine header_pest` | 511 | open_output_file |

### `basin_ls_pest_day.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_pest.f90` | `subroutine header_pest` | 472 | open_output_file |

### `basin_ls_pest_day.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_pest.f90` | `subroutine header_pest` | 466 | open_output_file |

### `basin_ls_pest_mon.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_pest.f90` | `subroutine header_pest` | 487 | open_output_file |

### `basin_ls_pest_mon.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_pest.f90` | `subroutine header_pest` | 481 | open_output_file |

### `basin_ls_pest_yr.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_pest.f90` | `subroutine header_pest` | 502 | open_output_file |

### `basin_ls_pest_yr.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_pest.f90` | `subroutine header_pest` | 496 | open_output_file |

### `basin_ls_yr.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 1490 | open_output_file |

### `basin_ls_yr.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 1484 | open_output_file |

### `basin_nb_aa.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 1444 | open_output_file |

### `basin_nb_aa.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 1438 | open_output_file |

### `basin_nb_day.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 1399 | open_output_file |

### `basin_nb_day.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 1393 | open_output_file |

### `basin_nb_mon.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 1414 | open_output_file |

### `basin_nb_mon.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 1408 | open_output_file |

### `basin_nb_yr.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 1429 | open_output_file |

### `basin_nb_yr.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 1423 | open_output_file |

### `basin_psc_aa.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_write.f90` | `subroutine header_write` | 548 | open_output_file |

### `basin_psc_aa.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_write.f90` | `subroutine header_write` | 542 | open_output_file |

### `basin_psc_day.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_write.f90` | `subroutine header_write` | 503 | open_output_file |

### `basin_psc_day.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_write.f90` | `subroutine header_write` | 497 | open_output_file |

### `basin_psc_mon.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_write.f90` | `subroutine header_write` | 518 | open_output_file |

### `basin_psc_mon.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_write.f90` | `subroutine header_write` | 512 | open_output_file |

### `basin_psc_yr.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_write.f90` | `subroutine header_write` | 533 | open_output_file |

### `basin_psc_yr.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_write.f90` | `subroutine header_write` | 527 | open_output_file |

### `basin_pw_aa.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 1566 | open_output_file |

### `basin_pw_aa.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 1560 | open_output_file |

### `basin_pw_day.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 1521 | open_output_file |

### `basin_pw_day.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 1515 | open_output_file |

### `basin_pw_mon.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 1536 | open_output_file |

### `basin_pw_mon.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 1530 | open_output_file |

### `basin_pw_yr.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 1551 | open_output_file |

### `basin_pw_yr.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 1545 | open_output_file |

### `basin_res_aa.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_write.f90` | `subroutine header_write` | 173 | open_output_file |

### `basin_res_aa.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_write.f90` | `subroutine header_write` | 167 | open_output_file |

### `basin_res_day.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_write.f90` | `subroutine header_write` | 128 | open_output_file |

### `basin_res_day.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_write.f90` | `subroutine header_write` | 122 | open_output_file |

### `basin_res_mon.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_write.f90` | `subroutine header_write` | 143 | open_output_file |

### `basin_res_mon.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_write.f90` | `subroutine header_write` | 137 | open_output_file |

### `basin_res_pest_aa.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_pest.f90` | `subroutine header_pest` | 453 | open_output_file |

### `basin_res_pest_aa.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_pest.f90` | `subroutine header_pest` | 447 | open_output_file |

### `basin_res_pest_day.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_pest.f90` | `subroutine header_pest` | 408 | open_output_file |

### `basin_res_pest_day.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_pest.f90` | `subroutine header_pest` | 402 | open_output_file |

### `basin_res_pest_mon.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_pest.f90` | `subroutine header_pest` | 423 | open_output_file |

### `basin_res_pest_mon.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_pest.f90` | `subroutine header_pest` | 417 | open_output_file |

### `basin_res_pest_yr.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_pest.f90` | `subroutine header_pest` | 438 | open_output_file |

### `basin_res_pest_yr.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_pest.f90` | `subroutine header_pest` | 432 | open_output_file |

### `basin_res_yr.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_write.f90` | `subroutine header_write` | 158 | open_output_file |

### `basin_res_yr.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_write.f90` | `subroutine header_write` | 152 | open_output_file |

### `basin_salt_aa.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_salt.f90` | `subroutine header_salt` | 144 | open_output_file |

### `basin_salt_day.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_salt.f90` | `subroutine header_salt` | 18 | open_output_file |

### `basin_salt_mon.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_salt.f90` | `subroutine header_salt` | 60 | open_output_file |

### `basin_salt_yr.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_salt.f90` | `subroutine header_salt` | 102 | open_output_file |

### `basin_sd_cha_aa.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_write.f90` | `subroutine header_write` | 360 | open_output_file |

### `basin_sd_cha_aa.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_write.f90` | `subroutine header_write` | 354 | open_output_file |

### `basin_sd_cha_day.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_write.f90` | `subroutine header_write` | 315 | open_output_file |

### `basin_sd_cha_day.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_write.f90` | `subroutine header_write` | 309 | open_output_file |

### `basin_sd_cha_mon.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_write.f90` | `subroutine header_write` | 330 | open_output_file |

### `basin_sd_cha_mon.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_write.f90` | `subroutine header_write` | 324 | open_output_file |

### `basin_sd_cha_yr.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_write.f90` | `subroutine header_write` | 345 | open_output_file |

### `basin_sd_cha_yr.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_write.f90` | `subroutine header_write` | 339 | open_output_file |

### `basin_sd_chamorph_aa.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_write.f90` | `subroutine header_write` | 423 | open_output_file |

### `basin_sd_chamorph_aa.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_write.f90` | `subroutine header_write` | 417 | open_output_file |

### `basin_sd_chamorph_day.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_write.f90` | `subroutine header_write` | 378 | open_output_file |

### `basin_sd_chamorph_day.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_write.f90` | `subroutine header_write` | 372 | open_output_file |

### `basin_sd_chamorph_mon.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_write.f90` | `subroutine header_write` | 393 | open_output_file |

### `basin_sd_chamorph_mon.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_write.f90` | `subroutine header_write` | 387 | open_output_file |

### `basin_sd_chamorph_yr.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_write.f90` | `subroutine header_write` | 408 | open_output_file |

### `basin_sd_chamorph_yr.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_write.f90` | `subroutine header_write` | 402 | open_output_file |

### `basin_sd_chanbud_aa.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_write.f90` | `subroutine header_write` | 485 | open_output_file |

### `basin_sd_chanbud_aa.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_write.f90` | `subroutine header_write` | 479 | open_output_file |

### `basin_sd_chanbud_day.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_write.f90` | `subroutine header_write` | 440 | open_output_file |

### `basin_sd_chanbud_day.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_write.f90` | `subroutine header_write` | 434 | open_output_file |

### `basin_sd_chanbud_mon.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_write.f90` | `subroutine header_write` | 455 | open_output_file |

### `basin_sd_chanbud_mon.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_write.f90` | `subroutine header_write` | 449 | open_output_file |

### `basin_sd_chanbud_yr.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_write.f90` | `subroutine header_write` | 470 | open_output_file |

### `basin_sd_chanbud_yr.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_write.f90` | `subroutine header_write` | 464 | open_output_file |

### `basin_totc.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_snutc.f90` | `subroutine header_snutc` | 27 | open_output_file |

### `basin_wb_aa.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 1383 | open_output_file |

### `basin_wb_aa.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 1377 | open_output_file |

### `basin_wb_day.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 1338 | open_output_file |

### `basin_wb_day.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 1332 | open_output_file |

### `basin_wb_mon.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 1353 | open_output_file |

### `basin_wb_mon.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 1347 | open_output_file |

### `basin_wb_yr.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 1368 | open_output_file |

### `basin_wb_yr.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 1362 | open_output_file |

### `channel_aa.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_channel.f90` | `subroutine header_channel` | 83 | open_output_file |

### `channel_aa.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_channel.f90` | `subroutine header_channel` | 77 | open_output_file |

### `channel_cs_aa.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_const.f90` | `subroutine header_const` | 589 | open_output_file |

### `channel_cs_aa.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_const.f90` | `subroutine header_const` | 570 | open_output_file |

### `channel_cs_day.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_const.f90` | `subroutine header_const` | 502 | open_output_file |

### `channel_cs_day.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_const.f90` | `subroutine header_const` | 483 | open_output_file |

### `channel_cs_mon.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_const.f90` | `subroutine header_const` | 531 | open_output_file |

### `channel_cs_mon.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_const.f90` | `subroutine header_const` | 512 | open_output_file |

### `channel_cs_yr.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_const.f90` | `subroutine header_const` | 560 | open_output_file |

### `channel_cs_yr.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_const.f90` | `subroutine header_const` | 541 | open_output_file |

### `channel_day.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_channel.f90` | `subroutine header_channel` | 32 | open_output_file |

### `channel_day.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_channel.f90` | `subroutine header_channel` | 26 | open_output_file |

### `channel_mon.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_channel.f90` | `subroutine header_channel` | 49 | open_output_file |

### `channel_mon.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_channel.f90` | `subroutine header_channel` | 43 | open_output_file |

### `channel_mon_sdmorph.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_sd_channel.f90` | `subroutine header_sd_channel` | 173 | open_output_file |

### `channel_pest_aa.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_pest.f90` | `subroutine header_pest` | 133 | open_output_file |

### `channel_pest_aa.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_pest.f90` | `subroutine header_pest` | 127 | open_output_file |

### `channel_pest_day.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_pest.f90` | `subroutine header_pest` | 88 | open_output_file |

### `channel_pest_day.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_pest.f90` | `subroutine header_pest` | 82 | open_output_file |

### `channel_pest_mon.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_pest.f90` | `subroutine header_pest` | 103 | open_output_file |

### `channel_pest_mon.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_pest.f90` | `subroutine header_pest` | 97 | open_output_file |

### `channel_pest_yr.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_pest.f90` | `subroutine header_pest` | 118 | open_output_file |

### `channel_pest_yr.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_pest.f90` | `subroutine header_pest` | 112 | open_output_file |

### `channel_salt_aa.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_salt.f90` | `subroutine header_salt` | 573 | open_output_file |

### `channel_salt_aa.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_salt.f90` | `subroutine header_salt` | 554 | open_output_file |

### `channel_salt_day.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_salt.f90` | `subroutine header_salt` | 486 | open_output_file |

### `channel_salt_day.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_salt.f90` | `subroutine header_salt` | 467 | open_output_file |

### `channel_salt_mon.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_salt.f90` | `subroutine header_salt` | 515 | open_output_file |

### `channel_salt_mon.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_salt.f90` | `subroutine header_salt` | 496 | open_output_file |

### `channel_salt_yr.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_salt.f90` | `subroutine header_salt` | 544 | open_output_file |

### `channel_salt_yr.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_salt.f90` | `subroutine header_salt` | 525 | open_output_file |

### `channel_sd_aa.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_sd_channel.f90` | `subroutine header_sd_channel` | 131 | open_output_file |

### `channel_sd_aa.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_sd_channel.f90` | `subroutine header_sd_channel` | 118 | open_output_file |

### `channel_sd_day.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_sd_channel.f90` | `subroutine header_sd_channel` | 41 | open_output_file |

### `channel_sd_day.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_sd_channel.f90` | `subroutine header_sd_channel` | 29 | open_output_file |

### `channel_sd_mon.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_sd_channel.f90` | `subroutine header_sd_channel` | 71 | open_output_file |

### `channel_sd_mon.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_sd_channel.f90` | `subroutine header_sd_channel` | 58 | open_output_file |

### `channel_sd_subday.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_sd_channel.f90` | `subroutine header_sd_channel` | 21 | open_output_file |

### `channel_sd_subday.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_sd_channel.f90` | `subroutine header_sd_channel` | 15 | open_output_file |

### `channel_sd_yr.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_sd_channel.f90` | `subroutine header_sd_channel` | 101 | open_output_file |

### `channel_sd_yr.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_sd_channel.f90` | `subroutine header_sd_channel` | 88 | open_output_file |

### `channel_sdmorph_aa.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_sd_channel.f90` | `subroutine header_sd_channel` | 207 | open_output_file |

### `channel_sdmorph_aa.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_sd_channel.f90` | `subroutine header_sd_channel` | 201 | open_output_file |

### `channel_sdmorph_day.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_sd_channel.f90` | `subroutine header_sd_channel` | 156 | open_output_file |

### `channel_sdmorph_day.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_sd_channel.f90` | `subroutine header_sd_channel` | 150 | open_output_file |

### `channel_sdmorph_mon.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_sd_channel.f90` | `subroutine header_sd_channel` | 167 | open_output_file |

### `channel_sdmorph_yr.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_sd_channel.f90` | `subroutine header_sd_channel` | 190 | open_output_file |

### `channel_sdmorph_yr.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_sd_channel.f90` | `subroutine header_sd_channel` | 184 | open_output_file |

### `channel_yr.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_channel.f90` | `subroutine header_channel` | 66 | open_output_file |

### `channel_yr.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_channel.f90` | `subroutine header_channel` | 60 | open_output_file |

### `checker.out` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `proc_hru.f90` | `subroutine proc_hru` | 58 | open_output_file |

### `co2.out` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `co2_read.f90` | `subroutine co2_read` | 35 | open_output_file |

### `crop_yld_aa.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 1596 | open_output_file |

### `crop_yld_aa.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 1591 | open_output_file |

### `crop_yld_yr.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 1582 | open_output_file |

### `crop_yld_yr.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 1577 | open_output_file |

### `deposition_aa.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_hyd.f90` | `subroutine header_hyd` | 198 | open_output_file |

### `deposition_aa.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_hyd.f90` | `subroutine header_hyd` | 192 | open_output_file |

### `deposition_day.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_hyd.f90` | `subroutine header_hyd` | 150 | open_output_file |

### `deposition_day.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_hyd.f90` | `subroutine header_hyd` | 144 | open_output_file |

### `deposition_mon.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_hyd.f90` | `subroutine header_hyd` | 166 | open_output_file |

### `deposition_mon.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_hyd.f90` | `subroutine header_hyd` | 160 | open_output_file |

### `deposition_yr.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_hyd.f90` | `subroutine header_hyd` | 182 | open_output_file |

### `deposition_yr.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_hyd.f90` | `subroutine header_hyd` | 176 | open_output_file |

### `diagnostics.out` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `proc_bsn.f90` | `subroutine proc_bsn` | 15 | open_output_file |

### `erosion.out` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `proc_hru.f90` | `subroutine proc_hru` | 52 | open_output_file |

### `files_out.out` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `proc_bsn.f90` | `subroutine proc_bsn` | 12 | open_output_file |

### `flow_duration_curve.out` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_write.f90` | `subroutine header_write` | 16 | open_output_file |

### `hru-lte_ls_aa.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 1009 | open_output_file |

### `hru-lte_ls_aa.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 1003 | open_output_file |

### `hru-lte_ls_day.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 964 | open_output_file |

### `hru-lte_ls_day.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 958 | open_output_file |

### `hru-lte_ls_mon.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 979 | open_output_file |

### `hru-lte_ls_mon.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 973 | open_output_file |

### `hru-lte_ls_yr.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 994 | open_output_file |

### `hru-lte_ls_yr.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 988 | open_output_file |

### `hru-lte_pw_aa.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 1071 | open_output_file |

### `hru-lte_pw_aa.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 1065 | open_output_file |

### `hru-lte_pw_day.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 1026 | open_output_file |

### `hru-lte_pw_day.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 1020 | open_output_file |

### `hru-lte_pw_mon.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 1041 | open_output_file |

### `hru-lte_pw_mon.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 1035 | open_output_file |

### `hru-lte_pw_yr.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 1056 | open_output_file |

### `hru-lte_pw_yr.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 1050 | open_output_file |

### `hru-lte_wb_aa.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 936 | open_output_file |

### `hru-lte_wb_aa.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 930 | open_output_file |

### `hru-lte_wb_day.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 886 | open_output_file |

### `hru-lte_wb_day.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 880 | open_output_file |

### `hru-lte_wb_mon.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 902 | open_output_file |

### `hru-lte_wb_mon.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 896 | open_output_file |

### `hru-lte_wb_yr.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 919 | open_output_file |

### `hru-lte_wb_yr.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 913 | open_output_file |

### `hru_begsim_soil_prop.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 664 | open_output_file |

### `hru_begsim_soil_prop.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 659 | open_output_file |

### `hru_carbvars.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 600 | open_output_file |

### `hru_carbvars.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 595 | open_output_file |

### `hru_cbn_lyr.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 469 | open_output_file |

### `hru_cbn_lyr.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 465 | open_output_file |

### `hru_cflux_stat.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 530 | open_output_file |

### `hru_cflux_stat.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 524 | open_output_file |

### `hru_cpool_stat.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 556 | open_output_file |

### `hru_cpool_stat.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 550 | open_output_file |

### `hru_cs_aa.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_const.f90` | `subroutine header_const` | 345 | open_output_file |

### `hru_cs_aa.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_const.f90` | `subroutine header_const` | 313 | open_output_file |

### `hru_cs_day.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_const.f90` | `subroutine header_const` | 222 | open_output_file |

### `hru_cs_day.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_const.f90` | `subroutine header_const` | 190 | open_output_file |

### `hru_cs_mon.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_const.f90` | `subroutine header_const` | 263 | open_output_file |

### `hru_cs_mon.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_const.f90` | `subroutine header_const` | 231 | open_output_file |

### `hru_cs_yr.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_const.f90` | `subroutine header_const` | 304 | open_output_file |

### `hru_cs_yr.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_const.f90` | `subroutine header_const` | 272 | open_output_file |

### `hru_endsim_soil_prop.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 648 | open_output_file |

### `hru_endsim_soil_prop.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 643 | open_output_file |

### `hru_ls_aa.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 806 | open_output_file |

### `hru_ls_aa.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 800 | open_output_file |

### `hru_ls_day.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 698 | open_output_file |

### `hru_ls_day.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 692 | open_output_file |

### `hru_ls_mon.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 776 | open_output_file |

### `hru_ls_mon.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 770 | open_output_file |

### `hru_ls_yr.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 791 | open_output_file |

### `hru_ls_yr.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 785 | open_output_file |

### `hru_n_p_pool_stat.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 569 | open_output_file |

### `hru_n_p_pool_stat.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 563 | open_output_file |

### `hru_nb_aa.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 200 | open_output_file |

### `hru_nb_aa.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 194 | open_output_file |

### `hru_nb_day.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 93 | open_output_file |

### `hru_nb_day.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 87 | open_output_file |

### `hru_nb_mon.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 170 | open_output_file |

### `hru_nb_mon.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 164 | open_output_file |

### `hru_nb_yr.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 185 | open_output_file |

### `hru_nb_yr.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 179 | open_output_file |

### `hru_ncycle_aa.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 154 | open_output_file |

### `hru_ncycle_aa.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 148 | open_output_file |

### `hru_ncycle_day.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 109 | open_output_file |

### `hru_ncycle_day.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 103 | open_output_file |

### `hru_ncycle_mon.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 124 | open_output_file |

### `hru_ncycle_mon.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 118 | open_output_file |

### `hru_ncycle_yr.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 139 | open_output_file |

### `hru_ncycle_yr.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 133 | open_output_file |

### `hru_nut_carb_gl_aa.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 760 | open_output_file |

### `hru_nut_carb_gl_aa.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 754 | open_output_file |

### `hru_nut_carb_gl_day.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 715 | open_output_file |

### `hru_nut_carb_gl_day.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 709 | open_output_file |

### `hru_nut_carb_gl_mon.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 730 | open_output_file |

### `hru_nut_carb_gl_mon.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 724 | open_output_file |

### `hru_nut_carb_gl_yr.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 745 | open_output_file |

### `hru_nut_carb_gl_yr.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 739 | open_output_file |

### `hru_org_allo_vars.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 616 | open_output_file |

### `hru_org_allo_vars.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 611 | open_output_file |

### `hru_org_ratio_vars.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 632 | open_output_file |

### `hru_org_ratio_vars.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 627 | open_output_file |

### `hru_org_trans_vars.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 582 | open_output_file |

### `hru_org_trans_vars.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 576 | open_output_file |

### `hru_orgc.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_snutc.f90` | `subroutine header_snutc` | 11 | open_output_file |

### `hru_path_aa.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_path.f90` | `subroutine header_path` | 64 | open_output_file |

### `hru_path_aa.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_path.f90` | `subroutine header_path` | 58 | open_output_file |

### `hru_path_day.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_path.f90` | `subroutine header_path` | 19 | open_output_file |

### `hru_path_day.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_path.f90` | `subroutine header_path` | 13 | open_output_file |

### `hru_path_mon.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_path.f90` | `subroutine header_path` | 34 | open_output_file |

### `hru_path_mon.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_path.f90` | `subroutine header_path` | 28 | open_output_file |

### `hru_path_yr.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_path.f90` | `subroutine header_path` | 49 | open_output_file |

### `hru_path_yr.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_path.f90` | `subroutine header_path` | 43 | open_output_file |

### `hru_pest_aa.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_pest.f90` | `subroutine header_pest` | 69 | open_output_file |

### `hru_pest_aa.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_pest.f90` | `subroutine header_pest` | 63 | open_output_file |

### `hru_pest_day.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_pest.f90` | `subroutine header_pest` | 24 | open_output_file |

### `hru_pest_day.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_pest.f90` | `subroutine header_pest` | 18 | open_output_file |

### `hru_pest_mon.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_pest.f90` | `subroutine header_pest` | 39 | open_output_file |

### `hru_pest_mon.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_pest.f90` | `subroutine header_pest` | 33 | open_output_file |

### `hru_pest_yr.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_pest.f90` | `subroutine header_pest` | 54 | open_output_file |

### `hru_pest_yr.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_pest.f90` | `subroutine header_pest` | 48 | open_output_file |

### `hru_plc_stat.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 490 | open_output_file |

### `hru_plc_stat.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 484 | open_output_file |

### `hru_plcarb_aa.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 387 | open_output_file |

### `hru_plcarb_aa.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 381 | open_output_file |

### `hru_plcarb_day.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 342 | open_output_file |

### `hru_plcarb_day.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 336 | open_output_file |

### `hru_plcarb_mon.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 357 | open_output_file |

### `hru_plcarb_mon.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 351 | open_output_file |

### `hru_plcarb_yr.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 372 | open_output_file |

### `hru_plcarb_yr.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 366 | open_output_file |

### `hru_pw_aa.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 867 | open_output_file |

### `hru_pw_aa.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 861 | open_output_file |

### `hru_pw_day.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 822 | open_output_file |

### `hru_pw_day.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 816 | open_output_file |

### `hru_pw_mon.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 837 | open_output_file |

### `hru_pw_mon.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 831 | open_output_file |

### `hru_pw_yr.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 852 | open_output_file |

### `hru_pw_yr.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 846 | open_output_file |

### `hru_rescarb_aa.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 324 | open_output_file |

### `hru_rescarb_aa.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 318 | open_output_file |

### `hru_rescarb_day.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 279 | open_output_file |

### `hru_rescarb_day.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 273 | open_output_file |

### `hru_rescarb_mon.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 294 | open_output_file |

### `hru_rescarb_mon.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 288 | open_output_file |

### `hru_rescarb_yr.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 309 | open_output_file |

### `hru_rescarb_yr.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 303 | open_output_file |

### `hru_rsdc_stat.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 504 | open_output_file |

### `hru_rsdc_stat.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 498 | open_output_file |

### `hru_salt_aa.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_salt.f90` | `subroutine header_salt` | 337 | open_output_file |

### `hru_salt_aa.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_salt.f90` | `subroutine header_salt` | 306 | open_output_file |

### `hru_salt_day.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_salt.f90` | `subroutine header_salt` | 217 | open_output_file |

### `hru_salt_day.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_salt.f90` | `subroutine header_salt` | 186 | open_output_file |

### `hru_salt_mon.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_salt.f90` | `subroutine header_salt` | 257 | open_output_file |

### `hru_salt_mon.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_salt.f90` | `subroutine header_salt` | 226 | open_output_file |

### `hru_salt_yr.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_salt.f90` | `subroutine header_salt` | 297 | open_output_file |

### `hru_salt_yr.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_salt.f90` | `subroutine header_salt` | 266 | open_output_file |

### `hru_scf_aa.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 450 | open_output_file |

### `hru_scf_aa.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 444 | open_output_file |

### `hru_scf_day.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 405 | open_output_file |

### `hru_scf_day.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 399 | open_output_file |

### `hru_scf_mon.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 420 | open_output_file |

### `hru_scf_mon.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 414 | open_output_file |

### `hru_scf_yr.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 435 | open_output_file |

### `hru_scf_yr.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 429 | open_output_file |

### `hru_seq_lyr.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 478 | open_output_file |

### `hru_seq_lyr.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 474 | open_output_file |

### `hru_soilc_stat.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 517 | open_output_file |

### `hru_soilc_stat.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 511 | open_output_file |

### `hru_soilcarb_aa.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 261 | open_output_file |

### `hru_soilcarb_aa.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 255 | open_output_file |

### `hru_soilcarb_day.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 216 | open_output_file |

### `hru_soilcarb_day.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 210 | open_output_file |

### `hru_soilcarb_mb_stat.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 543 | open_output_file |

### `hru_soilcarb_mb_stat.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 537 | open_output_file |

### `hru_soilcarb_mon.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 231 | open_output_file |

### `hru_soilcarb_mon.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 225 | open_output_file |

### `hru_soilcarb_yr.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 246 | open_output_file |

### `hru_soilcarb_yr.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 240 | open_output_file |

### `hru_totc.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_snutc.f90` | `subroutine header_snutc` | 19 | open_output_file |

### `hru_wb_aa.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 77 | open_output_file |

### `hru_wb_aa.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 71 | open_output_file |

### `hru_wb_day.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 28 | open_output_file |

### `hru_wb_day.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 21 | open_output_file |

### `hru_wb_mon.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 45 | open_output_file |

### `hru_wb_mon.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 38 | open_output_file |

### `hru_wb_yr.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 61 | open_output_file |

### `hru_wb_yr.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 55 | open_output_file |

### `hydcon.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_hyd.f90` | `subroutine header_hyd` | 13 | open_output_file |

### `hydcon.out` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_hyd.f90` | `subroutine header_hyd` | 10 | open_output_file |

### `hydin_aa.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_hyd.f90` | `subroutine header_hyd` | 133 | open_output_file |

### `hydin_aa.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_hyd.f90` | `subroutine header_hyd` | 127 | open_output_file |

### `hydin_day.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_hyd.f90` | `subroutine header_hyd` | 88 | open_output_file |

### `hydin_day.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_hyd.f90` | `subroutine header_hyd` | 82 | open_output_file |

### `hydin_metals_aa.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_cs.f90` | `subroutine header_cs` | 215 | open_output_file |

### `hydin_metals_aa.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_cs.f90` | `subroutine header_cs` | 210 | open_output_file |

### `hydin_metals_day.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_cs.f90` | `subroutine header_cs` | 48 | open_output_file |

### `hydin_metals_day.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_cs.f90` | `subroutine header_cs` | 43 | open_output_file |

### `hydin_metals_mon.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_cs.f90` | `subroutine header_cs` | 104 | open_output_file |

### `hydin_metals_mon.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_cs.f90` | `subroutine header_cs` | 99 | open_output_file |

### `hydin_metals_yr.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_cs.f90` | `subroutine header_cs` | 160 | open_output_file |

### `hydin_metals_yr.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_cs.f90` | `subroutine header_cs` | 155 | open_output_file |

### `hydin_mon.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_hyd.f90` | `subroutine header_hyd` | 103 | open_output_file |

### `hydin_mon.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_hyd.f90` | `subroutine header_hyd` | 97 | open_output_file |

### `hydin_paths_aa.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_cs.f90` | `subroutine header_cs` | 202 | open_output_file |

### `hydin_paths_aa.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_cs.f90` | `subroutine header_cs` | 197 | open_output_file |

### `hydin_paths_day.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_cs.f90` | `subroutine header_cs` | 35 | open_output_file |

### `hydin_paths_day.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_cs.f90` | `subroutine header_cs` | 30 | open_output_file |

### `hydin_paths_mon.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_cs.f90` | `subroutine header_cs` | 91 | open_output_file |

### `hydin_paths_mon.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_cs.f90` | `subroutine header_cs` | 86 | open_output_file |

### `hydin_paths_yr.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_cs.f90` | `subroutine header_cs` | 147 | open_output_file |

### `hydin_paths_yr.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_cs.f90` | `subroutine header_cs` | 142 | open_output_file |

### `hydin_pests_aa.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_cs.f90` | `subroutine header_cs` | 189 | open_output_file |

### `hydin_pests_aa.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_cs.f90` | `subroutine header_cs` | 184 | open_output_file |

### `hydin_pests_day.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_cs.f90` | `subroutine header_cs` | 22 | open_output_file |

### `hydin_pests_day.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_cs.f90` | `subroutine header_cs` | 17 | open_output_file |

### `hydin_pests_mon.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_cs.f90` | `subroutine header_cs` | 77 | open_output_file |

### `hydin_pests_mon.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_cs.f90` | `subroutine header_cs` | 72 | open_output_file |

### `hydin_pests_yr.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_cs.f90` | `subroutine header_cs` | 134 | open_output_file |

### `hydin_pests_yr.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_cs.f90` | `subroutine header_cs` | 129 | open_output_file |

### `hydin_salts_aa.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_cs.f90` | `subroutine header_cs` | 228 | open_output_file |

### `hydin_salts_aa.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_cs.f90` | `subroutine header_cs` | 223 | open_output_file |

### `hydin_salts_day.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_cs.f90` | `subroutine header_cs` | 61 | open_output_file |

### `hydin_salts_day.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_cs.f90` | `subroutine header_cs` | 56 | open_output_file |

### `hydin_salts_mon.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_cs.f90` | `subroutine header_cs` | 117 | open_output_file |

### `hydin_salts_mon.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_cs.f90` | `subroutine header_cs` | 112 | open_output_file |

### `hydin_salts_yr.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_cs.f90` | `subroutine header_cs` | 173 | open_output_file |

### `hydin_salts_yr.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_cs.f90` | `subroutine header_cs` | 168 | open_output_file |

### `hydin_yr.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_hyd.f90` | `subroutine header_hyd` | 118 | open_output_file |

### `hydin_yr.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_hyd.f90` | `subroutine header_hyd` | 112 | open_output_file |

### `hydout_aa.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_hyd.f90` | `subroutine header_hyd` | 71 | open_output_file |

### `hydout_aa.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_hyd.f90` | `subroutine header_hyd` | 65 | open_output_file |

### `hydout_day.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_hyd.f90` | `subroutine header_hyd` | 26 | open_output_file |

### `hydout_day.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_hyd.f90` | `subroutine header_hyd` | 20 | open_output_file |

### `hydout_metals_aa.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_cs.f90` | `subroutine header_cs` | 436 | open_output_file |

### `hydout_metals_aa.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_cs.f90` | `subroutine header_cs` | 431 | open_output_file |

### `hydout_metals_day.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_cs.f90` | `subroutine header_cs` | 270 | open_output_file |

### `hydout_metals_day.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_cs.f90` | `subroutine header_cs` | 265 | open_output_file |

### `hydout_metals_mon.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_cs.f90` | `subroutine header_cs` | 325 | open_output_file |

### `hydout_metals_mon.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_cs.f90` | `subroutine header_cs` | 320 | open_output_file |

### `hydout_metals_yr.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_cs.f90` | `subroutine header_cs` | 381 | open_output_file |

### `hydout_metals_yr.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_cs.f90` | `subroutine header_cs` | 376 | open_output_file |

### `hydout_mon.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_hyd.f90` | `subroutine header_hyd` | 41 | open_output_file |

### `hydout_mon.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_hyd.f90` | `subroutine header_hyd` | 35 | open_output_file |

### `hydout_paths_aa.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_cs.f90` | `subroutine header_cs` | 423 | open_output_file |

### `hydout_paths_aa.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_cs.f90` | `subroutine header_cs` | 418 | open_output_file |

### `hydout_paths_day.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_cs.f90` | `subroutine header_cs` | 257 | open_output_file |

### `hydout_paths_day.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_cs.f90` | `subroutine header_cs` | 252 | open_output_file |

### `hydout_paths_mon.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_cs.f90` | `subroutine header_cs` | 312 | open_output_file |

### `hydout_paths_mon.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_cs.f90` | `subroutine header_cs` | 307 | open_output_file |

### `hydout_paths_yr.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_cs.f90` | `subroutine header_cs` | 368 | open_output_file |

### `hydout_paths_yr.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_cs.f90` | `subroutine header_cs` | 363 | open_output_file |

### `hydout_pests_aa.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_cs.f90` | `subroutine header_cs` | 410 | open_output_file |

### `hydout_pests_aa.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_cs.f90` | `subroutine header_cs` | 405 | open_output_file |

### `hydout_pests_day.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_cs.f90` | `subroutine header_cs` | 244 | open_output_file |

### `hydout_pests_day.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_cs.f90` | `subroutine header_cs` | 239 | open_output_file |

### `hydout_pests_mon.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_cs.f90` | `subroutine header_cs` | 299 | open_output_file |

### `hydout_pests_mon.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_cs.f90` | `subroutine header_cs` | 294 | open_output_file |

### `hydout_pests_yr.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_cs.f90` | `subroutine header_cs` | 355 | open_output_file |

### `hydout_pests_yr.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_cs.f90` | `subroutine header_cs` | 350 | open_output_file |

### `hydout_salts_aa.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_cs.f90` | `subroutine header_cs` | 449 | open_output_file |

### `hydout_salts_aa.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_cs.f90` | `subroutine header_cs` | 444 | open_output_file |

### `hydout_salts_day.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_cs.f90` | `subroutine header_cs` | 283 | open_output_file |

### `hydout_salts_day.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_cs.f90` | `subroutine header_cs` | 278 | open_output_file |

### `hydout_salts_mon.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_cs.f90` | `subroutine header_cs` | 338 | open_output_file |

### `hydout_salts_mon.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_cs.f90` | `subroutine header_cs` | 333 | open_output_file |

### `hydout_salts_yr.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_cs.f90` | `subroutine header_cs` | 394 | open_output_file |

### `hydout_salts_yr.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_cs.f90` | `subroutine header_cs` | 389 | open_output_file |

### `hydout_yr.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_hyd.f90` | `subroutine header_hyd` | 56 | open_output_file |

### `hydout_yr.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_hyd.f90` | `subroutine header_hyd` | 50 | open_output_file |

### `lsunit_ls_aa.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 1259 | open_output_file |

### `lsunit_ls_aa.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 1253 | open_output_file |

### `lsunit_ls_day.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 1214 | open_output_file |

### `lsunit_ls_day.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 1208 | open_output_file |

### `lsunit_ls_mon.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 1229 | open_output_file |

### `lsunit_ls_mon.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 1223 | open_output_file |

### `lsunit_ls_yr.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 1244 | open_output_file |

### `lsunit_ls_yr.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 1238 | open_output_file |

### `lsunit_nb_aa.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 1198 | open_output_file |

### `lsunit_nb_aa.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 1192 | open_output_file |

### `lsunit_nb_day.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 1153 | open_output_file |

### `lsunit_nb_day.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 1147 | open_output_file |

### `lsunit_nb_mon.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 1168 | open_output_file |

### `lsunit_nb_mon.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 1162 | open_output_file |

### `lsunit_nb_yr.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 1183 | open_output_file |

### `lsunit_nb_yr.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 1177 | open_output_file |

### `lsunit_pw_aa.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 1321 | open_output_file |

### `lsunit_pw_aa.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 1315 | open_output_file |

### `lsunit_pw_day.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 1275 | open_output_file |

### `lsunit_pw_day.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 1269 | open_output_file |

### `lsunit_pw_mon.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 1291 | open_output_file |

### `lsunit_pw_mon.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 1285 | open_output_file |

### `lsunit_pw_yr.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 1306 | open_output_file |

### `lsunit_pw_yr.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 1300 | open_output_file |

### `lsunit_wb_aa.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 1137 | open_output_file |

### `lsunit_wb_aa.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 1131 | open_output_file |

### `lsunit_wb_day.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 1089 | open_output_file |

### `lsunit_wb_day.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 1083 | open_output_file |

### `lsunit_wb_mon.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 1105 | open_output_file |

### `lsunit_wb_mon.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 1099 | open_output_file |

### `lsunit_wb_yr.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 1121 | open_output_file |

### `lsunit_wb_yr.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `output_landscape_init.f90` | `subroutine output_landscape_init` | 1115 | open_output_file |

### `lu_change_out.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_lu_change.f90` | `subroutine header_lu_change` | 8 | open_output_file |

### `mgt_out.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_mgt.f90` | `subroutine header_mgt` | 9 | open_output_file |

### `out.key` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `gwflow_read.f90` | `subroutine gwflow_read` | 1717 | open |

### `recall_aa.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_write.f90` | `subroutine header_write` | 235 | open_output_file |

### `recall_aa.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_write.f90` | `subroutine header_write` | 229 | open_output_file |

### `recall_day.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_write.f90` | `subroutine header_write` | 190 | open_output_file |

### `recall_day.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_write.f90` | `subroutine header_write` | 184 | open_output_file |

### `recall_mon.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_write.f90` | `subroutine header_write` | 205 | open_output_file |

### `recall_mon.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_write.f90` | `subroutine header_write` | 199 | open_output_file |

### `recall_yr.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_write.f90` | `subroutine header_write` | 220 | open_output_file |

### `recall_yr.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_write.f90` | `subroutine header_write` | 214 | open_output_file |

### `reservoir_aa.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_reservoir.f90` | `subroutine header_reservoir` | 66 | open_output_file |

### `reservoir_aa.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_reservoir.f90` | `subroutine header_reservoir` | 60 | open_output_file |

### `reservoir_cs_aa.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_const.f90` | `subroutine header_const` | 721 | open_output_file |

### `reservoir_cs_aa.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_const.f90` | `subroutine header_const` | 698 | open_output_file |

### `reservoir_cs_day.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_const.f90` | `subroutine header_const` | 622 | open_output_file |

### `reservoir_cs_day.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_const.f90` | `subroutine header_const` | 599 | open_output_file |

### `reservoir_cs_mon.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_const.f90` | `subroutine header_const` | 655 | open_output_file |

### `reservoir_cs_mon.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_const.f90` | `subroutine header_const` | 632 | open_output_file |

### `reservoir_cs_yr.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_const.f90` | `subroutine header_const` | 688 | open_output_file |

### `reservoir_cs_yr.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_const.f90` | `subroutine header_const` | 665 | open_output_file |

### `reservoir_day.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_reservoir.f90` | `subroutine header_reservoir` | 21 | open_output_file |

### `reservoir_day.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_reservoir.f90` | `subroutine header_reservoir` | 15 | open_output_file |

### `reservoir_mon.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_reservoir.f90` | `subroutine header_reservoir` | 36 | open_output_file |

### `reservoir_mon.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_reservoir.f90` | `subroutine header_reservoir` | 30 | open_output_file |

### `reservoir_pest_aa.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_pest.f90` | `subroutine header_pest` | 197 | open_output_file |

### `reservoir_pest_aa.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_pest.f90` | `subroutine header_pest` | 191 | open_output_file |

### `reservoir_pest_day.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_pest.f90` | `subroutine header_pest` | 152 | open_output_file |

### `reservoir_pest_day.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_pest.f90` | `subroutine header_pest` | 146 | open_output_file |

### `reservoir_pest_mon.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_pest.f90` | `subroutine header_pest` | 167 | open_output_file |

### `reservoir_pest_mon.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_pest.f90` | `subroutine header_pest` | 161 | open_output_file |

### `reservoir_pest_yr.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_pest.f90` | `subroutine header_pest` | 182 | open_output_file |

### `reservoir_pest_yr.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_pest.f90` | `subroutine header_pest` | 176 | open_output_file |

### `reservoir_salt_aa.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_salt.f90` | `subroutine header_salt` | 693 | open_output_file |

### `reservoir_salt_aa.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_salt.f90` | `subroutine header_salt` | 673 | open_output_file |

### `reservoir_salt_day.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_salt.f90` | `subroutine header_salt` | 603 | open_output_file |

### `reservoir_salt_day.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_salt.f90` | `subroutine header_salt` | 583 | open_output_file |

### `reservoir_salt_mon.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_salt.f90` | `subroutine header_salt` | 633 | open_output_file |

### `reservoir_salt_mon.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_salt.f90` | `subroutine header_salt` | 613 | open_output_file |

### `reservoir_salt_yr.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_salt.f90` | `subroutine header_salt` | 663 | open_output_file |

### `reservoir_salt_yr.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_salt.f90` | `subroutine header_salt` | 643 | open_output_file |

### `reservoir_yr.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_reservoir.f90` | `subroutine header_reservoir` | 51 | open_output_file |

### `reservoir_yr.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_reservoir.f90` | `subroutine header_reservoir` | 45 | open_output_file |

### `rout_unit_cs_aa.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_const.f90` | `subroutine header_const` | 872 | open_output_file |

### `rout_unit_cs_aa.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_const.f90` | `subroutine header_const` | 845 | open_output_file |

### `rout_unit_cs_day.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_const.f90` | `subroutine header_const` | 758 | open_output_file |

### `rout_unit_cs_day.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_const.f90` | `subroutine header_const` | 731 | open_output_file |

### `rout_unit_cs_mon.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_const.f90` | `subroutine header_const` | 796 | open_output_file |

### `rout_unit_cs_mon.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_const.f90` | `subroutine header_const` | 769 | open_output_file |

### `rout_unit_cs_yr.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_const.f90` | `subroutine header_const` | 834 | open_output_file |

### `rout_unit_cs_yr.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_const.f90` | `subroutine header_const` | 807 | open_output_file |

### `rout_unit_salt_aa.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_salt.f90` | `subroutine header_salt` | 844 | open_output_file |

### `rout_unit_salt_aa.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_salt.f90` | `subroutine header_salt` | 817 | open_output_file |

### `rout_unit_salt_day.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_salt.f90` | `subroutine header_salt` | 730 | open_output_file |

### `rout_unit_salt_day.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_salt.f90` | `subroutine header_salt` | 703 | open_output_file |

### `rout_unit_salt_mon.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_salt.f90` | `subroutine header_salt` | 768 | open_output_file |

### `rout_unit_salt_mon.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_salt.f90` | `subroutine header_salt` | 741 | open_output_file |

### `rout_unit_salt_yr.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_salt.f90` | `subroutine header_salt` | 806 | open_output_file |

### `rout_unit_salt_yr.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_salt.f90` | `subroutine header_salt` | 779 | open_output_file |

### `ru_aa.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_write.f90` | `subroutine header_write` | 611 | open_output_file |

### `ru_aa.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_write.f90` | `subroutine header_write` | 605 | open_output_file |

### `ru_day.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_write.f90` | `subroutine header_write` | 566 | open_output_file |

### `ru_day.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_write.f90` | `subroutine header_write` | 560 | open_output_file |

### `ru_mon.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_write.f90` | `subroutine header_write` | 581 | open_output_file |

### `ru_mon.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_write.f90` | `subroutine header_write` | 575 | open_output_file |

### `ru_yr.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_write.f90` | `subroutine header_write` | 596 | open_output_file |

### `ru_yr.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_write.f90` | `subroutine header_write` | 590 | open_output_file |

### `sd_chanbud_aa.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_sd_channel.f90` | `subroutine header_sd_channel` | 270 | open_output_file |

### `sd_chanbud_aa.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_sd_channel.f90` | `subroutine header_sd_channel` | 264 | open_output_file |

### `sd_chanbud_day.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_sd_channel.f90` | `subroutine header_sd_channel` | 225 | open_output_file |

### `sd_chanbud_day.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_sd_channel.f90` | `subroutine header_sd_channel` | 219 | open_output_file |

### `sd_chanbud_mon.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_sd_channel.f90` | `subroutine header_sd_channel` | 240 | open_output_file |

### `sd_chanbud_mon.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_sd_channel.f90` | `subroutine header_sd_channel` | 234 | open_output_file |

### `sd_chanbud_yr.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_sd_channel.f90` | `subroutine header_sd_channel` | 255 | open_output_file |

### `sd_chanbud_yr.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_sd_channel.f90` | `subroutine header_sd_channel` | 249 | open_output_file |

### `water_allo_aa.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_water_allocation.f90` | `subroutine header_water_allocation` | 70 | open_output_file |

### `water_allo_aa.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_water_allocation.f90` | `subroutine header_water_allocation` | 64 | open_output_file |

### `water_allo_day.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_water_allocation.f90` | `subroutine header_water_allocation` | 19 | open_output_file |

### `water_allo_day.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_water_allocation.f90` | `subroutine header_water_allocation` | 13 | open_output_file |

### `water_allo_mon.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_water_allocation.f90` | `subroutine header_water_allocation` | 36 | open_output_file |

### `water_allo_mon.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_water_allocation.f90` | `subroutine header_water_allocation` | 30 | open_output_file |

### `water_allo_yr.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_water_allocation.f90` | `subroutine header_water_allocation` | 53 | open_output_file |

### `water_allo_yr.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_water_allocation.f90` | `subroutine header_water_allocation` | 47 | open_output_file |

### `wetland_aa.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_wetland.f90` | `subroutine header_wetland` | 67 | open_output_file |

### `wetland_aa.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_wetland.f90` | `subroutine header_wetland` | 61 | open_output_file |

### `wetland_cs_aa.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_const.f90` | `subroutine header_const` | 1001 | open_output_file |

### `wetland_cs_aa.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_const.f90` | `subroutine header_const` | 979 | open_output_file |

### `wetland_cs_day.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_const.f90` | `subroutine header_const` | 905 | open_output_file |

### `wetland_cs_day.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_const.f90` | `subroutine header_const` | 883 | open_output_file |

### `wetland_cs_mon.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_const.f90` | `subroutine header_const` | 937 | open_output_file |

### `wetland_cs_mon.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_const.f90` | `subroutine header_const` | 915 | open_output_file |

### `wetland_cs_yr.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_const.f90` | `subroutine header_const` | 969 | open_output_file |

### `wetland_cs_yr.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_const.f90` | `subroutine header_const` | 947 | open_output_file |

### `wetland_day.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_wetland.f90` | `subroutine header_wetland` | 18 | open_output_file |

### `wetland_day.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_wetland.f90` | `subroutine header_wetland` | 12 | open_output_file |

### `wetland_mon.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_wetland.f90` | `subroutine header_wetland` | 34 | open_output_file |

### `wetland_mon.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_wetland.f90` | `subroutine header_wetland` | 28 | open_output_file |

### `wetland_salt_aa.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_salt.f90` | `subroutine header_salt` | 965 | open_output_file |

### `wetland_salt_aa.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_salt.f90` | `subroutine header_salt` | 945 | open_output_file |

### `wetland_salt_day.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_salt.f90` | `subroutine header_salt` | 875 | open_output_file |

### `wetland_salt_day.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_salt.f90` | `subroutine header_salt` | 855 | open_output_file |

### `wetland_salt_mon.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_salt.f90` | `subroutine header_salt` | 905 | open_output_file |

### `wetland_salt_mon.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_salt.f90` | `subroutine header_salt` | 885 | open_output_file |

### `wetland_salt_yr.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_salt.f90` | `subroutine header_salt` | 935 | open_output_file |

### `wetland_salt_yr.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_salt.f90` | `subroutine header_salt` | 915 | open_output_file |

### `wetland_yr.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_wetland.f90` | `subroutine header_wetland` | 50 | open_output_file |

### `wetland_yr.txt` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_wetland.f90` | `subroutine header_wetland` | 44 | open_output_file |

### `yield.csv` (**not on list**)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_yield.f90` | `subroutine header_yield` | 14 | open_output_file |

### `yield.out` (✓ on list)

| Source File | Subroutine | Line | Operation |
|------------|-----------|------|-----------|
| `header_yield.f90` | `subroutine header_yield` | 11 | open_output_file |

## Files on Provided List NOT Found in Code

These files appear in the provided checklist but were not found as direct or
variable-resolved references in the current source code.

| Filename | Listed Count | Notes |
|----------|-------------|-------|
| `NEEDS WORK` | 4 | Not a real filename - placeholder in documentation |
| `aquifer.out` | 17 | Now `aquifer_day.txt`, `aquifer_mon.txt`, etc. |
| `atmo.cli` | 12 | Now `atmodep.cli` in code |
| `bsn_chan.out` | 13 | Likely renamed or removed in current code |
| `cha.key` | 21 | Old key file format; now integrated into main outputs |
| `channel.out` | 62 | Now `channel_day.txt`, `channel_mon.txt`, etc. |
| `cons_prac.lum` | 9 | Now `cons_practice.lum` in code |
| `crop_yld_aa.out` | 5 | Now `basin_crop_yld_aa.txt` |
| `deposition .out` | 29 | Typo with trailing space in name |
| `hru_sub.key` | 12 | Old key file format; now integrated into main outputs |
| `hycon.out` | 4 | Now `hydcon.out` |
| `hyd-out.out` | 29 | Old hydrograph output; replaced by new format |
| `hyd_in.out` | 29 | Old hydrograph input output; replaced by new format |
| `losses.bsn` | 14 | Now `basin_ls_day.txt`, `basin_ls_mon.txt`, etc. |
| `losses.hru` | 15 | Now `hru_ls_day.txt`, `hru_ls_mon.txt`, etc. |
| `losses.sd` | 14 | Old SWAT-DEG output; commented out in code |
| `losses.sub` | 14 | Now `lsunit_ls_day.txt`, `lsunit_ls_mon.txt`, etc. |
| `metl.cst` | 9 | Now `metals.mtl` in code |
| `mgt.key` | 24 | Old key file format; now integrated into main outputs |
| `mgt.out` | 29 | Now `mgt_out.txt` |
| `modflow.con` | 20 | MODFLOW connection file; referenced via in_con but not yet implemented |
| `nutbal.bsn` | 21 | Now `basin_nb_day.txt`, `basin_nb_mon.txt`, etc. |
| `nutbal.hru` | 22 | Now `hru_nb_day.txt`, `hru_nb_mon.txt`, etc. |
| `nutbal.sub` | 21 | Now `lsunit_nb_day.txt`, `lsunit_nb_mon.txt`, etc. |
| `path.cst` | 9 | Old constituent file; may be renamed |
| `path_hru_ini` | 5 | Missing extension; likely `path_hru.ini` in code |
| `pest.cst` | 9 | Old constituent file; may be renamed |
| `plantwx.bsn` | 20 | Now `basin_pw_day.txt`, `basin_pw_mon.txt`, etc. |
| `plantwx.hru` | 26 | Now `hru_pw_day.txt`, `hru_pw_mon.txt`, etc. |
| `plantwx.sd` | 20 | Old SWAT-DEG output; commented out in code |
| `plantwx.sub` | 20 | Now `lsunit_pw_day.txt`, `lsunit_pw_mon.txt`, etc. |
| `recann.dat` | 25 | Recall annual data; opened dynamically with constructed filename |
| `recday.dat` | 25 | Recall daily data; opened dynamically with constructed filename |
| `res.dtl` | 47 | Now `res_rel.dtl` in code |
| `res.key` | 21 | Old key file format; now integrated into main outputs |
| `reservoir.out` | 44 | Now `reservoir_day.txt`, `reservoir_mon.txt`, etc. |
| `salt.cst` | 9 | Now `salt.slt` in code |
| `salt_hru_ini` | 5 | Missing extension; likely `salt_hru.ini` in code |
| `sd_channel.out` | 17 | Now `channel_sd_day.txt`, `channel_sd_mon.txt`, etc. |
| `soils.out` | 7 | Now `hru_orgc.txt` and `hru_totc.txt` |
| `transfer.wro` | 1 | Old name; now `water_allocation.wro` |
| `waterbal.bsn` | 20 | Now `basin_wb_day.txt`, `basin_wb_mon.txt`, etc. |
| `waterbal.hru` | 42 | Now `hru_wb_day.txt`, `hru_wb_mon.txt`, etc. |
| `waterbal.sd` | 20 | Old SWAT-DEG output; commented out in code |
| `waterbal.sub` | 20 | Now `lsunit_wb_day.txt`, `lsunit_wb_mon.txt`, etc. |
| `wind-dir.cli` | 18 | Commented out in `input_file_module.f90` |

## Files Found in Code NOT on Provided List

These files are referenced in the source code but do not appear in the provided checklist.

| Filename | Source File(s) | Subroutine(s) | Type |
|----------|---------------|--------------|------|
| `aquifer_aa.csv` | `header_aquifer.f90` | `subroutine header_aquifer` | output |
| `aquifer_aa.txt` | `header_aquifer.f90` | `subroutine header_aquifer` | output |
| `aquifer_cs_aa.csv` | `header_const.f90` | `subroutine header_const` | output |
| `aquifer_cs_aa.txt` | `header_const.f90` | `subroutine header_const` | output |
| `aquifer_cs_day.csv` | `header_const.f90` | `subroutine header_const` | output |
| `aquifer_cs_day.txt` | `header_const.f90` | `subroutine header_const` | output |
| `aquifer_cs_mon.csv` | `header_const.f90` | `subroutine header_const` | output |
| `aquifer_cs_mon.txt` | `header_const.f90` | `subroutine header_const` | output |
| `aquifer_cs_yr.csv` | `header_const.f90` | `subroutine header_const` | output |
| `aquifer_cs_yr.txt` | `header_const.f90` | `subroutine header_const` | output |
| `aquifer_day.csv` | `header_aquifer.f90` | `subroutine header_aquifer` | output |
| `aquifer_day.txt` | `header_aquifer.f90` | `subroutine header_aquifer` | output |
| `aquifer_mon.csv` | `header_aquifer.f90` | `subroutine header_aquifer` | output |
| `aquifer_mon.txt` | `header_aquifer.f90` | `subroutine header_aquifer` | output |
| `aquifer_pest_aa.csv` | `header_pest.f90` | `subroutine header_pest` | output |
| `aquifer_pest_aa.txt` | `header_pest.f90` | `subroutine header_pest` | output |
| `aquifer_pest_day.csv` | `header_pest.f90` | `subroutine header_pest` | output |
| `aquifer_pest_day.txt` | `header_pest.f90` | `subroutine header_pest` | output |
| `aquifer_pest_mon.csv` | `header_pest.f90` | `subroutine header_pest` | output |
| `aquifer_pest_mon.txt` | `header_pest.f90` | `subroutine header_pest` | output |
| `aquifer_pest_yr.csv` | `header_pest.f90` | `subroutine header_pest` | output |
| `aquifer_pest_yr.txt` | `header_pest.f90` | `subroutine header_pest` | output |
| `aquifer_salt_aa.csv` | `header_salt.f90` | `subroutine header_salt` | output |
| `aquifer_salt_aa.txt` | `header_salt.f90` | `subroutine header_salt` | output |
| `aquifer_salt_day.csv` | `header_salt.f90` | `subroutine header_salt` | output |
| `aquifer_salt_day.txt` | `header_salt.f90` | `subroutine header_salt` | output |
| `aquifer_salt_mon.csv` | `header_salt.f90` | `subroutine header_salt` | output |
| `aquifer_salt_mon.txt` | `header_salt.f90` | `subroutine header_salt` | output |
| `aquifer_salt_yr.csv` | `header_salt.f90` | `subroutine header_salt` | output |
| `aquifer_salt_yr.txt` | `header_salt.f90` | `subroutine header_salt` | output |
| `aquifer_yr.csv` | `header_aquifer.f90` | `subroutine header_aquifer` | output |
| `aquifer_yr.txt` | `header_aquifer.f90` | `subroutine header_aquifer` | output |
| `area_calc.out` | `proc_bsn.f90` | `subroutine proc_bsn` | output |
| `atmodep.cli` | `cli_read_atmodep.f90`, `input_file_module.f90` | `module input_file_module`, `subroutine cli_read_atmodep` | input, reference |
| `basin_aqu_aa.csv` | `header_write.f90` | `subroutine header_write` | output |
| `basin_aqu_aa.txt` | `header_write.f90` | `subroutine header_write` | output |
| `basin_aqu_day.csv` | `header_write.f90` | `subroutine header_write` | output |
| `basin_aqu_day.txt` | `header_write.f90` | `subroutine header_write` | output |
| `basin_aqu_mon.csv` | `header_write.f90` | `subroutine header_write` | output |
| `basin_aqu_mon.txt` | `header_write.f90` | `subroutine header_write` | output |
| `basin_aqu_pest_aa.csv` | `header_pest.f90` | `subroutine header_pest` | output |
| `basin_aqu_pest_aa.txt` | `header_pest.f90` | `subroutine header_pest` | output |
| `basin_aqu_pest_day.csv` | `header_pest.f90` | `subroutine header_pest` | output |
| `basin_aqu_pest_day.txt` | `header_pest.f90` | `subroutine header_pest` | output |
| `basin_aqu_pest_mon.csv` | `header_pest.f90` | `subroutine header_pest` | output |
| `basin_aqu_pest_mon.txt` | `header_pest.f90` | `subroutine header_pest` | output |
| `basin_aqu_pest_yr.csv` | `header_pest.f90` | `subroutine header_pest` | output |
| `basin_aqu_pest_yr.txt` | `header_pest.f90` | `subroutine header_pest` | output |
| `basin_aqu_yr.csv` | `header_write.f90` | `subroutine header_write` | output |
| `basin_aqu_yr.txt` | `header_write.f90` | `subroutine header_write` | output |
| `basin_carbon_all.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `basin_ch_pest_aa.csv` | `header_pest.f90` | `subroutine header_pest` | output |
| `basin_ch_pest_aa.txt` | `header_pest.f90` | `subroutine header_pest` | output |
| `basin_ch_pest_day.csv` | `header_pest.f90` | `subroutine header_pest` | output |
| `basin_ch_pest_day.txt` | `header_pest.f90` | `subroutine header_pest` | output |
| `basin_ch_pest_mon.csv` | `header_pest.f90` | `subroutine header_pest` | output |
| `basin_ch_pest_mon.txt` | `header_pest.f90` | `subroutine header_pest` | output |
| `basin_ch_pest_yr.csv` | `header_pest.f90` | `subroutine header_pest` | output |
| `basin_ch_pest_yr.txt` | `header_pest.f90` | `subroutine header_pest` | output |
| `basin_cha_aa.csv` | `header_write.f90` | `subroutine header_write` | output |
| `basin_cha_aa.txt` | `header_write.f90` | `subroutine header_write` | output |
| `basin_cha_day.csv` | `header_write.f90` | `subroutine header_write` | output |
| `basin_cha_day.txt` | `header_write.f90` | `subroutine header_write` | output |
| `basin_cha_mon.csv` | `header_write.f90` | `subroutine header_write` | output |
| `basin_cha_mon.txt` | `header_write.f90` | `subroutine header_write` | output |
| `basin_cha_yr.csv` | `header_write.f90` | `subroutine header_write` | output |
| `basin_cha_yr.txt` | `header_write.f90` | `subroutine header_write` | output |
| `basin_crop_yld_aa.txt` | `header_yield.f90` | `subroutine header_yield` | output |
| `basin_crop_yld_yr.txt` | `header_yield.f90` | `subroutine header_yield` | output |
| `basin_cs_aa.txt` | `header_const.f90` | `subroutine header_const` | output |
| `basin_cs_day.txt` | `header_const.f90` | `subroutine header_const` | output |
| `basin_cs_mon.txt` | `header_const.f90` | `subroutine header_const` | output |
| `basin_cs_yr.txt` | `header_const.f90` | `subroutine header_const` | output |
| `basin_ls_aa.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `basin_ls_aa.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `basin_ls_day.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `basin_ls_day.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `basin_ls_mon.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `basin_ls_mon.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `basin_ls_pest_aa.csv` | `header_pest.f90` | `subroutine header_pest` | output |
| `basin_ls_pest_aa.txt` | `header_pest.f90` | `subroutine header_pest` | output |
| `basin_ls_pest_day.csv` | `header_pest.f90` | `subroutine header_pest` | output |
| `basin_ls_pest_day.txt` | `header_pest.f90` | `subroutine header_pest` | output |
| `basin_ls_pest_mon.csv` | `header_pest.f90` | `subroutine header_pest` | output |
| `basin_ls_pest_mon.txt` | `header_pest.f90` | `subroutine header_pest` | output |
| `basin_ls_pest_yr.csv` | `header_pest.f90` | `subroutine header_pest` | output |
| `basin_ls_pest_yr.txt` | `header_pest.f90` | `subroutine header_pest` | output |
| `basin_ls_yr.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `basin_ls_yr.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `basin_nb_aa.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `basin_nb_aa.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `basin_nb_day.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `basin_nb_day.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `basin_nb_mon.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `basin_nb_mon.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `basin_nb_yr.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `basin_nb_yr.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `basin_psc_aa.csv` | `header_write.f90` | `subroutine header_write` | output |
| `basin_psc_aa.txt` | `header_write.f90` | `subroutine header_write` | output |
| `basin_psc_day.csv` | `header_write.f90` | `subroutine header_write` | output |
| `basin_psc_day.txt` | `header_write.f90` | `subroutine header_write` | output |
| `basin_psc_mon.csv` | `header_write.f90` | `subroutine header_write` | output |
| `basin_psc_mon.txt` | `header_write.f90` | `subroutine header_write` | output |
| `basin_psc_yr.csv` | `header_write.f90` | `subroutine header_write` | output |
| `basin_psc_yr.txt` | `header_write.f90` | `subroutine header_write` | output |
| `basin_pw_aa.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `basin_pw_aa.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `basin_pw_day.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `basin_pw_day.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `basin_pw_mon.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `basin_pw_mon.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `basin_pw_yr.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `basin_pw_yr.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `basin_res_aa.csv` | `header_write.f90` | `subroutine header_write` | output |
| `basin_res_aa.txt` | `header_write.f90` | `subroutine header_write` | output |
| `basin_res_day.csv` | `header_write.f90` | `subroutine header_write` | output |
| `basin_res_day.txt` | `header_write.f90` | `subroutine header_write` | output |
| `basin_res_mon.csv` | `header_write.f90` | `subroutine header_write` | output |
| `basin_res_mon.txt` | `header_write.f90` | `subroutine header_write` | output |
| `basin_res_pest_aa.csv` | `header_pest.f90` | `subroutine header_pest` | output |
| `basin_res_pest_aa.txt` | `header_pest.f90` | `subroutine header_pest` | output |
| `basin_res_pest_day.csv` | `header_pest.f90` | `subroutine header_pest` | output |
| `basin_res_pest_day.txt` | `header_pest.f90` | `subroutine header_pest` | output |
| `basin_res_pest_mon.csv` | `header_pest.f90` | `subroutine header_pest` | output |
| `basin_res_pest_mon.txt` | `header_pest.f90` | `subroutine header_pest` | output |
| `basin_res_pest_yr.csv` | `header_pest.f90` | `subroutine header_pest` | output |
| `basin_res_pest_yr.txt` | `header_pest.f90` | `subroutine header_pest` | output |
| `basin_res_yr.csv` | `header_write.f90` | `subroutine header_write` | output |
| `basin_res_yr.txt` | `header_write.f90` | `subroutine header_write` | output |
| `basin_salt_aa.txt` | `header_salt.f90` | `subroutine header_salt` | output |
| `basin_salt_day.txt` | `header_salt.f90` | `subroutine header_salt` | output |
| `basin_salt_mon.txt` | `header_salt.f90` | `subroutine header_salt` | output |
| `basin_salt_yr.txt` | `header_salt.f90` | `subroutine header_salt` | output |
| `basin_sd_cha_aa.csv` | `header_write.f90` | `subroutine header_write` | output |
| `basin_sd_cha_aa.txt` | `header_write.f90` | `subroutine header_write` | output |
| `basin_sd_cha_day.csv` | `header_write.f90` | `subroutine header_write` | output |
| `basin_sd_cha_day.txt` | `header_write.f90` | `subroutine header_write` | output |
| `basin_sd_cha_mon.csv` | `header_write.f90` | `subroutine header_write` | output |
| `basin_sd_cha_mon.txt` | `header_write.f90` | `subroutine header_write` | output |
| `basin_sd_cha_yr.csv` | `header_write.f90` | `subroutine header_write` | output |
| `basin_sd_cha_yr.txt` | `header_write.f90` | `subroutine header_write` | output |
| `basin_sd_chamorph_aa.csv` | `header_write.f90` | `subroutine header_write` | output |
| `basin_sd_chamorph_aa.txt` | `header_write.f90` | `subroutine header_write` | output |
| `basin_sd_chamorph_day.csv` | `header_write.f90` | `subroutine header_write` | output |
| `basin_sd_chamorph_day.txt` | `header_write.f90` | `subroutine header_write` | output |
| `basin_sd_chamorph_mon.csv` | `header_write.f90` | `subroutine header_write` | output |
| `basin_sd_chamorph_mon.txt` | `header_write.f90` | `subroutine header_write` | output |
| `basin_sd_chamorph_yr.csv` | `header_write.f90` | `subroutine header_write` | output |
| `basin_sd_chamorph_yr.txt` | `header_write.f90` | `subroutine header_write` | output |
| `basin_sd_chanbud_aa.csv` | `header_write.f90` | `subroutine header_write` | output |
| `basin_sd_chanbud_aa.txt` | `header_write.f90` | `subroutine header_write` | output |
| `basin_sd_chanbud_day.csv` | `header_write.f90` | `subroutine header_write` | output |
| `basin_sd_chanbud_day.txt` | `header_write.f90` | `subroutine header_write` | output |
| `basin_sd_chanbud_mon.csv` | `header_write.f90` | `subroutine header_write` | output |
| `basin_sd_chanbud_mon.txt` | `header_write.f90` | `subroutine header_write` | output |
| `basin_sd_chanbud_yr.csv` | `header_write.f90` | `subroutine header_write` | output |
| `basin_sd_chanbud_yr.txt` | `header_write.f90` | `subroutine header_write` | output |
| `basin_totc.txt` | `header_snutc.f90` | `subroutine header_snutc` | output |
| `basin_wb_aa.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `basin_wb_aa.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `basin_wb_day.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `basin_wb_day.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `basin_wb_mon.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `basin_wb_mon.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `basin_wb_yr.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `basin_wb_yr.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `basins_carbon.tes` | `carbon_read.f90` | `subroutine carbon_read` | unknown |
| `carb_coefs.cbn` | `carbon_coef_read.f90` | `subroutine carbon_coef_read` | unknown |
| `channel_aa.csv` | `header_channel.f90` | `subroutine header_channel` | output |
| `channel_aa.txt` | `header_channel.f90` | `subroutine header_channel` | output |
| `channel_cs_aa.csv` | `header_const.f90` | `subroutine header_const` | output |
| `channel_cs_aa.txt` | `header_const.f90` | `subroutine header_const` | output |
| `channel_cs_day.csv` | `header_const.f90` | `subroutine header_const` | output |
| `channel_cs_day.txt` | `header_const.f90` | `subroutine header_const` | output |
| `channel_cs_mon.csv` | `header_const.f90` | `subroutine header_const` | output |
| `channel_cs_mon.txt` | `header_const.f90` | `subroutine header_const` | output |
| `channel_cs_yr.csv` | `header_const.f90` | `subroutine header_const` | output |
| `channel_cs_yr.txt` | `header_const.f90` | `subroutine header_const` | output |
| `channel_day.csv` | `header_channel.f90` | `subroutine header_channel` | output |
| `channel_day.txt` | `header_channel.f90` | `subroutine header_channel` | output |
| `channel_mon.csv` | `header_channel.f90` | `subroutine header_channel` | output |
| `channel_mon.txt` | `header_channel.f90` | `subroutine header_channel` | output |
| `channel_mon_sdmorph.csv` | `header_sd_channel.f90` | `subroutine header_sd_channel` | output |
| `channel_pest_aa.csv` | `header_pest.f90` | `subroutine header_pest` | output |
| `channel_pest_aa.txt` | `header_pest.f90` | `subroutine header_pest` | output |
| `channel_pest_day.csv` | `header_pest.f90` | `subroutine header_pest` | output |
| `channel_pest_day.txt` | `header_pest.f90` | `subroutine header_pest` | output |
| `channel_pest_mon.csv` | `header_pest.f90` | `subroutine header_pest` | output |
| `channel_pest_mon.txt` | `header_pest.f90` | `subroutine header_pest` | output |
| `channel_pest_yr.csv` | `header_pest.f90` | `subroutine header_pest` | output |
| `channel_pest_yr.txt` | `header_pest.f90` | `subroutine header_pest` | output |
| `channel_salt_aa.csv` | `header_salt.f90` | `subroutine header_salt` | output |
| `channel_salt_aa.txt` | `header_salt.f90` | `subroutine header_salt` | output |
| `channel_salt_day.csv` | `header_salt.f90` | `subroutine header_salt` | output |
| `channel_salt_day.txt` | `header_salt.f90` | `subroutine header_salt` | output |
| `channel_salt_mon.csv` | `header_salt.f90` | `subroutine header_salt` | output |
| `channel_salt_mon.txt` | `header_salt.f90` | `subroutine header_salt` | output |
| `channel_salt_yr.csv` | `header_salt.f90` | `subroutine header_salt` | output |
| `channel_salt_yr.txt` | `header_salt.f90` | `subroutine header_salt` | output |
| `channel_sd_aa.csv` | `header_sd_channel.f90` | `subroutine header_sd_channel` | output |
| `channel_sd_aa.txt` | `header_sd_channel.f90` | `subroutine header_sd_channel` | output |
| `channel_sd_day.csv` | `header_sd_channel.f90` | `subroutine header_sd_channel` | output |
| `channel_sd_day.txt` | `header_sd_channel.f90` | `subroutine header_sd_channel` | output |
| `channel_sd_mon.csv` | `header_sd_channel.f90` | `subroutine header_sd_channel` | output |
| `channel_sd_mon.txt` | `header_sd_channel.f90` | `subroutine header_sd_channel` | output |
| `channel_sd_subday.csv` | `header_sd_channel.f90` | `subroutine header_sd_channel` | output |
| `channel_sd_subday.txt` | `header_sd_channel.f90` | `subroutine header_sd_channel` | output |
| `channel_sd_yr.csv` | `header_sd_channel.f90` | `subroutine header_sd_channel` | output |
| `channel_sd_yr.txt` | `header_sd_channel.f90` | `subroutine header_sd_channel` | output |
| `channel_sdmorph_aa.csv` | `header_sd_channel.f90` | `subroutine header_sd_channel` | output |
| `channel_sdmorph_aa.txt` | `header_sd_channel.f90` | `subroutine header_sd_channel` | output |
| `channel_sdmorph_day.csv` | `header_sd_channel.f90` | `subroutine header_sd_channel` | output |
| `channel_sdmorph_day.txt` | `header_sd_channel.f90` | `subroutine header_sd_channel` | output |
| `channel_sdmorph_mon.txt` | `header_sd_channel.f90` | `subroutine header_sd_channel` | output |
| `channel_sdmorph_yr.csv` | `header_sd_channel.f90` | `subroutine header_sd_channel` | output |
| `channel_sdmorph_yr.txt` | `header_sd_channel.f90` | `subroutine header_sd_channel` | output |
| `channel_yr.csv` | `header_channel.f90` | `subroutine header_channel` | output |
| `channel_yr.txt` | `header_channel.f90` | `subroutine header_channel` | output |
| `checker.out` | `proc_hru.f90` | `subroutine proc_hru` | output |
| `co2.out` | `co2_read.f90` | `subroutine co2_read` | output |
| `co2_yr.dat` | `co2_read.f90` | `subroutine co2_read` | reference, unknown |
| `cons_practice.lum` | `cons_prac_read.f90`, `input_file_module.f90` | `module input_file_module`, `subroutine cons_prac_read` | input, reference |
| `crop_yld_aa.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `crop_yld_aa.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `crop_yld_yr.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `crop_yld_yr.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `cs_aqu.ini` | `cs_aqu_read.f90` | `subroutine cs_aqu_read` | reference, unknown |
| `cs_atmo.cli` | `cli_read_atmodep_cs.f90` | `subroutine cli_read_atmodep_cs` | reference, unknown |
| `cs_channel.ini` | `cs_cha_read.f90` | `subroutine cs_cha_read` | reference, unknown |
| `cs_hru.ini` | `cs_hru_read.f90` | `subroutine cs_hru_read` | reference, unknown |
| `cs_irrigation` | `cs_irr_read.f90` | `subroutine cs_irr_read` | unknown |
| `cs_plants_boron` | `cs_plant_read.f90` | `subroutine cs_plant_read` | unknown |
| `cs_reactions` | `cs_reactions_read.f90` | `subroutine cs_reactions_read` | unknown |
| `cs_recall.rec` | `recall_read_cs.f90` | `subroutine recall_read_cs` | reference, unknown |
| `cs_res` | `res_read_csdb.f90` | `subroutine res_read_csdb` | unknown |
| `cs_streamobs` | `cs_cha_read.f90` | `subroutine cs_cha_read` | unknown |
| `cs_streamobs_output` | `cs_cha_read.f90` | `subroutine cs_cha_read` | unknown |
| `cs_uptake` | `cs_uptake_read.f90` | `subroutine cs_uptake_read` | unknown |
| `cs_urban` | `cs_urban_read.f90` | `subroutine cs_urban_read` | unknown |
| `deposition_aa.csv` | `header_hyd.f90` | `subroutine header_hyd` | output |
| `deposition_aa.txt` | `header_hyd.f90` | `subroutine header_hyd` | output |
| `deposition_day.csv` | `header_hyd.f90` | `subroutine header_hyd` | output |
| `deposition_day.txt` | `header_hyd.f90` | `subroutine header_hyd` | output |
| `deposition_mon.csv` | `header_hyd.f90` | `subroutine header_hyd` | output |
| `deposition_mon.txt` | `header_hyd.f90` | `subroutine header_hyd` | output |
| `deposition_yr.csv` | `header_hyd.f90` | `subroutine header_hyd` | output |
| `deposition_yr.txt` | `header_hyd.f90` | `subroutine header_hyd` | output |
| `element.ccu` | `ch_read_elements.f90` | `subroutine ch_read_elements` | unknown |
| `erosion.out` | `proc_hru.f90` | `subroutine proc_hru` | output |
| `fertilizer.frt_cs` | `cs_fert_read.f90` | `subroutine cs_fert_read` | unknown |
| `gwflow.canals` | `gwflow_read.f90` | `subroutine gwflow_read` | unknown |
| `gwflow.cellhru` | `gwflow_read.f90` | `subroutine gwflow_read` | unknown |
| `gwflow.chancells` | `basin_read_objs.f90`, `gwflow_chan_read.f90` | `subroutine basin_read_objs`, `subroutine gwflow_chan_read` | unknown |
| `gwflow.con` | `basin_read_objs.f90`, `gwflow_chan_read.f90`, `input_file_module.f90` | `module input_file_module`, `subroutine basin_read_objs`, `subroutine gwflow_chan_read` | reference, unknown |
| `gwflow.floodplain` | `gwflow_read.f90` | `subroutine gwflow_read` | unknown |
| `gwflow.hru_pump_observe` | `gwflow_read.f90` | `subroutine gwflow_read` | unknown |
| `gwflow.hrucell` | `gwflow_read.f90` | `subroutine gwflow_read` | unknown |
| `gwflow.huc12cell` | `gwflow_read.f90` | `subroutine gwflow_read` | unknown |
| `gwflow.input` | `gwflow_read.f90` | `subroutine gwflow_read` | unknown |
| `gwflow.lsucell` | `gwflow_read.f90` | `subroutine gwflow_read` | unknown |
| `gwflow.pumpex` | `gwflow_read.f90` | `subroutine gwflow_read` | unknown |
| `gwflow.rescells` | `gwflow_read.f90` | `subroutine gwflow_read` | unknown |
| `gwflow.solutes` | `gwflow_read.f90` | `subroutine gwflow_read` | unknown |
| `gwflow.solutes.minerals` | `gwflow_read.f90` | `subroutine gwflow_read` | unknown |
| `gwflow.streamobs` | `gwflow_read.f90` | `subroutine gwflow_read` | unknown |
| `gwflow.tiles` | `gwflow_read.f90` | `subroutine gwflow_read` | unknown |
| `gwflow.wetland` | `wet_read_hyd.f90` | `subroutine wet_read_hyd` | unknown |
| `gwflow_balance_gw_aa` | `gwflow_read.f90` | `subroutine gwflow_read` | unknown |
| `gwflow_balance_gw_day` | `gwflow_read.f90` | `subroutine gwflow_read` | unknown |
| `gwflow_balance_gw_yr` | `gwflow_read.f90` | `subroutine gwflow_read` | unknown |
| `gwflow_balance_huc12` | `gwflow_read.f90` | `subroutine gwflow_read` | unknown |
| `gwflow_balance_huc12_mon` | `gwflow_read.f90` | `subroutine gwflow_read` | unknown |
| `gwflow_flux_canl` | `gwflow_read.f90` | `subroutine gwflow_read` | unknown |
| `gwflow_flux_floodplain` | `gwflow_read.f90` | `subroutine gwflow_read` | unknown |
| `gwflow_flux_gwet` | `gwflow_read.f90` | `subroutine gwflow_read` | unknown |
| `gwflow_flux_gwsw` | `gwflow_read.f90` | `subroutine gwflow_read` | unknown |
| `gwflow_flux_ppag` | `gwflow_read.f90` | `subroutine gwflow_read` | unknown |
| `gwflow_flux_ppex` | `gwflow_read.f90` | `subroutine gwflow_read` | unknown |
| `gwflow_flux_pumping_deficient` | `gwflow_read.f90` | `subroutine gwflow_read` | unknown |
| `gwflow_flux_pumping_hru_mo` | `gwflow_read.f90` | `subroutine gwflow_read` | unknown |
| `gwflow_flux_pumping_hru_obs` | `gwflow_read.f90` | `subroutine gwflow_read` | unknown |
| `gwflow_flux_pumping_hru_yr` | `gwflow_read.f90` | `subroutine gwflow_read` | unknown |
| `gwflow_flux_reaction` | `gwflow_read.f90` | `subroutine gwflow_read` | unknown |
| `gwflow_flux_rech` | `gwflow_read.f90` | `subroutine gwflow_read` | unknown |
| `gwflow_flux_resv` | `gwflow_read.f90` | `subroutine gwflow_read` | unknown |
| `gwflow_flux_satx` | `gwflow_read.f90` | `subroutine gwflow_read` | unknown |
| `gwflow_flux_soil` | `gwflow_read.f90` | `subroutine gwflow_read` | unknown |
| `gwflow_flux_tile` | `gwflow_read.f90` | `subroutine gwflow_read` | unknown |
| `gwflow_flux_wetland` | `gwflow_read.f90` | `subroutine gwflow_read` | unknown |
| `gwflow_mass_canl` | `gwflow_read.f90` | `subroutine gwflow_read` | unknown |
| `gwflow_mass_fpln` | `gwflow_read.f90` | `subroutine gwflow_read` | unknown |
| `gwflow_mass_gwsw` | `gwflow_read.f90` | `subroutine gwflow_read` | unknown |
| `gwflow_mass_ppag` | `gwflow_read.f90` | `subroutine gwflow_read` | unknown |
| `gwflow_mass_ppex` | `gwflow_read.f90` | `subroutine gwflow_read` | unknown |
| `gwflow_mass_rech` | `gwflow_read.f90` | `subroutine gwflow_read` | unknown |
| `gwflow_mass_resv` | `gwflow_read.f90` | `subroutine gwflow_read` | unknown |
| `gwflow_mass_satx` | `gwflow_read.f90` | `subroutine gwflow_read` | unknown |
| `gwflow_mass_soil` | `gwflow_read.f90` | `subroutine gwflow_read` | unknown |
| `gwflow_mass_tile` | `gwflow_read.f90` | `subroutine gwflow_read` | unknown |
| `gwflow_mass_wetl` | `gwflow_read.f90` | `subroutine gwflow_read` | unknown |
| `gwflow_record` | `basin_read_objs.f90` | `subroutine basin_read_objs` | unknown |
| `gwflow_state_conc` | `gwflow_read.f90` | `subroutine gwflow_read` | unknown |
| `gwflow_state_conc_mo` | `gwflow_read.f90` | `subroutine gwflow_read` | unknown |
| `gwflow_state_conc_yr` | `gwflow_read.f90` | `subroutine gwflow_read` | unknown |
| `gwflow_state_head` | `gwflow_read.f90` | `subroutine gwflow_read` | unknown |
| `gwflow_state_head_mo` | `gwflow_read.f90` | `subroutine gwflow_read` | unknown |
| `gwflow_state_head_yr` | `gwflow_read.f90` | `subroutine gwflow_read` | unknown |
| `gwflow_state_hydsep` | `gwflow_read.f90` | `subroutine gwflow_read` | unknown |
| `gwflow_state_obs_conc` | `gwflow_read.f90` | `subroutine gwflow_read` | unknown |
| `gwflow_state_obs_flow` | `gwflow_read.f90` | `subroutine gwflow_read` | unknown |
| `gwflow_state_obs_head` | `gwflow_read.f90` | `subroutine gwflow_read` | unknown |
| `gwflow_state_obs_head_usgs` | `gwflow_read.f90` | `subroutine gwflow_read` | unknown |
| `gwflow_tile_cell_groups` | `gwflow_read.f90` | `subroutine gwflow_read` | unknown |
| `hru-lte_ls_aa.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru-lte_ls_aa.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru-lte_ls_day.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru-lte_ls_day.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru-lte_ls_mon.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru-lte_ls_mon.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru-lte_ls_yr.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru-lte_ls_yr.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru-lte_pw_aa.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru-lte_pw_aa.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru-lte_pw_day.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru-lte_pw_day.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru-lte_pw_mon.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru-lte_pw_mon.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru-lte_pw_yr.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru-lte_pw_yr.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru-lte_wb_aa.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru-lte_wb_aa.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru-lte_wb_day.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru-lte_wb_day.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru-lte_wb_mon.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru-lte_wb_mon.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru-lte_wb_yr.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru-lte_wb_yr.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru-new.cal` | `header_write.f90` | `subroutine header_write` | unknown |
| `hru-out.cal` | `header_write.f90` | `subroutine header_write` | unknown |
| `hru_begsim_soil_prop.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_begsim_soil_prop.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_carbvars.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_carbvars.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_cbn_lyr.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_cbn_lyr.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_cflux_stat.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_cflux_stat.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_cpool_stat.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_cpool_stat.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_cs_aa.csv` | `header_const.f90` | `subroutine header_const` | output |
| `hru_cs_aa.txt` | `header_const.f90` | `subroutine header_const` | output |
| `hru_cs_day.csv` | `header_const.f90` | `subroutine header_const` | output |
| `hru_cs_day.txt` | `header_const.f90` | `subroutine header_const` | output |
| `hru_cs_mon.csv` | `header_const.f90` | `subroutine header_const` | output |
| `hru_cs_mon.txt` | `header_const.f90` | `subroutine header_const` | output |
| `hru_cs_yr.csv` | `header_const.f90` | `subroutine header_const` | output |
| `hru_cs_yr.txt` | `header_const.f90` | `subroutine header_const` | output |
| `hru_endsim_soil_prop.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_endsim_soil_prop.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_ls_aa.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_ls_aa.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_ls_day.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_ls_day.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_ls_mon.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_ls_mon.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_ls_yr.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_ls_yr.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_n_p_pool_stat.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_n_p_pool_stat.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_nb_aa.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_nb_aa.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_nb_day.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_nb_day.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_nb_mon.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_nb_mon.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_nb_yr.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_nb_yr.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_ncycle_aa.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_ncycle_aa.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_ncycle_day.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_ncycle_day.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_ncycle_mon.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_ncycle_mon.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_ncycle_yr.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_ncycle_yr.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_nut_carb_gl_aa.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_nut_carb_gl_aa.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_nut_carb_gl_day.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_nut_carb_gl_day.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_nut_carb_gl_mon.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_nut_carb_gl_mon.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_nut_carb_gl_yr.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_nut_carb_gl_yr.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_org_allo_vars.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_org_allo_vars.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_org_ratio_vars.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_org_ratio_vars.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_org_trans_vars.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_org_trans_vars.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_orgc.txt` | `header_snutc.f90` | `subroutine header_snutc` | output |
| `hru_path_aa.csv` | `header_path.f90` | `subroutine header_path` | output |
| `hru_path_aa.txt` | `header_path.f90` | `subroutine header_path` | output |
| `hru_path_day.csv` | `header_path.f90` | `subroutine header_path` | output |
| `hru_path_day.txt` | `header_path.f90` | `subroutine header_path` | output |
| `hru_path_mon.csv` | `header_path.f90` | `subroutine header_path` | output |
| `hru_path_mon.txt` | `header_path.f90` | `subroutine header_path` | output |
| `hru_path_yr.csv` | `header_path.f90` | `subroutine header_path` | output |
| `hru_path_yr.txt` | `header_path.f90` | `subroutine header_path` | output |
| `hru_pest_aa.csv` | `header_pest.f90` | `subroutine header_pest` | output |
| `hru_pest_aa.txt` | `header_pest.f90` | `subroutine header_pest` | output |
| `hru_pest_day.csv` | `header_pest.f90` | `subroutine header_pest` | output |
| `hru_pest_day.txt` | `header_pest.f90` | `subroutine header_pest` | output |
| `hru_pest_mon.csv` | `header_pest.f90` | `subroutine header_pest` | output |
| `hru_pest_mon.txt` | `header_pest.f90` | `subroutine header_pest` | output |
| `hru_pest_yr.csv` | `header_pest.f90` | `subroutine header_pest` | output |
| `hru_pest_yr.txt` | `header_pest.f90` | `subroutine header_pest` | output |
| `hru_plc_stat.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_plc_stat.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_plcarb_aa.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_plcarb_aa.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_plcarb_day.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_plcarb_day.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_plcarb_mon.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_plcarb_mon.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_plcarb_yr.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_plcarb_yr.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_pw_aa.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_pw_aa.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_pw_day.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_pw_day.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_pw_mon.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_pw_mon.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_pw_yr.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_pw_yr.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_rescarb_aa.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_rescarb_aa.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_rescarb_day.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_rescarb_day.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_rescarb_mon.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_rescarb_mon.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_rescarb_yr.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_rescarb_yr.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_rsdc_stat.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_rsdc_stat.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_salt_aa.csv` | `header_salt.f90` | `subroutine header_salt` | output |
| `hru_salt_aa.txt` | `header_salt.f90` | `subroutine header_salt` | output |
| `hru_salt_day.csv` | `header_salt.f90` | `subroutine header_salt` | output |
| `hru_salt_day.txt` | `header_salt.f90` | `subroutine header_salt` | output |
| `hru_salt_mon.csv` | `header_salt.f90` | `subroutine header_salt` | output |
| `hru_salt_mon.txt` | `header_salt.f90` | `subroutine header_salt` | output |
| `hru_salt_yr.csv` | `header_salt.f90` | `subroutine header_salt` | output |
| `hru_salt_yr.txt` | `header_salt.f90` | `subroutine header_salt` | output |
| `hru_scf_aa.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_scf_aa.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_scf_day.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_scf_day.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_scf_mon.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_scf_mon.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_scf_yr.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_scf_yr.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_seq_lyr.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_seq_lyr.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_soilc_stat.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_soilc_stat.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_soilcarb_aa.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_soilcarb_aa.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_soilcarb_day.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_soilcarb_day.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_soilcarb_mb_stat.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_soilcarb_mb_stat.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_soilcarb_mon.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_soilcarb_mon.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_soilcarb_yr.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_soilcarb_yr.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_totc.txt` | `header_snutc.f90` | `subroutine header_snutc` | output |
| `hru_wb_aa.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_wb_aa.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_wb_day.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_wb_day.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_wb_mon.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_wb_mon.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_wb_yr.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hru_wb_yr.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `hydcon.csv` | `header_hyd.f90` | `subroutine header_hyd` | output |
| `hydin_aa.csv` | `header_hyd.f90` | `subroutine header_hyd` | output |
| `hydin_aa.txt` | `header_hyd.f90` | `subroutine header_hyd` | output |
| `hydin_day.csv` | `header_hyd.f90` | `subroutine header_hyd` | output |
| `hydin_day.txt` | `header_hyd.f90` | `subroutine header_hyd` | output |
| `hydin_metals_aa.csv` | `header_cs.f90` | `subroutine header_cs` | output |
| `hydin_metals_aa.txt` | `header_cs.f90` | `subroutine header_cs` | output |
| `hydin_metals_day.csv` | `header_cs.f90` | `subroutine header_cs` | output |
| `hydin_metals_day.txt` | `header_cs.f90` | `subroutine header_cs` | output |
| `hydin_metals_mon.csv` | `header_cs.f90` | `subroutine header_cs` | output |
| `hydin_metals_mon.txt` | `header_cs.f90` | `subroutine header_cs` | output |
| `hydin_metals_yr.csv` | `header_cs.f90` | `subroutine header_cs` | output |
| `hydin_metals_yr.txt` | `header_cs.f90` | `subroutine header_cs` | output |
| `hydin_mon.csv` | `header_hyd.f90` | `subroutine header_hyd` | output |
| `hydin_mon.txt` | `header_hyd.f90` | `subroutine header_hyd` | output |
| `hydin_paths_aa.csv` | `header_cs.f90` | `subroutine header_cs` | output |
| `hydin_paths_aa.txt` | `header_cs.f90` | `subroutine header_cs` | output |
| `hydin_paths_day.csv` | `header_cs.f90` | `subroutine header_cs` | output |
| `hydin_paths_day.txt` | `header_cs.f90` | `subroutine header_cs` | output |
| `hydin_paths_mon.csv` | `header_cs.f90` | `subroutine header_cs` | output |
| `hydin_paths_mon.txt` | `header_cs.f90` | `subroutine header_cs` | output |
| `hydin_paths_yr.csv` | `header_cs.f90` | `subroutine header_cs` | output |
| `hydin_paths_yr.txt` | `header_cs.f90` | `subroutine header_cs` | output |
| `hydin_pests_aa.csv` | `header_cs.f90` | `subroutine header_cs` | output |
| `hydin_pests_aa.txt` | `header_cs.f90` | `subroutine header_cs` | output |
| `hydin_pests_day.csv` | `header_cs.f90` | `subroutine header_cs` | output |
| `hydin_pests_day.txt` | `header_cs.f90` | `subroutine header_cs` | output |
| `hydin_pests_mon.csv` | `header_cs.f90` | `subroutine header_cs` | output |
| `hydin_pests_mon.txt` | `header_cs.f90` | `subroutine header_cs` | output |
| `hydin_pests_yr.csv` | `header_cs.f90` | `subroutine header_cs` | output |
| `hydin_pests_yr.txt` | `header_cs.f90` | `subroutine header_cs` | output |
| `hydin_salts_aa.csv` | `header_cs.f90` | `subroutine header_cs` | output |
| `hydin_salts_aa.txt` | `header_cs.f90` | `subroutine header_cs` | output |
| `hydin_salts_day.csv` | `header_cs.f90` | `subroutine header_cs` | output |
| `hydin_salts_day.txt` | `header_cs.f90` | `subroutine header_cs` | output |
| `hydin_salts_mon.csv` | `header_cs.f90` | `subroutine header_cs` | output |
| `hydin_salts_mon.txt` | `header_cs.f90` | `subroutine header_cs` | output |
| `hydin_salts_yr.csv` | `header_cs.f90` | `subroutine header_cs` | output |
| `hydin_salts_yr.txt` | `header_cs.f90` | `subroutine header_cs` | output |
| `hydin_yr.csv` | `header_hyd.f90` | `subroutine header_hyd` | output |
| `hydin_yr.txt` | `header_hyd.f90` | `subroutine header_hyd` | output |
| `hydout_aa.csv` | `header_hyd.f90` | `subroutine header_hyd` | output |
| `hydout_aa.txt` | `header_hyd.f90` | `subroutine header_hyd` | output |
| `hydout_day.csv` | `header_hyd.f90` | `subroutine header_hyd` | output |
| `hydout_day.txt` | `header_hyd.f90` | `subroutine header_hyd` | output |
| `hydout_metals_aa.csv` | `header_cs.f90` | `subroutine header_cs` | output |
| `hydout_metals_aa.txt` | `header_cs.f90` | `subroutine header_cs` | output |
| `hydout_metals_day.csv` | `header_cs.f90` | `subroutine header_cs` | output |
| `hydout_metals_day.txt` | `header_cs.f90` | `subroutine header_cs` | output |
| `hydout_metals_mon.csv` | `header_cs.f90` | `subroutine header_cs` | output |
| `hydout_metals_mon.txt` | `header_cs.f90` | `subroutine header_cs` | output |
| `hydout_metals_yr.csv` | `header_cs.f90` | `subroutine header_cs` | output |
| `hydout_metals_yr.txt` | `header_cs.f90` | `subroutine header_cs` | output |
| `hydout_mon.csv` | `header_hyd.f90` | `subroutine header_hyd` | output |
| `hydout_mon.txt` | `header_hyd.f90` | `subroutine header_hyd` | output |
| `hydout_paths_aa.csv` | `header_cs.f90` | `subroutine header_cs` | output |
| `hydout_paths_aa.txt` | `header_cs.f90` | `subroutine header_cs` | output |
| `hydout_paths_day.csv` | `header_cs.f90` | `subroutine header_cs` | output |
| `hydout_paths_day.txt` | `header_cs.f90` | `subroutine header_cs` | output |
| `hydout_paths_mon.csv` | `header_cs.f90` | `subroutine header_cs` | output |
| `hydout_paths_mon.txt` | `header_cs.f90` | `subroutine header_cs` | output |
| `hydout_paths_yr.csv` | `header_cs.f90` | `subroutine header_cs` | output |
| `hydout_paths_yr.txt` | `header_cs.f90` | `subroutine header_cs` | output |
| `hydout_pests_aa.csv` | `header_cs.f90` | `subroutine header_cs` | output |
| `hydout_pests_aa.txt` | `header_cs.f90` | `subroutine header_cs` | output |
| `hydout_pests_day.csv` | `header_cs.f90` | `subroutine header_cs` | output |
| `hydout_pests_day.txt` | `header_cs.f90` | `subroutine header_cs` | output |
| `hydout_pests_mon.csv` | `header_cs.f90` | `subroutine header_cs` | output |
| `hydout_pests_mon.txt` | `header_cs.f90` | `subroutine header_cs` | output |
| `hydout_pests_yr.csv` | `header_cs.f90` | `subroutine header_cs` | output |
| `hydout_pests_yr.txt` | `header_cs.f90` | `subroutine header_cs` | output |
| `hydout_salts_aa.csv` | `header_cs.f90` | `subroutine header_cs` | output |
| `hydout_salts_aa.txt` | `header_cs.f90` | `subroutine header_cs` | output |
| `hydout_salts_day.csv` | `header_cs.f90` | `subroutine header_cs` | output |
| `hydout_salts_day.txt` | `header_cs.f90` | `subroutine header_cs` | output |
| `hydout_salts_mon.csv` | `header_cs.f90` | `subroutine header_cs` | output |
| `hydout_salts_mon.txt` | `header_cs.f90` | `subroutine header_cs` | output |
| `hydout_salts_yr.csv` | `header_cs.f90` | `subroutine header_cs` | output |
| `hydout_salts_yr.txt` | `header_cs.f90` | `subroutine header_cs` | output |
| `hydout_yr.csv` | `header_hyd.f90` | `subroutine header_hyd` | output |
| `hydout_yr.txt` | `header_hyd.f90` | `subroutine header_hyd` | output |
| `hydrology-cal.hyd` | `header_write.f90` | `subroutine header_write` | unknown |
| `initial.aqu_cs` | `aqu_read_init_cs.f90` | `subroutine aqu_read_init_cs` | unknown |
| `initial.cha_cs` | `ch_read_init_cs.f90` | `subroutine ch_read_init_cs` | unknown |
| `looping.con` | `hyd_connect.f90` | `subroutine hyd_connect` | unknown |
| `lsunit_ls_aa.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `lsunit_ls_aa.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `lsunit_ls_day.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `lsunit_ls_day.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `lsunit_ls_mon.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `lsunit_ls_mon.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `lsunit_ls_yr.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `lsunit_ls_yr.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `lsunit_nb_aa.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `lsunit_nb_aa.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `lsunit_nb_day.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `lsunit_nb_day.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `lsunit_nb_mon.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `lsunit_nb_mon.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `lsunit_nb_yr.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `lsunit_nb_yr.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `lsunit_pw_aa.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `lsunit_pw_aa.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `lsunit_pw_day.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `lsunit_pw_day.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `lsunit_pw_mon.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `lsunit_pw_mon.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `lsunit_pw_yr.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `lsunit_pw_yr.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `lsunit_wb_aa.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `lsunit_wb_aa.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `lsunit_wb_day.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `lsunit_wb_day.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `lsunit_wb_mon.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `lsunit_wb_mon.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `lsunit_wb_yr.csv` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `lsunit_wb_yr.txt` | `output_landscape_init.f90` | `subroutine output_landscape_init` | output |
| `lu_change_out.txt` | `header_lu_change.f90` | `subroutine header_lu_change` | output |
| `manure.frt` | `manure_parm_read.f90` | `subroutine manure_parm_read` | reference, unknown |
| `manure_allo.mnu` | `manure_allocation_read.f90` | `subroutine manure_allocation_read` | unknown |
| `metals.mtl` | `input_file_module.f90` | `module input_file_module` | reference |
| `mgt_out.txt` | `header_mgt.f90` | `subroutine header_mgt` | output |
| `nutrients.rte` | `rte_read_nut.f90` | `subroutine rte_read_nut` | unknown |
| `object.prt` | `input_file_module.f90`, `object_read_output.f90` | `module input_file_module`, `subroutine object_read_output` | input, reference |
| `om_osrc.wal` | `om_osrc_read.f90` | `subroutine om_osrc_read` | unknown |
| `om_treat.wal` | `om_treat_read.f90` | `subroutine om_treat_read` | unknown |
| `om_use.wal` | `om_use_read.f90` | `subroutine om_use_read` | unknown |
| `outside_src.wal` | `water_osrc_read.f90` | `subroutine water_osrc_read` | unknown |
| `path_hru.ini` | `input_file_module.f90`, `path_hru_aqu_read.f90` | `module input_file_module`, `subroutine path_hru_aqu_read` | input, reference |
| `pest.com` | `recall_read.f90` | `subroutine recall_read` | unknown |
| `pest_metabolite.pes` | `pest_metabolite_read.f90` | `subroutine pest_metabolite_read` | reference, unknown |
| `plant_parms.cal` | `pl_write_parms_cal.f90` | `subroutine pl_write_parms_cal` | unknown |
| `puddle.ops` | `mgt_read_puddle.f90` | `subroutine mgt_read_puddle` | reference, unknown |
| `recall_aa.csv` | `header_write.f90` | `subroutine header_write` | output |
| `recall_aa.txt` | `header_write.f90` | `subroutine header_write` | output |
| `recall_day.csv` | `header_write.f90` | `subroutine header_write` | output |
| `recall_day.txt` | `header_write.f90` | `subroutine header_write` | output |
| `recall_db.rec` | `recall_read.f90` | `subroutine recalldb_read` | reference, unknown |
| `recall_mon.csv` | `header_write.f90` | `subroutine header_write` | output |
| `recall_mon.txt` | `header_write.f90` | `subroutine header_write` | output |
| `recall_yr.csv` | `header_write.f90` | `subroutine header_write` | output |
| `recall_yr.txt` | `header_write.f90` | `subroutine header_write` | output |
| `res_conds.dat` | `res_read_conds.f90` | `subroutine res_read_conds` | reference, unknown |
| `res_rel.dtl` | `dtbl_res_read.f90`, `input_file_module.f90` | `module input_file_module`, `subroutine dtbl_res_read` | input, reference |
| `reservoir.res_cs` | `res_read_salt_cs.f90` | `subroutine res_read_salt_cs` | unknown |
| `reservoir_aa.csv` | `header_reservoir.f90` | `subroutine header_reservoir` | output |
| `reservoir_aa.txt` | `header_reservoir.f90` | `subroutine header_reservoir` | output |
| `reservoir_cs_aa.csv` | `header_const.f90` | `subroutine header_const` | output |
| `reservoir_cs_aa.txt` | `header_const.f90` | `subroutine header_const` | output |
| `reservoir_cs_day.csv` | `header_const.f90` | `subroutine header_const` | output |
| `reservoir_cs_day.txt` | `header_const.f90` | `subroutine header_const` | output |
| `reservoir_cs_mon.csv` | `header_const.f90` | `subroutine header_const` | output |
| `reservoir_cs_mon.txt` | `header_const.f90` | `subroutine header_const` | output |
| `reservoir_cs_yr.csv` | `header_const.f90` | `subroutine header_const` | output |
| `reservoir_cs_yr.txt` | `header_const.f90` | `subroutine header_const` | output |
| `reservoir_day.csv` | `header_reservoir.f90` | `subroutine header_reservoir` | output |
| `reservoir_day.txt` | `header_reservoir.f90` | `subroutine header_reservoir` | output |
| `reservoir_mon.csv` | `header_reservoir.f90` | `subroutine header_reservoir` | output |
| `reservoir_mon.txt` | `header_reservoir.f90` | `subroutine header_reservoir` | output |
| `reservoir_pest_aa.csv` | `header_pest.f90` | `subroutine header_pest` | output |
| `reservoir_pest_aa.txt` | `header_pest.f90` | `subroutine header_pest` | output |
| `reservoir_pest_day.csv` | `header_pest.f90` | `subroutine header_pest` | output |
| `reservoir_pest_day.txt` | `header_pest.f90` | `subroutine header_pest` | output |
| `reservoir_pest_mon.csv` | `header_pest.f90` | `subroutine header_pest` | output |
| `reservoir_pest_mon.txt` | `header_pest.f90` | `subroutine header_pest` | output |
| `reservoir_pest_yr.csv` | `header_pest.f90` | `subroutine header_pest` | output |
| `reservoir_pest_yr.txt` | `header_pest.f90` | `subroutine header_pest` | output |
| `reservoir_salt_aa.csv` | `header_salt.f90` | `subroutine header_salt` | output |
| `reservoir_salt_aa.txt` | `header_salt.f90` | `subroutine header_salt` | output |
| `reservoir_salt_day.csv` | `header_salt.f90` | `subroutine header_salt` | output |
| `reservoir_salt_day.txt` | `header_salt.f90` | `subroutine header_salt` | output |
| `reservoir_salt_mon.csv` | `header_salt.f90` | `subroutine header_salt` | output |
| `reservoir_salt_mon.txt` | `header_salt.f90` | `subroutine header_salt` | output |
| `reservoir_salt_yr.csv` | `header_salt.f90` | `subroutine header_salt` | output |
| `reservoir_salt_yr.txt` | `header_salt.f90` | `subroutine header_salt` | output |
| `reservoir_yr.csv` | `header_reservoir.f90` | `subroutine header_reservoir` | output |
| `reservoir_yr.txt` | `header_reservoir.f90` | `subroutine header_reservoir` | output |
| `rout_unit_cs_aa.csv` | `header_const.f90` | `subroutine header_const` | output |
| `rout_unit_cs_aa.txt` | `header_const.f90` | `subroutine header_const` | output |
| `rout_unit_cs_day.csv` | `header_const.f90` | `subroutine header_const` | output |
| `rout_unit_cs_day.txt` | `header_const.f90` | `subroutine header_const` | output |
| `rout_unit_cs_mon.csv` | `header_const.f90` | `subroutine header_const` | output |
| `rout_unit_cs_mon.txt` | `header_const.f90` | `subroutine header_const` | output |
| `rout_unit_cs_yr.csv` | `header_const.f90` | `subroutine header_const` | output |
| `rout_unit_cs_yr.txt` | `header_const.f90` | `subroutine header_const` | output |
| `rout_unit_salt_aa.csv` | `header_salt.f90` | `subroutine header_salt` | output |
| `rout_unit_salt_aa.txt` | `header_salt.f90` | `subroutine header_salt` | output |
| `rout_unit_salt_day.csv` | `header_salt.f90` | `subroutine header_salt` | output |
| `rout_unit_salt_day.txt` | `header_salt.f90` | `subroutine header_salt` | output |
| `rout_unit_salt_mon.csv` | `header_salt.f90` | `subroutine header_salt` | output |
| `rout_unit_salt_mon.txt` | `header_salt.f90` | `subroutine header_salt` | output |
| `rout_unit_salt_yr.csv` | `header_salt.f90` | `subroutine header_salt` | output |
| `rout_unit_salt_yr.txt` | `header_salt.f90` | `subroutine header_salt` | output |
| `ru_aa.csv` | `header_write.f90` | `subroutine header_write` | output |
| `ru_aa.txt` | `header_write.f90` | `subroutine header_write` | output |
| `ru_day.csv` | `header_write.f90` | `subroutine header_write` | output |
| `ru_day.txt` | `header_write.f90` | `subroutine header_write` | output |
| `ru_mon.csv` | `header_write.f90` | `subroutine header_write` | output |
| `ru_mon.txt` | `header_write.f90` | `subroutine header_write` | output |
| `ru_yr.csv` | `header_write.f90` | `subroutine header_write` | output |
| `ru_yr.txt` | `header_write.f90` | `subroutine header_write` | output |
| `salt.slt` | `input_file_module.f90` | `module input_file_module` | reference |
| `salt_aqu.ini` | `salt_aqu_read.f90` | `subroutine salt_aqu_read` | reference, unknown |
| `salt_atmo.cli` | `cli_read_atmodep_salt.f90` | `subroutine cli_read_atmodep_salt` | reference, unknown |
| `salt_channel.ini` | `salt_cha_read.f90` | `subroutine salt_cha_read` | reference, unknown |
| `salt_fertilizer.frt` | `salt_fert_read.f90` | `subroutine salt_fert_read` | reference, unknown |
| `salt_hru.ini` | `input_file_module.f90`, `salt_hru_read.f90` | `module input_file_module`, `subroutine salt_hru_read` | reference, unknown |
| `salt_irrigation` | `salt_irr_read.f90` | `subroutine salt_irr_read` | unknown |
| `salt_plants` | `salt_plant_read.f90` | `subroutine salt_plant_read` | unknown |
| `salt_recall.rec` | `recall_read_salt.f90` | `subroutine recall_read_salt` | reference, unknown |
| `salt_res` | `res_read_saltdb.f90` | `subroutine res_read_saltdb` | unknown |
| `salt_road` | `salt_roadsalt_read.f90` | `subroutine salt_roadsalt_read` | unknown |
| `salt_uptake` | `salt_uptake_read.f90` | `subroutine salt_uptake_read` | unknown |
| `salt_urban` | `salt_urban_read.f90` | `subroutine salt_urban_read` | unknown |
| `satbuffer.str` | `sat_buff_read.f90` | `subroutine sat_buff_read` | reference, unknown |
| `scen_dtl.upd` | `cal_cond_read.f90` | `subroutine cal_cond_read` | unknown |
| `sd_chanbud_aa.csv` | `header_sd_channel.f90` | `subroutine header_sd_channel` | output |
| `sd_chanbud_aa.txt` | `header_sd_channel.f90` | `subroutine header_sd_channel` | output |
| `sd_chanbud_day.csv` | `header_sd_channel.f90` | `subroutine header_sd_channel` | output |
| `sd_chanbud_day.txt` | `header_sd_channel.f90` | `subroutine header_sd_channel` | output |
| `sd_chanbud_mon.csv` | `header_sd_channel.f90` | `subroutine header_sd_channel` | output |
| `sd_chanbud_mon.txt` | `header_sd_channel.f90` | `subroutine header_sd_channel` | output |
| `sd_chanbud_yr.csv` | `header_sd_channel.f90` | `subroutine header_sd_channel` | output |
| `sd_chanbud_yr.txt` | `header_sd_channel.f90` | `subroutine header_sd_channel` | output |
| `soil_lyr_depths.sol` | `soils_init.f90` | `subroutine soils_init` | reference, unknown |
| `transplant.plt` | `plant_transplant_read.f90` | `subroutine plant_transplant_read` | reference, unknown |
| `usgs_annual_head` | `gwflow_read.f90` | `subroutine gwflow_read` | unknown |
| `water_allo_aa.csv` | `header_water_allocation.f90` | `subroutine header_water_allocation` | output |
| `water_allo_aa.txt` | `header_water_allocation.f90` | `subroutine header_water_allocation` | output |
| `water_allo_day.csv` | `header_water_allocation.f90` | `subroutine header_water_allocation` | output |
| `water_allo_day.txt` | `header_water_allocation.f90` | `subroutine header_water_allocation` | output |
| `water_allo_mon.csv` | `header_water_allocation.f90` | `subroutine header_water_allocation` | output |
| `water_allo_mon.txt` | `header_water_allocation.f90` | `subroutine header_water_allocation` | output |
| `water_allo_yr.csv` | `header_water_allocation.f90` | `subroutine header_water_allocation` | output |
| `water_allo_yr.txt` | `header_water_allocation.f90` | `subroutine header_water_allocation` | output |
| `water_pipe.wal` | `water_pipe_read.f90` | `subroutine water_pipe_read` | unknown |
| `water_tower.wal` | `water_tower_read.f90` | `subroutine water_tower_read` | unknown |
| `water_treat.wal` | `water_treatment_read.f90` | `subroutine water_treatment_read` | unknown |
| `water_use.wal` | `water_use_read.f90` | `subroutine water_use_read` | unknown |
| `wetland.wet_cs` | `wet_read_salt_cs.f90` | `subroutine wet_read_salt_cs` | unknown |
| `wetland_aa.csv` | `header_wetland.f90` | `subroutine header_wetland` | output |
| `wetland_aa.txt` | `header_wetland.f90` | `subroutine header_wetland` | output |
| `wetland_cs_aa.csv` | `header_const.f90` | `subroutine header_const` | output |
| `wetland_cs_aa.txt` | `header_const.f90` | `subroutine header_const` | output |
| `wetland_cs_day.csv` | `header_const.f90` | `subroutine header_const` | output |
| `wetland_cs_day.txt` | `header_const.f90` | `subroutine header_const` | output |
| `wetland_cs_mon.csv` | `header_const.f90` | `subroutine header_const` | output |
| `wetland_cs_mon.txt` | `header_const.f90` | `subroutine header_const` | output |
| `wetland_cs_yr.csv` | `header_const.f90` | `subroutine header_const` | output |
| `wetland_cs_yr.txt` | `header_const.f90` | `subroutine header_const` | output |
| `wetland_day.csv` | `header_wetland.f90` | `subroutine header_wetland` | output |
| `wetland_day.txt` | `header_wetland.f90` | `subroutine header_wetland` | output |
| `wetland_mon.csv` | `header_wetland.f90` | `subroutine header_wetland` | output |
| `wetland_mon.txt` | `header_wetland.f90` | `subroutine header_wetland` | output |
| `wetland_salt_aa.csv` | `header_salt.f90` | `subroutine header_salt` | output |
| `wetland_salt_aa.txt` | `header_salt.f90` | `subroutine header_salt` | output |
| `wetland_salt_day.csv` | `header_salt.f90` | `subroutine header_salt` | output |
| `wetland_salt_day.txt` | `header_salt.f90` | `subroutine header_salt` | output |
| `wetland_salt_mon.csv` | `header_salt.f90` | `subroutine header_salt` | output |
| `wetland_salt_mon.txt` | `header_salt.f90` | `subroutine header_salt` | output |
| `wetland_salt_yr.csv` | `header_salt.f90` | `subroutine header_salt` | output |
| `wetland_salt_yr.txt` | `header_salt.f90` | `subroutine header_salt` | output |
| `wetland_yr.csv` | `header_wetland.f90` | `subroutine header_wetland` | output |
| `wetland_yr.txt` | `header_wetland.f90` | `subroutine header_wetland` | output |
| `yield.csv` | `header_yield.f90` | `subroutine header_yield` | output |

## Summary

- **Files in provided list:** 192
- **Files from list found in code:** 146
- **Files from list NOT found in code:** 46
- **Files in code NOT on provided list:** 748
- **Total unique files referenced in code:** 894
- **Total input files:** 270
- **Total output files:** 624
- **Variable-to-filename mappings:** 154
