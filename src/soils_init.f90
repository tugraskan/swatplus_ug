      subroutine soils_init
      
      use hru_module, only : hru, wfsh, ihru, isep, iseptic, i_sep
      use soil_module
      use plant_module
      use maximum_data_module
      use soil_data_module
      use organic_mineral_mass_module
      use constituent_mass_module
      use hydrograph_module, only : sp_ob
      use time_module
      use basin_module
      use septic_data_module
      
      implicit none  
      
      integer :: msoils = 0       !none          !ending of loop
      integer :: isol = 0         !none          |counter
      integer :: mlyr = 0         !none          |max number of soil layers
      integer :: i = 0            !none          |counter
      integer :: j = 0            !none          |counter
      integer :: nly = 0          !              |end of loop
      integer :: ly = 0           !none          |counter
      integer :: ccd = 0          !mm            |current custom depth in millimeters
      integer :: pcd = 0          !mm            |previous custom depth in millimeters
      integer :: prev_depth = 0   !mm            |previous custom depth in millimeters
      integer :: tot_soil_depth = 0 !mm          |total soil profile depth in millimeters 
      integer :: eof = 0          !              |end of file
      integer :: n = 0            !              |count to use to compute an average
      real :: dep_new1 = 0.       !mm            |depth of top of septic layer
      real :: dep_new2 = 0.       !mm            |depth of bottom of septic layer
      real :: sum = 0.            !              |temporary sum to do and average with 
      logical :: i_exist          !none          |check to determine if a file exists
      character (len=500) :: header = "" !       |header of file
      character (len=80) :: titldum = "" !       |title of file
      character (len=16) :: units = ""  !        |name
      type (soil_hru_database), dimension(:), allocatable :: sol_mm_db
      
      !!Section 1
      !!this section sets, allocates, and initializes the original soil database
      msoils = Max(0,db_mx%soil)
      allocate (sol(0:msoils))
       
      do isol = 1, msoils
        sol(isol)%s%snam = soildb(isol)%s%snam
        sol(isol)%s%hydgrp = soildb(isol)%s%hydgrp
        sol(isol)%s%zmx = soildb(isol)%s%zmx                      
        sol(isol)%s%anion_excl = soildb(isol)%s%anion_excl
        sol(isol)%s%crk = soildb(isol)%s%crk                  
        sol(isol)%s%texture = soildb(isol)%s%texture

        inquire (file="soil_lyr_depths.sol",exist=i_exist)
        if (.not. i_exist) then
          if (soildb(isol)%ly(1)%z > 19.5) then
            sol(isol)%s%nly = soildb(isol)%s%nly + 1    !add 10 mm layer
          else
            sol(isol)%s%nly = soildb(isol)%s%nly
          end if
          mlyr = sol(isol)%s%nly
          allocate (sol(isol)%ly(mlyr))
          allocate (sol(isol)%phys(mlyr))

          !!set first 10 mm layer
          sol(isol)%phys(1)%d = 10.
          sol(isol)%phys(1)%bd = soildb(isol)%ly(1)%bd
          sol(isol)%phys(1)%awc = soildb(isol)%ly(1)%awc
          sol(isol)%phys(1)%k = soildb(isol)%ly(1)%k
          
          sol(isol)%phys(1)%clay = soildb(isol)%ly(1)%clay
          sol(isol)%phys(1)%silt = soildb(isol)%ly(1)%silt
          sol(isol)%phys(1)%sand = soildb(isol)%ly(1)%sand
          sol(isol)%phys(1)%rock = soildb(isol)%ly(1)%rock
          sol(isol)%ly(1)%alb = soildb(isol)%ly(1)%alb
          sol(isol)%ly(1)%usle_k = soildb(isol)%ly(1)%usle_k
          sol(isol)%ly(1)%ec = soildb(isol)%ly(1)%ec
          sol(isol)%ly(1)%cal = soildb(isol)%ly(1)%cal
          sol(isol)%ly(1)%ph = soildb(isol)%ly(1)%ph
          !!set remaining layers
          if (soildb(isol)%ly(1)%z > 19.5) then
            do j = 2, mlyr
              sol(isol)%phys(j)%d = soildb(isol)%ly(j-1)%z
              sol(isol)%phys(j)%bd = soildb(isol)%ly(j-1)%bd
              sol(isol)%phys(j)%awc = soildb(isol)%ly(j-1)%awc
              sol(isol)%phys(j)%k = soildb(isol)%ly(j-1)%k
              sol(isol)%phys(j)%clay = soildb(isol)%ly(j-1)%clay
              sol(isol)%phys(j)%silt = soildb(isol)%ly(j-1)%silt
              sol(isol)%phys(j)%sand = soildb(isol)%ly(j-1)%sand
              sol(isol)%phys(j)%rock = soildb(isol)%ly(j-1)%rock
              sol(isol)%ly(j)%alb = soildb(isol)%ly(j-1)%alb
              sol(isol)%ly(j)%usle_k = soildb(isol)%ly(j-1)%usle_k
              sol(isol)%ly(j)%ec = soildb(isol)%ly(j-1)%ec
              sol(isol)%ly(j)%cal = soildb(isol)%ly(j-1)%cal
              sol(isol)%ly(j)%ph = soildb(isol)%ly(j-1)%ph
            end do
          else
            !!1st layer < 20 mm so dont add 10 mm  layer
            do j = 2, mlyr
              sol(isol)%phys(j)%d = soildb(isol)%ly(j)%z
              sol(isol)%phys(j)%bd = soildb(isol)%ly(j)%bd
              sol(isol)%phys(j)%awc = soildb(isol)%ly(j)%awc
              sol(isol)%phys(j)%k = soildb(isol)%ly(j)%k
              sol(isol)%phys(j)%clay = soildb(isol)%ly(j)%clay
              sol(isol)%phys(j)%silt = soildb(isol)%ly(j)%silt
              sol(isol)%phys(j)%sand = soildb(isol)%ly(j)%sand
              sol(isol)%phys(j)%rock = soildb(isol)%ly(j)%rock
              sol(isol)%ly(j)%alb = soildb(isol)%ly(j)%alb
              sol(isol)%ly(j)%usle_k = soildb(isol)%ly(j)%usle_k
              sol(isol)%ly(j)%ec = soildb(isol)%ly(j)%ec
              sol(isol)%ly(j)%cal = soildb(isol)%ly(j)%cal
              sol(isol)%ly(j)%ph = soildb(isol)%ly(j)%ph
            end do
          end if
        else              !this part reads in custom depths and calculates the weighted average values 

          ! Allocate a temporary data structure to do weighted averages from.
          tot_soil_depth = soildb(isol)%ly(soildb(isol)%s%nly)%z
          allocate (sol_mm_db(1))
          allocate (sol_mm_db(1)%phys(tot_soil_depth))
          allocate (sol_mm_db(1)%ly(tot_soil_depth))

          ! Populate temporary data structure to do weighted averages from.
          prev_depth = 0
          do j = 1, soildb(isol)%s%nly
            do i = prev_depth + 1, tot_soil_depth
              if (i <= soildb(isol)%ly(j)%z .and. i > prev_depth ) then
                sol_mm_db(1)%phys(i)%d = i
                sol_mm_db(1)%phys(i)%bd = soildb(isol)%ly(j)%bd
                sol_mm_db(1)%phys(i)%awc = soildb(isol)%ly(j)%awc
                sol_mm_db(1)%phys(i)%k = soildb(isol)%ly(j)%k
                sol_mm_db(1)%phys(i)%clay = soildb(isol)%ly(j)%clay
                sol_mm_db(1)%phys(i)%silt = soildb(isol)%ly(j)%silt
                sol_mm_db(1)%phys(i)%sand = soildb(isol)%ly(j)%sand
                sol_mm_db(1)%phys(i)%rock = soildb(isol)%ly(j)%rock
                sol_mm_db(1)%ly(i)%alb = soildb(isol)%ly(j)%alb
                sol_mm_db(1)%ly(i)%usle_k = soildb(isol)%ly(j)%usle_k
                sol_mm_db(1)%ly(i)%ec = soildb(isol)%ly(j)%ec
                sol_mm_db(1)%ly(i)%cal = soildb(isol)%ly(j)%cal
                sol_mm_db(1)%ly(i)%ph = soildb(isol)%ly(j)%ph
              else 
                exit
              end if
            end do
            prev_depth = soildb(isol)%ly(j)%z               
          end do

          open (107,file="soil_lyr_depths.sol")
          read (107,*,iostat=eof) titldum
          if (eof < 0) exit
          read (107,*,iostat=eof) header
          if (eof < 0) exit
          read (107,*,iostat=eof) units
          if (eof < 0) exit
          do 
            read (107,*,iostat=eof) ccd
            if (eof < 0) exit
            if (ccd <= tot_soil_depth) then
              mlyr = mlyr + 1
            else if (ccd > tot_soil_depth) then
              ccd = tot_soil_depth
              mlyr = mlyr + 1
              exit
            endif  
          end do 

          tot_soil_depth = Min(tot_soil_depth, ccd)
          sol(isol)%s%nly = mlyr    !Adjust number of layers
          
          tot_soil_depth = Min(tot_soil_depth, ccd)
          allocate (sol(isol)%ly(mlyr))
          allocate (sol(isol)%phys(mlyr))
          sol(isol)%phys(mlyr)%d = tot_soil_depth
          rewind (107)  
          read (107,*,iostat=eof) titldum
          read (107,*,iostat=eof) header
          read (107,*,iostat=eof) units

          pcd = 1
          do i = 1, mlyr
            read (107,*,iostat=eof) ccd

            ! if (ccd > tot_soil_depth) then
            !   sol(isol)%phys(i)%d = tot_soil_depth
            ! else 
            !   sol(isol)%phys(i)%d = ccd
            ! endif

            sol(isol)%phys(i)%d = ccd

            sum = 0.0
            n = 0
            do j = pcd, ccd
              if (j <= tot_soil_depth) then
                sum = sum + sol_mm_db(1)%phys(j)%bd 
                n = n + 1
              end if
            end do
            sol(isol)%phys(i)%bd = sum/n

            sum = 0.0
            n = 0
            do j = pcd, ccd
              if (j <= tot_soil_depth) then
                sum = sum + sol_mm_db(1)%phys(j)%awc
                n = n + 1
              end if
            end do
            sol(isol)%phys(i)%awc = sum/n

            
            sum = 0.0
            n = 0
            do j = pcd, ccd
              if (j <= tot_soil_depth) then
                sum = sum + sol_mm_db(1)%phys(j)%k
                n = n + 1
              end if
            end do
            sol(isol)%phys(i)%k = sum/n

            sum = 0.0
            n = 0
            do j = pcd, ccd
              if (j <= tot_soil_depth) then
                sum = sum + sol_mm_db(1)%phys(j)%clay
                n = n + 1
              end if
            end do
            sol(isol)%phys(i)%clay = sum/n

            sum = 0.0
            n = 0
            do j = pcd, ccd
              if (j <= tot_soil_depth) then
                sum = sum + sol_mm_db(1)%phys(j)%silt
                n = n + 1
              end if
            end do
            sol(isol)%phys(i)%silt = sum/n

            sum = 0.0
            n = 0
            do j = pcd, ccd
              if (j <= tot_soil_depth) then
                sum = sum + sol_mm_db(1)%phys(j)%sand
                n = n + 1
              end if
            end do
            sol(isol)%phys(i)%sand = sum/n

            sum = 0.0
            n = 0
            do j = pcd, ccd
              if (j <= tot_soil_depth) then
                sum = sum + sol_mm_db(1)%phys(j)%rock
                n = n + 1
              end if
            end do
            sol(isol)%phys(i)%rock = sum/n

            sum = 0.0
            n = 0
            do j = pcd, ccd
              if (j <= tot_soil_depth) then
                sum = sum + sol_mm_db(1)%ly(j)%alb
                n = n + 1
              end if
            end do
            sol(isol)%ly(i)%alb = sum/n

            sum = 0.0
            n = 0
            do j = pcd, ccd
              if (j <= tot_soil_depth) then
                sum = sum + sol_mm_db(1)%ly(j)%usle_k
                n = n + 1
              end if
            end do
            sol(isol)%ly(i)%usle_k = sum/n

            sum = 0.0
            n = 0
            do j = pcd, ccd
              if (j <= tot_soil_depth) then
                sum = sum + sol_mm_db(1)%ly(j)%ec
                n = n + 1
              end if
            end do
            sol(isol)%ly(i)%ec = sum/n

            sum = 0.0
            n = 0
            do j = pcd, ccd
              if (j <= tot_soil_depth) then
                sum = sum + sol_mm_db(1)%ly(j)%cal
                n = n + 1
              end if
            end do
            sol(isol)%ly(i)%cal = sum/n

            sum = 0.0
            n = 0
            do j = pcd, ccd
              if (j <= tot_soil_depth) then
                sum = sum + sol_mm_db(1)%ly(j)%ph
                n = n + 1
              end if
            end do
            sol(isol)%ly(i)%ph = sum/n

            pcd = ccd + 1
          end do
          deallocate (sol_mm_db(1)%phys)
          deallocate (sol_mm_db(1)%ly)
          deallocate (sol_mm_db)
          close (107)
        end if
      end do
           
      do isol = 1, msoils
        call soil_phys_init(isol)          !! initialize soil physical parameters
      end do
      
      !!Section 2
      !!this section sets hru soils to appropriate soil database
      
      do ihru = 1, sp_ob%hru
        !! allocate soil layers
        isol = hru(ihru)%dbs%soil
        wfsh(ihru) = 10. * Exp(6.5309 - 7.32561* sol(isol)%phys(1)%por +            &
            3.809479 * sol(isol)%phys(1)%por**2+0.001583 *                          &
            sol(isol)%phys(1)%clay **2 + 0.000344 * sol(isol)%phys(1)%sand*         &
            sol(isol)%phys(1)%clay - 0.049837 * sol(isol)%phys(1)%por *             &
            sol(isol)%phys(1)%sand + 0.001608*sol(isol)%phys(1)%por ** 2 *          &
            sol(isol)%phys(1)%sand ** 2+0.001602*sol(isol)%phys(1)%por ** 2 *       &
            sol(isol)%phys(1)%clay**2-0.0000136*sol(isol)%phys(1)%sand ** 2         &
            * sol(isol)%phys(1)%clay-0.003479*sol(isol)%phys(1)%clay ** 2 *         &
            sol(isol)%phys(1)%por - 0.000799 * sol(isol)%phys(1)%sand ** 2 *        & 
            sol(isol)%phys(1)%por)
        soil(ihru) = sol(isol)%s
        nly = soil(ihru)%nly
        allocate (soil(ihru)%ly(nly))
        allocate (soil(ihru)%phys(nly))
        
        !! set hru soils to appropriate database soil layers
        do ly = 1, nly
          soil(ihru)%phys(ly) = sol(isol)%phys(ly)
          soil(ihru)%ly(ly) = sol(isol)%ly(ly)
        end do
        
        !! create a biozone layer in septic HRUs
        isep = iseptic(ihru)
        dep_new1 = 0.
        dep_new2 = 0.
        if (sep(isep)%opt /= 0) then 
          dep_new1 = 0.
          dep_new2 = 0.
	      if (sep(isep)%z + sep(isep)%thk > soil(ihru)%phys(nly)%d) then
            i_sep(ihru) = nly + 1
            dep_new1 = sep(isep)%z - sep(isep)%thk
            dep_new2 = 0.
          else
            do ly = 2, nly
              if (sep(isep)%z < soil(ihru)%phys(ly)%d) then
                i_sep(ihru) = ly + 1
                if (abs(sep(isep)%z - soil(ihru)%phys(ly)%d) > 25.4) then
                  dep_new1 = sep(isep)%z
                  dep_new2 = sep(isep)%z + sep(isep)%thk
                else
                  dep_new1 = 0.
                  soil(ihru)%phys(ly)%d = sep(isep)%z
                end if
                if (abs(sep(isep)%z - soil(ihru)%phys(ly-1)%d) < 25.4) then
                  dep_new1 = sep(isep)%z + sep(isep)%thk
                  dep_new2 = 0.
                end if
                exit
              end if
            end do
          end if
          if (dep_new1 > 1.e-6) call layersplit (dep_new1)
          if (dep_new2 > 1.e-6) call layersplit (dep_new2)
        end if       ! sep(isep)%opt /= 0
   
        !! allocate soil1 arrays - carbon/nutrients
        nly = soil(ihru)%nly
        !allocate (cs_soil(ihru)%ly(nly))
        allocate (soil1(ihru)%sw(nly), source = 0.)
        allocate (soil1(ihru)%cbn(nly), source = 0.)
        allocate (soil1(ihru)%sed(nly))
        allocate (soil1(ihru)%mn(nly))
        allocate (soil1(ihru)%mp(nly))
        allocate (soil1(ihru)%tot(nly))
        allocate (soil1(ihru)%seq(nly))
        allocate (soil1(ihru)%org_con_lr(nly))
        allocate (soil1(ihru)%org_allo_lr(nly))
        allocate (soil1(ihru)%org_ratio_lr(nly))
        allocate (soil1(ihru)%org_tran_lr(nly))
        allocate (soil1(ihru)%org_flx_lr(nly))
        allocate (soil1(ihru)%org_flx_cum_lr(nly))
        allocate (soil1(ihru)%hact(nly))
        allocate (soil1(ihru)%hsta(nly))
        allocate (soil1(ihru)%rsd(nly))
        allocate (soil1(ihru)%str(nly))
        allocate (soil1(ihru)%lig(nly))
        allocate (soil1(ihru)%meta(nly))
        allocate (soil1(ihru)%hs(nly))
        allocate (soil1(ihru)%hp(nly))
        allocate (soil1(ihru)%microb(nly))
        allocate (soil1(ihru)%man(nly))
        allocate (soil1(ihru)%water(nly))

        allocate (soil1_init(ihru)%sw(nly), source = 0.)
        allocate (soil1_init(ihru)%cbn(nly), source = 0.)
        allocate (soil1_init(ihru)%sed(nly))
        allocate (soil1_init(ihru)%mn(nly))
        allocate (soil1_init(ihru)%mp(nly))
        allocate (soil1_init(ihru)%tot(nly))
        allocate (soil1_init(ihru)%seq(nly))
        allocate (soil1_init(ihru)%hact(nly))
        allocate (soil1_init(ihru)%hsta(nly))
        allocate (soil1_init(ihru)%rsd(nly))
        allocate (soil1_init(ihru)%str(nly))
        allocate (soil1_init(ihru)%lig(nly))
        allocate (soil1_init(ihru)%meta(nly))
        allocate (soil1_init(ihru)%hs(nly))
        allocate (soil1_init(ihru)%hp(nly))
        allocate (soil1_init(ihru)%microb(nly))
        allocate (soil1_init(ihru)%man(nly))
        allocate (soil1_init(ihru)%water(nly))
        
      end do

      return
      
      end subroutine soils_init