!!@summary Execute management actions based on decision table outcomes for various agricultural operations
!!@description This subroutine processes management actions triggered by decision table conditions. It handles
!! multiple types of agricultural operations including fertilizer application, pesticide application, tillage,
!! irrigation, harvesting, grazing, plant operations, burning, landuse changes, and various other farm management
!! activities. The subroutine iterates through all actions in the decision table and executes those that have
!! been triggered by their corresponding conditions.
!!@arguments
!! - ob_cur: Sequential number of the current individual object being processed
!! - ob_num: Sequential number for all objects in the simulation
!! - idtbl: Decision table identifier for the current object
      subroutine actions (ob_cur, ob_num, idtbl)
      use conditional_module
      use climate_module
      use time_module
      use aquifer_module
      use hru_module, only : hru, cn2, fertno3, fertnh3, fertorgn, fertorgp, fertsolp,   &
        ihru, ipl, isol,  phubase, sol_sumno3, sol_sumsolp, qtile
      use soil_module
      use plant_module
      use plant_data_module
      use mgt_operations_module  
      use landuse_data_module
      use tillage_data_module
      use reservoir_module
      use sd_channel_module
      use septic_data_module
      use hru_lte_module
      use basin_module
      use organic_mineral_mass_module
      use hydrograph_module
      use output_landscape_module
      use conditional_module
      use constituent_mass_module
      use calibration_data_module
      use fertilizer_data_module
      use maximum_data_module
      use tiles_data_module
      use water_body_module
      use reservoir_data_module
      use manure_allocation_module
      use water_allocation_module

      implicit none

      integer, intent (in)  :: ob_cur      !!none | sequential number of individual objects
      integer, intent (in)  :: ob_num      !!none | sequential number for all objects  
      integer, intent (in)  :: idtbl       !!none | decision table identifier
      integer :: icom = 0                  !!none | community counter
      integer :: iac = 0                   !!none | action counter
      integer :: ial = 0                   !!none | alternative counter
      integer :: iburn = 0                 !!none | burn type from fire data base
      integer :: idtill = 0                !!none | tillage type
      integer :: ifertop = 0               !!none | surface application fraction from chem app data base
      integer :: ifrt = 0                  !!none | fertilizer type from fert data base
      integer :: ipestop = 0               !!none | surface application fraction from chem app data base
      integer :: ipst = 0                  !!none | pesticide type from pest data base
      integer :: iharvop = 0               !!none | harvest operation type
      integer :: iihru = 0                 !!none | HRU index
      integer :: ilu = 0                   !!none | landuse type 
      integer :: j = 0                     !!none | object counter
      integer :: iob = 0                   !!none | object index
      integer :: idp = 0                   !!none | drainage parameter index
      integer :: istr = 0                  !!none | structure index
      integer :: istr1 = 0                 !!none | structure index 1
      integer :: iob_out = 0               !!none | output object index
      integer :: inhyd = 0                 !!none | inflow hydrograph index
      integer :: ihyd_in = 0               !!none | input hydrograph index
      integer :: icon = 0                  !!none | connection index
      integer :: iplt_bsn = 0              !!none | basin plant index
      integer :: irrop = 0                 !!none | irrigation operation index
      integer :: igr = 0                   !!none | grazing index
      integer :: ireg = 0                  !!none | region index
      integer :: ilum = 0                  !!none | landuse management index
      integer :: isrc = 0                  !!none | source index
      integer :: isched = 0                !!none | schedule index
      integer :: ipud = 0                  !!none | puddle index
      integer :: ipdl = 0                  !!none | puddle layer index
      integer :: ires = 0                  !!none | reservoir index
      integer :: idb = 0                   !!none | database index
      integer :: imallo = 0                !!none | manure allocation index
      integer :: idmd = 0                  !!none | demand index
      integer :: irec = 0                  !!none | record index
      integer :: iplt = 0                  !!none | plant index
      integer :: num_plts_cur = 0          !!none | current number of plants
      integer :: hru_rcv                   !!none | receiving HRU index
      real :: hiad1 = 0.                   !!none | harvest index
      real :: biomass = 0.                 !!kg/ha | plant biomass
      real :: frt_kg = 0.                  !!kg/ha | fertilizer amount
      real :: harveff = 0.                 !!fraction | harvest efficiency
      real :: wur = 0.                     !!none | water use ratio
      real :: frac = 0.                    !!fraction | fraction value
      real :: rto = 0.                     !!fraction | ratio value
      real :: rto1 = 0.                    !!fraction | ratio value 1
      real :: pest_kg = 0.                 !!kg/ha | amount of pesticide applied 
      real :: chg_par                      !!variable | new parameter value
      real :: yield = 0.                   !!t/ha | crop yield
      real :: sumpst = 0.                  !!kg/ha | sum of pesticides
      real :: rock = 0.                    !!fraction | rock content
      real :: p_factor = 0.                !!none | phosphorus factor
      real :: cn_prev = 0.                 !!none | previous curve number
      real :: stor_m3 = 0.                 !!m3 | storage volume
      character(len=1) :: action = ""      !!none | action flag
      character(len=40) :: lu_prev = ""    !!none | previous landuse name

      !! Loop through all actions in the decision table
      do iac = 1, d_tbl%acts
        action = "n"
        !! Check if any alternative condition triggers this action
        do ial = 1, d_tbl%alts
          if (d_tbl%act_hit(ial) == "y" .and. d_tbl%act_outcomes(iac,ial) == "y") then
            action = "y"
            exit
          end if
        end do
      
        !! Execute action if triggered by decision table conditions
        if (action == "y") then
          !! Select appropriate management action based on action type
          select case (d_tbl%act(iac)%typ)
          
          !! Process manure demand for manure allocation system
          case ("manure_demand")
            j = ob_cur
            idmd = ob_num
            imallo = 1      !if mallo objects > 1, need to input
            
            !! Set manure allocation parameters based on decision table values
            mallo(imallo)%dmd(idmd)%manure_amt = manure_amtz
            if (pcom(j)%dtbl(idtbl)%num_actions(iac) <= Int(d_tbl%act(iac)%const2)) then
              mallo(imallo)%dmd(idmd)%manure_amt%mallo_obj = 1                      !assume 1 manure allocation object - could use file_pointer to xwalk
              mallo(imallo)%dmd(idmd)%manure_amt%src_obj = d_tbl%act(iac)%ob_num    !amount applied - t/ha
              mallo(imallo)%dmd(idmd)%manure_amt%app_t_ha = d_tbl%act(iac)%const    !manure source object number
              mallo(imallo)%dmd(idmd)%manure_amt%app_method = d_tbl%act_app(iac)    !manure application method
            end if

          !! Process irrigation demand from HRU for water allocation
          case ("irr_demand")
            ipl = 1
            j = d_tbl%act(iac)%ob_num
            if (j == 0) j = ob_cur
            
            !! Handle special case for paddy/wetland ponding depth irrigation
            if (d_tbl%act(iac)%name=='ponding') then !irrigation demand calculated by paddy/wetland ponding depth requirements Jaehak 2023
              hru(j)%irr_hmax = d_tbl%act(iac)%const !mm target ponding depth
              hru(j)%irr_hmin = d_tbl%act(iac)%const2 !mm threshold ponding depth for irrigation
              
              !! Add any irrigation that already occurred today to current depth
              wet_ob(j)%depth = wet_ob(j)%depth + irrig(j)%applied / 1000. !mm irrigation by wro already happend for today Jaehak 2023

              !! Calculate irrigation demand based on current ponding depth vs threshold
              if (wet_ob(j)%depth*1000.<hru(j)%irr_hmin) then
                irrig(j)%demand = max(0.,d_tbl%act(iac)%const-wet_ob(j)%depth*1000.) * hru(j)%area_ha * 10.       ! m3 = mm * ha * 10.
              else
                irrig(j)%demand = 0.
              endif
            else
              !! Handle regular irrigation demand (non-ponding systems)
              if (pcom(j)%dtbl(idtbl)%num_actions(iac) <= Int(d_tbl%act(iac)%const2)) then
                irrop = d_tbl%act_typ(iac)      ! irrigation application type in irr.ops
                irrig(j)%demand = d_tbl%act(iac)%const * hru(j)%area_ha * 10.       ! m3 = mm * ha * 10.
            
            !! Check for unlimited irrigation source and apply directly to HRU
            if (d_tbl%act(iac)%file_pointer == "unlim") then
              irrig(j)%applied = irrop_db(irrop)%amt_mm * irrop_db(irrop)%eff * (1. - irrop_db(irrop)%surq)
              irrig(j)%runoff = irrop_db(irrop)%amt_mm * irrop_db(irrop)%eff * irrop_db(irrop)%surq
            end if  
              
                !! Set organics and constituents from irrigation operation parameters
                if (pco%mgtout == "y") then
                  write (2612, *) j, time%yrc, time%mo, time%day_mo, d_tbl%act(iac)%name, "IRRIGATE", phubase(j),  &
                      pcom(j)%plcur(ipl)%phuacc, soil(j)%sw,pl_mass(j)%tot(ipl)%m, soil1(j)%rsd(1)%m, &
                      sol_sumno3(j), sol_sumsolp(j), irrig(j)%applied
                end if
              else
                !! Set demand for irrigation from external water sources (channel, reservoir or aquifer)
                if (pco%mgtout == "y") then
                  write (2612, *) j, time%yrc, time%mo, time%day_mo, d_tbl%act(iac)%name, "IRRIG_DMD", phubase(j), &
                      pcom(j)%plcur(ipl)%phuacc, soil(j)%sw,pl_mass(j)%tot(ipl)%m, soil1(j)%rsd(1)%m, &
                      sol_sumno3(j), sol_sumsolp(j), irrop_db(irrop)%amt_mm
                end if
              end if
            endif

          !! Apply irrigation water directly to HRU
          case ("irrigate")
            ipl = 1
            j = ob_cur                      ! hru number 
            
            !! Check maximum number of applications per year constraint
            if (pcom(j)%dtbl(idtbl)%num_actions(iac) <= Int(d_tbl%act(iac)%const2)) then
            isrc = d_tbl%act(iac)%ob_num    ! source object type number
            irrop = d_tbl%act_typ(iac)      ! irrigation application type in irr.ops

            !! Handle special case for paddy irrigation with ponding depth control
            if (d_tbl%act(iac)%name=='ponding') then !paddy irrigation
              hru(j)%irr_hmax = d_tbl%act(iac)%const !mm
              hru(j)%irr_hmin = d_tbl%act(iac)%const2 !mm
              !! Calculate irrigation amounts for paddy ponding based on current depth
              irrig(j)%applied = max(0.,d_tbl%act(iac)%const-wet_ob(j)%depth*1000.) * irrop_db(irrop)%eff * &
                        (1. - irrop_db(irrop)%surq) !mm
              irrig(j)%runoff = max(0.,d_tbl%act(iac)%const-wet_ob(j)%depth*1000.) * irrop_db(irrop)%surq   !mm
              irrig(j)%demand = max(0.,d_tbl%act(iac)%const-wet_ob(j)%depth*1000.) * hru(j)%area_ha * 10.       ! m3 = mm * ha * 10.
            else
              !! Calculate irrigation amounts for regular (non-paddy) systems
              irrig(j)%applied = d_tbl%act(iac)%const * irrop_db(irrop)%eff * (1. - irrop_db(irrop)%surq)
              irrig(j)%runoff = d_tbl%act(iac)%const * irrop_db(irrop)%surq
              irrig(j)%demand = d_tbl%act(iac)%const * hru(j)%area_ha * 10.       ! m3 = mm * ha * 10.
            end if

            !! Determine water source object type and extract water accordingly
            iob = d_tbl%act(iac)%ob_num
            select case (d_tbl%act(iac)%ob)
            case ("aqu")
              !! Extract irrigation water from aquifer
              stor_m3 = aqu_d(iob)%stor * aqu_prm(iob)%area_ha * 10.
              if (stor_m3 > irrig(j)%demand) then
                rto = irrig(j)%demand / stor_m3                 ! ratio of water removed from aquifer volume (m3)
              else
                !! If insufficient water in aquifer, set irrigation to zero
                rto = 0.
                irrig(j)%applied = 0.
                irrig(j)%runoff = 0.
                irrig(j)%demand = 0.
              end if
              !! Apply constraints and calculate water/constituent transfers
              rto = amax1 (0., rto)
              rto = amin1 (1., rto)
              rto1 = (1. - rto)
              irrig(j)%water%flo = rto * aqu_d(iob)%stor                ! organics in irrigation water
              aqu_d(iob)%stor = rto1 * aqu_d(iob)%stor                  ! remainder stays in aquifer
              cs_irr(iob) = rto * cs_aqu(iob)                           ! constituents in irrigation water
              cs_aqu(iob) = rto1 * cs_aqu(iob)                          ! remainder stays in aquifer
              
            case ("cha", "sdc")
              !! Extract irrigation water from channel
              if (ch_stor(iob)%flo > irrig(j)%demand) then
                rto = irrig(j)%demand / ch_stor(iob)%flo                ! ratio of water removed from channel volume
              else
                !! If insufficient water in channel, set irrigation to zero
                rto = 0.
                irrig(j)%applied = 0.
                irrig(j)%runoff = 0.
                irrig(j)%demand = 0.
              end if
              !! Apply constraints and calculate water/constituent transfers
              rto = amax1 (0., rto)
              rto = amin1 (1., rto)
              rto1 = (1. - rto)
              irrig(j)%water = rto * ch_stor(iob)                       ! organics in irrigation water
              ch_stor(iob) = rto1 * ch_stor(iob)                        ! remainder stays in channel
              cs_irr(iob) = rto * ch_water(iob)                         ! constituents in irrigation water
              ch_water(iob) = rto1 * ch_water(iob)                      ! remainder stays in channel
              
            case ("res")
              !! Extract irrigation water from reservoir
              if (res(iob)%flo > irrig(j)%demand) then
                rto = irrig(j)%demand / res(iob)%flo                    ! ratio of water removed from res volume
              else
                !! If insufficient water in reservoir, set irrigation to zero
                rto = 0.
                irrig(j)%applied = 0.
                irrig(j)%runoff = 0.
                irrig(j)%demand = 0.
              end if
              !! Apply constraints and calculate water/constituent transfers
              rto = amax1 (0., rto)
              rto = amin1 (1., rto)
              rto1 = (1. - rto)
              irrig(j)%water = rto * res(iob)                           ! organics in irrigation water
              res(iob) = rto1 * res(iob)                                ! remainder stays in reservoir
              !cs_irr(iob) = rto * res_water(iob)                        ! constituents in irrigation water
              !res_water(iob) = rto1 * res_water(iob)                    ! remainder stays in reservoir
              
            end select
                  
            !! Update irrigation tracking variables and output management information
            ! add irrigation to yearly sum for dtbl conditioning jga 6-25
            hru(j)%irr_yr = hru(j)%irr_yr + irrig(j)%applied
            
            !! Write management output if enabled
            if (pco%mgtout == "y") then
              write (2612, *) j, time%yrc, time%mo, time%day_mo, d_tbl%act(iac)%name, "IRRIGATE", phubase(j),  &
                  pcom(j)%plcur(ipl)%phuacc, soil(j)%sw, pl_mass(j)%tot(ipl)%m, soil1(j)%rsd(1)%m, &
                  sol_sumno3(j), sol_sumsolp(j), irrig(j)%demand
            end if
            
              !! Update action counters and reset day tracking variables
              pcom(j)%dtbl(idtbl)%num_actions(iac) = pcom(j)%dtbl(idtbl)%num_actions(iac) + 1
              pcom(j)%dtbl(idtbl)%days_act(iac) = 1                     !reset days since last action
              pcom(j)%days_irr = 1                                      ! reset days since last irrigation
              if (iac > 1) pcom(j)%dtbl(idtbl)%days_act(iac-1) =  0     !reset previous action day counter
            end if      ! const2 - number per year check

          !! Apply fertilizer to HRU
          case ("fertilize")
            j = d_tbl%act(iac)%ob_num
            if (j == 0) j = ob_cur
            
            !! Check maximum number of fertilizer applications per year
            if (pcom(j)%dtbl(idtbl)%num_actions(iac) <= Int(d_tbl%act(iac)%const2)) then
              ipl = 1
              ifrt = d_tbl%act_typ(iac)               !fertilizer type from fert data base
              frt_kg = d_tbl%act(iac)%const           !amount applied in kg/ha
              ifertop = d_tbl%act_app(iac)            !surface application fraction from chem app data base

              !! Check for wetland conditions and apply appropriate fertilizer method
              if (wet(j)%flo > 0. .and. chemapp_db(ifertop)%surf_frac == 1) then
                !! Apply fertilizer to wetland system
                call pl_fert_wet (ifrt, frt_kg)
                if (pco%mgtout == "y") then
                  write (2612,*) j, time%yrc, time%mo, time%day_mo, mgt%op_char, " FERT-WET", &
                    phubase(j), pcom(j)%plcur(ipl)%phuacc, soil(j)%sw, pl_mass(j)%tot(ipl)%m,           &
                    soil1(j)%rsd(1)%m, sol_sumno3(j), sol_sumsolp(j), frt_kg, fertno3, fertnh3,         &
                    fertorgn, fertsolp, fertorgp
                endif
              else
                !! Apply fertilizer to regular soil/plant system
                call pl_fert (ifrt, frt_kg, ifertop)
                if (pco%mgtout == "y") then
                  write (2612,*) j, time%yrc, time%mo, time%day_mo, mgt%op_char, "    FERT ", &
                    phubase(j), pcom(j)%plcur(ipl)%phuacc, soil(j)%sw, pl_mass(j)%tot(ipl)%m,           &
                    soil1(j)%rsd(1)%m, sol_sumno3(j), sol_sumsolp(j), frt_kg, fertno3, fertnh3,         &
                    fertorgn, fertsolp, fertorgp
                endif
              endif
              !! Update action tracking counters
              pcom(j)%dtbl(idtbl)%num_actions(iac) = pcom(j)%dtbl(idtbl)%num_actions(iac) + 1
              pcom(j)%dtbl(idtbl)%days_act(iac) = 1     !reset days since last action
              if (iac > 1) pcom(j)%dtbl(idtbl)%days_act(iac-1) =  0     !reset previous action day counter
            end if

          !! Apply manure to HRU
          case ("manure")
            j = d_tbl%act(iac)%ob_num
            if (j == 0) j = ob_cur
            
            !! Check maximum number of manure applications per year
            if (pcom(j)%dtbl(idtbl)%num_actions(iac) <= Int(d_tbl%act(iac)%const2)) then
              ipl = 1
              ifrt = d_tbl%act_typ(iac)               !fertilizer type from fert data base
              frt_kg = d_tbl%act(iac)%const           !amount applied in kg/ha
              ifertop = d_tbl%act_app(iac)            !surface application fraction from chem app data base

              !! Apply manure and track salt/constituent impacts
              call pl_manure (ifrt, frt_kg, ifertop)
              call salt_fert(j,ifrt,frt_kg,ifertop) !rtb salt 
              call cs_fert(j,ifrt,frt_kg,ifertop) !rtb cs
              if (pco%mgtout == "y") then
                write (2612,*) j, time%yrc, time%mo, time%day_mo, mgt%op_char, " MANURE ", &
                  phubase(j), pcom(j)%plcur(ipl)%phuacc, soil(j)%sw, pl_mass(j)%tot(ipl)%m,           &
                  soil1(j)%rsd(1)%m, sol_sumno3(j), sol_sumsolp(j), frt_kg, fertno3, fertnh3,         &
                  fertorgn, fertsolp, fertorgp
              endif
              !! Update action tracking counters
              pcom(j)%dtbl(idtbl)%num_actions(iac) = pcom(j)%dtbl(idtbl)%num_actions(iac) + 1
              pcom(j)%dtbl(idtbl)%days_act(iac) = 1     !reset days since last action
              if (iac > 1) pcom(j)%dtbl(idtbl)%days_act(iac-1) =  0     !reset previous action day counter
            end if

          !! Schedule future fertilizer application
          case ("fert_future")
            j = ob_cur
            ifrt = d_tbl%act(iac)%ob_num
            !! Set future fertilizer application day
            pcom(j)%fert_fut(ifrt)%day_fert = Int (d_tbl%act(iac)%const2)
              
          !! Perform tillage operation on HRU
          case ("till")
            j = d_tbl%act(iac)%ob_num
            if (j == 0) j = ob_cur
            
            !! Check maximum number of tillage operations per year
            if (pcom(j)%dtbl(idtbl)%num_actions(iac) <= Int(d_tbl%act(iac)%const2)) then
              idtill = d_tbl%act_typ(iac)
              ipl = 1
              !! Perform tillage mixing operation
              call mgt_newtillmix(j, 0., idtill)
            
              !! Write management output if enabled  
              if (pco%mgtout == "y") then
                write (2612, *) j, time%yrc, time%mo, time%day_mo, tilldb(idtill)%tillnm, "    TILLAGE",    &
                    phubase(j), pcom(j)%plcur(ipl)%phuacc, soil(j)%sw, pl_mass(j)%tot(ipl)%m,        &
                    soil1(j)%rsd(1)%m, sol_sumno3(j), sol_sumsolp(j), tilldb(idtill)%effmix
              end if
              !! Update action tracking counters
              pcom(j)%dtbl(idtbl)%num_actions(iac) = pcom(j)%dtbl(idtbl)%num_actions(iac) + 1
              pcom(j)%dtbl(idtbl)%days_act(iac) = 1     !reset days since this action
              if (iac > 1) pcom(j)%dtbl(idtbl)%days_act(iac-1) =  0     !reset previous action day counter
            end if

          !! Plant crop on HRU
          case ("plant")
            j = d_tbl%act(iac)%ob_num
            if (j == 0) j = ob_cur
            
            !! Check maximum number of planting operations per year
            if (pcom(j)%dtbl(idtbl)%num_actions(iac) <= Int(d_tbl%act(iac)%const2)) then
                
            icom = pcom(j)%pcomdb
            pcom(j)%days_plant = 1       !reset days since last planting
            !! Check for generic plant-harvest rotations and set appropriate crops
            isched = hru(j)%mgt_ops
            if (sched(isched)%auto_name(idtbl) == "pl_hv_summer1" .or.      &
                sched(isched)%auto_name(idtbl) == "pl_hv_winter1") then
              d_tbl%act(iac)%option = sched(isched)%auto_crop(1)
            end if
            if (sched(isched)%auto_name(idtbl) == "pl_hv_summer2") then
              d_tbl%act(iac)%option = sched(isched)%auto_crop(pcom(j)%rot_yr)
            end if
            
              !! Loop through all plants in the community to find matching crop
              do ipl = 1, pcom(j)%npl
                
                idp = pcomdb(icom)%pl(ipl)%db_num
                if (d_tbl%act(iac)%option == pcomdb(icom)%pl(ipl)%cpnm) then
                  !! Check if crop is already growing before planting
                  if (pcom(j)%plcur(ipl)%gro == "n") then
                    !! Plant the crop and initialize growth
                    pcom(j)%plcur(ipl)%gro = "y"
                    pcom(j)%plcur(ipl)%idorm = "n"
                    if (d_tbl%act_app(iac) > 0) then
                      !! Handle transplanting if specified
                      call mgt_transplant (d_tbl%act_app(iac))
                    end if
                    !! Write planting output if management output is enabled
                    if (pco%mgtout == "y") then
                    write (2612, *) j, time%yrc, time%mo, time%day_mo, pldb(idp)%plantnm, "    PLANT",   &
                      phubase(j), pcom(j)%plcur(ipl)%phuacc, soil(ihru)%sw,                     &
                      pl_mass(j)%tot(ipl)%m, soil1(j)%rsd(1)%m, sol_sumno3(j),                  &
                      sol_sumsolp(j), pcom(j)%plg(ipl)%lai, pcom(j)%plcur(ipl)%lai_pot
                    end if
                  else
                    !! Skip planting if crop is already growing and write notification
                    if (pco%mgtout ==  "y") then
                      write (2612, *) j, time%yrc, time%mo, time%day_mo, pldb(idp)%plantnm,         &
                        "    PLANT_ALREADY_GROWING", phubase(j), pcom(j)%plcur(ipl)%phuacc,       &
                        soil(j)%sw, pl_mass(j)%tot(ipl)%m, soil1(j)%rsd(1)%m, sol_sumno3(j),      &
                        sol_sumsolp(j),pcom(j)%plg(ipl)%lai, pcom(j)%plcur(ipl)%lai_pot
                    end if
                  end if
                end if
              end do
              
              !! Update action tracking counters after planting
              pcom(j)%dtbl(idtbl)%num_actions(iac) = pcom(j)%dtbl(idtbl)%num_actions(iac) + 1
              pcom(j)%dtbl(idtbl)%days_act(iac) = 1     !reset days since last action
              if (iac > 1) pcom(j)%dtbl(idtbl)%days_act(iac-1) =  0     !reset previous action day counter
            end if
            
          !! Harvest crop biomass only (no kill)
          case ("harvest")
            j = d_tbl%act(iac)%ob_num
            if (j == 0) j = ob_cur
            
            if (pcom(j)%dtbl(idtbl)%num_actions(iac) <= Int(d_tbl%act(iac)%const2)) then
              iharvop = d_tbl%act_typ(iac)
              icom = pcom(j)%pcomdb
              pcom(j)%days_harv = 1       !reset days since last harvest
              !! check for generic plant-harv and set crops
              isched = hru(j)%mgt_ops
              if (sched(isched)%auto_name(idtbl) == "pl_hv_summer1" .or.      &
                  sched(isched)%auto_name(idtbl) == "pl_hv_winter1") then
                d_tbl%act(iac)%option = sched(isched)%auto_crop(1)
              end if
              if (sched(isched)%auto_name(idtbl) == "pl_hv_summer2") then
                d_tbl%act(iac)%option = sched(isched)%auto_crop(pcom(j)%rot_yr)
              end if
            
              do ipl = 1, pcom(j)%npl
                biomass = pl_mass(j)%tot(ipl)%m
                if (d_tbl%act(iac)%option == pcomdb(icom)%pl(ipl)%cpnm .or. d_tbl%act(iac)%option == "all") then
                  
                !check minimum biomass for harvest
                if (biomass > harvop_db(iharvop)%bm_min) then
                !harvest specific type
                select case (harvop_db(iharvop)%typ)
                case ("biomass")    
                  call mgt_harvbiomass (j, ipl, iharvop)
                case ("grain")
                  call mgt_harvgrain (j, ipl, iharvop)
                case ("residue")
                  harveff = d_tbl%act(iac)%const
                  call mgt_harvresidue (j, harveff)
                case ("tree")
                  call mgt_harvbiomass (j, ipl, iharvop)
                case ("tuber")
                  call mgt_harvtuber (j, ipl, iharvop)
                case ("peanuts")
                  call mgt_harvtuber (j, ipl, iharvop)
                case ("stripper")
                  call mgt_harvbiomass (j, ipl, iharvop)
                case ("picker")
                  call mgt_harvgrain (j, ipl, iharvop)
                end select
                end if

                  !! sum yield and num. of harvest to calc ave yields
                  pl_mass(j)%yield_tot(ipl) = pl_mass(j)%yield_tot(ipl) + pl_yield
                  pl_mass(j)%yield_yr(ipl) = pl_mass(j)%yield_yr(ipl) + pl_yield
                  pcom(j)%plcur(ipl)%harv_num_yr = pcom(j)%plcur(ipl)%harv_num_yr + 1
                  pcom(j)%plcur(ipl)%harv_num_yr = pcom(j)%plcur(ipl)%harv_num_yr + 1
                            
                  !! sum basin crop yields and area harvested
                  iplt_bsn = pcom(j)%plcur(ipl)%bsn_num
                  bsn_crop_yld(iplt_bsn)%area_ha = bsn_crop_yld(iplt_bsn)%area_ha + hru(j)%area_ha
                  bsn_crop_yld(iplt_bsn)%yield = bsn_crop_yld(iplt_bsn)%yield + yield * hru(j)%area_ha / 1000.
                  
                  if (cal_codes%plt == "y") then
                    !! sum regional crop yields for soft calibration
                    ireg = hru(j)%crop_reg
                    do ilum = 1, plcal(ireg)%lum_num
                      if (plcal(ireg)%lum(ilum)%meas%name == mgt%op_char) then
                        plcal(ireg)%lum(ilum)%ha = plcal(ireg)%lum(ilum)%ha + hru(j)%area_ha
                        plcal(ireg)%lum(ilum)%sim%yield = plcal(ireg)%lum(ilum)%sim%yield + pl_yield%m * hru(j)%area_ha / 1000.
                      end if
                    end do
                  end if
            
                  idp = pcom(j)%plcur(ipl)%idplt
                  if (pco%mgtout == "y") then
                    write (2612, *) j, time%yrc, time%mo, time%day_mo,  pldb(idp)%plantnm, "    HARVEST",      &
                        phubase(j), pcom(j)%plcur(ipl)%phuacc, soil(j)%sw, biomass, soil1(j)%rsd(1)%m, &
                        sol_sumno3(j), sol_sumsolp(j), pl_yield%m, pcom(j)%plstr(ipl)%sum_n, &
                        pcom(j)%plstr(ipl)%sum_p, pcom(j)%plstr(ipl)%sum_tmp, pcom(j)%plstr(ipl)%sum_w, &
                        pcom(j)%plstr(ipl)%sum_a
                  end if 
                end if
                !pcom(j)%plcur(ipl)%phuacc = 0.
              end do
              pcom(j)%dtbl(idtbl)%num_actions(iac) = pcom(j)%dtbl(idtbl)%num_actions(iac) + 1
              pcom(j)%dtbl(idtbl)%days_act(iac) = 1     !reset days since last action
              if (iac > 1) pcom(j)%dtbl(idtbl)%days_act(iac-1) =  0     !reset previous action day counter
            end if

          !kill plant
          case ("kill")
            j = d_tbl%act(iac)%ob_num
            if (j == 0) j = ob_cur
            
            if (pcom(j)%dtbl(idtbl)%num_actions(iac) <= Int(d_tbl%act(iac)%const2)) then
              icom = pcom(j)%pcomdb
              pcom(j)%days_kill = 1       !reset days since last kill
              do ipl = 1, pcom(j)%npl
                biomass = pl_mass(j)%tot(ipl)%m
                if (d_tbl%act(iac)%option == pcomdb(icom)%pl(ipl)%cpnm .or. d_tbl%act(iac)%option == "all") then
                  pcom(j)%last_kill = pcomdb(icom)%pl(ipl)%cpnm
                  call mgt_killop (j, ipl)

                  idp = pcom(j)%plcur(ipl)%idplt
                  if (pco%mgtout == "y") then
                    write (2612, *) j, time%yrc, time%mo, time%day_mo,  pldb(idp)%plantnm, "         KILL",     &
                        phubase(j), pcom(j)%plcur(ipl)%phuacc, soil(j)%sw, biomass, soil1(j)%rsd(1)%m,  &
                        sol_sumno3(j), sol_sumsolp(j), yield, pcom(j)%plstr(ipl)%sum_n,                  &
                        pcom(j)%plstr(ipl)%sum_p, pcom(j)%plstr(ipl)%sum_tmp, pcom(j)%plstr(ipl)%sum_w,  &
                        pcom(j)%plstr(ipl)%sum_a
                  end if 
                end if
                pcom(j)%plcur(ipl)%phuacc = 0.
                phubase(j) = 0.
              end do
              pcom(j)%dtbl(idtbl)%num_actions(iac) = pcom(j)%dtbl(idtbl)%num_actions(iac) + 1
              pcom(j)%dtbl(idtbl)%days_act(iac) = 1     !reset days since last action
              if (iac > 1) pcom(j)%dtbl(idtbl)%days_act(iac-1) =  0     !reset previous action day counter
            end if
  
          !harvest and kill
          case ("harvest_kill")
            j = d_tbl%act(iac)%ob_num
            if (j == 0) j = ob_cur
            
            if (pcom(j)%dtbl(idtbl)%num_actions(iac) <= Int(d_tbl%act(iac)%const2)) then
              iharvop = d_tbl%act_typ(iac)
              icom = pcom(j)%pcomdb
              pcom(j)%days_harv = 1       !reset days since last harvest
              !! check for generic plant-harv and set crops
              isched = hru(j)%mgt_ops
              if (sched(isched)%auto_name(idtbl) == "pl_hv_summer1" .or.      &
                  sched(isched)%auto_name(idtbl) == "pl_hv_winter1") then
                d_tbl%act(iac)%option = sched(isched)%auto_crop(1)
              end if
              if (sched(isched)%auto_name(idtbl) == "pl_hv_summer2") then
                d_tbl%act(iac)%option = sched(isched)%auto_crop(pcom(j)%rot_yr)
              end if
              
              do ipl = 1, pcom(j)%npl
                biomass = pl_mass(j)%tot(ipl)%m
                if (d_tbl%act(iac)%option == pcomdb(icom)%pl(ipl)%cpnm .or. d_tbl%act(iac)%option == "all") then
                  
                !check minimum biomass for harvest
                if (biomass > harvop_db(iharvop)%bm_min) then
                !harvest specific type
                select case (harvop_db(iharvop)%typ)
                case ("biomass")    
                  call mgt_harvbiomass (j, ipl, iharvop)
                case ("grain")
                  call mgt_harvgrain (j, ipl, iharvop)
                case ("residue")
                  harveff = d_tbl%act(iac)%const
                  call mgt_harvresidue (j, harveff)
                case ("tree")
                case ("tuber")
                  call mgt_harvtuber (j, ipl, iharvop)
                case ("peanuts")
                  call mgt_harvtuber (j, ipl, iharvop)
                case ("stripper")
                  call mgt_harvgrain (j, ipl, iharvop)
                case ("picker")
                  call mgt_harvgrain (j, ipl, iharvop)
                end select
                end if

                  pcom(j)%last_kill = pcomdb(icom)%pl(ipl)%cpnm
                  call mgt_killop (j, ipl)

                  !! sum yield and number of harvests to calc ave yields
                  pl_mass(j)%yield_tot(ipl) = pl_mass(j)%yield_tot(ipl) + pl_yield
                  pl_mass(j)%yield_yr(ipl) = pl_mass(j)%yield_yr(ipl) + pl_yield
                  pcom(j)%plcur(ipl)%harv_num = pcom(j)%plcur(ipl)%harv_num + 1
                  pcom(j)%plcur(ipl)%harv_num_yr = pcom(j)%plcur(ipl)%harv_num_yr + 1
                            
                  !! sum basin crop yields and area harvested
                  iplt_bsn = pcom(j)%plcur(ipl)%bsn_num
                  bsn_crop_yld(iplt_bsn)%area_ha = bsn_crop_yld(iplt_bsn)%area_ha + hru(j)%area_ha
                  bsn_crop_yld(iplt_bsn)%yield = bsn_crop_yld(iplt_bsn)%yield + pl_yield%m * hru(j)%area_ha / 1000.
                  
                  !! sum regional crop yields for soft calibration
                  if (cal_codes%plt == "y") then
                    ireg = hru(j)%crop_reg
                    do ilum = 1, plcal(ireg)%lum_num
                      if (plcal(ireg)%lum(ilum)%meas%name == d_tbl%act(iac)%option) then
                        plcal(ireg)%lum(ilum)%ha = plcal(ireg)%lum(ilum)%ha + hru(j)%area_ha
                        plcal(ireg)%lum(ilum)%sim%yield = plcal(ireg)%lum(ilum)%sim%yield + pl_yield%m * hru(j)%area_ha / 1000.
                      end if
                    end do
                  end if
            
                  idp = pcom(j)%plcur(ipl)%idplt
                  if (pco%mgtout == "y") then
                    write (2612, *) j, time%yrc, time%mo, time%day_mo,  pldb(idp)%plantnm, "    HARV/KILL",        &
                        phubase(j), pcom(j)%plcur(ipl)%phuacc, soil(j)%sw, biomass, soil1(j)%rsd(1)%m,     &
                        sol_sumno3(j), sol_sumsolp(j), pl_yield%m, pcom(j)%plstr(ipl)%sum_n,   &
                        pcom(j)%plstr(ipl)%sum_p, pcom(j)%plstr(ipl)%sum_tmp, pcom(j)%plstr(ipl)%sum_w,     &
                        pcom(j)%plstr(ipl)%sum_a
                  end if 
                end if
              end do
              pcom(j)%dtbl(idtbl)%num_actions(iac) = pcom(j)%dtbl(idtbl)%num_actions(iac) + 1
              pcom(j)%dtbl(idtbl)%days_act(iac) = 1     !reset days since last action
              if (iac > 1) pcom(j)%dtbl(idtbl)%days_act(iac-1) =  0     !reset previous action day counter
            end if
  
          !reset rotation year
          case ("rot_reset")
            j = d_tbl%act(iac)%ob_num
            if (j == 0) j = ob_cur
            if (d_tbl%act(iac)%const < 1) d_tbl%act(iac)%const = 1
            pcom(j)%rot_yr = d_tbl%act(iac)%const
              
          !reset days since last harvest
          case ("harv_reset")
            j = d_tbl%act(iac)%ob_num
            if (j == 0) j = ob_cur
            if (d_tbl%act(iac)%const < 1) d_tbl%act(iac)%const = 1
            pcom(j)%days_harv = d_tbl%act(iac)%const
            
          !reset days since last harvest
          case ("kill_reset")
            j = d_tbl%act(iac)%ob_num
            if (j == 0) j = ob_cur
            if (d_tbl%act(iac)%const < 1) d_tbl%act(iac)%const = 1
            pcom(j)%days_kill = d_tbl%act(iac)%const
            
          !reset days since last planting
          case ("plant_reset")
            j = d_tbl%act(iac)%ob_num
            if (j == 0) j = ob_cur
            if (d_tbl%act(iac)%const < 1) d_tbl%act(iac)%const = 1
            pcom(j)%days_plant = d_tbl%act(iac)%const
            
          !reset days since last irrigation
          case ("irr_reset")
            j = d_tbl%act(iac)%ob_num
            if (j == 0) j = ob_cur
            if (d_tbl%act(iac)%const < 1) d_tbl%act(iac)%const = 1
            pcom(j)%days_irr = d_tbl%act(iac)%const
            
          !apply pesticide
          case ("pest_apply")
            j = d_tbl%act(iac)%ob_num
            if (j == 0) j = ob_cur
            
            if (pcom(j)%dtbl(idtbl)%num_actions(iac) <= Int(d_tbl%act(iac)%const2)) then
              ipl = 1
              sumpst = sumpst + 1
              ipst = d_tbl%act_typ(iac)                                     !pesticide type from fert data base
              ipestop = d_tbl%act_app(iac)                                  !surface application fraction from chem app data base
              pest_kg = d_tbl%act(iac)%const * chemapp_db(ipestop)%app_eff  !amount applied in kg/ha
              call pest_apply (j, ipst, pest_kg, ipestop)

              if (pco%mgtout == "y") then
                write (2612, *) j, time%yrc, time%mo, time%day_mo, d_tbl%act(iac)%option, "    PEST ",        &
                 phubase(j), pcom(j)%plcur(ipl)%phuacc, soil(j)%sw,pl_mass(j)%tot(ipl)%m,           &
                 soil1(j)%rsd(1)%m, sol_sumno3(j), sol_sumsolp(j), pest_kg
              endif
              pcom(j)%dtbl(idtbl)%num_actions(iac) = pcom(j)%dtbl(idtbl)%num_actions(iac) + 1
              !dtbl_lum(idtbl)%hru_lu_cur = dtbl_lum(idtbl)%hru_lu_cur + 1
              !dtbl_lum(idtbl)%hru_ha_cur = dtbl_lum(idtbl)%hru_ha_cur + hru(j)%area_ha
            end if
          
          case ("graze")    !! grazing operation
            j = d_tbl%act(iac)%ob_num
            if (j == 0) j = ob_cur

            igr = d_tbl%act_typ(iac)
            graze = grazeop_db(igr)
            call pl_graze
            
              !if (pco%mgtout == "y") then
              !  write (2612, *) j, time%yrc, time%mo, time%day_mo, "         ", "    GRAZE",         &
              !    phubase(j), pcom(j)%plcur(ipl)%phuacc, soil(j)%sw,pl_mass(j)%tot(ipl)%m,        &
              !    soil1(j)%rsd(1)%m, sol_sumno3(j), sol_sumsolp(j), grazeop_db(igr)%eat, grazeop_db(igr)%manure
              !end if
              pcom(j)%dtbl(idtbl)%num_actions(iac) = pcom(j)%dtbl(idtbl)%num_actions(iac) + 1

          !initiate growing season for hru_lte
          case ("grow_init")
            j = d_tbl%act(iac)%ob_num
            if (j == 0) j = ob_cur
            
            hlt(j)%gro = "y"
            hlt(j)%g = 0.
            hlt(j)%alai = 0.
            hlt(j)%dm = 0.
            hlt(j)%hufh = 0.

          !end growing season for hru_lte
          case ("grow_end")
            !calculate yield - print lai, biomass and yield
            j = d_tbl%act(iac)%ob_num
            if (j == 0) j = ob_cur
            
              idp = hlt(j)%iplant
              if (hlt(j)%pet < 10.) then
                wur = 100.
              else
                wur = 100. * hlt(j)%aet / hlt(j)%pet
              endif
              hiad1 = (pldb(idp)%hvsti - pldb(idp)%wsyf) *                            &   
                        (wur / (wur + Exp(6.13 - .0883 * wur))) + pldb(idp)%wsyf
              hiad1 = amin1 (hiad1, pldb(idp)%hvsti)
              yield = 0.8 * hlt(j)%dm * hiad1  ! * hlt(isd)%stress
              hlt(j)%yield = yield / 1000.
              hlt(j)%npp = hlt(j)%dm / 1000.
              hlt(j)%lai_mx = hlt(j)%alai
              !compute annual net primary productivity (npp) for perennial non-harvested?
              !use output.mgt print code
              !write() isd, time%day, time%yrc, pldb(iplt)%plantnm, hlt(isd)%alai, hlt(isd)%dm, yield
              hlt(j)%gro = "n"
              hlt(j)%g = 0.
              hlt(j)%alai = 0.
              hlt(j)%dm = 0.     !adjust for non-harvested perennials?
              hlt(j)%hufh = 0.
              hlt(j)%aet = 0.
              hlt(j)%pet = 0.

          !! drainage water management
          case ("tiledep_control") !! set drain depth for drainage water management
            j = d_tbl%act(iac)%ob_num
            if (j == 0) j = ob_cur
            
            if (pcom(j)%dtbl(idtbl)%num_actions(iac) <= Int(d_tbl%act(iac)%const2)) then
              istr = hru(j)%tiledrain
              hru(j)%lumv%sdr_dep = d_tbl%act(iac)%const
              pcom(j)%dtbl(idtbl)%num_actions(iac) = pcom(j)%dtbl(idtbl)%num_actions(iac) + 1
              
              if (pco%mgtout == "y") then
                write (2612, *) j, time%yrc, time%mo, time%day_mo, tilldb(idtill)%tillnm, "  DRAIN_CONTROL",    &
                    phubase(j), pcom(j)%plcur(1)%phuacc, soil(j)%sw, pl_mass(j)%tot(1)%m,        &
                    soil1(j)%rsd(1)%m, sol_sumno3(j), sol_sumsolp(j), hru(j)%lumv%sdr_dep
              end if
            end if
                                   
          ! set the amount of water to be diverted
          case ("tileflo_contol") 
            j = d_tbl%act(iac)%ob_num
            if (j == 0) j = ob_cur
            
            !! set amount of tile flow to send to buffer hru
            hru_rcv = hru(j)%sb%sb_db%hru_rcv
          
            ! option to set tile flow directed toward the saturated buffer hru
            select case (d_tbl%act(iac)%option)
                
            case ("flo_mm")    !! set tile flow diverted - can't be more than actual flow
              hru(hru_rcv)%sb%inflo = Min (qtile, d_tbl%act(iac)%const)

            case ("min_mm")    !! divert at least the minimum flow rate
              hru(hru_rcv)%sb%inflo = Max (qtile, d_tbl%act(iac)%const)
              
            case ("max_mm")    !! divert the maximum flow rate - can't be more than actual flow
              hru(hru_rcv)%sb%inflo = Min (qtile, d_tbl%act(iac)%const)
              
            case ("all_flo")    !! all flow diverted
              hru(hru_rcv)%sb%inflo = qtile

            case ("zero_flo")    !! all flow diverted
              hru(hru_rcv)%sb%inflo = 0.

            case ("frac")   !! minimum - constant fraction 
              hru(hru_rcv)%sb%inflo = d_tbl%act(iac)%const * qtile
                
            end select
                            
          ! set the demand from a reservoir
          case ("res_demand") 
            j = d_tbl%act(iac)%ob_num
            if (j == 0) j = ob_cur
            
            select case (d_tbl%act(iac)%option)
            !! demand is to fill to principal spillway
            case ("storage")
              if (d_tbl%act(iac)%file_pointer == "pvol") then
                dmd_m3 = d_tbl%act(iac)%const * res_ob(j)%pvol - res(j)%flo
                dmd_m3 = Max (0., dmd_m3)
              end if
              if (d_tbl%act(iac)%file_pointer == "evol") then
                dmd_m3 = d_tbl%act(iac)%const * res_ob(j)%evol - res(j)%flo
                dmd_m3 = Max (0., dmd_m3)
              end if
            end select
            
          !turn off hru impounded water - rice paddy or wetland
          case ("impound_off")
            j = d_tbl%act(iac)%ob_num
            if (j == 0) j = ob_cur
            
            hru(j)%dbs%surf_stor = 0
            wet(j) = hz
            wet_wat_d(j) = wbodz
           
          !turn on hru impounded water - rice paddy or wetland
          case ("impound_on")
            j = d_tbl%act(iac)%ob_num
            if (j == 0) j = ob_cur
            iihru = j
            
            !! xwalk with wetland.wet name
            do ires = 1, db_mx%wet_dat
              if (wet_dat(ires)%name == d_tbl%act(iac)%file_pointer) then
                hru(j)%dbs%surf_stor = ires
              end if
            end do
              
            call wet_initial (iihru)
         
          !adjust weir height - rice paddy
          case ("weir_height")
            j = d_tbl%act(iac)%ob_num
            if (j == 0) j = ob_cur
            
            if (d_tbl%act(iac)%option == "wet") then
              wet_ob(j)%weir_hgt = d_tbl%act(iac)%const / 1000. !m
              !update pvol/evol according to weir height for paddy weir discharge. Jaehak 2023
              wet_ob(j)%pvol = hru(j)%area_ha * wet_ob(j)%weir_hgt * 10.**4  ! m3
              if (wet_ob(j)%evol < wet_ob(j)%pvol*1.2) then
                wet_ob(j)%evol = wet_ob(j)%pvol * 1.2   
              endif
              
            else 
              res_ob(j)%weir_hgt = d_tbl%act(iac)%const / 1000.
            end if
           
          !puddling operation for rice paddies
          case ("puddle")
            j = d_tbl%act(iac)%ob_num
            if (j == 0) j = ob_cur
            if (pcom(j)%dtbl(idtbl)%num_actions(iac) <= Int(d_tbl%act(iac)%const2)) then

              !! xwalk with puddle.ops
              do ipdl = 1, db_mx%pudl_db
                if (pudl_db(ipdl)%name == d_tbl%act(iac)%option) then
                  ipud = ipdl
                end if
              end do
              
              !decrease hydraulic conductivity of upper layer
              if (pudl_db(ipud)%wet_hc>0) hru(j)%wet_hc = pudl_db(ipud)%wet_hc
              !increase sediment concentration in water
              wet(j)%sed = pudl_db(ipud)%sed * wet(j)%flo / 1000000.      ! t = ppm (1 t/1000000 m3) * m3
              !we can add nutrients when needed - may need to subtract nutrients from soil to maintain balance

              do idb = 1, db_mx%tillparm
                if (tilldb(idb)%tillnm == d_tbl%act(iac)%name) then
                  idtill = idb
                  exit
                endif
              end do
            
              if (wet_ob(j)%depth > 0.001) then
                call mgt_newtillmix_wet(j,idtill) 
              else
                call mgt_newtillmix(j,0.,idtill) 
              endif
              pcom(j)%dtbl(idtbl)%num_actions(iac) = pcom(j)%dtbl(idtbl)%num_actions(iac) + 1
            endif
            
          !hru area fraction change - update lsu_unit.ele and rout_unit.ele
          case ("hru_fr_update")
            !"option" is the updated lsu_unit.ele and "file_pointer" is rout_unit.ele
            call hru_fr_change (d_tbl%act(iac)%option, d_tbl%act(iac)%file_pointer)
            !! write to new landuse change file
            write (3612,*) j, time%yrc, time%mo, time%day_mo,  "   HRU_FRACTION_CHANGE ",        &
                    d_tbl%act(iac)%option, d_tbl%act(iac)%file_pointer, "   0   0"
                            
          !land use change - total land use and management change
          case ("lu_change")
            j = d_tbl%act(iac)%ob_num
            if (j == 0) j = ob_cur
            !if (d_tbl%lu_chg_mx(iac) <= Int(d_tbl%act(iac)%const2)) then
            d_tbl%lu_chg_mx(iac) = d_tbl%lu_chg_mx(iac) + 1
            ilu = d_tbl%act_typ(iac)
            hru(j)%land_use_mgt = ilu
            hru(j)%dbs%land_use_mgt = ilu
									 
            lu_prev = hru(j)%land_use_mgt_c
            hru(j)%land_use_mgt_c = d_tbl%act(iac)%file_pointer
            isol = hru(j)%dbs%soil
            call hru_lum_init (j)
            call plant_init (1,j)     ! (1) is to deallocate and reset
            call cn2_init (j)
            !! reset composite usle value - in hydro_init
            rock = Exp(-.053 * soil(j)%phys(1)%rock)
            hru(j)%lumv%usle_mult = rock * soil(j)%ly(1)%usle_k *       &
                                 hru(j)%lumv%usle_p * hru(j)%lumv%usle_ls * 11.8
            !! write to new landuse change file
            write (3612,*) j, time%yrc, time%mo, time%day_mo,  "    LU_CHANGE ",        &
                    lu_prev, hru(j)%land_use_mgt_c, "   0   0"
                            
              !! add new plants in simulation for yield output
              do ipl = 1, pcom(j)%npl
                if (basin_plants == 0) then
                  plts_bsn(1) = pcom(j)%pl(ipl)
                  basin_plants = 1
                else
                  num_plts_cur = basin_plants
                  do iplt = 1, num_plts_cur
                    if (pcom(j)%pl(ipl) == plts_bsn(iplt)) exit
                    if (iplt == basin_plants) then
                      plts_bsn(iplt+1) = pcom(j)%pl(ipl)
                      bsn_crop_yld(iplt+1) = bsn_crop_yld_z
                      bsn_crop_yld_aa(iplt+1) = bsn_crop_yld_z
                      basin_plants = basin_plants + 1
                      pcom(j)%plcur(ipl)%bsn_num = basin_plants
                    end if
                  end do
                end if
              end do
              !pcom(j)%dtbl(idtbl)%num_actions(iac) = pcom(j)%dtbl(idtbl)%num_actions(iac) + 1
            !end if
          !land use change - contouring
          case ("p_factor")
            j = d_tbl%act(iac)%ob_num
            if (j == 0) j = ob_cur
            
            p_factor = hru(j)%lumv%usle_p
            !! set new p factor
            hru(j)%lumv%usle_p = d_tbl%act(iac)%const
            !! reset composite usle value - in hydro_init
            rock = Exp(-.053 * soil(j)%phys(1)%rock)
            hru(j)%lumv%usle_mult = rock * soil(j)%ly(1)%usle_k *       &
                                 hru(j)%lumv%usle_p * hru(j)%lumv%usle_ls * 11.8
            !! write to new landuse change file
            write (3612,*) j, time%yrc, time%mo, time%day_mo,  "     P_FACTOR",        &
                    "  null           null",  p_factor, hru(j)%lumv%usle_p
                                
          !land use change - contouring
          case ("contour")
            j = d_tbl%act(iac)%ob_num
            if (j == 0) j = ob_cur
            
            p_factor = hru(j)%lumv%usle_p
            !! set new p factor as function of slope - from cons_practice.lum relationship
            hru(j)%lumv%usle_p = 2.7 * hru(j)%topo%slope + .26
            !! reset composite usle value - in hydro_init
            rock = Exp(-.053 * soil(j)%phys(1)%rock)
            hru(j)%lumv%usle_mult = rock * soil(j)%ly(1)%usle_k *       &
                                 hru(j)%lumv%usle_p * hru(j)%lumv%usle_ls * 11.8
            write (3612,*) j, time%yrc, time%mo, time%day_mo,  "      CONTOUR ",        &
                    "  null           null",  p_factor, hru(j)%lumv%usle_p
                                  
          !land use change - strip cropping
          case ("stripcrop")
            j = d_tbl%act(iac)%ob_num
            if (j == 0) j = ob_cur
            
            p_factor = hru(j)%lumv%usle_p
            !! set new p factor as function of slope - from cons_practice.lum relationship
            hru(j)%lumv%usle_p = 2.32 * hru(j)%topo%slope + .36
            !! adjust for pasture - above equation is for row crops
            if (d_tbl%act(iac)%file_pointer == "pasture") hru(j)%lumv%usle_p = .5 * hru(j)%lumv%usle_p
            !! reset composite usle value - in hydro_init
            rock = Exp(-.053 * soil(j)%phys(1)%rock)
            hru(j)%lumv%usle_mult = rock * soil(j)%ly(1)%usle_k *       &
                                 hru(j)%lumv%usle_p * hru(j)%lumv%usle_ls * 11.8
            write (3612,*) j, time%yrc, time%mo, time%day_mo,  "    STRIPCROP ",        &
                    "  null           null",  p_factor, hru(j)%lumv%usle_p  
                    
          !land use change
          case ("terrace")
            j = d_tbl%act(iac)%ob_num
            if (j == 0) j = ob_cur
              
            p_factor = hru(j)%lumv%usle_p
            !! set new p factor as function of slope - from cons_practice.lum relationship
            hru(j)%lumv%usle_p = 1.4 * hru(j)%topo%slope + .13
            !! adjust for sod outlet - above equation is for underflow outlet
            if (d_tbl%act(iac)%file_pointer == "sod_outlet") hru(j)%lumv%usle_p = 2. * hru(j)%lumv%usle_p
            !! reset composite usle value - in hydro_init
            rock = Exp(-.053 * soil(j)%phys(1)%rock)
            hru(j)%lumv%usle_mult = rock * soil(j)%ly(1)%usle_k *       &
                                 hru(j)%lumv%usle_p * hru(j)%lumv%usle_ls * 11.8
            write (3612,*) j, time%yrc, time%mo, time%day_mo,  "      TERRACE ",        &
                    "  null           null",  p_factor, hru(j)%lumv%usle_p  
                    
          !install tile drains
          case ("tile_install")
            j = d_tbl%act(iac)%ob_num
            if (j == 0) j = ob_cur
              
            do istr = 1, db_mx%sdr
              if (d_tbl%act(iac)%file_pointer == sdr(istr)%name) then
                istr1 = istr
                exit
              end if
            end do
            
            !! set parameters for structural land use/management
            if (d_tbl%act(iac)%file_pointer /= "null") then
              call structure_set_parms("tiledrain       ", istr1, j)
            end if
            !! write to new landuse change file
            istr = hru(j)%tiledrain
            write (3612,*) j, time%yrc, time%mo, time%day_mo,  " TILE_INSTALL ",        &
              sdr(istr)%name, sdr(istr1)%name, "   0   0"
                      
          !install septic tanks
          case ("septic_install")
            j = d_tbl%act(iac)%ob_num
            if (j == 0) j = ob_cur
              
            do istr = 1, db_mx%septic
              if (d_tbl%act(iac)%file_pointer == sep(istr)%name) then
                istr1 = istr
                exit
              end if
            end do
                  
            !! set parameters for structural land use/management
            if (d_tbl%act(iac)%file_pointer /= "null") then
              call structure_set_parms("septic          ", istr1, j)
            end if
            write (3612,*) j, time%yrc, time%mo, time%day_mo,  " SEPTIC_INSTALL ",       &
              sdr(istr)%name, sdr(istr1)%name, "   0   0"
                                    
          !install filter strips
          case ("fstrip_install")
            j = d_tbl%act(iac)%ob_num
            if (j == 0) j = ob_cur
              
            do istr = 1, db_mx%filtop_db
              if (d_tbl%act(iac)%file_pointer == filtstrip_db(istr)%name) then
                istr1 = istr
                exit
              end if
            end do
            
            !! set parameters for structural land use/management
            if (d_tbl%act(iac)%file_pointer /= "null") then
              call structure_set_parms("fstrip         ", istr1, j)
            end if
            write (3612,*) j, time%yrc, time%mo, time%day_mo,  " FSTRIP_INSTALL ",       &
              sdr(istr)%name, sdr(istr1)%name, "   0   0"
                                              
          !install grass waterways
          case ("grassww_install")
            j = d_tbl%act(iac)%ob_num
            if (j == 0) j = ob_cur
              
            do istr = 1, db_mx%grassop_db
              if (d_tbl%act(iac)%file_pointer == grwaterway_db(istr)%name) then
                !istr1 = istr
                hru(j)%lumv%grwat_i = 1
                exit
              end if
            end do
            
            !! set parameters for structural land use/management
            if (d_tbl%act(iac)%file_pointer /= "null") then
              call structure_set_parms("grassww         ", istr1, j)
            end if
            write (3612,*) j, time%yrc, time%mo, time%day_mo,  " GRASSWW_INSTALL ",       &
              sdr(istr)%name, sdr(istr1)%name, "   0   0"
                                                         
          !install grass waterways
          case ("grassww_uninstall")
            j = d_tbl%act(iac)%ob_num
            if (j == 0) j = ob_cur
            hru(j)%lumv%grwat_i = 0
            write (3612,*) j, time%yrc, time%mo, time%day_mo,  " GRASSWW_UNINSTALL ",       &
              sdr(istr)%name, sdr(istr1)%name, "   0   0"
          !user defined bmp reductions
          case ("user_def_bmp")
            j = d_tbl%act(iac)%ob_num
            if (j == 0) j = ob_cur
              
            do istr = 1, db_mx%bmpuserop_db
              if (d_tbl%act(iac)%file_pointer == bmpuser_db(istr)%name) then
                istr1 = istr
                exit
              end if
            end do
            
            !! set parameters for structural land use/management
            if (d_tbl%act(iac)%file_pointer /= "null") then
              call structure_set_parms("user_def        ", istr1, j)
            end if
            write (3612,*) j, time%yrc, time%mo, time%day_mo,  " USER_DEF_BMP ",       &
              sdr(istr)%name, sdr(istr1)%name, "   0   0"
                                        
          !channel change
          case ("chan_change")
            ich = ob_cur
            !set new cover and name for calibration
            sd_ch(ich)%cov = d_tbl%act(iac)%const
            sd_ch(ich)%order = d_tbl%act(iac)%file_pointer
        
          !! Perform burning operation on HRU
          case ("burn")
            j = d_tbl%act(iac)%ob_num
            if (j == 0) j = ob_cur
            
            !! Check maximum number of burn operations per year
            if (pcom(j)%dtbl(idtbl)%num_actions(iac) <= Int(d_tbl%act(iac)%const2)) then
              iburn = d_tbl%act_typ(iac)           !burn type
              !! Apply burning to all plants in the community
              do ipl = 1, pcom(j)%npl
                call pl_burnop (j, iburn)
              end do
                        

              !! Reset plant index for output after burn operation
              ipl = 1
              !! Write management output if enabled
              if (pco%mgtout == "y") then
                write (2612, *) j, time%yrc, time%mo, time%day_mo, d_tbl%act(iac)%name, "    BURN", phubase(j),    &
                    pcom(j)%plcur(ipl)%phuacc, soil(j)%sw,pl_mass(j)%tot(ipl)%m, soil1(j)%rsd(1)%m,   &
                    sol_sumno3(j), sol_sumsolp(j)
              end if
              !! Update action tracking counters
              pcom(j)%dtbl(idtbl)%num_actions(iac) = pcom(j)%dtbl(idtbl)%num_actions(iac) + 1
            end if
          
          !! Update curve number for runoff calculations
          case ("cn_update")
            j = d_tbl%act(iac)%ob_num
            if (j == 0) j = ob_cur
            
            !! Store previous curve number for comparison
            cn_prev = cn2(j)
            !! Check maximum number of curve number updates per year
            if (pcom(j)%dtbl(idtbl)%num_actions(iac) <= Int(d_tbl%act(iac)%const2)) then
              !! Update curve number using change parameter function
              cn2(j) = chg_par (cn2(j), d_tbl%act(iac)%option, d_tbl%act(iac)%const, 35., 95.)
              !! Recalculate curve number parameters for the HRU
              call curno (cn2(j), j)
              !! Write management output if enabled
              if (pco%mgtout == "y") then
                ipl = 1
                write (2612, *) j, time%yrc, time%mo, time%day_mo, d_tbl%act(iac)%name, "    CNUP", phubase(j),    &
                  pcom(j)%plcur(ipl)%phuacc, soil(j)%sw, pl_mass(j)%tot(ipl)%m, soil1(j)%rsd(1)%m,       &
                  sol_sumno3(j), sol_sumsolp(j), cn_prev, cn2(j)
              end if
            
            end if
            
            !! Update action tracking counters
            pcom(j)%dtbl(idtbl)%num_actions(iac) = pcom(j)%dtbl(idtbl)%num_actions(iac) + 1
                          
          case ("pheno_reset")  !! Begin and end monsoon initiation period for moisture-triggered growth
            j = d_tbl%act(iac)%ob_num
            if (j == 0) j = ob_cur
            
            !! Check maximum number of phenology resets per year
            if (pcom(j)%dtbl(idtbl)%num_actions(iac) <= Int(d_tbl%act(iac)%const2)) then
              !! Loop through all plants to reset phenology for moisture-triggered growth
              do ipl = 1, pcom(j)%npl
                idp = pcom(j)%plcur(ipl)%idplt
                !! Reset phenology only for moisture-triggered plants
                if (pldb(idp)%trig == "moisture_gro") then
                  pcom(j)%plcur(ipl)%phuacc = 0.
                  pcom(j)%plcur(ipl)%gro = "y" 
                  pcom(j)%plcur(ipl)%idorm = "n"
                endif
              end do
            end if
            
            !! Update action tracking counters
            pcom(j)%dtbl(idtbl)%num_actions(iac) = pcom(j)%dtbl(idtbl)%num_actions(iac) + 1
            pcom(j)%dtbl(idtbl)%days_act(iac) = 1     !reset days since last action
            if (iac > 1) pcom(j)%dtbl(idtbl)%days_act(iac-1) =  0     !reset previous action day counter

          !! Manage livestock herds (placeholder for future implementation)
          case ("herd")

          end select
        end if
      end do

      return
      end subroutine actions