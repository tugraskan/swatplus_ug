# Refactoring Example: hyd_read_connect with Table Reader (As-Is)

This example shows how to refactor the existing `hyd_read_connect` subroutine using the fork's `table_reader` method **exactly as provided** (without helper functions).

## Original Code (Current Implementation)

```fortran
subroutine hyd_read_connect(con_file, obtyp, nspu1, nspu, nhyds, ndsave)
  use hydrograph_module
  use input_read_module  ! Uses Header Mapping
  
  character (len=80) :: titldum = ""
  character (len=2000) :: header = ""
  integer :: eof = 0
  integer :: imax = 0
  logical :: use_hdr_map = .false.
  character(len=2000) :: fmt_line = ""
  
  ! Open file and read
  open (107,file=con_file)
  read (107,*,iostat=eof) titldum
  read (107,'(A)',iostat=eof) header
  call check_headers_by_tag(con_file, header, use_hdr_map)
  
  do i = ob1, ob2
    ! Many allocations...
    
    ! Read data with header mapping
    if (use_hdr_map) then
      call reorder_line(107, fmt_line)
      read(fmt_line,*,iostat=eof) ob(i)%num, ob(i)%name, ob(i)%gis_id, &
        ob(i)%area_ha, ob(i)%lat, ob(i)%long, ob(i)%elev, ob(i)%props, &
        ob(i)%wst_c, ob(i)%constit, ob(i)%props2, ob(i)%ruleset, ob(i)%src_tot
    else
      read (107,*,iostat=eof) ob(i)%num, ob(i)%name, ob(i)%gis_id, &
        ob(i)%area_ha, ob(i)%lat, ob(i)%long, ob(i)%elev, ob(i)%props, &
        ob(i)%wst_c, ob(i)%constit, ob(i)%props2, ob(i)%ruleset, ob(i)%src_tot
    end if
    
    ! Handle outputs...
  end do
  
  close (107)
end subroutine
```

---

## Refactored Code (Using Table Reader As-Is)

```fortran
subroutine hyd_read_connect(con_file, obtyp, nspu1, nspu, nhyds, ndsave)
  use hydrograph_module
  use utils  ! For table_reader from fork
  
  ! Table reader instance
  type(table_reader) :: tblr
  
  ! Column indices (must be found manually)
  integer :: col_num, col_name, col_gis_id, col_area, col_lat, col_long
  integer :: col_elev, col_props, col_wst_c, col_constit, col_props2
  integer :: col_ruleset, col_src_tot
  
  integer :: eof = 0
  integer :: imax = 0
  integer :: i, j
  logical :: i_exist
  
  ! Check if file exists
  inquire (file=con_file, exist=i_exist)
  if (.not. i_exist) return
  
  ! Initialize table reader
  call tblr%init(unit=107, file_name=con_file)
  
  ! Count data rows for allocation (optional but recommended)
  imax = tblr%get_num_data_lines()
  rewind(107)
  
  ! Read header row
  call tblr%get_header_columns(eof)
  if (eof /= 0) then
    close(107)
    return
  end if
  
  !------------------------------------------------------------------
  ! FIND COLUMN INDICES - Manual do-loop for EACH column
  ! (This is the "as-is" approach from the fork)
  !------------------------------------------------------------------
  
  ! Find 'num' column
  col_num = 0
  do i = 1, tblr%ncols
    if (trim(tblr%header_cols(i)) == 'num') then
      col_num = i
      exit
    endif
  end do
  
  ! Find 'name' column
  col_name = 0
  do i = 1, tblr%ncols
    if (trim(tblr%header_cols(i)) == 'name') then
      col_name = i
      exit
    endif
  end do
  
  ! Find 'gis_id' column
  col_gis_id = 0
  do i = 1, tblr%ncols
    if (trim(tblr%header_cols(i)) == 'gis_id') then
      col_gis_id = i
      exit
    endif
  end do
  
  ! Find 'area' column
  col_area = 0
  do i = 1, tblr%ncols
    if (trim(tblr%header_cols(i)) == 'area') then
      col_area = i
      exit
    endif
  end do
  
  ! Find 'lat' column
  col_lat = 0
  do i = 1, tblr%ncols
    if (trim(tblr%header_cols(i)) == 'lat') then
      col_lat = i
      exit
    endif
  end do
  
  ! Find 'lon' column
  col_long = 0
  do i = 1, tblr%ncols
    if (trim(tblr%header_cols(i)) == 'lon') then
      col_long = i
      exit
    endif
  end do
  
  ! Find 'elev' column
  col_elev = 0
  do i = 1, tblr%ncols
    if (trim(tblr%header_cols(i)) == 'elev') then
      col_elev = i
      exit
    endif
  end do
  
  ! Find 'hru' column (or whatever props is)
  col_props = 0
  do i = 1, tblr%ncols
    if (trim(tblr%header_cols(i)) == 'hru') then
      col_props = i
      exit
    endif
  end do
  
  ! Find 'wst' column
  col_wst_c = 0
  do i = 1, tblr%ncols
    if (trim(tblr%header_cols(i)) == 'wst') then
      col_wst_c = i
      exit
    endif
  end do
  
  ! Find 'cst' column
  col_constit = 0
  do i = 1, tblr%ncols
    if (trim(tblr%header_cols(i)) == 'cst') then
      col_constit = i
      exit
    endif
  end do
  
  ! Find 'ovfl' column (or props2)
  col_props2 = 0
  do i = 1, tblr%ncols
    if (trim(tblr%header_cols(i)) == 'ovfl') then
      col_props2 = i
      exit
    endif
  end do
  
  ! Find 'rule' column
  col_ruleset = 0
  do i = 1, tblr%ncols
    if (trim(tblr%header_cols(i)) == 'rule') then
      col_ruleset = i
      exit
    endif
  end do
  
  ! Find 'out_tot' column
  col_src_tot = 0
  do i = 1, tblr%ncols
    if (trim(tblr%header_cols(i)) == 'out_tot') then
      col_src_tot = i
      exit
    endif
  end do
  
  !------------------------------------------------------------------
  ! END OF COLUMN FINDING (13 columns = ~78 lines of code!)
  !------------------------------------------------------------------
  
  ! Process each spatial unit
  if (nspu > 0) then
    ob1 = nspu1
    ob2 = nspu1 + nspu - 1
    isp_ob = 0
    
    do i = ob1, ob2
      ! Setup object type and allocations
      ob(i)%typ = obtyp
      ob(i)%nhyds = nhyds
      isp_ob = isp_ob + 1
      ob(i)%sp_ob_no = isp_ob
      
      ! All the allocations (same as original)...
      allocate (ob(i)%hd(nhyds))
      allocate (ob(i)%hd_aa(nhyds))
      ! ... etc ...
      
      ! Read data row using table reader
      call tblr%get_row_fields(eof)
      if (eof /= 0) exit
      
      ! Parse each field by column index
      if (col_num > 0) then
        read(tblr%row_field(col_num), *) ob(i)%num
      end if
      
      if (col_name > 0) then
        read(tblr%row_field(col_name), *) ob(i)%name
      end if
      
      if (col_gis_id > 0) then
        read(tblr%row_field(col_gis_id), *) ob(i)%gis_id
      end if
      
      if (col_area > 0) then
        read(tblr%row_field(col_area), *) ob(i)%area_ha
      end if
      
      if (col_lat > 0) then
        read(tblr%row_field(col_lat), *) ob(i)%lat
      end if
      
      if (col_long > 0) then
        read(tblr%row_field(col_long), *) ob(i)%long
      end if
      
      if (col_elev > 0) then
        read(tblr%row_field(col_elev), *) ob(i)%elev
      end if
      
      if (col_props > 0) then
        read(tblr%row_field(col_props), *) ob(i)%props
      end if
      
      if (col_wst_c > 0) then
        read(tblr%row_field(col_wst_c), *) ob(i)%wst_c
      end if
      
      if (col_constit > 0) then
        read(tblr%row_field(col_constit), *) ob(i)%constit
      end if
      
      if (col_props2 > 0) then
        read(tblr%row_field(col_props2), *) ob(i)%props2
      end if
      
      if (col_ruleset > 0) then
        read(tblr%row_field(col_ruleset), *) ob(i)%ruleset
      end if
      
      if (col_src_tot > 0) then
        read(tblr%row_field(col_src_tot), *) ob(i)%src_tot
      end if
      
      ! Initialize area calculation
      if (ob(i)%typ == "hru" .or. ob(i)%typ == "ru" .or. ob(i)%typ == "recall") then
        ob(i)%area_ha_calc = ob(i)%area_ha
      else
        ob(i)%area_ha_calc = 0.
      end if
      
      ! Handle output connections if src_tot > 0
      if (ob(i)%src_tot > 0) then
        nout = ob(i)%src_tot
        allocate (ob(i)%obj_out(nout), source = 0)
        allocate (ob(i)%obtyp_out(nout))
        ! ... more allocations ...
        
        ! Need to re-read the row to get output connection data
        ! This is tricky with table_reader - need to track position
        ! For now, could store row in temp variable or handle differently
        
      else
        allocate (ob(i)%obtypno_out(1), source = 0)
        ob(i)%obtypno_out(1) = 0
      end if
      
      ! More allocations...
      allocate (ob(i)%fdc_ll(366))
      allocate (ob(i)%fdc_lla(time%nbyr))
      allocate (ob(i)%fdc%yr(time%nbyr))
      
    end do
  end if
  
  ! Crosswalk weather station (same as original)
  do i = ob1, ob2
    call search (wst_n, db_mx%wst, ob(i)%wst_c, ob(i)%wst)
  end do
  
  close (107)
  
end subroutine hyd_read_connect
```

---

## Code Comparison Summary

### Lines of Code for Column Finding

| Approach | Lines | Notes |
|----------|-------|-------|
| **Original (Header Mapping)** | 0 | All handled in config file |
| **Table Reader (As-Is)** | ~78 | 6 lines × 13 columns |

### What Changed

1. **Replaced**: `use input_read_module` with `use utils`

2. **Added**: `type(table_reader) :: tblr`

3. **Replaced**: Header mapping calls with table_reader calls:
   ```fortran
   ! Before
   call check_headers_by_tag(con_file, header, use_hdr_map)
   
   ! After  
   call tblr%init(unit=107, file_name=con_file)
   call tblr%get_header_columns(eof)
   ```

4. **Added**: Manual column finding (78 lines for 13 columns)

5. **Replaced**: Data reading:
   ```fortran
   ! Before
   read (107,*) ob(i)%num, ob(i)%name, ...
   
   ! After
   call tblr%get_row_fields(eof)
   read(tblr%row_field(col_num), *) ob(i)%num
   read(tblr%row_field(col_name), *) ob(i)%name
   ...
   ```

---

## Key Observations

### What You Gain

1. ✅ **Comment support**: Handles `#` comments in data files
2. ✅ **Column validation**: Automatically checks column count
3. ✅ **Empty line handling**: Skips blank lines
4. ✅ **Case-insensitive headers**: Column names normalized
5. ✅ **Better error messages**: Row/column context in warnings

### What You Lose

1. ❌ **Code brevity**: +78 lines for column finding
2. ❌ **Column reordering**: Must match exact order (or find manually)
3. ❌ **Default values**: No automatic filling of missing columns
4. ❌ **Configuration flexibility**: Everything hardcoded

### The Reality

**YES**, you are correct - using the fork's table_reader **as-is** requires:

- **~6 lines per column** for manual do-loop finding
- **13 columns = 78 lines** of repetitive code
- **50 columns = 300 lines** of repetitive code

This is why the `column_mapping_patterns.md` document suggests creating a helper function to wrap this repetitive pattern.

---

## Recommended Hybrid Approach

If you want to keep your Header Mapping flexibility but need Table Reader features:

```fortran
! Keep using Header Mapping for complex files
if (use_hdr_map) then
  call reorder_line(107, fmt_line)
  read(fmt_line,*) ob(i)%num, ob(i)%name, ...
  
! Use Table Reader for new/simple files  
else
  call tblr%get_row_fields(eof)
  read(tblr%row_field(col_num), *) ob(i)%num
  read(tblr%row_field(col_name), *) ob(i)%name
  ...
end if
```

Or better yet: **Add the helper function once** and use it everywhere:

```fortran
! Add this once to utils.f90
function find_col(tblr, name) result(idx)
  type(table_reader) :: tblr
  character(len=*) :: name
  integer :: idx, i
  idx = 0
  do i = 1, tblr%ncols
    if (trim(tblr%header_cols(i)) == trim(name)) then
      idx = i
      exit
    endif
  end do
end function

! Then use everywhere (1 line per column instead of 6)
col_num = find_col(tblr, 'num')
col_name = find_col(tblr, 'name')
col_area = find_col(tblr, 'area')
```

This reduces 78 lines to 13 lines for the same functionality.
