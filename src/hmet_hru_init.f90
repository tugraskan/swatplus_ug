!--------------------------------------------------------------------
!  hmet_hru_init
!    Allocate and initialize heavy metal pools for each HRU based on
!    the hmet_hru_aqu_read inputs.  Soil layers are populated with
!    starting concentrations and irrigation water values are set to
!    zero.
!--------------------------------------------------------------------
subroutine hmet_hru_init

  use hru_module, only : hru, sol_plt_ini
  use soil_module
  use constituent_mass_module
  use hydrograph_module, only : sp_ob

  implicit none

  integer :: ihru = 0
  integer :: ihmet = 0
  integer :: ihmet_db = 0
  integer :: ly = 0
  integer :: npmx = 0
  integer :: isp_ini = 0

  npmx = cs_db%num_metals

  do ihru = 1, sp_ob%hru
    if (npmx > 0) then
      do ly = 1, soil(ihru)%nly
        allocate(cs_soil(ihru)%ly(ly)%hmet(npmx), source = 0.)
      end do
      allocate(cs_irr(ihru)%hmet(npmx), source = 0.)
    end if

    isp_ini = hru(ihru)%dbs%soil_plant_init
    ihmet_db = sol_plt_ini(isp_ini)%hmet

    if (npmx > 0 .and. ihmet_db > 0) then
      do ihmet = 1, npmx
        do ly = 1, soil(ihru)%nly
          if (ly == 1) then
            cs_soil(ihru)%ly(1)%hmet(ihmet) = hmet_soil_ini(ihmet_db)%soil(ihmet)
          else
            cs_soil(ihru)%ly(ly)%hmet(ihmet) = 0.
          end if
        end do
      end do
      cs_irr(ihru)%hmet = 0.
    end if
  end do

  return
end subroutine hmet_hru_init
