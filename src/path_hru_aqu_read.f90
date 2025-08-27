!--------------------------------------------------------------------
!  path_hru_aqu_read
!    Read pathogen initialization data for HRUs and aquifers.  The
!    routine also processes pathogen concentrations tied to
!    fertilizers via the path.man file.
!--------------------------------------------------------------------
subroutine path_hru_aqu_read
    
      use constituent_mass_module
      use input_file_module
      use maximum_data_module
 
      implicit none
      
      character (len=80) :: titldum = ""
      character (len=80) :: header = ""
      character(len=16) :: manu = "path.man"
      integer :: ipath = 0
      integer :: ipathi = 0
      integer :: eof = 0
      integer :: imax = 0
      logical :: i_exist              !none       |check to determine if file exists

      eof = 0
      
      !read all export coefficient data
      inquire (file=in_init%path_soil, exist=i_exist)
      if (i_exist .or. in_init%path_soil /= "null") then
        do
          open (107,file=in_init%path_soil)
          read (107,*,iostat=eof) titldum
          if (eof < 0) exit
          imax = 0
          do while (eof == 0)
            read (107,*,iostat=eof) header
            if (eof < 0) exit
            read (107,*,iostat=eof) titldum     !name
            if (eof < 0) exit
            do ipath = 1, cs_db%num_paths
              read (107,*,iostat=eof) titldum
              if (eof < 0) exit
            end do
            imax = imax + 1
          end do
          
          db_mx%path_ini = imax
          
          allocate (path_soil_ini(imax))
          allocate (cs_path_solsor(cs_db%num_paths))
          
          do ipath = 1, imax
            allocate (path_soil_ini(ipath)%soil(cs_db%num_paths))
            allocate (path_soil_ini(ipath)%plt(cs_db%num_paths), source = 0.)
          end do
           
          rewind (107)
          read (107,*,iostat=eof) titldum
          if (eof < 0) exit
          
          do ipathi = 1, imax
            read (107,*,iostat=eof) header
            if (eof < 0) exit
            read (107,*,iostat=eof) path_soil_ini(ipathi)%name
            if (eof < 0) exit
            read (107,*,iostat=eof) titldum, path_soil_ini(ipathi)%soil, path_soil_ini(ipathi)%plt
            if (eof < 0) exit
          end do
          close (107)
          exit
        end do
        
        ! --- fertilizer pathogen concentrations ---
        ! reads the pathogen amounts that are attached to each fertilizer
      
        call fert_constituent_file_read (manu, imax, cs_db%num_paths)
        call MOVE_ALLOC(fert_arr, path_fert_soil_ini) 
        
      end if



  return
  end subroutine path_hru_aqu_read

