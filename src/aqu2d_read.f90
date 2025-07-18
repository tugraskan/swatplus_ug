!!@summary Read 2-D aquifer configuration
!!@description Loads channel element connections from input files for
!! groundwater simulation.
!!@arguments None
      subroutine aqu2d_read
    
      use hydrograph_module
      use input_file_module
      use maximum_data_module
      
      implicit none
      
      character (len=80) :: titldum = ""  !!none | title of file
      character (len=80) :: header = ""   !!none | header of file
      character (len=16) :: namedum = "" !!none | temporary name
      integer :: eof = 0              !!none | end of file flag
      integer :: imax = 0             !!none | max index in file
      integer :: nspu = 0             !!none | number of subunits
      logical :: i_exist              !!none | file exists flag
      integer :: i = 0                !!none | counter
      integer :: isp = 0              !!none | counter
      integer :: numb = 0             !!none | dummy variable
      integer :: iaq = 0              !!none | counter
      integer :: iaq_db = 0           !!none | counter
      integer :: ielem1 = 0           !!none | element count

      eof = 0
      imax = 0
      
!! read data for aquifer elements for 2-D groundwater model
      inquire (file=in_link%aqu_cha, exist=i_exist)
      if (.not. i_exist .or. in_link%aqu_cha == "null" ) then
        allocate (aq_ch(0:0))
      else
!! loop until end of file
!! loop through file to count elements
      do
        if (eof < 0) exit
        open (107,file=in_link%aqu_cha)
        read (107,*,iostat=eof) titldum
        if (eof < 0) exit
        read (107,*,iostat=eof) header
        if (eof < 0) exit
        imax = 0
        do while (eof == 0)
          read (107,*,iostat=eof) i
          if (eof < 0) exit
          imax = Max(imax,i)
        end do
      end do

!! allocate arrays based on file count
      db_mx%aqu2d = imax
      allocate (aq_ch(sp_ob%aqu))
      rewind (107)
      read (107,*) titldum
      read (107,*) header

!! read channel definitions
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

!! close file and exit
      close (107)
      
!! finalize routine
      return
      end subroutine aqu2d_read
