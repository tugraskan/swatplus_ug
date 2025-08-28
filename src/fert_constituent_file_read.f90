!--------------------------------------------------------------------
!  fert_constituent_file_read
!    Utility routine used by several constituent modules to read the
!    "*.man" tables that store concentrations of a constituent for each
!    fertilizer type.  The routine allocates an array sized to the
!    number of fertilizer records and fills it with the concentration
!    values.
!--------------------------------------------------------------------
subroutine fert_constituent_file_read(constituent_name, nconst)
    
    
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
      integer, intent(in) :: nconst                         !!        |    number of constituents
      


      ! local 
      character(len=16)  :: file_name
      character(len=80) :: titldum = ""   !     |   scratch string for titles
      character(len=80) :: header = ""    !     |   header line
      integer :: eof = 0                  !     |   end-of-file flag
      logical :: i_exist                  !     |   true if file exists
      integer :: i, k, j                  !     |   loop indices
      integer :: imax

      i = 0
      j = 0

      
      file_name = trim(constituent_name)
  


      !! check if the file exists
      inquire(file=file_name, exist=i_exist)
      if (i_exist) then
        do
          open (107,file= file_name)
          read (107,*,iostat=eof) titldum
          if (eof < 0) exit
          imax = 0
          do while (eof == 0)
            read (107,*,iostat=eof) header
            if (eof < 0) exit
            read (107,*,iostat=eof) titldum     !name
            if (eof < 0) exit
            do i = 1, nconst
              read (107,*,iostat=eof) titldum
              if (eof < 0) exit
            end do
            imax = imax + 1
          end do
          
          
          allocate(fert_arr(imax))
          
          do i = 1, imax
            allocate (fert_arr(i)%ppm(nconst), source = 0.)
          end do
          
          rewind (107)
          read (107,*,iostat=eof) titldum
          if (eof < 0) exit
          read (107,*,iostat=eof) header
          if (eof < 0) exit
          
          do i = 1, imax
            read (107,*,iostat=eof) fert_arr(i)%name
            do j = 1, nconst
              read (107,*,iostat=eof) titldum, fert_arr(i)%ppm(j)
              if (eof < 0) exit
            end do
          end do
          close (107)
          exit
        end do
      end if

      return
end subroutine fert_constituent_file_read

