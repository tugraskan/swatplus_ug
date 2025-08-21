!!@summary Read initial constituent and organic matter data for aquifer initialization from input files
!!@description This subroutine reads the aquifer initialization file containing initial constituent concentrations,
!! organic matter, and other chemical data for proper aquifer simulation startup. The subroutine handles
!! file structure determination, memory allocation for initialization arrays, and population of aquifer
!! starting conditions. It processes both organic mineral and constituent initialization data to ensure
!! accurate representation of initial aquifer chemistry. The subroutine includes file existence checking
!! and handles cases where initialization files are not provided or specified as null.
!!@arguments
!! None - reads from global input file configuration and populates global aquifer initialization arrays
      !populate initial constituent data for aquifers
      subroutine aqu_read_init !rtb cs
      
      use basin_module
      use input_file_module
      use maximum_data_module
      use aquifer_module
      use aqu_pesticide_module
      use hydrograph_module
      use constituent_mass_module
      
      implicit none      
      
      character (len=80) :: titldum = ""  !!none       | title line from aquifer initialization file
      character (len=80) :: header = ""   !!none       | header line describing file format
      integer :: eof = 0                  !!none       | end of file indicator for read operations
      integer :: imax = 0                 !!none       | maximum number of initialization records found
      logical :: i_exist                  !!none       | file existence check flag
      integer :: iaqu = 0                 !!none       | aquifer initialization record counter
      integer :: iaq = 0                  !!none       | aquifer object counter
      integer :: ics = 0                  !!none       | constituent/organic matter counter
      
      !! Initialize file processing counters
      eof = 0
      imax = 0
      
      !! Check for aquifer initialization file and process if it exists
      !read init
      inquire (file=in_aqu%init, exist=i_exist)
      !! Handle case where initialization file does not exist or is null
      if (.not. i_exist .or. in_aqu%init == "null") then
        !! Allocate empty initialization array when no file provided
        allocate (aqu_init(0:0))
      else   
      !! Process aquifer initialization file when it exists
      do
       !! Open aquifer initialization file for reading
       open (105,file=in_aqu%init)
       !! Read file header information
       read (105,*,iostat=eof) titldum
       if (eof < 0) exit
       read (105,*,iostat=eof) header
       if (eof < 0) exit
        !! First pass: count initialization records for array allocation
        do while (eof == 0)
          read (105,*,iostat=eof) titldum
          if (eof < 0) exit
          !! Count each initialization record
          imax = imax + 1
        end do

      !! Allocate initialization arrays based on count found
      allocate (aqu_init(0:imax))
      allocate (aqu_init_dat_c(0:imax))

      !! Reset file position for second reading pass
      rewind (105)
      !! Skip header lines again
      read (105,*,iostat=eof) titldum
      if (eof < 0) exit
      read (105,*,iostat=eof) header
      if (eof < 0) exit
           
       !! Second pass: read initialization data into arrays
       do iaqu = 1, imax
         !! Read complete initialization data for each aquifer record
         read (105,*,iostat=eof) aqu_init_dat_c(iaqu)
         if (eof < 0) exit
       end do
       
       end do
       !! Close aquifer initialization file
       close (105)

      end if

      !! Apply initialization data to each aquifer object in simulation
      !! initialize organics and constituents for each aquifer object
      do iaq = 1, sp_ob%aqu

        !! Process initial organic mineral initialization for each aquifer
        !! initial organic mineral
        do ics = 1, db_mx%om_water_init
          !! Note: Organic matter initialization is deferred to aqu_initial subroutine
          !! initializing organics in aqu_initial - do it here later
          !if (aqu_init(ini)%org_min == 0) write (9001,*) om_init_name(ics), " not found"
        end do
            
      end do

      return
      end subroutine aqu_read_init