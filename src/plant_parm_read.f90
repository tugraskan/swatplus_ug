      subroutine plant_parm_read
      
      use input_file_module
      use maximum_data_module
      use plant_data_module
      use basin_module, only : bsn_cc
      
      implicit none 

      integer :: ic = 0                   !none       |plant counter
      character (len=80) :: titldum = ""  !           |title of file
      character (len=80) :: header = ""   !           |header of file
      character (len=80) :: plclass = ""  !           |plant class - row crop, close grown, grass, tree, etc
      integer :: eof = 0              !           |end of file
      integer :: imax = 0             !none       |determine max number for array (imax) and total number in file
      integer :: mpl = 0              !           | not used
      logical :: i_exist              !none       |check to determine if file exists
      
      
      eof = 0
      imax = 0
      mpl = 0
      
      ! Check if plant parameter file exists
      inquire (file=in_parmdb%plants_plt, exist=i_exist)
      if (.not. i_exist .or. in_parmdb%plants_plt == " null") then
        allocate (pldb(0:0))
        allocate (plcp(0:0))
        allocate (pl_class(0:0))
        allocate (pl_desc(0:0))
      else
        do
            open (104,file=in_parmdb%plants_plt)
            ! Handle reading based on bsn_cc%smax flag
            if (bsn_cc%smax == 1) then
                ! For nam run (bsn_cc%smax == 1), read only the header
                read(104, *, iostat=eof) header
                if (eof < 0) exit
                ! Count the number of plant records  
                do while (eof == 0)
                    read(104, *, iostat=eof) 
                    if (eof < 0) exit
                    imax = imax + 1
                end do
            else
                ! For regular run (bsn_cc%smax == 0), read both titldum and header
                read(104, *, iostat=eof) titldum
                if (eof < 0) exit
                read(104, *, iostat=eof) header
                if (eof < 0) exit
                ! Count the number of plant records  
                do while (eof == 0)
                    read(104, *, iostat=eof) 
                    if (eof < 0) exit
                    imax = imax + 1
                end do
            end if
            
            ! Allocate arrays based on count
            allocate (pldb(0:imax))
            allocate (plcp(0:imax))
            allocate (pl_class(0:imax))
            allocate (pl_desc(0:imax))
            
        ! Rewind file and read again for data
        rewind (104)
        
        !  Read data again depending on flag
        if (bsn_cc%smax == 1) then
            ! For nam run (bsn_cc%smax == 1), just skip to reading the plant data
            read(104, *, iostat=eof) header  ! Header is already read above, continue for data
        else
            ! For regular run (bsn_cc%smax == 0), read titldum and header again
            read(104, *, iostat=eof) titldum
            if (eof < 0) exit
            read(104, *, iostat=eof) header
            if (eof < 0) exit
        end if
          
        ! Read plant data into arrays
        do ic = 1, imax
        if (bsn_cc%smax == 1) then
          ! For nam run, read pldb(ic), pl_class(ic), and pl_desc(ic)
          read (104,*,iostat=eof) pldb(ic), pl_desc(ic), pl_class(ic)
        else
          ! For regular run, read both only pldb(ic)
            read(104, *, iostat=eof) pldb(ic)
        end if
          if (eof < 0) exit
          pldb(ic)%mat_yrs = Max (1, pldb(ic)%mat_yrs) ! Ensure mat_yrs is at least 1
        end do
        
        exit
      enddo
      endif
      
      ! Set global plant parameter count
      db_mx%plantparm = imax
      
      close (104)
      return
      end subroutine plant_parm_read
