      subroutine res_nutrient (iob)

      use reservoir_data_module
      use time_module
      use reservoir_module
      use hydrograph_module, only : resz, ob, ht2, wbody
      use climate_module
      
      implicit none      
      
      integer, intent (in) :: iob
      real :: nitrok = 0.        !              |
      real :: phosk = 0.         !              |
      real :: nitrosolk = 0.     !              |
      real :: phossolk = 0.      !              |
      real :: tpco = 0.          !              |
      real :: chlaco = 0.        !              |
      integer :: iwst = 0        !none          |weather station number
      real :: nsetlr = 0.        !              |
      real :: psetlr = 0.        !              |
      real :: nsolr = 0.         !              |
      real :: psolr = 0.         !              |
      real :: conc_n = 0.        !              |
      real :: conc_p = 0.        !              |
      real :: conc_soln = 0.     !              |
      real :: conc_solp = 0.     !              |
      real :: theta              !              |
      

      !! if reservoir volume less than 1 m^3, set all nutrient levels to
      !! zero and perform no nutrient calculations
      if (wbody%flo < 1.e-6) then
        wbody = resz
        return
      end if

      !! if reservoir volume greater than 1 m^3, perform nutrient calculations
      if (time%mo >= wbody_prm%nut%ires1 .and. time%mo <= wbody_prm%nut%ires2) then
        nsetlr = wbody_prm%nut%nsetlr1
        psetlr = wbody_prm%nut%psetlr1
      else
        nsetlr = wbody_prm%nut%nsetlr2
        psetlr = wbody_prm%nut%psetlr2
      endif
      nsolr = wbody_prm%nut%nsolr
      psolr = wbody_prm%nut%psolr

      !! n and p concentrations kg/m3 * kg/1000 t * 1000000 ppp = 1000
      conc_n = 1000. * wbody%orgn / wbody%flo
      conc_p = 1000. * wbody%sedp / wbody%flo
      conc_soln = 1000. * (wbody%no3 + wbody%nh3 + wbody%no2) / wbody%flo
      conc_solp = 1000. * wbody%solp / wbody%flo
      
      !! new inputs thetn, thetap, conc_pmin, conc_nmin
      !! Ikenberry wetland eqs modified - not function of area - fraction of difference in concentrations
      iwst = ob(iob)%wst
      nitrok = (conc_n - wbody_prm%nut%conc_nmin) * Theta(nsetlr, wbody_prm%nut%theta_n, wst(iwst)%weat%tave)
      nitrok = amin1 (nitrok, 1.)
      nitrok = max (nitrok, 0.)
      phosk = (conc_p - wbody_prm%nut%conc_pmin) * Theta(psetlr, wbody_prm%nut%theta_p, wst(iwst)%weat%tave)
      phosk = amin1 (phosk, 1.)
      phosk = max (phosk, 0.)
      nitrosolk = (conc_soln - wbody_prm%nut%conc_nmin) * Theta(nsolr, wbody_prm%nut%theta_n, wst(iwst)%weat%tave)
      nitrosolk = amin1 (nitrosolk, 1.)
      nitrosolk = max (nitrosolk, 0.)
      phossolk = (conc_solp - wbody_prm%nut%conc_pmin) * Theta(psolr, wbody_prm%nut%theta_p, wst(iwst)%weat%tave)
      phossolk = amin1 (phossolk, 1.)
      phossolk = max (phossolk, 0.)

      !! remove nutrients from reservoir by settling - exclude soluble nutrients
      !! other part of equation 29.1.3 in SWAT manual
      wbody%solp = wbody%solp * (1. - phosk * wbody_prm%solp_stl_fr)
      wbody%sedp = wbody%sedp * (1. - phosk)
      wbody%orgn = wbody%orgn * (1. - nitrok)
      wbody%no3 = wbody%no3 * (1. - nitrok * wbody_prm%soln_stl_fr)
      wbody%nh3 = wbody%nh3 * (1. - nitrok * wbody_prm%soln_stl_fr)
      wbody%no2 = wbody%no2 * (1. - nitrok * wbody_prm%soln_stl_fr)

      !! calculate chlorophyll-a and water clarity
      chlaco = 0.
      wbody%chla = 0.
      tpco = 1.e+6 * (wbody%solp + wbody%sedp) / (wbody%flo + ht2%flo)
      if (tpco > 1.e-4) then
        !! equation 29.1.6 in SWAT manual
        !chlaco = wbody_prm%nut%chlar * 0.551 * (tpco**0.76)
        wbody%chla = (wbody%flo + ht2%flo) * 1.e-6
      endif
      
      !! check nutrient masses greater than zero
      wbody%no3 = max (wbody%no3, 0.0)
      wbody%orgn = max (wbody%orgn, 0.0)
      wbody%sedp = max (wbody%sedp, 0.0)
      wbody%solp = max (wbody%solp, 0.0)
      wbody%chla = max (wbody%chla, 0.0)
      wbody%nh3 = max (wbody%nh3, 0.0)
      wbody%no2 = max (wbody%no2, 0.0)

      !! calculate amount of nutrients leaving reservoir
      ht2%no3 = wbody%no3 * ht2%flo / (wbody%flo + ht2%flo)
      ht2%orgn = wbody%orgn * ht2%flo / (wbody%flo + ht2%flo)
      ht2%sedp = wbody%sedp * ht2%flo / (wbody%flo + ht2%flo)
      ht2%solp = wbody%solp * ht2%flo / (wbody%flo + ht2%flo)
      ht2%chla = wbody%chla * ht2%flo / (wbody%flo + ht2%flo)
      ht2%nh3 = wbody%nh3 * ht2%flo / (wbody%flo + ht2%flo)
      ht2%no2 = wbody%no2 * ht2%flo / (wbody%flo + ht2%flo)
      
      !! remove nutrients leaving reservoir
      wbody%no3 = max(0.,wbody%no3 - ht2%no3) !No less than zero, Jaehak 2024
      wbody%orgn = max(0.,wbody%orgn - ht2%orgn)
      wbody%sedp = max(0.,wbody%sedp - ht2%sedp)
      wbody%solp = max(0.,wbody%solp - ht2%solp)
      wbody%chla = max(0.,wbody%chla - ht2%chla)
      wbody%nh3 = max(0.,wbody%nh3 - ht2%nh3)
      wbody%no2 = max(0.,wbody%no2 - ht2%no2)

      return
      end subroutine res_nutrient