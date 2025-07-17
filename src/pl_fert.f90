      subroutine pl_fert (ifrt, frt_kg, fertop)
      
!!    ~ ~ ~ PURPOSE ~ ~ ~
!!    this subroutine applies mineral and organic N and P specified by
!!    date and amount in the management file (.mgt).  After updating
!!    soil nutrient pools, any associated pesticide, pathogen, salt or
!!    heavy metal loads are added via fert_constituents_apply.
!!    ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~

!!    ~ ~ ~ SUBROUTINES/FUNCTIONS CALLED ~ ~ ~
!!    SWAT: Erfc

!!    ~ ~ ~ ~ ~ ~ END SPECIFICATIONS ~ ~ ~ ~ ~ ~

      use mgt_operations_module
      use fertilizer_data_module
      use basin_module
      use organic_mineral_mass_module
      use constituent_mass_module
      use hru_module, only : ihru, fertn, fertp, fertnh3, fertno3, fertorgn, fertorgp, fertp,  &
        fertsolp  
      implicit none 
      
      real :: rtof             !none          |weighting factor used to partition the 
                                          !              |organic N & P concentration of septic effluent
                                          !              |between the fresh organic and the stable organic pools
      integer :: j = 0                    !none          |hru counter
      integer :: l = 0                    !none          |layer counter 
      integer, intent (in) :: ifrt        !              |fertilizer type from fert data base
      integer, intent (in) :: fertop      !              |fertilizer operation type
      real, intent (in) :: frt_kg         !kg/ha         |total mass of fertilizer applied
      real :: fr_ly = 0.                  !fraction      |fraction of fertilizer applied to layer
      real :: m_kg                        !kg/ha         |mass of fertilizer applied to layer
      real :: c_kg                        !kg/ha         |mass of carbon applied to layer
      real :: c_n_rto                     !              |carbon nitrogen ratio
      real :: meta_fr                     !              |fraction of metabolic applied to layer
      real :: pool_fr                     !              |fraction of structural or lignin applied to layer
      logical :: manure_flag
      manure_flag = .false.
      org_frt%m = 0.
      org_frt%c = 0.
      org_frt%n = 0.
      org_frt%p = 0.
      c_n_rto = 0.
      meta_fr = 0.

      j = ihru
      
      rtof = man_coef%rtof
      !! calculate c:n ratio for manure applications for SWAT-C
      if (bsn_cc%cswat == 2) then
        if (fertdb(ifrt)%forgn > 0. .or. fertdb(ifrt)%forgp > 0. ) then
          manure_flag = .true.
        endif
        
        if (manure_flag) then
          org_frt%m = frt_kg
          org_frt%c = man_coef%man_to_c * frt_kg
          org_frt%n = fertdb(ifrt)%forgn * frt_kg
          org_frt%p = fertdb(ifrt)%forgp * frt_kg
          c_n_rto = .175 * org_frt%c / (fertdb(ifrt)%fminn + fertdb(ifrt)%forgn + 1.e-5)
          !! meta_fr is the fraction of fertilizer that is allocated to metabolic litter pool
          meta_fr = .85 - .018 * c_n_rto
        endif

        if (meta_fr < 0.01) then
          meta_fr = 0.01
        else
          if (meta_fr > .7) then
            meta_fr = .7
          end if
        end if
      end if
      
      !! add fertilizer to first and/or second layer
      do l = 1, 2
        if (l == 1) then
          fr_ly = chemapp_db(fertop)%surf_frac
        else
          fr_ly = 1. - chemapp_db(fertop)%surf_frac                     
        endif

        !! add mineral n and p for all methods
        soil1(j)%mn(l)%no3 = soil1(j)%mn(l)%no3 + fr_ly * frt_kg *          &
                       (1. - fertdb(ifrt)%fnh3n) * fertdb(ifrt)%fminn
        soil1(j)%mn(l)%nh4 = soil1(j)%mn(l)%nh4 + fr_ly * frt_kg *          &
                       fertdb(ifrt)%fnh3n * fertdb(ifrt)%fminn
        soil1(j)%mp(l)%lab = soil1(j)%mp(l)%lab + fr_ly * frt_kg *          & 
                       fertdb(ifrt)%fminp

        !! add total organic n and p for all methods
        soil1(j)%tot(l)%n = soil1(j)%tot(l)%n + rtof * fr_ly * frt_kg *     &
                       fertdb(ifrt)%forgn
        soil1(j)%tot(l)%p = soil1(j)%tot(l)%p + rtof * fr_ly * frt_kg *     &
                       fertdb(ifrt)%forgp

        !! for stable carbon - add n and p to active humus pool
        if (bsn_cc%cswat == 0) then
          soil1(j)%rsd(l)%n = soil1(j)%rsd(l)%n + rtof * fr_ly * &
                       frt_kg * fertdb(ifrt)%forgn
          soil1(j)%rsd(l)%p = soil1(j)%rsd(l)%p + rtof * fr_ly * frt_kg *           &
                       fertdb(ifrt)%forgp
          soil1(j)%hact(l)%n = soil1(j)%hact(l)%n + (1. - rtof) * fr_ly *           &
                       frt_kg * fertdb(ifrt)%forgn
          soil1(j)%hact(l)%p = soil1(j)%hsta(l)%p + (1. - rtof) * fr_ly * frt_kg *  &
                       fertdb(ifrt)%forgp
        end if
        
        !! for C-FARM add to manure pool - assume C:N ratio = 10
        if (bsn_cc%cswat == 1) then
          soil1(j)%man(l)%c = soil1(j)%man(l)%c + fr_ly * frt_kg * fertdb(ifrt)%forgn * 10.
          soil1(j)%man(l)%n = soil1(j)%man(l)%n + fr_ly * frt_kg * fertdb(ifrt)%forgn
          soil1(j)%man(l)%p = soil1(j)%man(l)%p + fr_ly * frt_kg * fertdb(ifrt)%forgp
        end if

        !! for SWAT-C add to slow humus pool and fresh residue pools
        if (bsn_cc%cswat == 2 .and. manure_flag) then
          
          !! add 1-rtof to slow humus pool
          pool_fr = (1. - rtof) * fr_ly
          soil1(j)%tot(l) = soil1(j)%tot(l) + pool_fr * org_frt
          soil1(j)%hs(l) = soil1(j)%hs(l) + pool_fr * org_frt
        
          !! add rtof to fresh residue pools
          !! add metabolic manure pool
          pool_fr = (1. - rtof) * meta_fr * fr_ly
          soil1(j)%meta(l) = soil1(j)%meta(l) + pool_fr * org_frt
           
          !! add structural manure pool
          pool_fr = (1. - rtof) * (1. - meta_fr) * fr_ly
          soil1(j)%str(l) = soil1(j)%str(l) + pool_fr * org_frt
          
          !! add lignin manure pool
          soil1(j)%lig(l) = soil1(j)%lig(l) + 0.175 * pool_fr * org_frt
          
          !! total residue pool is metabolic + structural
          ! soil1(j)%rsd(l) = soil1(j)%meta(l) + soil1(j)%str(l)
          
        end if
        
      end do 

      !! summary calculations
      fertno3 = frt_kg * fertdb(ifrt)%fminn * (1. - fertdb(ifrt)%fnh3n)
      fertnh3 = frt_kg * (fertdb(ifrt)%fminn * fertdb(ifrt)%fnh3n)
      fertorgn = frt_kg * fertdb(ifrt)%forgn
      fertsolp = frt_kg * fertdb(ifrt)%fminp
      fertorgp = frt_kg * fertdb(ifrt)%forgp  
      fertn = fertn + frt_kg * (fertdb(ifrt)%fminn + fertdb(ifrt)%forgn)
      fertp = fertp + frt_kg * (fertdb(ifrt)%fminp + fertdb(ifrt)%forgp)


      !! apply constituents associated with this fertilizer
      !! the helper cross-references pest/path/salt/hmet/cs names from
      !! fertilizer_ext.frt and distributes the resulting loads
      call fert_constituents_apply(j, ifrt, frt_kg, fertop)

      
      !! apply pesticides associated with this fertilizer, done in fert_constituents_apply now
      !if (cs_db%num_pests > 0) then
      !  if (allocated(pest_fert_soil_ini)) then
      !    if (size(manure_db) >= ifrt) then
      !      if (manure_db(ifrt)%pest /= '') then
      !        do ipest_ini = 1, size(pest_fert_soil_ini)
      !          if (trim(manure_db(ifrt)%pest) == trim(pest_fert_soil_ini(ipest_ini)%name)) then
      !            do ipest = 1, cs_db%num_pests
      !              pest_kg = frt_kg * pest_fert_soil_ini(ipest_ini)%soil(ipest)
      !              if (pest_kg > 0.) call pest_apply (j, ipest, pest_kg, fertop)
      !            end do
      !            exit
      !          end if
      !        end do
      !      end if
      !    end if
      !  end if
      !end if
      
      return
      end subroutine pl_fert
