      subroutine nut_orgnc2

!!    ~ ~ ~ PURPOSE ~ ~ ~
!!    this subroutine calculates the amount of organic nitrogen removed in
!!    surface runoff - when using CSWAT==2 it 


!!    ~ ~ ~ INCOMING VARIABLES ~ ~ ~
!!    name          |units        |definition
!!    ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
!!    enratio       |none         |enrichment ratio calculated for day in HRU
!!    erorgn(:)     |none         |organic N enrichment ratio, if left blank
!!                                |the model will calculate for every event
!!    ihru          |none         |HRU number
!!    sedc_d(:)     |kg C/ha      |amount of C lost with sediment
!!
!!
!!     
!!                                |pools 
!!    ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
!!    ~ ~ ~ ~ ~ ~ END SPECIFICATIONS ~ ~ ~ ~ ~ ~

      use hru_module, only : enratio, hru, ihru, sedorgn, sedyld, surfq, ipl
      use soil_module
      use organic_mineral_mass_module
      use carbon_module
      use plant_module
      use plant_data_module
      
      implicit none

      integer :: j = 0       !none          |HRU number
      integer :: ly = 0       !none          |soil layer number 
      real :: flo_loss_co = 0.        !kg N/ha       |amount of organic N in first soil layer
      real :: wt1 = 0.       !none          |conversion factor (mg/kg => kg/ha)
      real :: er = 0.        !none          |enrichment ratio
      real :: conc = 0.      !              |concentration of organic N in soil
      real :: sol_mass = 0.  !              |  
      real :: c_surlat = 0.         !              |c loss with runoff or lateral flow
      real :: c_vert = 0.           !              |c loss with vertical flow
      real :: c_horiz = 0.           !              |c loss with vertical flow
      real :: c_microb = 0.         !              |BMC LOSS WITH SEDIMENT
      real :: c_sed = 0.            !              |Organic C loss with sediment
      real :: ero_fr = 0.           !frac          |fraction of soil erosion of total soil mass
      real :: koc = 0.          !              |KOC FOR CARBON LOSS IN WATER AND SEDIMENT(500._1500.) KD = KOC * C
      real :: c_microb_fac = 0.               !              |
      real :: flo_tot = 0.          !mm            |total flow from the soil layer
      real :: c_microb_loss = 0.               !              | 
      real :: horiz_conc = 0.               !              | 
      real :: vert_conc = 0.               !              | 
      real :: perc_clyr = 0.        !              | 
      real :: latc_clyr = 0.        !              | 
      real :: n_left_rto = 0.              !              |
      real :: c_microb_perc = 0.               !              |
      real :: c_microb_sed = 0.               !              |
      real :: c_ly1 = 0.
      
      j = ihru
      
      latc_clyr = 0.        
      perc_clyr = 0.
      wt1 = 0.
      er = 0.
      
      !! total carbon in surface residue and soil humus
      c_ly1 = soil1(j)%hp(1)%n + soil1(j)%hs(1)%n + pl_mass(j)%rsd_tot%n
      !! wt = sol_bd(1,j) * sol_z(1,j) * 10. (tons/ha) -> wt1 = wt/1000
      wt1 = soil(j)%phys(1)%bd * soil(j)%phys(1)%d / 100.

      if (hru(j)%hyd%erorgn > .001) then
        er = hru(j)%hyd%erorgn
      else
        er = enratio
      end if

      !! organic n leaving hru
      conc = c_ly1 * er / wt1
      sedorgn(j) = .001 * conc * sedyld(j) / hru(j)%area_ha

      !! update soil carbon organic nitrogen pools
      if (c_ly1 > 1.e-6) then
        n_left_rto = (1. - sedorgn(j) / c_ly1)
        soil1(j)%tot(1)%n = soil1(j)%tot(1)%n * n_left_rto
        soil1(j)%hs(1)%n = soil1(j)%hs(1)%n * n_left_rto
        soil1(j)%hp(1)%n = soil1(j)%hp(1)%n * n_left_rto
        do ipl = 1, pcom(j)%npl
          pl_mass(j)%rsd(ipl)%n =   pl_mass(j)%rsd(ipl)%n * n_left_rto
        end do
        soil1(j)%meta(1)%n = soil1(j)%meta(1)%n * n_left_rto
        soil1(j)%str(1)%n = soil1(j)%str(1)%n * n_left_rto
        soil1(j)%lig(1)%n = soil1(j)%lig(1)%n * n_left_rto
      end if
      
      !! Calculate runoff and leached C&N from microbial biomass
      latc_clyr = 0.
      sol_mass = (soil(j)%phys(1)%d / 1000.) * 10000. * soil(j)%phys(1)%bd * 1000. * (1- soil(j)%phys(1)%rock / 100.)
      c_surlat = 0.
      c_vert = 0.
      c_microb = 0.
      c_sed = 0.
      soil1(j)%tot(1)%c = soil1(j)%hp(1)%c + soil1(j)%hs(1)%c + soil1(j)%meta(1)%c + soil1(j)%str(1)%c !Total organic carbon in layer 1
      ero_fr = MIN((sedyld(j)/hru(j)%area_ha) / (sol_mass / 1000.),.9) !fraction of soil erosion of total soil mass
      c_sed = ero_fr * soil1(j)%tot(1)%c
      soil1(j)%tot(1)%c = soil1(j)%tot(1)%c * (1.- ero_fr)
      soil1(j)%hs(1)%c = soil1(j)%hs(1)%c * (1.- ero_fr)
      soil1(j)%hp(1)%c = soil1(j)%hp(1)%c * (1.- ero_fr)
      do ipl = 1, pcom(j)%npl
        pl_mass(j)%rsd(ipl)%c = pl_mass(j)%rsd(ipl)%c * (1.- ero_fr)
      end do
          
        
      if (soil1(j)%microb(1)%c > .01) then
          koc = cb_wtr_coef%prmt_21 !KOC FOR CARBON LOSS IN WATER AND SEDIMENT(500._1500.) KD = KOC * C
          soil1(j)%tot(1)%c = soil1(j)%str(1)%c + soil1(j)%meta(1)%c + soil1(j)%hp(1)%c + soil1(j)%hs(1)%c + soil1(j)%microb(1)%c
          c_microb_fac = .0001 * koc * soil1(j)%tot(1)%c
          flo_tot = soil(j)%phys(1)%por*soil(j)%phys(1)%d-soil(j)%phys(1)%wpmm !mm
          IF (flo_tot <= 0.) THEN
            flo_tot = 0.01
          END IF
          c_microb_loss = c_microb_fac * flo_tot / soil(j)%phys(1)%d
          c_microb_loss = MIN(c_microb_loss, soil1(j)%microb(1)%c)
          c_microb_perc = c_microb_loss * (soil(j)%ly(1)%prk / flo_tot)
          c_microb_sed = c_microb_loss * (sedyld(j) / hru(j)%area_ha / flo_tot)
          soil1(j)%microb(1)%c = soil1(j)%microb(1)%c - c_microb_loss
          soil1(j)%tot(1)%c = soil1(j)%tot(1)%c - c_microb_loss
          c_surlat = c_surlat + c_microb_loss * (surfq(j) / flo_tot)
          c_vert = c_vert + c_microb_perc
          c_microb = c_microb + c_microb_sed
      end if

      soil1(j)%meta(1)%c = soil1(j)%meta(1)%c * (1.- ero_fr)
      soil1(j)%str(1)%c = soil1(j)%str(1)%c * (1.- ero_fr)
      soil1(j)%lig(1)%c = soil1(j)%lig(1)%c * (1.- ero_fr)

      return
      end subroutine nut_orgnc2