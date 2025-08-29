subroutine load_constituent_linkages()
    use fertilizer_constituent_module
    use cs_data_module
    implicit none

    ! Load different types of constituent linkage files using existing routine
    call load_pesticide_linkages()
    call load_pathogen_linkages()
    call load_salt_linkages()
    call load_heavy_metal_linkages()
end subroutine

subroutine load_pesticide_linkages()
    use fertilizer_constituent_module
    use cs_data_module
    use pesticide_data_module
    implicit none

    logical :: i_exist
    integer :: i, j
    
    inquire(file='pest.man', exist=i_exist)
    if (.not. i_exist) then
        return
    endif
    
    ! Use existing fert_constituent_file_read routine
    call fert_constituent_file_read('pest.man', cs_db%num_pests)
    
    ! Map loaded data to pesticide arrays
    if (allocated(fert_arr)) then
        do i = 1, cs_db%num_pests
            do j = 1, db_mx%fertparm
                if (fertdb_ext(j)%is_manure) then
                    ! Find matching pesticide and fertilizer
                    pest_fert_ini(i)%conc(j) = get_constituent_concentration('pest', i, j)
                endif
            enddo
        enddo
    endif
end subroutine

subroutine load_pathogen_linkages()
    use fertilizer_constituent_module
    use cs_data_module
    use pathogen_data_module
    implicit none

    logical :: i_exist
    integer :: i, j
    
    inquire(file='path.man', exist=i_exist)
    if (.not. i_exist) then
        return
    endif
    
    ! Use existing fert_constituent_file_read routine
    call fert_constituent_file_read('path.man', cs_db%num_paths)
    
    ! Map loaded data to pathogen arrays
    if (allocated(fert_arr)) then
        do i = 1, cs_db%num_paths
            do j = 1, db_mx%fertparm
                if (fertdb_ext(j)%is_manure) then
                    path_fert_ini(i)%conc(j) = get_constituent_concentration('path', i, j)
                endif
            enddo
        enddo
    endif
end subroutine

subroutine load_salt_linkages()
    use fertilizer_constituent_module
    use cs_data_module
    use salt_data_module
    implicit none

    logical :: i_exist
    integer :: i, j
    
    inquire(file='salt.man', exist=i_exist)
    if (.not. i_exist) then
        return
    endif
    
    ! Use existing fert_constituent_file_read routine
    call fert_constituent_file_read('salt.man', cs_db%num_salts)
    
    ! Map loaded data to salt arrays
    if (allocated(fert_arr)) then
        do i = 1, cs_db%num_salts
            do j = 1, db_mx%fertparm
                if (fertdb_ext(j)%is_manure) then
                    salt_fert_ini(i)%conc(j) = get_constituent_concentration('salt', i, j)
                endif
            enddo
        enddo
    endif
end subroutine

subroutine load_heavy_metal_linkages()
    use fertilizer_constituent_module
    use cs_data_module
    implicit none

    logical :: i_exist
    integer :: i, j
    
    inquire(file='hmet.man', exist=i_exist)
    if (.not. i_exist) then
        return
    endif
    
    ! Use existing fert_constituent_file_read routine
    call fert_constituent_file_read('hmet.man', cs_db%num_hmets)
    
    ! Map loaded data to heavy metal arrays
    if (allocated(fert_arr)) then
        do i = 1, cs_db%num_hmets
            do j = 1, db_mx%fertparm
                if (fertdb_ext(j)%is_manure) then
                    hmet_fert_ini(i)%conc(j) = get_constituent_concentration('hmet', i, j)
                endif
            enddo
        enddo
    endif
end subroutine