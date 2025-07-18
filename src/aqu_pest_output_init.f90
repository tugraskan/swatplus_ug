!!@summary Initialize pesticide output tracking for aquifers
!!@description
!! Resets daily, monthly and annual pesticide storage values
!! for both basin totals and individual aquifers.
!!@arguments
!!    (none) | in/out | module variables used
      subroutine aqu_pest_output_init
      
      use aqu_pesticide_module
      use constituent_mass_module
      use hydrograph_module, only : sp_ob
      
      implicit none      

      integer :: ipest = 0              !!none | pesticide counter
      integer :: iaq = 0                !!none | aquifer counter
      
      !! set initial aquifer pesticides at beginning of output for monthly, annual and average annual
      !! loop through each aquifer
      do iaq = 1, sp_ob%aqu
          
        !! zero initial basin pesticides (for printing)
        !! zero initial basin pesticides (for printing)
        do ipest = 1, cs_db%num_pests
          baqupst_d%pest(ipest)%stor_init = 0.
          baqupst_m%pest(ipest)%stor_init = 0.
          baqupst_y%pest(ipest)%stor_init = 0.
          baqupst_a%pest(ipest)%stor_init = 0.
        end do
          
        do ipest = 1, cs_db%num_pests
          !! set initial aquifer pesticides (for printing)
          aqupst_d(iaq)%pest(ipest)%stor_init = cs_aqu(iaq)%pest(ipest)
          aqupst_m(iaq)%pest(ipest)%stor_init = cs_aqu(iaq)%pest(ipest)
          aqupst_y(iaq)%pest(ipest)%stor_init = cs_aqu(iaq)%pest(ipest)
          aqupst_a(iaq)%pest(ipest)%stor_init = cs_aqu(iaq)%pest(ipest)
          !! sum initial basin pesticides (for printing)
          baqupst_d%pest(ipest)%stor_init = baqupst_d%pest(ipest)%stor_init + cs_aqu(iaq)%pest(ipest)
          baqupst_m%pest(ipest)%stor_init = baqupst_m%pest(ipest)%stor_init + cs_aqu(iaq)%pest(ipest)
          baqupst_y%pest(ipest)%stor_init = baqupst_y%pest(ipest)%stor_init + cs_aqu(iaq)%pest(ipest)
          baqupst_a%pest(ipest)%stor_init = baqupst_a%pest(ipest)%stor_init + cs_aqu(iaq)%pest(ipest)
        end do

      end do

      return
      end subroutine aqu_pest_output_init