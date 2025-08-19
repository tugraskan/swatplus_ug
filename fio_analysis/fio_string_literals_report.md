# SWAT+ UG File I/O Operations Using String Literals

## Executive Summary

**Total Files with FIO String Literals:** 77
**Total FIO String Literal Occurrences:** 828

## Analysis Scope

This analysis specifically identifies File I/O operations that use hardcoded string literals instead of variables for file names. The focus is on:

- `open()` statements with file="string"
- `inquire()` statements with file="string"
- `read()` statements with file="string"
- `write()` statements with file="string"
- `close()` statements with file="string"
- Formatted I/O with hardcoded filenames

## Summary by Operation Type

**INQUIRE:** 70 occurrences
**OPEN:** 758 occurrences

## Summary by File

**output_landscape_init.f90:** 201 occurrences
**gwflow_read.f90:** 77 occurrences
**header_write.f90:** 76 occurrences
**header_cs.f90:** 64 occurrences
**header_pest.f90:** 64 occurrences
**header_const.f90:** 52 occurrences
**header_salt.f90:** 52 occurrences
**header_hyd.f90:** 26 occurrences
**header_sd_channel.f90:** 26 occurrences
**swift_output.f90:** 14 occurrences
**header_reservoir.f90:** 9 occurrences
**header_aquifer.f90:** 8 occurrences
**header_channel.f90:** 8 occurrences
**header_path.f90:** 8 occurrences
**header_water_allocation.f90:** 8 occurrences
**header_wetland.f90:** 8 occurrences
**cs_cha_read.f90:** 5 occurrences
**header_yield.f90:** 4 occurrences
**basin_read_objs.f90:** 3 occurrences
**co2_read.f90:** 3 occurrences
**header_snutc.f90:** 3 occurrences
**proc_bsn.f90:** 3 occurrences
**aqu_read_init_cs.f90:** 2 occurrences
**cal_cond_read.f90:** 2 occurrences
**carbon_coef_read.f90:** 2 occurrences
**carbon_read.f90:** 2 occurrences
**ch_read_elements.f90:** 2 occurrences
**ch_read_init_cs.f90:** 2 occurrences
**cli_read_atmodep_cs.f90:** 2 occurrences
**cli_read_atmodep_salt.f90:** 2 occurrences
**cs_aqu_read.f90:** 2 occurrences
**cs_fert_read.f90:** 2 occurrences
**cs_hru_read.f90:** 2 occurrences
**cs_irr_read.f90:** 2 occurrences
**cs_plant_read.f90:** 2 occurrences
**cs_reactions_read.f90:** 2 occurrences
**cs_uptake_read.f90:** 2 occurrences
**cs_urban_read.f90:** 2 occurrences
**gwflow_chan_read.f90:** 2 occurrences
**hyd_connect.f90:** 2 occurrences
**manure_allocation_read.f90:** 2 occurrences
**manure_parm_read.f90:** 2 occurrences
**mgt_read_puddle.f90:** 2 occurrences
**pest_metabolite_read.f90:** 2 occurrences
**plant_transplant_read.f90:** 2 occurrences
**proc_hru.f90:** 2 occurrences
**readcio_read.f90:** 2 occurrences
**recall_read.f90:** 2 occurrences
**recall_read_cs.f90:** 2 occurrences
**recall_read_salt.f90:** 2 occurrences
**res_read_conds.f90:** 2 occurrences
**res_read_cs.f90:** 2 occurrences
**res_read_csdb.f90:** 2 occurrences
**res_read_salt.f90:** 2 occurrences
**res_read_salt_cs.f90:** 2 occurrences
**res_read_saltdb.f90:** 2 occurrences
**rte_read_nut.f90:** 2 occurrences
**salt_aqu_read.f90:** 2 occurrences
**salt_cha_read.f90:** 2 occurrences
**salt_fert_read.f90:** 2 occurrences
**salt_hru_read.f90:** 2 occurrences
**salt_irr_read.f90:** 2 occurrences
**salt_plant_read.f90:** 2 occurrences
**salt_roadsalt_read.f90:** 2 occurrences
**salt_uptake_read.f90:** 2 occurrences
**salt_urban_read.f90:** 2 occurrences
**sat_buff_read.f90:** 2 occurrences
**sd_hydsed_read.f90:** 2 occurrences
**soil_plant_init_cs.f90:** 2 occurrences
**soils_init.f90:** 2 occurrences
**treat_read_om.f90:** 2 occurrences
**wet_read_hyd.f90:** 2 occurrences
**wet_read_salt_cs.f90:** 2 occurrences
**basin_read_cc.f90:** 1 occurrences
**header_lu_change.f90:** 1 occurrences
**header_mgt.f90:** 1 occurrences
**pl_write_parms_cal.f90:** 1 occurrences

## Detailed Findings

### aqu_read_init_cs.f90

**Line 43** (inquire):
```fortran
inquire (file="initial.aqu_cs",exist=i_exist)
```
String literal: `initial.aqu_cs`

**Line 47** (open):
```fortran
open (105,file="initial.aqu_cs")
```
String literal: `initial.aqu_cs`

### basin_read_cc.f90

**Line 31** (open):
```fortran
open (140,file = 'pet.cli')
```
String literal: `pet.cli`

### basin_read_objs.f90

**Line 49** (inquire):
```fortran
inquire(file='gwflow.chancells',exist=i_exist)
```
String literal: `gwflow.chancells`

**Line 52** (open):
```fortran
open(107,file='gwflow.chancells')
```
String literal: `gwflow.chancells`

**Line 85** (open):
```fortran
open(out_gw,file='gwflow_record')
```
String literal: `gwflow_record`

### cal_cond_read.f90

**Line 38** (inquire):
```fortran
inquire (file="scen_dtl.upd", exist=i_exist)
```
String literal: `scen_dtl.upd`

**Line 43** (open):
```fortran
open (107,file="scen_dtl.upd")
```
String literal: `scen_dtl.upd`

### carbon_coef_read.f90

**Line 38** (inquire):
```fortran
inquire (file='carb_coefs.cbn', exist=i_exist)
```
String literal: `carb_coefs.cbn`

**Line 40** (open):
```fortran
open (107,file='carb_coefs.cbn', iostat=eof)
```
String literal: `carb_coefs.cbn`

### carbon_read.f90

**Line 17** (inquire):
```fortran
inquire (file='basins_carbon.tes', exist=i_exist)
```
String literal: `basins_carbon.tes`

**Line 22** (open):
```fortran
open (104,file='basins_carbon.tes')
```
String literal: `basins_carbon.tes`

### ch_read_elements.f90

**Line 140** (inquire):
```fortran
inquire (file="element.ccu", exist=i_exist)
```
String literal: `element.ccu`

**Line 143** (open):
```fortran
open (107,file="element.ccu")
```
String literal: `element.ccu`

### ch_read_init_cs.f90

**Line 22** (inquire):
```fortran
inquire (file="initial.cha_cs", exist=i_exist)
```
String literal: `initial.cha_cs`

**Line 27** (open):
```fortran
open (105,file="initial.cha_cs")
```
String literal: `initial.cha_cs`

### cli_read_atmodep_cs.f90

**Line 32** (inquire):
```fortran
inquire (file='cs_atmo.cli',exist=i_exist)
```
String literal: `cs_atmo.cli`

**Line 37** (open):
```fortran
open(5050,file='cs_atmo.cli')
```
String literal: `cs_atmo.cli`

### cli_read_atmodep_salt.f90

**Line 33** (inquire):
```fortran
inquire (file='salt_atmo.cli',exist=i_exist)
```
String literal: `salt_atmo.cli`

**Line 38** (open):
```fortran
open(5050,file='salt_atmo.cli')
```
String literal: `salt_atmo.cli`

### co2_read.f90

**Line 34** (open):
```fortran
open (2222,file="co2.out")
```
String literal: `co2.out`

**Line 40** (inquire):
```fortran
inquire (file="co2_yr.dat", exist=i_exist)
```
String literal: `co2_yr.dat`

**Line 44** (open):
```fortran
open (107,file="co2_yr.dat")
```
String literal: `co2_yr.dat`

### cs_aqu_read.f90

**Line 20** (inquire):
```fortran
inquire (file="cs_aqu.ini", exist=i_exist)
```
String literal: `cs_aqu.ini`

**Line 23** (open):
```fortran
open (107,file="cs_aqu.ini")
```
String literal: `cs_aqu.ini`

### cs_cha_read.f90

**Line 25** (inquire):
```fortran
inquire (file="cs_channel.ini", exist=i_exist)
```
String literal: `cs_channel.ini`

**Line 28** (open):
```fortran
open (107,file="cs_channel.ini")
```
String literal: `cs_channel.ini`

**Line 64** (inquire):
```fortran
inquire (file="cs_streamobs", exist=i_exist)
```
String literal: `cs_streamobs`

**Line 66** (open):
```fortran
open(107,file='cs_streamobs')
```
String literal: `cs_streamobs`

**Line 74** (open):
```fortran
open(8200,file='cs_streamobs_output')
```
String literal: `cs_streamobs_output`

### cs_fert_read.f90

**Line 24** (inquire):
```fortran
inquire (file="fertilizer.frt_cs", exist=i_exist)
```
String literal: `fertilizer.frt_cs`

**Line 26** (open):
```fortran
open (107,file="fertilizer.frt_cs")
```
String literal: `fertilizer.frt_cs`

### cs_hru_read.f90

**Line 20** (inquire):
```fortran
inquire (file="cs_hru.ini", exist=i_exist)
```
String literal: `cs_hru.ini`

**Line 23** (open):
```fortran
open (107,file="cs_hru.ini")
```
String literal: `cs_hru.ini`

### cs_irr_read.f90

**Line 21** (inquire):
```fortran
inquire (file="cs_irrigation", exist=i_exist)
```
String literal: `cs_irrigation`

**Line 24** (open):
```fortran
open (107,file="cs_irrigation")
```
String literal: `cs_irrigation`

### cs_plant_read.f90

**Line 18** (inquire):
```fortran
inquire (file="cs_plants_boron", exist=i_exist)
```
String literal: `cs_plants_boron`

**Line 22** (open):
```fortran
open(107,file="cs_plants_boron")
```
String literal: `cs_plants_boron`

### cs_reactions_read.f90

**Line 30** (inquire):
```fortran
inquire (file="cs_reactions", exist=i_exist)
```
String literal: `cs_reactions`

**Line 34** (open):
```fortran
open(107,file="cs_reactions")
```
String literal: `cs_reactions`

### cs_uptake_read.f90

**Line 32** (inquire):
```fortran
inquire (file='cs_uptake',exist=i_exist)
```
String literal: `cs_uptake`

**Line 39** (open):
```fortran
open(5054,file='cs_uptake')
```
String literal: `cs_uptake`

### cs_urban_read.f90

**Line 24** (inquire):
```fortran
inquire (file='cs_urban',exist=i_exist)
```
String literal: `cs_urban`

**Line 28** (open):
```fortran
open(5054,file='cs_urban')
```
String literal: `cs_urban`

### gwflow_chan_read.f90

**Line 35** (open):
```fortran
open(1280,file='gwflow.chancells')
```
String literal: `gwflow.chancells`

**Line 36** (open):
```fortran
open(1281,file='gwflow.con')
```
String literal: `gwflow.con`

### gwflow_read.f90

**Line 172** (open):
```fortran
open(in_gw,file='gwflow.input')
```
String literal: `gwflow.input`

**Line 204** (inquire):
```fortran
inquire(file='gwflow.hrucell',exist=i_exist)
```
String literal: `gwflow.hrucell`

**Line 211** (inquire):
```fortran
inquire(file='gwflow.lsucell',exist=i_exist) !try LSU-cell connection instead
```
String literal: `gwflow.lsucell`

**Line 222** (inquire):
```fortran
inquire(file='gwflow.lsucell',exist=i_exist)
```
String literal: `gwflow.lsucell`

**Line 233** (inquire):
```fortran
inquire(file='gwflow.hrucell',exist=i_exist) !try HRU-cell connection instead
```
String literal: `gwflow.hrucell`

**Line 642** (inquire):
```fortran
inquire(file='usgs_annual_head',exist=i_exist)
```
String literal: `usgs_annual_head`

**Line 657** (open):
```fortran
open(out_gwobs,file='gwflow_state_obs_head')
```
String literal: `gwflow_state_obs_head`

**Line 687** (open):
```fortran
open(in_usgs_head,file='usgs_annual_head')
```
String literal: `usgs_annual_head`

**Line 702** (open):
```fortran
open(out_gwobs_usgs,file='gwflow_state_obs_head_usgs')
```
String literal: `gwflow_state_obs_head_usgs`

**Line 788** (open):
```fortran
open(out_gw_rech,file='gwflow_flux_rech')
```
String literal: `gwflow_flux_rech`

**Line 796** (open):
```fortran
open(out_gw_et,file='gwflow_flux_gwet')
```
String literal: `gwflow_flux_gwet`

**Line 814** (open):
```fortran
open(out_gwsw,file='gwflow_flux_gwsw')
```
String literal: `gwflow_flux_gwsw`

**Line 846** (open):
```fortran
open(out_gw_soil,file='gwflow_flux_soil')
```
String literal: `gwflow_flux_soil`

**Line 901** (open):
```fortran
open(out_gw_satex,file='gwflow_flux_satx')
```
String literal: `gwflow_flux_satx`

**Line 908** (open):
```fortran
open(out_gw_pumpag,file='gwflow_flux_ppag')
```
String literal: `gwflow_flux_ppag`

**Line 911** (open):
```fortran
open(out_gw_pumpdef,file='gwflow_flux_pumping_deficient')
```
String literal: `gwflow_flux_pumping_deficient`

**Line 924** (open):
```fortran
open(out_hru_pump_yr,file='gwflow_flux_pumping_hru_yr')
```
String literal: `gwflow_flux_pumping_hru_yr`

**Line 927** (open):
```fortran
open(out_hru_pump_mo,file='gwflow_flux_pumping_hru_mo')
```
String literal: `gwflow_flux_pumping_hru_mo`

**Line 930** (inquire):
```fortran
inquire(file='gwflow.hru_pump_observe',exist=i_exist)
```
String literal: `gwflow.hru_pump_observe`

**Line 932** (open):
```fortran
open(in_hru_pump_obs,file='gwflow.hru_pump_observe')
```
String literal: `gwflow.hru_pump_observe`

**Line 941** (open):
```fortran
open(out_hru_pump_obs,file='gwflow_flux_pumping_hru_obs')
```
String literal: `gwflow_flux_pumping_hru_obs`

**Line 949** (inquire):
```fortran
inquire(file='gwflow.pumpex',exist=i_exist)
```
String literal: `gwflow.pumpex`

**Line 952** (open):
```fortran
open(in_gw,file='gwflow.pumpex')
```
String literal: `gwflow.pumpex`

**Line 977** (open):
```fortran
open(out_gw_pumpex,file='gwflow_flux_ppex')
```
String literal: `gwflow_flux_ppex`

**Line 987** (inquire):
```fortran
inquire(file='gwflow.tiles',exist=i_exist)
```
String literal: `gwflow.tiles`

**Line 990** (open):
```fortran
open(in_gw,file='gwflow.tiles')
```
String literal: `gwflow.tiles`

**Line 1008** (open):
```fortran
open(out_tile_cells,file='gwflow_tile_cell_groups')
```
String literal: `gwflow_tile_cell_groups`

**Line 1052** (open):
```fortran
open(out_gw_tile,file='gwflow_flux_tile')
```
String literal: `gwflow_flux_tile`

**Line 1061** (inquire):
```fortran
inquire(file='gwflow.rescells',exist=i_exist)
```
String literal: `gwflow.rescells`

**Line 1064** (open):
```fortran
open(in_res_cell,file='gwflow.rescells')
```
String literal: `gwflow.rescells`

**Line 1110** (open):
```fortran
open(out_gw_res,file='gwflow_flux_resv')
```
String literal: `gwflow_flux_resv`

**Line 1124** (open):
```fortran
open(out_gw_wet,file='gwflow_flux_wetland')
```
String literal: `gwflow_flux_wetland`

**Line 1132** (inquire):
```fortran
inquire(file='gwflow.floodplain',exist=i_exist)
```
String literal: `gwflow.floodplain`

**Line 1135** (open):
```fortran
open(in_fp_cell,file='gwflow.floodplain')
```
String literal: `gwflow.floodplain`

**Line 1182** (open):
```fortran
open(out_gw_fp,file='gwflow_flux_floodplain')
```
String literal: `gwflow_flux_floodplain`

**Line 1192** (inquire):
```fortran
inquire(file='gwflow.canals',exist=i_exist)
```
String literal: `gwflow.canals`

**Line 1195** (open):
```fortran
open(in_canal_cell,file='gwflow.canals')
```
String literal: `gwflow.canals`

**Line 1341** (open):
```fortran
open(out_gw_canal,file='gwflow_flux_canl')
```
String literal: `gwflow_flux_canl`

**Line 1354** (inquire):
```fortran
inquire(file='gwflow.solutes',exist=i_exist)
```
String literal: `gwflow.solutes`

**Line 1358** (open):
```fortran
open(in_gw,file='gwflow.solutes')
```
String literal: `gwflow.solutes`

**Line 1366** (inquire):
```fortran
inquire(file="constituents.cs", exist=i_exist2)
```
String literal: `constituents.cs`

**Line 1444** (inquire):
```fortran
inquire(file='gwflow.solutes.minerals',exist=i_exist)
```
String literal: `gwflow.solutes.minerals`

**Line 1446** (open):
```fortran
open(in_gw_minl,file='gwflow.solutes.minerals')
```
String literal: `gwflow.solutes.minerals`

**Line 1597** (open):
```fortran
open(out_sol_rech,file='gwflow_mass_rech')
```
String literal: `gwflow_mass_rech`

**Line 1604** (open):
```fortran
open(out_sol_gwsw,file='gwflow_mass_gwsw')
```
String literal: `gwflow_mass_gwsw`

**Line 1608** (open):
```fortran
open(out_sol_soil,file='gwflow_mass_soil')
```
String literal: `gwflow_mass_soil`

**Line 1615** (open):
```fortran
open(out_sol_satx,file='gwflow_mass_satx')
```
String literal: `gwflow_mass_satx`

**Line 1619** (open):
```fortran
open(out_sol_ppag,file='gwflow_mass_ppag')
```
String literal: `gwflow_mass_ppag`

**Line 1623** (open):
```fortran
open(out_sol_ppex,file='gwflow_mass_ppex')
```
String literal: `gwflow_mass_ppex`

**Line 1628** (open):
```fortran
open(out_sol_tile,file='gwflow_mass_tile')
```
String literal: `gwflow_mass_tile`

**Line 1633** (open):
```fortran
open(out_sol_resv,file='gwflow_mass_resv')
```
String literal: `gwflow_mass_resv`

**Line 1638** (open):
```fortran
open(out_sol_wetl,file='gwflow_mass_wetl')
```
String literal: `gwflow_mass_wetl`

**Line 1643** (open):
```fortran
open(out_sol_fpln,file='gwflow_mass_fpln')
```
String literal: `gwflow_mass_fpln`

**Line 1648** (open):
```fortran
open(out_sol_canl,file='gwflow_mass_canl')
```
String literal: `gwflow_mass_canl`

**Line 1652** (open):
```fortran
open(out_gw_chem,file='gwflow_flux_reaction')
```
String literal: `gwflow_flux_reaction`

**Line 1655** (open):
```fortran
open(out_gwobs_sol,file='gwflow_state_obs_conc')
```
String literal: `gwflow_state_obs_conc`

**Line 1674** (open):
```fortran
open(in_lsu_cell,file='gwflow.lsucell')
```
String literal: `gwflow.lsucell`

**Line 1721** (inquire):
```fortran
inquire(file='gwflow.huc12cell',exist=i_exist)
```
String literal: `gwflow.huc12cell`

**Line 1724** (open):
```fortran
open(5100,file='out.key')
```
String literal: `out.key`

**Line 1755** (open):
```fortran
open(in_hru_cell,file='gwflow.hrucell')
```
String literal: `gwflow.hrucell`

**Line 1808** (open):
```fortran
open(in_huc_cell,file='gwflow.huc12cell')
```
String literal: `gwflow.huc12cell`

**Line 1869** (open):
```fortran
open(in_cell_hru,file='gwflow.cellhru')
```
String literal: `gwflow.cellhru`

**Line 1910** (open):
```fortran
open(out_gwbal,file='gwflow_balance_gw_day')
```
String literal: `gwflow_balance_gw_day`

**Line 1949** (open):
```fortran
open(out_gwbal_yr,file='gwflow_balance_gw_yr')
```
String literal: `gwflow_balance_gw_yr`

**Line 1982** (open):
```fortran
open(out_gwbal_aa,file='gwflow_balance_gw_aa')
```
String literal: `gwflow_balance_gw_aa`

**Line 2016** (open):
```fortran
open(out_huc12wb,file='gwflow_balance_huc12')
```
String literal: `gwflow_balance_huc12`

**Line 2044** (open):
```fortran
open(out_huc12wb_mo,file='gwflow_balance_huc12_mon')
```
String literal: `gwflow_balance_huc12_mon`

**Line 2321** (open):
```fortran
open(out_gwheads,file='gwflow_state_head')
```
String literal: `gwflow_state_head`

**Line 2340** (open):
```fortran
open(out_gwconc,file='gwflow_state_conc')
```
String literal: `gwflow_state_conc`

**Line 2365** (open):
```fortran
open(out_head_mo,file='gwflow_state_head_mo')
```
String literal: `gwflow_state_head_mo`

**Line 2366** (open):
```fortran
open(out_head_yr,file='gwflow_state_head_yr')
```
String literal: `gwflow_state_head_yr`

**Line 2375** (open):
```fortran
open(out_conc_mo,file='gwflow_state_conc_mo')
```
String literal: `gwflow_state_conc_mo`

**Line 2376** (open):
```fortran
open(out_conc_yr,file='gwflow_state_conc_yr')
```
String literal: `gwflow_state_conc_yr`

**Line 2385** (inquire):
```fortran
inquire(file='gwflow.streamobs',exist=i_exist)
```
String literal: `gwflow.streamobs`

**Line 2387** (open):
```fortran
open(in_str_obs,file='gwflow.streamobs')
```
String literal: `gwflow.streamobs`

**Line 2388** (open):
```fortran
open(out_strobs,file='gwflow_state_obs_flow')
```
String literal: `gwflow_state_obs_flow`

**Line 2420** (open):
```fortran
open(out_hyd_sep,file='gwflow_state_hydsep')
```
String literal: `gwflow_state_hydsep`

### header_aquifer.f90

**Line 11** (open):
```fortran
open (2520,file="aquifer_day.txt",recl = 1500)
```
String literal: `aquifer_day.txt`

**Line 17** (open):
```fortran
open (2524,file="aquifer_day.csv",recl = 1500)
```
String literal: `aquifer_day.csv`

**Line 28** (open):
```fortran
open (2521,file="aquifer_mon.txt",recl = 1500)
```
String literal: `aquifer_mon.txt`

**Line 34** (open):
```fortran
open (2525,file="aquifer_mon.csv",recl = 1500)
```
String literal: `aquifer_mon.csv`

**Line 45** (open):
```fortran
open (2522,file="aquifer_yr.txt",recl = 1500)
```
String literal: `aquifer_yr.txt`

**Line 51** (open):
```fortran
open (2526,file="aquifer_yr.csv",recl = 1500)
```
String literal: `aquifer_yr.csv`

**Line 62** (open):
```fortran
open (2523,file="aquifer_aa.txt",recl = 1500)
```
String literal: `aquifer_aa.txt`

**Line 68** (open):
```fortran
open (2527,file="aquifer_aa.csv",recl = 1500)
```
String literal: `aquifer_aa.csv`

### header_channel.f90

**Line 25** (open):
```fortran
open (2480,file="channel_day.txt",recl = 1500)
```
String literal: `channel_day.txt`

**Line 31** (open):
```fortran
open (2484,file="channel_day.csv",recl = 1500)
```
String literal: `channel_day.csv`

**Line 42** (open):
```fortran
open (2481,file="channel_mon.txt",recl = 1500)
```
String literal: `channel_mon.txt`

**Line 48** (open):
```fortran
open (2485,file="channel_mon.csv",recl = 1500)
```
String literal: `channel_mon.csv`

**Line 59** (open):
```fortran
open (2482,file="channel_yr.txt",recl = 1500)
```
String literal: `channel_yr.txt`

**Line 65** (open):
```fortran
open (2486,file="channel_yr.csv",recl = 1500)
```
String literal: `channel_yr.csv`

**Line 76** (open):
```fortran
open (2483,file="channel_aa.txt",recl = 1500)
```
String literal: `channel_aa.txt`

**Line 82** (open):
```fortran
open (2487,file="channel_aa.csv",recl = 1500)
```
String literal: `channel_aa.csv`

### header_const.f90

**Line 17** (open):
```fortran
open (6080,file="basin_cs_day.txt", recl = 2000)
```
String literal: `basin_cs_day.txt`

**Line 60** (open):
```fortran
open (6082,file="basin_cs_mon.txt", recl = 2000)
```
String literal: `basin_cs_mon.txt`

**Line 103** (open):
```fortran
open (6084,file="basin_cs_yr.txt", recl = 2000)
```
String literal: `basin_cs_yr.txt`

**Line 146** (open):
```fortran
open (6086,file="basin_cs_aa.txt", recl = 2000)
```
String literal: `basin_cs_aa.txt`

**Line 189** (open):
```fortran
open (6021,file="hru_cs_day.txt", recl = 3000)
```
String literal: `hru_cs_day.txt`

**Line 221** (open):
```fortran
open (6022,file="hru_cs_day.csv", recl = 3000)
```
String literal: `hru_cs_day.csv`

**Line 230** (open):
```fortran
open (6023,file="hru_cs_mon.txt", recl = 3000)
```
String literal: `hru_cs_mon.txt`

**Line 262** (open):
```fortran
open (6024,file="hru_cs_mon.csv", recl = 3000)
```
String literal: `hru_cs_mon.csv`

**Line 271** (open):
```fortran
open (6025,file="hru_cs_yr.txt", recl = 3000)
```
String literal: `hru_cs_yr.txt`

**Line 303** (open):
```fortran
open (6026,file="hru_cs_yr.csv", recl = 3000)
```
String literal: `hru_cs_yr.csv`

**Line 312** (open):
```fortran
open (6027,file="hru_cs_aa.txt", recl = 3000)
```
String literal: `hru_cs_aa.txt`

**Line 344** (open):
```fortran
open (6028,file="hru_cs_aa.csv", recl = 3000)
```
String literal: `hru_cs_aa.csv`

**Line 354** (open):
```fortran
open (6060,file="aquifer_cs_day.txt",recl=2000)
```
String literal: `aquifer_cs_day.txt`

**Line 375** (open):
```fortran
open (6061,file="aquifer_cs_day.csv",recl=2000)
```
String literal: `aquifer_cs_day.csv`

**Line 386** (open):
```fortran
open (6062,file="aquifer_cs_mon.txt",recl=2000)
```
String literal: `aquifer_cs_mon.txt`

**Line 407** (open):
```fortran
open (6063,file="aquifer_cs_mon.csv",recl=2000)
```
String literal: `aquifer_cs_mon.csv`

**Line 418** (open):
```fortran
open (6064,file="aquifer_cs_yr.txt",recl=2000)
```
String literal: `aquifer_cs_yr.txt`

**Line 439** (open):
```fortran
open (6065,file="aquifer_cs_yr.csv",recl=2000)
```
String literal: `aquifer_cs_yr.csv`

**Line 450** (open):
```fortran
open (6066,file="aquifer_cs_aa.txt",recl=2000)
```
String literal: `aquifer_cs_aa.txt`

**Line 471** (open):
```fortran
open (6067,file="aquifer_cs_aa.csv",recl=2000)
```
String literal: `aquifer_cs_aa.csv`

**Line 482** (open):
```fortran
open (6030,file="channel_cs_day.txt",recl=2000)
```
String literal: `channel_cs_day.txt`

**Line 501** (open):
```fortran
open (6031,file="channel_cs_day.csv",recl=2000)
```
String literal: `channel_cs_day.csv`

**Line 511** (open):
```fortran
open (6032,file="channel_cs_mon.txt",recl=2000)
```
String literal: `channel_cs_mon.txt`

**Line 530** (open):
```fortran
open (6033,file="channel_cs_mon.csv",recl=2000)
```
String literal: `channel_cs_mon.csv`

**Line 540** (open):
```fortran
open (6034,file="channel_cs_yr.txt",recl=2000)
```
String literal: `channel_cs_yr.txt`

**Line 559** (open):
```fortran
open (6035,file="channel_cs_yr.csv",recl=2000)
```
String literal: `channel_cs_yr.csv`

**Line 569** (open):
```fortran
open (6036,file="channel_cs_aa.txt",recl=2000)
```
String literal: `channel_cs_aa.txt`

**Line 588** (open):
```fortran
open (6037,file="channel_cs_aa.csv",recl=2000)
```
String literal: `channel_cs_aa.csv`

**Line 598** (open):
```fortran
open (6040,file="reservoir_cs_day.txt",recl=2000)
```
String literal: `reservoir_cs_day.txt`

**Line 621** (open):
```fortran
open (6041,file="reservoir_cs_day.csv",recl=2000)
```
String literal: `reservoir_cs_day.csv`

**Line 631** (open):
```fortran
open (6042,file="reservoir_cs_mon.txt",recl=2000)
```
String literal: `reservoir_cs_mon.txt`

**Line 654** (open):
```fortran
open (6043,file="reservoir_cs_mon.csv",recl=2000)
```
String literal: `reservoir_cs_mon.csv`

**Line 664** (open):
```fortran
open (6044,file="reservoir_cs_yr.txt",recl=2000)
```
String literal: `reservoir_cs_yr.txt`

**Line 687** (open):
```fortran
open (6045,file="reservoir_cs_yr.csv",recl=2000)
```
String literal: `reservoir_cs_yr.csv`

**Line 697** (open):
```fortran
open (6046,file="reservoir_cs_aa.txt",recl=2000)
```
String literal: `reservoir_cs_aa.txt`

**Line 720** (open):
```fortran
open (6047,file="reservoir_cs_aa.csv",recl=2000)
```
String literal: `reservoir_cs_aa.csv`

**Line 730** (open):
```fortran
open (6070,file="rout_unit_cs_day.txt",recl=2000)
```
String literal: `rout_unit_cs_day.txt`

**Line 757** (open):
```fortran
open (6071,file="rout_unit_cs_day.csv",recl=2000)
```
String literal: `rout_unit_cs_day.csv`

**Line 768** (open):
```fortran
open (6072,file="rout_unit_cs_mon.txt",recl=2000)
```
String literal: `rout_unit_cs_mon.txt`

**Line 795** (open):
```fortran
open (6073,file="rout_unit_cs_mon.csv",recl=2000)
```
String literal: `rout_unit_cs_mon.csv`

**Line 806** (open):
```fortran
open (6074,file="rout_unit_cs_yr.txt",recl=2000)
```
String literal: `rout_unit_cs_yr.txt`

**Line 833** (open):
```fortran
open (6075,file="rout_unit_cs_yr.csv",recl=2000)
```
String literal: `rout_unit_cs_yr.csv`

**Line 844** (open):
```fortran
open (6076,file="rout_unit_cs_aa.txt",recl=2000)
```
String literal: `rout_unit_cs_aa.txt`

**Line 871** (open):
```fortran
open (6077,file="rout_unit_cs_aa.csv",recl=2000)
```
String literal: `rout_unit_cs_aa.csv`

**Line 882** (open):
```fortran
open (6090,file="wetland_cs_day.txt",recl=2000)
```
String literal: `wetland_cs_day.txt`

**Line 904** (open):
```fortran
open (6091,file="wetland_cs_day.csv",recl=2000)
```
String literal: `wetland_cs_day.csv`

**Line 914** (open):
```fortran
open (6092,file="wetland_cs_mon.txt",recl=2000)
```
String literal: `wetland_cs_mon.txt`

**Line 936** (open):
```fortran
open (6093,file="wetland_cs_mon.csv",recl=2000)
```
String literal: `wetland_cs_mon.csv`

**Line 946** (open):
```fortran
open (6094,file="wetland_cs_yr.txt",recl=2000)
```
String literal: `wetland_cs_yr.txt`

**Line 968** (open):
```fortran
open (6095,file="wetland_cs_yr.csv",recl=2000)
```
String literal: `wetland_cs_yr.csv`

**Line 978** (open):
```fortran
open (6096,file="wetland_cs_aa.txt",recl=2000)
```
String literal: `wetland_cs_aa.txt`

**Line 1000** (open):
```fortran
open (6097,file="wetland_cs_aa.csv",recl=2000)
```
String literal: `wetland_cs_aa.csv`

### header_cs.f90

**Line 16** (open):
```fortran
open (2708,file="hydin_pests_day.txt",recl=800)
```
String literal: `hydin_pests_day.txt`

**Line 21** (open):
```fortran
open (2724,file="hydin_pests_day.csv",recl=800)
```
String literal: `hydin_pests_day.csv`

**Line 29** (open):
```fortran
open (2712,file="hydin_paths_day.txt",recl=800)
```
String literal: `hydin_paths_day.txt`

**Line 34** (open):
```fortran
open (2728,file="hydin_paths_day.csv",recl=800)
```
String literal: `hydin_paths_day.csv`

**Line 42** (open):
```fortran
open (2716,file="hydin_metals_day.txt",recl=800)
```
String literal: `hydin_metals_day.txt`

**Line 47** (open):
```fortran
open (2732,file="hydin_metals_day.csv",recl=800)
```
String literal: `hydin_metals_day.csv`

**Line 55** (open):
```fortran
open (2720,file="hydin_salts_day.txt",recl=800)
```
String literal: `hydin_salts_day.txt`

**Line 60** (open):
```fortran
open (2736,file="hydin_salts_day.csv",recl=800)
```
String literal: `hydin_salts_day.csv`

**Line 71** (open):
```fortran
open (2709,file="hydin_pests_mon.txt",recl=800)
```
String literal: `hydin_pests_mon.txt`

**Line 76** (open):
```fortran
open (2725,file="hydin_pests_mon.csv",recl=800)
```
String literal: `hydin_pests_mon.csv`

**Line 85** (open):
```fortran
open (2713,file="hydin_paths_mon.txt",recl=800)
```
String literal: `hydin_paths_mon.txt`

**Line 90** (open):
```fortran
open (2729,file="hydin_paths_mon.csv",recl=800)
```
String literal: `hydin_paths_mon.csv`

**Line 98** (open):
```fortran
open (2717,file="hydin_metals_mon.txt",recl=800)
```
String literal: `hydin_metals_mon.txt`

**Line 103** (open):
```fortran
open (2733,file="hydin_metals_mon.csv",recl=800)
```
String literal: `hydin_metals_mon.csv`

**Line 111** (open):
```fortran
open (2721,file="hydin_salts_mon.txt",recl=800)
```
String literal: `hydin_salts_mon.txt`

**Line 116** (open):
```fortran
open (2737,file="hydin_salts_mon.csv",recl=800)
```
String literal: `hydin_salts_mon.csv`

**Line 128** (open):
```fortran
open (2710,file="hydin_pests_yr.txt",recl=800)
```
String literal: `hydin_pests_yr.txt`

**Line 133** (open):
```fortran
open (2726,file="hydin_pests_yr.csv",recl=800)
```
String literal: `hydin_pests_yr.csv`

**Line 141** (open):
```fortran
open (2714,file="hydin_paths_yr.txt",recl=800)
```
String literal: `hydin_paths_yr.txt`

**Line 146** (open):
```fortran
open (2730,file="hydin_paths_yr.csv",recl=800)
```
String literal: `hydin_paths_yr.csv`

**Line 154** (open):
```fortran
open (2718,file="hydin_metals_yr.txt",recl=800)
```
String literal: `hydin_metals_yr.txt`

**Line 159** (open):
```fortran
open (2734,file="hydin_metals_yr.csv",recl=800)
```
String literal: `hydin_metals_yr.csv`

**Line 167** (open):
```fortran
open (2722,file="hydin_salts_yr.txt",recl=800)
```
String literal: `hydin_salts_yr.txt`

**Line 172** (open):
```fortran
open (2738,file="hydin_salts_yr.csv",recl=800)
```
String literal: `hydin_salts_yr.csv`

**Line 183** (open):
```fortran
open (2711,file="hydin_pests_aa.txt",recl=800)
```
String literal: `hydin_pests_aa.txt`

**Line 188** (open):
```fortran
open (2727,file="hydin_pests_aa.csv",recl=800)
```
String literal: `hydin_pests_aa.csv`

**Line 196** (open):
```fortran
open (2715,file="hydin_paths_aa.txt",recl=800)
```
String literal: `hydin_paths_aa.txt`

**Line 201** (open):
```fortran
open (2731,file="hydin_paths_aa.csv",recl=800)
```
String literal: `hydin_paths_aa.csv`

**Line 209** (open):
```fortran
open (2719,file="hydin_metals_aa.txt",recl=800)
```
String literal: `hydin_metals_aa.txt`

**Line 214** (open):
```fortran
open (2735,file="hydin_metals_aa.csv",recl=800)
```
String literal: `hydin_metals_aa.csv`

**Line 222** (open):
```fortran
open (2723,file="hydin_salts_aa.txt",recl=800)
```
String literal: `hydin_salts_aa.txt`

**Line 227** (open):
```fortran
open (2739,file="hydin_salts_aa.csv",recl=800)
```
String literal: `hydin_salts_aa.csv`

**Line 238** (open):
```fortran
open (2740,file="hydout_pests_day.txt",recl=800)
```
String literal: `hydout_pests_day.txt`

**Line 243** (open):
```fortran
open (2756,file="hydout_pests_day.csv")
```
String literal: `hydout_pests_day.csv`

**Line 251** (open):
```fortran
open (2744,file="hydout_paths_day.txt",recl=800)
```
String literal: `hydout_paths_day.txt`

**Line 256** (open):
```fortran
open (2760,file="hydout_paths_day.csv")
```
String literal: `hydout_paths_day.csv`

**Line 264** (open):
```fortran
open (2748,file="hydout_metals_day.txt",recl=800)
```
String literal: `hydout_metals_day.txt`

**Line 269** (open):
```fortran
open (2764,file="hydout_metals_day.csv")
```
String literal: `hydout_metals_day.csv`

**Line 277** (open):
```fortran
open (2752,file="hydout_salts_day.txt",recl=800)
```
String literal: `hydout_salts_day.txt`

**Line 282** (open):
```fortran
open (2768,file="hydout_salts_day.csv")
```
String literal: `hydout_salts_day.csv`

**Line 293** (open):
```fortran
open (2741,file="hydout_pests_mon.txt",recl=800)
```
String literal: `hydout_pests_mon.txt`

**Line 298** (open):
```fortran
open (2757,file="hydout_pests_mon.csv",recl=800)
```
String literal: `hydout_pests_mon.csv`

**Line 306** (open):
```fortran
open (2745,file="hydout_paths_mon.txt",recl=800)
```
String literal: `hydout_paths_mon.txt`

**Line 311** (open):
```fortran
open (2761,file="hydout_paths_mon.csv")
```
String literal: `hydout_paths_mon.csv`

**Line 319** (open):
```fortran
open (2749,file="hydout_metals_mon.txt",recl=800)
```
String literal: `hydout_metals_mon.txt`

**Line 324** (open):
```fortran
open (2765,file="hydout_metals_mon.csv")
```
String literal: `hydout_metals_mon.csv`

**Line 332** (open):
```fortran
open (2753,file="hydout_salts_mon.txt",recl=800)
```
String literal: `hydout_salts_mon.txt`

**Line 337** (open):
```fortran
open (2769,file="hydout_salts_mon.csv",recl=800)
```
String literal: `hydout_salts_mon.csv`

**Line 349** (open):
```fortran
open (2742,file="hydout_pests_yr.txt",recl=800)
```
String literal: `hydout_pests_yr.txt`

**Line 354** (open):
```fortran
open (2758,file="hydout_pests_yr.csv",recl=800)
```
String literal: `hydout_pests_yr.csv`

**Line 362** (open):
```fortran
open (2746,file="hydout_paths_yr.txt",recl=800)
```
String literal: `hydout_paths_yr.txt`

**Line 367** (open):
```fortran
open (2762,file="hydout_paths_yr.csv",recl=800)
```
String literal: `hydout_paths_yr.csv`

**Line 375** (open):
```fortran
open (2750,file="hydout_metals_yr.txt",recl=800)
```
String literal: `hydout_metals_yr.txt`

**Line 380** (open):
```fortran
open (2766,file="hydout_metals_yr.csv",recl=800)
```
String literal: `hydout_metals_yr.csv`

**Line 388** (open):
```fortran
open (2754,file="hydout_salts_yr.txt",recl=800)
```
String literal: `hydout_salts_yr.txt`

**Line 393** (open):
```fortran
open (2770,file="hydout_salts_yr.csv",recl=800)
```
String literal: `hydout_salts_yr.csv`

**Line 404** (open):
```fortran
open (2743,file="hydout_pests_aa.txt",recl=800)
```
String literal: `hydout_pests_aa.txt`

**Line 409** (open):
```fortran
open (2759,file="hydout_pests_aa.csv",recl=800)
```
String literal: `hydout_pests_aa.csv`

**Line 417** (open):
```fortran
open (2747,file="hydout_paths_aa.txt",recl=800)
```
String literal: `hydout_paths_aa.txt`

**Line 422** (open):
```fortran
open (2763,file="hydout_paths_aa.csv",recl=800)
```
String literal: `hydout_paths_aa.csv`

**Line 430** (open):
```fortran
open (2751,file="hydout_metals_aa.txt",recl=800)
```
String literal: `hydout_metals_aa.txt`

**Line 435** (open):
```fortran
open (2767,file="hydout_metals_aa.csv",recl=800)
```
String literal: `hydout_metals_aa.csv`

**Line 443** (open):
```fortran
open (2755,file="hydout_salts_aa.txt",recl=800)
```
String literal: `hydout_salts_aa.txt`

**Line 448** (open):
```fortran
open (2771,file="hydout_salts_aa.csv",recl=800)
```
String literal: `hydout_salts_aa.csv`

### header_hyd.f90

**Line 9** (open):
```fortran
open (7000,file="hydcon.out")
```
String literal: `hydcon.out`

**Line 12** (open):
```fortran
open (7001,file="hydcon.csv")
```
String literal: `hydcon.csv`

**Line 19** (open):
```fortran
open (2580,file="hydout_day.txt",recl=800)
```
String literal: `hydout_day.txt`

**Line 25** (open):
```fortran
open (2584,file="hydout_day.csv",recl=800)
```
String literal: `hydout_day.csv`

**Line 34** (open):
```fortran
open (2581,file="hydout_mon.txt",recl=800)
```
String literal: `hydout_mon.txt`

**Line 40** (open):
```fortran
open (2585,file="hydout_mon.csv",recl=800)
```
String literal: `hydout_mon.csv`

**Line 49** (open):
```fortran
open (2582,file="hydout_yr.txt",recl=800)
```
String literal: `hydout_yr.txt`

**Line 55** (open):
```fortran
open (2586,file="hydout_yr.csv",recl=800)
```
String literal: `hydout_yr.csv`

**Line 64** (open):
```fortran
open (2583,file="hydout_aa.txt",recl=800)
```
String literal: `hydout_aa.txt`

**Line 70** (open):
```fortran
open (2587,file="hydout_aa.csv",recl=800)
```
String literal: `hydout_aa.csv`

**Line 81** (open):
```fortran
open (2560,file="hydin_day.txt",recl=800)
```
String literal: `hydin_day.txt`

**Line 87** (open):
```fortran
open (2564,file="hydin_day.csv",recl=800)
```
String literal: `hydin_day.csv`

**Line 96** (open):
```fortran
open (2561,file="hydin_mon.txt",recl=800)
```
String literal: `hydin_mon.txt`

**Line 102** (open):
```fortran
open (2565,file="hydin_mon.csv",recl=800)
```
String literal: `hydin_mon.csv`

**Line 111** (open):
```fortran
open (2562,file="hydin_yr.txt",recl=800)
```
String literal: `hydin_yr.txt`

**Line 117** (open):
```fortran
open (2566,file="hydin_yr.csv",recl=800)
```
String literal: `hydin_yr.csv`

**Line 126** (open):
```fortran
open (2563,file="hydin_aa.txt",recl=800)
```
String literal: `hydin_aa.txt`

**Line 132** (open):
```fortran
open (2567,file="hydin_aa.csv",recl=800)
```
String literal: `hydin_aa.csv`

**Line 143** (open):
```fortran
open (2700,file="deposition_day.txt",recl=800)
```
String literal: `deposition_day.txt`

**Line 149** (open):
```fortran
open (2704,file="deposition_day.csv",recl=800)
```
String literal: `deposition_day.csv`

**Line 159** (open):
```fortran
open (2701,file="deposition_mon.txt",recl=800)
```
String literal: `deposition_mon.txt`

**Line 165** (open):
```fortran
open (2705,file="deposition_mon.csv",recl=800)
```
String literal: `deposition_mon.csv`

**Line 175** (open):
```fortran
open (2702,file="deposition_yr.txt",recl=800)
```
String literal: `deposition_yr.txt`

**Line 181** (open):
```fortran
open (2706,file="deposition_yr.csv",recl=800)
```
String literal: `deposition_yr.csv`

**Line 191** (open):
```fortran
open (2703,file="deposition_aa.txt",recl=800)
```
String literal: `deposition_aa.txt`

**Line 197** (open):
```fortran
open (2707,file="deposition_aa.csv",recl=800)
```
String literal: `deposition_aa.csv`

### header_lu_change.f90

**Line 7** (open):
```fortran
open (3612,file="lu_change_out.txt",recl=800)
```
String literal: `lu_change_out.txt`

### header_mgt.f90

**Line 8** (open):
```fortran
open (2612,file="mgt_out.txt",recl=800)
```
String literal: `mgt_out.txt`

### header_path.f90

**Line 11** (open):
```fortran
open (2790,file="hru_path_day.txt",recl=800)
```
String literal: `hru_path_day.txt`

**Line 17** (open):
```fortran
open (2794,file="hru_path_day.csv",recl=800)
```
String literal: `hru_path_day.csv`

**Line 26** (open):
```fortran
open (2791,file="hru_path_mon.txt",recl=800)
```
String literal: `hru_path_mon.txt`

**Line 32** (open):
```fortran
open (2795,file="hru_path_mon.csv",recl=800)
```
String literal: `hru_path_mon.csv`

**Line 41** (open):
```fortran
open (2792,file="hru_path_yr.txt",recl=800)
```
String literal: `hru_path_yr.txt`

**Line 47** (open):
```fortran
open (2796,file="hru_path_yr.csv",recl=800)
```
String literal: `hru_path_yr.csv`

**Line 56** (open):
```fortran
open (2793,file="hru_path_aa.txt",recl=800)
```
String literal: `hru_path_aa.txt`

**Line 62** (open):
```fortran
open (2797,file="hru_path_aa.csv",recl=800)
```
String literal: `hru_path_aa.csv`

### header_pest.f90

**Line 17** (open):
```fortran
open (2800,file="hru_pest_day.txt",recl=800)
```
String literal: `hru_pest_day.txt`

**Line 23** (open):
```fortran
open (2804,file="hru_pest_day.csv",recl=800)
```
String literal: `hru_pest_day.csv`

**Line 32** (open):
```fortran
open (2801,file="hru_pest_mon.txt",recl=800)
```
String literal: `hru_pest_mon.txt`

**Line 38** (open):
```fortran
open (2805,file="hru_pest_mon.csv",recl=800)
```
String literal: `hru_pest_mon.csv`

**Line 47** (open):
```fortran
open (2802,file="hru_pest_yr.txt",recl=800)
```
String literal: `hru_pest_yr.txt`

**Line 53** (open):
```fortran
open (2806,file="hru_pest_yr.csv",recl=800)
```
String literal: `hru_pest_yr.csv`

**Line 62** (open):
```fortran
open (2803,file="hru_pest_aa.txt",recl=800)
```
String literal: `hru_pest_aa.txt`

**Line 68** (open):
```fortran
open (2807,file="hru_pest_aa.csv",recl=800)
```
String literal: `hru_pest_aa.csv`

**Line 81** (open):
```fortran
open (2808,file="channel_pest_day.txt",recl=800)
```
String literal: `channel_pest_day.txt`

**Line 87** (open):
```fortran
open (2812,file="channel_pest_day.csv",recl=800)
```
String literal: `channel_pest_day.csv`

**Line 96** (open):
```fortran
open (2809,file="channel_pest_mon.txt",recl=800)
```
String literal: `channel_pest_mon.txt`

**Line 102** (open):
```fortran
open (2813,file="channel_pest_mon.csv",recl=800)
```
String literal: `channel_pest_mon.csv`

**Line 111** (open):
```fortran
open (2810,file="channel_pest_yr.txt",recl=800)
```
String literal: `channel_pest_yr.txt`

**Line 117** (open):
```fortran
open (2814,file="channel_pest_yr.csv",recl=800)
```
String literal: `channel_pest_yr.csv`

**Line 126** (open):
```fortran
open (2811,file="channel_pest_aa.txt",recl=800)
```
String literal: `channel_pest_aa.txt`

**Line 132** (open):
```fortran
open (2815,file="channel_pest_aa.csv",recl=800)
```
String literal: `channel_pest_aa.csv`

**Line 145** (open):
```fortran
open (2816,file="reservoir_pest_day.txt",recl=800)
```
String literal: `reservoir_pest_day.txt`

**Line 151** (open):
```fortran
open (2820,file="reservoir_pest_day.csv",recl=800)
```
String literal: `reservoir_pest_day.csv`

**Line 160** (open):
```fortran
open (2817,file="reservoir_pest_mon.txt",recl=800)
```
String literal: `reservoir_pest_mon.txt`

**Line 166** (open):
```fortran
open (2821,file="reservoir_pest_mon.csv",recl=800)
```
String literal: `reservoir_pest_mon.csv`

**Line 175** (open):
```fortran
open (2818,file="reservoir_pest_yr.txt",recl=800)
```
String literal: `reservoir_pest_yr.txt`

**Line 181** (open):
```fortran
open (2822,file="reservoir_pest_yr.csv",recl=800)
```
String literal: `reservoir_pest_yr.csv`

**Line 190** (open):
```fortran
open (2819,file="reservoir_pest_aa.txt",recl=800)
```
String literal: `reservoir_pest_aa.txt`

**Line 196** (open):
```fortran
open (2823,file="reservoir_pest_aa.csv",recl=800)
```
String literal: `reservoir_pest_aa.csv`

**Line 209** (open):
```fortran
open (3000,file="basin_aqu_pest_day.txt",recl=800)
```
String literal: `basin_aqu_pest_day.txt`

**Line 215** (open):
```fortran
open (3004,file="basin_aqu_pest_day.csv",recl=800)
```
String literal: `basin_aqu_pest_day.csv`

**Line 224** (open):
```fortran
open (3001,file="basin_aqu_pest_mon.txt",recl=800)
```
String literal: `basin_aqu_pest_mon.txt`

**Line 230** (open):
```fortran
open (3005,file="basin_aqu_pest_mon.csv",recl=800)
```
String literal: `basin_aqu_pest_mon.csv`

**Line 239** (open):
```fortran
open (3002,file="basin_aqu_pest_yr.txt",recl=800)
```
String literal: `basin_aqu_pest_yr.txt`

**Line 245** (open):
```fortran
open (3006,file="basin_aqu_pest_yr.csv",recl=800)
```
String literal: `basin_aqu_pest_yr.csv`

**Line 254** (open):
```fortran
open (3003,file="basin_aqu_pest_aa.txt",recl=800)
```
String literal: `basin_aqu_pest_aa.txt`

**Line 260** (open):
```fortran
open (3007,file="basin_aqu_pest_aa.csv",recl=800)
```
String literal: `basin_aqu_pest_aa.csv`

**Line 273** (open):
```fortran
open (3008,file="aquifer_pest_day.txt",recl=800)
```
String literal: `aquifer_pest_day.txt`

**Line 279** (open):
```fortran
open (3012,file="aquifer_pest_day.csv",recl=800)
```
String literal: `aquifer_pest_day.csv`

**Line 288** (open):
```fortran
open (3009,file="aquifer_pest_mon.txt",recl=800)
```
String literal: `aquifer_pest_mon.txt`

**Line 294** (open):
```fortran
open (3013,file="aquifer_pest_mon.csv",recl=800)
```
String literal: `aquifer_pest_mon.csv`

**Line 303** (open):
```fortran
open (3010,file="aquifer_pest_yr.txt",recl=800)
```
String literal: `aquifer_pest_yr.txt`

**Line 309** (open):
```fortran
open (3014,file="aquifer_pest_yr.csv",recl=800)
```
String literal: `aquifer_pest_yr.csv`

**Line 318** (open):
```fortran
open (3011,file="aquifer_pest_aa.txt",recl=800)
```
String literal: `aquifer_pest_aa.txt`

**Line 324** (open):
```fortran
open (3015,file="aquifer_pest_aa.csv",recl=800)
```
String literal: `aquifer_pest_aa.csv`

**Line 337** (open):
```fortran
open (2832,file="basin_ch_pest_day.txt",recl=800)
```
String literal: `basin_ch_pest_day.txt`

**Line 343** (open):
```fortran
open (2836,file="basin_ch_pest_day.csv",recl=800)
```
String literal: `basin_ch_pest_day.csv`

**Line 352** (open):
```fortran
open (2833,file="basin_ch_pest_mon.txt",recl=800)
```
String literal: `basin_ch_pest_mon.txt`

**Line 358** (open):
```fortran
open (2837,file="basin_ch_pest_mon.csv",recl=800)
```
String literal: `basin_ch_pest_mon.csv`

**Line 367** (open):
```fortran
open (2834,file="basin_ch_pest_yr.txt",recl=800)
```
String literal: `basin_ch_pest_yr.txt`

**Line 373** (open):
```fortran
open (2838,file="basin_ch_pest_yr.csv",recl=800)
```
String literal: `basin_ch_pest_yr.csv`

**Line 382** (open):
```fortran
open (2835,file="basin_ch_pest_aa.txt",recl=800)
```
String literal: `basin_ch_pest_aa.txt`

**Line 388** (open):
```fortran
open (2839,file="basin_ch_pest_aa.csv",recl=800)
```
String literal: `basin_ch_pest_aa.csv`

**Line 401** (open):
```fortran
open (2848,file="basin_res_pest_day.txt",recl=800)
```
String literal: `basin_res_pest_day.txt`

**Line 407** (open):
```fortran
open (2852,file="basin_res_pest_day.csv",recl=800)
```
String literal: `basin_res_pest_day.csv`

**Line 416** (open):
```fortran
open (2849,file="basin_res_pest_mon.txt",recl=800)
```
String literal: `basin_res_pest_mon.txt`

**Line 422** (open):
```fortran
open (2853,file="basin_res_pest_mon.csv",recl=800)
```
String literal: `basin_res_pest_mon.csv`

**Line 431** (open):
```fortran
open (2850,file="basin_res_pest_yr.txt",recl=800)
```
String literal: `basin_res_pest_yr.txt`

**Line 437** (open):
```fortran
open (2854,file="basin_res_pest_yr.csv",recl=800)
```
String literal: `basin_res_pest_yr.csv`

**Line 446** (open):
```fortran
open (2851,file="basin_res_pest_aa.txt",recl=800)
```
String literal: `basin_res_pest_aa.txt`

**Line 452** (open):
```fortran
open (2855,file="basin_res_pest_aa.csv",recl=800)
```
String literal: `basin_res_pest_aa.csv`

**Line 465** (open):
```fortran
open (2864,file="basin_ls_pest_day.txt",recl=800)
```
String literal: `basin_ls_pest_day.txt`

**Line 471** (open):
```fortran
open (2868,file="basin_ls_pest_day.csv",recl=800)
```
String literal: `basin_ls_pest_day.csv`

**Line 480** (open):
```fortran
open (2865,file="basin_ls_pest_mon.txt",recl=800)
```
String literal: `basin_ls_pest_mon.txt`

**Line 486** (open):
```fortran
open (2869,file="basin_ls_pest_mon.csv",recl=800)
```
String literal: `basin_ls_pest_mon.csv`

**Line 495** (open):
```fortran
open (2866,file="basin_ls_pest_yr.txt",recl=800)
```
String literal: `basin_ls_pest_yr.txt`

**Line 501** (open):
```fortran
open (2870,file="basin_ls_pest_yr.csv",recl=800)
```
String literal: `basin_ls_pest_yr.csv`

**Line 510** (open):
```fortran
open (2867,file="basin_ls_pest_aa.txt",recl=800)
```
String literal: `basin_ls_pest_aa.txt`

**Line 516** (open):
```fortran
open (2871,file="basin_ls_pest_aa.csv",recl=800)
```
String literal: `basin_ls_pest_aa.csv`

### header_reservoir.f90

**Line 10** (open):
```fortran
open (7777,file="reservoir_sed.txt",recl=1500)
```
String literal: `reservoir_sed.txt`

**Line 14** (open):
```fortran
open (2540,file="reservoir_day.txt",recl=1500)
```
String literal: `reservoir_day.txt`

**Line 20** (open):
```fortran
open (2544,file="reservoir_day.csv",recl=1500)
```
String literal: `reservoir_day.csv`

**Line 29** (open):
```fortran
open (2541,file="reservoir_mon.txt",recl=1500)
```
String literal: `reservoir_mon.txt`

**Line 35** (open):
```fortran
open (2545,file="reservoir_mon.csv",recl=1500)
```
String literal: `reservoir_mon.csv`

**Line 44** (open):
```fortran
open (2542,file="reservoir_yr.txt",recl=1500)
```
String literal: `reservoir_yr.txt`

**Line 50** (open):
```fortran
open (2546,file="reservoir_yr.csv",recl=1500)
```
String literal: `reservoir_yr.csv`

**Line 59** (open):
```fortran
open (2543,file="reservoir_aa.txt",recl = 1500)
```
String literal: `reservoir_aa.txt`

**Line 65** (open):
```fortran
open (2547,file="reservoir_aa.csv",recl=1500)
```
String literal: `reservoir_aa.csv`

### header_salt.f90

**Line 17** (open):
```fortran
open (5080,file="basin_salt_day.txt", recl = 2000)
```
String literal: `basin_salt_day.txt`

**Line 59** (open):
```fortran
open (5082,file="basin_salt_mon.txt", recl = 2000)
```
String literal: `basin_salt_mon.txt`

**Line 101** (open):
```fortran
open (5084,file="basin_salt_yr.txt", recl = 2000)
```
String literal: `basin_salt_yr.txt`

**Line 143** (open):
```fortran
open (5086,file="basin_salt_aa.txt", recl = 2000)
```
String literal: `basin_salt_aa.txt`

**Line 185** (open):
```fortran
open (5021,file="hru_salt_day.txt", recl = 3000)
```
String literal: `hru_salt_day.txt`

**Line 216** (open):
```fortran
open (5022,file="hru_salt_day.csv", recl = 3000)
```
String literal: `hru_salt_day.csv`

**Line 225** (open):
```fortran
open (5023,file="hru_salt_mon.txt", recl = 3000)
```
String literal: `hru_salt_mon.txt`

**Line 256** (open):
```fortran
open (5024,file="hru_salt_mon.csv", recl = 3000)
```
String literal: `hru_salt_mon.csv`

**Line 265** (open):
```fortran
open (5025,file="hru_salt_yr.txt", recl = 3000)
```
String literal: `hru_salt_yr.txt`

**Line 296** (open):
```fortran
open (5026,file="hru_salt_yr.csv", recl = 3000)
```
String literal: `hru_salt_yr.csv`

**Line 305** (open):
```fortran
open (5027,file="hru_salt_aa.txt", recl = 3000)
```
String literal: `hru_salt_aa.txt`

**Line 336** (open):
```fortran
open (5028,file="hru_salt_aa.csv", recl = 3000)
```
String literal: `hru_salt_aa.csv`

**Line 346** (open):
```fortran
open (5060,file="aquifer_salt_day.txt",recl=2000)
```
String literal: `aquifer_salt_day.txt`

**Line 365** (open):
```fortran
open (5061,file="aquifer_salt_day.csv",recl=2000)
```
String literal: `aquifer_salt_day.csv`

**Line 376** (open):
```fortran
open (5062,file="aquifer_salt_mon.txt",recl=2000)
```
String literal: `aquifer_salt_mon.txt`

**Line 395** (open):
```fortran
open (5063,file="aquifer_salt_mon.csv",recl=2000)
```
String literal: `aquifer_salt_mon.csv`

**Line 406** (open):
```fortran
open (5064,file="aquifer_salt_yr.txt",recl=2000)
```
String literal: `aquifer_salt_yr.txt`

**Line 425** (open):
```fortran
open (5065,file="aquifer_salt_yr.csv",recl=2000)
```
String literal: `aquifer_salt_yr.csv`

**Line 436** (open):
```fortran
open (5066,file="aquifer_salt_aa.txt",recl=2000)
```
String literal: `aquifer_salt_aa.txt`

**Line 455** (open):
```fortran
open (5067,file="aquifer_salt_aa.csv",recl=2000)
```
String literal: `aquifer_salt_aa.csv`

**Line 466** (open):
```fortran
open (5030,file="channel_salt_day.txt",recl=4000)
```
String literal: `channel_salt_day.txt`

**Line 485** (open):
```fortran
open (5031,file="channel_salt_day.csv",recl=2000)
```
String literal: `channel_salt_day.csv`

**Line 495** (open):
```fortran
open (5032,file="channel_salt_mon.txt",recl=4000)
```
String literal: `channel_salt_mon.txt`

**Line 514** (open):
```fortran
open (5033,file="channel_salt_mon.csv",recl=2000)
```
String literal: `channel_salt_mon.csv`

**Line 524** (open):
```fortran
open (5034,file="channel_salt_yr.txt",recl=4000)
```
String literal: `channel_salt_yr.txt`

**Line 543** (open):
```fortran
open (5035,file="channel_salt_yr.csv",recl=2000)
```
String literal: `channel_salt_yr.csv`

**Line 553** (open):
```fortran
open (5036,file="channel_salt_aa.txt",recl=4000)
```
String literal: `channel_salt_aa.txt`

**Line 572** (open):
```fortran
open (5037,file="channel_salt_aa.csv",recl=2000)
```
String literal: `channel_salt_aa.csv`

**Line 582** (open):
```fortran
open (5040,file="reservoir_salt_day.txt",recl=2000)
```
String literal: `reservoir_salt_day.txt`

**Line 602** (open):
```fortran
open (5041,file="reservoir_salt_day.csv",recl=2000)
```
String literal: `reservoir_salt_day.csv`

**Line 612** (open):
```fortran
open (5042,file="reservoir_salt_mon.txt",recl=2000)
```
String literal: `reservoir_salt_mon.txt`

**Line 632** (open):
```fortran
open (5043,file="reservoir_salt_mon.csv",recl=2000)
```
String literal: `reservoir_salt_mon.csv`

**Line 642** (open):
```fortran
open (5044,file="reservoir_salt_yr.txt",recl=2000)
```
String literal: `reservoir_salt_yr.txt`

**Line 662** (open):
```fortran
open (5045,file="reservoir_salt_yr.csv",recl=2000)
```
String literal: `reservoir_salt_yr.csv`

**Line 672** (open):
```fortran
open (5046,file="reservoir_salt_aa.txt",recl=2000)
```
String literal: `reservoir_salt_aa.txt`

**Line 692** (open):
```fortran
open (5047,file="reservoir_salt_aa.csv",recl=2000)
```
String literal: `reservoir_salt_aa.csv`

**Line 702** (open):
```fortran
open (5070,file="rout_unit_salt_day.txt",recl=2000)
```
String literal: `rout_unit_salt_day.txt`

**Line 729** (open):
```fortran
open (5071,file="rout_unit_salt_day.csv",recl=2000)
```
String literal: `rout_unit_salt_day.csv`

**Line 740** (open):
```fortran
open (5072,file="rout_unit_salt_mon.txt",recl=2000)
```
String literal: `rout_unit_salt_mon.txt`

**Line 767** (open):
```fortran
open (5073,file="rout_unit_salt_mon.csv",recl=2000)
```
String literal: `rout_unit_salt_mon.csv`

**Line 778** (open):
```fortran
open (5074,file="rout_unit_salt_yr.txt",recl=2000)
```
String literal: `rout_unit_salt_yr.txt`

**Line 805** (open):
```fortran
open (5075,file="rout_unit_salt_yr.csv",recl=2000)
```
String literal: `rout_unit_salt_yr.csv`

**Line 816** (open):
```fortran
open (5076,file="rout_unit_salt_aa.txt",recl=2000)
```
String literal: `rout_unit_salt_aa.txt`

**Line 843** (open):
```fortran
open (5077,file="rout_unit_salt_aa.csv",recl=2000)
```
String literal: `rout_unit_salt_aa.csv`

**Line 854** (open):
```fortran
open (5090,file="wetland_salt_day.txt",recl=2000)
```
String literal: `wetland_salt_day.txt`

**Line 874** (open):
```fortran
open (5091,file="wetland_salt_day.csv",recl=2000)
```
String literal: `wetland_salt_day.csv`

**Line 884** (open):
```fortran
open (5092,file="wetland_salt_mon.txt",recl=2000)
```
String literal: `wetland_salt_mon.txt`

**Line 904** (open):
```fortran
open (5093,file="wetland_salt_mon.csv",recl=2000)
```
String literal: `wetland_salt_mon.csv`

**Line 914** (open):
```fortran
open (5094,file="wetland_salt_yr.txt",recl=2000)
```
String literal: `wetland_salt_yr.txt`

**Line 934** (open):
```fortran
open (5095,file="wetland_salt_yr.csv",recl=2000)
```
String literal: `wetland_salt_yr.csv`

**Line 944** (open):
```fortran
open (5096,file="wetland_salt_aa.txt",recl=2000)
```
String literal: `wetland_salt_aa.txt`

**Line 964** (open):
```fortran
open (5097,file="wetland_salt_aa.csv",recl=2000)
```
String literal: `wetland_salt_aa.csv`

### header_sd_channel.f90

**Line 14** (open):
```fortran
open (2508,file="channel_sd_subday.txt",recl = 1500)
```
String literal: `channel_sd_subday.txt`

**Line 20** (open):
```fortran
open (4814,file="channel_sd_subday.csv",recl = 1500)
```
String literal: `channel_sd_subday.csv`

**Line 29** (open):
```fortran
open (2500,file="channel_sd_day.txt",recl = 1500)
```
String literal: `channel_sd_day.txt`

**Line 41** (open):
```fortran
open (2504,file="channel_sd_day.csv",recl = 1500)
```
String literal: `channel_sd_day.csv`

**Line 58** (open):
```fortran
open (2501,file="channel_sd_mon.txt",recl = 1500)
```
String literal: `channel_sd_mon.txt`

**Line 71** (open):
```fortran
open (2505,file="channel_sd_mon.csv",recl = 1500)
```
String literal: `channel_sd_mon.csv`

**Line 88** (open):
```fortran
open (2502,file="channel_sd_yr.txt",recl = 1500)
```
String literal: `channel_sd_yr.txt`

**Line 101** (open):
```fortran
open (2506,file="channel_sd_yr.csv",recl = 1500)
```
String literal: `channel_sd_yr.csv`

**Line 118** (open):
```fortran
open (2503,file="channel_sd_aa.txt",recl = 1500)
```
String literal: `channel_sd_aa.txt`

**Line 131** (open):
```fortran
open (2507,file="channel_sd_aa.csv",recl = 1500)
```
String literal: `channel_sd_aa.csv`

**Line 150** (open):
```fortran
open (4800,file="channel_sdmorph_day.txt",recl = 1500)
```
String literal: `channel_sdmorph_day.txt`

**Line 156** (open):
```fortran
open (4804,file="channel_sdmorph_day.csv",recl = 1500)
```
String literal: `channel_sdmorph_day.csv`

**Line 167** (open):
```fortran
open (4801,file="channel_sdmorph_mon.txt",recl = 1500)
```
String literal: `channel_sdmorph_mon.txt`

**Line 173** (open):
```fortran
open (4805,file="channel_mon_sdmorph.csv",recl = 1500)
```
String literal: `channel_mon_sdmorph.csv`

**Line 184** (open):
```fortran
open (4802,file="channel_sdmorph_yr.txt",recl = 1500)
```
String literal: `channel_sdmorph_yr.txt`

**Line 190** (open):
```fortran
open (4806,file="channel_sdmorph_yr.csv",recl = 1500)
```
String literal: `channel_sdmorph_yr.csv`

**Line 201** (open):
```fortran
open (4803,file="channel_sdmorph_aa.txt",recl = 1500)
```
String literal: `channel_sdmorph_aa.txt`

**Line 207** (open):
```fortran
open (4807,file="channel_sdmorph_aa.csv",recl = 1500)
```
String literal: `channel_sdmorph_aa.csv`

**Line 219** (open):
```fortran
open (4808,file="sd_chanbud_day.txt", recl = 1500)
```
String literal: `sd_chanbud_day.txt`

**Line 225** (open):
```fortran
open (4812,file="sd_chanbud_day.csv", recl = 1500)
```
String literal: `sd_chanbud_day.csv`

**Line 234** (open):
```fortran
open (4809,file="sd_chanbud_mon.txt",recl = 1500)
```
String literal: `sd_chanbud_mon.txt`

**Line 240** (open):
```fortran
open (4813,file="sd_chanbud_mon.csv",recl = 1500)
```
String literal: `sd_chanbud_mon.csv`

**Line 249** (open):
```fortran
open (4810,file="sd_chanbud_yr.txt", recl = 1500)
```
String literal: `sd_chanbud_yr.txt`

**Line 255** (open):
```fortran
open (4814,file="sd_chanbud_yr.csv", recl = 1500)
```
String literal: `sd_chanbud_yr.csv`

**Line 264** (open):
```fortran
open (4811,file="sd_chanbud_aa.txt",recl = 1500)
```
String literal: `sd_chanbud_aa.txt`

**Line 270** (open):
```fortran
open (4815,file="sd_chanbud_aa.csv",recl = 1500)
```
String literal: `sd_chanbud_aa.csv`

### header_snutc.f90

**Line 10** (open):
```fortran
open (2610,file="hru_orgc.txt",recl=800)
```
String literal: `hru_orgc.txt`

**Line 18** (open):
```fortran
open (2611,file="hru_totc.txt",recl=800)
```
String literal: `hru_totc.txt`

**Line 26** (open):
```fortran
open (2613,file="basin_totc.txt",recl=800)
```
String literal: `basin_totc.txt`

### header_water_allocation.f90

**Line 12** (open):
```fortran
open (3110,file="water_allo_day.txt",recl = 1500)
```
String literal: `water_allo_day.txt`

**Line 18** (open):
```fortran
open (3114,file="water_allo_day.csv",recl = 1500)
```
String literal: `water_allo_day.csv`

**Line 29** (open):
```fortran
open (3111,file="water_allo_mon.txt",recl = 1500)
```
String literal: `water_allo_mon.txt`

**Line 35** (open):
```fortran
open (3115,file="water_allo_mon.csv",recl = 1500)
```
String literal: `water_allo_mon.csv`

**Line 46** (open):
```fortran
open (3112,file="water_allo_yr.txt",recl = 1500)
```
String literal: `water_allo_yr.txt`

**Line 52** (open):
```fortran
open (3116,file="water_allo_yr.csv",recl = 1500)
```
String literal: `water_allo_yr.csv`

**Line 63** (open):
```fortran
open (3113,file="water_allo_aa.txt",recl = 1500)
```
String literal: `water_allo_aa.txt`

**Line 69** (open):
```fortran
open (3117,file="water_allo_aa.csv",recl = 1500)
```
String literal: `water_allo_aa.csv`

### header_wetland.f90

**Line 11** (open):
```fortran
open (2548,file="wetland_day.txt",recl=1500)
```
String literal: `wetland_day.txt`

**Line 17** (open):
```fortran
open (2552,file="wetland_day.csv",recl=1500)
```
String literal: `wetland_day.csv`

**Line 27** (open):
```fortran
open (2549,file="wetland_mon.txt",recl=1500)
```
String literal: `wetland_mon.txt`

**Line 33** (open):
```fortran
open (2553,file="wetland_mon.csv",recl=1500)
```
String literal: `wetland_mon.csv`

**Line 43** (open):
```fortran
open (2550,file="wetland_yr.txt",recl=1500)
```
String literal: `wetland_yr.txt`

**Line 49** (open):
```fortran
open (2554,file="wetland_yr.csv",recl=1500)
```
String literal: `wetland_yr.csv`

**Line 60** (open):
```fortran
open (2551,file="wetland_aa.txt",recl=1500)
```
String literal: `wetland_aa.txt`

**Line 66** (open):
```fortran
open (2555,file="wetland_aa.csv",recl=1500)
```
String literal: `wetland_aa.csv`

### header_write.f90

**Line 15** (open):
```fortran
open (6000,file="flow_duration_curve.out", recl=800)
```
String literal: `flow_duration_curve.out`

**Line 24** (open):
```fortran
open (4999,file="hru-out.cal", recl = 800)
```
String literal: `hru-out.cal`

**Line 33** (open):
```fortran
open (5000,file="hru-new.cal", recl = 800)
```
String literal: `hru-new.cal`

**Line 39** (open):
```fortran
open (5001,file="hydrology-cal.hyd", recl = 800)
```
String literal: `hydrology-cal.hyd`

**Line 59** (open):
```fortran
open (2090,file="basin_aqu_day.txt", recl = 1500)
```
String literal: `basin_aqu_day.txt`

**Line 65** (open):
```fortran
open (2094,file="basin_aqu_day.csv", recl = 1500)
```
String literal: `basin_aqu_day.csv`

**Line 74** (open):
```fortran
open (2091,file="basin_aqu_mon.txt",recl = 1500)
```
String literal: `basin_aqu_mon.txt`

**Line 80** (open):
```fortran
open (2095,file="basin_aqu_mon.csv",recl = 1500)
```
String literal: `basin_aqu_mon.csv`

**Line 89** (open):
```fortran
open (2092,file="basin_aqu_yr.txt",recl = 1500)
```
String literal: `basin_aqu_yr.txt`

**Line 95** (open):
```fortran
open (2096,file="basin_aqu_yr.csv",recl = 1500)
```
String literal: `basin_aqu_yr.csv`

**Line 104** (open):
```fortran
open (2093,file="basin_aqu_aa.txt",recl = 1500)
```
String literal: `basin_aqu_aa.txt`

**Line 110** (open):
```fortran
open (2097,file="basin_aqu_aa.csv",recl = 1500)
```
String literal: `basin_aqu_aa.csv`

**Line 121** (open):
```fortran
open (2100,file="basin_res_day.txt", recl = 1500)
```
String literal: `basin_res_day.txt`

**Line 127** (open):
```fortran
open (2104,file="basin_res_day.csv", recl = 1500)
```
String literal: `basin_res_day.csv`

**Line 136** (open):
```fortran
open (2101,file="basin_res_mon.txt",recl = 1500)
```
String literal: `basin_res_mon.txt`

**Line 142** (open):
```fortran
open (2105,file="basin_res_mon.csv",recl = 1500)
```
String literal: `basin_res_mon.csv`

**Line 151** (open):
```fortran
open (2102,file="basin_res_yr.txt", recl = 1500)
```
String literal: `basin_res_yr.txt`

**Line 157** (open):
```fortran
open (2106,file="basin_res_yr.csv", recl = 1500)
```
String literal: `basin_res_yr.csv`

**Line 166** (open):
```fortran
open (2103,file="basin_res_aa.txt",recl = 1500)
```
String literal: `basin_res_aa.txt`

**Line 172** (open):
```fortran
open (2107,file="basin_res_aa.csv",recl = 1500)
```
String literal: `basin_res_aa.csv`

**Line 183** (open):
```fortran
open (4600,file="recall_day.txt", recl = 1500)
```
String literal: `recall_day.txt`

**Line 189** (open):
```fortran
open (4604,file="recall_day.csv", recl = 1500)
```
String literal: `recall_day.csv`

**Line 198** (open):
```fortran
open (4601,file="recall_mon.txt",recl = 1500)
```
String literal: `recall_mon.txt`

**Line 204** (open):
```fortran
open (4605,file="recall_mon.csv",recl = 1500)
```
String literal: `recall_mon.csv`

**Line 213** (open):
```fortran
open (4602,file="recall_yr.txt", recl = 1500)
```
String literal: `recall_yr.txt`

**Line 219** (open):
```fortran
open (4606,file="recall_yr.csv", recl = 1500)
```
String literal: `recall_yr.csv`

**Line 228** (open):
```fortran
open (4603,file="recall_aa.txt",recl = 1500)
```
String literal: `recall_aa.txt`

**Line 234** (open):
```fortran
open (4607,file="recall_aa.csv",recl = 1500)
```
String literal: `recall_aa.csv`

**Line 246** (open):
```fortran
open (2110,file="basin_cha_day.txt", recl = 1500)
```
String literal: `basin_cha_day.txt`

**Line 252** (open):
```fortran
open (2114,file="basin_cha_day.csv", recl = 1500)
```
String literal: `basin_cha_day.csv`

**Line 261** (open):
```fortran
open (2111,file="basin_cha_mon.txt",recl = 1500)
```
String literal: `basin_cha_mon.txt`

**Line 267** (open):
```fortran
open (2115,file="basin_cha_mon.csv",recl = 1500)
```
String literal: `basin_cha_mon.csv`

**Line 276** (open):
```fortran
open (2112,file="basin_cha_yr.txt", recl = 1500)
```
String literal: `basin_cha_yr.txt`

**Line 282** (open):
```fortran
open (2116,file="basin_cha_yr.csv", recl = 1500)
```
String literal: `basin_cha_yr.csv`

**Line 291** (open):
```fortran
open (2113,file="basin_cha_aa.txt",recl = 1500)
```
String literal: `basin_cha_aa.txt`

**Line 297** (open):
```fortran
open (2117,file="basin_cha_aa.csv",recl = 1500)
```
String literal: `basin_cha_aa.csv`

**Line 308** (open):
```fortran
open (4900,file="basin_sd_cha_day.txt", recl = 1500)
```
String literal: `basin_sd_cha_day.txt`

**Line 314** (open):
```fortran
open (4904,file="basin_sd_cha_day.csv", recl = 1500)
```
String literal: `basin_sd_cha_day.csv`

**Line 323** (open):
```fortran
open (4901,file="basin_sd_cha_mon.txt",recl = 1500)
```
String literal: `basin_sd_cha_mon.txt`

**Line 329** (open):
```fortran
open (4905,file="basin_sd_cha_mon.csv",recl = 1500)
```
String literal: `basin_sd_cha_mon.csv`

**Line 338** (open):
```fortran
open (4902,file="basin_sd_cha_yr.txt", recl = 1500)
```
String literal: `basin_sd_cha_yr.txt`

**Line 344** (open):
```fortran
open (4906,file="basin_sd_cha_yr.csv", recl = 1500)
```
String literal: `basin_sd_cha_yr.csv`

**Line 353** (open):
```fortran
open (4903,file="basin_sd_cha_aa.txt",recl = 1500)
```
String literal: `basin_sd_cha_aa.txt`

**Line 359** (open):
```fortran
open (4907,file="basin_sd_cha_aa.csv",recl = 1500)
```
String literal: `basin_sd_cha_aa.csv`

**Line 371** (open):
```fortran
open (2120,file="basin_sd_chamorph_day.txt", recl = 1500)
```
String literal: `basin_sd_chamorph_day.txt`

**Line 377** (open):
```fortran
open (2124,file="basin_sd_chamorph_day.csv", recl = 1500)
```
String literal: `basin_sd_chamorph_day.csv`

**Line 386** (open):
```fortran
open (2121,file="basin_sd_chamorph_mon.txt",recl = 1500)
```
String literal: `basin_sd_chamorph_mon.txt`

**Line 392** (open):
```fortran
open (2125,file="basin_sd_chamorph_mon.csv",recl = 1500)
```
String literal: `basin_sd_chamorph_mon.csv`

**Line 401** (open):
```fortran
open (2122,file="basin_sd_chamorph_yr.txt", recl = 1500)
```
String literal: `basin_sd_chamorph_yr.txt`

**Line 407** (open):
```fortran
open (2126,file="basin_sd_chamorph_yr.csv", recl = 1500)
```
String literal: `basin_sd_chamorph_yr.csv`

**Line 416** (open):
```fortran
open (2123,file="basin_sd_chamorph_aa.txt",recl = 1500)
```
String literal: `basin_sd_chamorph_aa.txt`

**Line 422** (open):
```fortran
open (2127,file="basin_sd_chamorph_aa.csv",recl = 1500)
```
String literal: `basin_sd_chamorph_aa.csv`

**Line 433** (open):
```fortran
open (2128,file="basin_sd_chanbud_day.txt", recl = 1500)
```
String literal: `basin_sd_chanbud_day.txt`

**Line 439** (open):
```fortran
open (2132,file="basin_sd_chanbud_day.csv", recl = 1500)
```
String literal: `basin_sd_chanbud_day.csv`

**Line 448** (open):
```fortran
open (2129,file="basin_sd_chanbud_mon.txt",recl = 1500)
```
String literal: `basin_sd_chanbud_mon.txt`

**Line 454** (open):
```fortran
open (2133,file="basin_sd_chanbud_mon.csv",recl = 1500)
```
String literal: `basin_sd_chanbud_mon.csv`

**Line 463** (open):
```fortran
open (2130,file="basin_sd_chanbud_yr.txt", recl = 1500)
```
String literal: `basin_sd_chanbud_yr.txt`

**Line 469** (open):
```fortran
open (2134,file="basin_sd_chanbud_yr.csv", recl = 1500)
```
String literal: `basin_sd_chanbud_yr.csv`

**Line 478** (open):
```fortran
open (2131,file="basin_sd_chanbud_aa.txt",recl = 1500)
```
String literal: `basin_sd_chanbud_aa.txt`

**Line 484** (open):
```fortran
open (2135,file="basin_sd_chanbud_aa.csv",recl = 1500)
```
String literal: `basin_sd_chanbud_aa.csv`

**Line 496** (open):
```fortran
open (4500,file="basin_psc_day.txt", recl = 1500)
```
String literal: `basin_psc_day.txt`

**Line 502** (open):
```fortran
open (4504,file="basin_psc_day.csv", recl = 1500)
```
String literal: `basin_psc_day.csv`

**Line 511** (open):
```fortran
open (4501,file="basin_psc_mon.txt",recl = 1500)
```
String literal: `basin_psc_mon.txt`

**Line 517** (open):
```fortran
open (4505,file="basin_psc_mon.csv",recl = 1500)
```
String literal: `basin_psc_mon.csv`

**Line 526** (open):
```fortran
open (4502,file="basin_psc_yr.txt", recl = 1500)
```
String literal: `basin_psc_yr.txt`

**Line 532** (open):
```fortran
open (4506,file="basin_psc_yr.csv", recl = 1500)
```
String literal: `basin_psc_yr.csv`

**Line 541** (open):
```fortran
open (4503,file="basin_psc_aa.txt",recl = 1500)
```
String literal: `basin_psc_aa.txt`

**Line 547** (open):
```fortran
open (4507,file="basin_psc_aa.csv",recl = 1500)
```
String literal: `basin_psc_aa.csv`

**Line 559** (open):
```fortran
open (2600,file="ru_day.txt", recl = 1500)
```
String literal: `ru_day.txt`

**Line 565** (open):
```fortran
open (2604,file="ru_day.csv", recl = 1500)
```
String literal: `ru_day.csv`

**Line 574** (open):
```fortran
open (2601,file="ru_mon.txt",recl = 1500)
```
String literal: `ru_mon.txt`

**Line 580** (open):
```fortran
open (2605,file="ru_mon.csv",recl = 1500)
```
String literal: `ru_mon.csv`

**Line 589** (open):
```fortran
open (2602,file="ru_yr.txt", recl = 1500)
```
String literal: `ru_yr.txt`

**Line 595** (open):
```fortran
open (2606,file="ru_yr.csv", recl = 1500)
```
String literal: `ru_yr.csv`

**Line 604** (open):
```fortran
open (2603,file="ru_aa.txt",recl = 1500)
```
String literal: `ru_aa.txt`

**Line 610** (open):
```fortran
open (2607,file="ru_aa.csv",recl = 1500)
```
String literal: `ru_aa.csv`

### header_yield.f90

**Line 10** (open):
```fortran
open (4700,file="yield.out", recl=800)
```
String literal: `yield.out`

**Line 13** (open):
```fortran
open (4701,file="yield.csv", recl=800)
```
String literal: `yield.csv`

**Line 21** (open):
```fortran
open (5100,file="basin_crop_yld_yr.txt", recl=800)
```
String literal: `basin_crop_yld_yr.txt`

**Line 25** (open):
```fortran
open (5101,file="basin_crop_yld_aa.txt", recl=800)
```
String literal: `basin_crop_yld_aa.txt`

### hyd_connect.f90

**Line 78** (inquire):
```fortran
inquire(file='gwflow.huc12cell',exist=i_exist)
```
String literal: `gwflow.huc12cell`

**Line 417** (open):
```fortran
open (9002,file="looping.con",recl = 8000)
```
String literal: `looping.con`

### manure_allocation_read.f90

**Line 34** (inquire):
```fortran
inquire (file="manure_allo.mnu", exist=i_exist)
```
String literal: `manure_allo.mnu`

**Line 39** (open):
```fortran
open (107,file="manure_allo.mnu")
```
String literal: `manure_allo.mnu`

### manure_parm_read.f90

**Line 22** (inquire):
```fortran
inquire (file="manure.frt", exist=i_exist)
```
String literal: `manure.frt`

**Line 27** (open):
```fortran
open (107,file="manure.frt")
```
String literal: `manure.frt`

### mgt_read_puddle.f90

**Line 18** (inquire):
```fortran
inquire (file="puddle.ops", exist=i_exist)
```
String literal: `puddle.ops`

**Line 23** (open):
```fortran
open (104,file="puddle.ops")
```
String literal: `puddle.ops`

### output_landscape_init.f90

**Line 17** (open):
```fortran
open (2000,file="hru_wb_day.txt",recl = 1500)
```
String literal: `hru_wb_day.txt`

**Line 24** (open):
```fortran
open (2004,file="hru_wb_day.csv",recl = 1500)
```
String literal: `hru_wb_day.csv`

**Line 34** (open):
```fortran
open (2001,file="hru_wb_mon.txt",recl = 1500)
```
String literal: `hru_wb_mon.txt`

**Line 41** (open):
```fortran
open (2005,file="hru_wb_mon.csv",recl = 1500)
```
String literal: `hru_wb_mon.csv`

**Line 51** (open):
```fortran
open (2002,file="hru_wb_yr.txt",recl = 1500)
```
String literal: `hru_wb_yr.txt`

**Line 57** (open):
```fortran
open (2006,file="hru_wb_yr.csv",recl = 1500)
```
String literal: `hru_wb_yr.csv`

**Line 67** (open):
```fortran
open (2003,file="hru_wb_aa.txt",recl = 1500)
```
String literal: `hru_wb_aa.txt`

**Line 73** (open):
```fortran
open (2007,file="hru_wb_aa.csv",recl = 1500)
```
String literal: `hru_wb_aa.csv`

**Line 83** (open):
```fortran
open (2020,file="hru_nb_day.txt", recl = 1500)
```
String literal: `hru_nb_day.txt`

**Line 89** (open):
```fortran
open (2024,file="hru_nb_day.csv", recl = 1500)
```
String literal: `hru_nb_day.csv`

**Line 99** (open):
```fortran
open (3333,file="hru_ncycle_day.txt", recl = 1500)
```
String literal: `hru_ncycle_day.txt`

**Line 105** (open):
```fortran
open (3334,file="hru_ncycle_day.csv", recl = 1500)
```
String literal: `hru_ncycle_day.csv`

**Line 114** (open):
```fortran
open (3335,file="hru_ncycle_mon.txt", recl = 1500)
```
String literal: `hru_ncycle_mon.txt`

**Line 120** (open):
```fortran
open (3336,file="hru_ncycle_mon.csv", recl = 1500)
```
String literal: `hru_ncycle_mon.csv`

**Line 129** (open):
```fortran
open (3337,file="hru_ncycle_yr.txt", recl = 1500)
```
String literal: `hru_ncycle_yr.txt`

**Line 135** (open):
```fortran
open (3338,file="hru_ncycle_yr.csv", recl = 1500)
```
String literal: `hru_ncycle_yr.csv`

**Line 144** (open):
```fortran
open (3339,file="hru_ncycle_aa.txt", recl = 1500)
```
String literal: `hru_ncycle_aa.txt`

**Line 150** (open):
```fortran
open (3340,file="hru_ncycle_aa.csv", recl = 1500)
```
String literal: `hru_ncycle_aa.csv`

**Line 160** (open):
```fortran
open (2021,file="hru_nb_mon.txt", recl = 1500)
```
String literal: `hru_nb_mon.txt`

**Line 166** (open):
```fortran
open (2025,file="hru_nb_mon.csv", recl = 1500)
```
String literal: `hru_nb_mon.csv`

**Line 175** (open):
```fortran
open (2022,file="hru_nb_yr.txt", recl = 1500)
```
String literal: `hru_nb_yr.txt`

**Line 181** (open):
```fortran
open (2026,file="hru_nb_yr.csv", recl = 1500)
```
String literal: `hru_nb_yr.csv`

**Line 190** (open):
```fortran
open (2023,file="hru_nb_aa.txt", recl = 1500)
```
String literal: `hru_nb_aa.txt`

**Line 196** (open):
```fortran
open (2027,file="hru_nb_aa.csv", recl = 1500)
```
String literal: `hru_nb_aa.csv`

**Line 206** (open):
```fortran
open (4520,file="hru_soilcarb_day.txt", recl = 1500)
```
String literal: `hru_soilcarb_day.txt`

**Line 212** (open):
```fortran
open (4524,file="hru_soilcarb_day.csv", recl = 1500)
```
String literal: `hru_soilcarb_day.csv`

**Line 221** (open):
```fortran
open (4521,file="hru_soilcarb_mon.txt", recl = 1500)
```
String literal: `hru_soilcarb_mon.txt`

**Line 227** (open):
```fortran
open (4525,file="hru_soilcarb_mon.csv", recl = 1500)
```
String literal: `hru_soilcarb_mon.csv`

**Line 236** (open):
```fortran
open (4522,file="hru_soilcarb_yr.txt", recl = 1500)
```
String literal: `hru_soilcarb_yr.txt`

**Line 242** (open):
```fortran
open (4526,file="hru_soilcarb_yr.csv", recl = 1500)
```
String literal: `hru_soilcarb_yr.csv`

**Line 251** (open):
```fortran
open (4523,file="hru_soilcarb_aa.txt", recl = 1500)
```
String literal: `hru_soilcarb_aa.txt`

**Line 257** (open):
```fortran
open (4527,file="hru_soilcarb_aa.csv", recl = 1500)
```
String literal: `hru_soilcarb_aa.csv`

**Line 269** (open):
```fortran
open (4530,file="hru_rescarb_day.txt", recl = 1500)
```
String literal: `hru_rescarb_day.txt`

**Line 275** (open):
```fortran
open (4534,file="hru_rescarb_day.csv", recl = 1500)
```
String literal: `hru_rescarb_day.csv`

**Line 284** (open):
```fortran
open (4531,file="hru_rescarb_mon.txt", recl = 1500)
```
String literal: `hru_rescarb_mon.txt`

**Line 290** (open):
```fortran
open (4535,file="hru_rescarb_mon.csv", recl = 1500)
```
String literal: `hru_rescarb_mon.csv`

**Line 299** (open):
```fortran
open (4532,file="hru_rescarb_yr.txt", recl = 1500)
```
String literal: `hru_rescarb_yr.txt`

**Line 305** (open):
```fortran
open (4536,file="hru_rescarb_yr.csv", recl = 1500)
```
String literal: `hru_rescarb_yr.csv`

**Line 314** (open):
```fortran
open (4533,file="hru_rescarb_aa.txt", recl = 1500)
```
String literal: `hru_rescarb_aa.txt`

**Line 320** (open):
```fortran
open (4537,file="hru_rescarb_aa.csv", recl = 1500)
```
String literal: `hru_rescarb_aa.csv`

**Line 332** (open):
```fortran
open (4540,file="hru_plcarb_day.txt", recl = 1500)
```
String literal: `hru_plcarb_day.txt`

**Line 338** (open):
```fortran
open (4544,file="hru_plcarb_day.csv", recl = 1500)
```
String literal: `hru_plcarb_day.csv`

**Line 347** (open):
```fortran
open (4541,file="hru_plcarb_mon.txt", recl = 1500)
```
String literal: `hru_plcarb_mon.txt`

**Line 353** (open):
```fortran
open (4545,file="hru_plcarb_mon.csv", recl = 1500)
```
String literal: `hru_plcarb_mon.csv`

**Line 362** (open):
```fortran
open (4542,file="hru_plcarb_yr.txt", recl = 1500)
```
String literal: `hru_plcarb_yr.txt`

**Line 368** (open):
```fortran
open (4546,file="hru_plcarb_yr.csv", recl = 1500)
```
String literal: `hru_plcarb_yr.csv`

**Line 377** (open):
```fortran
open (4543,file="hru_plcarb_aa.txt", recl = 1500)
```
String literal: `hru_plcarb_aa.txt`

**Line 383** (open):
```fortran
open (4547,file="hru_plcarb_aa.csv", recl = 1500)
```
String literal: `hru_plcarb_aa.csv`

**Line 395** (open):
```fortran
open (4550,file="hru_scf_day.txt", recl = 1500)
```
String literal: `hru_scf_day.txt`

**Line 401** (open):
```fortran
open (4554,file="hru_scf_day.csv", recl = 1500)
```
String literal: `hru_scf_day.csv`

**Line 410** (open):
```fortran
open (4551,file="hru_scf_mon.txt", recl = 1500)
```
String literal: `hru_scf_mon.txt`

**Line 416** (open):
```fortran
open (4555,file="hru_scf_mon.csv", recl = 1500)
```
String literal: `hru_scf_mon.csv`

**Line 425** (open):
```fortran
open (4552,file="hru_scf_yr.txt", recl = 1500)
```
String literal: `hru_scf_yr.txt`

**Line 431** (open):
```fortran
open (4556,file="hru_scf_yr.csv", recl = 1500)
```
String literal: `hru_scf_yr.csv`

**Line 440** (open):
```fortran
open (4553,file="hru_scf_aa.txt", recl = 1500)
```
String literal: `hru_scf_aa.txt`

**Line 446** (open):
```fortran
open (4557,file="hru_scf_aa.csv", recl = 1500)
```
String literal: `hru_scf_aa.csv`

**Line 461** (open):
```fortran
open (4548,file = "hru_cbn_lyr.txt", recl = 1500)
```
String literal: `hru_cbn_lyr.txt`

**Line 467** (open):
```fortran
open (4549,file="hru_cbn_lyr.csv", recl = 1500)
```
String literal: `hru_cbn_lyr.csv`

**Line 474** (open):
```fortran
open (4558,file = "hru_seq_lyr.txt", recl = 1500)
```
String literal: `hru_seq_lyr.txt`

**Line 480** (open):
```fortran
open (4559,file="hru_seq_lyr.csv", recl = 1500)
```
String literal: `hru_seq_lyr.csv`

**Line 488** (open):
```fortran
open (4560,file = "hru_plc_stat.txt", recl = 1500)
```
String literal: `hru_plc_stat.txt`

**Line 494** (open):
```fortran
open (4563,file="hru_plc_stat.csv", recl = 1500)
```
String literal: `hru_plc_stat.csv`

**Line 502** (open):
```fortran
open (4561,file = "hru_rsdc_stat.txt", recl = 1500)
```
String literal: `hru_rsdc_stat.txt`

**Line 508** (open):
```fortran
open (4564,file="hru_rsdc_stat.csv", recl = 1500)
```
String literal: `hru_rsdc_stat.csv`

**Line 515** (open):
```fortran
open (4562,file = "hru_soilc_stat.txt", recl = 1500)
```
String literal: `hru_soilc_stat.txt`

**Line 521** (open):
```fortran
open (4565,file="hru_soilc_stat.csv", recl = 1500)
```
String literal: `hru_soilc_stat.csv`

**Line 528** (open):
```fortran
open (4567,file = "hru_cflux_stat.txt", recl = 1500)
```
String literal: `hru_cflux_stat.txt`

**Line 534** (open):
```fortran
open (4568,file="hru_cflux_stat.csv", recl = 1500)
```
String literal: `hru_cflux_stat.csv`

**Line 541** (open):
```fortran
open (4570,file = "hru_soilcarb_mb_stat.txt", recl = 1500)
```
String literal: `hru_soilcarb_mb_stat.txt`

**Line 547** (open):
```fortran
open (4571,file="hru_soilcarb_mb_stat.csv", recl = 1500)
```
String literal: `hru_soilcarb_mb_stat.csv`

**Line 554** (open):
```fortran
open (4572,file = "hru_cpool_stat.txt", recl = 1500)
```
String literal: `hru_cpool_stat.txt`

**Line 560** (open):
```fortran
open (4573,file="hru_cpool_stat.csv", recl = 1500)
```
String literal: `hru_cpool_stat.csv`

**Line 567** (open):
```fortran
open (4582,file = "hru_n_p_pool_stat.txt", recl = 1500)
```
String literal: `hru_n_p_pool_stat.txt`

**Line 573** (open):
```fortran
open (4583,file="hru_n_p_pool_stat.csv", recl = 1500)
```
String literal: `hru_n_p_pool_stat.csv`

**Line 580** (open):
```fortran
open (4580,file = "hru_org_trans_vars.txt", recl = 1500)
```
String literal: `hru_org_trans_vars.txt`

**Line 586** (open):
```fortran
open (4581,file="hru_org_trans_vars.csv", recl = 1500)
```
String literal: `hru_org_trans_vars.csv`

**Line 599** (open):
```fortran
open (4574,file = "hru_carbvars.txt", recl = 1500)
```
String literal: `hru_carbvars.txt`

**Line 604** (open):
```fortran
open (4575,file="hru_carbvars.csv", recl = 1500)
```
String literal: `hru_carbvars.csv`

**Line 615** (open):
```fortran
open (4576,file = "hru_org_allo_vars.txt", recl = 1500)
```
String literal: `hru_org_allo_vars.txt`

**Line 620** (open):
```fortran
open (4577,file="hru_org_allo_vars.csv", recl = 1500)
```
String literal: `hru_org_allo_vars.csv`

**Line 631** (open):
```fortran
open (4578,file = "hru_org_ratio_vars.txt", recl = 1500)
```
String literal: `hru_org_ratio_vars.txt`

**Line 636** (open):
```fortran
open (4579,file="hru_org_ratio_vars.csv", recl = 1500)
```
String literal: `hru_org_ratio_vars.csv`

**Line 647** (open):
```fortran
open (4584,file = "hru_endsim_soil_prop.txt", recl = 1500)
```
String literal: `hru_endsim_soil_prop.txt`

**Line 652** (open):
```fortran
open (4585,file="hru_endsim_soil_prop.csv", recl = 1500)
```
String literal: `hru_endsim_soil_prop.csv`

**Line 662** (open):
```fortran
open (4566,file = "basin_carbon_all.txt", recl = 1500)
```
String literal: `basin_carbon_all.txt`

**Line 674** (open):
```fortran
open (2030,file="hru_ls_day.txt", recl = 1500)
```
String literal: `hru_ls_day.txt`

**Line 680** (open):
```fortran
open (2034,file="hru_ls_day.csv", recl = 1500)
```
String literal: `hru_ls_day.csv`

**Line 691** (open):
```fortran
open (3341,file="hru_nut_carb_gl_day.txt", recl = 1500)
```
String literal: `hru_nut_carb_gl_day.txt`

**Line 697** (open):
```fortran
open (3342,file="hru_nut_carb_gl_day.csv", recl = 1500)
```
String literal: `hru_nut_carb_gl_day.csv`

**Line 706** (open):
```fortran
open (3343,file="hru_nut_carb_gl_mon.txt", recl = 1500)
```
String literal: `hru_nut_carb_gl_mon.txt`

**Line 712** (open):
```fortran
open (3344,file="hru_nut_carb_gl_mon.csv", recl = 1500)
```
String literal: `hru_nut_carb_gl_mon.csv`

**Line 721** (open):
```fortran
open (3345,file="hru_nut_carb_gl_yr.txt", recl = 1500)
```
String literal: `hru_nut_carb_gl_yr.txt`

**Line 727** (open):
```fortran
open (3346,file="hru_nut_carb_gl_yr.csv", recl = 1500)
```
String literal: `hru_nut_carb_gl_yr.csv`

**Line 736** (open):
```fortran
open (3347,file="hru_nut_carb_gl_aa.txt", recl = 1500)
```
String literal: `hru_nut_carb_gl_aa.txt`

**Line 742** (open):
```fortran
open (3348,file="hru_nut_carb_gl_aa.csv", recl = 1500)
```
String literal: `hru_nut_carb_gl_aa.csv`

**Line 752** (open):
```fortran
open (2031,file="hru_ls_mon.txt",recl = 1500)
```
String literal: `hru_ls_mon.txt`

**Line 758** (open):
```fortran
open (2035,file="hru_ls_mon.csv",recl = 1500)
```
String literal: `hru_ls_mon.csv`

**Line 767** (open):
```fortran
open (2032,file="hru_ls_yr.txt", recl = 1500)
```
String literal: `hru_ls_yr.txt`

**Line 773** (open):
```fortran
open (2036,file="hru_ls_yr.csv", recl = 1500)
```
String literal: `hru_ls_yr.csv`

**Line 782** (open):
```fortran
open (2033,file="hru_ls_aa.txt",recl = 1500)
```
String literal: `hru_ls_aa.txt`

**Line 788** (open):
```fortran
open (2037,file="hru_ls_aa.csv",recl = 1500)
```
String literal: `hru_ls_aa.csv`

**Line 798** (open):
```fortran
open (2040,file="hru_pw_day.txt", recl = 1500)
```
String literal: `hru_pw_day.txt`

**Line 804** (open):
```fortran
open (2044,file="hru_pw_day.csv", recl = 1500)
```
String literal: `hru_pw_day.csv`

**Line 813** (open):
```fortran
open (2041,file="hru_pw_mon.txt",recl = 1500)
```
String literal: `hru_pw_mon.txt`

**Line 819** (open):
```fortran
open (2045,file="hru_pw_mon.csv",recl = 1500)
```
String literal: `hru_pw_mon.csv`

**Line 828** (open):
```fortran
open (2042,file="hru_pw_yr.txt", recl = 1500)
```
String literal: `hru_pw_yr.txt`

**Line 834** (open):
```fortran
open (2046,file="hru_pw_yr.csv", recl = 1500)
```
String literal: `hru_pw_yr.csv`

**Line 843** (open):
```fortran
open (2043,file="hru_pw_aa.txt",recl = 1500)
```
String literal: `hru_pw_aa.txt`

**Line 849** (open):
```fortran
open (2047,file="hru_pw_aa.csv",recl = 1500)
```
String literal: `hru_pw_aa.csv`

**Line 862** (open):
```fortran
open (2300,file="hru-lte_wb_day.txt",recl = 1500)
```
String literal: `hru-lte_wb_day.txt`

**Line 868** (open):
```fortran
open (2304,file="hru-lte_wb_day.csv",recl = 1500)
```
String literal: `hru-lte_wb_day.csv`

**Line 878** (open):
```fortran
open (2301,file="hru-lte_wb_mon.txt",recl = 1500)
```
String literal: `hru-lte_wb_mon.txt`

**Line 884** (open):
```fortran
open (2305,file="hru-lte_wb_mon.csv",recl = 1500)
```
String literal: `hru-lte_wb_mon.csv`

**Line 895** (open):
```fortran
open (2302,file="hru-lte_wb_yr.txt",recl = 1500)
```
String literal: `hru-lte_wb_yr.txt`

**Line 901** (open):
```fortran
open (2306,file="hru-lte_wb_yr.csv",recl = 1500)
```
String literal: `hru-lte_wb_yr.csv`

**Line 912** (open):
```fortran
open (2303,file="hru-lte_wb_aa.txt",recl = 1500)
```
String literal: `hru-lte_wb_aa.txt`

**Line 918** (open):
```fortran
open (2307,file="hru-lte_wb_aa.csv",recl = 1500)
```
String literal: `hru-lte_wb_aa.csv`

**Line 940** (open):
```fortran
open (2440,file="hru-lte_ls_day.txt",recl = 1500)
```
String literal: `hru-lte_ls_day.txt`

**Line 946** (open):
```fortran
open (2444,file="hru-lte_ls_day.csv",recl = 1500)
```
String literal: `hru-lte_ls_day.csv`

**Line 955** (open):
```fortran
open (2441,file="hru-lte_ls_mon.txt",recl = 1500)
```
String literal: `hru-lte_ls_mon.txt`

**Line 961** (open):
```fortran
open (2445,file="hru-lte_ls_mon.csv",recl = 1500)
```
String literal: `hru-lte_ls_mon.csv`

**Line 970** (open):
```fortran
open (2442,file="hru-lte_ls_yr.txt",recl = 1500)
```
String literal: `hru-lte_ls_yr.txt`

**Line 976** (open):
```fortran
open (2446,file="hru-lte_ls_yr.csv",recl = 1500)
```
String literal: `hru-lte_ls_yr.csv`

**Line 985** (open):
```fortran
open (2443,file="hru-lte_ls_aa.txt",recl = 1500)
```
String literal: `hru-lte_ls_aa.txt`

**Line 991** (open):
```fortran
open (2447,file="hru-lte_ls_aa.csv",recl = 1500)
```
String literal: `hru-lte_ls_aa.csv`

**Line 1002** (open):
```fortran
open (2460,file="hru-lte_pw_day.txt",recl = 1500)
```
String literal: `hru-lte_pw_day.txt`

**Line 1008** (open):
```fortran
open (2464,file="hru-lte_pw_day.csv",recl = 1500)
```
String literal: `hru-lte_pw_day.csv`

**Line 1017** (open):
```fortran
open (2461,file="hru-lte_pw_mon.txt",recl = 1500)
```
String literal: `hru-lte_pw_mon.txt`

**Line 1023** (open):
```fortran
open (2465,file="hru-lte_pw_mon.csv",recl = 1500)
```
String literal: `hru-lte_pw_mon.csv`

**Line 1032** (open):
```fortran
open (2462,file="hru-lte_pw_yr.txt",recl = 1500)
```
String literal: `hru-lte_pw_yr.txt`

**Line 1038** (open):
```fortran
open (2466,file="hru-lte_pw_yr.csv",recl = 1500)
```
String literal: `hru-lte_pw_yr.csv`

**Line 1047** (open):
```fortran
open (2463,file="hru-lte_pw_aa.txt",recl = 1500)
```
String literal: `hru-lte_pw_aa.txt`

**Line 1053** (open):
```fortran
open (2467,file="hru-lte_pw_aa.csv",recl = 1500)
```
String literal: `hru-lte_pw_aa.csv`

**Line 1065** (open):
```fortran
open (2140,file="lsunit_wb_day.txt",recl = 1500)
```
String literal: `lsunit_wb_day.txt`

**Line 1071** (open):
```fortran
open (2144,file="lsunit_wb_day.csv",recl = 1500)
```
String literal: `lsunit_wb_day.csv`

**Line 1081** (open):
```fortran
open (2141,file="lsunit_wb_mon.txt",recl = 1500)
```
String literal: `lsunit_wb_mon.txt`

**Line 1087** (open):
```fortran
open (2145,file="lsunit_wb_mon.csv",recl = 1500)
```
String literal: `lsunit_wb_mon.csv`

**Line 1097** (open):
```fortran
open (2142,file="lsunit_wb_yr.txt",recl = 1500)
```
String literal: `lsunit_wb_yr.txt`

**Line 1103** (open):
```fortran
open (2146,file="lsunit_wb_yr.csv",recl = 1500)
```
String literal: `lsunit_wb_yr.csv`

**Line 1113** (open):
```fortran
open (2143,file="lsunit_wb_aa.txt",recl = 1500)
```
String literal: `lsunit_wb_aa.txt`

**Line 1119** (open):
```fortran
open (2147,file="lsunit_wb_aa.csv",recl = 1500)
```
String literal: `lsunit_wb_aa.csv`

**Line 1129** (open):
```fortran
open (2150,file="lsunit_nb_day.txt",recl = 1500)
```
String literal: `lsunit_nb_day.txt`

**Line 1135** (open):
```fortran
open (2154,file="lsunit_nb_day.csv",recl = 1500)
```
String literal: `lsunit_nb_day.csv`

**Line 1144** (open):
```fortran
open (2151,file="lsunit_nb_mon.txt", recl = 1500)
```
String literal: `lsunit_nb_mon.txt`

**Line 1150** (open):
```fortran
open (2155,file="lsunit_nb_mon.csv", recl = 1500)
```
String literal: `lsunit_nb_mon.csv`

**Line 1159** (open):
```fortran
open (2152,file="lsunit_nb_yr.txt",recl = 1500)
```
String literal: `lsunit_nb_yr.txt`

**Line 1165** (open):
```fortran
open (2156,file="lsunit_nb_yr.csv",recl = 1500)
```
String literal: `lsunit_nb_yr.csv`

**Line 1174** (open):
```fortran
open (2153,file="lsunit_nb_aa.txt", recl = 1500)
```
String literal: `lsunit_nb_aa.txt`

**Line 1180** (open):
```fortran
open (2157,file="lsunit_nb_aa.csv", recl = 1500)
```
String literal: `lsunit_nb_aa.csv`

**Line 1190** (open):
```fortran
open (2160,file="lsunit_ls_day.txt",recl = 1500)
```
String literal: `lsunit_ls_day.txt`

**Line 1196** (open):
```fortran
open (2164,file="lsunit_ls_day.csv",recl = 1500)
```
String literal: `lsunit_ls_day.csv`

**Line 1205** (open):
```fortran
open (2161,file="lsunit_ls_mon.txt",recl = 1500)
```
String literal: `lsunit_ls_mon.txt`

**Line 1211** (open):
```fortran
open (2165,file="lsunit_ls_mon.csv",recl = 1500)
```
String literal: `lsunit_ls_mon.csv`

**Line 1220** (open):
```fortran
open (2162,file="lsunit_ls_yr.txt",recl = 1500)
```
String literal: `lsunit_ls_yr.txt`

**Line 1226** (open):
```fortran
open (2166,file="lsunit_ls_yr.csv",recl = 1500)
```
String literal: `lsunit_ls_yr.csv`

**Line 1235** (open):
```fortran
open (2163,file="lsunit_ls_aa.txt",recl = 1500)
```
String literal: `lsunit_ls_aa.txt`

**Line 1241** (open):
```fortran
open (2167,file="lsunit_ls_aa.csv",recl = 1500)
```
String literal: `lsunit_ls_aa.csv`

**Line 1251** (open):
```fortran
open (2170,file="lsunit_pw_day.txt",recl = 1500)
```
String literal: `lsunit_pw_day.txt`

**Line 1257** (open):
```fortran
open (2174,file="lsunit_pw_day.csv",recl = 1500)
```
String literal: `lsunit_pw_day.csv`

**Line 1267** (open):
```fortran
open (2171,file="lsunit_pw_mon.txt",recl = 1500)
```
String literal: `lsunit_pw_mon.txt`

**Line 1273** (open):
```fortran
open (2175,file="lsunit_pw_mon.csv",recl = 1500)
```
String literal: `lsunit_pw_mon.csv`

**Line 1282** (open):
```fortran
open (2172,file="lsunit_pw_yr.txt",recl = 1500)
```
String literal: `lsunit_pw_yr.txt`

**Line 1288** (open):
```fortran
open (2176,file="lsunit_pw_yr.csv",recl = 1500)
```
String literal: `lsunit_pw_yr.csv`

**Line 1297** (open):
```fortran
open (2173,file="lsunit_pw_aa.txt",recl = 1500)
```
String literal: `lsunit_pw_aa.txt`

**Line 1303** (open):
```fortran
open (2177,file="lsunit_pw_aa.csv",recl = 1500)
```
String literal: `lsunit_pw_aa.csv`

**Line 1314** (open):
```fortran
open (2050,file="basin_wb_day.txt",recl = 1500)
```
String literal: `basin_wb_day.txt`

**Line 1320** (open):
```fortran
open (2054,file="basin_wb_day.csv",recl = 1500)
```
String literal: `basin_wb_day.csv`

**Line 1329** (open):
```fortran
open (2051,file="basin_wb_mon.txt",recl = 1500)
```
String literal: `basin_wb_mon.txt`

**Line 1335** (open):
```fortran
open (2055,file="basin_wb_mon.csv",recl = 1500)
```
String literal: `basin_wb_mon.csv`

**Line 1344** (open):
```fortran
open (2052,file="basin_wb_yr.txt",recl = 1500)
```
String literal: `basin_wb_yr.txt`

**Line 1350** (open):
```fortran
open (2056,file="basin_wb_yr.csv",recl = 1500)
```
String literal: `basin_wb_yr.csv`

**Line 1359** (open):
```fortran
open (2053,file="basin_wb_aa.txt",recl = 1500)
```
String literal: `basin_wb_aa.txt`

**Line 1365** (open):
```fortran
open (2057,file="basin_wb_aa.csv",recl = 1500)
```
String literal: `basin_wb_aa.csv`

**Line 1375** (open):
```fortran
open (2060,file="basin_nb_day.txt", recl = 1500)
```
String literal: `basin_nb_day.txt`

**Line 1381** (open):
```fortran
open (2064,file="basin_nb_day.csv", recl = 1500)
```
String literal: `basin_nb_day.csv`

**Line 1390** (open):
```fortran
open (2061,file="basin_nb_mon.txt", recl = 1500)
```
String literal: `basin_nb_mon.txt`

**Line 1396** (open):
```fortran
open (2065,file="basin_nb_mon.csv", recl = 1500)
```
String literal: `basin_nb_mon.csv`

**Line 1405** (open):
```fortran
open (2062,file="basin_nb_yr.txt", recl = 1500)
```
String literal: `basin_nb_yr.txt`

**Line 1411** (open):
```fortran
open (2066,file="basin_nb_yr.csv", recl = 1500)
```
String literal: `basin_nb_yr.csv`

**Line 1420** (open):
```fortran
open (2063,file="basin_nb_aa.txt", recl = 1500)
```
String literal: `basin_nb_aa.txt`

**Line 1426** (open):
```fortran
open (2067,file="basin_nb_aa.csv", recl = 1500)
```
String literal: `basin_nb_aa.csv`

**Line 1436** (open):
```fortran
open (2070,file="basin_ls_day.txt", recl = 1500)
```
String literal: `basin_ls_day.txt`

**Line 1442** (open):
```fortran
open (2074,file="basin_ls_day.csv", recl = 1500)
```
String literal: `basin_ls_day.csv`

**Line 1451** (open):
```fortran
open (2071,file="basin_ls_mon.txt",recl = 1500)
```
String literal: `basin_ls_mon.txt`

**Line 1457** (open):
```fortran
open (2075,file="basin_ls_mon.csv",recl = 1500)
```
String literal: `basin_ls_mon.csv`

**Line 1466** (open):
```fortran
open (2072,file="basin_ls_yr.txt", recl = 1500)
```
String literal: `basin_ls_yr.txt`

**Line 1472** (open):
```fortran
open (2076,file="basin_ls_yr.csv", recl = 1500)
```
String literal: `basin_ls_yr.csv`

**Line 1481** (open):
```fortran
open (2073,file="basin_ls_aa.txt",recl = 1500)
```
String literal: `basin_ls_aa.txt`

**Line 1487** (open):
```fortran
open (2077,file="basin_ls_aa.csv",recl = 1500)
```
String literal: `basin_ls_aa.csv`

**Line 1497** (open):
```fortran
open (2080,file="basin_pw_day.txt", recl = 1500)
```
String literal: `basin_pw_day.txt`

**Line 1503** (open):
```fortran
open (2084,file="basin_pw_day.csv", recl = 1500)
```
String literal: `basin_pw_day.csv`

**Line 1512** (open):
```fortran
open (2081,file="basin_pw_mon.txt",recl = 1500)
```
String literal: `basin_pw_mon.txt`

**Line 1518** (open):
```fortran
open (2085,file="basin_pw_mon.csv",recl = 1500)
```
String literal: `basin_pw_mon.csv`

**Line 1527** (open):
```fortran
open (2082,file="basin_pw_yr.txt", recl = 1500)
```
String literal: `basin_pw_yr.txt`

**Line 1533** (open):
```fortran
open (2086,file="basin_pw_yr.csv", recl = 1500)
```
String literal: `basin_pw_yr.csv`

**Line 1542** (open):
```fortran
open (2083,file="basin_pw_aa.txt",recl = 1500)
```
String literal: `basin_pw_aa.txt`

**Line 1548** (open):
```fortran
open (2087,file="basin_pw_aa.csv",recl = 1500)
```
String literal: `basin_pw_aa.csv`

**Line 1559** (open):
```fortran
open (4010,file="crop_yld_yr.txt", recl = 1500)
```
String literal: `crop_yld_yr.txt`

**Line 1564** (open):
```fortran
open (4011,file="crop_yld_yr.csv")
```
String literal: `crop_yld_yr.csv`

**Line 1573** (open):
```fortran
open (4008,file="crop_yld_aa.txt", recl = 1500)
```
String literal: `crop_yld_aa.txt`

**Line 1578** (open):
```fortran
open (4009,file="crop_yld_aa.csv")
```
String literal: `crop_yld_aa.csv`

### pest_metabolite_read.f90

**Line 26** (inquire):
```fortran
inquire (file="pest_metabolite.pes", exist=i_exist)
```
String literal: `pest_metabolite.pes`

**Line 29** (open):
```fortran
open (106,file="pest_metabolite.pes")
```
String literal: `pest_metabolite.pes`

### pl_write_parms_cal.f90

**Line 20** (open):
```fortran
open (107,file="plant_parms.cal",recl = 1500)
```
String literal: `plant_parms.cal`

### plant_transplant_read.f90

**Line 19** (inquire):
```fortran
inquire (file="transplant.plt", exist=i_exist)
```
String literal: `transplant.plt`

**Line 24** (open):
```fortran
open (104,file="transplant.plt")
```
String literal: `transplant.plt`

### proc_bsn.f90

**Line 8** (open):
```fortran
open (9000,file="files_out.out")
```
String literal: `files_out.out`

**Line 11** (open):
```fortran
open (9001,file="diagnostics.out", recl=8000)  !!ext to 8000 recl per email 8/2/21 - Kai-Uwe
```
String literal: `diagnostics.out`

**Line 14** (open):
```fortran
open (9004,file="area_calc.out", recl=8000)
```
String literal: `area_calc.out`

### proc_hru.f90

**Line 46** (open):
```fortran
open (4001,file = "erosion.out",recl=1200)
```
String literal: `erosion.out`

**Line 52** (open):
```fortran
open (4000,file = "checker.out",recl=1200)
```
String literal: `checker.out`

### readcio_read.f90

**Line 16** (inquire):
```fortran
inquire (file="file.cio", exist=i_exist)
```
String literal: `file.cio`

**Line 18** (open):
```fortran
open (107,file="file.cio")
```
String literal: `file.cio`

### recall_read.f90

**Line 202** (inquire):
```fortran
inquire (file="pest.com", exist=i_exist)
```
String literal: `pest.com`

**Line 205** (open):
```fortran
open (107,file="pest.com")
```
String literal: `pest.com`

### recall_read_cs.f90

**Line 44** (inquire):
```fortran
inquire (file="cs_recall.rec", exist=i_exist)
```
String literal: `cs_recall.rec`

**Line 47** (open):
```fortran
open (107,file="cs_recall.rec")
```
String literal: `cs_recall.rec`

### recall_read_salt.f90

**Line 44** (inquire):
```fortran
inquire (file="salt_recall.rec", exist=i_exist)
```
String literal: `salt_recall.rec`

**Line 47** (open):
```fortran
open (107,file="salt_recall.rec")
```
String literal: `salt_recall.rec`

### res_read_conds.f90

**Line 19** (inquire):
```fortran
inquire (file="res_conds.dat", exist=i_exist)
```
String literal: `res_conds.dat`

**Line 21** (open):
```fortran
open (100,file="res_conds.dat")
```
String literal: `res_conds.dat`

### res_read_cs.f90

**Line 24** (inquire):
```fortran
inquire (file="cs.res",exist=i_exist)
```
String literal: `cs.res`

**Line 29** (open):
```fortran
open (105,file="cs.res")
```
String literal: `cs.res`

### res_read_csdb.f90

**Line 24** (inquire):
```fortran
inquire (file="cs_res",exist=i_exist)
```
String literal: `cs_res`

**Line 29** (open):
```fortran
open (105,file="cs_res")
```
String literal: `cs_res`

### res_read_salt.f90

**Line 26** (inquire):
```fortran
inquire (file="salt_res",exist=i_exist)
```
String literal: `salt_res`

**Line 31** (open):
```fortran
open (105,file="salt_res")
```
String literal: `salt_res`

### res_read_salt_cs.f90

**Line 27** (inquire):
```fortran
inquire (file="reservoir.res_cs",exist=i_exist)
```
String literal: `reservoir.res_cs`

**Line 31** (open):
```fortran
open(105,file="reservoir.res_cs")
```
String literal: `reservoir.res_cs`

### res_read_saltdb.f90

**Line 26** (inquire):
```fortran
inquire (file="salt_res",exist=i_exist)
```
String literal: `salt_res`

**Line 31** (open):
```fortran
open (105,file="salt_res")
```
String literal: `salt_res`

### rte_read_nut.f90

**Line 24** (inquire):
```fortran
inquire (file="nutrients.rte",exist=i_exist)
```
String literal: `nutrients.rte`

**Line 29** (open):
```fortran
open (105,file="nutrients.rte")
```
String literal: `nutrients.rte`

### salt_aqu_read.f90

**Line 20** (inquire):
```fortran
inquire (file="salt_aqu.ini", exist=i_exist)
```
String literal: `salt_aqu.ini`

**Line 23** (open):
```fortran
open (107,file="salt_aqu.ini")
```
String literal: `salt_aqu.ini`

### salt_cha_read.f90

**Line 24** (inquire):
```fortran
inquire (file="salt_channel.ini", exist=i_exist)
```
String literal: `salt_channel.ini`

**Line 27** (open):
```fortran
open (107,file="salt_channel.ini")
```
String literal: `salt_channel.ini`

### salt_fert_read.f90

**Line 24** (inquire):
```fortran
inquire (file="salt_fertilizer.frt", exist=i_exist)
```
String literal: `salt_fertilizer.frt`

**Line 26** (open):
```fortran
open (107,file="salt_fertilizer.frt")
```
String literal: `salt_fertilizer.frt`

### salt_hru_read.f90

**Line 20** (inquire):
```fortran
inquire (file='salt_hru.ini', exist=i_exist)
```
String literal: `salt_hru.ini`

**Line 23** (open):
```fortran
open (107,file='salt_hru.ini')
```
String literal: `salt_hru.ini`

### salt_irr_read.f90

**Line 20** (inquire):
```fortran
inquire (file="salt_irrigation", exist=i_exist)
```
String literal: `salt_irrigation`

**Line 23** (open):
```fortran
open (107,file="salt_irrigation")
```
String literal: `salt_irrigation`

### salt_plant_read.f90

**Line 19** (inquire):
```fortran
inquire (file="salt_plants", exist=i_exist)
```
String literal: `salt_plants`

**Line 23** (open):
```fortran
open(107,file="salt_plants")
```
String literal: `salt_plants`

### salt_roadsalt_read.f90

**Line 44** (inquire):
```fortran
inquire (file='salt_road',exist=i_exist)
```
String literal: `salt_road`

**Line 48** (open):
```fortran
open(5051,file='salt_road')
```
String literal: `salt_road`

### salt_uptake_read.f90

**Line 32** (inquire):
```fortran
inquire (file='salt_uptake',exist=i_exist)
```
String literal: `salt_uptake`

**Line 39** (open):
```fortran
open(5054,file='salt_uptake')
```
String literal: `salt_uptake`

### salt_urban_read.f90

**Line 24** (inquire):
```fortran
inquire (file='salt_urban',exist=i_exist)
```
String literal: `salt_urban`

**Line 28** (open):
```fortran
open(5054,file='salt_urban')
```
String literal: `salt_urban`

### sat_buff_read.f90

**Line 26** (inquire):
```fortran
inquire (file="satbuffer.str", exist=i_exist)
```
String literal: `satbuffer.str`

**Line 30** (open):
```fortran
open (107,file="satbuffer.str")
```
String literal: `satbuffer.str`

### sd_hydsed_read.f90

**Line 69** (inquire):
```fortran
inquire (file="sed_nut.cha", exist=i_exist)
```
String literal: `sed_nut.cha`

**Line 74** (open):
```fortran
open (1,file="sed_nut.cha")
```
String literal: `sed_nut.cha`

### soil_plant_init_cs.f90

**Line 19** (inquire):
```fortran
inquire (file="soil_plant.ini_cs", exist=i_exist)
```
String literal: `soil_plant.ini_cs`

**Line 21** (open):
```fortran
open (107,file="soil_plant.ini_cs")
```
String literal: `soil_plant.ini_cs`

### soils_init.f90

**Line 73** (inquire):
```fortran
inquire (file="soil_lyr_depths.sol",exist=i_exist)
```
String literal: `soil_lyr_depths.sol`

**Line 170** (open):
```fortran
open (107,file="soil_lyr_depths.sol")
```
String literal: `soil_lyr_depths.sol`

### swift_output.f90

**Line 52** (inquire):
```fortran
inquire (file="SWIFT/file_cio.swf", exist=i_exist)
```
String literal: `SWIFT/file_cio.swf`

**Line 60** (open):
```fortran
open (107,file="SWIFT/file_cio.swf",recl = 1500)
```
String literal: `SWIFT/file_cio.swf`

**Line 89** (open):
```fortran
open (107,file="SWIFT/precip.swf",recl = 1500)
```
String literal: `SWIFT/precip.swf`

**Line 102** (open):
```fortran
open (107,file="SWIFT/hru_dat.swf",recl = 1500)
```
String literal: `SWIFT/hru_dat.swf`

**Line 114** (open):
```fortran
open (107,file="SWIFT/hru_exco.swf",recl = 1500)
```
String literal: `SWIFT/hru_exco.swf`

**Line 152** (open):
```fortran
open (107,file="SWIFT/hru_wet.swf",recl = 1500)
```
String literal: `SWIFT/hru_wet.swf`

**Line 172** (open):
```fortran
open (107,file="SWIFT/chan_dat.swf",recl = 1500)
```
String literal: `SWIFT/chan_dat.swf`

**Line 184** (open):
```fortran
open (107,file="SWIFT/chan_dr.swf",recl = 1500)
```
String literal: `SWIFT/chan_dr.swf`

**Line 204** (open):
```fortran
open (107,file="SWIFT/aqu_dr.swf",recl = 1500)
```
String literal: `SWIFT/aqu_dr.swf`

**Line 218** (open):
```fortran
open (107,file="SWIFT/res_dat.swf",recl = 1500)
```
String literal: `SWIFT/res_dat.swf`

**Line 230** (open):
```fortran
open (107,file="SWIFT/res_dr.swf",recl = 1500)
```
String literal: `SWIFT/res_dr.swf`

**Line 244** (open):
```fortran
open (107,file="SWIFT/recall.swf",recl = 1500)
```
String literal: `SWIFT/recall.swf`

**Line 250** (open):
```fortran
open (108,file="SWIFT/" // trim(adjustl(recall(irec)%name)),recl = 1500)
```
String literal: `SWIFT/`

**Line 265** (open):
```fortran
open (108,file="SWIFT/object_prt.swf",recl = 1500)
```
String literal: `SWIFT/object_prt.swf`

### treat_read_om.f90

**Line 24** (inquire):
```fortran
inquire (file="treatment.trt", exist=i_exist)
```
String literal: `treatment.trt`

**Line 27** (open):
```fortran
open (107,file="treatment.trt")
```
String literal: `treatment.trt`

### wet_read_hyd.f90

**Line 69** (inquire):
```fortran
inquire(file='gwflow.wetland',exist=i_exist)
```
String literal: `gwflow.wetland`

**Line 72** (open):
```fortran
open(in_wet_cell,file='gwflow.wetland')
```
String literal: `gwflow.wetland`

### wet_read_salt_cs.f90

**Line 27** (inquire):
```fortran
inquire (file="wetland.wet_cs",exist=i_exist)
```
String literal: `wetland.wet_cs`

**Line 31** (open):
```fortran
open(105,file="wetland.wet_cs")
```
String literal: `wetland.wet_cs`

## Recommendations

1. **Replace hardcoded filenames with variables** - Use configurable filename variables instead of string literals
2. **Centralize filename management** - Consider a filename configuration module
3. **Use meaningful variable names** - Make file paths configurable through parameters
4. **Standardize file I/O patterns** - Establish consistent patterns for file operations

## Example Refactoring

**Before (using string literal):**
```fortran
open(unit=10, file="output.txt", status="replace")
```

**After (using variable):**
```fortran
character(len=255) :: output_filename
output_filename = "output.txt"  ! or read from config
open(unit=10, file=output_filename, status="replace")
```
