      subroutine hmet_man_read
       
!!    ~ ~ ~ PURPOSE ~ ~ ~
!!    this subroutine reads heavy metal manure constituent loading for various fertilizer types
    
      use constituent_mass_module
      use input_file_module
      use maximum_data_module
      
      implicit none

      character (len=80) :: titldum = ""
      character (len=80) :: header = ""
      integer :: eof = 0
      integer :: imax = 0
      logical :: i_exist              !none       |check to determine if file exists

      eof = 0
      
      !read heavy metal manure constituent loading
      inquire (file="hmet.man", exist=i_exist)
      if (i_exist) then
        call fert_constituent_file_read("hmet.man", cs_man_db%num_metals)
        call MOVE_ALLOC(fert_arr, hmet_fert_ini)
      end if
      
      return
      end subroutine hmet_man_read