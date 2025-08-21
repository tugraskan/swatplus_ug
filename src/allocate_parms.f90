!!@summary Allocate memory for dynamic arrays and initialize simulation variables
!!@description This subroutine allocates memory for all dynamic arrays used throughout the SWAT+ simulation
!! based on the number of spatial objects (HRUs, channels, etc.). It initializes array sizes, allocates
!! memory for plant communities, drainage systems, septic systems, tillage operations, and other simulation
!! components. After allocation, it calls initialization subroutines to set default values.
!!@arguments
!! This subroutine has no explicit arguments - it operates on global module variables and uses
!! object counts from spatial object modules to determine array sizes
      subroutine allocate_parms

      use hru_module      
      use time_module
      use hydrograph_module
      use constituent_mass_module

      implicit none
      
      integer :: mhru = 0               !!none | maximum number of HRUs  
      integer :: mch = 0                !!none | maximum number of channels
      integer :: mpc = 0                !!none | maximum number of plant communities
      
      !! Initialize array dimension variables based on spatial object counts   
      mhyd = 1  !!added for jaehak vars
      mhru = sp_ob%hru
      mch = sp_ob%chan

      !! Allocate basic drainage and runoff arrays
      allocate (wnan(10), source = 0.)
      allocate (ranrns_hru(mhru), source = 0.)
      
      !! Allocate temporary plant nutrient and growth arrays (daily use, not saved)
       mpc = 20
       allocate (uno3d(mpc), source = 0.)
       allocate (uapd(mpc), source = 0.)
       allocate (un2(mpc), source = 0.)
       allocate (up2(mpc), source = 0.)
       allocate (translt(mpc), source = 0.)
       allocate (par(mpc), source = 0.)
       allocate (htfac(mpc), source = 0.)
       allocate (epmax(mpc), source = 0.)
       epmax = 0.

      !! Allocate plant community management arrays
      allocate (cvm_com(mhru), source = 0.)
      allocate (rsdco_plcom(mhru), source = 0.)
      allocate (percn(mhru), source = 0.)

      !! Allocate septic system management arrays (changes added 1/28/09 gsm)
      allocate (i_sep(mhru), source = 0)
      allocate (sep_tsincefail(mhru), source = 0)
      allocate (qstemm(mhru), source = 0.)
      allocate (bio_bod(mhru), source = 0.)
      allocate (biom(mhru), source = 0.)
      allocate (rbiom(mhru), source = 0.)
      allocate (fcoli(mhru), source = 0.)
      allocate (bz_perc(mhru), source = 0.)
      allocate (plqm(mhru), source = 0.)
      allocate (itb(mhru), source = 0)
      
      !! Allocate subdaily hydrograph arrays for time step calculations
      allocate (hhqday(mhru,time%step), source = 0.)
      
 !! Allocate management output arrays for tracking nutrient balances
      allocate (sol_sumno3(mhru), source = 0.)
      allocate (sol_sumsolp(mhru), source = 0.)

      !! Allocate additional septic system tracking arrays
      allocate (iseptic(mhru), source = 0)

!!    Allocate grazing management arrays
      allocate (grz_days(mhru), source = 0)

!!    Allocate general HRU-level management and hydrologic arrays
      allocate (brt(mhru), source = 0.)
      allocate (canstor(mhru), source = 0.)
      allocate (cbodu(mhru), source = 0.)
      allocate (chl_a(mhru), source = 0.)
      allocate (cklsp(mhru), source = 0.)
      allocate (cn2(mhru), source = 0.)
      allocate (cnday(mhru), source = 0.)
!    Allocate Drainmod tile equation arrays 01/2006 
   allocate (cumei(mhru), source = 0.)
   allocate (cumeira(mhru), source = 0.)
   allocate (cumrt(mhru), source = 0.)
   allocate (cumrai(mhru), source = 0.)
!    End Drainmod tile equations  01/2006
      !! Allocate plant growth and management tracking arrays
      allocate (dormhr(mhru), source = 0.)
      allocate (doxq(mhru), source = 0.)
      allocate (filterw(mhru), source = 0.)
      allocate (igrz(mhru), source = 0)
      allocate (yr_skip(mhru), source = 0)
      allocate (isweep(mhru), source = 0)
      allocate (phusw(mhru), source = 0.)
      !! Allocate nutrient transport arrays
      allocate (latno3(mhru), source = 0.)
      allocate (latq(mhru), source = 0.)
      allocate (ndeat(mhru), source = 0)
      allocate (nplnt(mhru), source = 0.)
      allocate (orgn_con(mhru), source = 0.)
      allocate (orgp_con(mhru), source = 0.)
      allocate (ovrlnd(mhru), source = 0.)
      allocate (phubase(mhru), source = 0.)

      allocate (pplnt(mhru), source = 0.)
      allocate (qdr(mhru), source = 0.)

      !! Allocate groundwater flow arrays (rtb gwflow module)
      allocate (gwsoilq(mhru), source = 0.)  !rtb gwflow


      allocate (satexq(mhru), source = 0.)  !rtb gwflow


      allocate (gwsoiln(mhru), source = 0.)  !rtb gwflow


      allocate (gwsoilp(mhru), source = 0.)  !rtb gwflow


      allocate (satexn(mhru), source = 0.)  !rtb gwflow


      
!    Allocate additional Drainmod arrays 01/2006 
   allocate (sstmaxd(mhru), source = 0.)
!    End Drainmod tile equations  01/2006 
      !! Allocate sediment transport and erosion arrays
      allocate (sedminpa(mhru), source = 0.)
      allocate (sedminps(mhru), source = 0.)
      allocate (sedorgn(mhru), source = 0.)
      allocate (sedorgp(mhru), source = 0.)
      allocate (sedyld(mhru), source = 0.)

      !! Allocate particle size class sediment arrays
      allocate (sanyld(mhru), source = 0.)
      allocate (silyld(mhru), source = 0.)
      allocate (clayld(mhru), source = 0.)
      allocate (sagyld(mhru), source = 0.)
      allocate (lagyld(mhru), source = 0.)
      allocate (grayld(mhru), source = 0.)
      !! Allocate water quality and nutrient concentration arrays
      allocate (sed_con(mhru), source = 0.)
      allocate (sepbtm(mhru), source = 0.)
      allocate (smx(mhru), source = 0.)
      allocate (soln_con(mhru), source = 0.)
      allocate (solp_con(mhru), source = 0.)
!!    Additional Drainmod arrays 01/2006 
   allocate (stmaxd(mhru), source = 0.)
      !! Allocate surface runoff and management arrays
      allocate (itill(mhru), source = 0)
      allocate (surfq(mhru), source = 0.)
      allocate (surqno3(mhru), source = 0.)
      allocate (surqsolp(mhru), source = 0.)
      allocate (swtrg(mhru), source = 0)
      !! Allocate urban and hydrologic process arrays
      allocate (rateinf_prev(mhru), source = 0.)
      allocate (urb_abstinit(mhru), source = 0.)
      allocate (t_ov(mhru), source = 0.)
      allocate (tconc(mhru), source = 0.)
      allocate (tc_gwat(mhru), source = 0.)
      allocate (tileno3(mhru), source = 0.)
      allocate (twash(mhru), source = 0.)
      !! Allocate USLE erosion factor arrays
      allocate (usle_cfac(mhru), source = 0.)
      allocate (usle_eifac(mhru), source = 0.)
      allocate (wfsh(mhru), source = 0.)
      !! Allocate salt transport arrays (rtb salt module)
      allocate (surqsalt(mhru,8), source = 0.)
      allocate (latqsalt(mhru,8), source = 0.)
      allocate (tilesalt(mhru,8), source = 0.)
      allocate (percsalt(mhru,8), source = 0.)
      allocate (gwupsalt(mhru,8), source = 0.)
      allocate (urbqsalt(mhru,8), source = 0.)
      allocate (wetqsalt(mhru,8), source = 0.)
      allocate (wtspsalt(mhru,8), source = 0.)
      !! Allocate constituent transport arrays (rtb cs module)
      allocate (surqcs(mhru,10), source = 0.)
      allocate (latqcs(mhru,10), source = 0.)
      allocate (tilecs(mhru,10), source = 0.)
      allocate (perccs(mhru,10), source = 0.)
      allocate (gwupcs(mhru,10), source = 0.)
      allocate (sedmcs(mhru,10), source = 0.)
      allocate (urbqcs(mhru,10), source = 0.)
      allocate (wetqcs(mhru,10), source = 0.)
      allocate (wtspcs(mhru,10), source = 0.)
      allocate (irswcs(mhru,10), source = 0.)
      allocate (irgwcs(mhru,10), source = 0.)
      
      !! Allocate additional arrays for salt/constituent transport (rtb modules)
      allocate (bss(40,mhru), source = 0.)  !rtb salt/cs (changed to 40)


      allocate (bss_ex(10,mhru), source = 0.)  !rtb gwflow


      allocate (wrt(2,mhru), source = 0.)
      allocate (surf_bs(55,mhru), source = 0.)  !rtb salt/cs (changed to 55)



!! Allocate subdaily surface arrays (sj aug 09 end)
   allocate (hhsurf_bs(2,mhru,time%step), source = 0.)
      !! Allocate urban runoff tracking arrays
      allocate (ubnrunoff(time%step), source = 0.)
      allocate (ubntss(time%step), source = 0.)

!! Allocate subdaily erosion modeling arrays by Jaehak Jeong
   allocate (hhsedy(mhru,time%step), source = 0.)
   allocate (ovrlnd_dt(mhru,time%step), source = 0.)
   allocate (init_abstrc(mhru), source = 0.)
   allocate (hhsurfq(mhru,time%step), source = 0.)

       !! Allocate tillage impact arrays for SOM decomposition
       allocate (tillage_switch(mhru), source = 0)
       allocate (tillage_depth(mhru), source = 0.)
       allocate (tillage_days(mhru), source = 0)
       allocate (tillage_factor(mhru), source = 0.)
       
       !! Initialize tillage impact variables to default values
       tillage_switch = 0
       tillage_depth = 0.
       tillage_days = 0
       tillage_factor = 0.
       
      !! Initialize carbon/nitrogen cycling variables (By Zhang for C/N cycling)
      !! ============================
          
      !! Call initialization subroutines to set default values for all allocated arrays
      call zero0
      call zero1
      call zero2
      call zeroini

      !! Array allocation and initialization complete for reservoir and other modules
      return
      end subroutine allocate_parms