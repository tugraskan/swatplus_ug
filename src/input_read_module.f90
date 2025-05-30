      !> \brief Master mapping registry and input reader
!!>
!!> Provides routines to load header mappings once and apply them for data reordering
module input_read_module
  implicit none
  
    !----------------------------------------------------------------------!
  ! Parser settings and constants                                          
  !----------------------------------------------------------------------!
  integer, parameter :: MAX_LINE = 512
  integer, parameter :: UNIT_NUMBER = 107
  integer, parameter :: MAX_FIELDS = 10

  !----------------------------------------------------------------------!
  ! Map metadata and header_map types                                      
  !----------------------------------------------------------------------!
  type :: map_meta
    character(len=60) :: tag
    character(len=1)  :: used
  end type map_meta

  type :: header_map
    type(map_meta)                :: meta
    character(len=90), allocatable :: expected(:)
    character(len=90), allocatable :: default_vals(:)
    character(len=90), allocatable :: missing(:)
    character(len=90), allocatable :: extra(:)
    logical,    allocatable         :: mandatory(:)
    logical                        :: is_correct = .true.
    integer,    allocatable         :: col_order(:)
  end type header_map

  !----------------------------------------------------------------------!
  ! Module-level state                                                    
  !----------------------------------------------------------------------!
  type(header_map), allocatable, target :: hdr_map(:)
  logical                              :: mapping_avail = .false.
  integer                              :: hblocks       = 0
  character(len=60)                    :: missing_tags(100) = ''
  integer                              :: num_missing_tags = 0

contains

  ! Convert a string to lowercase
  pure function to_lower(str) result(lower_str)
    character(len=*), intent(in) :: str
    character(len=len(str))      :: lower_str
    character(len=26), parameter :: low_case = 'abcdefghijklmnopqrstuvwxyz'
    character(len=26), parameter :: up_case  = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
    integer :: i, j
    lower_str = str
    do i = 1, len_trim(str)
      j = index(up_case, str(i:i))
      if (j /= 0) lower_str(i:i) = low_case(j:j)
    end do
  end function to_lower

  ! Split a line by any amount of whitespace, respecting quoted strings
  subroutine split_by_multispace(line, tokens, count)
    character(len=*), intent(in)                  :: line
    character(len=90), allocatable, intent(out)  :: tokens(:)
    integer, intent(out)                          :: count
    character(len=MAX_LINE)                      :: tmp
    integer                                       :: i, start
    logical                                       :: in_quotes

    tmp = line
    count = 0
    start = 1
    in_quotes = .false.
    allocate(tokens(0))

    do i = 1, len_trim(tmp)
      select case (tmp(i:i))
      case ('"')
        in_quotes = .not. in_quotes
      case (' ')
        if (.not. in_quotes) then
          if (i > start) then
            count = count + 1
            call resize_str(tokens, count)
            tokens(count) = adjustl(tmp(start:i-1))
          end if
          start = i + 1
        end if
      end select
    end do
    if (len_trim(tmp(start:)) > 0) then
      count = count + 1
      call resize_str(tokens, count)
      tokens(count) = adjustl(tmp(start:))
    end if
  end subroutine split_by_multispace

  ! Resize an allocatable string array, preserving contents
  subroutine resize_str(arr, new_size)
    character(len=90), allocatable, intent(inout) :: arr(:)
    integer, intent(in)                           :: new_size
    character(len=90), allocatable                :: tmp(:)
    integer                                       :: old_size
    old_size = size(arr)
    tmp = arr
    if (allocated(arr)) deallocate(arr)
    allocate(arr(new_size))
    if (old_size > 0) arr(1:old_size) = tmp
  end subroutine resize_str

  ! Find index of a tag in hdr_map
  function find_map_index(tag) result(idx)
    character(len=*), intent(in) :: tag
    integer                       :: idx, i
    idx = 0
    do i = 1, hblocks
      if (trim(hdr_map(i)%meta%tag) == trim(tag)) then
        idx = i; return
      end if
    end do
  end function find_map_index

  ! Build mandatory_idxs from defaults ('exit!')
  subroutine build_mandatory(map)
    type(header_map), intent(inout) :: map
    integer                         :: i, cnt
    cnt = 0
    do i = 1, size(map%default_vals)
      if (trim(map%default_vals(i)) == 'exit!') cnt = cnt + 1
    end do
    if (cnt > 0) then
      integer :: j
      allocate(map%mandatory_idxs(cnt))
      j = 0
      do i = 1, size(map%default_vals)
        if (trim(map%default_vals(i)) == 'exit!') then
          j = j + 1
          map%mandatory_idxs(j) = i
        end if
      end do
    else
      allocate(map%mandatory_idxs(0))
    end if
  end subroutine build_mandatory

  ! Initialize mappings from header_map.cio using whitespace splitting
  subroutine init_mappings()
    implicit none
    integer           :: ios, nfields, tag_idx, col_idx, i
    character(len=MAX_LINE) :: line
    character(len=90), allocatable :: fields(:)
    logical           :: in_section2

    ! Reset state
    if (allocated(hdr_map)) deallocate(hdr_map)
    mapping_avail = .false.
    hblocks      = 0

    inquire(file='header_map.cio', exist=ios)
    if (ios == 0) return
    open(unit=UNIT_NUMBER, file='header_map.cio', status='old', action='read', iostat=ios)
    if (ios /= 0) return

    in_section2 = .false.

    do
      read(UNIT_NUMBER,'(A)', iostat=ios) line
      if (ios /= 0) exit
      if (line(1:1) == '#' .or. adjustl(line) == '') cycle
      call split_by_multispace(line, fields, nfields)

      ! Detect section headers
      if (.not. in_section2) then
        if (trim(fields(1)) == 'tag' .and. trim(fields(2)) == 'used') cycle
        if (nfields == 2) then
          hblocks = hblocks + 1
          if (hblocks == 1) allocate(hdr_map(1)) else call resize_hdr_map(hblocks)
          hdr_map(hblocks)%meta%tag  = trim(fields(1))
          hdr_map(hblocks)%meta%used = fields(2)(1:1)
        else if (trim(fields(1)) == 'tag' .and. trim(fields(2)) == 'idx') then
          in_section2 = .true.
        end if
      else
        if (trim(fields(1)) == 'tag' .and. trim(fields(2)) == 'idx') cycle
        tag_idx = find_map_index(fields(1))
        read(fields(2), *) col_idx
        ! ensure arrays sized
        if (.not. allocated(hdr_map(tag_idx)%expected)) then
          allocate(hdr_map(tag_idx)%expected(col_idx))
          allocate(hdr_map(tag_idx)%default_vals(col_idx))
        else if (size(hdr_map(tag_idx)%expected) < col_idx) then
          call extend_maps(tag_idx, col_idx)
        end if
        hdr_map(tag_idx)%expected(col_idx)     = trim(fields(3))
        hdr_map(tag_idx)%default_vals(col_idx) = trim(fields(4))
      end if
    end do

    close(UNIT_NUMBER)

    ! Finalize each map
    do i = 1, hblocks
      allocate(hdr_map(i)%col_order(size(hdr_map(i)%expected)))
      do col_idx = 1, size(hdr_map(i)%expected)
        hdr_map(i)%col_order(col_idx) = col_idx
      end do
      call build_mandatory(hdr_map(i))
    end do

    mapping_avail = (hblocks > 0)
  end subroutine init_mappings

  ! Resize hdr_map array
  subroutine resize_hdr_map(new_size)
    integer, intent(in) :: new_size
    type(header_map), allocatable :: tmp(:)
    integer :: old
    old = new_size - 1
    allocate(tmp(old)); tmp = hdr_map
    deallocate(hdr_map)
    allocate(hdr_map(new_size)); hdr_map(1:old) = tmp
  end subroutine resize_hdr_map

  ! Extend expected and default_vals arrays for a map
  subroutine extend_maps(idx, new_size)
    integer, intent(in) :: idx, new_size
    character(len=90), allocatable :: texp(:), tdef(:)
    integer :: old
    old = size(hdr_map(idx)%expected)
    allocate(texp(old)); texp = hdr_map(idx)%expected
    allocate(tdef(old)); tdef = hdr_map(idx)%default_vals
    deallocate(hdr_map(idx)%expected, hdr_map(idx)%default_vals)
    allocate(hdr_map(idx)%expected(new_size))
    allocate(hdr_map(idx)%default_vals(new_size))
    hdr_map(idx)%expected(1:old)     = texp
    hdr_map(idx)%default_vals(1:old) = tdef
  end subroutine extend_maps




subroutine check_headers_by_tag(search_tag, header_line, use_hdr_map)
  implicit none

  character(len=*), intent(in)       :: search_tag    !! |Tag to search for
  character(len=*), intent(in)       :: header_line   !! |Header line to check
  logical, intent(inout)             :: use_hdr_map   !! |Flag to indicate whether to use map

  character(len=90), allocatable     :: headers(:)    !! |Header tokens
  logical, allocatable               :: matched(:)    !! |Flags for matched headers
  integer                            :: ntok, i, j
  integer                            :: miss_cnt, extra_cnt, imax
  type(header_map), pointer          :: hdr_map2(:)   !! |Pointer to all header maps
  type(header_map), pointer          :: hmap          !! |Pointer to the active header map
  character(len=:), allocatable      :: tag            !! |Local copy of search_tag

  ! Initialize outputs
  use_hdr_map = .false.

  if (.not. mapping_avail) return
  
  ! Point to full header_map array
  hdr_map2 => hdr_map
  ! Default to dummy map
  hmap => hdr_map2(0)
  ! Lookup tag
  tag = trim(search_tag)
  do i = 0, hblocks
    if (trim(hdr_map2(i)%meta%tag) == tag) then
      hmap => hdr_map2(i)
      use_hdr_map = .true.
      exit
    end if
  end do

  ! If no mapping, record and exit
  if (.not. use_hdr_map) then
    if (num_missing_tags < size(missing_tags)) then
      num_missing_tags = num_missing_tags + 1
      missing_tags(num_missing_tags) = tag
    end if
    return
  end if

  ! Split header line
  call split_by_multispace(header_line, headers, ntok)
  imax = size(hmap%expected)
  allocate(matched(ntok))
  matched = .false.
  hmap%is_correct = .true.

  ! Map headers; only missing columns mark as incorrect (ignore order)
  do i = 1, imax
    hmap%col_order(i) = 0
    do j = 1, ntok
      if (to_lower(adjustl(trim(headers(j)))) == to_lower(adjustl(trim(hmap%expected(i))))) then
        hmap%col_order(i) = j
        matched(j) = .true.
        exit
      end if
    end do
    if (hmap%col_order(i) == 0) then
      hmap%is_correct = .false.
    end if
  end do
  
  !––– Enforce mandatory columns (default_vals=='exit') –––
  do i = 1, imax
    if (hmap%col_order(i) == 0 .and. trim(hmap%default_vals(i)) == 'exit!') then
      print *, 'FATAL ERROR: Mandatory column "', trim(hmap%expected(i)), &
               '" missing for tag=', tag
      stop 1
    end if
  end do

  if (.not. hmap%is_correct) then
    ! missing columns
    miss_cnt = count(hmap%col_order == 0)
    if (miss_cnt > 0) then
      allocate(hmap%missing(miss_cnt))
      miss_cnt = 0
      do i = 1, imax
        if (hmap%col_order(i) == 0) then
          miss_cnt = miss_cnt + 1
          hmap%missing(miss_cnt) = hmap%expected(i)
        end if
      end do
    end if

    ! extra columns
    extra_cnt = count(.not. matched)
    if (extra_cnt > 0) then
      allocate(hmap%extra(extra_cnt))
      extra_cnt = 0
      do j = 1, ntok
        if (.not. matched(j)) then
          extra_cnt = extra_cnt + 1
          hmap%extra(extra_cnt) = trim(headers(j))
        end if
      end do
    end if

  else
    allocate(hmap%missing(0))
    allocate(hmap%extra(0))
    use_hdr_map = .false.
  end if

  deallocate(matched)
  deallocate(headers)

end subroutine check_headers_by_tag


!!> \brief Reorder a line from a unit based on the header map
!!>
!!> Reads a line from the given unit, splits it into tokens, and reorders or fills missing
!!> columns according to the header map. If the header is not a perfect match, missing columns
!!> are filled with default values.
!!>
!!> \param[in] unit Unit number to read from
!!> \param[in] hmap Header map
!!> \param[out] out_line Reordered line
subroutine reorder_line(unit, out_line)
    implicit none

    integer, intent(in) :: unit !! Unit number to read from
    character(len=2000) :: line = '' !!  | line buffer
    type(header_map), pointer          :: hmap2 !! |Header map pointer
    character(len=2000), intent(out) :: out_line !! |Reordered line
    character(len=90), allocatable :: tok(:) !! |Array of tokens
    integer :: ntok = 0 !!  | number of tokens
    integer :: i = 0    !!  | loop counter
    integer :: ios = 0  !!  | I/O status

    out_line = ''  ! Initialize output
    
    ! use to see debug values
    hmap2 => hmap

    ! Only reorder if the header is not a perfect match
    if (.not. hmap2%is_correct) then
            ! Read a line from the input unit
            read(unit,'(A)',iostat=ios) line
            if (ios /= 0) return

            ! Split the line into tokens using multi-space delimiter
            call split_by_multispace(line, tok, ntok)

            ! Loop over expected columns in the header map
            do i = 1, size(hmap2%expected)
                    ! If the column exists in the input, use it; otherwise, use the default value
                    if (hmap2%col_order(i) /= 0 .and. hmap2%col_order(i) <= ntok) then
                            out_line = trim(out_line)//' '//trim(tok(hmap2%col_order(i)))
                    else
                            out_line = trim(out_line)//' '//trim(hmap2%default_vals(i))
                    end if
            end do

            ! Left-adjust the output line and clean up
            out_line = adjustl(out_line)
            deallocate(tok)
    end if
end subroutine reorder_line

subroutine header_read_n_reorder(unit, use_hdr_map, out_line)
    implicit none

    integer, intent(in) :: unit !! Unit number to read from
    character(len=2000) :: line = '' !!  | line buffer
    type(header_map), pointer          :: hmap2 !! |Header map pointer
    character(len=2000), intent(out) :: out_line !! |Reordered line
    character(len=90), allocatable :: tok(:) !! |Array of tokens
    integer :: ntok = 0 !!  | number of tokens
    integer :: i = 0    !!  | loop counter
    integer :: ios = 0  !!  | I/O status
    logical, intent(inout) :: use_hdr_map          !! |Flag to indicate if header map should be used

    out_line = ''  ! Initialize output
    ! use to see debug values
    hmap2 => hmap
    
    ! Read a line from the input unit
    read(unit,'(A)',iostat=ios) line
    if (ios /= 0) return
    
    if (use_hdr_map) then
        ! If the header is a perfect match, just use the line as is
        if (hmap2%is_correct) then
            out_line = line 
        ! If the header is not a perfect match, reorder the line
        else 
            ! Split the line into tokens using multi-space delimiter
            call split_by_multispace(line, tok, ntok)

                ! Loop over expected columns in the header map
                do i = 1, size(hmap2%expected)
                        ! If the column exists in the input, use it; otherwise, use the default value
                        if (hmap2%col_order(i) /= 0 .and. hmap2%col_order(i) <= ntok) then
                                out_line = trim(out_line)//' '//trim(tok(hmap2%col_order(i)))
                        else
                                out_line = trim(out_line)//' '//trim(hmap2%default_vals(i))
                        end if
                end do
                ! Left-adjust the output line and clean up
                out_line = adjustl(out_line)
                deallocate(tok)    
        end if
    else
        out_line = line
    endif
        
end subroutine header_read_n_reorder


  !!> \brief Split a line by multiple spaces
  !!>
  !!> \param[in] line Line to split
  !!> \param[out] tokens Array of tokens
  !!> \param[out] count Number of tokens
  subroutine split_by_multispace(line, tokens, count)
  character(len=*), intent(in) :: line
  character(len=90), allocatable, intent(out) :: tokens(:)
  character(len=MAX_LINE)       :: line2 !! local line used for debug
  integer, intent(out) :: count

  character(len=90) :: word
  integer :: i, len_line, start
  logical :: in_quotes

  allocate(tokens(1000))
  line2 = line

  count = 0
  word = ''
  len_line = len_trim(line2)
  in_quotes = .false.
  start = 1

  do i = 1, len_line
    select case (line2(i:i))
    case ('"')
      in_quotes = .not. in_quotes
      word = trim(word)//line2(i:i)
    case (' ')
      if (in_quotes) then
        word = trim(word)//line2(i:i)
      else if (len_trim(word) > 0) then
        count = count + 1
        tokens(count) = adjustl(word)
        word = ''
      end if
    case default
      word = trim(word)//line2(i:i)
    end select
  end do

  if (len_trim(word) > 0) then
    count = count + 1
    tokens(count) = adjustl(word)
  end if

  if (count < size(tokens)) tokens = tokens(1:count)
  end subroutine split_by_multispace
  
!  Write missing columns, extra columns, and mapping information to a file
  subroutine write_mapping_info
  implicit none
  integer :: unit = 1942 !! Unit number to write to
  integer :: i, ii
  type(header_map), pointer          :: hdr_map2(:)

  !> \brief Writes mapping information to a file
  !!>
  !!> This subroutine writes information about header mappings that are not a perfect match.
  !!> For each mapping, if there are missing or extra columns, it writes the tag, missing columns,
  !!> and extra columns to the file "use_hdr_map.fin".
  !!>
  !!> - Only writes information for mappings where is_correct is .false.
  !!> - Outputs the tag, missing columns, and extra columns for each such mapping.
  !!> - Skips writing if mapping_avail is .false.
  !!>

  ! Lookup the tag in available mappings
  hdr_map2 => hdr_map
  
  ! Return early if no mapping is available
  if (.not. mapping_avail) return
  
  ! Print message to standard output
  write(*,*) 'Alt mapping may have been used see Mapping information:'
  ! Open the output file for writing
  open (unit,file="use_hdr_map.fin")
  
  ! Loop over all header blocks
  do ii = 1, hblocks
      ! Only process mappings that are not a perfect match
      if (.not. hdr_map2(ii)%is_correct) then
        ! Write the tag for the mapping
        write(unit,*) trim(hdr_map2(ii)%meta%tag)
        ! Write missing columns, if any
        if (size(hdr_map2(ii)%missing) > 0) then
          write(unit,*) 'Missing columns: ', (trim(hdr_map2(ii)%missing(i)), ' ', i=1, size(hdr_map2(ii)%missing))
        end if
        ! Write extra columns, if any
        if (size(hdr_map2(ii)%extra) > 0) then
          write(unit,*) 'Extra columns: ', (trim(hdr_map2(ii)%extra(i)), ' ', i=1, size(hdr_map2(ii)%extra))
        end if
      end if
  end do
  ! Close the output file
  close(unit)
  end subroutine write_mapping_info

end module input_read_module