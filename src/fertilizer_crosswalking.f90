subroutine compute_fertilizer_manure_indices()
    use fertilizer_constituent_module
    use maximum_data_module
    implicit none

    integer :: i, j
    integer :: matched_count = 0
    
    do i = 1, db_mx%fertparm
        ! Initialize values
        fertdb_ext(i)%manure_idx = 0
        fertdb_ext(i)%is_manure = .false.
        fertdb_ext(i)%conversion_factor = 0.0
        
        if (trim(fertdb_ext(i)%om_name) /= "" .and. trim(fertdb_ext(i)%om_name) /= "null") then
            ! Find matching manure record
            do j = 1, db_mx%manureparm
                if (trim(fertdb_ext(i)%om_name) == trim(manure_om_db(j)%name)) then
                    ! Store pre-computed index
                    fertdb_ext(i)%manure_idx = j
                    fertdb_ext(i)%is_manure = .true.
                    matched_count = matched_count + 1
                    
                    ! Set unit conversion factor
                    call set_conversion_factor(fertdb_ext(i), manure_om_db(j))
                    exit
                endif
            enddo
        endif
    enddo
end subroutine

subroutine set_conversion_factor(fert_rec, manure_rec)
    use fertilizer_constituent_module
    implicit none

    type(fertilizer_db_extended), intent(inout) :: fert_rec
    type(manure_organic_matter_data), intent(in) :: manure_rec
    
    select case (trim(manure_rec%typ))
        case ('liquid')
            ! 1 lb/1000 gal = 119.82 ppm (liquid manure density ~8.34 lb/gal)
            fert_rec%conversion_factor = 119.82
            
        case ('slurry')
            ! Intermediate density, use liquid conversion
            fert_rec%conversion_factor = 119.82
            
        case ('solid', 'semi-solid')
            ! 1 lb/ton = 500 ppm (2000 lb/ton conversion)
            fert_rec%conversion_factor = 500.0
            
        case ('compost')
            ! Composted material, use solid conversion
            fert_rec%conversion_factor = 500.0
            
        case default
            ! Default to solid conversion
            fert_rec%conversion_factor = 500.0
    end select
end subroutine

subroutine build_lookup_tables()
    use fertilizer_constituent_module
    use maximum_data_module
    implicit none

    integer :: i
    
    ! Allocate lookup arrays
    allocate(fertilizer_to_manure_map(db_mx%fertparm))
    allocate(fertilizer_is_manure(db_mx%fertparm))
    allocate(fertilizer_conversion_factors(db_mx%fertparm))
    
    ! Populate lookup arrays for fast runtime access
    do i = 1, db_mx%fertparm
        fertilizer_to_manure_map(i) = fertdb_ext(i)%manure_idx
        fertilizer_is_manure(i) = fertdb_ext(i)%is_manure
        fertilizer_conversion_factors(i) = fertdb_ext(i)%conversion_factor
    enddo
end subroutine

subroutine cleanup_lookup_tables()
    use fertilizer_constituent_module
    implicit none

    ! Deallocate lookup arrays when done
    if (allocated(fertilizer_to_manure_map)) deallocate(fertilizer_to_manure_map)
    if (allocated(fertilizer_is_manure)) deallocate(fertilizer_is_manure)
    if (allocated(fertilizer_conversion_factors)) deallocate(fertilizer_conversion_factors)
end subroutine