      subroutine cs_man_read
       
!!    ~ ~ ~ PURPOSE ~ ~ ~
!!    this subroutine reads other constituent manure loading for various fertilizer types
    
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
      
      !read other constituent manure loading
      inquire (file="cs.man", exist=i_exist)
      if (i_exist) then
        call fert_constituent_file_read("cs.man", cs_man_db%num_cs)
        call MOVE_ALLOC(fert_arr, cs_fert_ini)
      end if
      
      return
      end subroutine cs_man_read