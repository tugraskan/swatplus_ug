      module error_stop_mod
      !! Centralized error-stop module.
      !! Provides a single, standard-Fortran interface for all fatal error exits,
      !! replacing the non-portable CALL EXIT() GNU extension and the inconsistent
      !! mix of bare STOP, STOP 1, and ERROR STOP used elsewhere in the code.
      !!
      !! Usage:
      !!   call error_stop()                  ! exit code 1, no message
      !!   call error_stop(2)                 ! exit code 2, no message
      !!   call error_stop(msg="bad input")   ! exit code 1, print message
      !!   call error_stop(1, msg, iunit)     ! exit code 1, print to * and iunit

      implicit none

      private
      public :: error_stop

      interface error_stop
        module procedure error_stop_no_code
        module procedure error_stop_with_code
      end interface

      contains

      subroutine error_stop_no_code(msg, output_unit)
        character(*), intent(in), optional :: msg         !! supplemental message to write on error
        integer,      intent(in), optional :: output_unit !! file unit to write error to (in addition to *)
        call error_stop_with_code(1, msg, output_unit)
      end subroutine

      subroutine error_stop_with_code(stop_code, msg, output_unit)
        integer,      intent(in)           :: stop_code   !! error code to raise
        character(*), intent(in), optional :: msg         !! supplemental message to write on error
        integer,      intent(in), optional :: output_unit !! file unit to write error to (in addition to *)
        integer :: iout
        iout = 0
        if (present(output_unit)) iout = output_unit
        if (present(msg)) then
          write(*,'(/,a)') msg
          if (iout /= 0) write(iout,'(/,a,/)') msg
        end if
        !! NOTE: ERROR STOP with a variable stop code requires Fortran 2018.
        !! For portability, integer literals are used via SELECT CASE.
        select case (stop_code)
          case (1); error stop 1
          case (2); error stop 2
          case (3); error stop 3
          case (4); error stop 4
          case (5); error stop 5
          case (6); error stop 6
          case (7); error stop 7
          case (8); error stop 8
          case (9); error stop 9
          case default; error stop 1
        end select
      end subroutine

      end module error_stop_mod
