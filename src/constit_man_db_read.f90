!--------------------------------------------------------------------
!  constit_man_db_read
!    Read and initialize the manure-specific constituent database 
!    from constituents_man.cs. This database is separate from the 
!    general constituent database (constituents.cs) and is used 
!    specifically for fertilizer/manure constituent applications.
!    
!    The subroutine also consolidates reading of all fertilizer
!    constituent files (*.man) and performs early crosswalking
!    to pre-compute array indices for optimal performance during
!    fertilizer applications.
!--------------------------------------------------------------------
subroutine constit_man_db_read
      
      use basin_module
      use input_file_module
      use constituent_mass_module
      use maximum_data_module
      use pesticide_data_module
      use pathogen_data_module

      implicit none
         
      character (len=80) :: titldum = ""!           |title of file
      logical :: i_exist              !none       |check to determine if file exists
      integer :: eof = 0              !           |end of file
      integer :: i = 0                !           |
      integer :: imax = 0             !           |
      integer :: ipest = 0            !none       |counter
      integer :: ipestdb = 0          !none       |counter
      integer :: ipath = 0            !none       |counter
      integer :: ipathdb = 0          !none       |counter
      character (len=80) :: cs_man_file = "constituents_man.cs"
       
      eof = 0
      imax = 0
      
      inquire (file=cs_man_file, exist=i_exist)
      if (.not. i_exist .or. cs_man_file == "null") then
        allocate (cs_man_db%pests(0:0))
        allocate (cs_man_db%paths(0:0))
        allocate (cs_man_db%metals(0:0))
        allocate (cs_man_db%salts(0:0))
        allocate (cs_man_db%cs(0:0))
      else
      do
        open (106,file=cs_man_file)
        read (106,*,iostat=eof) titldum
        if (eof < 0) exit
        read (106,*,iostat=eof) cs_man_db%num_pests
        if (eof < 0) exit
        allocate (cs_man_db%pests(0:cs_man_db%num_pests))
        allocate (cs_man_db%pest_num(0:cs_man_db%num_pests), source = 0)
        read (106,*,iostat=eof) (cs_man_db%pests(i), i = 1, cs_man_db%num_pests)
        if (eof < 0) exit
        read (106,*,iostat=eof) cs_man_db%num_paths
        if (eof < 0) exit
        allocate (cs_man_db%paths(0:cs_man_db%num_paths))
        allocate (cs_man_db%path_num(0:cs_man_db%num_paths), source = 0)
        read (106,*,iostat=eof) (cs_man_db%paths(i), i = 1, cs_man_db%num_paths)
        if (eof < 0) exit
        read (106,*,iostat=eof) cs_man_db%num_metals
        if (eof < 0) exit
        allocate (cs_man_db%metals(0:cs_man_db%num_metals))
        allocate (cs_man_db%metals_num(0:cs_man_db%num_metals), source = 0)
        read (106,*,iostat=eof) (cs_man_db%metals(i), i = 1, cs_man_db%num_metals)
        if (eof < 0) exit
        !salt ions
        read (106,*,iostat=eof) cs_man_db%num_salts
        if (eof < 0) exit
        allocate (cs_man_db%salts(0:cs_man_db%num_salts))
        allocate (cs_man_db%salts_num(0:cs_man_db%num_salts), source = 0)
        read (106,*,iostat=eof) (cs_man_db%salts(i), i = 1, cs_man_db%num_salts)
        !other constituents
        read (106,*,iostat=eof) cs_man_db%num_cs
        if (eof < 0) exit
        allocate (cs_man_db%cs(0:cs_man_db%num_cs))
        allocate (cs_man_db%cs_num (0:cs_man_db%num_cs), source = 0)
        read (106,*,iostat=eof) (cs_man_db%cs(i), i = 1, cs_man_db%num_cs)
        exit
      end do
      end if

      do ipest = 1, cs_man_db%num_pests
        do ipestdb = 1, db_mx%pestparm
          if (pestdb(ipestdb)%name == cs_man_db%pests(ipest)) then
            cs_man_db%pest_num(ipest) = ipestdb
            exit
          end if
        end do
      end do  
      
      do ipath = 1, cs_man_db%num_paths
        do ipathdb = 1, db_mx%path
          if (path_db(ipathdb)%pathnm == cs_man_db%paths(ipath)) then
            cs_man_db%path_num(ipath) = ipathdb
            exit
          end if
        end do
      end do
          
      !sum up the number of pesticides, pathogens, metals, salt ions, and other constituents
      cs_man_db%num_tot = cs_man_db%num_pests + cs_man_db%num_paths + cs_man_db%num_metals + cs_man_db%num_salts + cs_man_db%num_cs !rtb salt, cs
      
      close (106)
      
      ! --- Read all fertilizer constituent files now that constituent database is loaded ---
      ! This consolidates all fert_constituent_file_read calls that were previously scattered
      ! across individual constituent reading subroutines
      
      ! Read pesticide fertilizer concentrations
      if (cs_man_db%num_pests > 0) then
        call fert_constituent_file_read("pest.man", db_mx%fertparm, cs_man_db%num_pests)
        call MOVE_ALLOC(fert_arr, pest_fert_soil_ini)
      end if
      
      ! Read pathogen fertilizer concentrations  
      if (cs_man_db%num_paths > 0) then
        call fert_constituent_file_read("path.man", db_mx%fertparm, cs_man_db%num_paths)
        call MOVE_ALLOC(fert_arr, path_fert_soil_ini)
      end if
      
      ! Read heavy metal fertilizer concentrations
      if (cs_man_db%num_metals > 0) then
        call fert_constituent_file_read("hmet.man", db_mx%fertparm, cs_man_db%num_metals)
        call MOVE_ALLOC(fert_arr, hmet_fert_soil_ini)
      end if
      
      ! Read salt fertilizer concentrations
      if (cs_man_db%num_salts > 0) then
        call fert_constituent_file_read("salt.man", db_mx%fertparm, cs_man_db%num_salts)
        call MOVE_ALLOC(fert_arr, salt_fert_soil_ini)
      end if
      
      ! Read general constituent fertilizer concentrations
      if (cs_man_db%num_cs > 0) then
        call fert_constituent_file_read("cs.man", db_mx%fertparm, cs_man_db%num_cs)
        call MOVE_ALLOC(fert_arr, cs_fert_soil_ini)
      end if
      
      ! Perform fertilizer-constituent crosswalking now that all data is loaded
      call fert_constituent_crosswalk
      
      return
      end subroutine constit_man_db_read
      
      
!--------------------------------------------------------------------
!  fert_constituent_crosswalk
!    Crosswalk fertilizer linkage table names with constituent arrays
!    to populate direct array indices. This eliminates the need for
!    string matching during fertilizer application.
!--------------------------------------------------------------------
subroutine fert_constituent_crosswalk

      use fertilizer_data_module
      use constituent_mass_module

      implicit none
      
      integer :: ifrt = 0     ! fertilizer counter
      integer :: i = 0        ! array counter
      
      ! Exit if no extended fertilizer database exists or if empty
      if (.not. allocated(manure_db) .or. size(manure_db) <= 1) return
      
      ! Crosswalk each fertilizer entry
      do ifrt = 1, size(manure_db)
        if (ifrt == 0) cycle  ! skip null entry
        
        ! --- Pesticide crosswalk ---
        if (allocated(pest_fert_soil_ini) .and. size(pest_fert_soil_ini) > 0 .and. &
            manure_db(ifrt)%pest /= '') then
          do i = 1, size(pest_fert_soil_ini)
            if (trim(manure_db(ifrt)%pest) == trim(pest_fert_soil_ini(i)%name)) then
              manure_db(ifrt)%pest_idx = i
              exit
            end if
          end do
        end if
        
        ! --- Pathogen crosswalk ---
        if (allocated(path_fert_soil_ini) .and. size(path_fert_soil_ini) > 0 .and. &
            manure_db(ifrt)%path /= '') then
          do i = 1, size(path_fert_soil_ini)
            if (trim(manure_db(ifrt)%path) == trim(path_fert_soil_ini(i)%name)) then
              manure_db(ifrt)%path_idx = i
              exit
            end if
          end do
        end if
        
        ! --- Salt crosswalk ---
        if (allocated(salt_fert_soil_ini) .and. size(salt_fert_soil_ini) > 0 .and. &
            manure_db(ifrt)%salt /= '') then
          do i = 1, size(salt_fert_soil_ini)
            if (trim(manure_db(ifrt)%salt) == trim(salt_fert_soil_ini(i)%name)) then
              manure_db(ifrt)%salt_idx = i
              exit
            end if
          end do
        end if
        
        ! --- Heavy metal crosswalk ---
        if (allocated(hmet_fert_soil_ini) .and. size(hmet_fert_soil_ini) > 0 .and. &
            manure_db(ifrt)%hmet /= '') then
          do i = 1, size(hmet_fert_soil_ini)
            if (trim(manure_db(ifrt)%hmet) == trim(hmet_fert_soil_ini(i)%name)) then
              manure_db(ifrt)%hmet_idx = i
              exit
            end if
          end do
        end if
        
        ! --- Generic constituent crosswalk ---
        if (allocated(cs_fert_soil_ini) .and. size(cs_fert_soil_ini) > 0 .and. &
            manure_db(ifrt)%cs /= '') then
          do i = 1, size(cs_fert_soil_ini)
            if (trim(manure_db(ifrt)%cs) == trim(cs_fert_soil_ini(i)%name)) then
              manure_db(ifrt)%cs_idx = i
              exit
            end if
          end do
        end if
        
      end do
      
      return
      end subroutine fert_constituent_crosswalk