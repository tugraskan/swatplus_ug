subroutine xwalk_head
  implicit none

  integer, parameter :: maxLineLen = 256
  character(len=maxLineLen) :: line
  integer :: ios, myunit, cnt_unit
  integer :: line_count, i, j
  integer :: pos, start, len_line, token_count
  integer :: num_tokens
  logical :: found

  ! Arrays to store the CSV mappings (Fortran reference and short header)
  character(len=64), allocatable :: fort_var(:)
  character(len=64), allocatable :: short_hdr(:)

  ! Array to store the headers from object.cnt
  character(len=32), allocatable :: cnt_headers(:)
  
  ! Create temporary copies for conversion
  character(len=32) :: header_lower
  character(len=64) :: mapping_lower
  

  ! Variables to read from the first line of header_map.csv
  character(len=256) :: first_file_name
  integer :: expected_count

  !----------------------------------------------------------
  ! 1) Read the CSV file "header_map.csv"
  !    (Now parse the first line into a string and an integer)
  !----------------------------------------------------------
  open(newunit=myunit, file='header_map.csv', status='old', action='read', iostat=ios)
  if (ios /= 0) then
    print *, "Error opening header_map.csv, iostat=", ios
    return
  endif

  ! Read the first line, which might look like:
  !    object.cnt   21
  ! We store the file name and the integer in separate variables.
  read(myunit, *, iostat=ios) first_file_name, expected_count
  if (ios /= 0) then
    print *, "Error reading first line of header_map.csv, iostat=", ios
    close(myunit)
    return
  endif

  print *, "File name from CSV:", trim(first_file_name)
  print *, "Expected count from CSV:", expected_count

  ! Now count the remaining mapping lines in header_map.csv
  line_count = 0
  do
    read(myunit, *, iostat=ios) line
    if (ios /= 0) exit
    line_count = line_count + 1
  end do

  ! Rewind so we can read those lines again
  rewind(myunit)
  ! Skip the first line again, but this time we do the same read:
  read(myunit, *, iostat=ios) first_file_name, expected_count
  if (ios /= 0) then
    print *, "Error re-reading first line of header_map.csv, iostat=", ios
    close(myunit)
    return
  endif

  ! Allocate arrays for the mapping pairs
  allocate(fort_var(line_count), short_hdr(line_count))

  ! Read each remaining line and parse two tokens
  do i = 1, line_count
    read(myunit, *, iostat=ios) fort_var(i), short_hdr(i)
    if (ios /= 0) then
        print *, "Error reading mapping line", i, "of header_map.csv, iostat=", ios
        close(myunit)
        return
    endif
  end do

  close(myunit)

  !----------------------------------------------------------
  ! 2) Read the second line of "object.cnt" (the header line)
  !----------------------------------------------------------
  open(newunit=cnt_unit, file='object.cnt', status='old', action='read', iostat=ios)
  if (ios /= 0) then
    print *, "Error opening object.cnt, iostat=", ios
    return
  endif

  ! Skip the first line
  read(cnt_unit, *, iostat=ios) line
  if (ios /= 0) then
    print *, "Error skipping first line of object.cnt, iostat=", ios
    close(cnt_unit)
    return
  endif

  ! Read the second line which contains the headers
  read(cnt_unit, *, iostat=ios) line
  if (ios /= 0) then
    print *, "Error reading header line of object.cnt, iostat=", ios
    close(cnt_unit)
    return
  endif
  close(cnt_unit)

  len_line = len_trim(line)
  pos = 1
  num_tokens = 0

  ! Count the tokens (headers) in the line
  do while (pos <= len_line)
    do while (pos <= len_line .and. line(pos:pos) == ' ')
      pos = pos + 1
    end do
    if (pos > len_line) exit
    num_tokens = num_tokens + 1
    do while (pos <= len_line .and. line(pos:pos) /= ' ')
      pos = pos + 1
    end do
  end do

  allocate(cnt_headers(num_tokens))

  pos = 1
  num_tokens = 0
  do while (pos <= len_line)
    do while (pos <= len_line .and. line(pos:pos) == ' ')
      pos = pos + 1
    end do
    if (pos > len_line) exit
    start = pos
    do while (pos <= len_line .and. line(pos:pos) /= ' ')
      pos = pos + 1
    end do
    num_tokens = num_tokens + 1
    cnt_headers(num_tokens) = line(start:pos-1)
  end do

  !----------------------------------------------------------
  ! 3) Cross-reference each header from object.cnt with the CSV mappings
  !    (Case-insensitive compare using your 'caps' subroutine)
  !----------------------------------------------------------
  print *, "--------------------------------------"
  print *, "Cross-reference results:"
  do i = 1, size(cnt_headers)
    found = .false.
    do j = 1, line_count
      

      header_lower = trim(cnt_headers(i))
      mapping_lower = trim(short_hdr(j))
      call caps(header_lower)
      call caps(mapping_lower)
      if (header_lower == mapping_lower) then
        print *, "Header:", trim(cnt_headers(i)), " => Fortran ref:", trim(fort_var(j))
        found = .true.
        exit
      end if
    end do
    if (.not. found) then
      print *, "Header:", trim(cnt_headers(i)), " => No match found in CSV"
    end if
  end do

end subroutine xwalk_head

