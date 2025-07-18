!!@summary Compute daily albedo for the current HRU
!!@description Calculates HRU albedo using plant cover and snow depth
!! from SWAT manual equations.
!!@arguments None
      subroutine albedo

      use hru_module, only : hru, ihru, albday
      use soil_module
      use plant_module
      use organic_mineral_mass_module
      
      implicit none
        
      real :: cej = 0.  !!none | constant
      real :: eaj = 0.  !!none | soil cover index
      integer :: j = 0  !!none | HRU number
      real :: cover = 0.  !!kg/ha | soil cover
      
      j = ihru

!! calculate albedo
      cej = -5.e-5
      cover = pl_mass(j)%ab_gr_com%m + soil1(j)%rsd(1)%m
      eaj = Exp(cej * (cover + .1))   !! equation 2.2.16 in SWAT manual

!! determine albedo based on snow cover
      if (hru(j)%sno_mm <= .5) then
        !! equation 2.2.14 in SWAT manual
        albday = soil(j)%ly(1)%alb

        !! equation 2.2.15 in SWAT manual
!! adjust for plant cover
        if (pcom(j)%lai_sum > 0.) albday = .23 * (1. - eaj) + soil(j)%ly(1)%alb * eaj
      else
        !! equation 2.2.13 in SWAT manual
        albday = 0.8
      end if

      return
      end subroutine albedo