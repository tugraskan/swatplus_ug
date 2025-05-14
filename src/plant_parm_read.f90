      subroutine plant_parm_read
      
      use input_file_module
      use maximum_data_module
      use plant_data_module
      use basin_module
      use input_read_module
      
      implicit none 

      integer :: ic = 0                   !none       |plant counter
      character (len=80) :: titldum = ""  !           |title of file
      character (len=2000) :: header = ""   !           |header of file
      character (len=80) :: plclass = ""  !           |plant class - row crop, close grown, grass, tree, etc
      integer :: eof = 0              !           |end of file
      integer :: imax = 0             !none       |determine max number for array (imax) and total number in file
      integer :: mpl = 0              !           | 
      logical :: i_exist              !none       |check to determine if file exists
      character(len=2000) :: fmt_line
      character(len=2000) :: raw_line
      integer             :: ios
      character(len=3) :: pvar = '*'

      
      
      eof = 0
      imax = 0
      mpl = 0

      inquire (file=in_parmdb%plants_plt, exist=i_exist)
      if (.not. i_exist .or. in_parmdb%plants_plt == " null") then
        allocate (pldb(0:0))
        allocate (plcp(0:0))
        allocate (pl_class(0:0))
      else

          do
            tag = trim(in_parmdb%plants_plt)
            hmap => get_map_by_tag(tag)
            open (104,file=in_parmdb%plants_plt)
            read (104,*,iostat=eof) titldum
            if (eof < 0) exit
            read (104,*,iostat=eof) header
            if (eof < 0) exit
              do while (eof == 0)
                read (104,*,iostat=eof) titldum
                if (eof < 0) exit
                imax = imax + 1
              end do
            allocate (pldb(0:imax))
            allocate (plcp(0:imax))
            allocate (pl_class(0:imax))
        
            rewind (104)
            read (104,*,iostat=eof) titldum
            if (eof < 0) exit
            read (104,pvar,iostat=eof) header            
            if (eof < 0) exit
            !if (mapping_avail) then
                !call check_headers(header, hmap)
            !end if
        
          
            do ic = 1, imax
              if (bsn_cc%nam1 /= 0) then
                  !if (mapping_avail .and. .not. hmap%is_correct) then
                      !print *, 'k'
                    !— read raw text line —
                    !read(104,pvar,iostat=ios) raw_line
                    !if (ios /= 0) exit
                    !— reorder into fmt_line using the map for this file —
                        !call reorder_line(raw_line, hmap%expected, hmap%default_vals, &
                            !hmap%col_order, fmt_line)
                    !— unpack into your derived type —
                    !read(fmt_line,*,iostat=eof) pldb(ic)
                !else
                    read (104,*,iostat=eof) pldb(ic)
                !endif
              else
                read (104,*,iostat=eof) pldb(ic), pl_class(ic)
              end if
              if (eof < 0) exit
              pldb(ic)%mat_yrs = Max (1, pldb(ic)%mat_yrs)
            end do
        
            exit
          enddo
        endif


      db_mx%plantparm = imax
      
      close (104)
      return
      end subroutine plant_parm_read
