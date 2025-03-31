module xwalk_module
  implicit none

  ! Define the crosswalk type.
  type :: xwalk_entry
     character(len=32) :: field_name       ! e.g., "NAME", "GW_FLO", etc.
     integer           :: col_pos           ! Column position in the data record
     character(len=8)  :: data_type         ! Expected data type (e.g., "REAL", "CHAR")
     character(len=16) :: default_value     ! Default value (stored as text for conversion)
  end type xwalk_entry

end module xwalk_module
