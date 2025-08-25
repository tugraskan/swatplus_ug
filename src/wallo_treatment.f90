      subroutine wallo_treatment (iwallo, idmd)
      
      use water_allocation_module
      use hydrograph_module
      use constituent_mass_module
      
      implicit none 

      integer, intent (in):: iwallo         !water allocation object number
      integer, intent (in) :: idmd          !water demand object number
      integer :: itrt = 0           !none       |treatment database number
      real :: loss_factor = 1.0     !factor for water loss during treatment
      real :: overflow = 0.0        !overflow from storage capacity limits
      real :: release_fraction = 0.0 !fraction released per day based on lag
      real :: release_flow = 0.0    !flow released from storage
      
      !! get treatment database number from demand object
      itrt = wallo(iwallo)%dmd(idmd)%trt_num
      
      if (itrt > 0 .and. itrt <= size(wtp)) then
        !! applying water treatment plant parameters
        !! calculate water loss during treatment
        loss_factor = 1.0 - wtp(itrt)%loss_fr
        
        !! treating water to wtp concentrations using cross-reference
        !! use the om_treat_idx to get the correct organic mineral treatment data
        if (wtp(itrt)%om_treat_idx > 0) then
          outflo_om = wtp_om_treat(wtp(itrt)%om_treat_idx)
        else
          !! if no cross-reference, use default or zero values
          outflo_om = wdraw_om_tot  ! pass through unchanged as fallback
        end if
        
        !! treated outflow is a fraction of withdrawal accounting for losses
        outflo_om%flo = wdraw_om_tot%flo * loss_factor
        
        !! convert concentration to mass
        call hyd_convert_conc_to_mass (outflo_om)
        
        !! treat constituents
        !! convert concentration to mass
        call hydcsout_conc_mass (outflo_om%flo, wtp_cs_treat(itrt), outflo_cs)
        
        !! implement storage capacity limits and time lag
        if (wtp(itrt)%stor_mx > 0.0 .and. wtp(itrt)%lag_days > 0.0) then
          !! add treated water to storage
          wtp(itrt)%stor_cur = wtp(itrt)%stor_cur + outflo_om%flo
          
          !! check storage capacity limits - overflow if exceeds capacity
          overflow = 0.0
          if (wtp(itrt)%stor_cur > wtp(itrt)%stor_mx) then
            overflow = wtp(itrt)%stor_cur - wtp(itrt)%stor_mx
            wtp(itrt)%stor_cur = wtp(itrt)%stor_mx
          end if
          
          !! calculate release fraction based on lag time
          release_fraction = min(1.0, 1.0 / wtp(itrt)%lag_days)
          release_flow = wtp(itrt)%stor_cur * release_fraction
          
          !! update storage after release
          wtp(itrt)%stor_cur = wtp(itrt)%stor_cur - release_flow
          
          !! adjust output flow to include overflow and lagged release
          outflo_om%flo = release_flow + overflow
        end if
        
        !! store treated water output for the demand object
        wallo(iwallo)%dmd(idmd)%trt = outflo_om
      end if
      
      return
    end subroutine wallo_treatment
    
    subroutine wallo_use (iwallo, idmd)
      
      use water_allocation_module
      use hydrograph_module
      use constituent_mass_module
      
      implicit none 

      integer, intent (in):: iwallo         !water allocation object number
      integer, intent (in) :: idmd          !water demand object number
      integer :: iuse = 0           !none       |treatment database number
      real :: loss_factor = 1.0     !factor for water loss during treatment
      real :: overflow = 0.0        !overflow from storage capacity limits
      real :: release_fraction = 0.0 !fraction released per day based on lag
      real :: release_flow = 0.0    !flow released from storage
      
      !! get use database number from demand object
      iuse = wallo(iwallo)%dmd(idmd)%trt_num
      
      if (iuse > 0 .and. iuse <= size(wuse)) then
        !! applying water use plant parameters
        !! calculate water loss during treatment
        loss_factor = 1.0 - wuse(iuse)%loss_fr
        
        !! treating water to use concentrations using cross-reference
        !! use the om_use_idx to get the correct organic mineral use data
        if (wuse(iuse)%om_use_idx > 0) then
          outflo_om = wuse_om_efflu(wuse(iuse)%om_use_idx)
        else
          !! if no cross-reference, use default or zero values
          outflo_om = wdraw_om_tot  ! pass through unchanged as fallback
        end if
        
        !! treated outflow is a fraction of withdrawal accounting for losses
        outflo_om%flo = wdraw_om_tot%flo * loss_factor
        
        !! convert concentration to mass
        call hyd_convert_conc_to_mass (outflo_om)
        
        !! store treated water output for the demand object
        wallo(iwallo)%dmd(idmd)%trt = outflo_om
        
        !! constituents effluent
        !! convert concentration to mass
        call hydcsout_conc_mass (outflo_om%flo, wuse_cs_efflu(iuse), outflo_cs)
        
        !! implement storage capacity limits and time lag
        if (wuse(iuse)%stor_mx > 0.0 .and. wuse(iuse)%lag_days > 0.0) then
          !! add treated water to storage
          wuse(iuse)%stor_cur = wuse(iuse)%stor_cur + outflo_om%flo
          
          !! check storage capacity limits - overflow if exceeds capacity
          overflow = 0.0
          if (wuse(iuse)%stor_cur > wuse(iuse)%stor_mx) then
            overflow = wuse(iuse)%stor_cur - wuse(iuse)%stor_mx
            wuse(iuse)%stor_cur = wuse(iuse)%stor_mx
          end if
          
          !! calculate release fraction based on lag time
          release_fraction = min(1.0, 1.0 / wuse(iuse)%lag_days)
          release_flow = wuse(iuse)%stor_cur * release_fraction
          
          !! update storage after release
          wuse(iuse)%stor_cur = wuse(iuse)%stor_cur - release_flow
          
          !! adjust output flow to include overflow and lagged release
          outflo_om%flo = release_flow + overflow
          
          !! update the treated water output with lagged flow
          wallo(iwallo)%dmd(idmd)%trt%flo = outflo_om%flo
        end if
      end if
      
      return
    end subroutine wallo_use