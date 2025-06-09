!> \file input_read_module.f90
!! \brief Master mapping registry and input reader for SWAT+
!!
!! This module handles the loading, management, and application of header mappings for input files.
!! It provides routines to:
!! - Load mappings from a configuration file (`header_map.cio`) that describe expected headers for various input files.
!! - Check the headers of input files against the mappings, identifying missing or extra columns.
!! - Reorder or fill missing columns in input lines according to the header mappings.
!! - Write mapping diagnostics for imperfect matches to a summary file.
!!
!! Main types:
!! - `header_map`: Structure holding mapping for a single file.
!!
!! Main entry points:
!! - `load_header_mappings`: Load all mappings from file.
!! - `check_headers_by_tag`: Check headers for a specific file/tag.
!! - `reorder_line`: Reorder input lines according to the mapping.
!! - `header_read_n_reorder`: Read and reorder lines with header mapping.
!! - `write_mapping_info`: Output mapping diagnostics.
!!
!! \author <Your Name>
!! \date <YYYY-MM-DD>
module input_read_module
  implicit none

  !==================[Constants and Module Variables]====================!
  integer, parameter        :: MAX_LINE_LEN = 2000      !! | Maximum length of a line 
  integer, parameter        :: STR_LEN    = 90          !! | Maximum length of a string allowed 
  integer, parameter        :: NAME_LEN      = 60       !! | Maximum length of a file name 
  integer, parameter        :: IO_UNIT      = 107       !! *IO | I/O unit number of header_map.cio file
  integer, parameter        :: MAX_HDRS     = 100       !! | Maximum number of header blocks in the mapping file
  character(len=STR_LEN), parameter :: DEFAULT_STR = 'MISSING' !! | Default string value for missing data

  logical                   :: mapping_loaded = .false. !! | Indicates whether the header mappings have been loaded
  integer                   :: map_count = 0            !! | Number of header mappings loaded
  character(len=NAME_LEN), allocatable :: missing_tags(:)     !! | Array for tags with no column assignments
  integer                   :: num_missing_tags = 0      !! | Number of missing tags

  character(len=NAME_LEN)   :: HDR_file = 'header_map.cio'    !! | Name of the mapping configuration file
  character(len=60)         :: tag                            !! | Temporary variable for tag name
  character(len=NAME_LEN), allocatable :: tmp_missing(:)      !! | Temporary array for missing tags

  !==================[ Types ]=======================================!

  type :: header_map    !! | Structure holding the mapping for a single file
      character(len=NAME_LEN)    :: name  =   ' '     !! | Name for the header map
      logical                    :: used = .false.    !! | Usage flag for the header map
      character(len=STR_LEN), allocatable   :: expected(:)     !! | Expected column names
      character(len=STR_LEN), allocatable   :: default_vals(:) !! | Default values for each expected column
      character(len=STR_LEN), allocatable   :: missing(:)      !! | Missing columns
      character(len=STR_LEN), allocatable   :: extra(:)        !! | Extra columns
      logical, allocatable                  :: mandatory(:)    !! | Mandatory flags for each expected column
      logical                    :: is_correct = .false.       !! | Flag to indicate if the header map is a perfect match
      integer, allocatable                  :: col_order(:)    !! | Order of columns in the header map
  end type header_map

  type(header_map), allocatable, target :: all_maps(:)    !! | Array of all header maps loaded from the mapping file
  type(header_map), pointer              :: active_map    !! | Pointer to the currently active header map

  type(header_map), allocatable :: tmp_maps(:)            !! | Temporary array for growing/shrinking all_maps
  type(header_map), allocatable :: filtered(:)            !! | Temporary array for filtering valid header maps

contains

  !==================[ Utility: Lowercase Converter ]===============!
  !> \brief Converts a string to lowercase.
  !! \param[in] str Input string.
  !! \return Lowercase version of str.
  pure function lowercase(str) result(res)
    character(len=*), intent(in) :: str                                   !! | Input string to convert to lowercase
    character(len=len(str))      :: res                                   !! | Resulting lowercase string
    character(len=26), parameter :: lc = 'abcdefghijklmnopqrstuvwxyz'     !! | Lowercase alphabet
    character(len=26), parameter :: uc = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'     !! | Uppercase alphabet
    integer                      :: i                                     !! | Loop counter
    integer                      :: pos                                   !! | Position of character in alphabet

    res = str
    ! Convert each character to lowercase
    do i = 1, len_trim(str)
      pos = index(uc, str(i:i))
      if (pos > 0) res(i:i) = lc(pos:pos)
    end do
  end function lowercase

  !==================[ Split_by_Multispace ]=================!
  !> \brief Splits a line into tokens based on spaces, treating quoted strings as single tokens.
  !! \param[in] line Input line to split.
  !! \param[out] tokens Array of tokens found.
  !! \param[out] count Number of tokens found.
  subroutine split_by_Multispace(line, tokens, count)
    character(len=*), intent(in)         :: line                     !! | Line to split
    character(len=STR_LEN), allocatable, intent(out) :: tokens(:)    !! | Array of tokens
    integer, intent(out)                 :: count                    !! | Number of tokens found
    character(len=MAX_LINE_LEN)          :: buffer                   !! | Temporary buffer for the line
    character(len=STR_LEN)               :: word                     !! | Current word being built
    logical                              :: in_quotes = .false.      !! | Flag for being inside quotes
    integer                              :: len_line                 !! | Length of the line
    integer                              :: i                        !! | Loop counter

    !-----------------------------------------------------------------------
    ! Initialise buffers and counters before scanning the line
    !-----------------------------------------------------------------------
    allocate(tokens(1000))
    buffer   = line
    word     = ''
    count    = 0
    len_line = len_trim(buffer)
    in_quotes = .false.

    !-----------------------------------------------------------------------
    ! Scan each character of the line. Quoted strings are preserved and
    ! spaces outside of quotes are used as delimiters.
    !-----------------------------------------------------------------------
    do i = 1, len_line
      select case (buffer(i:i))
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

    !-----------------------------------------------------------------------
    ! Append the last token if one remains after exiting the loop
    !-----------------------------------------------------------------------
    if (len_trim(word) > 0) then
      count = count + 1
      tokens(count) = adjustl(word)
    end if

    !-----------------------------------------------------------------------
    ! Resize the token array to the actual number of tokens discovered
    !-----------------------------------------------------------------------
    if (count < size(tokens)) tokens = tokens(1:count)
  end subroutine split_by_Multispace

  !==================[ Load_header_mappings - One-Pass ]=======================!
  !> \brief Loads header mappings from the mapping configuration file.
  subroutine load_header_mappings()
    implicit none

    character(len=MAX_LINE_LEN)         :: line               !! | Line buffer for reading file
    character(len=STR_LEN), allocatable :: tok(:)             !! | Token array
    integer                             :: io                 !! | I/O status code
    integer                             :: nf                 !! | Number of tokens found
    integer                             :: i                  !! | Loop counter
    integer                             :: idx                !! | Index for column assignment
    integer                             :: ncols              !! | Number of columns for a map
    integer                             :: p                  !! | Loop/index for skipping leading spaces
    integer                             :: map_idx            !! | Index of current map in all_maps
    character(len=NAME_LEN)             :: file_id            !! | File/tag name
    logical                             :: used_flag          !! | Indicates whether map is in use
    logical                             :: i_exist            !! | File existence flag
    character(len=NAME_LEN)             :: last_file_id = ''  !! | Last file/tag read (for quick lookup)
    integer                             :: last_map_idx = 0   !! | Index of last file/tag
    integer                             :: keep_count         !! | Counter for valid maps

    !-----------------------------------------------------------------------
    ! Initialise state and attempt to open the mapping configuration file
    !-----------------------------------------------------------------------
    map_count      = 0
    mapping_loaded = .false.

    inquire(file=HDR_file, exist=i_exist)
    if (.not. i_exist) return

    open(unit=IO_UNIT, file=trim(HDR_file), status='old', action='read', iostat=io)
    if (io /= 0) return

    !-----------------------------------------------------------------------
    ! Read the file line by line.  Lines with three tokens define a new file
    ! mapping.  Lines with five tokens assign individual column information.
    !-----------------------------------------------------------------------
    do
      read(IO_UNIT, '(A)', iostat=io) line
      if (io /= 0) exit   ! EOF or read error

      if (trim(line) == '') cycle
      p = 1
      do while (p <= len_trim(line) .and. line(p:p) == ' ')
        p = p + 1
      end do
      if (line(p:p) == '#') cycle

      call split_by_multispace(line, tok, nf)
      select case(nf)
      case (3)
        !-- Beginning of a new header mapping block -----------------------
        file_id   = trim(tok(1))
        used_flag = (tok(2)(1:1) == 'Y' .or. tok(2)(1:1) == 'y')
        read(tok(3), *, iostat=io) ncols
        if (io /= 0) ncols = 0

        if (used_flag) then
          map_count = map_count + 1
          if (.not. allocated(all_maps)) then
            allocate(all_maps(1))
          else
            allocate(tmp_maps(map_count))
            tmp_maps(1:map_count-1) = all_maps
            call move_alloc(tmp_maps, all_maps)
          end if
          all_maps(map_count)%name      = file_id
          all_maps(map_count)%used      = .true.
          allocate(all_maps(map_count)%expected   (ncols))
          allocate(all_maps(map_count)%default_vals(ncols))
          allocate(all_maps(map_count)%mandatory  (ncols))
          allocate(all_maps(map_count)%col_order  (ncols))
          all_maps(map_count)%col_order = 0
        end if

      case (5)
        !-- Column definition within a mapping ---------------------------
        file_id = trim(tok(1))
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
        if (map_idx == 0) cycle      ! Skip entries for unknown mappings

        read(tok(2), *, iostat=io) idx
        if (io /= 0) cycle
        if (idx < 1 .or. idx > size(all_maps(map_idx)%expected)) cycle

        all_maps(map_idx)%expected   (idx) = trim(tok(3))
        all_maps(map_idx)%default_vals(idx) = trim(tok(4))
        all_maps(map_idx)%mandatory  (idx) = (tok(5)(1:1) == 'Y')
        all_maps(map_idx)%col_order  (idx) = idx

      case default
      end select
    end do

    !-----------------------------------------------------------------------
    ! Finished reading the mapping file
    !-----------------------------------------------------------------------
    close(IO_UNIT)

    keep_count = 0
    allocate(missing_tags(map_count))
    num_missing_tags = 0
    !-----------------------------------------------------------------------
    ! Remove mappings that have no columns defined and collect their tags
    !-----------------------------------------------------------------------
    do i = 1, map_count
      if (any(all_maps(i)%col_order /= 0)) then
        keep_count = keep_count + 1
      else
        num_missing_tags = num_missing_tags + 1
        missing_tags(num_missing_tags) = trim(all_maps(i)%name)
      end if
    end do

    ! Resize the missing tag list to the actual number found
    if (num_missing_tags < size(missing_tags)) then
      allocate(tmp_missing(num_missing_tags))
      tmp_missing = missing_tags(1:num_missing_tags)
      deallocate(missing_tags)
      call move_alloc(tmp_missing, missing_tags)
    end if

    ! Compact the mapping array so that only valid mappings remain
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

    ! Flag indicating whether any usable mappings were loaded
    mapping_loaded = (map_count > 0)
  end subroutine load_header_mappings

  !==================[ check_headers_by_tag ]=======================!
  !> \brief Checks an input header line against the mapping for a given tag.
  subroutine check_headers_by_tag(search_tag, header_line, use_hdr_map)
    implicit none

    character(len=*), intent(in)  :: search_tag             !! | Tag to search for
    character(len=*), intent(in)  :: header_line            !! | Header line from the input file
    logical,       intent(inout)  :: use_hdr_map            !! | Will be set to true if a mapping applies

    character(len=STR_LEN), allocatable :: headers(:)       !! | Array of header tokens from file
    logical,           allocatable      :: matched(:)       !! | Flags for matched columns
    integer                             :: ntok             !! | Number of tokens in header_line
    integer                             :: i, j             !! | Loop counters
    integer                             :: idx              !! | Index for missing/extra columns
    integer                             :: h_index          !! | Index of matching map
    logical                             :: found            !! | Flag if mapping found
    type(header_map), pointer           :: hmap             !! | Pointer to current header map
    type(header_map), pointer           :: hdr_map2(:)      !! | Pointer to all header maps

    !-----------------------------------------------------------------------
    ! Look for a loaded mapping that matches the requested tag
    !-----------------------------------------------------------------------
    use_hdr_map = .false.
    h_index    = 0
    if (.not. mapping_loaded) return
    hdr_map2 => all_maps

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

    !-----------------------------------------------------------------------
    ! Prepare to check the header line against the selected mapping
    !-----------------------------------------------------------------------
    hmap => hdr_map2(h_index)
    use_hdr_map = .true.

    ! Tokenise the header line for comparison
    call split_by_multispace(header_line, headers, ntok)

    allocate(matched(ntok))
    matched = .false.

    hmap%is_correct = .true.
    !-----------------------------------------------------------------------
    ! Determine the column order by matching expected headers to the tokens
    !-----------------------------------------------------------------------
    do i = 1, size(hmap%expected)
      hmap%col_order(i) = 0
      do j = 1, ntok
        if (lowercase(trim(headers(j))) == lowercase(trim(hmap%expected(i)))) then
          hmap%col_order(i) = j
          matched(j) = .true.
          exit
        end if
      end do
      if (hmap%col_order(i) == 0) hmap%is_correct = .false.
    end do

    !-----------------------------------------------------------------------
    ! If any expected headers were not found record missing/extra fields
    !-----------------------------------------------------------------------
    if (.not. hmap%is_correct) then
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
      ! Perfect match: initialise empty arrays and disable reordering
      if (.not. allocated(hmap%missing)) allocate(hmap%missing(0))
      if (.not. allocated(hmap%extra  )) allocate(hmap%extra  (0))
      use_hdr_map = .false.
    end if

    ! Clean up temporary arrays
    deallocate(matched)
    deallocate(headers)
  end subroutine check_headers_by_tag

  !==================[ reorder_line ]=======================!
  !> \brief Reorders a line from an input unit based on the active header map.
  subroutine reorder_line(unit, out_line)
    implicit none

    integer, intent(in)              :: unit                !! *unit | Input unit number
    character(len=2000)              :: line = ''           !! | Line buffer
    type(header_map), pointer        :: hmap2               !! | Pointer to active header map
    character(len=2000), intent(out) :: out_line            !! | Output line, reordered as needed
    character(len=90), allocatable   :: tok(:)              !! | Array of tokens
    integer                          :: ntok = 0            !! | Number of tokens
    integer                          :: i = 0               !! | Loop counter
    integer                          :: ios = 0             !! | I/O status

    !-----------------------------------------------------------------------
    ! Fetch the active map and read the raw line from the unit when needed
    !-----------------------------------------------------------------------
    !-----------------------------------------------------------------------
    ! Read a raw line from the unit and use the active mapping if requested
    !-----------------------------------------------------------------------
    out_line = ''
    hmap2 => active_map

    if (.not. hmap2%is_correct) then
      read(unit,'(A)',iostat=ios) line
      if (ios /= 0) return

      ! Tokenise the input line and rebuild it in the expected order
      call split_by_multispace(line, tok, ntok)

      do i = 1, size(hmap2%expected)
        if (hmap2%col_order(i) /= 0 .and. hmap2%col_order(i) <= ntok) then
          out_line = trim(out_line)//' '//trim(tok(hmap2%col_order(i)))
        else
          out_line = trim(out_line)//' '//trim(hmap2%default_vals(i))
        end if
      end do

      out_line = adjustl(out_line)
      deallocate(tok)
    end if
  end subroutine reorder_line

  !==================[ header_read_n_reorder ]=======================!
  !> \brief Reads a line and reorders it according to the header map, if needed.
  subroutine header_read_n_reorder(unit, use_hdr_map, out_line)
    implicit none

    integer, intent(in)              :: unit                !! *unit | Input unit number
    character(len=2000)              :: line = ''           !! | Line buffer
    type(header_map), pointer        :: hmap2               !! | Pointer to active header map
    character(len=2000), intent(out) :: out_line            !! | Output line, reordered as needed
    character(len=90), allocatable   :: tok(:)              !! | Array of tokens
    integer                          :: ntok = 0            !! | Number of tokens
    integer                          :: i = 0               !! | Loop counter
    integer                          :: ios = 0             !! | I/O status
    logical, intent(inout)           :: use_hdr_map         !! | Flag for header mapping

    out_line = ''
    hmap2 => active_map

    read(unit,'(A)',iostat=ios) line
    if (ios /= 0) return

    if (use_hdr_map) then
      if (hmap2%is_correct) then
        out_line = line
      else
        ! Re-tokenise and reorder the line according to the mapping
        call split_by_multispace(line, tok, ntok)
        do i = 1, size(hmap2%expected)
          if (hmap2%col_order(i) /= 0 .and. hmap2%col_order(i) <= ntok) then
            out_line = trim(out_line)//' '//trim(tok(hmap2%col_order(i)))
          else
            out_line = trim(out_line)//' '//trim(hmap2%default_vals(i))
          end if
        end do
        out_line = adjustl(out_line)
        deallocate(tok)
      end if
    else
      out_line = line
    endif
  end subroutine header_read_n_reorder

  !==================[ write_mapping_info ]=======================!
  !> \brief Writes summary information about non-perfect header mappings to a file.
  subroutine write_mapping_info
    implicit none
    integer                          :: unit = 1942        !! *unit | Output unit number for mapping info
    integer                          :: i                  !! | Loop counter
    integer                          :: ii                 !! | Loop counter
    type(header_map), pointer        :: hdr_map2(:)         !! | Pointer to all header maps

    hdr_map2 => all_maps
    if (.not. mapping_loaded) return

    ! Inform the user and write details for any imperfect matches
    write(*,*) 'Alt mapping may have been used see Mapping information:'
    open (unit,file="use_hdr_map.fin")
    do ii = 1, map_count
      if (.not. hdr_map2(ii)%is_correct) then
        write(unit,*) trim(hdr_map2(ii)%name)
        if (size(hdr_map2(ii)%missing) > 0) then
          write(unit,*) 'Missing columns: ', (trim(hdr_map2(ii)%missing(i)), ' ', i=1, size(hdr_map2(ii)%missing))
        end if
        if (size(hdr_map2(ii)%extra) > 0) then
          write(unit,*) 'Extra columns: ', (trim(hdr_map2(ii)%extra(i)), ' ', i=1, size(hdr_map2(ii)%extra))
        end if
      end if
    end do
    close(unit)
  end subroutine write_mapping_info

end module input_read_module