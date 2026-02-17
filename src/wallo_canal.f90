      subroutine wallo_canal (iwallo, itrn, ican)
      
      use water_allocation_module
      use hydrograph_module
      use constituent_mass_module
      
      implicit none 

      integer, intent (in):: iwallo     !water allocation object number
      integer, intent (in) :: ican      !water transfer object number
      integer, intent (in) :: itrn      !water treatment plant object number
      
      !! compute outflow from canal using decision table or simple lag
      if (canal(ican)%dtbl == "null") then
        !! simple drawdown days
          wallod_out(iwallo)%trn(itrn)%trn_flo = canal_om_stor(ican)%flo / canal(ican)%ddown_days
      else
        !! decision table to condition outflow from canal
      end if
      
      !! outflow is the fraction of the withdrawal from the canal
      outflo_om = (wallod_out(iwallo)%trn(itrn)%trn_flo / canal_om_stor(ican)%flo) * canal_om_stor(ican)
      
      !! amount that is removed
      wal_tr_omd(ican) = canal_om_stor(ican) - wal_omd(iwallo)%trn(itrn)%h_tot
      
      !! organic hydrograph being transfered from the source to the receiving object
      !wal_omd(iwallo)%trn(itrn)%src(isrc)%hd = (1. - canal(ican)%loss_fr) *                &
      !                                             wal_omd(iwallo)%trn(itrn)%src(isrc)%hd
      !! add to aquifers
      
      outflo_om = hz
      
    return
    end subroutine wallo_canal