      subroutine manure_parm_read
      
      use input_file_module
      use maximum_data_module
      use fertilizer_data_module
      
      implicit none
   
      integer :: it = 0                     !!none      |counter
      character (len=80) :: titldum = ""    !!          |title of file
      character (len=256) :: header = ""     !!          |header of file
      character (len=256) :: csv_line = ""  !! line for csv file
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
      
      !! --- inquire if fp5-manure-content-defaults-swat.csv exists --- !!
      inquire (file="fp5-manure-content-defaults-swat.csv", exist=i_exist)
      if (.not. i_exist .or. "fp5-manure-content-defaults-swat.csv" == "null") then
          allocate (omad_db(0:0))
      else
            open (unit,file="fp5-manure-content-defaults-swat.csv")
            read(unit,'(A)',iostat=eof) header   ! skip header line
            do while (eof == 0)
                read(unit,'(A)',iostat=eof) csv_line
                if (eof < 0) exit
                imax = imax + 1
            end do
            allocate (omad_db(0:imax))
            rewind(unit)
            read(unit,'(A)',iostat=eof) header
            do it = 1, imax
                read(unit,'(A)',iostat=eof) csv_line
                if (eof < 0) exit
                read(csv_line,*) &
                     omad_db(it)%manure_region, &
                     omad_db(it)%manure_source, &
                     omad_db(it)%manure_type, &
                     omad_db(it)%pct_moisture, &
                     omad_db(it)%pct_solids, &
                     omad_db(it)%total_c, &
                     omad_db(it)%total_n, &
                     omad_db(it)%inorganic_n, &
                     omad_db(it)%organic_n, &
                     omad_db(it)%total_p2o5, &
                     omad_db(it)%inorganic_p2o5, &
                     omad_db(it)%organic_p2o5, &
                     omad_db(it)%inorganic_p, &
                     omad_db(it)%organic_p, &
                     omad_db(it)%solids, &
                     omad_db(it)%water, &
                     omad_db(it)%units, &
                     omad_db(it)%sample_size, &
                     omad_db(it)%summary_level, &
                     omad_db(it)%data_source
                omad_db(it)%manure_name = trim(omad_db(it)%manure_region)//trim(omad_db(it)%manure_source)//"_"// &
                     trim(omad_db(it)%manure_type)
            end do
            close (unit)

            ! crosswalk OMAD records to entries loaded from fertilizer_ext.frt
            if (size(fertdb_cbn) > 0 .and. size(omad_db) > 0) then
              do i = 1, size(fertdb_cbn)
                do it = 1, size(omad_db)
                  if (trim(fertdb_cbn(i)%omad%manure_name) == trim(omad_db(it)%manure_name)) then
                    fertdb_cbn(i)%omad = omad_db(it)
                    exit  ! Stop searching once a match is found
                  end if
                end do
              end do
            end if
        endif
             
      return
      end subroutine manure_parm_read
