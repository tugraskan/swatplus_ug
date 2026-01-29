# Author: fgeter
# Purpose of the code is to write a fortran subroutine that 
# reads a simple swatplus table.
# The user needs to provide the necessary input
# specified after "begin user provided input"
#
# See doc/table_read_generator.md for detailed documentation
# on using module parameters for required columns.

# begin user provided input

subroutine_name = "cons_prac_read"    # Name of the swatplus subroutine to create
module_name = "landuse_data_module"   # path to the module that contains the derived type
type_name = "conservation_practice_table" # Name of the derived type to read from the module.
cust_hdr_string = "name PFAC sl_len_mx" # If this string empty, the module type def 
                                      # variables will be used as column headers.
                                      # If not an empty string, the order and number 
                                      # of the headers in the string must match 
                                      # the order and number of variables in the 
                                      # module type def.   
req_cols_param = "cons_prac_req_cols" # Name of the parameter in module_name that
                                      # contains the required column headers.
                                      # If empty string, the cust_hdr_string will
                                      # be hard-coded in the generated subroutine.
                                      # If provided, the parameter must be defined
                                      # in the module specified by module_name.
col_is_string = ["name"]              # list of header columns that are of
                                      # type character strings in module data type 
                                      # separated by a comma (",")
input_file_name = "in_lum%cons_prac_lum" # file name of the table to read in
allocation_name = "cons_prac"         # Name of the array to allocate
dtype = "lu_tbl"                      # Name of the derived type for table reader 
db_max_name = "cons_prac"             # enter an empty string if not applicable

use_modules = [                       # The modules the subroutine will need to
    "input_file_module",              # use. 
    "maximum_data_module",
    "landuse_data_module",
    "utils"
]
# end user provided input
def get_type_vars(module_name, type_name):
    mod_file = module_name + ".f90"
    with open(mod_file, "r") as f:
        var_str = ""
        begin_type = False
        for line in f.readlines():
            line = line.strip().split("!")[0].strip() # remove comments
            if begin_type == True:
                if "end type" in line or "endtype" in line:
                    break
                var = line.split("::")[1].strip().split("=")[0].strip()
                var_str = var_str + " " +var
            else:
                if type_name in line and "type" in line:
                    begin_type = True
                    continue
    return var_str


type_vars = get_type_vars(module_name, type_name).split()
if cust_hdr_string == "":
    header_cols = type_vars
else:
    header_cols = cust_hdr_string.split()

sub_file_name = subroutine_name + ".f90"
with open(sub_file_name, "w") as f:
    f.write(f"subroutine {subroutine_name}\n\n")
    for m in use_modules:
        f.write("use " + m + "\n")
    f.write("\n")
    f.write("implicit none\n\n")
    f.write("integer :: eof = 0     ! end of file\n")
    f.write("integer :: imax = 0    ! number of elements to be allocated\n")
    f.write("integer :: i\n\n")
    f.write(f"type(table_reader) :: {dtype}\n")
    f.write(f"call {dtype}%init(unit=107, file_name={input_file_name}) \n\n")
    f.write(f"if ({dtype}%file_exists .eqv. .false.) then\n")
    f.write(f"  allocate ({allocation_name}(0:0))\n")
    f.write("else\n")
    f.write(f"  imax = {dtype}%get_num_data_lines()  !get number of valid data lines\n")
    f.write(f"  allocate ({allocation_name}(0:imax))\n\n")
    f.write(f"  if (imax /= 0) then\n\n")
    f.write( "    ! optional call to set minimum required columns\n")
    # Use module parameter if provided, otherwise hard-code the string
    if req_cols_param != "":
        f.write(f"    call {dtype}%min_req_cols({req_cols_param})\n\n")
    else:
        f.write(f"    call {dtype}%min_req_cols(\"{cust_hdr_string}\")\n\n")
    f.write( "    ! get the column headers\n")
    f.write(f"    call {dtype}%get_header_columns(eof)\n\n")
    f.write( "    if (eof == 0) then   ! proceed if not at the end of the file.\n")
    f.write( "      do\n")
    f.write( "        ! get a row of data\n")
    f.write(f"        call {dtype}%get_row_fields(eof)\n")
    f.write( "        if (eof /= 0) exit  ! exit if at the end of the file.\n\n")
    f.write( "        ! Assign data to cons_prac fields based on header column names\n")
    f.write(f"        do i = 1, {dtype}%get_col_count()\n")
    f.write(f"          select case ({dtype}%header_cols(i))\n")
    for col in range(len(header_cols)):
        col_name = header_cols[col]
        var_name = type_vars[col]

        if header_cols[col] in col_is_string:
            f.write(f"            case (\"{col_name}\")\n")
            f.write(f"              {allocation_name}({dtype}%get_row_idx())%{var_name} = trim({dtype}%row_field(i))\n")
        else:
            f.write(f"            case (\"{col_name}\")\n")
            f.write(f"              read({dtype}%row_field(i), *) {allocation_name}({dtype}%get_row_idx())%{var_name}\n")
    f.write( "            case default\n")
    f.write( "              ! Output warning for unknown column header\n")
    f.write(f"              call {dtype}%output_column_warning(i)\n")
    f.write( "          end select\n")
    f.write( "        end do\n")
    f.write( "      enddo\n")
    f.write( "    endif\n")
    f.write( "  endif\n")
    f.write( "endif\n\n")
    if len(db_max_name) > 0:
        f.write(f"db_mx%{db_max_name} = imax\n\n")
    f.write(f"close({dtype}%unit)\n\n")
    f.write( "return \n")
    f.write(f"end subroutine {subroutine_name}")
