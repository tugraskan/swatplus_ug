!!@summary Initialize aquifer simulation objects and allocate memory for all aquifer-related data structures
!!@description This subroutine performs comprehensive initialization of all aquifer simulation components including
!! memory allocation for hydrologic, water quality, and constituent transport arrays. It allocates space for
!! aquifer objects, salt balance tracking, constituent mass balance, and pesticide transport arrays across
!! multiple temporal scales (daily, monthly, yearly, average annual). The subroutine initializes aquifer
!! parameters from the database, calculates derived parameters (recession factors, decay rates), and
!! sets initial conditions for water storage, groundwater depth, nutrient concentrations, and flow states.
!! Constituent arrays are allocated conditionally based on the presence of salts, general constituents, and pesticides.
!!@arguments
!! None - operates on global simulation objects and database structures
      subroutine aqu_initial 
    
      use aquifer_module  
      use hydrograph_module
      use constituent_mass_module
      use aqu_pesticide_module
      use salt_module !rtb salt
      use salt_aquifer !rtb salt
      use cs_module !rtb cs
      use cs_aquifer !rtb cs
       
      implicit none
      
      integer :: iaq = 0               !!none      | aquifer object counter
      integer :: iob = 0               !!none      | object identifier counter  
      integer :: iaqdb = 0             !!none      | aquifer database parameter index
      integer :: isalt = 0             !!none      | salt ion species counter
      integer :: ics = 0               !!none      | constituent species counter 

      !! Allocate primary aquifer data structure arrays for all aquifer objects
      !allocate objects for each aquifer
      allocate (aqu_om_init(sp_ob%aqu))
      allocate (aqu_d(sp_ob%aqu))
      allocate (aqu_dat(sp_ob%aqu))
      allocate (aqu_prm(sp_ob%aqu))
      allocate (aqu_m(sp_ob%aqu))
      allocate (aqu_y(sp_ob%aqu))
      allocate (aqu_a(sp_ob%aqu))
      allocate (cs_aqu(sp_ob%aqu))
      
      !! Allocate pesticide output tracking arrays
      allocate (aqupst_d(sp_ob%aqu))
      allocate (aqupst_m(sp_ob%aqu))
      allocate (aqupst_y(sp_ob%aqu))
      allocate (aqupst_a(sp_ob%aqu))

      !! Allocate basin-wide pesticide summary arrays if pesticides are simulated
      if (cs_db%num_pests > 0) then
        allocate (baqupst_d%pest(cs_db%num_pests))
        allocate (baqupst_m%pest(cs_db%num_pests))
        allocate (baqupst_y%pest(cs_db%num_pests))
        allocate (baqupst_a%pest(cs_db%num_pests))
      end if
      
      !! Allocate and initialize salt balance tracking arrays for aquifers
      !salts !rtb salt
      if (cs_db%num_salts > 0) then
        !! Allocate salt balance arrays for all time scales
        allocate (asaltb_d(sp_ob%aqu))
        allocate (asaltb_m(sp_ob%aqu))
        allocate (asaltb_y(sp_ob%aqu))
        allocate (asaltb_a(sp_ob%aqu))
        !! Initialize salt balance arrays for each aquifer
        do iaq = 1,sp_ob%aqu
          !! Allocate salt ion arrays for each time scale
          allocate (asaltb_d(iaq)%salt(cs_db%num_salts))
          allocate (asaltb_m(iaq)%salt(cs_db%num_salts))
          allocate (asaltb_y(iaq)%salt(cs_db%num_salts))
          allocate (asaltb_a(iaq)%salt(cs_db%num_salts))
          !! Initialize monthly salt balance components to zero
          do isalt=1,cs_db%num_salts
            asaltb_m(iaq)%salt(isalt)%rchrg = 0.
            asaltb_m(iaq)%salt(isalt)%seep = 0.
            asaltb_m(iaq)%salt(isalt)%saltgw = 0.
            asaltb_m(iaq)%salt(isalt)%conc = 0.
            asaltb_m(iaq)%salt(isalt)%irr = 0.
            !! Initialize yearly salt balance components to zero
            asaltb_y(iaq)%salt(isalt)%rchrg = 0.
            asaltb_y(iaq)%salt(isalt)%seep = 0.
            asaltb_y(iaq)%salt(isalt)%saltgw = 0.
            asaltb_y(iaq)%salt(isalt)%conc = 0.
            asaltb_y(iaq)%salt(isalt)%irr = 0.
            !! Initialize average annual salt balance components to zero
            asaltb_a(iaq)%salt(isalt)%rchrg = 0.
            asaltb_a(iaq)%salt(isalt)%seep = 0.
            asaltb_a(iaq)%salt(isalt)%saltgw = 0.
            asaltb_a(iaq)%salt(isalt)%conc = 0.
            asaltb_a(iaq)%salt(isalt)%irr = 0.
          enddo
          !! Initialize salt dissolution tracking for first salt component
          asaltb_m(iaq)%salt(1)%diss = 0.
          asaltb_y(iaq)%salt(1)%diss = 0.
          asaltb_a(iaq)%salt(1)%diss = 0.
        enddo
      endif
      
      !! Allocate and initialize constituent balance tracking arrays for aquifers
      !constituents !rtb cs
      if (cs_db%num_cs > 0) then
        !! Allocate constituent balance arrays for all time scales
        allocate (acsb_d(sp_ob%aqu))
        allocate (acsb_m(sp_ob%aqu))
        allocate (acsb_y(sp_ob%aqu))
        allocate (acsb_a(sp_ob%aqu))
        !! Initialize constituent balance arrays for each aquifer
        do iaq = 1,sp_ob%aqu
          !! Allocate constituent arrays for each time scale
          allocate (acsb_d(iaq)%cs(cs_db%num_cs))
          allocate (acsb_m(iaq)%cs(cs_db%num_cs))
          allocate (acsb_y(iaq)%cs(cs_db%num_cs))
          allocate (acsb_a(iaq)%cs(cs_db%num_cs))
          !! Initialize monthly constituent balance components to zero
          do ics=1,cs_db%num_cs
            acsb_m(iaq)%cs(ics)%csgw = 0. !monthly
            acsb_m(iaq)%cs(ics)%rchrg = 0.
            acsb_m(iaq)%cs(ics)%seep = 0.
            acsb_m(iaq)%cs(ics)%irr = 0.
            acsb_m(iaq)%cs(ics)%sorb = 0.
            acsb_m(iaq)%cs(ics)%rctn = 0.
            acsb_m(iaq)%cs(ics)%conc = 0.
            acsb_m(iaq)%cs(ics)%srbd = 0.
            !! Initialize yearly constituent balance components to zero
            acsb_y(iaq)%cs(ics)%csgw = 0. !yearly
            acsb_y(iaq)%cs(ics)%rchrg = 0.
            acsb_y(iaq)%cs(ics)%seep = 0.
            acsb_y(iaq)%cs(ics)%irr = 0.
            acsb_y(iaq)%cs(ics)%sorb = 0.
            acsb_y(iaq)%cs(ics)%rctn = 0.
            acsb_y(iaq)%cs(ics)%conc = 0.
            acsb_y(iaq)%cs(ics)%srbd = 0.
            !! Initialize average annual constituent balance components to zero
            acsb_a(iaq)%cs(ics)%csgw = 0. !average annual
            acsb_a(iaq)%cs(ics)%rchrg = 0.
            acsb_a(iaq)%cs(ics)%seep = 0.
            acsb_a(iaq)%cs(ics)%irr = 0.
            acsb_a(iaq)%cs(ics)%sorb = 0.
            acsb_a(iaq)%cs(ics)%rctn = 0.
            acsb_a(iaq)%cs(ics)%conc = 0.
            acsb_a(iaq)%cs(ics)%srbd = 0.
          enddo
        enddo
      endif
      
      !! Initialize individual aquifer objects with constituent arrays and parameters
      do iaq = 1, sp_ob%aqu
        !! Allocate pesticide and constituent tracking arrays for each aquifer
        if (cs_db%num_pests > 0) then
          !! Allocate constituent arrays for pesticides, pathogens, heavy metals, and salts
          !! allocate constituents
          allocate (cs_aqu(iaq)%pest(cs_db%num_pests), source = 0.)
          allocate (aqupst_d(iaq)%pest(cs_db%num_pests))
          allocate (aqupst_m(iaq)%pest(cs_db%num_pests))
          allocate (aqupst_y(iaq)%pest(cs_db%num_pests))
          allocate (aqupst_a(iaq)%pest(cs_db%num_pests))
          allocate (cs_aqu(iaq)%path(cs_db%num_paths), source = 0.)
          allocate (cs_aqu(iaq)%hmet(cs_db%num_metals), source = 0.)
          allocate (cs_aqu(iaq)%salt(cs_db%num_salts), source = 0.)
        end if
        !! Allocate and initialize salt ion tracking arrays
        !salts !rtb salt
        if (cs_db%num_salts > 0) then
          !! Allocate salt ion mass tracking arrays
          allocate (cs_aqu(iaq)%salt(cs_db%num_salts), source = 0.) !salt ion mass (kg)

          !! Allocate salt mineral fraction tracking arrays
          allocate (cs_aqu(iaq)%salt_min(5), source = 0.)  !salt mineral fractions

          !! Allocate salt ion concentration tracking arrays
          allocate (cs_aqu(iaq)%saltc(cs_db%num_salts), source = 0.)  !salt ion concentration (mg/L)

          !! Initialize salt arrays to zero
          cs_aqu(iaq)%salt = 0. !rtb salt
          cs_aqu(iaq)%salt_min = 0.
          cs_aqu(iaq)%saltc = 0.
        end if
        !! Allocate and initialize general constituent tracking arrays
        !constituents !rtb cs
        if (cs_db%num_cs > 0) then
          !! Allocate constituent mass tracking arrays
          allocate (cs_aqu(iaq)%cs(cs_db%num_cs), source = 0.) !constituent mass (kg)

          !! Allocate constituent concentration tracking arrays
          allocate (cs_aqu(iaq)%csc(cs_db%num_cs), source = 0.)  !constituent concentration (mg/L)

          !! Allocate sorbed constituent mass tracking arrays
          allocate (cs_aqu(iaq)%cs_sorb(cs_db%num_cs), source = 0.)  !sorbed constituent mass (kg/ha)

          !! Allocate sorbed constituent concentration tracking arrays
          allocate (cs_aqu(iaq)%csc_sorb(cs_db%num_cs), source = 0.)  !sorbed constituent mass concentration (mg/kg)

          !! Initialize constituent arrays to zero
          cs_aqu(iaq)%cs = 0. !rtb cs
          cs_aqu(iaq)%csc = 0.
          cs_aqu(iaq)%cs_sorb = 0.
          cs_aqu(iaq)%csc_sorb = 0.
        end if
        
        !! Set up aquifer database links and copy parameters from database
        iob = sp_ob1%aqu + iaq - 1
        iaqdb = ob(iob)%props

        !! Copy aquifer parameters from database to simulation arrays
        !! initialize parameters
        aqu_dat(iaq) = aqudb(iaqdb)
        
        !! Calculate derived aquifer parameters from database values
        aqu_prm(iaq)%area_ha = ob(iob)%area_ha
        aqu_prm(iaq)%alpha_e = Exp(-aqu_dat(iaq)%alpha)
        aqu_prm(iaq)%nloss = Exp(-.693 / (aqu_dat(iaq)%hlife_n + .1))
        
        !! Initialize aquifer state variables from database or calculated values
        aqu_d(iaq)%flo = aqu_dat(iaq)%flo
        aqu_d(iaq)%dep_wt = aqu_dat(iaq)%dep_wt
        aqu_d(iaq)%stor = 1000. * (aqu_dat(iaq)%dep_bot - aqu_d(iaqdb)%dep_wt) * aqu_dat(iaq)%spyld
        !! Convert nitrate concentration from ppm to mass: (m3=10*mm*ha), kg=m3*ppm/1000
        !! convert ppm -> kg    (m3=10*mm*ha)     kg=m3*ppm/1000
        aqu_d(iaq)%no3_st = (10. * aqu_d(iaq)%flo * aqu_prm(iaq)%area_ha) * aqu_dat(iaq)%no3 / 1000.
        aqu_d(iaq)%minp = 0.
        aqu_d(iaq)%cbn = aqu_dat(iaq)%cbn
        !! Initialize daily flux variables to zero
        aqu_d(iaq)%rchrg = 0.
        aqu_d(iaq)%seep = 0.
        aqu_d(iaq)%revap = 0.
        aqu_d(iaq)%no3_rchg = 0.
        aqu_d(iaq)%no3_loss = 0.
        aqu_d(iaq)%no3_lat = 0.
        aqu_d(iaq)%no3_seep = 0.
        !! Initialize flow routing variables to zero
        aqu_d(iaq)%flo_cha = 0.
        aqu_d(iaq)%flo_res = 0.
        aqu_d(iaq)%flo_ls = 0.
      end do
            
      !! Note: pesticides and constituents are initialized in aqu_read_init
      ! pesticides and constituents are initialized in aqu_read_init

      return
      end subroutine aqu_initial         