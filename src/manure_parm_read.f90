      subroutine manure_parm_read
      
      use input_file_module
      use maximum_data_module
      use fertilizer_data_module
      
      implicit none
   
      integer :: it = 0                     !!none      |counter
      character (len=256) :: header = ""     !!          |header of file
      character (len=256) :: csv_line = ""  !! line for csv file
      integer :: eof = 0                    !!          |end of file
      integer :: unit = 107                 !!          |unit number for file
      integer :: imax = 0                   !!none      |determine max number for array (imax) and total number in file
      logical :: i_exist                    !!none      |check to determine if file exists
      integer :: i


      eof = 0
      imax = 0

      
      !! --- inquire if fp5-manure-content-defaults-swat.csv exists --- !!
      inquire (file="fp5-manure-content-defaults-swat.csv", exist=i_exist)
      if (.not. i_exist .or. "fp5-manure-content-defaults-swat.csv" == "null") then
          allocate (manure_db(0:0))
          db_mx%manureparm = 0
      else
            open (unit,file="fp5-manure-content-defaults-swat.csv")
            read(unit,'(A)',iostat=eof) header   ! skip header line
            do while (eof == 0)
                read(unit,'(A)',iostat=eof) csv_line
                if (eof < 0) exit
                imax = imax + 1
            end do
            allocate (manure_db(0:imax))
            rewind(unit)
            read(unit,'(A)',iostat=eof) header
            do it = 1, imax
                read(unit,'(A)',iostat=eof) csv_line
                if (eof < 0) exit
                read(csv_line,*) &
                     manure_db(it)%manure_region, &
                     manure_db(it)%manure_source, &
                     manure_db(it)%manure_type, &
                     manure_db(it)%pct_moisture, &
                     manure_db(it)%pct_solids, &
                     manure_db(it)%total_c, &
                     manure_db(it)%total_n, &
                     manure_db(it)%inorganic_n, &
                     manure_db(it)%organic_n, &
                     manure_db(it)%total_p2o5, &
                     manure_db(it)%inorganic_p2o5, &
                     manure_db(it)%organic_p2o5, &
                     manure_db(it)%inorganic_p, &
                     manure_db(it)%organic_p, &
                     manure_db(it)%solids, &
                     manure_db(it)%water, &
                     manure_db(it)%units, &
                     manure_db(it)%sample_size, &
                     manure_db(it)%summary_level, &
                     manure_db(it)%data_source
                manure_db(it)%manure_name = trim(manure_db(it)%manure_region)//trim(manure_db(it)%manure_source)//"_"// &
                     trim(manure_db(it)%manure_type)
            end do
            close (unit)

            db_mx%manureparm = imax

            ! crosswalk manure content records to entries loaded from fertilizer_ext.frt
            if (size(fertdb_cbn) > 0 .and. size(manure_db) > 0) then
              do i = 1, size(fertdb_cbn)
                do it = 1, size(manure_db)
                  if (trim(fertdb_cbn(i)%manure_content%manure_name) == trim(manure_db(it)%manure_name)) then
                    fertdb_cbn(i)%manure_content = manure_db(it)
                    exit  ! Stop searching once a match is found
                  end if
                end do
              end do
            end if
        endif
             
      return
      end subroutine manure_parm_read
