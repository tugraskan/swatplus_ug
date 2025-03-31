subroutine xwalk_reader (filename, xwalk_entries, n_xwalk)
  use xwalk_module    ! Provides the type xwalk_entry
  implicit none

   ! Input:
  character(len=*), intent(in) :: filename
  ! Outputs:
  type(xwalk_entry), allocatable, intent(out) :: xwalk_entries(:)
  integer, intent(out) :: n_xwalk

  ! Local variables:
  integer :: unit_number, ios, i, nlines, j
  character(len=256) :: line
  character(len=32) :: token1
  character(len=32) :: token2
  character(len=8)  :: token3
  character(len=16) :: token4
  character(len=256) :: line_mod

  ! Open the CSV file.
  open(newunit=unit_number, file=filename, status='old', action='read', iostat=ios)
  if (ios /= 0) then
     print *, "Error opening xwalk file: ", trim(filename)
     stop
  end if

  ! First pass: count the total number of lines.
  nlines = 0
  do
     read(unit_number, '(A)', iostat=ios) line
     if (ios /= 0) exit
     nlines = nlines + 1
  end do

  rewind(unit_number)
  ! Skip header line (assumed to be the first line).
  read(unit_number, '(A)', iostat=ios) line

  ! Allocate xwalk_entries for (nlines - 1) lines.
  n_xwalk = nlines - 1
  allocate(xwalk_entries(n_xwalk))

  ! Second pass: read and parse each CSV line.
  do i = 1, n_xwalk
     read(unit_number, '(A)', iostat=ios) line
     if (ios /= 0) exit

     ! Make a modifiable copy and replace commas with spaces.
     line_mod = line
     do j = 1, len_trim(line_mod)
        if (line_mod(j:j) == ',') then
           line_mod(j:j) = ' '
        end if
     end do

     ! Use list-directed internal read to extract tokens.
     read(line_mod, *) token1, token2, token3, token4

     ! Store tokens in the xwalk entry.
     xwalk_entries(i)%field_name    = token1
     read(token2, *) xwalk_entries(i)%col_pos
     xwalk_entries(i)%data_type     = token3
     xwalk_entries(i)%default_value = token4
  end do

  close(unit_number)
end subroutine xwalk_reader