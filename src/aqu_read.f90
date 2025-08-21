!!@summary Read aquifer property database from input file and populate aquifer parameter arrays
!!@description This subroutine reads the aquifer property database from the aquifer.aqu input file containing
!! hydraulic and chemical parameters for all aquifer types used in the simulation. The subroutine first
!! determines the file structure by counting entries to allocate appropriate array sizes, then reads
!! aquifer parameters including flow characteristics, depth relationships, nutrient concentrations,
!! and other properties into the aqudb database array. The reading process handles file existence
!! checking and proper memory allocation. The subroutine also initializes groundwater flow module
!! flags for potential advanced groundwater modeling capabilities.
!!@arguments
!! None - reads from global input file names and populates global aquifer database arrays
       subroutine aqu_read 
      
       use input_file_module
       use aquifer_module
       use basin_module !rtb gwflow
       use maximum_data_module
       
       implicit none
      
       character (len=500) :: header = ""   !!none    | file header text for documentation
       character (len=80) :: titldum = ""   !!none    | title line from input file
       integer :: eof = 0                   !!none    | end of file indicator for read operations
       integer :: i = 0                     !!none    | aquifer database index counter
       integer :: imax = 0                  !!none    | maximum aquifer database index found
       integer :: msh_aqp = 0               !!none    | count of aquifer parameter entries
       logical :: i_exist                   !!none    | file existence check flag
       integer :: ish_aqp = 0               !!none    | aquifer parameter reading counter  
       integer :: k = 0                     !!none    | temporary index for reading operations
       
       !! Initialize counters and flags for file processing
       msh_aqp = 0
       eof = 0
       imax = 0

       !! Check for aquifer database file and read aquifer properties
       !! read shallow aquifer property data from aquifer.aqu
       inquire (file=in_aqu%aqu, exist=i_exist)
       !! Handle case where aquifer file does not exist or is null
       if (.not. i_exist .or. in_aqu%aqu == "null") then
            !! Allocate empty aquifer database array
            allocate (aqudb(0:0))
          else
       !! Process aquifer database file when it exists
       do
          !! Open aquifer database file for reading
          open (107,file=in_aqu%aqu)
          !! Read title and header information from file
          read (107,*,iostat=eof) titldum
          if (eof < 0) exit
          read (107,*,iostat=eof) header
          if (eof < 0) exit
          !! First pass: count aquifer entries and find maximum index
            do while (eof == 0)
              read (107,*,iostat=eof) i
              if (eof < 0) exit
              !! Track maximum index for array allocation
              imax = Max(imax,i)
              !! Count total number of aquifer entries
              msh_aqp = msh_aqp + 1
            end do 
               
          !! Store count in database maximum tracking and allocate array
          db_mx%aqudb = msh_aqp
          allocate (aqudb(0:imax))
          !! Reset file position for second reading pass
          rewind (107)
          !! Skip title and header lines again
          read (107,*,iostat=eof) titldum
          if (eof < 0) exit
          read (107,*,iostat=eof) header
          if (eof < 0) exit
          
          !! Second pass: read aquifer parameter data into database array
          do ish_aqp = 1, msh_aqp
            !! Read aquifer index to determine array position
            read (107,*,iostat=eof) i
            if (eof < 0) exit
            !! Backspace to re-read the complete line
            backspace (107)
            !! Read complete aquifer parameter set from database file
            !! read from the aquifer database file named aquifer.aqu
            read (107,*,iostat=eof) k, aqudb(i)
            if (eof < 0) exit
          end do

          !! Close aquifer database file and exit reading loop
          close (107)
          exit
          
          !! Initialize groundwater flow module flag for advanced modeling
          bsn_cc%gwflow = 0 ! rtb set gwflow module flag to 0
       enddo
       endif
          
       return
       end subroutine aqu_read         