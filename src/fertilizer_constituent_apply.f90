subroutine fert_constituents_apply(j, ifrt, frt_kg, fertop)
    use fertilizer_constituent_module
    use hru_module
    use cs_data_module
    implicit none

    integer, intent(in) :: j           ! HRU number
    integer, intent(in) :: ifrt        ! Fertilizer ID
    real, intent(in) :: frt_kg         ! Application rate (kg/ha)
    integer, intent(in) :: fertop      ! Application method
    
    ! Input validation
    if (j <= 0 .or. j > nhru) return
    if (ifrt <= 0 .or. ifrt > db_mx%fertparm) return
    if (frt_kg <= 0.0) return
    
    ! Only apply constituents for manure-based fertilizers
    if (.not. fertdb_ext(ifrt)%is_manure) return
    
    ! Check if constituent tracking is enabled
    if (.not. cs_db%constituents_active) return
    
    ! Apply each constituent type if enabled
    if (cs_db%pest_active) call apply_pesticide_constituents(j, ifrt, frt_kg, fertop)
    if (cs_db%path_active) call apply_pathogen_constituents(j, ifrt, frt_kg, fertop)
    if (cs_db%salt_active) call apply_salt_constituents(j, ifrt, frt_kg, fertop)
    if (cs_db%hmet_active) call apply_heavy_metal_constituents(j, ifrt, frt_kg, fertop)
    
    ! Update daily application tracking
    hru_fert_const(j)%daily_applications = hru_fert_const(j)%daily_applications + 1
    hru_fert_const(j)%total_fert_applied = hru_fert_const(j)%total_fert_applied + frt_kg
end subroutine

subroutine apply_pesticide_constituents(j, ifrt, frt_kg, fertop)
    use fertilizer_constituent_module
    use pesticide_data_module
    use hru_module
    use cs_data_module
    use maximum_data_module
    implicit none

    integer, intent(in) :: j, ifrt, fertop
    real, intent(in) :: frt_kg
    
    integer :: ipest, soil_layer
    real :: pest_loading_kg_ha, surface_fraction, subsurface_fraction
    real :: pest_mass_layer
    
    if (cs_db%num_pests == 0) return
    if (.not. allocated(pest_fert_ini)) return
    
    ! Get application method parameters
    if (fertop > 0 .and. fertop <= db_mx%chemapp) then
        surface_fraction = chemapp_db(fertop)%surf_frac
    else
        surface_fraction = 0.7  ! Default: 70% surface application
    endif
    subsurface_fraction = 1.0 - surface_fraction
    
    ! Apply each pesticide
    do ipest = 1, cs_db%num_pests
        if (pest_fert_ini(ipest)%conc(ifrt) > 0.0) then
            ! Calculate pesticide loading (kg/ha)
            pest_loading_kg_ha = convert_constituent_loading(frt_kg, &
                                 pest_fert_ini(ipest)%conc(ifrt), &
                                 fertdb_ext(ifrt)%conversion_factor)
            
            ! Apply to soil layers based on application method
            do soil_layer = 1, min(soil(j)%nly, 3)  ! Apply to top 3 layers max
                select case (soil_layer)
                    case (1)
                        ! Surface layer gets majority of application
                        pest_mass_layer = pest_loading_kg_ha * surface_fraction
                        
                    case (2)
                        ! Second layer gets subsurface fraction
                        pest_mass_layer = pest_loading_kg_ha * subsurface_fraction * 0.8
                        
                    case (3)
                        ! Third layer gets remaining subsurface fraction
                        pest_mass_layer = pest_loading_kg_ha * subsurface_fraction * 0.2
                        
                    case default
                        pest_mass_layer = 0.0
                end select
                
                ! Update soil pesticide mass
                hru_pest_soil(j)%pest(ipest)%soil(soil_layer) = &
                  hru_pest_soil(j)%pest(ipest)%soil(soil_layer) + pest_mass_layer
                
                ! Update daily balance arrays
                hpestb_d(j)%pest(ipest)%fert = hpestb_d(j)%pest(ipest)%fert + pest_mass_layer
                
                ! Update annual balance arrays
                hpestb_a(j)%pest(ipest)%fert = hpestb_a(j)%pest(ipest)%fert + pest_mass_layer
            enddo
            
            ! Track total pesticide applied for this HRU
            hru_pest_soil(j)%pest(ipest)%tot_fert = &
              hru_pest_soil(j)%pest(ipest)%tot_fert + pest_loading_kg_ha
        endif
    enddo
end subroutine

subroutine apply_pathogen_constituents(j, ifrt, frt_kg, fertop)
    use fertilizer_constituent_module
    use pathogen_data_module
    use hru_module
    use cs_data_module
    use maximum_data_module
    implicit none

    integer, intent(in) :: j, ifrt, fertop
    real, intent(in) :: frt_kg
    
    integer :: ipath, soil_layer
    real :: path_loading_cfu_ha, surface_fraction
    real :: survival_factor, temperature_factor
    real :: path_mass_layer
    
    if (cs_db%num_paths == 0) return
    if (.not. allocated(path_fert_ini)) return
    
    ! Get application method parameters
    if (fertop > 0 .and. fertop <= db_mx%chemapp) then
        surface_fraction = chemapp_db(fertop)%surf_frac
    else
        surface_fraction = 0.9  ! Default: 90% surface for pathogens
    endif
    
    ! Calculate environmental survival factors
    call calculate_pathogen_survival_factors(j, survival_factor, temperature_factor)
    
    ! Apply each pathogen
    do ipath = 1, cs_db%num_paths
        if (path_fert_ini(ipath)%conc(ifrt) > 0.0) then
            ! Calculate pathogen loading (CFU/ha)
            path_loading_cfu_ha = convert_pathogen_loading(frt_kg, &
                                  path_fert_ini(ipath)%conc(ifrt), &
                                  fertdb_ext(ifrt)%conversion_factor)
            
            ! Apply survival factors
            path_loading_cfu_ha = path_loading_cfu_ha * survival_factor * temperature_factor
            
            ! Apply to soil layers (pathogens mainly stay in surface layers)
            do soil_layer = 1, min(soil(j)%nly, 2)  ! Apply to top 2 layers only
                select case (soil_layer)
                    case (1)
                        ! Surface layer gets majority of pathogens
                        path_mass_layer = path_loading_cfu_ha * surface_fraction
                        
                    case (2)
                        ! Second layer gets remaining fraction
                        path_mass_layer = path_loading_cfu_ha * (1.0 - surface_fraction)
                        
                    case default
                        path_mass_layer = 0.0
                end select
                
                ! Update soil pathogen count
                hru_path_soil(j)%path(ipath)%soil(soil_layer) = &
                  hru_path_soil(j)%path(ipath)%soil(soil_layer) + path_mass_layer
                
                ! Update balance arrays
                hpathb_d(j)%path(ipath)%fert = hpathb_d(j)%path(ipath)%fert + path_mass_layer
                hpathb_a(j)%path(ipath)%fert = hpathb_a(j)%path(ipath)%fert + path_mass_layer
            enddo
            
            ! Track total pathogen loading
            hru_path_soil(j)%path(ipath)%tot_fert = &
              hru_path_soil(j)%path(ipath)%tot_fert + path_loading_cfu_ha
        endif
    enddo
end subroutine