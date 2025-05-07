      subroutine water_allocation_read
      
      use input_file_module
      use water_allocation_module
      use mgt_operations_module
      use maximum_data_module
      use hydrograph_module
      use sd_channel_module
      use conditional_module
      use hru_module, only : hru
      
      implicit none 
      
      character (len=80) :: titldum = ""!           |title of file
      character (len=80) :: header = "" !           |header of file
      integer :: eof = 0              !           |end of file
      integer :: imax = 0             !none       |determine max number for array (imax) and total number in file
      logical :: i_exist              !none       |check to determine if file exists
      integer :: i = 0                !none       |counter
      integer :: k = 0                !none       |counter
      integer :: isrc = 0             !none       |counter
      integer :: iwro = 0             !none       |number of water allocation objects
      integer :: num_objs = 0
      integer :: num_src = 0
      integer :: num_rcv = 0
      integer :: idmd = 0
      integer :: idb = 0
      integer :: idb_irr = 0
      integer :: ihru = 0
      integer :: isrc_wallo = 0
      integer :: div_found = 0
      
      eof = 0
      imax = 0
      
      !! read water allocation inputs

      inquire (file=in_watrts%transfer_wro, exist=i_exist)
      if (.not. i_exist .or. in_watrts%transfer_wro == "null") then
        allocate (wallo(0:0))
      else
      do 
        open (107,file=in_watrts%transfer_wro)
        read (107,*,iostat=eof) titldum
        if (eof < 0) exit
        read (107,*,iostat=eof) imax
        db_mx%wallo_db = imax
        if (eof < 0) exit
        
        allocate (wallo(imax))
        allocate (wallod_out(imax))
        allocate (wallom_out(imax))
        allocate (walloy_out(imax))
        allocate (walloa_out(imax))

        do iwro = 1, imax
          read (107,*,iostat=eof) header
          if (eof < 0) exit
          read (107,*,iostat=eof) wallo(iwro)%name, wallo(iwro)%rule_typ, wallo(iwro)%src_obs, &
                                                    wallo(iwro)%dmd_obs
          
          if (eof < 0) exit
          read (107,*,iostat=eof) header
          if (eof < 0) exit
          num_objs = wallo(iwro)%src_obs
          allocate (wallo(iwro)%src(num_objs))
          num_objs = wallo(iwro)%dmd_obs
          allocate (wallo(iwro)%dmd(num_objs))
          allocate (wallod_out(iwro)%dmd(num_objs))
          allocate (wallom_out(iwro)%dmd(num_objs))
          allocate (walloy_out(iwro)%dmd(num_objs))
          allocate (walloa_out(iwro)%dmd(num_objs))
                    
          !! read source object data
          do isrc = 1, wallo(iwro)%src_obs
            read (107,*,iostat=eof) i
            wallo(iwro)%src(i)%num = i
            if (eof < 0) exit
            backspace (107)
              read (107,*,iostat=eof) k, wallo(iwro)%src(i)%ob_typ, wallo(iwro)%src(i)%ob_num,    &
                                                                  wallo(iwro)%src(i)%limit_mon
          end do
          
          !! read demand object data
          read (107,*,iostat=eof) header
          if (eof < 0) exit
          do idmd = 1, num_objs
            read (107,*,iostat=eof) i
            wallo(iwro)%dmd(i)%num = i
            if (eof < 0) exit
            backspace (107)
            read (107,*,iostat=eof) k, wallo(iwro)%dmd(i)%ob_typ, wallo(iwro)%dmd(i)%ob_num,            &
              wallo(iwro)%dmd(i)%dmd_typ, wallo(iwro)%dmd(i)%dmd_typ_name, wallo(iwro)%dmd(i)%amount,   &
              wallo(iwro)%dmd(i)%right, wallo(iwro)%dmd(i)%src_num, wallo(iwro)%dmd(i)%rcv_num
            num_src = wallo(iwro)%dmd(i)%src_num
            allocate (wallo(iwro)%dmd(i)%src(num_src))
            allocate (wallod_out(iwro)%dmd(i)%src(num_src))
            allocate (wallom_out(iwro)%dmd(i)%src(num_src))
            allocate (walloy_out(iwro)%dmd(i)%src(num_src))
            allocate (walloa_out(iwro)%dmd(i)%src(num_src))
            num_rcv = wallo(iwro)%dmd(i)%rcv_num
            allocate (wallo(iwro)%dmd(i)%rcv(num_rcv))
            
            !! for hru irrigation, need to xwalk with irrigation demand decision table
            if (wallo(iwro)%dmd(i)%ob_typ == "hru") then
              !! xwalk with lum decision table
              do idb = 1, db_mx%dtbl_lum
                if (wallo(iwro)%dmd(i)%withdr == dtbl_lum(idb)%name) then
                  ihru = wallo(iwro)%dmd(i)%ob_num
                  hru(ihru)%irr_dmd_dtbl = idb
                  do idb_irr = 1, db_mx%irrop_db 
                    if (dtbl_lum(idb)%act(1)%option == irrop_db(idb_irr)%name) then
                      wallo(iwro)%dmd(idmd)%irr_eff = irrop_db(idb_irr)%eff
                      wallo(iwro)%dmd(idmd)%surq = irrop_db(idb_irr)%surq
                      exit
                    end if
                  end do
                end if
              end do
            end if
            
            !! for municipal and divert demands, can use recall for daily, monthly, or annual withdrawals
            if (wallo(iwro)%dmd(i)%ob_typ == "muni" .or. wallo(iwro)%dmd(i)%ob_typ == "divert") then
              if (wallo(iwro)%dmd(i)%withdr /= "ave_day") then
                !! xwalk with recall database
                do idb = 1, db_mx%dtbl_flo
                  if (wallo(iwro)%dmd(i)%withdr == dtbl_flo(idb)%name) then
                    wallo(iwro)%dmd(i)%rec_num = idb
                    exit
                  end if
                end do
              end if
            end if
          
            !! for municipal treatment - recall option for daily, monthly, or annual mass
            if (wallo(iwro)%dmd(i)%treat_typ == "recall") then
              !! xwalk with recall database
              do idb = 1, db_mx%recall_max
                if (wallo(iwro)%dmd(i)%treatment == recall(idb)%name) then
                  wallo(iwro)%dmd(i)%trt_num = idb
                  exit
                end if
              end do
            end if
            
            read (107,*,iostat=eof) k, wallo(iwro)%dmd(i)%ob_typ, wallo(iwro)%dmd(i)%ob_num,            &
              wallo(iwro)%dmd(i)%dmd_typ, wallo(iwro)%dmd(i)%dmd_typ_name, wallo(iwro)%dmd(i)%amount,   &
              wallo(iwro)%dmd(i)%right, wallo(iwro)%dmd(i)%src_num, 
              (wallo(iwro)%dmd(i)%src(isrc), isrc = 1, num_objs), wallo(iwro)%dmd(i)%rcv_num,           &
              wallo(iwro)%dmd(i)%rcv_ob, wallo(iwro)%dmd(i)%rcv_num, wallo(iwro)%dmd(i)%rcv_dtl,        &
              (wallo(iwro)%dmd(i)%src(isrc), isrc = 1, num_objs)
            
            backspace (107)
            read (107,*,iostat=eof) k, wallo(iwro)%dmd(i)%ob_typ, wallo(iwro)%dmd(i)%ob_num,    &
              wallo(iwro)%dmd(i)%withdr, wallo(iwro)%dmd(i)%amount, wallo(iwro)%dmd(i)%right,   &
              wallo(iwro)%dmd(i)%treat_typ, wallo(iwro)%dmd(i)%treatment,  wallo(iwro)%dmd(i)%rcv_ob,   &
              wallo(iwro)%dmd(i)%rcv_num, wallo(iwro)%dmd(i)%rcv_dtl,                           &
              wallo(iwro)%dmd(i)%dmd_src_obs, (wallo(iwro)%dmd(i)%src(isrc), isrc = 1, num_objs)

            !! set object name and number for each source for each demand object
            do isrc = 1, num_objs
              isrc_wallo = wallo(iwro)%dmd(i)%src(isrc)%src
              wallo(iwro)%dmd(i)%src_ob(isrc)%ob_typ = wallo(iwro)%src(isrc_wallo)%ob_typ
              wallo(iwro)%dmd(i)%src_ob(isrc)%ob_num = wallo(iwro)%src(isrc_wallo)%ob_num
            end do
            
            !! zero output variables for summing
            do isrc = 1, num_objs
              wallod_out(iwro)%dmd(i)%src(isrc) = walloz
              wallom_out(iwro)%dmd(i)%src(isrc) = walloz
              walloy_out(iwro)%dmd(i)%src(isrc) = walloz
              walloa_out(iwro)%dmd(i)%src(isrc) = walloz
            end do
            
          end do
          
          !if canal diversions are used as source water, read in the number of days that diversion water can be
          !available for irrigation (rtb)
          div_found = 0
          do isrc = 1, wallo(iwro)%src_obs
            if(wallo(iwro)%src(isrc)%ob_typ == "div") then
              div_found = 1
            endif
          enddo
          if(div_found == 1) then
            !prepare array
            allocate (div_volume_daily(sp_ob%recall), source = 0.)
            allocate (div_volume_total(sp_ob%recall), source = 0.)
            allocate (div_volume_used(sp_ob%recall), source = 0.)
            div_volume_daily = 0.
            div_volume_total = 0.
            div_volume_used = 0.
            !read the days parameter
            read(107,*)
            read(107,*) div_delay
            div_delay = Exp(-1./(div_delay + 1.e-6))
          endif
          
        end do

        exit
      end do
      end if
      close(107)

      return
      end subroutine water_allocation_read