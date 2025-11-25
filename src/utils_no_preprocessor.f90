! This is a simplified version of utils.f90 for manual builds without CMake
! that don't have the preprocessor enabled. For CMake builds, use utils.f90 instead.
! 
! To use this file instead of utils.f90:
! 1. Delete or rename utils.f90
! 2. Rename this file to utils.f90
! 3. Compile normally without needing to enable the preprocessor

module utils
    use iso_fortran_env
    IMPLICIT NONE

contains

real function exp_w(y)
    implicit none
    real, intent(in) :: y
    logical :: err_output
    
    ! err_output = .true.
    err_output = .false.
    ! err_output = .false.

    if (y < -80.) then
        exp_w = 0.
        if (err_output) then
            write(error_unit,'(A)') ""
            write(error_unit,'(A,F6.1,A)') "Warning: exp(", y, ") causes an underflow."
            write(error_unit,'(A)') "Setting exp_w result to zero"
            write(error_unit, *)  "Stack trace not available in this build"
        endif
    else  
        exp_w = exp(y)
    endif
end function exp_w
end module utils
