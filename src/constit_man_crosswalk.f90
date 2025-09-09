!--------------------------------------------------------------------
!  constit_man_crosswalk
!    Perform crosswalking of fertilizer linkage table names with 
!    constituent arrays. This populates direct array indices to 
!    eliminate string matching during fertilizer applications.
!    
!    This subroutine should be called after all constituent *.man 
!    files have been read by their respective read subroutines.
!--------------------------------------------------------------------
subroutine constit_man_crosswalk
      
      use basin_module
      use input_file_module
      use constituent_mass_module
      use maximum_data_module
      use pesticide_data_module
      use pathogen_data_module
      use fertilizer_data_module

      implicit none
         
      integer :: i = 0                !           |
      integer :: ifrt = 0             !none       |fertilizer counter  
       
      ! Perform crosswalking of fertilizer linkage table names with constituent arrays
      ! This populates direct array indices to eliminate string matching during application
      
      ! Exit if no extended fertilizer database exists or if empty
      if (allocated(manure_db) .and. size(manure_db) > 1) then
        ! Crosswalk each fertilizer entry
        do ifrt = 1, size(manure_db)
          if (ifrt == 0) cycle  ! skip null entry
          
          ! --- Pesticide crosswalk ---
          if (allocated(pest_fert_ini) .and. size(pest_fert_ini) > 0 .and. &
              manure_db(ifrt)%pest /= '') then
            do i = 1, size(pest_fert_ini)
              if (trim(manure_db(ifrt)%pest) == trim(pest_fert_ini(i)%name)) then
                manure_db(ifrt)%pest_idx = i
                exit
              end if
            end do
          end if
          
          ! --- Pathogen crosswalk ---
          if (allocated(path_fert_ini) .and. size(path_fert_ini) > 0 .and. &
              manure_db(ifrt)%path /= '') then
            do i = 1, size(path_fert_ini)
              if (trim(manure_db(ifrt)%path) == trim(path_fert_ini(i)%name)) then
                manure_db(ifrt)%path_idx = i
                exit
              end if
            end do
          end if
          
          ! --- Salt crosswalk ---
          if (allocated(salt_fert_ini) .and. size(salt_fert_ini) > 0 .and. &
              manure_db(ifrt)%salt /= '') then
            do i = 1, size(salt_fert_ini)
              if (trim(manure_db(ifrt)%salt) == trim(salt_fert_ini(i)%name)) then
                manure_db(ifrt)%salt_idx = i
                exit
              end if
            end do
          end if
          
          ! --- Heavy metal crosswalk ---
          if (allocated(hmet_fert_ini) .and. size(hmet_fert_ini) > 0 .and. &
              manure_db(ifrt)%hmet /= '') then
            do i = 1, size(hmet_fert_ini)
              if (trim(manure_db(ifrt)%hmet) == trim(hmet_fert_ini(i)%name)) then
                manure_db(ifrt)%hmet_idx = i
                exit
              end if
            end do
          end if
          
          ! --- Generic constituent crosswalk ---
          if (allocated(cs_fert_ini) .and. size(cs_fert_ini) > 0 .and. &
              manure_db(ifrt)%cs /= '') then
            do i = 1, size(cs_fert_ini)
              if (trim(manure_db(ifrt)%cs) == trim(cs_fert_ini(i)%name)) then
                manure_db(ifrt)%cs_idx = i
                exit
              end if
            end do
          end if
          
        end do
      end if
      
      return
      end subroutine constit_man_crosswalk