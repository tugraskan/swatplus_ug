
!--------------------------------------------------------------------
!  fert_constituents_apply
!    Apply pesticide, pathogen, salt, heavy metal and other constituent
!    loads that are linked to a fertilizer application.  The routine
!    multiplies the fertilizer rate by the stored constituent
!    concentrations and distributes the resulting mass between plant
!    and soil pools.
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



      integer :: ipest_ini = 0, ipest = 0  ! pesticide table and index
      real :: pest_kg = 0.                 ! mass of pesticide applied
      integer :: ipath_ini = 0, ipath = 0  ! pathogen table and index
      real :: path_kg = 0.                 ! mass of pathogen applied
      integer :: isalt_ini = 0, isalt = 0  ! salt table and index
      real :: salt_kg = 0.                 ! mass of salt applied
      integer :: ihmet_ini = 0, ihmet = 0  ! heavy metal table and index
      real :: hmet_kg = 0.                 ! mass of heavy metal applied
      integer :: ics_ini = 0, ics = 0      ! other constituent table and index
      real :: cs_kg = 0.                   ! mass of other constituent applied


      ! --- pesticides ---
      ! If the fertilizer references a pesticide table, locate the matching
      ! entry and apply each pesticide in proportion to the fertilizer mass.
      
      if (cs_db%num_pests > 0) then
        if (allocated(pest_fert_soil_ini)) then
          if (size(manure_db) >= ifrt) then
            if (manure_db(ifrt)%pest /= '') then
              do ipest_ini = 1, size(pest_fert_soil_ini)
                if (trim(manure_db(ifrt)%pest) == trim(pest_fert_soil_ini(ipest_ini)%name)) then
                  do ipest = 1, cs_db%num_pests
                    pest_kg = frt_kg * pest_fert_soil_ini(ipest_ini)%soil(ipest)
                    if (pest_kg > 0.) call pest_apply(j, ipest, pest_kg, fertop)
                  end do

                  exit                       ! stop searching once a match is found
                end if
              end do
            end if
          end if
        end if
      end if

      ! --- pathogens ---
      ! Similar logic is used for pathogens.  The matching table provides
      ! concentrations for each pathogen which are multiplied by the fertilizer
      ! rate and then added to plant and soil pools.

      if (cs_db%num_paths > 0) then
        if (allocated(path_fert_soil_ini)) then
          if (size(manure_db) >= ifrt) then
            if (manure_db(ifrt)%path /= '') then
              do ipath_ini = 1, size(path_fert_soil_ini)
                if (trim(manure_db(ifrt)%path) == trim(path_fert_soil_ini(ipath_ini)%name)) then
                  do ipath = 1, cs_db%num_paths
                    path_kg = frt_kg * path_fert_soil_ini(ipath_ini)%soil(ipath)
                    if (path_kg > 0.) call path_apply(j, ipath, path_kg, fertop)
                  end do
                  exit
                end if
              end do
            end if
          end if
        end if
      end if

      ! --- salts ---
      ! Add ion concentrations from the matching salt table to the soil layers.

      if (cs_db%num_salts > 0) then
        if (allocated(salt_fert_soil_ini)) then
          if (size(manure_db) >= ifrt) then
            if (manure_db(ifrt)%salt /= '') then
              do isalt_ini = 1, size(salt_fert_soil_ini)
                if (trim(manure_db(ifrt)%salt) == trim(salt_fert_soil_ini(isalt_ini)%name)) then
                  do isalt = 1, size(salt_fert_soil_ini(isalt_ini)%soil)
                    salt_kg = frt_kg * salt_fert_soil_ini(isalt_ini)%soil(isalt)
                    if (salt_kg > 0.) call salt_apply(j, isalt, salt_kg, fertop)
                  end do
                  exit
                end if
              end do
            end if
          end if
        end if
      end if

      ! --- heavy metals ---
      ! Heavy metals are treated like salts but stored in a separate table.

      if (cs_db%num_metals > 0) then
        if (allocated(hmet_fert_soil_ini)) then
          if (size(manure_db) >= ifrt) then
            if (manure_db(ifrt)%hmet /= '') then
              do ihmet_ini = 1, size(hmet_fert_soil_ini)
                if (trim(manure_db(ifrt)%hmet) == trim(hmet_fert_soil_ini(ihmet_ini)%name)) then
                  do ihmet = 1, size(hmet_fert_soil_ini(ihmet_ini)%soil)
                    hmet_kg = frt_kg * hmet_fert_soil_ini(ihmet_ini)%soil(ihmet)
                    if (hmet_kg > 0.) call hmet_apply(j, ihmet, hmet_kg, fertop)
                  end do
                  exit
                end if
              end do
            end if
          end if
        end if
      end if

      ! --- other constituents ---
      ! Generic constituents are treated in the same way as salts and metals.

      if (cs_db%num_cs > 0) then
        if (allocated(cs_fert_soil_ini)) then
          if (size(manure_db) >= ifrt) then
            if (manure_db(ifrt)%cs /= '') then
              do ics_ini = 1, size(cs_fert_soil_ini)
                if (trim(manure_db(ifrt)%cs) == trim(cs_fert_soil_ini(ics_ini)%name)) then
                  do ics = 1, size(cs_fert_soil_ini(ics_ini)%soil)
                    cs_kg = frt_kg * cs_fert_soil_ini(ics_ini)%soil(ics)
                    if (cs_kg > 0.) call cs_apply(j, ics, cs_kg, fertop)
                  end do
                  exit
                end if
              end do
            end if
          end if
        end if
      end if

      return
      end subroutine fert_constituents_apply
