!--------------------------------------------------------------------
!  path_apply
!    Apply a pathogen load to the soil surface and optionally the
!    plant canopy.  The load is distributed between surface soil and
!    the second layer based on the application method and canopy
!    interception.
!--------------------------------------------------------------------
subroutine path_apply(jj, ipath, path_kg, pathop)

  use mgt_operations_module
  use soil_module
  use plant_module
  use output_ls_pathogen_module
  use constituent_mass_module

  implicit none

  integer, intent(in) :: jj      ! HRU number
  integer, intent(in) :: ipath   ! pathogen index
  real,    intent(in) :: path_kg ! amount of pathogen applied (kg or cfu)
  integer, intent(in) :: pathop  ! application option

  integer :: j = 0
  integer :: ipl = 0
  real :: gc = 0.
  real :: surf_frac = 0.
  real :: pl_frac = 0.

  j = jj

  ! fraction intercepted by plant canopy
  gc = (1.99532 - erfc(1.333 * pcom(j)%lai_sum - 2.)) / 2.1
  if (gc < 0.) gc = 0.
  surf_frac = chemapp_db(pathop)%surf_frac

  if (pcom(j)%lai_sum > 1.e-6) then
    do ipl = 1, pcom(j)%npl
      pl_frac = pcom(j)%plg(ipl)%lai / pcom(j)%lai_sum
      cs_pl(j)%pl_on(ipl)%path(ipath) = cs_pl(j)%pl_on(ipl)%path(ipath) + gc * pl_frac * path_kg
      hpath_bal(j)%path(ipath)%apply_plt = hpath_bal(j)%path(ipath)%apply_plt + gc * pl_frac * path_kg
    end do
  end if

  cs_soil(j)%ly(1)%path(ipath) = cs_soil(j)%ly(1)%path(ipath) + (1. - gc) * surf_frac * path_kg
  cs_soil(j)%ly(2)%path(ipath) = cs_soil(j)%ly(2)%path(ipath) + (1. - gc) * (1. - surf_frac) * path_kg
  hpath_bal(j)%path(ipath)%apply_sol = hpath_bal(j)%path(ipath)%apply_sol + (1. - gc) * path_kg

end subroutine path_apply
