      subroutine water_use_read
      
      use input_file_module
      use water_allocation_module
      use mgt_operations_module
      use maximum_data_module
      use hydrograph_module
      use constituent_mass_module
      use sd_channel_module
      
      implicit none 
      
      character (len=80) :: titldum = ""!         |title of file
      character (len=80) :: header = "" !         |header of file
      integer :: eof = 0              !           |end of file
      integer :: imax = 0             !none       |determine max number for array (imax) and total number in file
      logical :: i_exist              !none       |check to determine if file exists
      integer :: i = 0                !none       |counter
      integer :: iwuse = 0            !none       |number of water treatment objects
      integer :: iom = 0              !none       |counter
      
      eof = 0
      imax = 0
      
      !! read water allocation inputs

      inquire (file='water_use.wal', exist=i_exist)
      if (.not. i_exist .or. 'water_use.wal' == "null") then
        allocate (wuse(0:0))
      else
      do 
        open (107,file='water_use.wal')
        read (107,*,iostat=eof) titldum
        if (eof < 0) exit
        read (107,*,iostat=eof) imax
        read (107,*,iostat=eof) header
        db_mx%uses = imax
        if (eof < 0) exit
        
        allocate (wuse(imax))          
        allocate (wuse_om_stor(imax))
        allocate (wuse_om_out(imax))
        allocate (wuse_cs_stor(imax))
        allocate (wal_use_omd(imax))
        allocate (wal_use_omm(imax))
        allocate (wal_use_omy(imax))
        allocate (wal_use_oma(imax))

        do iwuse = 1, imax
          !! water_use.wal column order (v2): num name use_typ stor_mx lag_days loss_fr
          !!   org_min pests paths salts constit descrip
          !! use_typ tokens: dom ind com mun agr lsk pwr rec oth
          read (107,*,iostat=eof) i, wuse(iwuse)%name, wuse(iwuse)%use_typ,       &
                                     wuse(iwuse)%stor_mx,                          &
                                     wuse(iwuse)%lag_days, wuse(iwuse)%loss_fr,   &
                                     wuse(iwuse)%org_min, wuse(iwuse)%pests,      &
                                     wuse(iwuse)%paths, wuse(iwuse)%salts,        &
                                     wuse(iwuse)%constit, wuse(iwuse)%descrip
          if (eof < 0) exit

          !! validate use_typ; default to "oth" for unrecognised tokens
          select case (trim(wuse(iwuse)%use_typ))
            case ("dom","ind","com","mun","agr","lsk","pwr","rec","oth")
              !! valid token - no action needed
            case default
              wuse(iwuse)%use_typ = "oth"
          end select
          
          !! crosswalk organic mineral with 
          do iom = 1, db_mx%om_use
            if (om_use_name(iom) == wuse(iwuse)%org_min) then
              wuse(iwuse)%iorg_min = iom
              exit
            end if
          end do
            
          !! read pseticide concentrations of treated water
          if (cs_db%num_pests > 0) then
            allocate (wuse_cs_efflu(iwuse)%pest(cs_db%num_pests))
            read (107,*,iostat=eof) header
            read (107,*,iostat=eof) wuse_cs_efflu(iwuse)%pest
          end if
          
          !! read pathogen concentrations of treated water
          if (cs_db%num_paths > 0) then
            allocate (wuse_cs_efflu(iwuse)%path(cs_db%num_paths))
            read (107,*,iostat=eof) header
            read (107,*,iostat=eof) wuse_cs_efflu(iwuse)%path
          end if
        end do
          
        exit
      end do
      end if
      close(107)

      return
    end subroutine water_use_read