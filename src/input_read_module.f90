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
      character(len=1)          :: used = 'n'    !! | Usage flag for the header map ('y' or 'n')
      character(len=STR_LEN), allocatable   :: expected(:)  !! | Expected column names in the header map
      character(len=STR_LEN), allocatable   :: default_vals(:)  !! | Default values for each expected column
      character(len=STR_LEN), allocatable   :: missing(:)   !! | Missing columns in the header map
      character(len=STR_LEN), allocatable   :: extra(:)     !! | Extra columns in the header map
      logical,             allocatable        :: mandatory(:) !! | Mandatory flags for each expected column
      logical                                 :: is_correct   !! | Flag to indicate if the header map is a perfect match
      integer,             allocatable        :: col_order(:) !! | Order of columns in the header map

      
  end type header_map
  
  type(header_map), allocatable, target  :: all_maps(:) !! Array of header maps
  type(header_map), pointer              :: active_map  !! | Pointer to the active header map

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

  !==================[ Split_by_Multispace ]=================!
  subroutine split_by_Multispace(line, tokens, count)
    character(len=*), intent(in)         :: line            !! | Line to split
    character(len=STR_LEN), allocatable, intent(out) :: tokens(:) !! | Array of tokens
    integer, intent(out)                 :: count       !! | Number of tokens found

    character(len=MAX_LINE_LEN) :: buffer       !! | Temparary buffer for the line
    character(len=STR_LEN)    :: word         !! | Current word being built
    logical :: in_quotes = .false. !! | Flag to indicate if we are inside quotes        
    integer :: len_line          !! | Length of the line
    integer :: i    !! | Loop counter

    ! Allocate tokens array with a maximum size
    allocate(tokens(1000))
    buffer = line
    word = ''; count = 0
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

!==================[ Load_header_mappings ]=======================!
! This subroutine reads and parses a header mapping configuration
! The file is expected to have two sections:
! 1. Metadata: Defines each mapping with its identifier, usage flag, and column count.
! 2. Column Mappings: Specifies the expected headers, default values, and mandatory flags.
subroutine load_header_mappings()
  implicit none
  
  ! Local Variables
  character(len=MAX_LINE_LEN) :: line         !!    | Line buffer for reading the file
  character(len=WORD_LEN), allocatable :: words(:)  !!  | Array of words extracted from the line
  character(len=WORD_LEN) :: map_id           !!    | Identifier for the header map
  character(len=1) :: usage_flag              !!    | Usage flag ('y' for used, 'n' for unused)
  character(len=WORD_LEN) :: lower_flag       !!    | Lowercase flag for mandatory columns
  integer :: iostat, num_fields               !!    | I/O status and number of fields in the line
  integer :: num_cols                         !!    | Number of columns in the current mapping
  integer :: map_index                        !!    | Index for the current mapping
  integer :: col_index                        !!    | Index for the current column
  integer :: i  !! | Loop counter
  logical :: in_column_section = .false.      !!    | Flag to indicate if parsing column mappings


  ! Reset state
  if (allocated(all_maps)) deallocate(all_maps)
  map_count = 0
  mapping_loaded = .false.

  ! Check if the header map file exists
  inquire(file='header_map.cio', exist=iostat)
  if (iostat == 0) return

  ! Open the header map file
  open(unit=IO_UNIT, file='header_map.cio', status='old', action='read', iostat=iostat)
  if (iostat /= 0) return

  ! Read the file line by line
  do
    read(IO_UNIT, '(A)', iostat=iostat) line
    if (iostat /= 0) exit

    ! Skip comments and empty lines
    if (line(1:1) == '#' .or. adjustl(line) == '') cycle

    ! Split the line into words
    call split_by_multispace(line, words, num_fields)

    ! Check for transition to column mappings section
    if (.not. in_column_section) then
      if (num_fields >= 2 .and. trim(words(1)) == 'file' .and. trim(words(2)) == 'idx') then
        in_column_section = .true.
        cycle
      end if

      ! Process metadata line
      if (num_fields == 3 .and. trim(words(1)) /= 'file') then
        map_id = trim(words(1))
        usage_flag = words(2)(1:1)
        read(words(3), *) num_cols

        ! Allocate or expand all_maps array
        map_count = map_count + 1
        if (map_count == 1) then
          allocate(all_maps(1))
        else
          allocate(all_maps(map_count))
        end if

        ! Initialize the current header map
        all_maps(map_count)%meta%tag = map_id
        all_maps(map_count)%meta%used = usage_flag
        allocate(all_maps(map_count)%expected(num_cols))
        allocate(all_maps(map_count)%default_vals(num_cols))
        allocate(all_maps(map_count)%mandatory(num_cols))
        allocate(all_maps(map_count)%col_order(num_cols))
        all_maps(map_count)%col_order = [(j, j = 1, num_cols)]
      end if

    else
      ! Process column mapping line
      if (num_fields < 4) cycle

      map_id = trim(words(1))
      map_index = find_map_by_tag(map_id)
      if (map_index == 0 .or. all_maps(map_index)%meta%used /= 'y') cycle

      read(words(2), *) col_index
      all_maps(map_index)%expected(col_index)     = trim(words(3))
      all_maps(map_index)%default_vals(col_index) = trim(words(4))

      if (num_fields >= 5) then
        lower_flag = lowercase(words(5))
        all_maps(map_index)%mandatory(col_index) = (lower_flag(1:1) == 'y')
      else
        all_maps(map_index)%mandatory(col_index) = .false.
      end if
    end if
  end do

  close(IO_UNIT)

  ! Finalize mapping_loaded flag
  mapping_loaded = (map_count > 0)
end subroutine load_header_mappings



  !==================[ Helper: Find Map by Tag ]=====================!
  integer function find_map_by_tag(tag)
    character(len=*), intent(in) :: tag
    integer :: i
    find_map_by_tag = 0
    do i = 1, map_count
      if (trim(all_maps(i)%tag) == trim(tag)) then
        find_map_by_tag = i
        return
      end if
    end do
  end function find_map_by_tag




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
        write(unit,*) trim(hdr_map2(ii)%tag)
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