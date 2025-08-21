!!@summary Format and output constituent mass balance data for aquifers at multiple time scales
!!@description This subroutine handles the comprehensive output of constituent mass balance data for a specific aquifer
!! across daily, monthly, yearly, and average annual time scales. It accumulates mass flux data (discharge to
!! groundwater, recharge, seepage, irrigation, diversions) and state variables (storage mass, concentrations,
!! sorbed mass) from daily to longer-term summaries. The subroutine includes chemical transformations through
!! sorption and reactions. Output formatting includes both fixed-format and CSV options for data analysis.
!! Time averaging is applied appropriately for extensive vs intensive variables.
!!@arguments
!! - iaq: Aquifer index number for the specific aquifer object being processed
      subroutine aqu_cs_output(iaq) !rtb cs
    
      use time_module
      use basin_module
      use aquifer_module
      use hydrograph_module, only : ob, sp_ob1
      use cs_aquifer
      use constituent_mass_module
      
      implicit none
      
      integer, intent (in) :: iaq        !!none       | aquifer index number for output processing
      real :: const = 0.                 !!days       | time period constant for averaging calculations
      integer :: iob = 0                 !!none       | object identifier for GIS mapping
      integer :: ics = 0                 !!none       | constituent species counter
                         
      !! Remove legacy comment header
!!    ~ ~ ~ PURPOSE ~ ~ ~
!!    this subroutine outputs constituent mass loadings and concentrations in aquifers

      !! Calculate object identifier for GIS referencing
      iob = sp_ob1%aqu + iaq - 1
          
      !! Accumulate daily constituent mass balance data to monthly totals
      !add daily values to monthly values
      do ics=1,cs_db%num_cs
        !! Sum daily discharge to groundwater for each constituent
        acsb_m(iaq)%cs(ics)%csgw = acsb_m(iaq)%cs(ics)%csgw + acsb_d(iaq)%cs(ics)%csgw
        !! Sum daily recharge loading for each constituent
        acsb_m(iaq)%cs(ics)%rchrg = acsb_m(iaq)%cs(ics)%rchrg + acsb_d(iaq)%cs(ics)%rchrg
        !! Sum daily seepage losses for each constituent
        acsb_m(iaq)%cs(ics)%seep = acsb_m(iaq)%cs(ics)%seep + acsb_d(iaq)%cs(ics)%seep
        !! Sum daily irrigation extractions for each constituent
        acsb_m(iaq)%cs(ics)%irr = acsb_m(iaq)%cs(ics)%irr + acsb_d(iaq)%cs(ics)%irr
        !! Sum daily diversions for each constituent
        acsb_m(iaq)%cs(ics)%div = acsb_m(iaq)%cs(ics)%div + acsb_d(iaq)%cs(ics)%div
        !! Sum daily sorption processes for each constituent
        acsb_m(iaq)%cs(ics)%sorb = acsb_m(iaq)%cs(ics)%sorb + acsb_d(iaq)%cs(ics)%sorb
        !! Sum daily chemical reaction processes for each constituent
        acsb_m(iaq)%cs(ics)%rctn = acsb_m(iaq)%cs(ics)%rctn + acsb_d(iaq)%cs(ics)%rctn
        !! Sum daily storage masses for monthly averaging
        acsb_m(iaq)%cs(ics)%mass = acsb_m(iaq)%cs(ics)%mass + acsb_d(iaq)%cs(ics)%mass
        !! Sum daily concentrations for monthly averaging
        acsb_m(iaq)%cs(ics)%conc = acsb_m(iaq)%cs(ics)%conc + acsb_d(iaq)%cs(ics)%conc
        !! Sum daily sorbed masses for monthly averaging
        acsb_m(iaq)%cs(ics)%srbd = acsb_m(iaq)%cs(ics)%srbd + acsb_d(iaq)%cs(ics)%srbd
      enddo
      
      !! Generate daily output reports when requested
      !daily print
      if (pco%cs_aqu%d == "y") then
        !! Write fixed-format daily output with time stamps and all constituent data
        write (6060,100) time%day, time%mo, time%day_mo, time%yrc, iaq, ob(iob)%gis_id, & 
                         (acsb_d(iaq)%cs(ics)%csgw,ics=1,cs_db%num_cs), &
                         (acsb_d(iaq)%cs(ics)%rchrg,ics=1,cs_db%num_cs), &
                         (acsb_d(iaq)%cs(ics)%seep,ics=1,cs_db%num_cs), &
                         (acsb_d(iaq)%cs(ics)%irr,ics=1,cs_db%num_cs), &
                         (acsb_d(iaq)%cs(ics)%div,ics=1,cs_db%num_cs), &
                         (acsb_d(iaq)%cs(ics)%sorb,ics=1,cs_db%num_cs), &
                         (acsb_d(iaq)%cs(ics)%rctn,ics=1,cs_db%num_cs), &
                         (acsb_d(iaq)%cs(ics)%mass,ics=1,cs_db%num_cs), &
                         (acsb_d(iaq)%cs(ics)%conc,ics=1,cs_db%num_cs), &
                         (acsb_d(iaq)%cs(ics)%srbd,ics=1,cs_db%num_cs)
        !! Write CSV-format daily output when CSV option is enabled
        if (pco%csvout == "y") then
          write (6061,'(*(G0.3,:","))') time%day, time%mo, time%day_mo, time%yrc, iaq, ob(iob)%gis_id, & 
                                                                           (acsb_d(iaq)%cs(ics)%csgw,ics=1,cs_db%num_cs), &
                                       (acsb_d(iaq)%cs(ics)%rchrg,ics=1,cs_db%num_cs), &
                                       (acsb_d(iaq)%cs(ics)%seep,ics=1,cs_db%num_cs), &
                                       (acsb_d(iaq)%cs(ics)%irr,ics=1,cs_db%num_cs), &
                                       (acsb_d(iaq)%cs(ics)%div,ics=1,cs_db%num_cs), &
                                       (acsb_d(iaq)%cs(ics)%sorb,ics=1,cs_db%num_cs), &
                                       (acsb_d(iaq)%cs(ics)%rctn,ics=1,cs_db%num_cs), &
                                       (acsb_d(iaq)%cs(ics)%mass,ics=1,cs_db%num_cs), &
                                       (acsb_d(iaq)%cs(ics)%conc,ics=1,cs_db%num_cs), &
                                       (acsb_d(iaq)%cs(ics)%srbd,ics=1,cs_db%num_cs)
        endif
      endif

      !! Process monthly output and accumulation at end of month
      !monthly print
      if (time%end_mo == 1) then

        !! Accumulate monthly data to yearly totals
        !add monthly values to yearly values
        do ics=1,cs_db%num_cs
          !! Sum monthly discharge to groundwater for yearly total
          acsb_y(iaq)%cs(ics)%csgw = acsb_y(iaq)%cs(ics)%csgw + acsb_m(iaq)%cs(ics)%csgw
          !! Sum monthly recharge for yearly total
          acsb_y(iaq)%cs(ics)%rchrg = acsb_y(iaq)%cs(ics)%rchrg + acsb_m(iaq)%cs(ics)%rchrg
          !! Sum monthly seepage for yearly total
          acsb_y(iaq)%cs(ics)%seep = acsb_y(iaq)%cs(ics)%seep + acsb_m(iaq)%cs(ics)%seep
          !! Sum monthly irrigation for yearly total
          acsb_y(iaq)%cs(ics)%irr = acsb_y(iaq)%cs(ics)%irr + acsb_m(iaq)%cs(ics)%irr
          !! Sum monthly diversions for yearly total
          acsb_y(iaq)%cs(ics)%div = acsb_y(iaq)%cs(ics)%div + acsb_m(iaq)%cs(ics)%div
          !! Sum monthly sorption for yearly total
          acsb_y(iaq)%cs(ics)%sorb = acsb_y(iaq)%cs(ics)%sorb + acsb_m(iaq)%cs(ics)%sorb
          !! Sum monthly reactions for yearly total
          acsb_y(iaq)%cs(ics)%rctn = acsb_y(iaq)%cs(ics)%rctn + acsb_m(iaq)%cs(ics)%rctn
          !! Sum monthly masses for yearly averaging
          acsb_y(iaq)%cs(ics)%mass = acsb_y(iaq)%cs(ics)%mass + acsb_m(iaq)%cs(ics)%mass
          !! Sum monthly concentrations for yearly averaging
          acsb_y(iaq)%cs(ics)%conc = acsb_y(iaq)%cs(ics)%conc + acsb_m(iaq)%cs(ics)%conc
          !! Sum monthly sorbed masses for yearly averaging
          acsb_y(iaq)%cs(ics)%srbd = acsb_y(iaq)%cs(ics)%srbd + acsb_m(iaq)%cs(ics)%srbd
        enddo
        !! Calculate number of days in current month for averaging
        const = float (ndays(time%mo + 1) - ndays(time%mo))
        !! Convert intensive variables (mass, concentration, sorbed) to monthly averages
        do ics=1,cs_db%num_cs !average mass, concentration and sorbed mass
          acsb_m(iaq)%cs(ics)%mass = acsb_m(iaq)%cs(ics)%mass / const
          acsb_m(iaq)%cs(ics)%conc = acsb_m(iaq)%cs(ics)%conc / const
          acsb_m(iaq)%cs(ics)%srbd = acsb_m(iaq)%cs(ics)%srbd / const
        enddo
        !! Generate monthly output reports when requested
        if (pco%cs_aqu%m == "y") then
          !! Write fixed-format monthly output
          write (6062,100) time%day, time%mo, time%day_mo, time%yrc, iaq, ob(iob)%gis_id, & 
                           (acsb_m(iaq)%cs(ics)%csgw,ics=1,cs_db%num_cs), &
                           (acsb_m(iaq)%cs(ics)%rchrg,ics=1,cs_db%num_cs), &
                           (acsb_m(iaq)%cs(ics)%seep,ics=1,cs_db%num_cs), &
                           (acsb_m(iaq)%cs(ics)%irr,ics=1,cs_db%num_cs), &
                           (acsb_m(iaq)%cs(ics)%div,ics=1,cs_db%num_cs), &
                           (acsb_m(iaq)%cs(ics)%sorb,ics=1,cs_db%num_cs), &
                           (acsb_m(iaq)%cs(ics)%rctn,ics=1,cs_db%num_cs), &
                           (acsb_m(iaq)%cs(ics)%mass,ics=1,cs_db%num_cs), &
                           (acsb_m(iaq)%cs(ics)%conc,ics=1,cs_db%num_cs), &
                           (acsb_m(iaq)%cs(ics)%srbd,ics=1,cs_db%num_cs)
          !! Write CSV-format monthly output when CSV option is enabled
          if (pco%csvout == "y") then
            write (6063,'(*(G0.3,:","))') time%day, time%mo, time%day_mo, time%yrc, iaq, ob(iob)%gis_id, & 
                                         (acsb_m(iaq)%cs(ics)%csgw,ics=1,cs_db%num_cs), &
                                         (acsb_m(iaq)%cs(ics)%rchrg,ics=1,cs_db%num_cs), &
                                         (acsb_m(iaq)%cs(ics)%seep,ics=1,cs_db%num_cs), &
                                         (acsb_m(iaq)%cs(ics)%irr,ics=1,cs_db%num_cs), &
                                         (acsb_m(iaq)%cs(ics)%div,ics=1,cs_db%num_cs), &
                                         (acsb_m(iaq)%cs(ics)%sorb,ics=1,cs_db%num_cs), &
                                         (acsb_m(iaq)%cs(ics)%rctn,ics=1,cs_db%num_cs), &
                                         (acsb_m(iaq)%cs(ics)%mass,ics=1,cs_db%num_cs), &
                                         (acsb_m(iaq)%cs(ics)%conc,ics=1,cs_db%num_cs), &
                                         (acsb_m(iaq)%cs(ics)%srbd,ics=1,cs_db%num_cs)
          endif
        endif
        !! Reset monthly accumulators to zero for next month
        !zero out
        do ics=1,cs_db%num_cs
          acsb_m(iaq)%cs(ics)%csgw = 0.
          acsb_m(iaq)%cs(ics)%rchrg = 0.
          acsb_m(iaq)%cs(ics)%seep = 0.
          acsb_m(iaq)%cs(ics)%irr = 0.
          acsb_m(iaq)%cs(ics)%div = 0.
          acsb_m(iaq)%cs(ics)%sorb = 0.
          acsb_m(iaq)%cs(ics)%rctn = 0.
          acsb_m(iaq)%cs(ics)%mass = 0.
          acsb_m(iaq)%cs(ics)%conc = 0.
          acsb_m(iaq)%cs(ics)%srbd = 0.
        enddo
      endif
      
      !! Process yearly output and accumulation at end of year
      !yearly print
      if (time%end_yr == 1) then
        !! Accumulate yearly data to long-term totals for average annual calculations
        !add yearly values to total values
        do ics=1,cs_db%num_cs
          !! Sum yearly discharge to groundwater for average annual total
          acsb_a(iaq)%cs(ics)%csgw = acsb_a(iaq)%cs(ics)%csgw + acsb_y(iaq)%cs(ics)%csgw
          !! Sum yearly recharge for average annual total
          acsb_a(iaq)%cs(ics)%rchrg = acsb_a(iaq)%cs(ics)%rchrg + acsb_y(iaq)%cs(ics)%rchrg
          !! Sum yearly seepage for average annual total
          acsb_a(iaq)%cs(ics)%seep = acsb_a(iaq)%cs(ics)%seep + acsb_y(iaq)%cs(ics)%seep
          !! Sum yearly irrigation for average annual total
          acsb_a(iaq)%cs(ics)%irr = acsb_a(iaq)%cs(ics)%irr + acsb_y(iaq)%cs(ics)%irr
          !! Sum yearly diversions for average annual total
          acsb_a(iaq)%cs(ics)%div = acsb_a(iaq)%cs(ics)%div + acsb_y(iaq)%cs(ics)%div
          !! Sum yearly sorption for average annual total
          acsb_a(iaq)%cs(ics)%sorb = acsb_a(iaq)%cs(ics)%sorb + acsb_y(iaq)%cs(ics)%sorb
          !! Sum yearly reactions for average annual total
          acsb_a(iaq)%cs(ics)%rctn = acsb_a(iaq)%cs(ics)%rctn + acsb_y(iaq)%cs(ics)%rctn
          !! Sum yearly masses for average annual averaging
          acsb_a(iaq)%cs(ics)%mass = acsb_a(iaq)%cs(ics)%mass + acsb_y(iaq)%cs(ics)%mass
          !! Sum yearly concentrations for average annual averaging
          acsb_a(iaq)%cs(ics)%conc = acsb_a(iaq)%cs(ics)%conc + acsb_y(iaq)%cs(ics)%conc
          !! Sum yearly sorbed masses for average annual averaging
          acsb_a(iaq)%cs(ics)%srbd = acsb_a(iaq)%cs(ics)%srbd + acsb_y(iaq)%cs(ics)%srbd
        enddo
        !! Calculate number of days in current year for averaging
        const = time%day_end_yr
        !! Convert intensive variables (mass, concentration, sorbed) to yearly averages
        do ics=1,cs_db%num_cs !average mass, concentration and sorbed mass
          acsb_y(iaq)%cs(ics)%mass = acsb_y(iaq)%cs(ics)%mass / const
          acsb_y(iaq)%cs(ics)%conc = acsb_y(iaq)%cs(ics)%conc / const
          acsb_y(iaq)%cs(ics)%srbd = acsb_y(iaq)%cs(ics)%srbd / const
        enddo
        !! Generate yearly output reports when requested
        if (pco%cs_aqu%y == "y") then
          !! Write fixed-format yearly output
          write (6064,100) time%day, time%mo, time%day_mo, time%yrc, iaq, ob(iob)%gis_id, & 
                           (acsb_y(iaq)%cs(ics)%csgw,ics=1,cs_db%num_cs), &
                           (acsb_y(iaq)%cs(ics)%rchrg,ics=1,cs_db%num_cs), &
                           (acsb_y(iaq)%cs(ics)%seep,ics=1,cs_db%num_cs), &
                           (acsb_y(iaq)%cs(ics)%irr,ics=1,cs_db%num_cs), &
                           (acsb_y(iaq)%cs(ics)%div,ics=1,cs_db%num_cs), &
                           (acsb_y(iaq)%cs(ics)%sorb,ics=1,cs_db%num_cs), &
                           (acsb_y(iaq)%cs(ics)%rctn,ics=1,cs_db%num_cs), &
                           (acsb_y(iaq)%cs(ics)%mass,ics=1,cs_db%num_cs), &
                           (acsb_y(iaq)%cs(ics)%conc,ics=1,cs_db%num_cs), &
                           (acsb_y(iaq)%cs(ics)%srbd,ics=1,cs_db%num_cs)
          !! Write CSV-format yearly output when CSV option is enabled
          if (pco%csvout == "y") then
            write (6065,'(*(G0.3,:","))') time%day, time%mo, time%day_mo, time%yrc, iaq, ob(iob)%gis_id, & 
                                         (acsb_y(iaq)%cs(ics)%csgw,ics=1,cs_db%num_cs), &
                                         (acsb_y(iaq)%cs(ics)%rchrg,ics=1,cs_db%num_cs), &
                                         (acsb_y(iaq)%cs(ics)%seep,ics=1,cs_db%num_cs), &
                                         (acsb_y(iaq)%cs(ics)%irr,ics=1,cs_db%num_cs), &
                                         (acsb_y(iaq)%cs(ics)%div,ics=1,cs_db%num_cs), &
                                         (acsb_y(iaq)%cs(ics)%sorb,ics=1,cs_db%num_cs), &
                                         (acsb_y(iaq)%cs(ics)%rctn,ics=1,cs_db%num_cs), &
                                         (acsb_y(iaq)%cs(ics)%mass,ics=1,cs_db%num_cs), &
                                         (acsb_y(iaq)%cs(ics)%conc,ics=1,cs_db%num_cs), &
                                         (acsb_y(iaq)%cs(ics)%srbd,ics=1,cs_db%num_cs)
          endif
        endif
        !! Reset yearly accumulators to zero for next year
        !zero out
        do ics=1,cs_db%num_cs
          acsb_y(iaq)%cs(ics)%csgw = 0.
          acsb_y(iaq)%cs(ics)%rchrg = 0.
          acsb_y(iaq)%cs(ics)%seep = 0.
          acsb_y(iaq)%cs(ics)%irr = 0.
          acsb_y(iaq)%cs(ics)%div = 0.
          acsb_y(iaq)%cs(ics)%sorb = 0.
          acsb_y(iaq)%cs(ics)%rctn = 0.
          acsb_y(iaq)%cs(ics)%mass = 0.
          acsb_y(iaq)%cs(ics)%conc = 0.
          acsb_y(iaq)%cs(ics)%srbd = 0.
        enddo
      endif
      
      !! Generate average annual output at end of simulation
      !average annual print
      if (time%end_sim == 1 .and. pco%cs_aqu%a == "y") then
        !! Calculate average annual values by dividing totals by number of years
        !calculate average annual values
        do ics=1,cs_db%num_cs
          !! Calculate average annual discharge to groundwater
          acsb_a(iaq)%cs(ics)%csgw = acsb_a(iaq)%cs(ics)%csgw / time%nbyr
          !! Calculate average annual recharge
          acsb_a(iaq)%cs(ics)%rchrg = acsb_a(iaq)%cs(ics)%rchrg / time%nbyr
          !! Calculate average annual seepage
          acsb_a(iaq)%cs(ics)%seep = acsb_a(iaq)%cs(ics)%seep / time%nbyr
          !! Calculate average annual irrigation
          acsb_a(iaq)%cs(ics)%irr = acsb_a(iaq)%cs(ics)%irr / time%nbyr
          !! Calculate average annual diversions
          acsb_a(iaq)%cs(ics)%div = acsb_a(iaq)%cs(ics)%div / time%nbyr
          !! Calculate average annual sorption
          acsb_a(iaq)%cs(ics)%sorb = acsb_a(iaq)%cs(ics)%sorb / time%nbyr
          !! Calculate average annual reactions
          acsb_a(iaq)%cs(ics)%rctn = acsb_a(iaq)%cs(ics)%rctn / time%nbyr
          !! Calculate average annual mass
          acsb_a(iaq)%cs(ics)%mass = acsb_a(iaq)%cs(ics)%mass / time%nbyr
          !! Calculate average annual concentration
          acsb_a(iaq)%cs(ics)%conc = acsb_a(iaq)%cs(ics)%conc / time%nbyr
          !! Calculate average annual sorbed mass
          acsb_a(iaq)%cs(ics)%srbd = acsb_a(iaq)%cs(ics)%srbd / time%nbyr
        enddo
        !! Write fixed-format average annual output
        write (6066,100) time%day, time%mo, time%day_mo, time%yrc, iaq, ob(iob)%gis_id, & 
                        (acsb_a(iaq)%cs(ics)%csgw,ics=1,cs_db%num_cs), &
                        (acsb_a(iaq)%cs(ics)%rchrg,ics=1,cs_db%num_cs), &
                        (acsb_a(iaq)%cs(ics)%seep,ics=1,cs_db%num_cs), &
                        (acsb_a(iaq)%cs(ics)%irr,ics=1,cs_db%num_cs), &
                        (acsb_a(iaq)%cs(ics)%div,ics=1,cs_db%num_cs), &
                        (acsb_a(iaq)%cs(ics)%sorb,ics=1,cs_db%num_cs), &
                        (acsb_a(iaq)%cs(ics)%rctn,ics=1,cs_db%num_cs), &
                        (acsb_a(iaq)%cs(ics)%mass,ics=1,cs_db%num_cs), &
                        (acsb_a(iaq)%cs(ics)%conc,ics=1,cs_db%num_cs), &
                        (acsb_a(iaq)%cs(ics)%srbd,ics=1,cs_db%num_cs)
        !! Write CSV-format average annual output when CSV option is enabled
        if (pco%csvout == "y") then
          write (6067,'(*(G0.3,:","))') time%day, time%mo, time%day_mo, time%yrc, iaq, ob(iob)%gis_id, & 
                                        (acsb_a(iaq)%cs(ics)%csgw,ics=1,cs_db%num_cs), &
                                        (acsb_a(iaq)%cs(ics)%rchrg,ics=1,cs_db%num_cs), &
                                        (acsb_a(iaq)%cs(ics)%seep,ics=1,cs_db%num_cs), &
                                        (acsb_a(iaq)%cs(ics)%irr,ics=1,cs_db%num_cs), &
                                        (acsb_a(iaq)%cs(ics)%div,ics=1,cs_db%num_cs), &
                                        (acsb_a(iaq)%cs(ics)%sorb,ics=1,cs_db%num_cs), &
                                        (acsb_a(iaq)%cs(ics)%rctn,ics=1,cs_db%num_cs), &
                                        (acsb_a(iaq)%cs(ics)%mass,ics=1,cs_db%num_cs), &
                                        (acsb_a(iaq)%cs(ics)%conc,ics=1,cs_db%num_cs), &
                                        (acsb_a(iaq)%cs(ics)%srbd,ics=1,cs_db%num_cs)
        endif
      endif

      
      return
      
      !! Output format specification for all time scale reports
100   format (4i6,2i8,500e18.7)      

      end subroutine aqu_cs_output