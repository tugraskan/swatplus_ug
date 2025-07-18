      !populate initial constituent data for aquifers
!!@summary Read initial constituent concentrations for aquifers
!!@description
!! Loads nitrate, pesticide and salt starting values from input
!! files and stores them in the aquifer state variables.
!!@arguments
!!    (none) | in/out | module arrays modified
      subroutine aqu_read_init !rtb cs
      
      use basin_module
      use input_file_module
      use maximum_data_module
      use aquifer_module
      use aqu_pesticide_module
      use hydrograph_module
      use constituent_mass_module
      
      implicit none      
      
      character (len=80) :: titldum = ""  !!none | title of file
      character (len=80) :: header = "" !!none | header of file
      integer :: eof = 0                !!none | end of file
      integer :: imax = 0               !!none | determine max number in file
      logical :: i_exist                !!none | check file exists
      integer :: iaqu = 0               !!none | counter
      integer :: iaq = 0                !!none |
      integer :: ics = 0                !!none |
      
      eof = 0
      imax = 0
      
      !read init
      inquire (file=in_aqu%init, exist=i_exist)
      if (.not. i_exist .or. in_aqu%init == "null") then
        allocate (aqu_init(0:0))
      else   
      do
       open (105,file=in_aqu%init)
       read (105,*,iostat=eof) titldum
       if (eof < 0) exit
       read (105,*,iostat=eof) header
       if (eof < 0) exit
        do while (eof == 0)
          read (105,*,iostat=eof) titldum
          if (eof < 0) exit
          imax = imax + 1
        end do

      allocate (aqu_init(0:imax))
      allocate (aqu_init_dat_c(0:imax))

      rewind (105)
      read (105,*,iostat=eof) titldum
      if (eof < 0) exit
      read (105,*,iostat=eof) header
      if (eof < 0) exit
           
       !! read all initial records
       do iaqu = 1, imax
         read (105,*,iostat=eof) aqu_init_dat_c(iaqu)
         if (eof < 0) exit
       end do
       
       end do
       close (105)

      end if

      !! initialize organics and constituents for each aquifer object
      !! initialize organics and constituents for each aquifer object
      do iaq = 1, sp_ob%aqu

        !! initial organic mineral
        do ics = 1, db_mx%om_water_init
          !! initializing organics in aqu_initial - do it here later
          !if (aqu_init(ini)%org_min == 0) write (9001,*) om_init_name(ics), " not found"
        end do
            
      end do

      return
      end subroutine aqu_read_init