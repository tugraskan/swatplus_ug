      !> \brief Master mapping registry and input reader
!!>
!!> Provides routines to load header mappings once and apply them for data reordering
module input_read_module
  implicit none

  logical :: mapping_avail = .false.   !!  |mapping selected flag
  character(len=60) :: tag = ''        !!  |tag for mapping
  integer :: hblocks = 0               !!  |number of header blocks
  character(len=60) :: missing_tags(100) = ''   !!  |array of missing tags
  integer :: num_missing_tags = 0      !!  |number of missing tags

  type :: map_meta
    character(len=60) :: tag = ''      !!  | mapping identifier
    character(len=1)  :: used = 'n'    !!  | user flag
  end type map_meta

  type :: header_map
    type(map_meta)               :: meta           !! |tag, used flag, version
    character(len=90), dimension (:), allocatable :: expected(:)  !! |column headers desired order
    character(len=90), dimension (:), allocatable :: default_vals(:) !! |defaults for missing columns
    integer, allocatable           :: col_order(:) !! |column order
    logical                        :: is_correct = .true. !!  |flag for perfect header match
    character(len=90), dimension (:), allocatable :: missing(:)   !! |missing columns
    character(len=90), dimension (:), allocatable :: extra(:)     !! |extra columns
  end type header_map

  type(header_map), allocatable, target :: hdr_map(:)
  type(header_map), pointer             :: hmap

contains

  !!> \brief Convert a string to lowercase
  pure function to_lower(str) result(lower_str)
    character(len=*), intent(in) :: str                          !! |Input string
    character(len=len(str)) :: lower_str                         !! |Result
    character(len=26), parameter :: low_case = 'abcdefghijklmnopqrstuvwxyz'  !! |Lowercase reference
    character(len=26), parameter :: up_case  = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'  !! |Uppercase reference
    integer :: i, j                                               !! |Loop counters

    lower_str = str
    do i = 1, len_trim(str)
      j = index(up_case, str(i:i))
      if (j /= 0) lower_str(i:i) = low_case(j:j)
    end do
  end function to_lower

  !!> \brief Initializes the header mapping structures from a default configuration file.
  !!>
  !!> This subroutine reads the mapping definitions from the master header file ('header_map.cio'),
  !!> parses the mapping blocks, and populates the global header mapping array. Only mappings marked as
  !!> used ('y') are retained. The routine ensures the integrity of the mapping blocks and sets the
  !!> mapping availability flag accordingly.
  !!>
  !!> \details
  !!> - Checks for the existence of the master mapping file.
  !!> - Reads and counts mapping blocks, ensuring each block is complete (3 lines per block).
  !!> - Allocates and fills the mapping array with parsed data.
  !!> - Filters out unused mappings.
  !!> - Sets the mapping_avail flag to indicate successful mapping initialization.
  !!>
  !!> \note
  !!> If the mapping file is missing or contains incomplete blocks, the routine exits early and
  !!> disables mapping availability.
  !!> \brief Initialize mappings from default header file

  subroutine init_mappings
    implicit none
    character(len=*), parameter :: master_file = 'header_map.cio' !! 'header_map.cio' | master file name
    integer :: unit = 107        !!  | unit number
    integer :: ios = 0           !!  | I/O status
    integer :: blk = 0           !!  | block counter
    integer :: eof = 0           !!  | end of file status
    integer :: imax = 0          !!  | max number of lines
    integer :: num_columns = 0   !!  | number of columns
    integer :: max_lines = 0     !!  | max number of lines
    character(len=2000) :: line = '' !!  | line buffer
    character(len=5) :: dummy = '' !!  | dummy variable
    logical :: i_exist = .false. !!  | file existence flag
    integer :: i = 0             !!  | loop counter
    integer :: j = 0             !!  | loop counter
    type(header_map), allocatable :: hdr_map_tmp(:)

    eof = 0
    imax = 0
    max_lines = 0

    !!> \details
    !!> Inquire if the mapping file exists.
    inquire(file= master_file, exist=i_exist)

    if (i_exist) then
        !!> Open the mapping file for reading.
        open(newunit=unit, file=master_file, status='old', action='read', iostat=ios)
        if (ios /= 0) return

        ! Read and skip the title line of the master file.
        read (unit,*,iostat=eof) line

        !!> Count mapping blocks (3 lines per block).
        max_lines = 0
        do
            read(unit,'(A)', iostat=ios) line; if (ios /= 0) exit
            read(unit,'(A)', iostat=ios) line; if (ios /= 0) exit
            read(unit,'(A)', iostat=ios) line; if (ios /= 0) exit
            max_lines = max_lines + 3
        end do

        !!> Ensure no incomplete trailing block.
        if (mod(max_lines,3) /= 0) then
            close(unit)
            print *, 'Error: incomplete mapping block in master file'
            mapping_avail = .false.
            close(unit)
            return
        end if

        hblocks = max_lines / 3

        ! Allocate mapping array.
        allocate(hdr_map(0:hblocks))
        
        allocate(hdr_map(0)%expected   (0))
        allocate(hdr_map(0)%default_vals(0))
        allocate(hdr_map(0)%col_order   (0))
        allocate(hdr_map(0)%missing     (0))
        allocate(hdr_map(0)%extra       (0))

        rewind(unit)
        ! Skip title again.
        read (unit,*,iostat=eof) line

        !!> Read each mapping block and populate hdr_map.
        do blk = 1, hblocks
            !!> Read tag and used flag.
            read(unit,*, iostat=ios) dummy, hdr_map(blk)%meta%tag, dummy, hdr_map(blk)%meta%used
            !!> Read expected headers.
            read(unit,'(A)', iostat=ios) line
            call split_by_multispace(line, hdr_map(blk)%expected, num_columns)
            !!> Read default values.
            read(unit,'(A)', iostat=ios) line
            call split_by_multispace(line, hdr_map(blk)%default_vals, num_columns)
            !!> Allocate column order array.
            allocate(hdr_map(blk)%col_order(num_columns))
        end do

        !!> Filter hdr_map to retain only entries with used = 'y'.
        j = 0
        do i = 1, size(hdr_map)
            if (hdr_map(i)%meta%used == 'y') then
                j = j + 1
                if (i /= j) hdr_map(j) = hdr_map(i)
            end if
        end do

        !!> If any unused mappings were removed, resize the array.
        if (j < size(hdr_map)) then
            call move_alloc(hdr_map, hdr_map_tmp)
            allocate(hdr_map(0:j))
            ! Re-initialize dummy slot after shrink
            allocate(hdr_map(0)%expected    (0))
            allocate(hdr_map(0)%default_vals(0))
            allocate(hdr_map(0)%col_order   (0))
            allocate(hdr_map(0)%missing     (0))
            allocate(hdr_map(0)%extra       (0))

            ! Copy back the real entries
            hdr_map(1:j) = hdr_map_tmp(1:j)
            deallocate(hdr_map_tmp)
        end if

          hblocks = j
          mapping_avail = .true.
          close(unit)
    endif
  end subroutine init_mappings

subroutine check_headers_by_tag(search_tag, header_line, use_hdr_map)
  implicit none

  character(len=*), intent(in)       :: search_tag    !! |Tag to search for
  character(len=*), intent(in)       :: header_line   !! |Header line to check
  !type(header_map), pointer          :: hmap          !! |Output: pointer to matching header map
  !character(len=3), intent(out)      :: pvar          !! |Format variable
  logical, intent(inout)             :: use_hdr_map   !! |Flag to indicate whether to use map

  character(len=90), allocatable     :: headers(:)    !! |Header tokens
  logical, allocatable               :: matched(:)    !! |Flags for matched headers
  integer                            :: ntok, i, j
  integer                            :: miss_cnt, extra_cnt
  integer                            :: imax
  type(header_map), pointer          :: hdr_map2(:)     !! |Pointer to all header maps
  

  ! Initialize outputs
  
  use_hdr_map = .false.

  if (.not. mapping_avail) return
  
  ! Use hdr_map2 to see debugging information
  hdr_map2 => hdr_map
  ! Set hmap to dummy hdr_map
  hmap => hdr_map2(0)
  ! Lookup the tag in available mappings
  tag = search_tag
  do i = 0, hblocks
    if (trim(hdr_map2(i)%meta%tag) == trim(tag)) then
      hmap => hdr_map2(i)
      use_hdr_map = .true.
      exit
    end if
  end do

  ! If not found, track it and exit
  if (.not. use_hdr_map) then
    if (num_missing_tags < size(missing_tags)) then
      num_missing_tags = num_missing_tags + 1
      missing_tags(num_missing_tags) = trim(tag)
    end if
    return
  end if

  ! Split and compare headers if map was found
  call split_by_multispace(header_line, headers, ntok)
  imax = size(hmap%expected)
  allocate(matched(ntok))
  matched = .false.
  hmap%is_correct = .true.

  do i = 1, imax
    hmap%col_order(i) = 0
    do j = 1, ntok
      if (to_lower(adjustl(trim(headers(j)))) == to_lower(adjustl(trim(hmap%expected(i))))) then
        hmap%col_order(i) = j
        matched(j) = .true.
        exit
      end if
    end do
    if (hmap%col_order(i) /= i) then
      hmap%is_correct = .false.
    end if
  end do

  if (.not. hmap%is_correct) then
    ! missing
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

    ! extra
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
  integer, intent(out) :: count

  character(len=90) :: word
  integer :: i, len_line, start
  logical :: in_quotes

  allocate(tokens(1000))
  count = 0
  word = ''
  len_line = len_trim(line)
  in_quotes = .false.
  start = 1

  do i = 1, len_line
    select case (line(i:i))
    case ('"')
      in_quotes = .not. in_quotes
      word = trim(word)//line(i:i)
    case (' ')
      if (in_quotes) then
        word = trim(word)//line(i:i)
      else if (len_trim(word) > 0) then
        count = count + 1
        tokens(count) = adjustl(word)
        word = ''
      end if
    case default
      word = trim(word)//line(i:i)
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