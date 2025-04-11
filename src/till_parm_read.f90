      subroutine till_parm_read
      
      use input_file_module
      use maximum_data_module
      use tillage_data_module
      
      implicit none      

      character (len=80) :: titldum = ""!           |title of file
      character (len=80) :: header = "" !           |header of file
      integer :: eof = 0              !           |end of file
      integer :: imax = 0             !none       |determine max number for array (imax) and total number in file
      logical :: i_exist              !none       |check to determine if file exists
      integer :: itl = 0              !none       |counter
      integer :: mtl = 0              !           |
      
      eof = 0
      imax = 0
      mtl = 0
      bmix_idtill = 0
      
      inquire (file=in_parmdb%till_til, exist=i_exist)
      if (.not. i_exist .or. in_parmdb%till_til == "null") then
          allocate (tilldb(0:0))
      else
        do
          open (105,file=in_parmdb%till_til)
          read (105,*,iostat=eof) titldum
          if (eof < 0) exit
          read (105,*,iostat=eof) header
          if (eof < 0) exit
            do while (eof == 0)
              read (105,*,iostat=eof) titldum
              if (eof < 0) exit
              imax = imax + 1
            end do
            
          allocate (tilldb(0:imax))
          
          rewind (105)
          read (105,*,iostat=eof) titldum
          if (eof < 0) exit
          read (105,*,iostat=eof) header  
          if (eof < 0) exit
          
            do itl = 1, imax
              read (105,*,iostat=eof) tilldb(itl)
              if (tilldb(itl)%tillnm == "biomix") then
                bmix_idtill = itl
                bmix_eff = tilldb(itl)%effmix
                bmix_depth = tilldb(itl)%deptil
              endif
              if (eof < 0) exit
            end do    
          exit
        enddo
        if (bmix_idtill == 0) then
          bmix_eff = 0.2
          bmix_depth = 50. 
        endif
      endif
      
      db_mx%tillparm = imax

      close (105)
      return
      end subroutine till_parm_read