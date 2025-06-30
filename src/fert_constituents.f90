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

      real :: gc = 0.
      real :: surf_frac = 0.
      real :: pl_frac = 0.
      integer :: ipl = 0

      integer :: ipest_ini = 0, ipest = 0
      real :: pest_kg = 0.
      integer :: ipath_ini = 0, ipath = 0
      real :: path_kg = 0.
      integer :: isalt_ini = 0, isalt = 0
      real :: salt_kg = 0.
      integer :: ihmet_ini = 0, ihmet = 0
      real :: hmet_kg = 0.
      integer :: ics_ini = 0, ics = 0
      real :: cs_kg = 0.

      gc = (1.99532 - erfc(1.333 * pcom(j)%lai_sum - 2.)) / 2.1
      if (gc < 0.) gc = 0.
      surf_frac = chemapp_db(fertop)%surf_frac

      ! --- pesticides ---
      if (cs_db%num_pests > 0) then
        if (allocated(pest_fert_soil_ini)) then
          if (size(fertdb_cbn) >= ifrt) then
            if (fertdb_cbn(ifrt)%pest /= '') then
              do ipest_ini = 1, size(pest_fert_soil_ini)
                if (trim(fertdb_cbn(ifrt)%pest) == trim(pest_fert_soil_ini(ipest_ini)%name)) then
                  do ipest = 1, cs_db%num_pests
                    pest_kg = frt_kg * pest_fert_soil_ini(ipest_ini)%soil(ipest)
                    if (pest_kg > 0.) call pest_apply(j, ipest, pest_kg, fertop)
                  end do
                  exit
                end if
              end do
            end if
          end if
        end if
      end if

      ! --- pathogens ---
      if (cs_db%num_paths > 0) then
        if (allocated(path_fert_soil_ini)) then
          if (size(fertdb_cbn) >= ifrt) then
            if (fertdb_cbn(ifrt)%path /= '') then
              do ipath_ini = 1, size(path_fert_soil_ini)
                if (trim(fertdb_cbn(ifrt)%path) == trim(path_fert_soil_ini(ipath_ini)%name)) then
                  do ipath = 1, cs_db%num_paths
                    path_kg = frt_kg * path_fert_soil_ini(ipath_ini)%soil(ipath)
                    if (path_kg > 0.) then
                      if (pcom(j)%lai_sum > 1.e-6) then
                        do ipl = 1, pcom(j)%npl
                          pl_frac = pcom(j)%plg(ipl)%lai / pcom(j)%lai_sum
                          cs_pl(j)%pl_on(ipl)%path(ipath) = cs_pl(j)%pl_on(ipl)%path(ipath) + gc * pl_frac * path_kg
                          hpath_bal(j)%path(ipath)%apply_plt = hpath_bal(j)%path(ipath)%apply_plt + gc * pl_frac * path_kg
                        end do
                      end if
                      cs_soil(j)%ly(1)%path(ipath) = cs_soil(j)%ly(1)%path(ipath) + (1. - gc) * surf_frac * path_kg
                      cs_soil(j)%ly(2)%path(ipath) = cs_soil(j)%ly(2)%path(ipath) + (1. - gc) * (1. - surf_frac) * path_kg
                      hpath_bal(j)%path(ipath)%apply_sol = hpath_bal(j)%path(ipath)%apply_sol + (1. - gc) * path_kg
                    end if
                  end do
                  exit
                end if
              end do
            end if
          end if
        end if
      end if

      ! --- salts ---
      if (cs_db%num_salts > 0) then
        if (allocated(salt_fert_soil_ini)) then
          if (size(fertdb_cbn) >= ifrt) then
            if (fertdb_cbn(ifrt)%salt /= '') then
              do isalt_ini = 1, size(salt_fert_soil_ini)
                if (trim(fertdb_cbn(ifrt)%salt) == trim(salt_fert_soil_ini(isalt_ini)%name)) then
                  do isalt = 1, size(salt_fert_soil_ini(isalt_ini)%soil)
                    salt_kg = frt_kg * salt_fert_soil_ini(isalt_ini)%soil(isalt)
                    if (isalt <= size(cs_soil(j)%ly(1)%salt)) then
                      cs_soil(j)%ly(1)%salt(isalt) = cs_soil(j)%ly(1)%salt(isalt) + (1. - gc) * surf_frac * salt_kg
                      cs_soil(j)%ly(2)%salt(isalt) = cs_soil(j)%ly(2)%salt(isalt) + (1. - gc) * (1. - surf_frac) * salt_kg
                    end if
                  end do
                  exit
                end if
              end do
            end if
          end if
        end if
      end if

      ! --- heavy metals ---
      if (cs_db%num_metals > 0) then
        if (allocated(hmet_fert_soil_ini)) then
          if (size(fertdb_cbn) >= ifrt) then
            if (fertdb_cbn(ifrt)%hmet /= '') then
              do ihmet_ini = 1, size(hmet_fert_soil_ini)
                if (trim(fertdb_cbn(ifrt)%hmet) == trim(hmet_fert_soil_ini(ihmet_ini)%name)) then
                  do ihmet = 1, size(hmet_fert_soil_ini(ihmet_ini)%soil)
                    hmet_kg = frt_kg * hmet_fert_soil_ini(ihmet_ini)%soil(ihmet)
                    if (ihmet <= size(cs_soil(j)%ly(1)%hmet)) then
                      cs_soil(j)%ly(1)%hmet(ihmet) = cs_soil(j)%ly(1)%hmet(ihmet) + (1. - gc) * surf_frac * hmet_kg
                      cs_soil(j)%ly(2)%hmet(ihmet) = cs_soil(j)%ly(2)%hmet(ihmet) + (1. - gc) * (1. - surf_frac) * hmet_kg
                    end if
                  end do
                  exit
                end if
              end do
            end if
          end if
        end if
      end if

      ! --- other constituents ---
      if (cs_db%num_cs > 0) then
        if (allocated(cs_fert_soil_ini)) then
          if (size(fertdb_cbn) >= ifrt) then
            if (fertdb_cbn(ifrt)%cs /= '') then
              do ics_ini = 1, size(cs_fert_soil_ini)
                if (trim(fertdb_cbn(ifrt)%cs) == trim(cs_fert_soil_ini(ics_ini)%name)) then
                  do ics = 1, size(cs_fert_soil_ini(ics_ini)%soil)
                    cs_kg = frt_kg * cs_fert_soil_ini(ics_ini)%soil(ics)
                    if (ics <= size(cs_soil(j)%ly(1)%cs)) then
                      cs_soil(j)%ly(1)%cs(ics) = cs_soil(j)%ly(1)%cs(ics) + (1. - gc) * surf_frac * cs_kg
                      cs_soil(j)%ly(2)%cs(ics) = cs_soil(j)%ly(2)%cs(ics) + (1. - gc) * (1. - surf_frac) * cs_kg
                    end if
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
