      subroutine wallo_treatment (iwallo, idmd)
      
      use water_allocation_module
      use hydrograph_module
      use constituent_mass_module
      
      implicit none 

      integer, intent (in):: iwallo         !water allocation object number
      integer, intent (in) :: idmd          !water demand object number
      integer :: itrt = 0           !none       |treatment database number
      real :: loss_factor = 1.0     !factor for water loss during treatment
      
      !! get treatment database number from demand object
      itrt = wallo(iwallo)%dmd(idmd)%trt_num
      
      if (itrt > 0) then
        !! applying water treatment plant parameters
        !! calculate water loss during treatment
        loss_factor = 1.0 - wtp(itrt)%loss_fr
        
        !! treating water to wtp concentrations
        !! treated outflow is a fraction of withdrawal accounting for losses
        outflo_om = wtp_om_treat(itrt)
        outflo_om%flo = outflo_om%flo * wdraw_om_tot%flo * loss_factor
        
        !! convert concentration to mass
        call hyd_convert_conc_to_mass (outflo_om)
        
        !! treat constituents
        !! convert concentration to mass
        call hydcsout_conc_mass (outflo_om%flo, wtp_cs_treat(itrt), outflo_cs)
        
        !! store treated water output for the demand object
        wallo(iwallo)%dmd(idmd)%trt = outflo_om
        
        !! TODO: Implement treatment time lag (wtp(itrt)%lag_days)
        !! TODO: Implement storage capacity limits (wtp(itrt)%stor_mx)
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
      
      !! get use database number from demand object
      iuse = wallo(iwallo)%dmd(idmd)%trt_num
      
      if (iuse > 0) then
        !! applying water use plant parameters
        !! calculate water loss during treatment
        loss_factor = 1.0 - wuse(iuse)%loss_fr
        
        !! treating water to use concentrations
        !! treated outflow is a fraction of withdrawal accounting for losses
        outflo_om = wuse_om_efflu(iuse)
        outflo_om%flo = outflo_om%flo * wdraw_om_tot%flo * loss_factor
        
        !! convert concentration to mass
        call hyd_convert_conc_to_mass (outflo_om)
        
        !! store treated water output for the demand object
        wallo(iwallo)%dmd(idmd)%trt = outflo_om
        
        !! constituents effluent
        !! convert concentration to mass
        call hydcsout_conc_mass (outflo_om%flo, wuse_cs_efflu(iuse), outflo_cs)
        
        !! TODO: Implement treatment time lag (wuse(iuse)%lag_days)
        !! TODO: Implement storage capacity limits (wuse(iuse)%stor_mx)
      end if
      
      return
    end subroutine wallo_use