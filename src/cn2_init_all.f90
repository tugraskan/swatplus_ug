!!@summary Initialize curve numbers for all HRUs
!!@description Loops through every HRU and applies the CN2
!! initialization routine based on landuse and soil properties.
!!@arguments None
      subroutine cn2_init_all

      use soil_module
      use maximum_data_module
      use landuse_data_module
      use hydrograph_module, only : sp_ob

      implicit none

      integer :: j = 0               !!none | counter

!! assign topography and hydrologic parameters
      do j = 1, sp_ob%hru
        call cn2_init (j)
      end do

!! finish
      return
      end subroutine cn2_init_all