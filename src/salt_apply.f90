!--------------------------------------------------------------------
!  salt_apply
!    Apply dissolved salt ions to the soil profile.  The amount added
!    is divided between the surface and second layer and reduced by
!    any canopy interception of the application.
!--------------------------------------------------------------------
subroutine salt_apply(jj, isalt, salt_kg, saltop)

  use mgt_operations_module
  use soil_module
  use plant_module
  use constituent_mass_module

  implicit none

  integer, intent(in) :: jj      ! HRU number
  integer, intent(in) :: isalt   ! salt ion index
  real,    intent(in) :: salt_kg ! mass of salt applied
  integer, intent(in) :: saltop  ! application option

  integer :: j = 0
  real :: gc = 0.
  real :: surf_frac = 0.

  j = jj

  gc = (1.99532 - erfc(1.333 * pcom(j)%lai_sum - 2.)) / 2.1
  if (gc < 0.) gc = 0.
  surf_frac = chemapp_db(saltop)%surf_frac

  if (isalt <= size(cs_soil(j)%ly(1)%salt)) then
    cs_soil(j)%ly(1)%salt(isalt) = cs_soil(j)%ly(1)%salt(isalt) + (1. - gc) * surf_frac * salt_kg
    cs_soil(j)%ly(2)%salt(isalt) = cs_soil(j)%ly(2)%salt(isalt) + (1. - gc) * (1. - surf_frac) * salt_kg
  end if

end subroutine salt_apply
