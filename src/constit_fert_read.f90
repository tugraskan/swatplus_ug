!--------------------------------------------------------------------
!  constit_fert_read
!    Dedicated subroutine for reading all fertilizer constituent files.
!    Consolidates reading of all *.man files and follows repository
!    pattern of dedicated reading subroutines.
!    
!    Separated from constit_man_db_read for better modularity and
!    alignment with repository code structure patterns.
!--------------------------------------------------------------------
subroutine constit_fert_read

      use constituent_mass_module

      implicit none
      
      ! Read all fertilizer constituent files now that constituent database is loaded
      ! This consolidates all fert_constituent_file_read calls that were previously scattered
      ! across individual constituent reading subroutines
      
      ! Read pesticide fertilizer concentrations
      if (cs_man_db%num_pests > 0) then
        call fert_constituent_file_read("pest.man", cs_man_db%num_pests)
        call MOVE_ALLOC(fert_arr, pest_fert_ini)
      end if
      
      ! Read pathogen fertilizer concentrations  
      if (cs_man_db%num_paths > 0) then
        call fert_constituent_file_read("path.man", cs_man_db%num_paths)
        call MOVE_ALLOC(fert_arr, path_fert_ini)
      end if
      
      ! Read heavy metal fertilizer concentrations
      if (cs_man_db%num_metals > 0) then
        call fert_constituent_file_read("hmet.man", cs_man_db%num_metals)
        call MOVE_ALLOC(fert_arr, hmet_fert_ini)
      end if
      
      ! Read salt fertilizer concentrations
      if (cs_man_db%num_salts > 0) then
        call fert_constituent_file_read("salt.man",  cs_man_db%num_salts)
        call MOVE_ALLOC(fert_arr, salt_fert_ini)
      end if
      
      ! Read general constituent fertilizer concentrations
      if (cs_man_db%num_cs > 0) then
        call fert_constituent_file_read("cs.man",  cs_man_db%num_cs)
        call MOVE_ALLOC(fert_arr, cs_fert_ini)
      end if
      
      return
      end subroutine constit_fert_read