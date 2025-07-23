!!@summary Initialize land use management for all HRUs
!!@description Copies management options from the database and
!! invokes the land use initialization routine for each HRU.
!!@arguments None
      subroutine hru_lum_init_all

      use hru_module, only : hru
      use hydrograph_module, only : sp_ob

      implicit none

      integer :: iihru = 0          !!none | hru number

!! loop over HRUs and initialize management
      do iihru = 1, sp_ob%hru
        hru(iihru)%land_use_mgt = hru(iihru)%dbs%land_use_mgt
        call hru_lum_init (iihru)
      end do

!! finished initialization
      return
      end subroutine hru_lum_init_all