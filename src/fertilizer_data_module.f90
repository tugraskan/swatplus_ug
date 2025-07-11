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
      

      type manure_attributes
        character(len=64) ::  manure_name = " "  !! Identifier used to crosswalk fertilizer entries, constructed from
                                                 !! manure_region, manure_source, and manure_type
        !! additional attributes from fp5-manure-content-defaults-swat.csv
        character(len=32) :: manure_region = " "
        character(len=32) :: manure_source = " "
        character(len=32) :: manure_type = " "
        real :: pct_moisture = 0.0
        real :: pct_solids = 0.0
        real :: total_c = 0.0
        real :: total_n = 0.0
        real :: inorganic_n = 0.0
        real :: organic_n = 0.0
        real :: total_p2o5 = 0.0
        real :: inorganic_p2o5 = 0.0
        real :: organic_p2o5 = 0.0
        real :: inorganic_p = 0.0
        real :: organic_p = 0.0
        real :: solids = 0.0
        real :: water = 0.0
        character(len=32) :: units = " "
        integer :: sample_size = 0
        character(len=32) :: summary_level = " "
        character(len=64) :: data_source = " "
      end type  manure_attributes
      type (manure_attributes), dimension(:),allocatable :: manure_csv
      
      type manure_database
        type(fertilizer_db) :: base     !! base fertilizer data
        character(len=16) ::  name = " "  !! e.g., Midwest_Beef_Liquid
        character(len=64) ::  csv = " "  !! e.g., Midwest_Beef_Liquid
        type (manure_attributes), dimension(:),allocatable :: manucontent !! manure attributes from csv file
        character(len=16) :: pest = ""  !! pest.man name
        character(len=16) :: path = ""  !! path.man name
        character(len=16) :: salt = ""  !! salt.man name
        character(len=16) :: hmet = ""  !! hmet.man name
        character(len=16) :: cs = ""    !! cs.man name
      end type manure_database
      type (manure_database), dimension(:), allocatable, save :: manure_db

      
      end module fertilizer_data_module 
