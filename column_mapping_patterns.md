# Column Mapping Patterns: Avoiding Case Statement Explosion

## The Problem

When using the Table Reader or optimized Header Mapping methods, you might worry about needing code like this for every file:

```fortran
! BAD: Manual case statement for every column (hundreds of lines!)
do i = 1, tblr%ncols
  select case (trim(tblr%header_cols(i)))
    case ('id')
      id_col = i
    case ('name')
      name_col = i
    case ('gis_id')
      gis_id_col = i
    case ('area')
      area_col = i
    ! ... potentially hundreds more cases!
  end select
end do
```

**This is NOT necessary!** There are much better patterns.

---

## Solution 1: Helper Function (Recommended for Table Reader)

Create a simple lookup function that eliminates repetitive code:

```fortran
! In table_reader type or helper module
function find_column(tblr, col_name) result(col_idx)
  type(table_reader), intent(in) :: tblr
  character(len=*), intent(in)   :: col_name
  integer                        :: col_idx
  integer                        :: i
  character(len=MAX_NAME_LEN)    :: search_name
  
  search_name = to_lower(trim(col_name))
  col_idx = 0
  
  do i = 1, tblr%ncols
    if (trim(tblr%header_cols(i)) == search_name) then
      col_idx = i
      return
    endif
  end do
end function find_column
```

**Usage** (clean and concise):
```fortran
! Initialize
call tblr%init(unit=101, file_name='hru.con')
call tblr%get_header_columns(eof)

! Find columns - only 1 line per column!
id_col = find_column(tblr, 'ID')
name_col = find_column(tblr, 'NAME')
area_col = find_column(tblr, 'AREA')
gis_id_col = find_column(tblr, 'GIS_ID')

! Read data
do i = 1, imax
  call tblr%get_row_fields(eof)
  if (id_col > 0) read(tblr%row_field(id_col), *) id
  if (area_col > 0) read(tblr%row_field(area_col), *) area
end do
```

**Lines of code for 50 columns**: ~50 lines (vs hundreds with case statements)

---

## Solution 2: Column Name Array (Most Compact)

Use an array to map column names to indices automatically:

```fortran
! Define expected columns as an array
character(len=20), parameter :: expected_cols(10) = [ &
  'ID      ', 'NAME    ', 'GIS_ID  ', 'AREA    ', 'LAT     ', &
  'LON     ', 'ELEV    ', 'HRU     ', 'WST     ', 'CST     ' ]

integer :: col_map(10)  ! Maps expected_cols index to actual column index

! One-time setup: map all columns
do i = 1, size(expected_cols)
  col_map(i) = find_column(tblr, expected_cols(i))
end do

! Constants for readability
integer, parameter :: COL_ID = 1, COL_NAME = 2, COL_AREA = 4

! Read data with clean access
do i = 1, imax
  call tblr%get_row_fields(eof)
  read(tblr%row_field(col_map(COL_ID)), *) id
  read(tblr%row_field(col_map(COL_AREA)), *) area
end do
```

**Lines of code for 50 columns**: ~55 lines (declaration + constants)

---

## Solution 3: Hash Map/Dictionary (Advanced)

For very large column counts, use a hash map:

```fortran
! In a module
type :: column_map_entry
  character(len=MAX_NAME_LEN) :: name
  integer                     :: index
end type

type :: column_map
  type(column_map_entry), allocatable :: entries(:)
  integer                             :: count = 0
contains
  procedure :: add_column
  procedure :: get_index
end type

subroutine add_column(self, name, idx)
  class(column_map) :: self
  character(len=*) :: name
  integer :: idx
  
  self%count = self%count + 1
  if (.not. allocated(self%entries)) then
    allocate(self%entries(100))  ! Initial size
  else if (self%count > size(self%entries)) then
    ! Grow array (not shown for brevity)
  end if
  
  self%entries(self%count)%name = to_lower(trim(name))
  self%entries(self%count)%index = idx
end subroutine

function get_index(self, name) result(idx)
  class(column_map) :: self
  character(len=*) :: name
  integer :: idx, i
  character(len=MAX_NAME_LEN) :: search_name
  
  search_name = to_lower(trim(name))
  idx = 0
  
  do i = 1, self%count
    if (self%entries(i)%name == search_name) then
      idx = self%entries(i)%index
      return
    endif
  end do
end function

! Usage
type(column_map) :: colmap

! Build map once
do i = 1, tblr%ncols
  call colmap%add_column(tblr%header_cols(i), i)
end do

! Use throughout program
id_idx = colmap%get_index('ID')
read(tblr%row_field(id_idx), *) id
```

---

## Solution 4: Configuration-Driven (Zero Code Per Column!)

With Header Mapping, you already have zero code per column because the config file handles it:

**header_map.cio**:
```
[hru.con]
 1   ID         -999      Y
 2   NAME       NA        N
 3   GIS_ID     -99       N
 4   AREA       -99.9     N
 # ... all 50+ columns defined here
```

**Code** (same regardless of column count):
```fortran
call header_read_fast(unit, use_map, fields, nfields)
! fields(1) = ID, fields(2) = NAME, etc. automatically!
read(fields(1), *) id
read(fields(4), *) area
```

**Lines of code for 50 columns**: 0 lines in code, all in config file

---

## Comparison: Lines of Code Required

| Method | Columns=10 | Columns=50 | Columns=100 | Notes |
|--------|-----------|-----------|-------------|-------|
| **Case Statement** | ~40 lines | ~200 lines | ~400 lines | ❌ Scales horribly |
| **Helper Function** | ~10 lines | ~50 lines | ~100 lines | ✅ Linear scaling |
| **Column Array** | ~15 lines | ~60 lines | ~110 lines | ✅ Good for known columns |
| **Hash Map** | ~10 lines | ~10 lines | ~10 lines | ✅ Constant code |
| **Header Mapping Config** | ~0 lines | ~0 lines | ~0 lines | ✅ Best: all in config |

---

## Real-World Example: Reading HRU File (17 columns)

### ❌ Bad Approach (Case Statements)
```fortran
! 70+ lines of repetitive code
integer :: id_col, name_col, gis_col, area_col, lat_col, lon_col, elev_col
integer :: hru_col, wst_col, cst_col, ovfl_col, rule_col, out_col
integer :: obj1_col, id1_col, hyd1_col, frac1_col

do i = 1, tblr%ncols
  select case (trim(tblr%header_cols(i)))
    case ('id')
      id_col = i
    case ('name')
      name_col = i
    case ('gis_id')
      gis_col = i
    ! ... 14 more cases ...
  end select
end do
```

### ✅ Good Approach (Helper Function)
```fortran
! 17 lines of clean code
id_col = find_column(tblr, 'ID')
name_col = find_column(tblr, 'NAME')
gis_col = find_column(tblr, 'GIS_ID')
area_col = find_column(tblr, 'AREA')
lat_col = find_column(tblr, 'LAT')
lon_col = find_column(tblr, 'LON')
elev_col = find_column(tblr, 'ELEV')
hru_col = find_column(tblr, 'HRU')
wst_col = find_column(tblr, 'WST')
cst_col = find_column(tblr, 'CST')
ovfl_col = find_column(tblr, 'OVFL')
rule_col = find_column(tblr, 'RULE')
out_col = find_column(tblr, 'OUT_TOT')
obj1_col = find_column(tblr, 'obj_typ1')
id1_col = find_column(tblr, 'obj_id1')
hyd1_col = find_column(tblr, 'hyd_typ1')
frac1_col = find_column(tblr, 'frac1')
```

### ✅ Best Approach (Header Mapping)
```fortran
! 0 lines - all in header_map.cio
call header_read_fast(unit, use_map, fields, nfields)
read(fields(1), *) id
read(fields(2), *) name
! Column positions defined in config file
```

---

## Recommended Implementation Strategy

### For Table Reader Method

Add this to `utils.f90`:

```fortran
module utils
  ! ... existing code ...
  
contains
  
  ! ... existing functions ...
  
  !> Find column index by name (case-insensitive)
  function find_column_idx(tblr, col_name) result(idx)
    type(table_reader), intent(in) :: tblr
    character(len=*), intent(in)   :: col_name
    integer                        :: idx
    integer                        :: i
    character(len=MAX_NAME_LEN)    :: search_name
    
    search_name = to_lower(trim(col_name))
    idx = 0
    
    do i = 1, tblr%ncols
      if (trim(tblr%header_cols(i)) == search_name) then
        idx = i
        return
      endif
    end do
    
    ! Optionally warn if column not found
    if (idx == 0) then
      print *, 'Warning: Column "', trim(col_name), '" not found'
    endif
  end function find_column_idx
  
end module utils
```

**Usage in every file reader**:
```fortran
use utils

type(table_reader) :: tblr
integer :: id_col, name_col, area_col

call tblr%init(unit=101, file_name='data.txt')
call tblr%get_header_columns(eof)

! One line per column - simple and clear
id_col = find_column_idx(tblr, 'ID')
name_col = find_column_idx(tblr, 'NAME')  
area_col = find_column_idx(tblr, 'AREA')

do i = 1, imax
  call tblr%get_row_fields(eof)
  if (id_col > 0) read(tblr%row_field(id_col), *) id
  if (name_col > 0) read(tblr%row_field(name_col), *) name
  if (area_col > 0) read(tblr%row_field(area_col), *) area
end do
```

### For Header Mapping Method

**No code changes needed** - just define columns in `header_map.cio`:

```
[hru.con]
 1   ID         -999      Y
 2   NAME       NA        N
 3   AREA       -99.9     N
 # ... more columns ...
```

---

## Performance Considerations

**Helper Function Overhead**:
- Called once per column at initialization
- Linear search through ~10-100 columns
- Total cost: ~1-10 microseconds
- Negligible compared to file I/O (milliseconds)

**Optimization** (if needed for 1000+ columns):
```fortran
! Sort header_cols during initialization
! Use binary search instead of linear search
! Or use hash map for O(1) lookup
```

---

## Migration Path

### From Ad Hoc to Table Reader

**Before** (scattered logic):
```fortran
read(unit, *) titldum
read(unit, *) id, name, area  ! Hard-coded positions
```

**After** (with helper function):
```fortran
call tblr%init(unit, file_name)
call tblr%get_header_columns(eof)

id_col = find_column_idx(tblr, 'ID')      ! 1 line per column
name_col = find_column_idx(tblr, 'NAME')
area_col = find_column_idx(tblr, 'AREA')

do i = 1, imax
  call tblr%get_row_fields(eof)
  read(tblr%row_field(id_col), *) id      ! Use column indices
  read(tblr%row_field(name_col), *) name
  read(tblr%row_field(area_col), *) area
end do
```

**Code growth**: ~3 lines + 1 line per column (vs case statement: 4 lines per column)

### From Ad Hoc to Header Mapping

**Before**:
```fortran
read(unit, *) titldum  
read(unit, *) id, name, area
```

**After**:
```fortran
! Add to header_map.cio once
! Then code is the same for all files:
call header_read_fast(unit, use_map, fields, nfields)
read(fields(1), *) id
read(fields(2), *) name
read(fields(3), *) area
```

**Code growth**: 0 lines (all in config)

---

## Conclusion

**You do NOT need case statements for every column!**

### Best Practices:

1. **Table Reader**: Use `find_column_idx()` helper function
   - Adds only 1 line per column
   - Clean, readable, maintainable
   - Minimal code growth

2. **Header Mapping**: Use configuration file
   - Adds 0 lines of code per column
   - All metadata in config
   - Easiest to maintain

3. **Never use case statements** for column mapping
   - Too verbose (4× more lines)
   - Hard to maintain
   - Error-prone

### Scaling Summary:

| Columns | Case Stmt | Helper Func | Config File |
|---------|-----------|-------------|-------------|
| 10 | 40 lines | 10 lines | 0 lines |
| 50 | 200 lines | 50 lines | 0 lines |
| 100 | 400 lines | 100 lines | 0 lines |
| 500 | 2000 lines | 500 lines | 0 lines |

The helper function approach scales linearly and remains manageable. The config-based approach scales perfectly (zero code growth).

**Neither approach requires hundreds of case statements!**
