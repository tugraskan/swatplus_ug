subroutine calculate_pathogen_survival_factors(j, survival_factor, temperature_factor)
    use hru_module
    implicit none

    integer, intent(in) :: j
    real, intent(out) :: survival_factor, temperature_factor
    
    real :: soil_temp, soil_moisture
    
    ! Get current environmental conditions
    soil_temp = soil(j)%phys(1)%tmp
    soil_moisture = soil(j)%phys(1)%wc / soil(j)%phys(1)%fc
    
    ! Temperature survival factor (pathogens survive better in cooler conditions)
    if (soil_temp < 5.0) then
        temperature_factor = 0.9  ! High survival in cold
    else if (soil_temp < 15.0) then
        temperature_factor = 0.7  ! Medium survival in cool
    else if (soil_temp < 25.0) then
        temperature_factor = 0.4  ! Lower survival in warm
    else
        temperature_factor = 0.1  ! Low survival in hot
    endif
    
    ! Moisture survival factor (pathogens need moisture)
    if (soil_moisture > 0.8) then
        survival_factor = 0.8  ! High survival when very moist
    else if (soil_moisture > 0.4) then
        survival_factor = 0.6  ! Medium survival when moderately moist
    else if (soil_moisture > 0.1) then
        survival_factor = 0.3  ! Lower survival when dry
    else
        survival_factor = 0.05  ! Very low survival when very dry
    endif
end subroutine

subroutine apply_salt_constituents(j, ifrt, frt_kg, fertop)
    use fertilizer_constituent_module
    use salt_data_module
    use hru_module
    use cs_data_module
    implicit none

    integer, intent(in) :: j, ifrt, fertop
    real, intent(in) :: frt_kg
    
    integer :: isalt, soil_layer
    real :: salt_loading_kg_ha, distribution_fraction
    real :: leaching_factor
    real :: salt_mass_layer
    
    if (cs_db%num_salts == 0) return
    if (.not. allocated(salt_fert_ini)) return
    
    ! Calculate leaching factor based on soil properties
    call calculate_salt_leaching_factor(j, leaching_factor)
    
    ! Apply each salt constituent
    do isalt = 1, cs_db%num_salts
        if (salt_fert_ini(isalt)%conc(ifrt) > 0.0) then
            ! Calculate salt loading (kg/ha)
            salt_loading_kg_ha = convert_constituent_loading(frt_kg, &
                                 salt_fert_ini(isalt)%conc(ifrt), &
                                 fertdb_ext(ifrt)%conversion_factor)
            
            ! Distribute salts through soil profile (salts are mobile)
            do soil_layer = 1, min(soil(j)%nly, 5)  ! Apply to top 5 layers
                ! Distribution decreases with depth but salts can leach
                distribution_fraction = exp(-0.5 * real(soil_layer - 1)) * leaching_factor
                
                salt_mass_layer = salt_loading_kg_ha * distribution_fraction
                
                ! Update soil salt concentration
                hru_salt_soil(j)%salt(isalt)%soil(soil_layer) = &
                  hru_salt_soil(j)%salt(isalt)%soil(soil_layer) + salt_mass_layer
                
                ! Update balance arrays
                hsaltb_d(j)%salt(isalt)%fert = hsaltb_d(j)%salt(isalt)%fert + salt_mass_layer
                hsaltb_a(j)%salt(isalt)%fert = hsaltb_a(j)%salt(isalt)%fert + salt_mass_layer
            enddo
            
            ! Track total salt loading
            hru_salt_soil(j)%salt(isalt)%tot_fert = &
              hru_salt_soil(j)%salt(isalt)%tot_fert + salt_loading_kg_ha
        endif
    enddo
end subroutine

subroutine calculate_salt_leaching_factor(j, leaching_factor)
    use hru_module
    implicit none

    integer, intent(in) :: j
    real, intent(out) :: leaching_factor
    
    real :: soil_permeability
    
    ! Get soil hydraulic properties
    soil_permeability = soil(j)%phys(1)%k
    
    ! Calculate leaching potential based on permeability
    if (soil_permeability > 50.0) then
        leaching_factor = 1.5  ! High leaching in sandy soils
    else if (soil_permeability > 10.0) then
        leaching_factor = 1.0  ! Normal leaching in loamy soils
    else if (soil_permeability > 1.0) then
        leaching_factor = 0.7  ! Reduced leaching in clay soils
    else
        leaching_factor = 0.3  ! Minimal leaching in tight soils
    endif
end subroutine

subroutine apply_heavy_metal_constituents(j, ifrt, frt_kg, fertop)
    use fertilizer_constituent_module
    use hru_module
    use cs_data_module
    implicit none

    integer, intent(in) :: j, ifrt, fertop
    real, intent(in) :: frt_kg
    
    integer :: ihmet, soil_layer
    real :: hmet_loading_kg_ha, sorption_factor
    real :: ph_factor, organic_matter_factor
    real :: hmet_mass_layer
    
    if (cs_db%num_hmets == 0) return
    if (.not. allocated(hmet_fert_ini)) return
    
    ! Calculate sorption factors based on soil properties
    call calculate_heavy_metal_sorption(j, sorption_factor, ph_factor, organic_matter_factor)
    
    ! Apply each heavy metal constituent
    do ihmet = 1, cs_db%num_hmets
        if (hmet_fert_ini(ihmet)%conc(ifrt) > 0.0) then
            ! Calculate heavy metal loading (kg/ha)
            hmet_loading_kg_ha = convert_constituent_loading(frt_kg, &
                                 hmet_fert_ini(ihmet)%conc(ifrt), &
                                 fertdb_ext(ifrt)%conversion_factor)
            
            ! Apply sorption factors (heavy metals bind strongly to soil)
            hmet_loading_kg_ha = hmet_loading_kg_ha * sorption_factor * ph_factor * organic_matter_factor
            
            ! Heavy metals accumulate primarily in surface layers
            do soil_layer = 1, min(soil(j)%nly, 3)  ! Apply to top 3 layers
                select case (soil_layer)
                    case (1)
                        ! Surface layer gets most heavy metals (80%)
                        hmet_mass_layer = hmet_loading_kg_ha * 0.8
                        
                    case (2)
                        ! Second layer gets some (15%)
                        hmet_mass_layer = hmet_loading_kg_ha * 0.15
                        
                    case (3)
                        ! Third layer gets minimal (5%)
                        hmet_mass_layer = hmet_loading_kg_ha * 0.05
                        
                    case default
                        hmet_mass_layer = 0.0
                end select
                
                ! Update soil heavy metal concentration
                hru_hmet_soil(j)%hmet(ihmet)%soil(soil_layer) = &
                  hru_hmet_soil(j)%hmet(ihmet)%soil(soil_layer) + hmet_mass_layer
                
                ! Update balance arrays
                hhmetb_d(j)%hmet(ihmet)%fert = hhmetb_d(j)%hmet(ihmet)%fert + hmet_mass_layer
                hhmetb_a(j)%hmet(ihmet)%fert = hhmetb_a(j)%hmet(ihmet)%fert + hmet_mass_layer
            enddo
            
            ! Track total heavy metal loading
            hru_hmet_soil(j)%hmet(ihmet)%tot_fert = &
              hru_hmet_soil(j)%hmet(ihmet)%tot_fert + hmet_loading_kg_ha
        endif
    enddo
end subroutine

subroutine calculate_heavy_metal_sorption(j, sorption_factor, ph_factor, organic_matter_factor)
    use hru_module
    implicit none

    integer, intent(in) :: j
    real, intent(out) :: sorption_factor, ph_factor, organic_matter_factor
    
    real :: soil_ph, organic_carbon_pct, clay_content
    
    ! Get soil chemical and physical properties
    soil_ph = soil(j)%ly(1)%ph
    organic_carbon_pct = soil(j)%ly(1)%carbon * 100.0
    clay_content = soil(j)%ly(1)%clay
    
    ! pH factor (higher pH increases sorption)
    if (soil_ph > 7.5) then
        ph_factor = 1.2  ! High sorption in alkaline soils
    else if (soil_ph > 6.5) then
        ph_factor = 1.0  ! Normal sorption in neutral soils
    else if (soil_ph > 5.5) then
        ph_factor = 0.8  ! Reduced sorption in slightly acid soils
    else
        ph_factor = 0.5  ! Low sorption in acid soils
    endif
    
    ! Organic matter factor (more OM increases sorption)
    if (organic_carbon_pct > 3.0) then
        organic_matter_factor = 1.3  ! High sorption with high OM
    else if (organic_carbon_pct > 1.5) then
        organic_matter_factor = 1.0  ! Normal sorption with medium OM
    else if (organic_carbon_pct > 0.5) then
        organic_matter_factor = 0.8  ! Reduced sorption with low OM
    else
        organic_matter_factor = 0.6  ! Low sorption with very low OM
    endif
    
    ! Base sorption factor from clay content
    if (clay_content > 40.0) then
        sorption_factor = 1.2  ! High sorption in clay soils
    else if (clay_content > 20.0) then
        sorption_factor = 1.0  ! Normal sorption in loamy soils
    else
        sorption_factor = 0.7  ! Lower sorption in sandy soils
    endif
end subroutine