subroutine fert_constituent_file_read(constituent_name, imax, nconst)
    
    
!--------------------------------------------------------------------
!  fert_constituent_file_read
!    Read a constituent fertilization table (e.g. pest.man) and
!    allocate an array of cs_fert_init_concentrations containing the
!    concentrations for each fertilizer.
!    
! example format for all *.man:
! #title line: pest_hru.ini: 
! #header NAME    	        PPM  
! #application line: low_ini
!   dacamine	            1.001	   
!  roundup	                3.005
! #application line:no_ini
!  dacamine	                0.0	       
!  roundup	                0.0	    
!
!--------------------------------------------------------------------

      use constituent_mass_module
      implicit none

      
      character(len=*), intent(in) :: constituent_name    !!        |    name of the constituent file (e.g. 'pest.man')
      integer, intent(in) :: imax                         !!        |    number of fertilizer types
      integer, intent(in) :: nconst                       !!        |    number of constituents contained in the file


      ! local 
      character(len=16)  :: file_name
      character(len=80) :: titldum = ""   !     |   scratch string for titles
      character(len=80) :: header = ""    !     |   header line
      integer :: eof = 0                  !     |   end-of-file flag
      logical :: i_exist                  !     |   true if file exists
      integer :: i, k, j                 !     |   loop indices

      i = 0
      k = 0
      j = 0
      
      fert_file_name = trim(constituent_name)
      file_name = fert_file_name


      !! check if the file exists
      inquire(file=file_name, exist=i_exist)
      if (i_exist) then
          !! Allocate the array of fertilizer constituents to IMAX
          allocate(fert_arr(imax))
          do
            open(107, file=trim(file_name))     ! open constituent table
            do i = 1, imax
              allocate(fert_arr(i)%soil(nconst), source=0.)
            end do
              !! discard title and header information
              read(107,*,iostat=eof) titldum
              if (eof < 0) exit
              read(107,*,iostat=eof) header
              if (eof < 0) exit

              !! loop over fertilizer entries in the file
              do k = 1, imax
                read(107,*,iostat=eof) fert_arr(k)%name
                  if (eof < 0) exit
                !! loop over constituents for each fertilizer
                do j = 1, nconst
                    read(107,*,iostat=eof) titldum, fert_arr(k)%soil(j)
                    if (eof < 0) exit
                end do
              end do
              close(107)
              exit
          end do
        
      endif

      return
end subroutine fert_constituent_file_read

