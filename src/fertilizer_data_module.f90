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
      
      type fertilizer_ext_db
        character(len=16) :: oman = " "  !!
        character(len=16) :: pest = ""  !! pest.man name
        character(len=16) :: path = ""  !! path.man name
        character(len=16) :: salt = ""  !! salt.man name
        character(len=16) :: hmet = ""  !! hmet.man name
        character(len=16) :: cs = ""    !! cs.man name
      end type fertilizer_ext_db
      

      
      type manure_data
        character(len=16) :: manure_name = " "
      !  character(len=16), dimension(:),allocatable :: path = " "
      !  character(len=16), dimension(:),allocatable :: antibiotic = " "
      end type manure_data
      type (manure_data), dimension(:),allocatable :: manure_db
      
      type :: omad_input
        character(len=32) :: manure_name = " "  ! e.g., BFSD
        character(len=64) :: manure_desc = " "  ! e.g., Beef solid unsurfaced lot
        real :: omadtyp = 0.0    ! Type flag, e.g., 1.5
        real :: astgc = 0.0      ! gC/m2/ton or gC/m2/gal
        real :: astlbl = 0.0     ! May be a label/unused
        real :: astlig = 0.0     ! Lignin fraction
        real :: cn = 0.0         ! C:N ratio
        real :: cp = 0.0         ! C:P ratio
        real :: cs = 0.0         ! C:S ratio
      end type omad_input
      type(omad_input), allocatable, save :: omad_db(:)
      
      type fertilizer_carbon_db
        type(fertilizer_db) :: base     !! base fertilizer data
        real :: wc = 0.0                 !! kg H2O/kg frt     |frac of fert which is water (H2O)
        type (omad_input) :: omad
        character(len=16) :: pest = ""  !! pest.man name
        character(len=16) :: path = ""  !! path.man name
        character(len=16) :: salt = ""  !! salt.man name
        character(len=16) :: hmet = ""  !! hmet.man name
        character(len=16) :: cs = ""    !! cs.man name
      end type fertilizer_carbon_db
      type (fertilizer_carbon_db), dimension(:), allocatable, save :: fertdb_cbn

      
      end module fertilizer_data_module 