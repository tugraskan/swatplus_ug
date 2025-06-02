!> \brief Master mapping registry and input reader
!!>
!!> Provides routines to load header mappings once and apply them for data reordering
module input_read_module
  implicit none

  !==================[Constants and Module Variables]====================!
  integer, parameter        :: MAX_LINE_LEN = 512      !!   | Maximum length of a line 
  integer, parameter        :: STR_LEN    = 90       !!   | Maximum length of a string allowed 
  integer, parameter        :: NAME_LEN      = 60       !!   | Maxiumum Length of a File Name 
  integer, parameter        :: IO_UNIT      = 107      !!   | I/O unit number of header_map.cio file
  integer, parameter        :: MAX_HDRS     = 100      !!   | Maximum number of Files in the header_map.cio file
  
  logical                   :: mapping_loaded = .false.                     !! | Flag to indicate if the header mappings have been loaded
  integer                                 :: map_count = 0                  !! | Count of header mappings loaded
  character(len=NAME_LEN)                  :: missing_tags(MAX_HDRS) = ''    !! | Array to store missing tags
  integer                                 :: num_missing_tags = 0           !! | Number of missing tags
  integer                                 :: hblock  = 0     !! | Header block number

  !==================[ Types ]=======================================!

  type :: header_map    !! Header map structure
      character(len=NAME_LEN)    :: name  =   ' '     !! | Name for the header map
      logical                                 :: used = .false.    !! | Usage flag for the header map ('y' or 'n')
      character(len=STR_LEN), allocatable   :: expected(:)  !! | Expected column names in the header map
      character(len=STR_LEN), allocatable   :: default_vals(:)  !! | Default values for each expected column
      character(len=STR_LEN), allocatable   :: missing(:)   !! | Missing columns in the header map
      character(len=STR_LEN), allocatable   :: extra(:)     !! | Extra columns in the header map
      logical,             allocatable        :: mandatory(:) !! | Mandatory flags for each expected column
      logical                                 :: is_correct = .false.   !! | Flag to indicate if the header map is a perfect match
      integer,             allocatable        :: col_order(:) !! | Order of columns in the header map

      
  end type header_map
  
  type(header_map), target :: all_maps(MAX_HDRS) !! Array of header maps
  type(header_map), pointer              :: active_map  !! | Pointer to the active header map
  type(header_map), allocatable :: tmp(:)

contains

  !==================[ Utility: Lowercase Converter ]===============!
  pure function lowercase(str) result(res)
  character(len=*), intent(in) :: str                                   !!  | Input string to convert to lowercase
  character(len=len(str))      :: res                                   !!  | Resulting lowercase string
  character(len=26), parameter :: lc = 'abcdefghijklmnopqrstuvwxyz'     !!  | Lowercase alphabet
  character(len=26), parameter :: uc = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'     !!  | Uppercase alphabet
    integer :: i, pos

    res = str
    !! Convert each character to lowercase
    do i = 1, len_trim(str)
      pos = index(uc, str(i:i))
      if (pos > 0) res(i:i) = lc(pos:pos)
    end do
  end function lowercase

  !!==================[ Split_by_Multispace ]=================!!
  !! Purpose: This subroutine splits a line into tokens based on multiple spaces and quotes.
  subroutine split_by_Multispace(line, tokens, count)
    character(len=*), intent(in)         :: line            !! | Line to split
    character(len=STR_LEN), allocatable, intent(out) :: tokens(:) !! | Array of tokens /characters
    integer, intent(out)                 :: count       !! | Number of tokens found
    character(len=MAX_LINE_LEN) :: buffer       !! | Temparary buffer for the line, helps see debug value in VS
    character(len=STR_LEN)    :: word         !! | Current word being built
    logical :: in_quotes = .false. !! | Flag to indicate if we are inside quotes, some files have quoted strings
    integer :: len_line          !! | Length of the line
    integer :: i    !! | Loop counter

    ! Allocate tokens array with a maximum size
    allocate(tokens(1000))
    buffer = line
    word = ''
    count = 0
    len_line = len_trim(buffer)
    in_quotes = .false.

    !! Loop through each character in the line
    do i = 1, len_line
    !! Check if the character is a quote, space, or other
      select case (buffer(i:i))
      
      ! If it's a quote, toggle the in_quotes flag and trim the word
      case ('"')
        in_quotes = .not. in_quotes
        word = trim(word)//buffer(i:i)
      case (' ')
        if (in_quotes) then
          word = trim(word)//buffer(i:i)
        else if (len_trim(word) > 0) then
          count = count + 1
          tokens(count) = adjustl(word)
          word = ''
        end if
      case default
        word = trim(word)//buffer(i:i)
      end select
    end do
    
    !! Check if there is a word left after the loop
    if (len_trim(word) > 0) then
      count = count + 1
      tokens(count) = adjustl(word)
    end if
    
    !! If the count is less than the allocated size, resize the tokens array
    if (count < size(tokens)) tokens = tokens(1:count)
  end subroutine split_by_Multispace

subroutine load_header_mappings()
  implicit none

  ! Local Variables
  character(len=MAX_LINE_LEN)        :: line
  character(len=STR_LEN), allocatable :: words(:)
  character(len=NAME_LEN)           :: block_name
  character(len=1)                  :: usage_flag, lower_flag
  integer                            :: iostat, num_fields
  integer                            :: declared_num_cols, actual_count
  integer                            :: idx, i, map_index
  integer                            :: state      ! 0=look for [filelist], 1=in filelist, 2=in blocks

  ! Reset counters (assume all_maps and map_count are module variables)
  map_count      = 0
  mapping_loaded = .false.
  state          = 0

  ! If file doesn’t exist, bail
  inquire(file='header_map.cio', exist=iostat)
  if (iostat == 0) return

  open(unit=IO_UNIT, file='header_map.cio', status='old', action='read', iostat=iostat)
  if (iostat /= 0) return

  !— Read once to skip the title line (we assume it’s always present) —
  read(IO_UNIT,'(A)',iostat=iostat) line
  if (iostat /= 0) then
    close(IO_UNIT)
    return
  end if

  !— Main loop: state 0 finds “[filelist]”, state 1 reads filelist entries,
  !   state 2 handles each “[<filename>]” block (using declared_num_cols). —
  do
    read(IO_UNIT,'(A)',iostat=iostat) line
    if (iostat /= 0) exit   ! EOF → done

    ! Skip blank or comment lines
    if (trim(line)=='' .or. line(1:1)=='#') cycle

    select case (state)

    case (0)
      !— Expect “[filelist]” as the very first real line —
      if (trim(adjustl(line)) /= '[filelist]') then
        close(IO_UNIT)
        return
      end if
      state = 1
      cycle

    case (1)
      !— In [filelist] until we hit a “[foo]” marker —
      if (line(1:1)=='[' .and. index(line,']')>1) then
        block_name = adjustl(line(2:index(line,']')-1))
        block_name = trim(block_name)
        state = 2
        cycle
      end if

      ! Otherwise, parse “<filename>  <Y/N>  <declared_num_cols>”
      call split_by_Multispace(line, words, num_fields)
      if (num_fields < 3) cycle

      map_count = map_count + 1
      all_maps(map_count)%name = trim(words(1))
      usage_flag = words(2)(1:1)
      all_maps(map_count)%used = (usage_flag=='Y' .or. usage_flag=='y')

      read(words(3),*, iostat=iostat) declared_num_cols
      if (iostat /= 0) declared_num_cols = 0

      if (declared_num_cols > 0) then
        allocate(all_maps(map_count)%expected   (declared_num_cols))
        allocate(all_maps(map_count)%default_vals(declared_num_cols))
        allocate(all_maps(map_count)%mandatory  (declared_num_cols))
        allocate(all_maps(map_count)%col_order  (declared_num_cols))
        all_maps(map_count)%col_order = [(i, i=1,declared_num_cols)]
      end if

      cycle

    case (2)
      !— We have just seen “[foo]” (e.g. “[hru.con]”), stored in block_name. —

      ! 1) Find map_index for this block
      map_index = 0
      do i = 1, map_count
        if (all_maps(i)%name == block_name) then
          map_index = i
          exit
        end if
      end do

      ! 2) If not found or used=FALSE, skip until next “[foo]” marker or EOF
      if (map_index == 0 .or. .not. all_maps(map_index)%used) then
        do
          read(IO_UNIT,'(A)',iostat=iostat) line
          if (iostat /= 0) exit   ! EOF → done

          if (trim(line)=='' .or. line(1:1)=='#') cycle

          if (line(1:1)=='[' .and. index(line,']')>1) then
            block_name = adjustl(line(2:index(line,']')-1))
            block_name = trim(block_name)
            exit
          end if
        end do

        cycle   ! back to main loop (still state=2) with next block_name or EOF
      end if

      ! 3) Block is used = TRUE.  Read exactly declared_num_cols data rows:
      declared_num_cols = size(all_maps(map_index)%expected)
      actual_count = 0
      do while (actual_count < declared_num_cols)
          read(IO_UNIT, '(A)', iostat=iostat) line
          if (iostat /= 0) exit   ! EOF → bail

          ! 1) Skip blank‐only lines
          if (trim(line) == '') cycle

          ! 2) Skip comment lines even if they start with spaces
          if (line(1:1) == '#') cycle

          ! 3) If this is a new “[foo]” marker (again, maybe spaces before “[”)
          if (adjustl(line)(1:1) == '[' .and. index(adjustl(line),']') > 1) then
            block_name = adjustl( line( 2 : index(adjustl(line),']')-1 ) )
            block_name = trim(block_name)
            exit  ! missing data rows—bail out
          end if

          ! 4) Otherwise it’s a data row. Parse it:
          call split_by_Multispace(line, words, num_fields)
          if (num_fields < 4) cycle

          read(words(1), *, iostat=iostat) idx
          if (iostat /= 0) cycle
          if (idx < 1 .or. idx > declared_num_cols) cycle

          all_maps(map_index)%expected   (idx) = trim(words(2))
          all_maps(map_index)%default_vals(idx) = trim(words(3))

          lower_flag = 'N'
          if (num_fields >= 4) lower_flag = trim(words(4))
          all_maps(map_index)%mandatory(idx) = (lower_flag == 'Y' .or. lower_flag == 'y')

          actual_count = actual_count + 1
          
      end do
      ! 4) We (hopefully) finished reading all declared_num_cols, or hit a marker/EOF. Now skip to the next “[foo]”:
      do
        read(IO_UNIT,'(A)',iostat=iostat) line
        if (iostat /= 0) exit   ! EOF → done

        if (trim(line)=='' .or. line(1:1)=='#') cycle

        if (line(1:1)=='[' .and. index(line,']')>1) then
          block_name = adjustl(line(2:index(line,']')-1))
          block_name = trim(block_name)
          exit
        end if
      end do

      cycle   ! return to main loop, state=2, with the next block_name or EOF
    end select
  end do

  close(IO_UNIT)
  mapping_loaded = (map_count > 0)
end subroutine load_header_mappings

subroutine check_headers_by_tag(search_tag, header_line, use_hdr_map)
  implicit none

  character(len=*), intent(in)       :: search_tag    !! |Tag to search for
  character(len=*), intent(in)       :: header_line   !! |Header line to check
  character(len=STR_LEN) :: tag = ''        !!  |tag for mapping
  !type(header_map), pointer          :: hmap          !! |Output: pointer to matching header map
  !character(len=3), intent(out)      :: pvar          !! |Format variable
  logical, intent(inout)             :: use_hdr_map   !! |Flag to indicate whether to use map

  character(len=90), allocatable     :: headers(:)    !! |Header tokens
  logical, allocatable               :: matched(:)    !! |Flags for matched headers
  integer                            :: ntok, i, j
  integer                            :: miss_cnt, extra_cnt
  integer                            :: imax
  integer                            :: h_index 
  type(header_map)         :: hdr_map2(MAX_HDRS)

  ! Initialize outputs

  use_hdr_map = .false.
  h_index = 0

  if (.not. mapping_loaded) return

  ! Lookup the tag in available mappings
  tag = search_tag
  hdr_map2(i) = all_maps(i)
  do i = 1, hblock
    if (trim(hdr_map2(i)%name) == trim(tag)) then
      h_index = i
      use_hdr_map = .true.
      exit
    end if
  end do

  ! If not found, track it and exit
  if (h_index == 0) then
    if (num_missing_tags < size(missing_tags)) then
      num_missing_tags = num_missing_tags + 1
      missing_tags(num_missing_tags) = trim(tag)
    end if
    return
  end if

  ! Split and compare headers if map was found
  call split_by_multispace(header_line, headers, ntok)
  imax = size(hdr_map2(i)%expected)
  allocate(matched(ntok))
  matched = .false.
  hdr_map2(i)%is_correct = .true.

  do i = 1, imax
    hdr_map2(i)%col_order(i) = 0
    do j = 1, ntok
      if (lowercase(adjustl(trim(headers(j)))) == lowercase(adjustl(trim(hdr_map2(i)%expected(i))))) then
        hdr_map2(i)%col_order(i) = j
        matched(j) = .true.
        exit
      end if
    end do
    if (hdr_map2(i)%col_order(i) /= i) then
      hdr_map2(i)%is_correct = .false.
    end if
  end do

  if (.not. hdr_map2(i)%is_correct) then
    ! missing
    miss_cnt = count(hdr_map2(i)%col_order == 0)
    if (miss_cnt > 0) then
      allocate(hdr_map2(i)%missing(miss_cnt))
      miss_cnt = 0
      do i = 1, imax
        if (hdr_map2(i)%col_order(i) == 0) then
          miss_cnt = miss_cnt + 1
          hdr_map2(i)%missing(miss_cnt) = hdr_map2(i)%expected(i)
        end if
      end do
    end if

    ! extra
    extra_cnt = count(.not. matched)
    if (extra_cnt > 0) then
      allocate(hdr_map2(i)%extra(extra_cnt))
      extra_cnt = 0
      do j = 1, ntok
        if (.not. matched(j)) then
          extra_cnt = extra_cnt + 1
          hdr_map2(i)%extra(extra_cnt) = trim(headers(j))
        end if
      end do
    end if
  else
    allocate(hdr_map2(i)%missing(0))
    allocate(hdr_map2(i)%extra(0))
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
    hmap2 => active_map

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
    hmap2 => active_map
    
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

  
!  Write missing columns, extra columns, and mapping information to a file
  subroutine write_mapping_info
  implicit none
  integer :: unit = 1942 !! Unit number to write to
  integer :: i, ii
  type(header_map)         :: hdr_map2(MAX_HDRS)

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
  hdr_map2(i) = all_maps(i)
  
  ! Return early if no mapping is available
  if (.not. mapping_loaded) return
  
  ! Print message to standard output
  write(*,*) 'Alt mapping may have been used see Mapping information:'
  ! Open the output file for writing
  open (unit,file="use_hdr_map.fin")
  
  ! Loop over all header blocks
  do ii = 1, hblock
      ! Only process mappings that are not a perfect match
      if (.not. hdr_map2(ii)%is_correct) then
        ! Write the tag for the mapping
        write(unit,*) trim(hdr_map2(ii)%name)
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