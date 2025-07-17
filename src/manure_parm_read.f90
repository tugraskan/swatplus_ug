      subroutine manure_parm_read
      
      use input_file_module
      use maximum_data_module
      use fertilizer_data_module
      
      implicit none
   
      integer :: it = 0                     !!none      |counter
      character (len=80) :: csv = "fp5-manure-content-defaults-swat.csv"        !!          |filename for csv file
      character (len=256) :: header = ""     !!          |header of file
      character (len=1000) :: csv_line = ""  !! line for csv file
      integer :: eof = 0                    !!          |end of file
      integer :: unit = 107                 !!          |unit number for file
      integer :: imax = 0                   !!none      |determine max number for array (imax) and total number in file
      logical :: i_exist                    !!none      |check to determine if file exists
      integer :: i


      eof = 0
      imax = 0

      
      !! --- inquire if fp5-manure-content-defaults-swat.csv exists --- !!
      inquire (file=csv, exist=i_exist)
      if (.not. i_exist .or. csv == "null") then
          allocate (manure_csv(0:0))
          db_mx%manureparm = 0
      else
            open (unit,file=csv)
            read(unit,'(A)',iostat=eof) header   ! skip header line
            do while (eof == 0)
                read(unit,'(A)',iostat=eof) csv_line
                if (eof < 0) exit
                imax = imax + 1
            end do
            allocate (manure_csv(0:imax))
            rewind(unit)
            read(unit,'(A)',iostat=eof) header
            do it = 1, imax
                read (107,*,iostat=eof) manure_csv(it)%manure_region, &
                     manure_csv(it)%manure_source, &
                     manure_csv(it)%manure_type, &
                     manure_csv(it)%pct_moisture, &
                     manure_csv(it)%pct_solids, &
                     manure_csv(it)%total_c, &
                     manure_csv(it)%total_n, &
                     manure_csv(it)%inorganic_n, &
                     manure_csv(it)%organic_n, &
                     manure_csv(it)%total_p2o5, &
                     manure_csv(it)%inorganic_p2o5, &
                     manure_csv(it)%organic_p2o5, &
                     manure_csv(it)%inorganic_p, &
                     manure_csv(it)%organic_p, &
                     manure_csv(it)%solids, &
                     manure_csv(it)%water, &
                     manure_csv(it)%units, &
                     manure_csv(it)%sample_size, &
                     manure_csv(it)%summary_level, &
                     manure_csv(it)%data_source
                manure_csv(it)%manure_name = trim(manure_csv(it)%manure_region)//"_"//trim(manure_csv(it)%manure_source)//"_"// &
                     trim(manure_csv(it)%manure_type)
                if (eof < 0) exit
            end do
            close (unit)

            db_mx%manureparm = imax

            ! crosswalk manure content records to entries loaded from fertilizer_ext.frt
            if (size(manure_db) > 0 .and. size(manure_csv) > 0) then
              do i = 1, size(manure_db)
                do it = 1, size(manure_csv)
                  if (trim(manure_db(i)%csv) == trim(manure_csv(it)%manure_name)) then

                    ! store attributes from matching csv record
                    manure_db(i)%manucontent = manure_csv(it)
                    exit  ! Stop searching once a match is found
                  end if
                end do
              end do
            end if
        endif
             
      return
      end subroutine manure_parm_read
