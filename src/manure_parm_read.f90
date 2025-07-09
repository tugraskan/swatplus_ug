      subroutine manure_parm_read
      
      use input_file_module
      use maximum_data_module
      use fertilizer_data_module
      
      implicit none
   
      integer :: it = 0                     !!none      |counter
      character (len=80) :: titldum = ""    !!          |title of file
      character (len=80) :: header = ""     !!          |header of file
      character (len=16) :: omad_line = ""  !!          |omad line dummy variable
      integer :: eof = 0                    !!          |end of file
      integer :: unit = 107                 !!          |unit number for file
      integer :: imax = 0                   !!none      |determine max number for array (imax) and total number in file
      integer :: mfrt = 0                   !!          |
      logical :: i_exist                    !!none      |check to determine if file exists
      integer :: i
      
      
      eof = 0
      imax = 0
      mfrt = 0
      
      inquire (file="manure.frt", exist=i_exist)
      if (.not. i_exist .or. "manure.frt" == "null") then
         allocate (manure_db(0:0))
      else
      do  
        open (107,file="manure.frt")
        read (107,*,iostat=eof) titldum
        if (eof < 0) exit
        read (107,*,iostat=eof) header
        if (eof < 0) exit
           do while (eof == 0) 
             read (107,*,iostat=eof) titldum
             if (eof < 0) exit
             imax = imax + 1
           end do
           
        allocate (manure_db(0:imax))
        
        rewind (107)
        read (107,*,iostat=eof) titldum
        if (eof < 0) exit
        read (107,*,iostat=eof) header
        if (eof < 0) exit
        
        do it = 1, imax
          read (107,*,iostat=eof) manure_db(it)
          if (eof < 0) exit
        end do
       exit
      enddo
      endif
      
      db_mx%manureparm  = imax 
      close (107)
      
      !! reset counters for omad database
      eof = 0
      imax = 0
      
      !! --- inquire if omad.txt exists --- !!
      inquire (file="omad.txt", exist=i_exist)
      if (.not. i_exist .or. "omad.txt" == "null") then
          allocate (omad_db(0:0))
      else
            open (unit,file="omad.txt")
            do while (eof == 0)
                read (unit,*,iostat=eof) omad_line ! read dummy omad line
                if (eof < 0) exit
                imax = imax + 1
            end do
            !! ensure that imax is a multiple of 8 and omad is in proper format 
            if (mod(imax, 8) /= 0) then
                ! if not then write error message to diagnostics.out file and allocate empty omad_db
                write (9001, *) "Error: OMAD file does not have a multiple of 8 lines / not in proper format"
                allocate (omad_db(0:0))       
            else
                imax = imax / 8
                allocate (omad_db(0:imax))
                rewind (unit)
                !! read the omad database
                do it = 1, imax
                    read(unit, *, iostat=eof) omad_db(it)%manure_name, omad_db(it)%manure_desc
                    read(unit, *, iostat=eof) omad_db(it)%omadtyp
                    read(unit, *, iostat=eof) omad_db(it)%astgc
                    read(unit, *, iostat=eof) omad_db(it)%astlbl
                    read(unit, *, iostat=eof) omad_db(it)%astlig
                    read(unit, *, iostat=eof) omad_db(it)%cn
                    read(unit, *, iostat=eof) omad_db(it)%cp
                    read(unit, *, iostat=eof) omad_db(it)%cs
                end do
            endif
            close (unit)
            
            !xwalk fertdb_cbn(it)%omad%manure_name to omad_db(it)%manure_name

            do i = 1, size(fertdb_cbn)
              do it = 1, size(omad_db)
                if (fertdb_cbn(i)%omad%manure_name == omad_db(it)%manure_name) then
                  fertdb_cbn(i)%omad = omad_db(it)
                  exit  ! Stop searching once a match is found
                end if
              end do
            end do
        endif
             
      return
      end subroutine manure_parm_read