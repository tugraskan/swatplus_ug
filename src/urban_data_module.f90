      module urban_data_module
    
      implicit none
          
      type urban_db
        character(len=16) :: urbnm = ""
        real :: fimp = 0.05        !! fraction          |fraction of HRU area that is imp |range: 0..1
        real :: fcimp = 0.05       !! fraction          |fraction of HRU that is classified as directly connected imp |range: 0..1
        real :: curbden = 0.0      !! km/ha             |curb length density |range: 0..1
        real :: urbcoef = 0.0      !! 1/mm              |wash-off coefficient for removal of constituents from an imp surface |range: 0..1
        real :: dirtmx = 1000.0    !! kg/curb km        |max amt of solids allowed to build up on imp surfaces |range: 0..2000
        real :: thalf = 1.0        !! days              |time for the amt of solids on imp areas to build up to 1/2 max level |range: 0..100
        real :: tnconc = 0.0       !! mg N/kg sed       |conc of total nitrogen in suspended solid load from imp areas |range: 0..1000
        real :: tpconc = 0.0       !! mg P/kg sed       |conc of total phosphorus in suspened solid load from imp areas |range: 0..1000
        real :: tno3conc = 0.0     !! mg NO3-N/kg sed   |conc of NO3-N in suspended solid load from imp areas |range: 0..50
        real :: urbcn2 = 98.0      !! none              |moisture condition II curve number for imp areas |range: 30..100
      end type urban_db
      type (urban_db), dimension(:),allocatable, save :: urbdb
      
      end module urban_data_module 