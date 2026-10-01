      subroutine plant_parm_read
      
      use input_file_module
      use maximum_data_module
      use plant_data_module
      use basin_module
      use utils, only : split_line
      
      implicit none 
      
      external :: search
      integer :: ic = 0                   !none       |plant counter
      character (len=80) :: titldum = ""  !           |title of file
      character (len=80) :: header = ""   !           |header of file
      integer :: eof = 0              !           |end of file
      integer :: imax = 0             !none       |determine max number for array (imax) and total number in file
      integer :: mpl = 0              !           | 
      logical :: i_exist              !none       |check to determine if file exists
      character (len=2500) :: line = ""       !   |one plant line
      character (len=50) :: fields(100) = ""  !   |columns of one plant line
      integer :: nf = 0               !none       |number of columns in the plant line
      integer :: k = 0                !none       |column counter
      integer :: ios = 0              !none       |read status of the carbon layout
      type (input_lignin_partition_fracs) :: lig_in   !  |lignin fractions from columns 54-56 (carbon layout)
      
      
      eof = 0
      imax = 0
      mpl = 0

      inquire (file=in_parmdb%plants_plt, exist=i_exist)
      if (.not. i_exist .or. in_parmdb%plants_plt == " null") then
        allocate (pldb(0:0))
        allocate (plcp(0:0))
        allocate (pl_class(0:0))
        if (bsn_cc%cswat == 2) allocate (res_part_fracs(0:0))
      else
      do
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
        if (bsn_cc%cswat == 2) allocate (res_part_fracs(0:imax))
        
        rewind (104)
        read (104,*,iostat=eof) titldum
        if (eof < 0) exit
        read (104,*,iostat=eof) header
        if (eof < 0) exit
        
        !! carbon off - warn if the file has the carbon lignin columns (CLASS and DESCRIPTION would get lignin values)
        if (bsn_cc%cswat /= 2) then
          read (104,'(a)',iostat=eof) line
          if (eof < 0) exit
          call split_line (line, fields, nf)
          if (nf >= 58) then
            write (9001,*) "WARNING: ", trim(in_parmdb%plants_plt), " has lignin columns (54-56) but codes.bsn carbon /= 2;", &
                           " CLASS and DESCRIPTION will hold lignin values"
          end if
          backspace (104)
        end if
        
        do ic = 1, imax
          if (bsn_cc%cswat == 2) then
            !! carbon layout - avg_lig_frac, ab_lig_frac, bg_lig_frac are columns 54-56, between bio_cov and CLASS
            !! take them out and read the remaining 55 columns the same way as without carbon
            read (104,'(a)',iostat=eof) line
            if (eof < 0) exit
            call split_line (line, fields, nf)
            ios = 1
            if (nf >= 58) read (fields(54:56),*,iostat=ios) lig_in
            if (ios == 0) then
              line = ""
              do k = 1, nf
                if (k < 54 .or. k > 56) line = trim(line) // " " // trim(fields(k))
              end do
              if (bsn_cc%nam1 == 0) then
                read (line,*,iostat=ios) pldb(ic)
              else
                read (line,*,iostat=ios) pldb(ic), pl_class(ic)
              end if
            end if
            if (ios /= 0) then
              write (*,*) "ERROR: ", trim(in_parmdb%plants_plt), " plant ", trim(fields(1)), " could not be read;", &
                          " codes.bsn carbon = 2 needs avg_lig_frac, ab_lig_frac, bg_lig_frac as columns 54-56 (before CLASS)"
              write (9001,*) "ERROR: ", trim(in_parmdb%plants_plt), " plant ", trim(fields(1)), " could not be read;", &
                          " codes.bsn carbon = 2 needs avg_lig_frac, ab_lig_frac, bg_lig_frac as columns 54-56 (before CLASS)"
              error stop
            end if
            res_part_fracs(ic)%lig_frac_abg = lig_in%lig_frac_abg
            res_part_fracs(ic)%lig_frac_blg = lig_in%lig_frac_blg
            res_part_fracs(ic)%str_frac_abg = res_part_fracs(ic)%lig_frac_abg / .80 
            res_part_fracs(ic)%str_frac_blg = res_part_fracs(ic)%lig_frac_blg / .80 
            res_part_fracs(ic)%meta_frac_abg = 1.0 - res_part_fracs(ic)%str_frac_abg  
            res_part_fracs(ic)%meta_frac_blg = 1.0 - res_part_fracs(ic)%str_frac_blg 
          else
            if (bsn_cc%nam1 == 0) then
              read (104,*,iostat=eof) pldb(ic)
            else
              read (104,*,iostat=eof) pldb(ic), pl_class(ic)
            end if
            if (eof < 0) exit
          end if
          pldb(ic)%mat_yrs = Max (1, pldb(ic)%mat_yrs)
              
        end do
        
        exit
      enddo
      endif

      db_mx%plantparm = imax
      
      close (104)
      return

      end subroutine plant_parm_read
