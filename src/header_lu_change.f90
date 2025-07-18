!!@summary Write header for landuse change file
!!@description Opens the landuse change output and writes column headings.
!!@arguments None
     subroutine header_lu_change

     use basin_module

     implicit none
!! open lu_change output file
        open (3612,file="lu_change_out.txt",recl=800)
        write (3612,*) bsn%name, prog
        write (3612,100)
100     format (1x,'         hru','       year','         mon','         day','     operation', &
        '   lu_before','         lu_after')
        write (9000,*) "DTBL                      lu_change_out.txt"

!! finished header
      return
      end subroutine header_lu_change