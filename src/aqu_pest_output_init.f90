!!@summary Initialize aquifer pesticide output arrays with current storage values for all reporting time scales
!!@description This subroutine sets the initial pesticide storage values for output reporting at the beginning
!! of each output period across daily, monthly, yearly, and average annual time scales. It initializes
!! both individual aquifer pesticide storage values and basin-wide totals by summing across all aquifers.
!! The initialization ensures accurate mass balance reporting by capturing the starting pesticide inventory
!! before simulation processes modify storage values. These initial values are used in output calculations
!! to track net changes in pesticide storage over each reporting period.
!!@arguments
!! None - operates on global aquifer pesticide arrays and constituent database structures
      subroutine aqu_pest_output_init
      
      use aqu_pesticide_module
      use constituent_mass_module
      use hydrograph_module, only : sp_ob
      
      implicit none      

      integer :: ipest = 0              !!none         | pesticide species counter
      integer :: iaq = 0                !!none         | aquifer object counter
      
      !! Initialize pesticide storage values for all aquifers and time scales
      !! set initial aquifer pesticides at beginning of output for monthly, annual and average annual
      do iaq = 1, sp_ob%aqu
          
        !! Reset basin-wide pesticide storage initialization arrays to zero
        !! zero initial basin pesticides (for printing)
        do ipest = 1, cs_db%num_pests
          baqupst_d%pest(ipest)%stor_init = 0.
          baqupst_m%pest(ipest)%stor_init = 0.
          baqupst_y%pest(ipest)%stor_init = 0.
          baqupst_a%pest(ipest)%stor_init = 0.
        end do
          
        !! Set individual aquifer initial pesticide storage and accumulate basin totals
        do ipest = 1, cs_db%num_pests
          !! Set current pesticide storage as initial values for all time scales
          !! set initial aquifer pesticides (for printing)
          aqupst_d(iaq)%pest(ipest)%stor_init = cs_aqu(iaq)%pest(ipest)
          aqupst_m(iaq)%pest(ipest)%stor_init = cs_aqu(iaq)%pest(ipest)
          aqupst_y(iaq)%pest(ipest)%stor_init = cs_aqu(iaq)%pest(ipest)
          aqupst_a(iaq)%pest(ipest)%stor_init = cs_aqu(iaq)%pest(ipest)
          !! Accumulate individual aquifer pesticide storage to basin-wide totals
          !! sum initial basin pesticides (for printing)
          baqupst_d%pest(ipest)%stor_init = baqupst_d%pest(ipest)%stor_init + cs_aqu(iaq)%pest(ipest)
          baqupst_m%pest(ipest)%stor_init = baqupst_m%pest(ipest)%stor_init + cs_aqu(iaq)%pest(ipest)
          baqupst_y%pest(ipest)%stor_init = baqupst_y%pest(ipest)%stor_init + cs_aqu(iaq)%pest(ipest)
          baqupst_a%pest(ipest)%stor_init = baqupst_a%pest(ipest)%stor_init + cs_aqu(iaq)%pest(ipest)
        end do

      end do

      return
      end subroutine aqu_pest_output_init