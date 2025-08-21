!!@summary Format and output aquifer pesticide mass balance data across multiple time scales with proper averaging
!!@description This subroutine handles the comprehensive output of aquifer pesticide mass balance data
!! for a specific aquifer across daily, monthly, yearly, and average annual time scales. It accumulates
!! daily pesticide balance components to longer-term summaries, applies appropriate averaging for intensive
!! variables, and generates formatted output reports. The subroutine includes both fixed-format and CSV
!! output options. At the end of each time period, arrays are reset with proper initialization for the
!! next period. Time averaging accounts for varying month lengths and simulation duration.
!!@arguments
!! - j: Aquifer index number for the specific aquifer object being processed
      subroutine aqu_pesticide_output(j)
    
      use output_ls_pesticide_module
      use aqu_pesticide_module
      use plant_module
      use plant_data_module
      use time_module
      use basin_module
      use output_landscape_module
      use constituent_mass_module
      use hydrograph_module, only : sp_ob1, ob
      
      implicit none
      
      integer :: ipest = 0              !!none       | pesticide species counter
      integer :: j                      !!none       | aquifer index being processed
      integer :: iob = 0                !!none       | object identifier for GIS mapping
      real :: const = 0.                !!days       | time period constant for averaging calculations
      real :: stor_init = 0.            !!kg         | initial pesticide storage when resetting for next period
                         
      !! Remove legacy comment header
!!    ~ ~ ~ PURPOSE ~ ~ ~
!!    this subroutine outputs HRU variables on daily, monthly and annual time steps
     
      !! Calculate object identifier for GIS referencing
      iob = sp_ob1%aqu + j - 1
          
      !! Process pesticide mass balance output for each pesticide species
      !! print balance for each pesticide
      do ipest = 1, cs_db%num_pests
          
        !! Accumulate daily pesticide data to monthly totals
       aqupst_m(j)%pest(ipest) = aqupst_m(j)%pest(ipest) + aqupst_d(j)%pest(ipest)

        !! Generate daily pesticide output reports when requested
      !! daily print
        if (pco%day_print == "y" .and. pco%int_day_cur == pco%int_day) then
          if (pco%pest%d == "y") then
             !! Write fixed-format daily output with time stamps and pesticide balance
             write (3008,100) time%day, time%mo, time%day_mo, time%yrc, j, ob(iob)%gis_id, ob(iob)%name, cs_db%pests(ipest),&
               aqupst_d(j)%pest(ipest)   !! pesticide balance
             !! Write CSV-format daily output when CSV option is enabled
             if (pco%csvout == "y") then
               write (3012,'(*(G0.3,:","))') time%day, time%mo, time%day_mo, time%yrc, j, ob(iob)%gis_id, ob(iob)%name, &
                    cs_db%pests(ipest), aqupst_d(j)%pest(ipest)
             end if
          end if
        end if
        
        !! Process monthly accumulation and output at end of month
        !! check end of month
        if (time%end_mo == 1) then
          !! Accumulate monthly data to yearly totals
          aqupst_y(j)%pest(ipest) = aqupst_y(j)%pest(ipest) + aqupst_m(j)%pest(ipest)
          !! Calculate number of days in current month for averaging
          const = float (ndays(time%mo + 1) - ndays(time%mo))
          !! Apply monthly averaging to pesticide balance components
          aqupst_m(j)%pest(ipest) = aqupst_m(j)%pest(ipest) // const
          !! Set final storage for monthly reporting
          aqupst_m(j)%pest(ipest)%stor_final = aqupst_d(j)%pest(ipest)%stor_final

          !! Generate monthly pesticide output reports when requested
          !! monthly print
           if (pco%pest%m == "y") then
             !! Write fixed-format monthly output
             write (3009,100) time%day, time%mo, time%day_mo, time%yrc, j, ob(iob)%gis_id, ob(iob)%name, cs_db%pests(ipest), &
               aqupst_m(j)%pest(ipest)
               !! Write CSV-format monthly output when CSV option is enabled
               if (pco%csvout == "y") then
                 write (3013,'(*(G0.3,:","))') time%day, time%mo, time%day_mo, time%yrc, j, ob(iob)%gis_id, ob(iob)%name, &
                   cs_db%pests(ipest), aqupst_m(j)%pest(ipest)
               end if
           end if
          !! Reset monthly arrays and initialize for next month
          !! reset pesticide at start of next time step
          stor_init = aqupst_d(j)%pest(ipest)%stor_final
          aqupst_m(j)%pest(ipest) = aqu_pestbz
          aqupst_m(j)%pest(ipest)%stor_init = stor_init
        end if
        
        !! Process yearly accumulation and output at end of year
        !! check end of year
        if (time%end_yr == 1) then
          !! Accumulate yearly data to average annual totals
          aqupst_a(j)%pest(ipest) = aqupst_a(j)%pest(ipest) + aqupst_y(j)%pest(ipest)
          !! Calculate number of days in current year for averaging
          const = time%day_end_yr
          !! Apply yearly averaging to pesticide balance components
          aqupst_y(j)%pest(ipest) = aqupst_y(j)%pest(ipest) // const
          !! Set final storage for yearly reporting
          aqupst_y(j)%pest(ipest)%stor_final = aqupst_d(j)%pest(ipest)%stor_final

          !! Generate yearly pesticide output reports when requested
          !! yearly print
           if (time%end_yr == 1 .and. pco%pest%y == "y") then
             !! Write fixed-format yearly output
             write (3010,100) time%day, time%mo, time%day_mo, time%yrc, j, ob(iob)%gis_id, ob(iob)%name, cs_db%pests(ipest), &
               aqupst_y(j)%pest(ipest)
               !! Write CSV-format yearly output when CSV option is enabled
               if (pco%csvout == "y") then
                 write (3014,'(*(G0.3,:","))') time%day, time%mo, time%day_mo, time%yrc, j, ob(iob)%gis_id, ob(iob)%name, &
                   cs_db%pests(ipest), aqupst_y(j)%pest(ipest)
               end if
           end if
          !! Reset yearly arrays and initialize for next year
          !! reset pesticide at start of next time step
          stor_init = aqupst_d(j)%pest(ipest)%stor_final
          aqupst_y(j)%pest(ipest) = aqu_pestbz
          aqupst_y(j)%pest(ipest)%stor_init = stor_init
        end if
        
        !! Generate average annual output at end of simulation
         !! average annual print
         if (time%end_sim == 1 .and. pco%pest%a == "y") then
           !! Calculate average annual values by dividing totals by simulation period
           aqupst_a(j)%pest(ipest) = aqupst_a(j)%pest(ipest) / time%yrs_prt
           !! Apply average annual time averaging across all print days
           aqupst_a(j)%pest(ipest) = aqupst_a(j)%pest(ipest) // time%days_prt
           !! Set final storage for average annual reporting
           aqupst_a(j)%pest(ipest)%stor_final = aqupst_d(j)%pest(ipest)%stor_final
           !! Write fixed-format average annual output
           write (3011,100) time%day, time%mo, time%day_mo, time%yrc, j, ob(iob)%gis_id, ob(iob)%name, cs_db%pests(ipest), &
             aqupst_a(j)%pest(ipest)
           !! Write CSV-format average annual output when CSV option is enabled
           if (pco%csvout == "y") then
             write (3015,'(*(G0.3,:","))') time%day, time%mo, time%day_mo, time%yrc, j, ob(iob)%gis_id, ob(iob)%name, &
               cs_db%pests(ipest), aqupst_a(j)%pest(ipest)
           end if
           
         end if

      end do    !! Complete pesticide species loop
      return
      
      !! Output format specification for all time scale reports
100   format (4i6,2i8,2x,2a,13e12.4)      

      end subroutine aqu_pesticide_output