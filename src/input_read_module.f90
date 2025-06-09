!> \brief Master mapping registry and input reader
!!>
!!> Provides routines to load header mappings once and apply them for data reordering
module input_read_module
  implicit none

  !==================[Constants and Module Variables]====================!
  integer, parameter        :: MAX_LINE_LEN = 2000      !!   | Maximum length of a line 
  integer, parameter        :: STR_LEN    = 90       !!   | Maximum length of a string allowed 
  integer, parameter        :: NAME_LEN      = 60       !!   | Maxiumum Length of a File Name 
  integer, parameter        :: IO_UNIT      = 107      !!   | I/O unit number of header_map.cio file
  integer, parameter        :: MAX_HDRS     = 100      !!   | Maximum number of Files in the header_map.cio file
  character(len=STR_LEN), parameter :: DEFAULT_STR = 'MISSING'
  
  logical                   :: mapping_loaded = .false.                     !! | Flag to indicate if the header mappings have been loaded
  integer                                 :: map_count = 0                  !! | Count of header mappings loaded
  character(len=NAME_LEN), allocatable                  :: missing_tags(:)     !! | Array to store missing tags
  integer                                 :: num_missing_tags = 0           !! | Number of missing tags

  
  character(len=NAME_LEN)  :: HDR_file = 'header_map.cio'
  character(len=60) :: tag
  character(len=NAME_LEN), allocatable :: tmp_missing(:)

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
  
  type(header_map), allocatable, target :: all_maps(:)   !! Array of header maps
  type(header_map), pointer              :: active_map  !! | Pointer to the active header map

  type(header_map), allocatable :: tmp_maps(:)
  
  type(header_map), allocatable :: filtered(:)

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

!==================[ Load_header_mappings - One-Pass ]=======================!!
! Purpose: Single-pass parser that distinguishes metadata (3 tokens) from
!          column-mapping rows (5 tokens) in header_map.cio,
!          storing only used headers and removing unused entries.
subroutine load_header_mappings()
  implicit none

  ! Module-level assumptions (in containing module):
  !   type(header_map), allocatable, target :: all_maps(:)
  !   type(header_map), allocatable          :: tmp_maps(:)

  ! Local variables
  character(len=MAX_LINE_LEN)         :: line
  character(len=STR_LEN), allocatable :: tok(:)
  integer                             :: io, nf, i, idx, ncols, p, map_idx
  character(len=NAME_LEN)             :: file_id
  logical                             :: used_flag, i_exist
  character(len=NAME_LEN)             :: last_file_id = ''
  integer                             :: last_map_idx = 0
  integer                             :: keep_count

  map_count      = 0
  mapping_loaded = .false.

  ! Check for existence of the header_map file
  inquire(file=HDR_file, exist=i_exist)
  if (.not. i_exist) return

  ! Open the file
  open(unit=IO_UNIT, file=trim(HDR_file), status='old', action='read', iostat=io)
  if (io /= 0) return

  ! Single-pass parse: metadata and column mappings
  do
    read(IO_UNIT, '(A)', iostat=io) line
    if (io /= 0) exit   ! EOF or read error

    ! Skip blanks or comment lines (leading spaces allowed)
    if (trim(line) == '') cycle
    p = 1
    do while (p <= len_trim(line) .and. line(p:p) == ' ')
      p = p + 1
    end do
    if (line(p:p) == '#') cycle

    call split_by_multispace(line, tok, nf)
    select case(nf)

    case (3)
      ! Metadata: <filename> <Y/N> <ncols>
      file_id   = trim(tok(1))
      used_flag = (tok(2)(1:1) == 'Y' .or. tok(2)(1:1) == 'y')
      read(tok(3), *, iostat=io) ncols
      if (io /= 0) ncols = 0

      if (used_flag) then
        map_count = map_count + 1
        ! Grow all_maps
        if (.not. allocated(all_maps)) then
          allocate(all_maps(1))
        else
          allocate(tmp_maps(map_count))
          tmp_maps(1:map_count-1) = all_maps
          call move_alloc(tmp_maps, all_maps)
        end if
        ! Initialize new map entry
        all_maps(map_count)%name      = file_id
        all_maps(map_count)%used      = .true.
        allocate(all_maps(map_count)%expected   (ncols))
        allocate(all_maps(map_count)%default_vals(ncols))
        allocate(all_maps(map_count)%mandatory  (ncols))
        allocate(all_maps(map_count)%col_order  (ncols))
        all_maps(map_count)%col_order = 0
      end if

    case (5)
      ! Column mapping: <filename> <idx> <expected> <default> <mandatory>
      file_id = trim(tok(1))
      ! Fast lookup for repeated filenames
      if (file_id == last_file_id) then
        map_idx = last_map_idx
      else
        map_idx = 0
        do i = 1, map_count
          if (all_maps(i)%name == file_id) then
            map_idx = i
            last_file_id = file_id
            last_map_idx = i
            exit
          end if
        end do
      end if
      if (map_idx == 0) cycle   ! mapping for unused or unknown file

      read(tok(2), *, iostat=io) idx
      if (io /= 0) cycle
      if (idx < 1 .or. idx > size(all_maps(map_idx)%expected)) cycle

      all_maps(map_idx)%expected   (idx) = trim(tok(3))
      all_maps(map_idx)%default_vals(idx) = trim(tok(4))
      all_maps(map_idx)%mandatory  (idx) = (tok(5)(1:1) == 'Y')
      all_maps(map_idx)%col_order  (idx) = idx

    case default
      ! ignore lines with other token counts
    end select
  end do

  close(IO_UNIT)

  ! Post-process: remove any maps that received zero mappings
  keep_count = 0
  ! Allocate to maximum possible size
  allocate(missing_tags(map_count))
  num_missing_tags = 0
  do i = 1, map_count
    if (any(all_maps(i)%col_order /= 0)) then
      keep_count = keep_count + 1
    else
      num_missing_tags = num_missing_tags + 1
      missing_tags(num_missing_tags) = trim(all_maps(i)%name)
    end if
  end do

  ! Shrink missing_tags to remove any unused (empty) entries
  if (num_missing_tags < size(missing_tags)) then

    allocate(tmp_missing(num_missing_tags))
    tmp_missing = missing_tags(1:num_missing_tags)
    deallocate(missing_tags)
    call move_alloc(tmp_missing, missing_tags)
  end if

  ! Now filter out any all_maps entries that never got a mapping
  if (keep_count < map_count) then
    allocate(filtered(keep_count))
    keep_count = 0
    do i = 1, map_count
      if (any(all_maps(i)%col_order /= 0)) then
        keep_count = keep_count + 1
        filtered(keep_count) = all_maps(i)
      end if
    end do
    deallocate(all_maps)
    call move_alloc(filtered, all_maps)
    map_count = keep_count
  end if

  mapping_loaded = (map_count > 0)
end subroutine load_header_mappings

subroutine check_headers_by_tag(search_tag, header_line, use_hdr_map)
  implicit none

  ! Inputs
  character(len=*), intent(in)  :: search_tag
  character(len=*), intent(in)  :: header_line
  logical,       intent(inout)  :: use_hdr_map

  ! Locals
  character(len=STR_LEN), allocatable :: headers(:)
  logical,           allocatable      :: matched(:)
  integer               :: ntok, i, j, idx, h_index
  logical               :: found
  type(header_map), pointer :: hmap     ! pointer to the matching map
  type(header_map), pointer          :: hdr_map2(:)   !! |Pointer to all header maps

  use_hdr_map = .false.
  h_index    = 0
  if (.not. mapping_loaded) return
  
   hdr_map2 => all_maps


  ! 1) Find the matching header_map entry
  found = .false.
  tag = search_tag
  do i = 1, map_count
    if (trim(hdr_map2(i)%name) == trim(tag)) then
      h_index = i
      found = .true.
      exit
    end if
  end do
  
  if (.not. found) return


  ! Point at the map we want to test
  hmap => hdr_map2(h_index)
  use_hdr_map = .true.

  ! 2) Split the incoming header line
  call split_by_multispace(header_line, headers, ntok)

  ! Prepare matched flags
  allocate(matched(ntok))
  matched = .false.

  ! Assume correct until proven otherwise
  hmap%is_correct = .true.

  ! 3) Walk each expected column and try to find it in `headers`
  do i = 1, size(hmap%expected)
    hmap%col_order(i) = 0
    do j = 1, ntok
      if ( &
        lowercase(trim(headers(j))) == &
        lowercase(trim(hmap%expected(i))) ) then

        hmap%col_order(i) = j
        matched(j) = .true.
        exit
      end if
    end do
    if (hmap%col_order(i) == 0) hmap%is_correct = .false.
  end do

  ! 4) If it wasn’t perfect, collect missing & extra
  if (.not. hmap%is_correct) then
    ! missing
    idx = count(hmap%col_order == 0)
    if (idx > 0) then
      allocate(hmap%missing(idx))
      idx = 0
      do i = 1, size(hmap%col_order)
        if (hmap%col_order(i) == 0) then
          idx = idx + 1
          hmap%missing(idx) = hmap%expected(i)
        end if
      end do
    end if

    ! extra
    idx = count(.not. matched)
    if (idx > 0) then
      allocate(hmap%extra(idx))
      idx = 0
      do j = 1, ntok
        if (.not. matched(j)) then
          idx = idx + 1
          hmap%extra(idx) = headers(j)
        end if
      end do
    end if

  else
    ! perfect match: make sure arrays exist but are zero‐length
    if (.not. allocated(hmap%missing)) allocate(hmap%missing(0))
    if (.not. allocated(hmap%extra  )) allocate(hmap%extra  (0))
    use_hdr_map = .false.    ! everything matched → no need to apply the map
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
  hdr_map2 => all_maps
  
  ! Return early if no mapping is available
  if (.not. mapping_loaded) return
  
  ! Print message to standard output
  write(*,*) 'Alt mapping may have been used see Mapping information:'
  ! Open the output file for writing
  open (unit,file="use_hdr_map.fin")
  
  ! Loop over all header blocks
  do ii = 1, map_count
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