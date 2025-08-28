!--------------------------------------------------------------------
!  fertilizer_data_module
!    Data structures for storing fertilizer and manure properties
!    loaded from fertilizer parameter files and associated CSV
!    records.  These structures provide composition information used
!    by fertilizer application routines.
!--------------------------------------------------------------------
module fertilizer_data_module
     
      implicit none
          
      type fertilizer_db
        character(len=16) :: fertnm = " "
        real :: fminn = 0.            !! kg minN/kg frt     |fract of fert which is mineral nit (NO3+NH3)
        real :: fminp = 0.            !! kg minN/kg frt     |frac of fert which is mineral phos
        real :: forgn = 0.            !! kg orgN/kg frt     |frac of fert which is org n
        real :: forgp = 0.            !! kg orgP/kg frt     |frac of fert which is org p
        real :: fnh3n = 0.            !! kg NH3-N/kg N      |frac of mineral N content of fert which is NH3
      end type fertilizer_db
      type (fertilizer_db), dimension(:),allocatable, save :: fertdb
      

      type manure_organic_matter_data
        character(len=25) :: name = " "
        character(len=25) :: region = " "
        character(len=25) :: source = " "
        character(len=25) :: typ = " "
        real :: pct_moist = 0.0
        real :: pct_solid = 0.0
        real :: tot_c = 0.0
        real :: tot_n = 0.0
        real :: inorg_n = 0.0
        real :: org_n = 0.0
        real :: tot_p2o5 = 0.0
        real :: inorg_p2o5 = 0.0
        real :: org_p2o5 = 0.0
        real :: inorg_p = 0.0
        real :: org_p = 0.0
        real :: solids = 0.0
        real :: water = 0.0
        !character(len=16) :: units = " "
        !real :: sample_size = 0.0
        !character(len=16) :: summary_level = " "
        !character(len=16) :: data_source = " "
      end type manure_organic_matter_data
      type (manure_organic_matter_data), dimension(:),allocatable :: manure_om_db
      
      type manure_database
        type(fertilizer_db) :: base     !! base fertilizer data
        character(len=16) ::  name = " "  !! e.g., Midwest_Beef_Liquid
        character(len=25) ::  om_name = " "  !! name for crosswalking with manure_om.man
        type(manure_organic_matter_data) :: manucontent !! manure attributes from manure_om.man record
        character(len=16) :: pest = ""  !! pest.man name
        character(len=16) :: path = ""  !! path.man name
        character(len=16) :: salt = ""  !! salt.man name
        character(len=16) :: hmet = ""  !! hmet.man name
        character(len=16) :: cs = ""    !! cs.man name
        !! Pre-computed indices for direct array access (set during initialization)
        integer :: pest_idx = 0         !! index into pest_fert_soil_ini array
        integer :: path_idx = 0         !! index into path_fert_soil_ini array  
        integer :: salt_idx = 0         !! index into salt_fert_soil_ini array
        integer :: hmet_idx = 0         !! index into hmet_fert_soil_ini array
        integer :: cs_idx = 0           !! index into cs_fert_soil_ini array
      end type manure_database
      type (manure_database), dimension(:), allocatable, save :: manure_db

      
      end module fertilizer_data_module 
