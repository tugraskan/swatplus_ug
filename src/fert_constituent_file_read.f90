
!--------------------------------------------------------------------
      !  fert_constituent_file_read
      !    Read a constituent fertilization table (e.g. pest.man) and
      !    allocate an array of cs_fert_init_concentrations containing the
      !    concentrations for each fertilizer.
      !--------------------------------------------------------------------

      subroutine fert_constituent_file_read(file_name, imax, nconst, fert_arr, bulk)

      use constituent_mass_module
      implicit none


      !> name of the constituent file (e.g. 'pest.man')
      character(len=*), intent(in) :: file_name
      !> number of fertilizer types
      integer, intent(in) :: imax
      !> number of constituents contained in the file
      integer, intent(in) :: nconst
      !> returned array of concentrations for each fertilizer
      type(cs_fert_init_concentrations), dimension(:), allocatable, intent(out) :: fert_arr
      !> when true, the file stores all constituent values on a single line
      logical, intent(in), optional :: bulk

      ! local working variables
      character(len=80) :: titldum = ""   ! scratch string for titles
      character(len=80) :: header = ""    ! header line
      integer :: eof = 0                  ! end-of-file flag
      logical :: i_exist                  ! true if file exists
      integer :: i, j                     ! loop indices
      logical :: lbulk                    ! local copy of 'bulk'

      lbulk = .false.
      if (present(bulk)) lbulk = bulk
      ! 'bulk' format indicates that the constituent values for a fertilizer
      ! are written on a single line (salts and "cs" files).  Otherwise each
      ! constituent occupies its own record.

      ! Allocate the output array even when the file is missing so callers can
      ! rely on its presence.  Use a DO loop with EXIT to gracefully stop once
      ! the table has been read.
      inquire(file=trim(file_name), exist=i_exist)
      allocate(fert_arr(imax))
      do
        open(107, file=trim(file_name))     ! open constituent table
        do i = 1, imax
          allocate(fert_arr(i)%soil(nconst), source=0.)
        end do
        if (i_exist) then

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

              do j = 1, nconst
                read(107,*,iostat=eof) titldum, fert_arr(i)%soil(j)
                if (eof < 0) exit
              end do
            end if
          end do
          close(107)
          exit
        endif
      end do

      return
      end subroutine fert_constituent_file_read

      end module fert_constituent_file_module
