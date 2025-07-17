subroutine cs_apply(jj, ics, cs_kg, csop)

  use mgt_operations_module
  use soil_module
  use plant_module
  use constituent_mass_module

  implicit none

  integer, intent(in) :: jj    ! HRU number
  integer, intent(in) :: ics   ! constituent index
  real,    intent(in) :: cs_kg ! mass applied
  integer, intent(in) :: csop  ! application option

  integer :: j = 0
  real :: gc = 0.
  real :: surf_frac = 0.

  j = jj

  gc = (1.99532 - erfc(1.333 * pcom(j)%lai_sum - 2.)) / 2.1
  if (gc < 0.) gc = 0.
  surf_frac = chemapp_db(csop)%surf_frac

  if (ics <= size(cs_soil(j)%ly(1)%cs)) then
    cs_soil(j)%ly(1)%cs(ics) = cs_soil(j)%ly(1)%cs(ics) + (1. - gc) * surf_frac * cs_kg
    cs_soil(j)%ly(2)%cs(ics) = cs_soil(j)%ly(2)%cs(ics) + (1. - gc) * (1. - surf_frac) * cs_kg
  end if

end subroutine cs_apply
