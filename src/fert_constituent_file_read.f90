!--------------------------------------------------------------------
!  fert_constituent_file_read
!    Read a constituent fertilization table (e.g. pest.man) and
!    allocate an array of cs_fert_init_concentrations containing the
!    concentrations for each fertilizer.
!--------------------------------------------------------------------
subroutine fert_constituent_file_read(constituent_name, imax, nconst, bulk)

      use constituent_mass_module
      implicit none

      !> name of the constituent file (e.g. 'pest.man')
      character(len=*), intent(in) :: constituent_name
      !> number of fertilizer types
      integer, intent(in) :: imax
      !> number of constituents contained in the file
      integer, intent(in) :: nconst
      !> when true, the file stores all constituent values on a single line
      logical, intent(in) :: bulk

      ! local working variables
      character(len=16)  :: file_name
      character(len=80) :: titldum = ""   ! scratch string for titles
      character(len=80) :: header = ""    ! header line
      integer :: eof = 0                  ! end-of-file flag
      logical :: i_exist                  ! true if file exists
      integer :: i, ii, j                     ! loop indices
      logical :: lbulk                    ! local copy of 'bulk'
      
      fert_file_name = trim(constituent_name)
      file_name = fert_file_name

      lbulk = bulk
      ! 'bulk' format indicates that the constituent values for a fertilizer
      ! are written on a single line (salts and "cs" files).  Otherwise each
      ! constituent occupies its own record.

      ! Allocate the output array even when the file is missing so callers can
      ! rely on its presence.  Use a DO loop with EXIT to gracefully stop once
      ! the table has been read.
      inquire(file=file_name, exist=i_exist)
      if (i_exist .or. file_name /= "null") then
          allocate(fert_arr(imax))
          do
            open(107, file=trim(file_name))     ! open constituent table
            do i = 1, imax
              allocate(fert_arr(i)%soil(nconst), source=0.)
            end do
              ! discard title and header information
              read(107,*,iostat=eof) titldum
              if (eof < 0) exit
              read(107,*,iostat=eof) header
              if (eof < 0) exit

              ! loop over fertilizer entries in the file
              do i = 1, imax
                read(107,*,iostat=eof) fert_arr(i)%name
                if (lbulk) then                  ! one line per fertilizer
                  read(107,*,iostat=eof) titldum, fert_arr(i)%soil
                  if (eof < 0) exit
                else                             ! multiple lines: one per constituent
                  do j = 1, imax
                    read(107,*,iostat=eof) titldum, fert_arr(j)%soil(i)
                    if (eof < 0) exit
                  end do
                end if
              end do
              close(107)
              exit
          end do
        
        else 
            deallocate (fert_arr)
      endif

      return
end subroutine fert_constituent_file_read

