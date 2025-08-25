      subroutine water_treatment_output

      use time_module
      use water_allocation_module
      use maximum_data_module
      use basin_module
      
      implicit none
      
      integer :: iwtp = 0
      integer :: iwuse = 0

      !! water treatment plant outputs
      if (db_mx%wtp_db > 0) then
        do iwtp = 1, db_mx%wtp_db
        
          !! sum monthly and yearly outputs
          wtpm_out(iwtp) = wtpm_out(iwtp) + wtpd_out(iwtp)
          wtpy_out(iwtp) = wtpy_out(iwtp) + wtpd_out(iwtp)

          !! daily print
          if (pco%water_allo%d == "y") then
            write (3118,100) time%day, time%mo, time%day_mo, time%yrc, iwtp, wtp(iwtp)%name, &
                wtpd_out(iwtp)%inflow, wtpd_out(iwtp)%outflow, wtpd_out(iwtp)%storage, &
                wtp(iwtp)%stor_mx, wtpd_out(iwtp)%overflow, wtpd_out(iwtp)%loss, &
                wtpd_out(iwtp)%release_frac, wtp(iwtp)%lag_days

            if (pco%csvout == "y") then
              write (3122,'(*(G0.3,:","))') time%day, time%mo, time%day_mo, time%yrc, iwtp, &
                  trim(wtp(iwtp)%name), wtpd_out(iwtp)%inflow, wtpd_out(iwtp)%outflow, &
                  wtpd_out(iwtp)%storage, wtp(iwtp)%stor_mx, wtpd_out(iwtp)%overflow, &
                  wtpd_out(iwtp)%loss, wtpd_out(iwtp)%release_frac, wtp(iwtp)%lag_days
            end if
          end if
         
          !! reset daily output
          wtpd_out(iwtp) = wtp_out_zero

          !! monthly print
          if (time%end_mo == 1) then
            if (pco%water_allo%m == "y") then
              write (3119,100) time%day, time%mo, time%day_mo, time%yrc, iwtp, wtp(iwtp)%name, &
                  wtpm_out(iwtp)%inflow, wtpm_out(iwtp)%outflow, wtpm_out(iwtp)%storage, &
                  wtp(iwtp)%stor_mx, wtpm_out(iwtp)%overflow, wtpm_out(iwtp)%loss, &
                  wtpm_out(iwtp)%release_frac, wtp(iwtp)%lag_days

              if (pco%csvout == "y") then
                write (3123,'(*(G0.3,:","))') time%day, time%mo, time%day_mo, time%yrc, iwtp, &
                    trim(wtp(iwtp)%name), wtpm_out(iwtp)%inflow, wtpm_out(iwtp)%outflow, &
                    wtpm_out(iwtp)%storage, wtp(iwtp)%stor_mx, wtpm_out(iwtp)%overflow, &
                    wtpm_out(iwtp)%loss, wtpm_out(iwtp)%release_frac, wtp(iwtp)%lag_days
              end if
            end if

            !! sum yearly output and reset monthly
            wtpy_out(iwtp) = wtpy_out(iwtp) + wtpm_out(iwtp)
            wtpm_out(iwtp) = wtp_out_zero
          end if

          !! yearly print
          if (time%end_yr == 1) then
            if (pco%water_allo%y == "y") then
              write (3120,100) time%day, time%mo, time%day_mo, time%yrc, iwtp, wtp(iwtp)%name, &
                  wtpy_out(iwtp)%inflow, wtpy_out(iwtp)%outflow, wtpy_out(iwtp)%storage, &
                  wtp(iwtp)%stor_mx, wtpy_out(iwtp)%overflow, wtpy_out(iwtp)%loss, &
                  wtpy_out(iwtp)%release_frac, wtp(iwtp)%lag_days

              if (pco%csvout == "y") then
                write (3124,'(*(G0.3,:","))') time%day, time%mo, time%day_mo, time%yrc, iwtp, &
                    trim(wtp(iwtp)%name), wtpy_out(iwtp)%inflow, wtpy_out(iwtp)%outflow, &
                    wtpy_out(iwtp)%storage, wtp(iwtp)%stor_mx, wtpy_out(iwtp)%overflow, &
                    wtpy_out(iwtp)%loss, wtpy_out(iwtp)%release_frac, wtp(iwtp)%lag_days
              end if
            end if

            !! sum average annual output and reset yearly
            wtpa_out(iwtp) = wtpa_out(iwtp) + wtpy_out(iwtp)
            wtpy_out(iwtp) = wtp_out_zero
          end if

          !! average annual print
          if (time%end_sim == 1) then
            !! divide by number of years for average
            wtpa_out(iwtp) = wtpa_out(iwtp) / time%yrs_prt

            if (pco%water_allo%a == "y") then
              write (3121,100) time%day, time%mo, time%day_mo, time%yrc, iwtp, wtp(iwtp)%name, &
                  wtpa_out(iwtp)%inflow, wtpa_out(iwtp)%outflow, wtpa_out(iwtp)%storage, &
                  wtp(iwtp)%stor_mx, wtpa_out(iwtp)%overflow, wtpa_out(iwtp)%loss, &
                  wtpa_out(iwtp)%release_frac, wtp(iwtp)%lag_days

              if (pco%csvout == "y") then
                write (3125,'(*(G0.3,:","))') time%day, time%mo, time%day_mo, time%yrc, iwtp, &
                    trim(wtp(iwtp)%name), wtpa_out(iwtp)%inflow, wtpa_out(iwtp)%outflow, &
                    wtpa_out(iwtp)%storage, wtp(iwtp)%stor_mx, wtpa_out(iwtp)%overflow, &
                    wtpa_out(iwtp)%loss, wtpa_out(iwtp)%release_frac, wtp(iwtp)%lag_days
              end if
            end if
          end if

        end do    ! do iwtp = 1, db_mx%wtp_db
      end if

      !! water use plant outputs (similar structure)
      if (db_mx%wuse_db > 0) then
        do iwuse = 1, db_mx%wuse_db
        
          !! sum monthly and yearly outputs
          wusem_out(iwuse) = wusem_out(iwuse) + wused_out(iwuse)
          wusey_out(iwuse) = wusey_out(iwuse) + wused_out(iwuse)

          !! daily print
          if (pco%water_allo%d == "y") then
            write (3118,200) time%day, time%mo, time%day_mo, time%yrc, iwuse, wuse(iwuse)%name, &
                wused_out(iwuse)%inflow, wused_out(iwuse)%outflow, wused_out(iwuse)%storage, &
                wuse(iwuse)%stor_mx, wused_out(iwuse)%overflow, wused_out(iwuse)%loss, &
                wused_out(iwuse)%release_frac, wuse(iwuse)%lag_days

            if (pco%csvout == "y") then
              write (3122,'(*(G0.3,:","))') time%day, time%mo, time%day_mo, time%yrc, iwuse, &
                  trim(wuse(iwuse)%name), wused_out(iwuse)%inflow, wused_out(iwuse)%outflow, &
                  wused_out(iwuse)%storage, wuse(iwuse)%stor_mx, wused_out(iwuse)%overflow, &
                  wused_out(iwuse)%loss, wused_out(iwuse)%release_frac, wuse(iwuse)%lag_days
            end if
          end if
         
          !! reset daily output
          wused_out(iwuse) = wtp_out_zero

          !! monthly print
          if (time%end_mo == 1) then
            if (pco%water_allo%m == "y") then
              write (3119,200) time%day, time%mo, time%day_mo, time%yrc, iwuse, wuse(iwuse)%name, &
                  wusem_out(iwuse)%inflow, wusem_out(iwuse)%outflow, wusem_out(iwuse)%storage, &
                  wuse(iwuse)%stor_mx, wusem_out(iwuse)%overflow, wusem_out(iwuse)%loss, &
                  wusem_out(iwuse)%release_frac, wuse(iwuse)%lag_days

              if (pco%csvout == "y") then
                write (3123,'(*(G0.3,:","))') time%day, time%mo, time%day_mo, time%yrc, iwuse, &
                    trim(wuse(iwuse)%name), wusem_out(iwuse)%inflow, wusem_out(iwuse)%outflow, &
                    wusem_out(iwuse)%storage, wuse(iwuse)%stor_mx, wusem_out(iwuse)%overflow, &
                    wusem_out(iwuse)%loss, wusem_out(iwuse)%release_frac, wuse(iwuse)%lag_days
              end if
            end if

            !! reset monthly output
            wusem_out(iwuse) = wtp_out_zero
          end if

          !! yearly print
          if (time%end_yr == 1) then
            if (pco%water_allo%y == "y") then
              write (3120,200) time%day, time%mo, time%day_mo, time%yrc, iwuse, wuse(iwuse)%name, &
                  wusey_out(iwuse)%inflow, wusey_out(iwuse)%outflow, wusey_out(iwuse)%storage, &
                  wuse(iwuse)%stor_mx, wusey_out(iwuse)%overflow, wusey_out(iwuse)%loss, &
                  wusey_out(iwuse)%release_frac, wuse(iwuse)%lag_days

              if (pco%csvout == "y") then
                write (3124,'(*(G0.3,:","))') time%day, time%mo, time%day_mo, time%yrc, iwuse, &
                    trim(wuse(iwuse)%name), wusey_out(iwuse)%inflow, wusey_out(iwuse)%outflow, &
                    wusey_out(iwuse)%storage, wuse(iwuse)%stor_mx, wusey_out(iwuse)%overflow, &
                    wusey_out(iwuse)%loss, wusey_out(iwuse)%release_frac, wuse(iwuse)%lag_days
              end if
            end if

            !! reset yearly output
            wusey_out(iwuse) = wtp_out_zero
          end if

          !! average annual print
          if (time%end_sim == 1) then
            !! divide by number of years for average
            wusea_out(iwuse) = wusea_out(iwuse) / time%yrs_prt

            if (pco%water_allo%a == "y") then
              write (3121,200) time%day, time%mo, time%day_mo, time%yrc, iwuse, wuse(iwuse)%name, &
                  wusea_out(iwuse)%inflow, wusea_out(iwuse)%outflow, wusea_out(iwuse)%storage, &
                  wuse(iwuse)%stor_mx, wusea_out(iwuse)%overflow, wusea_out(iwuse)%loss, &
                  wusea_out(iwuse)%release_frac, wuse(iwuse)%lag_days

              if (pco%csvout == "y") then
                write (3125,'(*(G0.3,:","))') time%day, time%mo, time%day_mo, time%yrc, iwuse, &
                    trim(wuse(iwuse)%name), wusea_out(iwuse)%inflow, wusea_out(iwuse)%outflow, &
                    wusea_out(iwuse)%storage, wuse(iwuse)%stor_mx, wusea_out(iwuse)%overflow, &
                    wusea_out(iwuse)%loss, wusea_out(iwuse)%release_frac, wuse(iwuse)%lag_days
              end if
            end if
          end if

        end do    ! do iwuse = 1, db_mx%wuse_db
      end if
      
      return
      
100   format (4i6,i8,5x,a25,8f15.3)       !! treatment plant output format
200   format (4i6,i8,5x,a25,8f15.3)       !! water use output format (same as treatment)
      end subroutine water_treatment_output