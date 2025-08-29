module fertilizer_constituent_module

    use constituent_mass_module
    use fertilizer_data_module
    implicit none

    ! Extended fertilizer database type with constituent linkage
    type fertilizer_db_extended
        character(len=16) :: fertnm = " "      ! Fertilizer name (traditional)
        real :: fminn, fminp, forgn, forgp, fnh3n  ! NPK composition (traditional)
        character(len=25) :: om_name = " "     ! NEW: Links to manure_om.man
        character(len=16) :: pathogens = " "   ! Pathogen linkage (traditional)
        character(len=256) :: description = " " ! Description (traditional)
        
        ! Runtime-computed fields
        integer :: manure_idx = 0              ! Pre-computed manure database index
        real :: conversion_factor = 0.         ! Unit conversion factor
        logical :: is_manure = .false.         ! Flag indicating manure-based fertilizer
    end type fertilizer_db_extended

    ! Manure organic matter database type
    type manure_organic_matter_data
        character(len=25) :: name = " "         ! Unique identifier (links to om_name)
        character(len=25) :: region = " "       ! Geographic region
        character(len=25) :: source = " "       ! Animal source
        character(len=25) :: typ = " "          ! Physical form
        
        ! Composition (% by weight)
        real :: pct_moist = 0.0                ! Moisture percentage
        real :: pct_solid = 0.0                ! Solids percentage
        real :: tot_c = 0.0                    ! Total carbon
        real :: tot_n = 0.0                    ! Total nitrogen
        real :: inorg_n = 0.0                  ! Inorganic nitrogen
        real :: org_n = 0.0                    ! Organic nitrogen
        real :: tot_p2o5 = 0.0                 ! Total P2O5
        real :: inorg_p2o5 = 0.0               ! Inorganic P2O5
        real :: org_p2o5 = 0.0                 ! Organic P2O5
        real :: inorg_p = 0.0                  ! Inorganic phosphorus
        real :: org_p = 0.0                    ! Organic phosphorus
        real :: solids = 0.0                   ! Total solids content
        real :: water = 0.0                    ! Water content
    end type manure_organic_matter_data

    ! Global variables
    type(fertilizer_db_extended), dimension(:), allocatable :: fertdb_ext
    type(manure_organic_matter_data), dimension(:), allocatable :: manure_om_db
    character(len=16) :: fertilizer_format = "standard"
    
    ! Lookup tables for performance
    integer, dimension(:), allocatable :: fertilizer_to_manure_map
    logical, dimension(:), allocatable :: fertilizer_is_manure
    real, dimension(:), allocatable :: fertilizer_conversion_factors
    
    ! Maximum array sizes
    integer, parameter :: mx_manure = 1000
    
contains

    function convert_constituent_loading(base_rate_kg_ha, conc_ppm, conversion_factor) result(loading_kg_ha)
        real, intent(in) :: base_rate_kg_ha      ! Fertilizer application rate
        real, intent(in) :: conc_ppm             ! Constituent concentration
        real, intent(in) :: conversion_factor    ! Unit conversion factor
        real :: loading_kg_ha                    ! Resulting constituent loading
        
        ! Convert ppm to kg/kg, then multiply by application rate
        ! Formula: loading = rate * concentration * conversion / 1,000,000
        loading_kg_ha = base_rate_kg_ha * conc_ppm * conversion_factor / 1.0e6
        
        ! Apply minimum threshold to avoid numerical issues
        if (loading_kg_ha < 1.0e-12) loading_kg_ha = 0.0
    end function

    function convert_pathogen_loading(base_rate_kg_ha, cfu_per_g, conversion_factor) result(loading_cfu_ha)
        real, intent(in) :: base_rate_kg_ha      ! Fertilizer application rate
        real, intent(in) :: cfu_per_g            ! Pathogen concentration (CFU/g)
        real, intent(in) :: conversion_factor    ! Unit conversion factor
        real :: loading_cfu_ha                   ! Resulting pathogen loading (CFU/ha)
        
        ! Convert CFU/g to CFU/ha based on application rate
        ! 1 kg = 1000 g, so multiply by 1000
        loading_cfu_ha = base_rate_kg_ha * cfu_per_g * 1000.0
        
        ! Apply minimum threshold
        if (loading_cfu_ha < 1.0) loading_cfu_ha = 0.0
    end function

    function get_constituent_concentration(const_type, const_idx, fert_idx) result(concentration)
        character(len=*), intent(in) :: const_type
        integer, intent(in) :: const_idx, fert_idx
        real :: concentration
        
        integer :: i
        
        concentration = 0.0
        
        ! Find matching constituent and fertilizer in fert_arr
        if (allocated(fert_arr)) then
            do i = 1, size(fert_arr)
                if (trim(fert_arr(i)%name) == trim(fertdb(fert_idx)%fertnm)) then
                    if (const_idx <= size(fert_arr(i)%ppm)) then
                        concentration = fert_arr(i)%ppm(const_idx)
                    endif
                    exit
                endif
            enddo
        endif
    end function

end module fertilizer_constituent_module