      subroutine wallo_transfer (iwallo, idmd)
      
      use water_allocation_module
      use hydrograph_module
      use constituent_mass_module
      use sd_channel_module
      use aquifer_module
      use reservoir_module
      use time_module
      
      implicit none 

      integer, intent (in):: iwallo         !water allocation object number
      integer, intent (in) :: idmd          !water demand object number
      integer :: j = 0               !none       |object number of specific type (cha, res, aqu, etc)
      integer :: ircv = 0            !none       |receiving object sequential number

      !! move outgoing water (ht5) to receiving objects
      do ircv = 1, wallo(iwallo)%dmd(idmd)%rcv_num
        j = wallo(iwallo)%dmd(idmd)%rcv(ircv)%rcv_num
        
        !! comput conveyence losses
        !! decide if we want to lag outflows
            
        !! add water to receiving object
        select case (wallo(iwallo)%dmd(idmd)%rcv(ircv)%rcv_typ)
      
        case ("cha")
          !! channel transfer
          !save and add to channel when it's called
            
        case ("res")
          !! reservoir transfer
          res(j) = res(j) + wallo(iwallo)%dmd(idmd)%rcv(ircv)%frac * outflo_om
          res_water(j) = res_water(j) + wallo(iwallo)%dmd(idmd)%rcv(ircv)%frac * outflo_cs
            
        case ("aqu")
          !! aquifer transfer
          aqu(j) = aqu(j) + wallo(iwallo)%dmd(idmd)%rcv(ircv)%frac * outflo_om
          cs_aqu(j) = cs_aqu(j) + wallo(iwallo)%dmd(idmd)%rcv(ircv)%frac * outflo_cs
            
        case ("use")
          !! water use (domestic, industrial, commercial) 
          wuse_om_stor(j) = wuse_om_stor(j) + wallo(iwallo)%dmd(idmd)%rcv(ircv)%frac * outflo_om
          wuse_cs_stor(j) = wuse_cs_stor(j) + wallo(iwallo)%dmd(idmd)%rcv(ircv)%frac * outflo_cs
            
        case ("wtp")
          !! wastewater treatment 
          wtp_om_stor(j) = wtp_om_stor(j) + wallo(iwallo)%dmd(idmd)%rcv(ircv)%frac * outflo_om
          wtp_cs_stor(j) = wtp_cs_stor(j) + wallo(iwallo)%dmd(idmd)%rcv(ircv)%frac * outflo_cs
              
        case ("stor")
          !! water storage - don't change concentrations or compute outflow
          wtow_om_stor(j) = wtow_om_stor(j) + wallo(iwallo)%dmd(idmd)%rcv(ircv)%frac * outflo_om
          wtow_cs_stor(j) = wtow_cs_stor(j) + wallo(iwallo)%dmd(idmd)%rcv(ircv)%frac * outflo_cs
           
        case ("canal")
          !! water storage - don't change concentrations or compute outflow
          canal_om_stor(j) = canal_om_stor(j) + wallo(iwallo)%dmd(idmd)%rcv(ircv)%frac * outflo_om
          canal_cs_stor(j) = canal_cs_stor(j) + wallo(iwallo)%dmd(idmd)%rcv(ircv)%frac * outflo_cs
           
        end select
      end do     
      
      return
      end subroutine wallo_transfer