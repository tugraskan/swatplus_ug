!!@summary Initialize 2D groundwater aquifer channel connectivity and flow distribution parameters
!!@description This subroutine initializes parameters needed for the 2D groundwater flow model to distribute
!! groundwater discharge to channels using a geomorphological approach. It sets up channel drainage areas,
!! creates linked lists ordered by drainage area for flow distribution calculations, establishes aquifer-channel
!! connectivity, and allocates memory for constituent transport in aquifer-channel interactions.
!!@arguments
!! This subroutine has no explicit arguments - it operates on global aquifer and channel module variables
      subroutine aqu2d_init
    
      use hydrograph_module
      use sd_channel_module
      use maximum_data_module
      use constituent_mass_module

      implicit none

      integer :: iaq = 0                        !!none | aquifer counter
      integer :: mfe = 0                        !!none | first element index (channel with smallest drainage area)
      integer :: next1 = 0                      !!none | next element counter
      integer :: iprv = 0                       !!none | previous element counter 
      integer :: ipts = 0                       !!none | points counter
      integer :: npts = 0                       !!none | number of points
      integer :: icha = 0                       !!none | channel counter
      integer :: ichd = 0                       !!none | channel data index
      integer :: iob = 0                        !!none | object counter
      real :: sum_len = 0.                      !!km | total length of channels in aquifer
      real, dimension(:), allocatable :: next   !!none | next channel to dry up - sorted by drainage area
      
      !! Initialize groundwater flow distribution parameters for 2D aquifer model
      if (db_mx%aqu2d <= 0) return
      do iaq = 1, sp_ob%aqu
        !! Allocate and set channel drainage area arrays
        allocate (aq_ch(iaq)%ch(aq_ch(iaq)%num_tot))
        allocate (aqu_cha(aq_ch(iaq)%num_tot))
        allocate (next(aq_ch(iaq)%num_tot), source = 0.)
        sum_len = 0.
        !! Loop through channels connected to this aquifer
        do icha = 1, aq_ch(iaq)%num_tot
          ich = aq_ch(iaq)%num(icha)
          sd_ch(ich)%aqu_link = iaq
          sd_ch(ich)%aqu_link_ch = icha
          iob = sp_ob1%chandeg + ich - 1
          ichd = ob(iob)%props
          aqu_cha(icha)%area = ob(iob)%area_ha
          aqu_cha(icha)%len = sd_chd(ichd)%chl
          sum_len = sum_len + sd_chd(ichd)%chl
        end do
          
        !! Create linked list ordered by drainage area for flow distribution
        mfe = 1
        do icha = 2, aq_ch(iaq)%num_tot
          next1 = mfe
          npts = icha - 1
          do ipts = 1, npts
            if (aqu_cha(icha)%area < aqu_cha(next1)%area) then
              next(icha) = next1
              if (ipts == 1) then
                mfe = icha
              else
                next(iprv) = icha
              end if
              exit
            end if
            iprv = next1
            next1 = next(next1)
          end do
          if (npts > 0 .and. ipts == npts + 1) then
            next(iprv) = icha
          end if
        end do
            
        !! set the sorted object- aq_ch
        next1 = mfe
        do icha = 1, aq_ch(iaq)%num_tot
          aq_ch(iaq)%ch(icha) = aqu_cha(next1)
          next1 = next(next1)
        end do
        
        !! save total channel length in aquifer
        aq_ch(iaq)%len_tot = sum_len
        
        !! compute length of channel left when current channel dries up
        do icha = 1, aq_ch(iaq)%num_tot
          sum_len = sum_len - aq_ch(iaq)%ch(icha)%len
          aq_ch(iaq)%ch(icha)%len_left = sum_len
        end do

        deallocate (aqu_cha)
        deallocate (next)
        
      end do

      !rtb salt/cs
      if(cs_db%num_tot > 0) then
        allocate (aq_chcs(sp_ob%aqu))
        do iaq = 1, sp_ob%aqu
          !allocate groundwater loading array
          allocate (aq_chcs(iaq)%hd(1))
          !salts
          if(cs_db%num_salts > 0) then
            allocate (aq_chcs(iaq)%hd(1)%salt(cs_db%num_salts), source = 0.)
            aq_chcs(iaq)%hd(1)%salt = 0.
          endif
          !other constituents
          if(cs_db%num_cs > 0) then
            allocate (aq_chcs(iaq)%hd(1)%cs(cs_db%num_cs), source = 0.)
            aq_chcs(iaq)%hd(1)%cs = 0.
          endif
        enddo
      endif

      
      return
      end subroutine aqu2d_init