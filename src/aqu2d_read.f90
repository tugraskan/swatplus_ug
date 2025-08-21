!!@summary Read aquifer-channel connectivity data for 2D groundwater flow model
!!@description This subroutine reads input data defining the connections between aquifers and channels
!! for the 2D groundwater flow model. It processes the aquifer-channel linkage file to determine which
!! channels are connected to each aquifer, allocates memory for storing these connections, and sets up
!! the data structures needed for groundwater-surface water interactions in the model.
!!@arguments
!! This subroutine has no explicit arguments - it reads from input files defined in global modules
      subroutine aqu2d_read
    
      use hydrograph_module
      use input_file_module
      use maximum_data_module
      
      implicit none
      
      character (len=80) :: titldum = ""        !!none | title line of input file
      character (len=80) :: header = ""         !!none | header line of input file
      character (len=16) :: namedum = ""        !!none | name placeholder variable
      integer :: eof = 0                        !!none | end of file flag
      integer :: imax = 0                       !!none | maximum number for array allocation
      integer :: nspu = 0                       !!none | number of spatial units
      logical :: i_exist                        !!none | file existence check flag
      integer :: i = 0                          !!none | general counter
      integer :: isp = 0                        !!none | spatial counter
      integer :: numb = 0                       !!none | number placeholder
      integer :: iaq = 0                        !!none | aquifer counter
      integer :: iaq_db = 0                     !!none | aquifer database counter
      integer :: ielem1 = 0                     !!none | element counter

      eof = 0
      imax = 0
      
      !! Read aquifer-channel connectivity data for 2D groundwater model
      inquire (file=in_link%aqu_cha, exist=i_exist)
      if (.not. i_exist .or. in_link%aqu_cha == "null" ) then
        allocate (aq_ch(0:0))
      else 
      !! Process input file to determine array dimensions
      do
        if (eof < 0) exit
        open (107,file=in_link%aqu_cha)
        read (107,*,iostat=eof) titldum
        if (eof < 0) exit
        read (107,*,iostat=eof) header
        if (eof < 0) exit
        imax = 0
        !! Find maximum aquifer number for array allocation
        do while (eof == 0)
          read (107,*,iostat=eof) i
          if (eof < 0) exit
          imax = Max(imax,i)
        end do
      end do

      !! Allocate aquifer-channel connection arrays
      db_mx%aqu2d = imax
      allocate (aq_ch(sp_ob%aqu))
      rewind (107)
      read (107,*) titldum
      read (107,*) header

      do iaq_db = 1, imax

        read (107,*,iostat=eof) iaq, namedum, nspu
        if (eof < 0) exit
        
        if (nspu > 0) then
          backspace (107)
          allocate (elem_cnt(nspu), source = 0)
          read (107,*,iostat=eof) numb, aq_ch(iaq)%name, nspu, (elem_cnt(isp), isp = 1, nspu)
          if (eof < 0) exit
          
          call define_unit_elements (nspu, ielem1)
          
          allocate (aq_ch(iaq)%num(ielem1), source = 0)
          aq_ch(iaq)%num = defunit_num
          aq_ch(iaq)%num_tot = ielem1
          deallocate (defunit_num)

        end if
      end do
      end if

      close (107)
      
      return
      end subroutine aqu2d_read