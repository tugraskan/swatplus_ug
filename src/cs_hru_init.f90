!!@summary Populate initial constituent data for HRU soils
!!@description Allocates constituent arrays for each HRU layer
!! and converts initial concentrations to masses.
!!@arguments None
      subroutine cs_hru_init

      use hru_module, only : hru, sol_plt_ini
      use soil_module
      use organic_mineral_mass_module
      use constituent_mass_module
      use output_ls_pesticide_module
      use hydrograph_module, only : sp_ob, icmd
      use plant_module
      use pesticide_data_module
      use cs_module
      
      implicit none 
        
      integer :: ihru = 0        !!none | counter
      integer :: npmx = 0        !!none | total number of pesticides
      integer :: ly = 0          !!none | layer counter
      integer :: ics = 0         !!none | constituent counter
      integer :: ics_db = 0      !!none | index for initial conditions
      integer :: isp_ini = 0     !!none | soil-plant initialization index
      integer :: ipl = 0
      real :: wt1 = 0.           !!none | temporary variable
      real :: hru_area_m2 = 0.   !!m^2 | HRU area
      real :: water_volume = 0.  !!m^3 | volume of soil water
      real :: soil_volume = 0.   !!m^3 | soil layer volume
      real :: soil_mass = 0.     !!kg | mass of soil in layer
      real :: mass_sorbed = 0.   !!kg | sorbed constituent mass
        
        
!! allocate HRU constituent arrays
      npmx = cs_db%num_cs
      do ihru = 1, sp_ob%hru
        if (npmx > 0) then
          do ly = 1, soil(ihru)%nly
            allocate (cs_soil(ihru)%ly(ly)%cs(npmx), source = 0.)
            allocate (cs_soil(ihru)%ly(ly)%csc(npmx), source = 0.)
            allocate (cs_soil(ihru)%ly(ly)%cs_sorb(npmx), source = 0.)
            allocate (cs_soil(ihru)%ly(ly)%csc_sorb(npmx), source = 0.)
          end do
          allocate (cs_irr(ihru)%csc(npmx), source = 0.)
        end if

!! determine initial condition indices
        isp_ini = hru(ihru)%dbs%soil_plant_init
        ics_db = sol_plt_ini(isp_ini)%cs
        
!! prepare for g/m3 --> kg/ha conversion
        hru_area_m2 = hru(ihru)%area_ha * 10000.
        
!! loop through the constituents
        do ics = 1, npmx
          !plant mass
          !cs_pl(ihru)%cs(ics) = cs_soil_ini(ics_db)%plt(ics)
          !soil water constituent concentration and mass
          do ly = 1, soil(ihru)%nly
            !!soil water constituent ion concentration (mg/L)
            cs_soil(ihru)%ly(ly)%csc(ics) = cs_soil_ini(ics_db)%soil(ics)
            !!soil water constituent mass (kg/ha)
            water_volume = (soil(ihru)%phys(ly)%st/1000.) * hru_area_m2
            cs_soil(ihru)%ly(ly)%cs(ics) = (cs_soil_ini(ics_db)%soil(ics)/1000.) * water_volume / hru(ihru)%area_ha
            !!sorbed mass concentration (mg/kg)
            cs_soil(ihru)%ly(ly)%csc_sorb(ics) = cs_soil_ini(ics_db)%soil(ics+cs_db%num_cs)
            !!sorbed mass (kg/ha)
            soil_volume = hru_area_m2 * (soil(ihru)%phys(ly)%thick/1000.)
            soil_mass = soil_volume * (soil(ihru)%phys(ly)%bd*1000.)
            mass_sorbed = (cs_soil_ini(ics_db)%soil(ics+cs_db%num_cs)*soil_mass) / 1.e6
            cs_soil(ihru)%ly(ly)%cs_sorb(ics) = mass_sorbed / hru(ihru)%area_ha
          end do
          !! concentration in irrigation water
          cs_irr(ihru)%csc(ics) = cs_water_irr(ics_db)%water(ics)
        end do

      end do !! hru loop
                                   
      return
      end subroutine cs_hru_init