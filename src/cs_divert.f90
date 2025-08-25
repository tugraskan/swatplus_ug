      subroutine cs_divert(iwallo,idmd,dem_id) !rtb cs
      
      implicit none
      
      integer, intent(in) :: iwallo    ! water allocation object number
      integer, intent(in) :: idmd     ! demand object number  
      integer, intent(in) :: dem_id   ! demand id
      
!!    ~ ~ ~ PURPOSE ~ ~ ~
!!    this subroutine adds cs mass to the channel, and and removes cs mass
!!    from the source object
      
      return
      end !cs_divert