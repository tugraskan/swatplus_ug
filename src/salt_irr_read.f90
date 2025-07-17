!--------------------------------------------------------------------
!  salt_irr_read
!    Read salt concentrations in outside irrigation water.  If the
!    input file is not supplied a single zero concentration profile is
!    created so irrigation routines can proceed safely.
!--------------------------------------------------------------------
subroutine salt_irr_read
    
      use constituent_mass_module
      use input_file_module
      use maximum_data_module
      
      implicit none
 
      character (len=80) :: titldum = ""
      character (len=80) :: header = ""
      integer :: isalt = 0
      integer :: isalti = 0
      integer :: eof = 0
      integer :: imax = 0
      logical :: i_exist              !none       |check to determine if file exists

      eof = 0
      
      !read salt data for outside irrigation water
      !if the file is missing, a single default profile with zero
      !concentration is created so initialization routines can
      !safely reference salt_water_irr
      inquire (file="salt_irrigation", exist=i_exist)
      if (i_exist) then
        do
          open (107,file="salt_irrigation")
          read (107,*,iostat=eof) titldum
          if (eof < 0) exit
          read (107,*,iostat=eof) header
          if (eof < 0) exit
          
          !count the number of names
          imax = 0
          do while (eof == 0)
            if (eof < 0) exit
            read (107,*,iostat=eof) titldum
            if (eof < 0) exit
            imax = imax + 1
          end do
          
          !allocate salt irrigation array
          allocate (salt_water_irr(imax))
          do isalti=1,imax
            allocate (salt_water_irr(isalti)%water(cs_db%num_salts), source = 0.)
          end do
           
          !read in values
          rewind (107)
          read (107,*,iostat=eof) titldum
          if (eof < 0) exit
          read (107,*,iostat=eof) header
          if (eof < 0) exit
          do isalti=1,imax
            read (107,*,iostat=eof) salt_water_irr(isalti)%name,salt_water_irr(isalti)%water
            if (eof < 0) exit
          end do
          close (107)
          exit
        end do
        end if
      
      return
      end subroutine salt_irr_read