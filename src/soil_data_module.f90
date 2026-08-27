      module soil_data_module
    
      implicit none
      
      type soil_lte_database
       character(len=16) :: texture = ""
       real :: awc = 0.               !! mm/mm |available water capacity for lte soil |range: 0..1
       real :: por = 0.               !! mm/mm |porosity for lte soil |range: 0..1
       real :: scon = 0.              !! mm/hr |saturated condcutivity for lte soil |range: 0..2000
      end type soil_lte_database
      type (soil_lte_database), dimension(:), allocatable :: soil_lte
    
       type soiltest_db
        character(len=16) :: name = "default"
        real :: exp_co = .001         !        |depth coefficient to adjust concentrations for depth |range: 0.0005..0.002
        real :: lab_p = 5.            !ppm     |labile P in soil surface |range: 0..20
        real :: nitrate = 7.          !ppm     |nitrate N in soil surface |range: 0..40
        real :: fr_hum_act = .02      !0-1     |fraction of soil humus that is active |range: 0..1
        real :: hum_c_n = 10.         !ratio   |humus C:N ratio (range 8-12) |range: 8..12
        real :: hum_c_p = 80.         !ratio   |humus C:P ratio (range 70-90) |range: 70..90
        real :: inorgp = 0.5          !ppm     |inorganic P in soil surface - not currently used |range: 0..15
        real :: watersol_p = .15      !ppm     |water soluble P in soil surface - not currently used |range: 0..0.5
        real :: h3a_p = .25           !ppm     |h3a P in soil surface - not currently used |range: 0..1
        real :: mehlich_p = 1.2       !ppm     |Mehlich P in soil surface - not currently used |range: 0..5
        real :: bray_strong_p = .85   !ppm     |Bray P in soil surface - not currently used |range: 0..3
      end type soiltest_db
      type (soiltest_db), dimension (:), allocatable :: solt_db
          
!!!!!! OLD type 
      type soiltest_db_old
        character(len=16) :: name = "default"
        real :: exp_co = .001         !        |depth coefficient to adjust concentrations for depth
        real :: totaln = 13.          !ppm     |total N in soil
        real :: inorgn = 6.           !ppm     |inorganic N in soil surface
        real :: orgn = 3.             !ppm     |organic N in soil surface
        real :: totalp = 3.           !ppm     |total P in soil surface
        real :: inorgp = 3.5          !ppm     |inorganic P in soil surface
        real :: orgp = .4             !ppm     |organic P in soil surface
        real :: watersol_p = .15      !ppm     |water soluble P in soil surface    
        real :: h3a_p = .25           !ppm     |h3a P in soil surface        
        real :: mehlich_p = 1.2       !ppm     |Mehlich P in soil surface
        real :: bray_strong_p = .85   !ppm     |Bray P in soil surface
      end type soiltest_db_old
!!!!!! OLD type 
      
    type soilayer_db
        real :: z = 1500.           !! mm             |depth to bottom of soil layer |range: 0..3500
        real :: bd = 1.3            !! Mg/m**3        |bulk density of the soil |range: 0.9..2.5
        real :: awc = 0.2           !! mm H20/mm soil |available water capacity of soil layer |range: 0..1
        real :: k = 10.0            !! mm/hr          |saturated hydraulic conductivity of soil layer. Index:(layer,HRU) |range: 0..2000
        real :: cbn = 2.0           !! %              |percent organic carbon in soil layer |range: 0.05..10
        real :: clay = 10.          !! none           |fraction clay content in soil material (UNIT CHANGE!) |range: 0..100
        real :: silt = 60.          !! %              |percent silt content in soil material |range: 0..100
        real :: sand = 30.          !! none           |fraction of sand in soil material |range: 0..100
        real :: rock = 0.           !! %              |percent of rock fragments in soil layer |range: 0..100
        real :: alb = 0.1           !! none           |albedo when soil is moist |range: 0..0.25
        real :: usle_k = 0.2        !!                |USLE equation soil erodibility (K) factor |range: 0..0.65
        real :: ec = 0.             !! dS/m           |electrical conductivity of soil layer |range: 0..100
        real :: cal = 0.            !! %              |soil CaCo3 |range: 0..65
        real :: ph = 0.             !!                |soil Ph |range: 3..10
      end type soilayer_db
      
      type soil_profile_db
        character(len=20) :: snam = " "       !! NA            |soil series name 
        integer :: nly  = 1                   !! none          |number of soil layers |range: 1..10
        character(len=16) :: hydgrp = "A"     !! NA            |hydrologic soil group
        real :: zmx = 1500.                   !! mm            |maximum rooting depth |range: 0..3500
        real :: anion_excl = 0.5              !! none          |fraction of porosity from which anions are excluded |range: 0.01..1
        real :: crk = 0.01                    !! none          |crack volume potential of soil |range: 0..1
        character(len=16) :: texture = " "    !!               |texture of soil
      end type soil_profile_db
      
      type soil_database
       type (soil_profile_db) :: s
       type (soilayer_db), dimension(:), allocatable :: ly
      end type soil_database
      type (soil_database), dimension(:), allocatable :: soildb
                
      end module soil_data_module