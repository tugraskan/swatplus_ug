!!@summary Run hard calibration simulation
!!@description Reinitializes all objects and reruns the
!! model for a hard calibration pass.
!!@arguments None
      subroutine calhard_control

      use aquifer_module
      use maximum_data_module
      use hydrograph_module

      implicit none

!! re-initialize all objects
      call re_initialize

!! rerun model for calibration
      cal_sim = " hard calibration simulation "
      call time_control

!! finish
      return
      end subroutine calhard_control