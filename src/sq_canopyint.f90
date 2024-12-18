      subroutine sq_canopyint

!!    ~ ~ ~ PURPOSE ~ ~ ~
!!    this subroutine computes canopy interception of rainfall
!!    used for methods other than curve number

!!    ~ ~ ~ INCOMING VARIABLES ~ ~ ~
!!    name        |units         |definition
!!    ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
!!    blai(:)     |none          |maximum (potential) leaf area index
!!    canmx(:)    |mm H2O        |maximum canopy storage
!!    canstor(:)  |mm H2O        |amount of water held in canopy storage
!!    wst(:)%weat%ts(:) |mm H2O        |precipitation in time step for HRU
!!    ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~

!!    ~ ~ ~ OUTGOING VARIABLES ~ ~ ~
!!    name        |units         |definition
!!    ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
!!    canstor(:)  |mm H2O        |amount of water held in canopy storage
!!    wst(:)%weat%ts(:) |mm H2O        |precipitation reaching soil surface in
!!                               |time step
!!    ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
!!    ~ ~ ~ ~ ~ ~ END SPECIFICATIONS ~ ~ ~ ~ ~ ~

      use basin_module
      use time_module
      use climate_module, only : wst, w
      use hru_module, only : hru, canstor,ihru, precip_eff
      use plant_module
      use hydrograph_module, only : ob
      
      implicit none

      real :: xx = 0.            !mm H2O        |precipitation prior to canopy interception 
      integer :: j = 0           !none          |HRU number
      integer :: ii = 0          !none          |counter
      real :: canmxl = 0.        !mm H2O        |maximum canopy storage at current day's leaf
                                 !              |area
      real :: canstori = 0.      !mm H2O        |initial canopy storage water content 
      integer :: iwst = 0        !none          |counter
      integer :: iob = 0
      !real :: precip_eff        !mm            |daily effective precip for runoff calculations = precipday + ls_overq + snomlt - canstor
                                 !     |precip_eff = precipday + ls_overq - snofall + snomlt - canstor
      
      j = ihru
      iob = hru(j)%obj_no
      iwst = ob(iob)%wst 

      if (pcom(j)%lai_sum < 0.001 .or. pcom(j)%laimx_sum < 0.001) return

      if (time%step > 1) then
          canstori = canstor(j)
          canmxl = hru(j)%hyd%canmx * pcom(j)%lai_sum / pcom(j)%laimx_sum
          do ii = 1, time%step
            xx = w%ts(ii)
            w%ts(ii) = w%ts(ii) - (canmxl - canstor(j))

            if (w%ts(ii) < 0.) then
              canstor(j) = canstor(j) + xx
              w%ts(ii) = 0.
            else
              canstor(j) = canmxl
            endif
          end do
          if (canstor(j) > canstori) then
            do ii = 1, time%step
              xx = 0.
              xx = wst(iwst)%weat%ts(ii)
              w%ts(ii) = w%ts(ii) - (canstor(j) - canstori)

              if (w%ts(ii) < 0.) then
                canstori = canstori + xx
                w%ts(ii) = 0.
              else
                canstori = canstor(j)
              endif
            end do
          end if

        else
          canmxl = hru(j)%hyd%canmx * pcom(j)%lai_sum / pcom(j)%laimx_sum
          !! check if precip_eff is less than remaining canopy storage
          if (precip_eff < canmxl - canstor(j)) then
            canstor(j) = canstor(j) + precip_eff
            precip_eff = 0.
          else
            precip_eff = precip_eff - (canmxl - canstor(j))
            canstor(j) = canmxl
          endif
    end if     ! time%step > 1

      return
      end subroutine sq_canopyint