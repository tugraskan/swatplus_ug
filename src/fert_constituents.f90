
!--------------------------------------------------------------------
!  fert_constituents_apply
!    Apply pesticide, pathogen, salt, heavy metal and other
!    constituent loads that are linked to a fertilizer application.
!    Concentrations are looked up using pre-computed array indices
!    from the appropriate *.man file for the fertilizer in question.  
!    The resulting mass is partitioned between plant and soil pools 
!    according to the application option.
!--------------------------------------------------------------------
subroutine fert_constituents_apply(j, ifrt, frt_kg, fertop)


      use mgt_operations_module
      use fertilizer_data_module
      use constituent_mass_module
      use basin_module
      use soil_module
      use plant_module
      use output_ls_pesticide_module
      use output_ls_pathogen_module

      implicit none

      integer, intent(in) :: j           ! HRU number
      integer, intent(in) :: ifrt        ! fertilizer id
      real,    intent(in) :: frt_kg      ! fertilizer mass (kg/ha)
      integer, intent(in) :: fertop      ! chemical application type



      integer :: ipest = 0              ! pesticide index
      real :: pest_kg = 0.              ! mass of pesticide applied
      integer :: ipath = 0              ! pathogen index  
      real :: path_kg = 0.              ! mass of pathogen applied
      integer :: isalt = 0              ! salt index
      real :: salt_kg = 0.              ! mass of salt applied
      integer :: ihmet = 0              ! heavy metal index
      real :: hmet_kg = 0.              ! mass of heavy metal applied
      integer :: ics = 0                ! other constituent index
      real :: cs_kg = 0.                ! mass of other constituent applied


      ! --- pesticides ---
      ! Use pre-computed index to directly access the correct linkage table.
      ! This eliminates string matching during application.
      
      if (cs_man_db%num_pests > 0) then
        if (allocated(pest_fert_soil_ini)) then
          if (size(manure_db) >= ifrt .and. ifrt > 0) then
            if (manure_db(ifrt)%pest_idx > 0) then
              do ipest = 1, cs_man_db%num_pests
                pest_kg = frt_kg * pest_fert_soil_ini(manure_db(ifrt)%pest_idx)%soil(ipest)
                if (pest_kg > 0.) call pest_apply(j, ipest, pest_kg, fertop)
              end do
            end if
          end if
        end if
      end if

      ! --- pathogens ---
      ! Use pre-computed index for direct array access instead of string lookup.

      if (cs_man_db%num_paths > 0) then
        if (allocated(path_fert_soil_ini)) then
          if (size(manure_db) >= ifrt .and. ifrt > 0) then
            if (manure_db(ifrt)%path_idx > 0) then
              do ipath = 1, cs_man_db%num_paths
                path_kg = frt_kg * path_fert_soil_ini(manure_db(ifrt)%path_idx)%soil(ipath)
                if (path_kg > 0.) call path_apply(j, ipath, path_kg, fertop)
              end do
            end if
          end if
        end if
      end if

      ! --- salts ---
      ! Use pre-computed index for direct access to salt concentrations.

      if (cs_man_db%num_salts > 0) then
        if (allocated(salt_fert_soil_ini)) then
          if (size(manure_db) >= ifrt .and. ifrt > 0) then
            if (manure_db(ifrt)%salt_idx > 0) then
              do isalt = 1, size(salt_fert_soil_ini(manure_db(ifrt)%salt_idx)%soil)
                salt_kg = frt_kg * salt_fert_soil_ini(manure_db(ifrt)%salt_idx)%soil(isalt)
                if (salt_kg > 0.) call salt_apply(j, isalt, salt_kg, fertop)
              end do
            end if
          end if
        end if
      end if

      ! --- heavy metals ---
      ! Use pre-computed index for direct access to heavy metal concentrations.

      if (cs_man_db%num_metals > 0) then
        if (allocated(hmet_fert_soil_ini)) then
          if (size(manure_db) >= ifrt .and. ifrt > 0) then
            if (manure_db(ifrt)%hmet_idx > 0) then
              do ihmet = 1, size(hmet_fert_soil_ini(manure_db(ifrt)%hmet_idx)%soil)
                hmet_kg = frt_kg * hmet_fert_soil_ini(manure_db(ifrt)%hmet_idx)%soil(ihmet)
                if (hmet_kg > 0.) call hmet_apply(j, ihmet, hmet_kg, fertop)
              end do
            end if
          end if
        end if
      end if

      ! --- other constituents ---
      ! Use pre-computed index for direct access to generic constituent concentrations.

      if (cs_man_db%num_cs > 0) then
        if (allocated(cs_fert_soil_ini)) then
          if (size(manure_db) >= ifrt .and. ifrt > 0) then
            if (manure_db(ifrt)%cs_idx > 0) then
              do ics = 1, size(cs_fert_soil_ini(manure_db(ifrt)%cs_idx)%soil)
                cs_kg = frt_kg * cs_fert_soil_ini(manure_db(ifrt)%cs_idx)%soil(ics)
                if (cs_kg > 0.) call cs_apply(j, ics, cs_kg, fertop)
              end do
            end if
          end if
        end if
      end if

      return
      end subroutine fert_constituents_apply
