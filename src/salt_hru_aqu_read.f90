!--------------------------------------------------------------------
!  salt_hru_aqu_read
!    Read soil and plant salt concentrations for HRUs and aquifers.
!    Fertilizer based salt concentrations are loaded from salt.man and
!    stored for use during applications.
!--------------------------------------------------------------------
subroutine salt_hru_aqu_read
    
      use constituent_mass_module
      use input_file_module
      use maximum_data_module
      
      implicit none
 
      character (len=80) :: titldum = ""
      character (len=80) :: header = ""
      character (len=16) :: manu = 'salt.man'
      integer :: isalt = 0
      integer :: isalti = 0
      integer :: eof = 0
      integer :: imax = 0
      logical :: i_exist              !none       |check to determine if file exists

      eof = 0
      
      !read all export coefficient data
      inquire (file=in_init%salt_soil, exist=i_exist)
      if (i_exist .or. in_init%salt_soil /= "null") then
        do
          open (107,file=in_init%salt_soil)
          read (107,*,iostat=eof) titldum
          if (eof < 0) exit
          read (107,*,iostat=eof) header
          if (eof < 0) exit
          imax = 0
          do while (eof == 0)
            if (eof < 0) exit
            read (107,*,iostat=eof) titldum
            if (eof < 0) exit
            read (107,*,iostat=eof) titldum
            if (eof < 0) exit
            read (107,*,iostat=eof) titldum
            if (eof < 0) exit
            imax = imax + 1
          end do
          
          db_mx%salt_ini = imax
          
          allocate (salt_soil_ini(imax))
          do isalt = 1, imax
            allocate (salt_soil_ini(isalt)%soil(cs_db%num_salts+5), source = 0.)
            allocate (salt_soil_ini(isalt)%plt(cs_db%num_salts+5), source = 0.)
          end do
           
          rewind (107)
          read (107,*,iostat=eof) titldum
          if (eof < 0) exit
          read (107,*,iostat=eof) header
          if (eof < 0) exit

          do isalti = 1, imax
            read (107,*,iostat=eof) salt_soil_ini(isalti)%name
            if (eof < 0) exit
            read (107,*,iostat=eof) titldum, salt_soil_ini(isalti)%soil
            if (eof < 0) exit
            read (107,*,iostat=eof) titldum, salt_soil_ini(isalti)%plt
            if (eof < 0) exit
          end do
      close (107)
      exit
    end do
  end if

  ! --- fertilizer salt concentrations ---
  ! salts use the bulk format (all ions per line)
  call fert_constituent_file_read(manu, imax, cs_db%num_salts)
  call MOVE_ALLOC(fert_arr, salt_fert_soil_ini)

  return
  end subroutine salt_hru_aqu_read
