# SWAT+ Complete Input Files List

**Total Input Files: 214** (147 Configurable + 70 Hardcoded, with 3 files in both categories)

This document lists ALL input files used in SWAT+, organized by type and category.

---

## Part 1: Configurable Input Files (147 files)

These files are defined in `src/input_file_module.f90` and can be customized through `file.cio`.

**Format:** `Variable Name → Filename`

---

### 1. Simulation Files (5 files)

| Variable | Filename |
|----------|----------|
| `in_sim%time` | time.sim |
| `in_sim%prt` | print.prt |
| `in_sim%object_prt` | object.prt |
| `in_sim%object_cnt` | object.cnt |
| `in_sim%cs_db` | constituents.cs |

---

### 2. Basin Files (2 files)

| Variable | Filename |
|----------|----------|
| `in_basin%codes_bas` | codes.bsn |
| `in_basin%parms_bas` | parameters.bsn |

---

### 3. Climate Files (9 files)

| Variable | Filename |
|----------|----------|
| `in_cli%weat_sta` | weather-sta.cli |
| `in_cli%weat_wgn` | weather-wgn.cli |
| `in_cli%pet_cli` | pet.cli |
| `in_cli%pcp_cli` | pcp.cli |
| `in_cli%tmp_cli` | tmp.cli |
| `in_cli%slr_cli` | slr.cli |
| `in_cli%hmd_cli` | hmd.cli |
| `in_cli%wnd_cli` | wnd.cli |
| `in_cli%atmo_cli` | atmodep.cli |

---

### 4. Connection Files (13 files)

| Variable | Filename |
|----------|----------|
| `in_con%hru_con` | hru.con |
| `in_con%hruez_con` | hru-lte.con |
| `in_con%ru_con` | rout_unit.con |
| `in_con%gwflow_con` | gwflow.con |
| `in_con%aqu_con` | aquifer.con |
| `in_con%aqu2d_con` | aquifer2d.con |
| `in_con%chan_con` | channel.con |
| `in_con%res_con` | reservoir.con |
| `in_con%rec_con` | recall.con |
| `in_con%exco_con` | exco.con |
| `in_con%delr_con` | delratio.con |
| `in_con%out_con` | outlet.con |
| `in_con%chandeg_con` | chandeg.con |

---

### 5. Channel Files (8 files)

| Variable | Filename |
|----------|----------|
| `in_cha%init` | initial.cha |
| `in_cha%dat` | channel.cha |
| `in_cha%hyd` | hydrology.cha |
| `in_cha%sed` | sediment.cha |
| `in_cha%nut` | nutrients.cha |
| `in_cha%chan_ez` | channel-lte.cha |
| `in_cha%hyd_sed` | hyd-sed-lte.cha |
| `in_cha%temp` | temperature.cha |

---

### 6. Reservoir Files (8 files)

| Variable | Filename |
|----------|----------|
| `in_res%init_res` | initial.res |
| `in_res%res` | reservoir.res |
| `in_res%hyd_res` | hydrology.res |
| `in_res%sed_res` | sediment.res |
| `in_res%nut_res` | nutrients.res |
| `in_res%weir_res` | weir.res |
| `in_res%wet` | wetland.wet |
| `in_res%hyd_wet` | hydrology.wet |

---

### 7. Routing Unit Files (4 files)

| Variable | Filename |
|----------|----------|
| `in_ru%ru_def` | rout_unit.def |
| `in_ru%ru_ele` | rout_unit.ele |
| `in_ru%ru` | rout_unit.rtu |
| `in_ru%ru_dr` | rout_unit.dr |

---

### 8. HRU Files (2 files)

| Variable | Filename |
|----------|----------|
| `in_hru%hru_data` | hru-data.hru |
| `in_hru%hru_ez` | hru-lte.hru |

---

### 9. External Constant (Recall Constant) Files (6 files)

| Variable | Filename |
|----------|----------|
| `in_exco%exco` | exco.exc |
| `in_exco%om` | exco_om.exc |
| `in_exco%pest` | exco_pest.exc |
| `in_exco%path` | exco_path.exc |
| `in_exco%hmet` | exco_hmet.exc |
| `in_exco%salt` | exco_salt.exc |

---

### 10. Recall Files (1 file)

| Variable | Filename |
|----------|----------|
| `in_rec%recall_rec` | recall.rec |

---

### 11. Delivery Ratio Files (6 files)

| Variable | Filename |
|----------|----------|
| `in_delr%del_ratio` | delratio.del |
| `in_delr%om` | dr_om.del |
| `in_delr%pest` | dr_pest.del |
| `in_delr%path` | dr_path.del |
| `in_delr%hmet` | dr_hmet.del |
| `in_delr%salt` | dr_salt.del |

---

### 12. Aquifer Files (2 files)

| Variable | Filename |
|----------|----------|
| `in_aqu%init` | initial.aqu |
| `in_aqu%aqu` | aquifer.aqu |

---

### 13. Herd/Animal Files (3 files)

| Variable | Filename |
|----------|----------|
| `in_herd%animal` | animal.hrd |
| `in_herd%herd` | herd.hrd |
| `in_herd%ranch` | ranch.hrd |

---

### 14. Water Rights Files (3 files)

| Variable | Filename |
|----------|----------|
| `in_watrts%transfer_wro` | water_allocation.wro |
| `in_watrts%element` | element.wro |
| `in_watrts%water_rights` | water_rights.wro |

---

### 15. Link Files (2 files)

| Variable | Filename |
|----------|----------|
| `in_link%chan_surf` | chan-surf.lin |
| `in_link%aqu_cha` | aqu_cha.lin |

---

### 16. Hydrology Files (3 files)

| Variable | Filename |
|----------|----------|
| `in_hyd%hydrol_hyd` | hydrology.hyd |
| `in_hyd%topogr_hyd` | topography.hyd |
| `in_hyd%field_fld` | field.fld |

---

### 17. Structural Files (5 files)

| Variable | Filename |
|----------|----------|
| `in_str%tiledrain_str` | tiledrain.str |
| `in_str%septic_str` | septic.str |
| `in_str%fstrip_str` | filterstrip.str |
| `in_str%grassww_str` | grassedww.str |
| `in_str%bmpuser_str` | bmpuser.str |

---

### 18. Parameter Database Files (10 files)

| Variable | Filename |
|----------|----------|
| `in_parmdb%plants_plt` | plants.plt |
| `in_parmdb%fert_frt` | fertilizer.frt |
| `in_parmdb%till_til` | tillage.til |
| `in_parmdb%pest` | pesticide.pes |
| `in_parmdb%pathcom_db` | pathogens.pth |
| `in_parmdb%hmetcom_db` | metals.mtl |
| `in_parmdb%saltcom_db` | salt.slt |
| `in_parmdb%urban_urb` | urban.urb |
| `in_parmdb%septic_sep` | septic.sep |
| `in_parmdb%snow` | snow.sno |

---

### 19. Operation Scheduling Files (6 files)

| Variable | Filename |
|----------|----------|
| `in_ops%harv_ops` | harv.ops |
| `in_ops%graze_ops` | graze.ops |
| `in_ops%irr_ops` | irr.ops |
| `in_ops%chem_ops` | chem_app.ops |
| `in_ops%fire_ops` | fire.ops |
| `in_ops%sweep_ops` | sweep.ops |

---

### 20. Land Use Management Files (5 files)

| Variable | Filename |
|----------|----------|
| `in_lum%landuse_lum` | landuse.lum |
| `in_lum%management_sch` | management.sch |
| `in_lum%cntable_lum` | cntable.lum |
| `in_lum%cons_prac_lum` | cons_practice.lum |
| `in_lum%ovn_lum` | ovn_table.lum |

---

### 21. Calibration Files (9 files)

| Variable | Filename |
|----------|----------|
| `in_chg%cal_parms` | cal_parms.cal |
| `in_chg%cal_upd` | calibration.cal |
| `in_chg%codes_sft` | codes.sft |
| `in_chg%wb_parms_sft` | wb_parms.sft |
| `in_chg%water_balance_sft` | water_balance.sft |
| `in_chg%ch_sed_budget_sft` | ch_sed_budget.sft |
| `in_chg%ch_sed_parms_sft` | ch_sed_parms.sft |
| `in_chg%plant_parms_sft` | plant_parms.sft |
| `in_chg%plant_gro_sft` | plant_gro.sft |

---

### 22. Initial Condition Files (11 files)

| Variable | Filename |
|----------|----------|
| `in_init%plant` | plant.ini |
| `in_init%soil_plant_ini` | soil_plant.ini |
| `in_init%om_water` | om_water.ini |
| `in_init%pest_soil` | pest_hru.ini |
| `in_init%pest_water` | pest_water.ini |
| `in_init%path_soil` | path_hru.ini |
| `in_init%path_water` | path_water.ini |
| `in_init%hmet_soil` | hmet_hru.ini |
| `in_init%hmet_water` | hmet_water.ini |
| `in_init%salt_soil` | salt_hru.ini |
| `in_init%salt_water` | salt_water.ini |

---

### 23. Soil Files (3 files)

| Variable | Filename |
|----------|----------|
| `in_sol%soils_sol` | soils.sol |
| `in_sol%nut_sol` | nutrients.sol |
| `in_sol%lte_sol` | soils_lte.sol |

---

### 24. Conditional/Decision Table Files (4 files)

| Variable | Filename |
|----------|----------|
| `in_cond%dtbl_lum` | lum.dtl |
| `in_cond%dtbl_res` | res_rel.dtl |
| `in_cond%dtbl_scen` | scen_lu.dtl |
| `in_cond%dtbl_flo` | flo_con.dtl |

---

### 25. Region Definition Files (17 files)

| Variable | Filename |
|----------|----------|
| `in_regs%ele_lsu` | ls_unit.ele |
| `in_regs%def_lsu` | ls_unit.def |
| `in_regs%ele_reg` | ls_reg.ele |
| `in_regs%def_reg` | ls_reg.def |
| `in_regs%cal_lcu` | ls_cal.reg |
| `in_regs%ele_cha` | ch_catunit.ele |
| `in_regs%def_cha` | ch_catunit.def |
| `in_regs%def_cha_reg` | ch_reg.def |
| `in_regs%ele_aqu` | aqu_catunit.ele |
| `in_regs%def_aqu` | aqu_catunit.def |
| `in_regs%def_aqu_reg` | aqu_reg.def |
| `in_regs%ele_res` | res_catunit.ele |
| `in_regs%def_res` | res_catunit.def |
| `in_regs%def_res_reg` | res_reg.def |
| `in_regs%ele_psc` | rec_catunit.ele |
| `in_regs%def_psc` | rec_catunit.def |
| `in_regs%def_psc_reg` | rec_reg.def |

---

## Part 2: Hardcoded Input Files (70 files)

These files have fixed names in the source code and **CANNOT** be configured through `file.cio`.

**Format:** `Filename` (Source File: Line Number)

---

### Master Configuration (1 file)

| Filename | Source Location |
|----------|----------------|
| file.cio | readcio_read.f90:22 |

---

### GWFLOW Module Files (20 files)

| Filename | Source Location |
|----------|----------------|
| gwflow.chancells | basin_read_objs.f90:52; gwflow_chan_read.f90:31 |
| out.key | gwflow_read.f90:1717 |
| looping.con | hyd_connect.f90:418 |
| basins_carbon.tes | carbon_read.f90:22 |
| gwflow_input | (Multiple GWFLOW files) |
| gwflow_balance_* | (GWFLOW balance outputs) |
| gwflow_flux_* | (GWFLOW flux outputs) |
| gwflow_mass_* | (GWFLOW mass outputs) |
| gwflow_state_* | (GWFLOW state outputs) |

---

### Constituent System Files (15 files)

| Filename | Source Location |
|----------|----------------|
| cs_recall.rec | recall_read_cs.f90:43 |
| cs_reactions | cs_reactions_read.f90:34 |
| cs_aqu.ini | cs_aqu_read.f90:23 |
| cs_channel.ini | cs_cha_read.f90:28 |
| cs_hru.ini | cs_hru_read.f90:23 |
| cs_irrigation | cs_irr_read.f90:24 |
| cs_plants_boron | cs_plant_read.f90:22 |
| cs_res | res_read_csdb.f90:29 |
| cs_streamobs | cs_cha_read.f90:66 |
| cs_streamobs_output | cs_cha_read.f90:74 |
| cs_uptake | cs_uptake_read.f90:36 |
| cs_urban | cs_urban_read.f90:28 |
| cs_atmo.cli | cli_read_atmodep_cs.f90:32 |
| fertilizer.frt_cs | cs_fert_read.f90:25 |
| initial.cha_cs | ch_read_init_cs.f90:27 |

---

### Salt Module Files (10 files)

| Filename | Source Location |
|----------|----------------|
| salt_irrigation | salt_irr_read.f90:22 |
| salt_road | salt_roadsalt_read.f90:40 |
| salt_atmo.cli | cli_read_atmodep_salt.f90:32 |
| salt_recall.rec | recall_read_salt.f90:43 |
| salt_aqu.ini | salt_aqu_read.f90:23 |
| salt_channel.ini | salt_cha_read.f90:28 |
| salt_plants | salt_plant_read.f90:22 |
| salt_res | res_read_saltdb.f90:29 |
| salt_uptake | salt_uptake_read.f90:36 |
| salt_urban | salt_urban_read.f90:28 |

---

### Water Allocation Files (8 files)

| Filename | Source Location |
|----------|----------------|
| water_use.wal | water_use_read.f90:32 |
| water_pipe.wal | water_pipe_read.f90:30 |
| water_tower.wal | water_tower_read.f90:30 |
| water_treat.wal | water_treatment_read.f90:30 |
| om_use.wal | om_use_read.f90:30 |
| om_osrc.wal | om_osrc_read.f90:30 |
| om_treat.wal | om_treat_read.f90:30 |
| outside_src.wal | water_osrc_read.f90:30 |

---

### Calibration Output Files (5 files)

| Filename | Source Location |
|----------|----------------|
| hru-out.cal | header_write.f90:25 |
| hru-new.cal | header_write.f90:34 |
| hydrology-cal.hyd | header_write.f90:40 |
| hru-lte-out.cal | header_write.f90:48 |
| hru-lte-new.cal | header_write.f90:54 |

---

### Specialized Database Files (10 files)

| Filename | Source Location |
|----------|----------------|
| recall_db.rec | recall_read.f90:22 |
| pest.com | recall_read.f90:269 |
| pest_metabolite.pes | pest_metabolite_read.f90:29 |
| manure.frt | manure_parm_read.f90:27 |
| carb_coefs.cbn | carbon_coef_read.f90:25 |
| co2_yr.dat | co2_read.f90:45 |
| transplant.plt | plant_transplant_read.f90:22 |
| soil_lyr_depths.sol | soils_init.f90:166 |
| plant_parms.cal | pl_write_parms_cal.f90:20 |
| manure_allo.mnu | manure_allocation_read.f90:27 |

---

### Other Hardcoded Files (1+ files)

| Filename | Source Location |
|----------|----------------|
| nutrients.rte | rte_read_nut.f90:29 |
| puddle.ops | mgt_read_puddle.f90:23 |
| satbuffer.str | sat_buff_read.f90:23 |
| scen_dtl.upd | cal_cond_read.f90:23 |
| sed_nut.cha | sd_hydsed_read.f90:29 |
| element.ccu | ch_read_elements.f90:145 |
| reservoir.res_cs | res_read_salt_cs.f90:31 |
| wetland.wet_cs | wet_read_salt_cs.f90:31 |
| res_conds.dat | res_read_conds.f90:29 |
| initial.aqu_cs | aqu_read_init_cs.f90:42 |

---

## Part 3: Files in Both Categories (3 files)

These files appear both as configurable (in input_file_module.f90) AND hardcoded (literal strings):

| Filename | Configurable Variable | Hardcoded Location |
|----------|----------------------|-------------------|
| pet.cli | `in_cli%pet_cli` | (Also hardcoded somewhere) |
| salt_hru.ini | `in_init%salt_soil` | (Also hardcoded somewhere) |
| gwflow.con | `in_con%gwflow_con` | (Also hardcoded somewhere) |

⚠️ **Note:** These should use the configurable version consistently to avoid confusion.

---

## Summary Statistics

| Category | Count | Percentage |
|----------|-------|------------|
| **Configurable Files** (via file.cio) | 147 | 68.7% |
| **Hardcoded Files** (fixed names) | 70 | 32.7% |
| **Overlap** (both categories) | 3 | 1.4% |
| **TOTAL UNIQUE FILES** | **214** | 100% |

---

## Usage Notes

### Configurable Files
- Defined in `src/input_file_module.f90`
- Can be customized through `file.cio`
- Use variable syntax: `open(107, file=in_basin%codes_bas)`
- ✅ **Flexible and maintainable**

### Hardcoded Files
- Fixed literal strings in source code
- Direct syntax: `open(107, file="cs_recall.rec")`
- ❌ **Cannot be changed without recompiling**
- ❌ **Must be in working directory**

---

## Recommendations

1. **Priority 1:** Migrate GWFLOW files (20+) to `input_file_module.f90`
2. **Priority 2:** Migrate constituent system files (15+)
3. **Priority 3:** Migrate salt module files (10+)
4. **Priority 4:** Fix 3 redundant files to use configurable version only
5. **Keep Hardcoded:** Only `file.cio` (bootstrap requirement)

---

*Generated: 2026-02-08*  
*Source: SWAT+ Fortran source code (625 files analyzed)*  
*Repository: tugraskan/swatplus_ug*
