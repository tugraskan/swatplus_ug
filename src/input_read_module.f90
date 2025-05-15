!!> \brief Master mapping registry and input reader
!!>
!!> Provides routines to load header mappings once and apply them for data reordering
module input_read_module
  implicit none

  logical :: mapping_avail = .false.   !! .false. | mapping selected flag
  character(len=60) :: tag = ''        !! '' | tag for mapping
  integer :: hblocks = 0               !! 0 | number of header blocks
  character(len=60) :: missing_tags(100) = ''  !! '' | array of missing tags
  integer :: num_missing_tags = 0      !! 0 | number of missing tags

  type :: map_meta
    character(len=60) :: tag = ''      !! '' | mapping identifier
    character(len=1)  :: used = 'n'    !! 'n' | user flag
  end type map_meta

  type :: header_map
    type(map_meta)               :: meta           !! tag, used flag, version
    character(len=90), allocatable :: expected(:)  !! column headers desired order
    character(len=90), allocatable :: default_vals(:) !! defaults for missing columns
    integer, allocatable           :: col_order(:) !! column order
    logical                        :: is_correct = .false. !! .false. | flag for perfect header match
    character(len=90), allocatable :: missing(:)   !! missing columns
    character(len=90), allocatable :: extra(:)     !! extra columns
  end type header_map

  type(header_map), allocatable, target :: hdr_map(:)
  type(header_map), pointer             :: hmap

contains

  !!> \brief Initialize mappings from default header file
  subroutine init_mappings
    implicit none
    character(len=*), parameter :: master_file = 'header_map.cio' !! 'header_map.cio' | master file name
    integer :: unit = 107        !! 107 | unit number
    integer :: ios = 0           !! 0 | I/O status
    integer :: blk = 0           !! 0 | block counter
    integer :: eof = 0           !! 0 | end of file status
    integer :: imax = 0          !! 0 | max number of lines
    integer :: num_columns = 0   !! 0 | number of columns
    integer :: max_lines = 0     !! 0 | max number of lines
    character(len=2000) :: line = '' !! '' | line buffer
    character(len=5) :: dummy = '' !! '' | dummy variable
    logical :: i_exist = .false. !! .false. | file existence flag
    integer :: i = 0             !! 0 | loop counter
    integer :: j = 0             !! 0 | loop counter
    type(header_map), allocatable :: hdr_map_tmp(:)

    eof = 0
    imax = 0
    max_lines = 0

    !! Inquire mapping file
    inquire(file= master_file, exist=i_exist)

    if (i_exist) then
        ! open mapping file
        open(newunit=unit, file=master_file, status='old', action='read', iostat=ios)
        if (ios /= 0) return

        ! read title line of masterfile
        read (unit,*,iostat=eof) line

        ! count mapping blocks (3 lines per block)
        max_lines = 0
        do
            read(unit,'(A)', iostat=ios) line; if (ios /= 0) exit
            read(unit,'(A)', iostat=ios) line; if (ios /= 0) exit
            read(unit,'(A)', iostat=ios) line; if (ios /= 0) exit
            max_lines = max_lines + 3
        end do

        ! ensure no incomplete trailing block
        if (mod(max_lines,3) /= 0) then
            close(unit)
            stop 'Error: incomplete mapping block in master file'
        end if

        hblocks = max_lines / 3

        ! allocate mapping array
        allocate(hdr_map(hblocks))

        rewind(unit)
        ! skip title again
        read (unit,*,iostat=eof) line

        do blk = 1, hblocks
            read(unit,*, iostat=ios) dummy, hdr_map(blk)%meta%tag, dummy, hdr_map(blk)%meta%used
            read(unit,'(A)', iostat=ios) line
            call split_by_multispace(line, hdr_map(blk)%expected, num_columns)
            read(unit,'(A)', iostat=ios) line
            call split_by_multispace(line, hdr_map(blk)%default_vals, num_columns)
            allocate(hdr_map(blk)%col_order(num_columns))
        end do

        ! Filter hdr_map to retain only entries with used = 'y'
        j = 0
        do i = 1, size(hdr_map)
            if (hdr_map(i)%meta%used == 'y') then
                j = j + 1
                if (i /= j) hdr_map(j) = hdr_map(i)
            end if
        end do

        if (j < size(hdr_map)) then
            call move_alloc(hdr_map, hdr_map_tmp)
            allocate(hdr_map(j))
            hdr_map = hdr_map_tmp(1:j)
            deallocate(hdr_map_tmp)
        end if

        mapping_avail = .true.
        close(unit)
    endif
  end subroutine init_mappings

  !!> \brief Get mapping by tag
  !!>
  !!> \param[in] search_tag Tag to search for
  !!> \param[out] pm Pointer to the header map
  !!> \param[out] pvar Format variable
  !!> \param[inout] use_hdr_map Flag to indicate if header map should be used
  subroutine get_map_by_tag(search_tag, pm, pvar, use_hdr_map)
    implicit none

    character(len=60), intent(in)       :: search_tag !! Tag to search for
    type(header_map), pointer           :: pm         !! Pointer to the header map
    character(len=3), intent(out)       :: pvar       !! Format variable
    type(header_map), pointer           :: hdr_map2(:)!! Pointer to the header map array
    integer                             :: i = 0      !! Loop counter
    logical, intent(inout) :: use_hdr_map !! Flag to indicate if header map should be used

    pm => null()
    pvar = '*'

    if (mapping_avail) then
        hdr_map2 => hdr_map

        do i = 1, size(hdr_map2)
            if (trim(hdr_map2(i)%meta%tag) == trim(search_tag)) then
                pm => hdr_map2(i)
                pvar = '(A)'
                use_hdr_map = .true.
                return
            end if
        end do
    end if

    ! If no match was found, add to missing_tags
    if (num_missing_tags < size(missing_tags)) then
        num_missing_tags = num_missing_tags + 1
        missing_tags(num_missing_tags) = trim(search_tag)
    end if
  end subroutine get_map_by_tag

  !!> \brief Split a line by multiple spaces
  !!>
  !!> \param[in] line Line to split
  !!> \param[out] tokens Array of tokens
  !!> \param[out] count Number of tokens
  subroutine split_by_multispace(line, tokens, count)
    character(len=2000), intent(in) :: line !! Line to split
    character(len=90), dimension(:), allocatable, intent(out) :: tokens !! Array of tokens
    integer, intent(out) :: count !! Number of tokens
    character(len=90) :: word = '' !! '' | word buffer
    integer :: len_line = 0       !! 0 | length of the line
    integer :: start = 1          !! 1 | start position
    integer :: end_pos = 0        !! 0 | end position

    allocate(tokens(1000))
    count = 0
    len_line = len_trim(line)
    start = 1

    do while (start <= len_line)
        ! Skip multiple spaces
        do while (start <= len_line .and. line(start:start) == ' ')
            start = start + 1
        end do
        if (start > len_line) exit

        ! Find end of word
        end_pos = start
        do while (end_pos <= len_line .and. line(end_pos:end_pos) /= ' ')
            end_pos = end_pos + 1
        end do

        word = line(start:end_pos-1)
        count = count + 1
        tokens(count) = adjustl(word)

        start = end_pos + 1
    end do
    ! Resize tokens array to actual number of tokens
    if (count < size(tokens)) then
        tokens = tokens(1:count)
    end if
  end subroutine split_by_multispace

  !!> \brief Check headers against the expected order
  !!>
  !!> \param[in] header_line Header line to check
  !!> \param[inout] hmap Header map
  !!> \param[inout] use_hdr_map Flag to indicate if header map should be used
  subroutine check_headers(header_line, hmap, use_hdr_map)
    implicit none

    character(len=*), intent(in)    :: header_line !! Header line to check
    type(header_map), intent(inout) :: hmap        !! Header map
    character(len=90), allocatable  :: headers(:)  !! Array of headers
    logical,        allocatable     :: matched(:)  !! Array of matched flags
    logical, intent(inout) :: use_hdr_map          !! Flag to indicate if header map should be used
    integer                          :: ntok = 0   !! 0 | number of tokens
    integer                          :: i = 0      !! 0 | loop counter
    integer                          :: j = 0      !! 0 | loop counter
    integer                          :: imax = 0   !! 0 | max number of headers
    integer                          :: miss_cnt = 0 !! 0 | missing count
    integer                          :: extra_cnt = 0 !! 0 | extra count

    if (use_hdr_map) then
        j = 0

        ! 1) split the incoming header line
        call split_by_multispace(header_line, headers, ntok)
        imax    = size(hmap%expected)
        allocate(matched(ntok))
        matched = .false.

        ! 2) map *and* check order all in one pass
        hmap%is_correct = .true.
        do i = 1, imax
            hmap%col_order(i) = 0
            do j = 1, ntok
                if (adjustl(trim(headers(j))) == adjustl(trim(hmap%expected(i)))) then
                    hmap%col_order(i) = j
                    matched(j)        = .true.
                    exit
                end if
            end do

            ! if it wasn’t found at all, or was found at j /= i, mark false
            if (hmap%col_order(i) /= i) then
                hmap%is_correct = .false.
            end if
        end do

        ! 3) only build missing/extra when something’s wrong
        if (.not. hmap%is_correct) then
            ! missing
            miss_cnt = count(hmap%col_order == 0)
            allocate(hmap%missing(miss_cnt))
            miss_cnt = 0
            if (miss_cnt > 0) then
                do i = 1, imax
                    if (hmap%col_order(i) == 0) then
                        miss_cnt = miss_cnt + 1
                        hmap%missing(miss_cnt) = hmap%expected(i)
                    end if
                end do
            end if

            ! extra
            extra_cnt = count(.not. matched)
            allocate(hmap%extra(extra_cnt))
            extra_cnt = 0
            if (extra_cnt > 0) then
                do j = 1, ntok
                    if (.not. matched(j)) then
                        extra_cnt = extra_cnt + 1
                        hmap%extra(extra_cnt) = trim(headers(j))
                    end if
                end do
            end if
        else
            ! perfect match: allocate zero-length so they're always safe
            allocate(hmap%missing(0))
            allocate(hmap%extra(0))
        end if
        if (hmap%is_correct) then
            use_hdr_map = .false.
        end if
    end if
  end subroutine check_headers

  !!> \brief Reorder a line based on the header map
  !!>
  !!> \param[in] unit Unit number to read from
  !!> \param[in] hmap Header map
  !!> \param[out] out_line Reordered line
  subroutine reorder_line(unit, hmap, out_line)
    implicit none

    integer, intent(in) :: unit !! Unit number to read from
    character(len=2000) :: line = '' !! '' | line buffer
    type(header_map), intent(in) :: hmap !! Header map
    character(len=2000), intent(out) :: out_line !! Reordered line
    character(len=90), allocatable :: tok(:) !! Array of tokens
    integer :: ntok = 0 !! 0 | number of tokens
    integer :: i = 0    !! 0 | loop counter
    integer :: ios = 0  !! 0 | I/O status

    out_line = ''  ! Initialize output

    if (.not. hmap%is_correct) then
        read(unit,'(A)',iostat=ios) line
        if (ios /= 0) return

        call split_by_multispace(line, tok, ntok)

        do i = 1, size(hmap%expected)
            if (hmap%col_order(i) /= 0 .and. hmap%col_order(i) <= ntok) then
                out_line = trim(out_line)//' '//trim(tok(hmap%col_order(i)))
            else
                out_line = trim(out_line)//' '//trim(hmap%default_vals(i))
            end if
        end do

        out_line = adjustl(out_line)
        deallocate(tok)
    end if
  end subroutine reorder_line

end module input_read_module
