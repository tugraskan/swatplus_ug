!--------------------------------------------------------------------
!  hmet_apply
!    Apply a heavy metal mass to the first two soil layers, accounting
!    for canopy interception.  The portion captured by vegetation is
!    removed from the application before the remaining mass is split
!    between the surface and subsurface soil.
!--------------------------------------------------------------------
subroutine hmet_apply(jj, ihmet, hmet_kg, hmetop)

  use mgt_operations_module
  use soil_module
  use plant_module
  use constituent_mass_module

  implicit none

  integer, intent(in) :: jj      ! HRU number
  integer, intent(in) :: ihmet   ! heavy metal index
  real,    intent(in) :: hmet_kg ! mass of heavy metal applied
  integer, intent(in) :: hmetop  ! application option

  integer :: j = 0
  real :: gc = 0.
  real :: surf_frac = 0.

  j = jj

  gc = (1.99532 - erfc(1.333 * pcom(j)%lai_sum - 2.)) / 2.1
  if (gc < 0.) gc = 0.
  surf_frac = chemapp_db(hmetop)%surf_frac

  if (ihmet <= size(cs_soil(j)%ly(1)%hmet)) then
    cs_soil(j)%ly(1)%hmet(ihmet) = cs_soil(j)%ly(1)%hmet(ihmet) + (1. - gc) * surf_frac * hmet_kg
    cs_soil(j)%ly(2)%hmet(ihmet) = cs_soil(j)%ly(2)%hmet(ihmet) + (1. - gc) * (1. - surf_frac) * hmet_kg
  end if

end subroutine hmet_apply
