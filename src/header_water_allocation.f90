      subroutine header_water_allocation

      use maximum_data_module
      use water_allocation_module
      use basin_module
      use hydrograph_module
      
      implicit none 

!!!  Water Allocation Output
      if (db_mx%wallo_db > 0) then
        if (pco%water_allo%d == "y") then
          open (3110,file="wallo_allo_output_day.txt",recl = 1500)
          write (3110,*) bsn%name, prog
          write (3110,*) wallo_hdr_time2
          write (3110,*) wallo_unt_time2
          write (9000,*) "WATER_ALLOCATION          wallo_allo_output_day.txt"
          if (pco%csvout == "y") then
            open (3114,file="wallo_allo_output_day.csv",recl = 1500)
            write (3114,*) bsn%name, prog
            write (3114,'(*(G0.3,:,","))') wallo_hdr_time2
            write (3114,'(*(G0.3,:,","))') wallo_hdr_time2
            write (9000,*) "WATER_ALLOCATION          wallo_allo_output_day.csv"
          end if
        endif
      endif
      
        if (db_mx%wallo_db > 0) then
          if (pco%water_allo%m == "y") then  
          open (3111,file="wallo_allo_output_mon.txt",recl = 1500)
          write (3111,*) bsn%name, prog
          write (3111,*) wallo_hdr_time2
          write (3111,*) wallo_unt_time2
          write (9000,*) "WATER_ALLOCATION          wallo_allo_output_mon.txt"
          if (pco%csvout == "y") then
            open (3115,file="wallo_allo_output_mon.csv",recl = 1500)
            write (3115,*) bsn%name, prog
            write (3115,'(*(G0.3,:,","))') wallo_hdr_time2
            write (3115,'(*(G0.3,:,","))') wallo_unt_time2
            write (9000,*) "WATER_ALLOCATION          wallo_allo_output_mon.csv"
          end if
          end if
         end if 
        
      if (db_mx%wallo_db > 0) then
        if (pco%water_allo%y == "y") then
          open (3112,file="wallo_allo_output_yr.txt",recl = 1500)
          write (3112,*) bsn%name, prog
          write (3112,*) wallo_hdr_time2
          write (3112,*) wallo_unt_time2
          write (9000,*) "WATER_ALLOCATION          wallo_allo_output_yr.txt"
          if (pco%csvout == "y") then
            open (3116,file="wallo_allo_output_yr.csv",recl = 1500)
            write (3116,*) bsn%name, prog
            write (3116,'(*(G0.3,:,","))') wallo_hdr_time2
            write (3116,'(*(G0.3,:,","))') wallo_unt_time2
            write (9000,*) "WATER_ALLOCATION          wallo_allo_output_yr.csv"
          end if
        endif
      endif
      
        if (db_mx%wallo_db > 0) then
          if (pco%water_allo%a == "y") then
          open (3113,file="wallo_allo_output_aa.txt",recl = 1500)
          write (3113,*) bsn%name, prog
          write (3113,*) wallo_hdr_time2
          write (3113,*) wallo_unt_time2
          write (9000,*) "WATER_ALLOCATION          wallo_allo_output_aa.txt"
          if (pco%csvout == "y") then
            open (3117,file="wallo_allo_output_aa.csv",recl = 1500)
            write (3117,*) bsn%name, prog
            write (3117,'(*(G0.3,:,","))') wallo_hdr_time2
            write (3117,'(*(G0.3,:,","))') wallo_unt_time2
            write (9000,*) "WATER_ALLOCATION          wallo_allo_output_aa.csv"
          end if
          end if
         end if 
!!!  Water Allocation Output
               
!!   Water Allocation Organic Matter Transfer
      if (db_mx%wallo_db > 0) then
        if (pco%water_allo%d == "y") then
          open (3118,file="wallo_trn_output_day.txt",recl = 1500)
          write (3118,*) bsn%name, prog
          write (3118,*) wallo_hdr_time3, wallo_hyd_hdr, wallo_hyd_hdr2, wallo_hyd_hdr, &
                    wallo_hyd_hdr2, wallo_hyd_hdr
          write (3118,*) wallo_hdr_units1, wallo_hdr_units2, wallo_hdr_units2 
          write (9000,*) "WATER_ALLOCATION          wallo_trn_output_day.txt"
          if (pco%csvout == "y") then
            open (3122,file="wallo_trn_output_day.csv",recl = 1500)
            write (3122,*) bsn%name, prog
            write (3122,'(*(G0.3,:,","))') wallo_hdr_time3, wallo_hyd_hdr, wallo_hyd_hdr2, wallo_hyd_hdr, &
                    wallo_hyd_hdr2, wallo_hyd_hdr
            write (3122,'(*(G0.3,:,","))') wallo_hdr_units1, wallo_hdr_units2, wallo_hdr_units2
            write (9000,*) "WATER_ALLOCATION          wallo_trn_output_day.csv"
          end if
        endif
      endif
      
        if (db_mx%wallo_db > 0) then
          if (pco%water_allo%m == "y") then  
          open (3119,file="wallo_trn_output_mon.txt",recl = 1500)
          write (3119,*) bsn%name, prog
          write (3119,*) wallo_hdr_time3, wallo_hyd_hdr, wallo_hyd_hdr2, wallo_hyd_hdr, &
                    wallo_hyd_hdr2, wallo_hyd_hdr
          write (3119,*) wallo_hdr_units1, wallo_hdr_units2, wallo_hdr_units2
          write (9000,*) "WATER_ALLOCATION         wallo_trn_output_mon.txt"
          if (pco%csvout == "y") then
            open (3123,file="wallo_trn_output_mon.csv",recl = 1500)
            write (3123,*) bsn%name, prog
            write (3123,'(*(G0.3,:,","))') wallo_hdr_time3, wallo_hyd_hdr, wallo_hyd_hdr2, wallo_hyd_hdr, &
                    wallo_hyd_hdr2, wallo_hyd_hdr
            write (3123,'(*(G0.3,:,","))') wallo_hdr_units1, wallo_hdr_units2, wallo_hdr_units2
            write (9000,*) "WATER_ALLOCATION       wallo_trn_output_mon.csv"
          end if
          end if
         end if 
        
      if (db_mx%wallo_db > 0) then
        if (pco%water_allo%y == "y") then
          open (3120,file="wallo_trn_output_yr.txt",recl = 1500)
          write (3120,*) bsn%name, prog
          write (3120,*) wallo_hdr_time3, wallo_hyd_hdr, wallo_hyd_hdr2, wallo_hyd_hdr, &
                    wallo_hyd_hdr2, wallo_hyd_hdr
          write (3120,*) wallo_hdr_units1, wallo_hdr_units2, wallo_hdr_units2
          write (9000,*) "WATER_ALLOCATION          wallo_trn_output_yr.txt"
          if (pco%csvout == "y") then
            open (3124,file="wallo_trn_output_yr.csv",recl = 1500)
            write (3124,*) bsn%name, prog
            write (3124,'(*(G0.3,:,","))') wallo_hdr_time3, wallo_hyd_hdr, wallo_hyd_hdr2, wallo_hyd_hdr, &
                    wallo_hyd_hdr2, wallo_hyd_hdr
            write (3124,'(*(G0.3,:,","))') wallo_hdr_units1, wallo_hdr_units2, wallo_hdr_units2
            write (9000,*) "WATER_ALLOCATION          wallo_trn_output_yr.csv"
          end if
        endif
      endif
      
        if (db_mx%wallo_db > 0) then
          if (pco%water_allo%a == "y") then
          open (3121,file="wallo_trn_output_aa.txt",recl = 1500)
          write (3121,*) bsn%name, prog
          write (3121,*) wallo_hdr_time3, wallo_hyd_hdr, wallo_hyd_hdr2, wallo_hyd_hdr, &
                    wallo_hyd_hdr2, wallo_hyd_hdr
          write (3121,*) wallo_hdr_units1, wallo_hdr_units2, wallo_hdr_units2
          write (9000,*) "WATER_ALLOCATION          wallo_trn_output_aa.txt"
          if (pco%csvout == "y") then
            open (3125,file="wallo_trn_output_aa.csv",recl = 1500)
            write (3125,*) bsn%name, prog
            write (3125,'(*(G0.3,:,","))') wallo_hdr_time3, wallo_hyd_hdr, wallo_hyd_hdr2, wallo_hyd_hdr, &
                    wallo_hyd_hdr2, wallo_hyd_hdr
            write (3125,'(*(G0.3,:,","))') wallo_hdr_units1, wallo_hdr_units2, wallo_hdr_units2
            write (9000,*) "WATER_ALLOCATION          wallo_trn_output_aa.csv"
          end if
          end if
         end if        
!!   Water Allocation Organic Matter Transfer
            
!!   Water Allocation Organic Matter Treatment
      if (db_mx%wallo_db > 0) then
        if (pco%water_allo%d == "y") then
          open (3126,file="wallo_treat_output_day.txt",recl = 1500)
          write (3126,*) bsn%name, prog
          write (3126,*) wallo_hdr_time, hyd_hdr
          write (3126,*) wallo_hdr_units4
          write (9000,*) "WATER_ALLOCATION          wallo_treat_output_day.txt"
          if (pco%csvout == "y") then
            open (3130,file="wallo_treat_output_day.csv",recl = 1500)
            write (3130,*) bsn%name, prog
            write (3130,'(*(G0.3,:,","))') wallo_hdr_time, hyd_hdr
            write (3130,'(*(G0.3,:,","))') wallo_hdr_units4
            write (9000,*) "WATER_ALLOCATION          wallo_om_treat_output_day.csv"
          end if
        endif
      endif
      
        if (db_mx%wallo_db > 0) then
          if (pco%water_allo%m == "y") then  
          !open (3127,file="wallo_om_treat_mon.txt",recl = 1500)
          open (3127,file="wallo_treat_output_mon.txt",recl = 1500)
          write (3127,*) bsn%name, prog
          write (3127,*) wallo_hdr_time, hyd_hdr
          write (3127,*) wallo_hdr_units4
          write (9000,*) "WATER_ALLOCATION          wallo_treat_output_mon.txt"
          if (pco%csvout == "y") then
            open (3131,file="wallo_treat_output_mon.csv",recl = 1500)
            write (3131,*) bsn%name, prog
            write (3131,'(*(G0.3,:,","))') wallo_hdr_time, hyd_hdr
            write (3131,'(*(G0.3,:,","))') wallo_hdr_units4
            write (9000,*) "WATER_ALLOCATION          wallo_treat_output_mon.csv"
          end if
          end if
         end if 
        
      if (db_mx%wallo_db > 0) then
        if (pco%water_allo%y == "y") then
          !open (3128,file="wallo_om_treat_yr.txt",recl = 1500)
          open (3128,file="wallo_treat_output_yr.txt",recl = 1500)
          write (3128,*) bsn%name, prog
          write (3128,*) wallo_hdr_time, hyd_hdr
          write (3128,*) wallo_hdr_units4
          write (9000,*) "WATER_ALLOCATION          wallo_treat_output_yr.txt"
          if (pco%csvout == "y") then
            open (3132,file="wallo_treat_output_yr.csv",recl = 1500)
            write (3132,*) bsn%name, prog
            write (3132,'(*(G0.3,:,","))') wallo_hdr_time, hyd_hdr
            write (3132,'(*(G0.3,:,","))') wallo_hdr_units4
            write (9000,*) "WATER_ALLOCATION          wallo_treat_output_yr.csv"
          end if
        endif
      endif
      
        if (db_mx%wallo_db > 0) then
          if (pco%water_allo%a == "y") then
          open (3129,file="wallo_treat_output_aa.txt",recl = 1500)
          write (3129,*) bsn%name, prog
          write (3129,*) wallo_hdr_time, hyd_hdr
          write (3129,*) wallo_hdr_units4
          write (9000,*) "WATER_ALLOCATION          wallo_treat_output_aa.txt"
          if (pco%csvout == "y") then
            open (3133,file="wallo_treat_output_aa.csv",recl = 1500)
            write (3133,*) bsn%name, prog
            write (3133,'(*(G0.3,:,","))') wallo_hdr_time, hyd_hdr
            write (3133,'(*(G0.3,:,","))') wallo_hdr_units4
            write (9000,*) "WATER_ALLOCATION          wallo_treat_output_aa.csv"
          end if
          end if
         end if         
!!   Water Allocation Organic Matter Treatment

!!   Water Allocation Organic Matter Use
      if (db_mx%wallo_db > 0) then
        if (pco%water_allo%d == "y") then
          open (3134,file="wallo_use_output_day.txt",recl = 1500)
          write (3134,*) bsn%name, prog
          write (3134,*) wallo_hdr_time1, hyd_hdr
          write (3134,*) wallo_hdr_units4 
          write (9000,*) "WATER_ALLOCATION          wallo_use_output_day.txt"
          if (pco%csvout == "y") then
            open (3138,file="wallo_use_output_day.csv",recl = 1500)
            write (3138,*) bsn%name, prog
            write (3138,'(*(G0.3,:,","))') wallo_hdr_time1, hyd_hdr
            write (3138,'(*(G0.3,:,","))') wallo_hdr_units4
            write (9000,*) "WATER_ALLOCATION          wallo_use_output_day.csv"
          end if
        endif
      endif
      
        if (db_mx%wallo_db > 0) then
          if (pco%water_allo%m == "y") then  
          open (3135,file="wallo_use_output_mon.txt",recl = 1500)
          write (3135,*) bsn%name, prog
          write (3135,*) wallo_hdr_time1, hyd_hdr
          write (3135,*) wallo_hdr_units4
          write (9000,*) "WATER_ALLOCATION          wallo_use_output_mon.txt"
          if (pco%csvout == "y") then
            open (3139,file="wallo_use_output_mon.csv",recl = 1500)
            write (3139,*) bsn%name, prog
            write (3139,'(*(G0.3,:,","))') wallo_hdr_time1, hyd_hdr
            write (3139,'(*(G0.3,:,","))') wallo_hdr_units4
            write (9000,*) "WATER_ALLOCATION          wallo_use_output_mon.csv"
          end if
          end if
         end if 
        
      if (db_mx%wallo_db > 0) then
        if (pco%water_allo%y == "y") then
          open (3136,file="wallo_use_output_yr.txt",recl = 1500)
          write (3136,*) bsn%name, prog
          write (3136,*) wallo_hdr_time1, hyd_hdr
          write (3136,*) wallo_hdr_units4
          write (9000,*) "WATER_ALLOCATION          wallo_use_output_yr.txt"
          if (pco%csvout == "y") then
            open (3140,file="wallo_use_output_yr.csv",recl = 1500)
            write (3140,*) bsn%name, prog
            write (3140,'(*(G0.3,:,","))') wallo_hdr_time1, hyd_hdr
            write (3140,'(*(G0.3,:,","))') wallo_hdr_units4
            write (9000,*) "WATER_ALLOCATION          wallo_use_output_yr.csv"
          end if
        endif
      endif
      
        if (db_mx%wallo_db > 0) then
          if (pco%water_allo%a == "y") then
          open (3137,file="wallo_use_output_aa.txt",recl = 1500)
          write (3137,*) bsn%name, prog
          write (3137,*) wallo_hdr_time1, hyd_hdr
          write (3137,*) wallo_hdr_units4
          write (9000,*) "WATER_ALLOCATION          wallo_use_output_aa.txt"
          if (pco%csvout == "y") then
            open (3141,file="wallo_use_output_aa.csv",recl = 1500)
            write (3141,*) bsn%name, prog
            write (3141,'(*(G0.3,:,","))') wallo_hdr_time1, hyd_hdr
            write (3141,'(*(G0.3,:,","))') wallo_hdr_units4
            write (9000,*) "WATER_ALLOCATION          wallo_use_output_aa.csv"
          end if
          end if
         end if         
!!   Water Allocation Organic Matter Use
         
!!   Water Allocation OB Source
      if (db_mx%wallo_db > 0) then
        if (pco%water_allo%d == "y") then
          open (3142,file="wallo_osrc_output_day.txt",recl = 1500)
          write (3142,*) bsn%name, prog
          write (3142,*) wallo_hdr
          write (3142,*) wallo_hdr_units 
          write (9000,*) "WATER_ALLOCATION          wallo_osrc_output_day.txt"
          if (pco%csvout == "y") then
            open (3146,file="wallo_osrc_output_day.csv",recl = 1500)
            write (3146,*) bsn%name, prog
            write (3146,'(*(G0.3,:,","))') wallo_hdr
            write (3146,'(*(G0.3,:,","))') wallo_hdr_units
            write (9000,*) "WATER_ALLOCATION          wallo_osrc_output_day.csv"
          end if
        endif
      endif
      
        if (db_mx%wallo_db > 0) then
          if (pco%water_allo%m == "y") then  
          open (3143,file="wallo_osrc_output_mon.txt",recl = 1500)
          write (3143,*) bsn%name, prog
          write (3143,*) wallo_hdr
          write (3143,*) wallo_hdr_units
          write (9000,*) "WATER_ALLOCATION          wallo_osrc_output_mon.txt"
          if (pco%csvout == "y") then
            open (3147,file="wallo_oscr_output_mon.csv",recl = 1500)
            write (3147,*) bsn%name, prog
            write (3147,'(*(G0.3,:,","))') wallo_hdr
            write (3147,'(*(G0.3,:,","))') wallo_hdr_units
            write (9000,*) "WATER_ALLOCATION          wallo_osrc_output_mon.csv"
          end if
          end if
         end if 
        
      if (db_mx%wallo_db > 0) then
        if (pco%water_allo%y == "y") then
          open (3144,file="wallo_osrc_output_yr.txt",recl = 1500)
          write (3144,*) bsn%name, prog
          write (3144,*) wallo_hdr
          write (3144,*) wallo_hdr_units
          write (9000,*) "WATER_ALLOCATION          wallo_osrc_output_yr.txt"
          if (pco%csvout == "y") then
            open (3148,file="wallo_osrc_output_yr.csv",recl = 1500)
            write (3148,*) bsn%name, prog
            write (3148,'(*(G0.3,:,","))') wallo_hdr
            write (3148,'(*(G0.3,:,","))') wallo_hdr_units
            write (9000,*) "WATER_ALLOCATION          wallo_osrc_output_yr.csv"
          end if
        endif
      endif
      
        if (db_mx%wallo_db > 0) then
          if (pco%water_allo%a == "y") then
          open (3145,file="wallo_osrc_output_aa.txt",recl = 1500)
          write (3145,*) bsn%name, prog
          write (3145,*) wallo_hdr
          write (3145,*) wallo_hdr_units
          write (9000,*) "WATER_ALLOCATION          wallo_osrc_output_aa.txt"
          if (pco%csvout == "y") then
            open (3149,file="wallo_osrc_output_aa.csv",recl = 1500)
            write (3149,*) bsn%name, prog
            write (3149,'(*(G0.3,:,","))') wallo_hdr
            write (3149,'(*(G0.3,:,","))') wallo_hdr_units
            write (9000,*) "WATER_ALLOCATION          wallo_osrc_output_aa.csv"
          end if
          end if
         end if         
!!   Water Allocation OB Source
         
!!   Water Allocation OB Demand
      if (db_mx%wallo_db > 0) then
        if (pco%water_allo%d == "y") then
          open (3150,file="wallo_odmd_output_day.txt",recl = 1500)
          write (3150,*) bsn%name, prog
          write (3150,*) wallo_hdr
          write (3150,*) wallo_hdr_units 
          write (9000,*) "WATER_ALLOCATION          wallo_odmd_output_day.txt"
          if (pco%csvout == "y") then
            open (3154,file="wallo_odmd_output_day.csv",recl = 1500)
            write (3154,*) bsn%name, prog
            write (3154,'(*(G0.3,:,","))') wallo_hdr
            write (3154,'(*(G0.3,:,","))') wallo_hdr_units
            write (9000,*) "WATER_ALLOCATION          wallo_odmd_output_day.csv"
          end if
        endif
      endif
      
        if (db_mx%wallo_db > 0) then
          if (pco%water_allo%m == "y") then  
          open (3151,file="wallo_odmd_output_mon.txt",recl = 1500)
          write (3151,*) bsn%name, prog
          write (3151,*) wallo_hdr
          write (3151,*) wallo_hdr_units
          write (9000,*) "WATER_ALLOCATION          wallo_odmd_output_mon.txt"
          if (pco%csvout == "y") then
            open (3155,file="wallo_odmd_output_mon.csv",recl = 1500)
            write (3155,*) bsn%name, prog
            write (3155,'(*(G0.3,:,","))') wallo_hdr
            write (3155,'(*(G0.3,:,","))') wallo_hdr_units
            write (9000,*) "WATER_ALLOCATION          wallo_odmd_output_mon.csv"
          end if
          end if
         end if 
        
      if (db_mx%wallo_db > 0) then
        if (pco%water_allo%y == "y") then
          open (3152,file="wallo_odmd_output_yr.txt",recl = 1500)
          write (3152,*) bsn%name, prog
          write (3152,*) wallo_hdr
          write (3152,*) wallo_hdr_units
          write (9000,*) "WATER_ALLOCATION          wallo_odmd_output_yr.txt"
          if (pco%csvout == "y") then
            open (3156,file="wallo_odmd_output_yr.csv",recl = 1500)
            write (3156,*) bsn%name, prog
            write (3156,'(*(G0.3,:,","))') wallo_hdr
            write (3156,'(*(G0.3,:,","))') wallo_hdr_units
            write (9000,*) "WATER_ALLOCATION          wallo_odmd_output_yr.csv"
          end if
        endif
      endif
      
        if (db_mx%wallo_db > 0) then
          if (pco%water_allo%a == "y") then
          open (3153,file="wallo_odmd_output_aa.txt",recl = 1500)
          write (3153,*) bsn%name, prog
          write (3153,*) wallo_hdr
          write (3153,*) wallo_hdr_units
          write (9000,*) "WATER_ALLOCATION          wallo_odmd_output_aa.txt"
          if (pco%csvout == "y") then
            open (3157,file="wallo_odmd_output_aa.csv",recl = 1500)
            write (3157,*) bsn%name, prog
            write (3157,'(*(G0.3,:,","))') wallo_hdr
            write (3157,'(*(G0.3,:,","))') wallo_hdr_units
            write (9000,*) "WATER_ALLOCATION          wallo_odmd_output_aa.csv"
          end if
          end if
         end if         
!!   Water Allocation OB Demand
    
      return
      end subroutine header_water_allocation