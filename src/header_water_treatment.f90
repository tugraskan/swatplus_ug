      subroutine header_water_treatment

      use maximum_data_module
      use water_allocation_module
      use basin_module
      
      implicit none 

      !! water treatment plant outputs
      if (db_mx%wtp_db > 0) then
        if (pco%water_allo%d == "y") then
          open (3118,file="water_treat_day.txt",recl = 1500)
          write (3118,*) bsn%name, prog
          write (3118,*) wtp_hdr
          write (3118,*) wtp_hdr_units
          write (9000,*) "WATER_TREATMENT       water_treat_day.txt"
          if (pco%csvout == "y") then
            open (3122,file="water_treat_day.csv",recl = 1500)
            write (3122,*) bsn%name, prog
            write (3122,'(*(G0.3,:,","))') wtp_hdr
            write (3122,'(*(G0.3,:,","))') wtp_hdr_units
            write (9000,*) "WATER_TREATMENT       water_treat_day.csv"
          end if
        endif
      endif
      
      if (db_mx%wtp_db > 0) then
        if (pco%water_allo%m == "y") then  
          open (3119,file="water_treat_mon.txt",recl = 1500)
          write (3119,*) bsn%name, prog
          write (3119,*) wtp_hdr
          write (3119,*) wtp_hdr_units
          write (9000,*) "WATER_TREATMENT       water_treat_mon.txt"
          if (pco%csvout == "y") then
            open (3123,file="water_treat_mon.csv",recl = 1500)
            write (3123,*) bsn%name, prog
            write (3123,'(*(G0.3,:,","))') wtp_hdr
            write (3123,'(*(G0.3,:,","))') wtp_hdr_units
            write (9000,*) "WATER_TREATMENT       water_treat_mon.csv"
          end if
        end if
      end if 
        
      if (db_mx%wtp_db > 0) then
        if (pco%water_allo%y == "y") then
          open (3120,file="water_treat_yr.txt",recl = 1500)
          write (3120,*) bsn%name, prog
          write (3120,*) wtp_hdr
          write (3120,*) wtp_hdr_units
          write (9000,*) "WATER_TREATMENT       water_treat_yr.txt"
          if (pco%csvout == "y") then
            open (3124,file="water_treat_yr.csv",recl = 1500)
            write (3124,*) bsn%name, prog
            write (3124,'(*(G0.3,:,","))') wtp_hdr
            write (3124,'(*(G0.3,:,","))') wtp_hdr_units
            write (9000,*) "WATER_TREATMENT       water_treat_yr.csv"
          end if
        endif
      endif
      
      if (db_mx%wtp_db > 0) then
        if (pco%water_allo%a == "y") then
          open (3121,file="water_treat_aa.txt",recl = 1500)
          write (3121,*) bsn%name, prog
          write (3121,*) wtp_hdr
          write (3121,*) wtp_hdr_units
          write (9000,*) "WATER_TREATMENT       water_treat_aa.txt"
          if (pco%csvout == "y") then
            open (3125,file="water_treat_aa.csv",recl = 1500)
            write (3125,*) bsn%name, prog
            write (3125,'(*(G0.3,:,","))') wtp_hdr
            write (3125,'(*(G0.3,:,","))') wtp_hdr_units
            write (9000,*) "WATER_TREATMENT       water_treat_aa.csv"
          end if
        end if
      end if 
       
      return
      end subroutine header_water_treatment