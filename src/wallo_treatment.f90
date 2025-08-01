      subroutine wallo_treatment (iwallo, idmd)
      
      use water_allocation_module
      use hydrograph_module
      use constituent_mass_module
      
      implicit none 

      integer, intent (in):: iwallo         !water allocation object number
      integer, intent (in) :: idmd          !water demand object number
      integer :: itrt = 0           !none       |treatment database number
      
      !! treating water to wtp or use concentrations
      !! treated outflow is a fraction of withdrawal
      outflo_om = wtp_om_treat(itrt)
      outflo_om%flo = outflo_om%flo * wdraw_om_tot%flo
      
      !! convert concentration to mass
      call hyd_convert_conc_to_mass (outflo_om)
      
      !! treat constituents
      !! convert concentration to mass
      call hydcsout_conc_mass (outflo_om%flo, wtp_cs_treat(itrt), outflo_cs)
      
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
      
      !! treating water to wtp or use concentrations
      !! treated outflow is a fraction of withdrawal
      outflo_om = wuse_om_efflu(iuse)
      outflo_om%flo = outflo_om%flo * wdraw_om_tot%flo
      
      !! convert concentration to mass
      call hyd_convert_conc_to_mass (outflo_om)
      !wallo(iwallo)%dmd(idmd)%trt = ht5   !need to output how much was remoed or added?
      
      !! constituents effluent
      !! convert concentration to mass
      call hydcsout_conc_mass (outflo_om%flo, wuse_cs_efflu(iuse), outflo_cs)
      
      return
    end subroutine wallo_use