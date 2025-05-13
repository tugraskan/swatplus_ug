!!> \brief Master mapping registry and input reader
!!>
!!> Provides routines to load header mappings once and apply them for data reordering
module input_read_module
  implicit none

  logical :: mapping_avail = .false.   !! mapping selected flag
    
    type :: map_meta
      character(len=30) :: tag   = ''    !! mapping identifier
      character(len=1)  :: used  = 'n'     !! user flag
      !character(len=60) :: ver   = ''
    end type map_meta

    type :: header_map
      type(map_meta)               :: meta           !! tag, used flag, version
      character(len=60), allocatable :: expected(:)  !! column headers desired order
      character(len=90), allocatable :: default_vals(:) !! defaults for missing columns
      integer, allocatable           :: col_order(:)
      logical                        :: is_correct     !! flag for perfect header match
      character(len=60), allocatable :: missing(:)
      character(len=90), allocatable :: extra(:)
    end type header_map

  type(header_map), allocatable, target :: hdr_map(:)
  type(header_map), pointer             :: hmap

contains

  !!> \brief Initialize mappings from default header file
  subroutine init_mappings
    implicit none
    character(len=*), parameter :: master_file = 'header_map.cio'
    integer :: unit, ios, hblocks, blk, eof, imax, num_columns, max_lines
    character(len=1024) :: line
    logical :: i_exist

    unit = 107
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
            read(unit,*, iostat=ios) hdr_map(blk)%meta%tag, hdr_map(blk)%meta%used
            read(unit,'(A)', iostat=ios) line
            call split_by_multispace(line, hdr_map(blk)%expected, num_columns)
            read(unit,'(A)', iostat=ios) line
            call split_by_multispace(line, hdr_map(blk)%default_vals, num_columns)
            allocate(hdr_map(blk)%col_order(num_columns))
        end do

      ! get column order
        
      ! cleanup and finish
        
        mapping_avail = .true.
      close(unit)
    endif
  end subroutine init_mappings
  
  subroutine fetch_header_map(mapping_avail, tag, hmap, pvar)
    implicit none

    !— Caller inputs:
    logical, intent(in)          :: mapping_avail
    character(len=*), intent(in) :: tag

    !— Outputs:
    type(header_map), pointer    :: hmap
    character(len=*), intent(inout) :: pvar

    !— Locals:
    integer :: i

    !— 1) Initialize pointer to “not found”
    hmap => null()

    !— 2) Only do work if mapping is enabled
    if (mapping_avail) then

      !— 2a) Search through your global hdr_map array
      do i = 1, size(hdr_map)
        if (trim(hdr_map(i)%meta%tag) == trim(tag)) then
          hmap => hdr_map(i)            ! point to the matching map
          if (hmap%meta%used == 'y') then
            pvar = '(A)'                ! switch to character read
          end if
          return                        ! we’re done
        end if
      end do

      !— 2b) If we fall out of the loop, we never found it
      stop 'No mapping found for '//trim(tag)

    end if
  end subroutine fetch_header_map
         

subroutine split_by_multispace(line, tokens, count)
        character(len=*), intent(in) :: line
        character(len=90), dimension(:), allocatable, intent(out) :: tokens
        integer, intent(out) :: count
        character(len=90) :: word
        integer :: len_line, start, end_pos

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

 

  subroutine check_headers(header_line, hmap)
      implicit none

      character(len=*), intent(in)    :: header_line
      type(header_map), intent(inout) :: hmap
      character(len=90), allocatable  :: headers(:)
      logical,        allocatable     :: matched(:)
      integer                          :: ntok, i, j, imax
      integer                          :: miss_cnt, extra_cnt

      !— 1) split the incoming header line
      call split_by_multispace(header_line, headers, ntok)
      imax    = size(hmap%expected)
      allocate(matched(ntok))
      matched = .false.

      !— 2) map *and* check order all in one pass
      hmap%is_correct = .true.
      do i = 1, imax
        hmap%col_order(i) = 0
        do j = 1, ntok
          if (trim(headers(j)) == trim(hmap%expected(i))) then
            hmap%col_order(i) = j
            matched(j)        = .true.
            exit
          end if
        end do

        !— if it wasn’t found at all, or was found at j /= i, mark false
        if (hmap%col_order(i) /= i) then
          hmap%is_correct = .false.
        end if
      end do

      !— 3) only build missing/extra when something’s wrong
      if (.not. hmap%is_correct) then
        !— missing

        miss_cnt = count(hmap%col_order == 0)
        allocate(hmap%missing(miss_cnt))
        miss_cnt = 0
        do i = 1, imax
          if (hmap%col_order(i) == 0) then
            miss_cnt = miss_cnt + 1
            hmap%missing(miss_cnt) = hmap%expected(i)
          end if
        end do

        !— extra

        extra_cnt = count(.not. matched)
        allocate(hmap%extra(extra_cnt))
        extra_cnt = 0
        do j = 1, ntok
          if (.not. matched(j)) then
            extra_cnt = extra_cnt + 1
            hmap%extra(extra_cnt) = trim(headers(j))
          end if
        end do

      else
        !— perfect match: allocate zero‐length so they're always safe

        allocate(hmap%missing(0))

        allocate(hmap%extra(0))
      end if

    end subroutine check_headers





  !!> \brief Retrieve mapping by tag
  function get_map_by_tag(tag) result(pm)
    implicit none
    character(len=*), intent(in) :: tag
    type(header_map), pointer :: pm
    integer :: i

    pm => null()
    do i = 1, size(hdr_map)
      if (trim(hdr_map(i)%meta%tag) == trim(tag)) then
        pm => hdr_map(i)
        return
      end if
    end do
  end function get_map_by_tag


  

  subroutine reorder_line(line, expected, default_vals, col_order, out_line)
      implicit none
      character(len=*), intent(in)     :: line
      character(len=*), intent(in)     :: expected(:), default_vals(:)
      integer,        intent(in)       :: col_order(:)
      character(len=*), intent(out)    :: out_line
      character(len=90), dimension(:), allocatable :: tok(:)
      integer                          :: ntok, i

      call split_by_multispace(line, tok, ntok)

      out_line = ''
      do i = 1, size(expected)
        if (col_order(i) /= 0 .and. col_order(i) <= ntok) then
          out_line = trim(out_line)//' '//trim(tok(col_order(i)))
        else
          out_line = trim(out_line)//' '//trim(default_vals(i))
        end if
      end do

      out_line = adjustl(out_line)
      deallocate(tok)
end subroutine reorder_line


end module input_read_module



