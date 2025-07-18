!!@summary Read aquifer definition file
!!@description
!! Loads aquifer parameters and dimensions from the input file
!! and populates the aquifer module arrays.
!!@arguments
!!    (none) | in/out | uses module variables
       subroutine aqu_read
      
       use input_file_module
       use aquifer_module
       use basin_module !rtb gwflow
       use maximum_data_module
       
       implicit none
      
       character (len=500) :: header = "" !!none | input header line
       character (len=80) :: titldum = "" !!none | title dummy
       integer :: eof = 0         !!none | end of file flag
       integer :: i = 0           !!none | counter
       integer :: imax = 0        !!none | maximum count
       integer :: msh_aqp = 0     !!none | counter
       logical :: i_exist         !!none | check file exists
       integer :: ish_aqp = 0     !!none | counter
       integer :: k = 0           !!none | index
       
       msh_aqp = 0
       eof = 0
       imax = 0

       !! read shallow aquifer property data from aquifer.aqu
       inquire (file=in_aqu%aqu, exist=i_exist)
       if (.not. i_exist .or. in_aqu%aqu == "null") then
            allocate (aqudb(0:0))
          else
       do
          open (107,file=in_aqu%aqu)
          read (107,*,iostat=eof) titldum
          if (eof < 0) exit
          read (107,*,iostat=eof) header
          if (eof < 0) exit
            !! loop until end of file to count entries
            do while (eof == 0)
              read (107,*,iostat=eof) i
              if (eof < 0) exit
              imax = Max(imax,i)
              msh_aqp = msh_aqp + 1
            end do 
               
          db_mx%aqudb = msh_aqp
          allocate (aqudb(0:imax))
          rewind (107)
          read (107,*,iostat=eof) titldum
          if (eof < 0) exit
          read (107,*,iostat=eof) header
          if (eof < 0) exit
          
          !! read each aquifer entry
          do ish_aqp = 1, msh_aqp
            read (107,*,iostat=eof) i
            if (eof < 0) exit
            backspace (107)
            !! read from the aquifer database file named aquifer.aqu
            read (107,*,iostat=eof) k, aqudb(i)
            if (eof < 0) exit
          end do

          close (107)
          exit
          
          bsn_cc%gwflow = 0 ! rtb set gwflow module flag to 0
       enddo
       endif
          
       return
       end subroutine aqu_read         