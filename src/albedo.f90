!!@summary Calculate daily albedo value for the hydrologic response unit (HRU)
!!@description This subroutine computes the surface albedo for an HRU based on soil properties, vegetation cover,
!! and snow depth. The calculation follows SWAT manual equations 2.2.13-2.2.16. For areas with minimal snow
!! cover (<0.5 mm), albedo is calculated as a function of soil albedo, plant material, and residue cover.
!! For snow-covered areas, a fixed albedo value of 0.8 is used.
!!@arguments
!! This subroutine has no explicit arguments - it operates on global module variables
      subroutine albedo

      use hru_module, only : hru, ihru, albday
      use soil_module
      use plant_module
      use organic_mineral_mass_module
      
      implicit none
        
      real :: cej = 0.              !!none | exponential coefficient for vegetation cover effect
      real :: eaj = 0.              !!none | soil cover index factor      
      integer :: j = 0              !!none | HRU number index
      real :: cover = 0.            !!kg/ha | total soil cover from plants and residue
      
      !! Set HRU index from global variable
      j = ihru

      !! Calculate albedo based on snow cover conditions
      cej = -5.e-5
      cover = pl_mass(j)%ab_gr_com%m + soil1(j)%rsd(1)%m
      eaj = Exp(cej * (cover + .1))   !! equation 2.2.16 in SWAT manual

      !! Check for snow cover to determine albedo calculation method
      if (hru(j)%sno_mm <= .5) then
        !! equation 2.2.14 in SWAT manual
        albday = soil(j)%ly(1)%alb

        !! Adjust albedo for vegetation cover if plants are present
        !! equation 2.2.15 in SWAT manual
        if (pcom(j)%lai_sum > 0.) albday = .23 * (1. - eaj) + soil(j)%ly(1)%alb * eaj
      else
        !! Use fixed albedo for snow-covered surfaces
        !! equation 2.2.13 in SWAT manual
        albday = 0.8
      end if

      return
      end subroutine albedo