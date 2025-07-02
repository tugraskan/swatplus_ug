      module fert_constituent_file_module

      contains

      subroutine fert_constituent_file_read(file_name, imax, nconst, fert_arr, bulk)

      use constituent_mass_module
      implicit none

      character(len=*), intent(in) :: file_name
      integer, intent(in) :: imax
      integer, intent(in) :: nconst
      type(cs_fert_init_concentrations), dimension(:), allocatable, intent(out) :: fert_arr
      logical, intent(in), optional :: bulk

      character(len=80) :: titldum = ""
      character(len=80) :: header = ""
      integer :: eof = 0
      logical :: i_exist
      integer :: i, j
      logical :: lbulk

      lbulk = .false.
      if (present(bulk)) lbulk = bulk

      inquire(file=trim(file_name), exist=i_exist)
      allocate(fert_arr(imax))
      do
        open(107, file=trim(file_name))
        do i = 1, imax
          allocate(fert_arr(i)%soil(nconst), source=0.)
        end do
        if (i_exist) then
          read(107,*,iostat=eof) titldum
          if (eof < 0) exit
          read(107,*,iostat=eof) header
          if (eof < 0) exit

          do i = 1, imax
            read(107,*,iostat=eof) fert_arr(i)%name
            if (lbulk) then
              read(107,*,iostat=eof) titldum, fert_arr(i)%soil
              if (eof < 0) exit
            else
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
