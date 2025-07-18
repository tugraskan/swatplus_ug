!!@summary Process aquifer configuration
!!@description Reads all aquifer input files and allocates
!! required data structures before simulation begins.
!!@arguments None
      subroutine proc_aqu

      use hydrograph_module

      implicit none

!! read and initialize aquifer data
      call aqu_read
      call aqu_initial
      call aqu_read_init
      call aqu_read_init_cs

!! finished setup
      return

      end subroutine proc_aqu