!!@summary Determine soil erodibility factor
!!@description Calculates the wind erodibility based on soil
!! texture fractions using a series of conditional checks.
!!@arguments None
      subroutine wind_ero_erod

      use soil_module
      use wind_data_module

      implicit none

      real :: sand = 0.            !!none | fraction of sand in soil material
      integer :: j = 0             !!none | hru number
      real :: clay = 0.            !!none | fraction of clay in soil material
      real :: silt = 0.            !!percent | silt content of soil
      real :: cla = 0.             !!kg/L | amount of cla residue
     
!! read soil texture fractions
      sand = sol(j)%phys(1)%sand
      silt = sol(J)%phys(1)%silt
      clay = sol(j)%phys(1)%clay
      
!! coarse sand soils are highly erodible
      if (sand > 85. + 0.5 * clay) then
          wind_factors%erod = 1.
          return
      end if 
      
!! moderately coarse textures
      if (sand > 70. + clay)then
          wind_factors%erod =  0.43
          return
      end if
      
!! high silt content
      if (silt > 80. .and. clay < 12.) then
          wind_factors%erod = 0.12
          return
      end if
      
!! low clay content
      if (clay < 7.) then
          if (silt < 50.) then
              wind_factors%erod = 0.28
              return
          else
              wind_factors%erod = 0.18
              return
          endif
      end if
      
!! intermediate clay values
      if (clay < 20.) then
          if (sand > 52.) then
              wind_factors%erod = 0.28
              return
          else
              wind_factors%erod = 0.18
              return
          endif
      endif
      
!! transition between textures
      if (clay < 27.) then
          if (silt < 0.28) then
            wind_factors%erod = 0.18
            return
      else
            wind_factors%erod = 0.16
            return
          endif
      endif
      
!! adjust for calcium carbonate
      if (cla < 35. .and. sand < 20.) then
          wind_factors%erod = 0.12
          return
      endif
      
!! fairly fine textured soil
      if (clay < 35.) then
          if (sand < 45.) then
            wind_factors%erod = 0.16
            return
      else
            wind_factors%erod = 0.18
            return
          endif
      endif
      
!! default condition
      if (sand > 45.) then
          wind_factors%erod = 0.18
          return
      else
          wind_factors%erod = 0.28
          return
      endif
      
      return
      end subroutine wind_ero_erod