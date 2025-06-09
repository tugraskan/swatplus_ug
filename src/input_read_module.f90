module input_read_module
  implicit none
    
!==================[Purpose]====================!
!> \file input_read_module.f90
!! \brief Master mapping registry and input reader for SWAT+
!!
!! This module handles the loading, management, and application of header mappings for input files.
!! It provides Subroutines to:
!! - `load_header_mappings`: Load mappings from a configuration file (`header_map.cio`)
!!    that describe expected headers for various input files.
!! - 'split_by_Multispace': Split lines into tokens based on spaces, treating quoted strings as single tokens.
!! - `check_headers_by_tag`: Check the headers of input files against the mappings, identifying missing or extra columns.
!! - `reorder_line`: Reorder input lines according to the mapping.
!! - `header_read_n_reorder`: Read and reorder lines with header mapping
!! - `write_mapping_info`: Write mapping diagnostics for imperfect matches to a summary file.
!! Functions:
!! - `lowercase`: Convert strings to lowercase for case-insensitive comparisons.
!!
!! Main types:
!! - `header_map`: Strupper_caseture holding mapping for a single file.
!! Input File format:   
!! Section 1: input       used    ncols
!! Section 2: input    idx    expected_header    default_value    mandatory_flag

  !==================[Constants and Module Variables]====================!
  integer, parameter        :: MAX_LINE_LEN = 2000      !! | Maximum length of a line 
  integer, parameter        :: STR_LEN    = 90          !! | Maximum length of a string allowed 
  integer, parameter        :: NAME_LEN      = 60       !! | Maximum length of a file name 
  integer, parameter        :: IO_UNIT      = 107       !! *IO | I/O unit number of header_map.cio file
  integer, parameter        :: MAX_HDRS     = 100       !! | Maximum number of header blocks in the mapping file
  character(len=STR_LEN), parameter :: DEFAULT_STR = 'MISSING' !! | Default string value for missing data
  logical                   :: use_hdr_maps = .false.   !! | Global flag to enable/disable use of header maps
  integer                   :: hdr_count = 0                !! | Number of header mappings loaded
  character(len=NAME_LEN), allocatable :: missing_cols(:)     !! | Array for tags with no column assignments
  integer                   :: num_missing_cols = 0      !! | Number of missing tags

  character(len=NAME_LEN)   :: hdr_filename = 'header_map.cio'    !! | Name of the mapping configuration file
  character(len=60)         :: tag                            !! | Temporary variable for tag name
  character(len=NAME_LEN), allocatable :: tmp_missing(:)      !! | Temporary array for missing tags

  !==================[ Types ]=======================================!

  type :: header_map    !! | Strupper_caseture holding the mapping for a single file
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

  type(header_map), allocatable, target :: all_hdr_maps(:)    !! | Array of all header maps loaded from the mapping file
  type(header_map), pointer              :: active_hdr_map    !! | Pointer to the currently active header map

  type(header_map), allocatable :: tmp_hdr_maps(:)            !! | Temporary array for growing/shrinking all_hdr_maps
  type(header_map), allocatable :: filtered_hdr_maps(:)            !! | Temporary array for filtering valid header maps

contains

  !==================[ Utility: Lowercase Converter ]===============!
  !> \brief Converts a string to lowercase.
  !! \param[in] str Input string.
  !! \return Lowercase version of str.
  pure function lowercase(str) result(res)
    character(len=*), intent(in) :: str                                   !! | Input string to convert to lowercase
    character(len=len(str))      :: res                                   !! | Resulting lowercase string
    character(len=26), parameter :: lower_case = 'abcdefghijklmnopqrstuvwxyz'     !! | Lowercase alphabet
    character(len=26), parameter :: upper_case = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'     !! | Uppercase alphabet
    integer                      :: i                                     !! | Loop counter
    integer                      :: pos                                   !! | Position of character in alphabet

    res = str
    !! Convert each character to lowercase
    do i = 1, len_trim(str)
      pos = index(upper_case, str(i:i))
      if (pos > 0) res(i:i) = lower_case(pos:pos)
    end do
  end function lowercase

  !==================[ Split_by_Multispace ]=================!
  !> \brief Splits a line into tokens based on spaces, treating quoted strings as single tokens.
  !! \param[in] line Input line to split.
  !! \param[out] tokens Array of tokens hdr_found.
  !! \param[out] count Number of tokens hdr_found.
  subroutine split_by_Multispace(line, tokens, count)
    character(len=*), intent(in)         :: line                     !! | Line to split
    character(len=STR_LEN), allocatable, intent(out) :: tokens(:)    !! | Array of tokens / character strings
    integer, intent(out)                 :: count                    !! | Number of tokens / character strings hdr_found
    character(len=MAX_LINE_LEN)          :: buffer                   !! | Temporary buffer for the line
    character(len=STR_LEN)               :: word                     !! | Current word being built
    logical                              :: in_quotes = .false.      !! | Flag for being inside quotes
    integer                              :: len_line                 !! | Length of the line
    integer                              :: i                        !! | Loop counter

    !-----------------------------------------------------------------------
    !! Initialise buffers and counters before scanning the line
    !-----------------------------------------------------------------------
    allocate(tokens(1000))
    buffer   = line
    word     = ''
    count    = 0
    len_line = len_trim(buffer)
    in_quotes = .false.

    !-----------------------------------------------------------------------
    !! Scan each character of the line. 
    !! Quoted strings are preserved & spaces outside of quotes are used as delimiters.
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
    !! Append the last token if one remains after exiting the loop
    !-----------------------------------------------------------------------
    if (len_trim(word) > 0) then
      count = count + 1
      tokens(count) = adjustl(word)
    end if

    !-----------------------------------------------------------------------
    !! Resize the token array to the actual number of tokens discovered
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
    integer                             :: num_tokens_found   !! | Number of tokens hdr_found
    integer                             :: i                  !! | Loop counter
    integer                             :: idx                !! | Index for column assignment
    integer                             :: ncols              !! | Number of columns for a map
    integer                             :: first_char      !! | Loop/index for skipping leading spaces
    integer                             :: map_idx            !! | Index of current map in all_hdr_maps
    character(len=NAME_LEN)             :: file_id            !! | File/tag name
    logical                             :: used_flag          !! | Indicates whether map is in use
    logical                             :: i_exist            !! | File existence flag
    character(len=NAME_LEN)             :: last_file_id = ''  !! | Last file/tag read (for quick lookup)
    integer                             :: last_map_idx = 0   !! | Index of last file/tag
    integer                             :: keep_count         !! | Counter for valid maps

    !-----------------------------------------------------------------------
    !! Initialise and attempt to open the mapping configuration file
    !-----------------------------------------------------------------------

    use_hdr_maps = .false.

    inquire(file=hdr_filename, exist=i_exist)
    if (.not. i_exist) return

    open(unit=IO_UNIT, file=trim(hdr_filename), status='old', action='read', iostat=io)
    if (io /= 0) return

    !-----------------------------------------------------------------------
    !! Read the file line by line.  Lines with three tokens define a new file
    !! mapping.  Lines with five tokens assign individual column information.
    !-----------------------------------------------------------------------
    do
      read(IO_UNIT, '(A)', iostat=io) line
      if (io /= 0) exit   ! EOF or read error
      
      ! skip empty lines and # comments
      if (trim(line) == '') cycle
      first_char = 1
      do while (first_char <= len_trim(line) .and. line(first_char:first_char) == ' ')
        first_char = first_char + 1
      end do
      if (line(first_char:first_char) == '#') cycle
      
      ! call split_by_multispace to tokenize the line
      call split_by_multispace(line, tok, num_tokens_found)
      
      ! using the number of fields in a line to determine the action
      select case(num_tokens_found)
          
      !-- Three fields indicate a new mapping in Section 1 -----------
      ! -- Read Input file name, used flag, and number of columns, tok 1,2,3
      case (3)
        
        file_id   = trim(tok(1))
        used_flag = (tok(2)(1:1) == 'Y' .or. tok(2)(1:1) == 'y')
        read(tok(3), *, iostat=io) ncols
        if (io /= 0) ncols = 0

        !-- Check if used_flag is true
        if (used_flag) then
          hdr_count = hdr_count + 1
          if (.not. allocated(all_hdr_maps)) then
            allocate(all_hdr_maps(1))
          else
            allocate(tmp_hdr_maps(hdr_count))
            tmp_hdr_maps(1:hdr_count-1) = all_hdr_maps
            call move_alloc(tmp_hdr_maps, all_hdr_maps)
          end if
          !-- Allocate the new header map strupper_caseture
          all_hdr_maps(hdr_count)%name      = file_id
          all_hdr_maps(hdr_count)%used      = .true.
          allocate(all_hdr_maps(hdr_count)%expected   (ncols))
          allocate(all_hdr_maps(hdr_count)%default_vals(ncols))
          allocate(all_hdr_maps(hdr_count)%mandatory  (ncols))
          allocate(all_hdr_maps(hdr_count)%col_order  (ncols))
          all_hdr_maps(hdr_count)%col_order = 0
        end if
      
      !-- Five fields indicate a column assignment in Section 2 --------
      !-- Read file name, index, expected header, default value, and mandatory flag, tok 1-5
      case (5)
          
        file_id = trim(tok(1))
        !-- Check if the file_id matches the last one processed to avoid repeated lookups
        if (file_id == last_file_id) then
          map_idx = last_map_idx
        !-- If not, search for the mapping index
        else
          map_idx = 0
          ! -- Search through all_hdr_maps for the file_id and set last_file_id, last_map_idx
          do i = 1, hdr_count
            if (all_hdr_maps(i)%name == file_id) then
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
        if (idx < 1 .or. idx > size(all_hdr_maps(map_idx)%expected)) cycle

        all_hdr_maps(map_idx)%expected   (idx) = trim(tok(3))
        all_hdr_maps(map_idx)%default_vals(idx) = trim(tok(4))
        all_hdr_maps(map_idx)%mandatory  (idx) = (tok(5)(1:1) == 'Y')
        all_hdr_maps(map_idx)%col_order  (idx) = idx

      case default
      end select
    end do

    ! Finished reading the mapping file

    close(IO_UNIT)

    keep_count = 0
    allocate(missing_cols(hdr_count))
    num_missing_cols = 0
    !-----------------------------------------------------------------------
    !! Remove mappings that have no columns defined and collect their tags
    !-----------------------------------------------------------------------
    do i = 1, hdr_count
      if (any(all_hdr_maps(i)%col_order /= 0)) then
        keep_count = keep_count + 1
      else
        num_missing_cols = num_missing_cols + 1
        missing_cols(num_missing_cols) = trim(all_hdr_maps(i)%name)
      end if
    end do

    ! Resize the missing tag list to the actual number hdr_found
    if (num_missing_cols < size(missing_cols)) then
      allocate(tmp_missing(num_missing_cols))
      tmp_missing = missing_cols(1:num_missing_cols)
      deallocate(missing_cols)
      call move_alloc(tmp_missing, missing_cols)
    end if

    ! Compact the mapping array so that only valid mappings remain
    if (keep_count < hdr_count) then
      allocate(filtered_hdr_maps(keep_count))
      keep_count = 0
      do i = 1, hdr_count
        if (any(all_hdr_maps(i)%col_order /= 0)) then
          keep_count = keep_count + 1
          filtered_hdr_maps(keep_count) = all_hdr_maps(i)
        end if
      end do
      deallocate(all_hdr_maps)
      call move_alloc(filtered_hdr_maps, all_hdr_maps)
      hdr_count = keep_count
    end if
    !-----------------------------------------------------------------------
    !! Set flag indicating mappings were loaded supper_casecessfully
    !-----------------------------------------------------------------------
    use_hdr_maps = (hdr_count > 0)
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
    integer                             :: num_tok             !! | Number of tokens in header_line
    integer                             :: i, j             !! | Loop counters
    integer                             :: idx              !! | Index for missing/extra columns
    integer                             :: hdr_index        !! | Index of matching map
    logical                             :: hdr_found            !! | Flag if mapping hdr_found
    type(header_map), pointer           :: hdr_map             !! | Pointer to current header map / used to see debug values
    type(header_map), pointer           :: all_hdr_maps_local(:)      !! | Pointer to all header maps / used to see debug values

    !-----------------------------------------------------------------------
    !! Look for a loaded mapping that matches the requested tag
    !-----------------------------------------------------------------------
    use_hdr_map = .false.
    hdr_index    = 0
    
    ! return if no mappings are loaded
    if (.not. use_hdr_maps) return
    
    ! use the pointer to all_hdr_maps, used to see debug values
    all_hdr_maps_local => all_hdr_maps

    hdr_found = .false.
    tag = search_tag
    
    ! check if input file tag exists, set hdr_index if and hdr_found flag
    do i = 1, hdr_count
      if (trim(all_hdr_maps_local(i)%name) == trim(tag)) then
        hdr_index = i
        hdr_found = .true.
        exit
      end if
    end do

    ! return if file tag is not hdr_found
    if (.not. hdr_found) return

    !-----------------------------------------------------------------------
    !! Prepare to check the header line against the selected mapping
    !-----------------------------------------------------------------------
    hdr_map => all_hdr_maps_local(hdr_index)
    use_hdr_map = .true.

    ! Tokenise the header line for comparison
    call split_by_multispace(header_line, headers, num_tok)

    allocate(matched(num_tok))
    matched = .false.

    hdr_map%is_correct = .true.
    !-----------------------------------------------------------------------
    !! Determine the column order by matching expected headers to the tokens
    !! set col_order to 0 for unmatched headers
    !-----------------------------------------------------------------------
    do i = 1, size(hdr_map%expected)
      hdr_map%col_order(i) = 0
      do j = 1, num_tok
        if (lowercase(trim(headers(j))) == lowercase(trim(hdr_map%expected(i)))) then
          hdr_map%col_order(i) = j
          matched(j) = .true.
          exit
        end if
      end do
      if (hdr_map%col_order(i) == 0) hdr_map%is_correct = .false.
    end do

    !-----------------------------------------------------------------------
    !! If any expected headers were not hdr_found record missing/extra fields
    !-----------------------------------------------------------------------
    if (.not. hdr_map%is_correct) then
      idx = count(hdr_map%col_order == 0)
      if (idx > 0) then
        allocate(hdr_map%missing(idx))
        idx = 0
        do i = 1, size(hdr_map%col_order)
          if (hdr_map%col_order(i) == 0) then
            idx = idx + 1
            hdr_map%missing(idx) = hdr_map%expected(i)
          end if
        end do
      end if

      idx = count(.not. matched)
      if (idx > 0) then
        allocate(hdr_map%extra(idx))
        idx = 0
        do j = 1, num_tok
          if (.not. matched(j)) then
            idx = idx + 1
            hdr_map%extra(idx) = headers(j)
          end if
        end do
      end if

    else
      ! Perfect match: initialise empty arrays and disable reordering
      if (.not. allocated(hdr_map%missing)) allocate(hdr_map%missing(0))
      if (.not. allocated(hdr_map%extra  )) allocate(hdr_map%extra  (0))
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
    type(header_map), pointer        :: hdr_map             !! | Pointer to current header map / used to see debug values
    character(len=2000), intent(out) :: out_line            !! | Output line, reordered as needed
    character(len=90), allocatable   :: tok(:)              !! | Array of tokens
    integer                          :: num_tok = 0            !! | Number of tokens
    integer                          :: i = 0               !! | Loop counter
    integer                          :: ios = 0             !! | I/O status

    !-----------------------------------------------------------------------
    !! Fetch the active map and read the raw line from the unit when needed
    !! Read a raw line from the unit and use the active mapping if requested
    !-----------------------------------------------------------------------
    out_line = ''
    hdr_map => active_hdr_map

    ! Read the line from the input unit only if the map is not correct
    if (.not. hdr_map%is_correct) then
      read(unit,'(A)',iostat=ios) line
      if (ios /= 0) return

      ! Tokenise the input line and rebuild it in the expected order
      call split_by_multispace(line, tok, num_tok)

      ! reorder the tokens according to the header map
      do i = 1, size(hdr_map%expected)
        if (hdr_map%col_order(i) /= 0 .and. hdr_map%col_order(i) <= num_tok) then
          out_line = trim(out_line)//' '//trim(tok(hdr_map%col_order(i)))
        else
          out_line = trim(out_line)//' '//trim(hdr_map%default_vals(i))
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
    type(header_map), pointer        :: hdr_map               !! | Pointer to active header map
    character(len=2000), intent(out) :: out_line            !! | Output line, reordered as needed
    character(len=90), allocatable   :: tok(:)              !! | Array of tokens
    integer                          :: num_tok = 0            !! | Number of tokens
    integer                          :: i = 0               !! | Loop counter
    integer                          :: ios = 0             !! | I/O status
    logical, intent(inout)           :: use_hdr_map         !! | Flag for header mapping
    
    !-----------------------------------------------------------------------
    !! Read a line from the input unit and reorder it according to the active header map
    !-----------------------------------------------------------------------

    out_line = ''
    hdr_map => active_hdr_map

    read(unit,'(A)',iostat=ios) line
    
    if (ios /= 0) return

    ! if no mapping is used, just return the line as is
    if (use_hdr_map) then
      if (hdr_map%is_correct) then
        out_line = line
      else
        ! Re-tokenise and reorder the line according to the mapping
        call split_by_multispace(line, tok, num_tok)
        do i = 1, size(hdr_map%expected)
          if (hdr_map%col_order(i) /= 0 .and. hdr_map%col_order(i) <= num_tok) then
            out_line = trim(out_line)//' '//trim(tok(hdr_map%col_order(i)))
          else
            out_line = trim(out_line)//' '//trim(hdr_map%default_vals(i))
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
    type(header_map), pointer        :: all_hdr_maps_local(:)         !! | Pointer to all header maps

    all_hdr_maps_local => all_hdr_maps
    ! if no mappings loaded, return
    if (.not. use_hdr_maps) return

    ! Inform the user and write details for any imperfect matches
    write(*,*) 'Alt mapping may have been used see Mapping information:'
    open (unit,file="use_hdr_map.fin")
    do ii = 1, hdr_count
      if (.not. all_hdr_maps_local(ii)%is_correct) then
        write(unit,*) trim(all_hdr_maps_local(ii)%name)
        if (size(all_hdr_maps_local(ii)%missing) > 0) then
          write(unit,*) 'Missing columns: ', (trim(all_hdr_maps_local(ii)%missing(i)), ' ', i=1, size(all_hdr_maps_local(ii)%missing))
        end if
        if (size(all_hdr_maps_local(ii)%extra) > 0) then
          write(unit,*) 'Extra columns: ', (trim(all_hdr_maps_local(ii)%extra(i)), ' ', i=1, size(all_hdr_maps_local(ii)%extra))
        end if
      end if
    end do
    close(unit)
  end subroutine write_mapping_info

end module input_read_module