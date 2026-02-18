      subroutine header_snow_change
     
      use basin_module
      use output_path_module
      
      implicit none 
!!   open snow_change output file 
        call open_output_file(3613, "snow_change_out.txt", 800)
        write (3613,*) bsn%name, prog
        write (3613,100) 
100     format (1x,'         hru','       year','         mon','         day','     operation', &
        ' snow_before','      snow_after')  
        write (9000,*) "DTBL                   snow_change_out.txt"
         
      return
      end subroutine header_snow_change
