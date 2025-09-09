!--------------------------------------------------------------------
!  constit_man_db_read
!    Read and initialize the manure-specific constituent database 
!    from constituents_man.cs. This database is separate from the 
!    general constituent database (constituents.cs) and is used 
!    specifically for fertilizer/manure constituent applications.
!    
!    This subroutine focuses solely on database reading. The 
!    crosswalking between fertilizer records and constituent arrays
!    is handled by a separate constit_man_crosswalk subroutine.
!--------------------------------------------------------------------
subroutine constit_man_db_read
      
      use basin_module
      use input_file_module
      use constituent_mass_module
      use maximum_data_module
      use pesticide_data_module
      use pathogen_data_module
      use fertilizer_data_module

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
      integer :: ifrt = 0             !none       |fertilizer counter  
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
      
      return
      end subroutine constit_man_db_read