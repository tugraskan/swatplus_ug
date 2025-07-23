!!@summary Compute wind erosion factors
!!@description Coordinates individual wind erosion factor
!! calculations for bare soil, vegetative cover, roughness,
!! unsheltered distance and erodibility.
!!@arguments None
      subroutine wind_ero_control

      implicit none

!! calculate factors
      call wind_ero_bare

      call wind_ero_erod

      call wind_ero_veg

      call wind_ero_rough

      call wind_ero_unshelt

!! finished
      return
      end subroutine wind_ero_control