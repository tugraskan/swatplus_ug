!--------------------------------------------------------------------
!  manure_parm_read
!    Load manure attribute information from the manure_om.man table.
!    When fertilizer records reference an om_name, the corresponding 
!    attributes are copied into the manure database for later use.
!    
!    Features direct name-to-name crosswalking between fertilizer_ext.frt
!    om_name field and manure_om.man name field, replacing the previous
!    CSV-based approach with a streamlined database system.
!    
!    Includes automatic unit conversion based on manure type:
!      - 1 lb/1000 gal = 119.82 ppm (liquid/slurry types)
!      - 1 lb/ton = 500 ppm (solid/semi-solid types)
!    Conversion factor determined by manure type column (typ).
!--------------------------------------------------------------------
subroutine manure_parm_read
      
      use input_file_module
      use maximum_data_module
      use fertilizer_data_module
      
      implicit none
   
      integer :: it = 0                     !!none      |counter
      character (len=80) :: manure_file = "manure_om.man"        !!          |filename for manure file
      character (len=256) :: header = ""     !!          |header of file
      integer :: eof = 0                    !!          |end of file
      integer :: unit = 107                 !!          |unit number for file
      integer :: imax = 0                   !!none      |determine max number for array (imax) and total number in file
      logical :: i_exist                    !!none      |check to determine if file exists
      integer :: i
      real :: conversion_factor             !!          |unit conversion factor

      eof = 0
      imax = 0

      
      !! --- inquire if manure_om.man exists --- !!
      inquire (file=manure_file, exist=i_exist)
      if (.not. i_exist .or. manure_file == "null") then
          allocate (manure_om_db(0:0))
          db_mx%manureparm = 0
      else
            open (unit,file=manure_file)
            read(unit,'(A)',iostat=eof) header   ! skip header line
            do while (eof == 0)
                read(unit,*,iostat=eof) 
                if (eof < 0) exit
                imax = imax + 1                ! count number of records
            end do
            allocate (manure_om_db(0:imax))       ! allocate array for all records
            rewind(unit)
            read(unit,'(A)',iostat=eof) header
            do it = 1, imax
                read (unit,*,iostat=eof) manure_om_db(it)%name, &
                     manure_om_db(it)%region, &
                     manure_om_db(it)%source, &
                     manure_om_db(it)%typ, &
                     manure_om_db(it)%pct_moist, &
                     manure_om_db(it)%pct_solid, &
                     manure_om_db(it)%tot_c, &
                     manure_om_db(it)%tot_n, &
                     manure_om_db(it)%inorg_n, &
                     manure_om_db(it)%org_n, &
                     manure_om_db(it)%tot_p2o5, &
                     manure_om_db(it)%inorg_p2o5, &
                     manure_om_db(it)%org_p2o5, &
                     manure_om_db(it)%inorg_p, &
                     manure_om_db(it)%org_p, &
                     manure_om_db(it)%solids, &
                     manure_om_db(it)%water
                if (eof < 0) exit
                
                !! Apply unit conversions
                !! Determine conversion factor based on manure type column
                !! 1 lb/1000 gal = 119.82 ppm for liquid and slurry
                !! 1 lb/ton = 500 ppm for solid and semi-solid
                if (trim(manure_om_db(it)%typ) == 'liquid' .or. trim(manure_om_db(it)%typ) == 'slurry') then
                    conversion_factor = 119.82  ! 1 lb/1000 gal = 119.82 ppm for liquid/slurry
                else
                    conversion_factor = 500.0   ! 1 lb/ton = 500 ppm for solid/semi-solid
                endif
                
                !! Legacy moisture-based logic (commented out for reference):
                !! Determine if manure is liquid/slurry or solid/semi-solid based on moisture content
                !! Generally, >85% moisture is considered liquid, <85% is solid/semi-solid
                !is_liquid = manure_om_db(it)%pct_moist > 85.0
                !if (is_liquid) then
                !    conversion_factor = 119.82  ! 1 lb/1000 gal = 119.82 ppm for liquid/slurry
                !else
                !    conversion_factor = 500.0   ! 1 lb/ton = 500 ppm for solid/semi-solid
                !endif
                
                !! Convert variables from tot_c to water
                manure_om_db(it)%tot_c = manure_om_db(it)%tot_c * conversion_factor
                manure_om_db(it)%tot_n = manure_om_db(it)%tot_n * conversion_factor
                manure_om_db(it)%inorg_n = manure_om_db(it)%inorg_n * conversion_factor
                manure_om_db(it)%org_n = manure_om_db(it)%org_n * conversion_factor
                manure_om_db(it)%tot_p2o5 = manure_om_db(it)%tot_p2o5 * conversion_factor
                manure_om_db(it)%inorg_p2o5 = manure_om_db(it)%inorg_p2o5 * conversion_factor
                manure_om_db(it)%org_p2o5 = manure_om_db(it)%org_p2o5 * conversion_factor
                manure_om_db(it)%inorg_p = manure_om_db(it)%inorg_p * conversion_factor
                manure_om_db(it)%org_p = manure_om_db(it)%org_p * conversion_factor
                manure_om_db(it)%solids = manure_om_db(it)%solids * conversion_factor
                manure_om_db(it)%water = manure_om_db(it)%water * conversion_factor
            end do
            close (unit)

            db_mx%manureparm = imax

            ! Crosswalk the manure_om.man records with fertilizer_ext.frt
            ! entries.  When the om_name matches the name field in the
            ! manure_om.man record, copy the manure attributes into the
            ! manure_db so they are available during simulations.
            if (size(manure_db) > 0 .and. size(manure_om_db) > 0) then
              do i = 1, size(manure_db)
                do it = 1, size(manure_om_db)
                  if (trim(manure_db(i)%om_name) == trim(manure_om_db(it)%name)) then
                    manure_db(i)%manucontent = manure_om_db(it)
                    exit  ! Stop searching once a match is found
                  end if
                end do
              end do
            end if
        endif
             
      return
      end subroutine manure_parm_read
