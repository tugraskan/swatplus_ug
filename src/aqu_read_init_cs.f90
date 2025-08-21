!!@summary Read initial salt and constituent data for aquifer chemical initialization from specialized input file
!!@description This subroutine reads the initial.aqu_cs file containing initial salt ion concentrations and
!! general constituent data for comprehensive aquifer chemical initialization. It processes pesticide, pathogen,
!! salt, and constituent initial conditions, calculating both dissolved and sorbed phases. The subroutine
!! handles unit conversions between mass and concentration bases, calculates groundwater volumes and aquifer
!! bulk properties for proper mass balance initialization. It links aquifer initialization names to specific
!! chemical datasets and distributes constituents appropriately between dissolved and sorbed phases.
!!@arguments
!! None - reads from fixed filename "initial.aqu_cs" and populates global aquifer constituent arrays
      subroutine aqu_read_init_cs !rtb salt/cs
      
      use basin_module
      use input_file_module
      use maximum_data_module
      use aquifer_module
      use aqu_pesticide_module
      use hydrograph_module
      use constituent_mass_module
      
      implicit none      
      
      character (len=80) :: titldum = ""  !!none       | title line from chemical initialization file
      character (len=80) :: header = ""   !!none       | header line describing file format
      integer :: eof = 0                  !!none       | end of file indicator for read operations
      integer :: imax = 0                 !!none       | maximum number of initialization records found
      logical :: i_exist                  !!none       | file existence check flag
      integer :: i = 0                    !!none       | general counter variable
      integer :: iaqu = 0                 !!none       | aquifer initialization record counter
      integer :: ictr = 0                 !!none       | constituent initialization counter
      integer :: isp_ini = 0              !!none       | species initialization index counter
      integer :: idat = 0                 !!none       | data object identifier
      integer :: init = 0                 !!none       | initialization flag variable
      integer :: iaq = 0                  !!none       | aquifer object counter
      integer :: iob = 0                  !!none       | object identifier for area calculations
      integer :: idb = 0                  !!none       | database identifier index
      integer :: ini = 0                  !!none       | initialization index variable
      integer :: ipest = 0                !!none       | pesticide species counter
      integer :: ipath = 0                !!none       | pathogen species counter
      integer :: isalt = 0                !!none       | salt ion species counter
      integer :: init_aqu = 0             !!none       | aquifer initialization identifier
      integer :: ics = 0                  !!none       | constituent species counter
      integer :: iaqdb = 0                !!none       | aquifer database parameter index
      real :: gw_volume = 0.              !!m3         | volume of groundwater in aquifer
      real :: aqu_volume = 0.             !!m3         | total volume of aquifer material
      real :: aqu_bd = 0.                 !!kg/m3      | bulk density of aquifer material
      real :: aqu_mass = 0.               !!kg         | total mass of aquifer material
      real :: mass_sorbed = 0.            !!kg         | mass of sorbed constituent in aquifer
      
      !! Initialize file processing counters and flags
      eof = 0
      imax = 0
            
      !! Check for specialized chemical initialization file and process if it exists
      !read initial.aqu_cs
      inquire (file="initial.aqu_cs",exist=i_exist)
      if(i_exist) then
       
        !! Process chemical initialization file
        do
          !! Open chemical initialization file for reading
          open (105,file="initial.aqu_cs")
          !! Read file header information
          read (105,*,iostat=eof) titldum
          if (eof < 0) exit
          read (105,*,iostat=eof) header
          if (eof < 0) exit
          !! First pass: count initialization records for array allocation
          do while (eof == 0)
            read (105,*,iostat=eof) titldum
            if (eof < 0) exit
            !! Count each chemical initialization record
            imax = imax + 1
          end do

          !! Allocate chemical initialization array based on count found
          !allocate array
          allocate (aqu_init_dat_c_cs(imax))

          !! Reset file position for second reading pass
          !read initialization names
          rewind (105)
          !! Skip header lines again
          read (105,*,iostat=eof) titldum
          if (eof < 0) exit
          read (105,*,iostat=eof) header
          if (eof < 0) exit
          !! Second pass: read chemical initialization data into arrays
          do iaqu = 1, imax
            !! Read complete chemical initialization data for each record
            read (105,*,iostat=eof) aqu_init_dat_c_cs(iaqu)
            if (eof < 0) exit
          enddo
       
        enddo
        !! Close chemical initialization file
        close (105)
      
        !! Apply chemical initialization data to each aquifer object in simulation
        !! initialize organics and constituents for each aquifer object
        do iaq = 1, sp_ob%aqu
          !! Calculate aquifer object identifiers and physical properties
          iob = sp_ob1%aqu + iaq - 1
          idat = ob(iob)%props
          !! Calculate groundwater volume from storage and area
          gw_volume = (aqu_d(iaq)%stor/1000.)*(ob(iob)%area_ha*10000.) !m3 of groundwater
          iaqdb = ob(iob)%props !get database of the aquifer object
          !! Calculate total aquifer material volume excluding porosity
          aqu_volume = (ob(iob)%area_ha*10000.) * aqudb(iaqdb)%dep_bot * (1-aqu_dat(iaq)%spyld) !m3 of aquifer material
          !! Assume standard bulk density for aquifer material
          aqu_bd = 2000. !kg/m3 bulk density (assumed)
          !! Calculate total mass of aquifer material for sorption calculations
          aqu_mass = aqu_volume * aqu_bd !m3 * kg/m3 --> kg
          
          !! Initialize pesticide concentrations in aquifer water and sorbed phases
          !! initial pesticides
          do isp_ini = 1, imax
            !! Find matching initialization name for current aquifer
            if (aqu_init_dat_c_cs(isp_ini)%name == aqudb(iaq)%aqu_ini) then
              !! Process pesticide initialization data
              do ics = 1, db_mx%pestw_ini
                if (aqu_init_dat_c_cs(isp_ini)%pest == pest_init_name(ics)) then
                  !! Set initial pesticide masses in aquifer using unit conversions
                  !! initialize pesticides in aquifer water and benthic from input data
                  do ipest = 1, cs_db%num_pests
                    !! Convert mg/kg to kg/ha: mg/kg * t/m3 * m * ha * conversion factors
                    !! kg/ha = mg/kg (ppm) * t/m3  * m * 10000.m2/ha * 1000kg/t * kg/1000000 mg
                    !! assume bulk density of 2.0 t/m3
                    cs_aqu(iaq)%pest(ipest) = pest_water_ini(ics)%water(ipest) * 2.0 * aqudb(iaq)%dep_bot * 10.
                  end do
                  exit
                end if
              end do  
            endif
          enddo
           
          !! Initialize pathogen concentrations in aquifer water
          !! initial pathogens
          do isp_ini = 1, imax
            !! Find matching initialization name for current aquifer
            if (aqu_init_dat_c_cs(isp_ini)%name == aqudb(iaq)%aqu_ini) then
              !! Process pathogen initialization data
              do ics = 1, db_mx%pathw_ini
                if (aqu_init_dat_c_cs(isp_ini)%path == path_init_name(ics)) then
                  !! Set initial pathogen concentrations in aquifer from input data
                  !! initialize pathogens in aquifer water and benthic from input data
                  do ipath = 1, cs_db%num_paths
                    cs_aqu(iaq)%path(ipath) = path_soil_ini(ics)%soil(ipath)
                  end do
                  exit
                end if
              end do  
            endif
          enddo
            
          !! Initialize salt ion concentrations in aquifer water
          !! initial salts !rtb salt
          if(cs_db%num_salts > 0) then
          !! Process salt initialization data when salts are simulated
          do ics = 1, db_mx%salt_gw_ini
            if (aqu_init_dat_c_cs(iaq)%salt == salt_aqu_ini(ics)%name) then
              !! Set initial salt ion concentrations and masses
              !loop for salt ions
              do isalt = 1,cs_db%num_salts
                !! Set salt concentration in groundwater (mg/L)
                cs_aqu(iaq)%saltc(isalt) = salt_aqu_ini(ics)%conc(isalt) !g/m3 (mg/L)
                !! Convert concentration to total mass: g/m3 * m3 / 1000 = kg
                cs_aqu(iaq)%salt(isalt) = (salt_aqu_ini(ics)%conc(isalt)*gw_volume) / 1000. !g/m3 --> kg
              enddo
              exit
            end if
          end do
          endif
          
          !! Initialize general constituent concentrations in dissolved and sorbed phases
          !! initial constituents !rtb cs
          if(cs_db%num_cs > 0) then
          !! Process constituent initialization data when constituents are simulated
          do ictr = 1, db_mx%cs_aqu_ini
            if (aqu_init_dat_c_cs(iaq)%cs == cs_aqu_ini(ictr)%name) then
              !! Set initial constituent concentrations and calculate masses
              do ics = 1, cs_db%num_cs
                !! Set constituent concentration in groundwater (mg/L)
                cs_aqu(iaq)%csc(ics) = cs_aqu_ini(ictr)%aqu(ics) !g/m3 (mg/L)
                !! Convert concentration to total dissolved mass: g/m3 * m3 / 1000 = kg
                cs_aqu(iaq)%cs(ics) = (cs_aqu_ini(ictr)%aqu(ics)*gw_volume) / 1000. !g/m3 --> kg
                !! Set sorbed constituent concentration in aquifer material (mg/kg)
                cs_aqu(iaq)%csc_sorb(ics) = cs_aqu_ini(ictr)%aqu(ics+cs_db%num_cs) !mg/kg
                !! Calculate total sorbed mass: mg/kg * kg / 1e6 = kg
                mass_sorbed = (cs_aqu(iaq)%csc_sorb(ics)*aqu_mass)/1.e6 !mg/kg * kg / 1.e6 = kg
                !! Convert sorbed mass to area basis for consistency: kg / ha
                cs_aqu(iaq)%cs_sorb(ics) = mass_sorbed / ob(iob)%area_ha !kg/ha
              enddo
              exit
            end if
          end do
          endif

        end do
      
      return
      end subroutine aqu_read_init_cs
      