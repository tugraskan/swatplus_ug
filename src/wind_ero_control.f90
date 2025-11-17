      subroutine wind_ero_control
    
      implicit none
      
      external :: wind_ero_bare, wind_ero_erod, wind_ero_veg, wind_ero_rough, wind_ero_unshelt
 
      call wind_ero_bare
      
      call wind_ero_erod
      
      call wind_ero_veg
      
      call wind_ero_rough
      
      call wind_ero_unshelt
      
      return
      end subroutine wind_ero_control