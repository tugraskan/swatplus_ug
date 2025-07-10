subroutine fert_parm_read
      
      use input_file_module
      use maximum_data_module
      use fertilizer_data_module
      
      implicit none
   
      integer :: it = 0               !none       |counter
      character (len=80) :: titldum = ""!           |title of file
      character (len=80) :: header = "" !           |header of file
      integer :: eof = 0              !           |end of file
      integer :: imax = 0             !none       |determine max number for array (imax) and total number in file
      integer :: mfrt = 0             !           |
      logical :: i_exist              !none       |check to determine if file exists
      logical :: i_exist_cbn          !none       |check to determine if fertilizer_ext.frt exists
      
      
      eof = 0
      imax = 0
      mfrt = 0
      
      !! check if fertilizer_ext.frt exists, if so use it instead of fertilizer.frt
      inquire (file='fertilizer_ext.frt', exist = i_exist_cbn)
        if (.not. i_exist_cbn) then
           allocate (fertdb_cbn(0:0)) 
        else
            in_parmdb%fert_frt = 'fertilizer_ext.frt'
        endif

      
      inquire (file=in_parmdb%fert_frt, exist=i_exist)
      if (.not. i_exist .or. in_parmdb%fert_frt == "null") then
         allocate (fertdb(0:0))
      else
          do  
            open (107,file=in_parmdb%fert_frt)
            read (107,*,iostat=eof) titldum
            if (eof < 0) exit
            read (107,*,iostat=eof) header
            if (eof < 0) exit
               do while (eof == 0) 
                 read (107,*,iostat=eof) titldum
                 if (eof < 0) exit
                 imax = imax + 1
               end do
           
            allocate (fertdb(0:imax))
        
            rewind (107)
            read (107,*,iostat=eof) titldum
            if (eof < 0) exit
            read (107,*,iostat=eof) header
            if (eof < 0) exit
            
            !! read in original fertilizer.frt if not use the fertilizer_ext.frt
            if  (.not. i_exist_cbn) then
              do it = 1, imax
                read (107,*,iostat=eof) fertdb(it)
                if (eof < 0) exit
              end do
            else
              ! If fertilizer_ext.frt exists, read fertilizer_cbn data
              allocate (fertdb_cbn(0:imax))
              do it = 1, imax
                read (107,*,iostat=eof) fertdb_cbn(it)%base, fertdb_cbn(it)%wc, &
                      fertdb_cbn(it)%manure_content%manure_region, &
                      fertdb_cbn(it)%manure_content%manure_source, &
                      fertdb_cbn(it)%manure_content%manure_type, &
                      fertdb_cbn(it)%pest, fertdb_cbn(it)%path, &
                      fertdb_cbn(it)%salt, fertdb_cbn(it)%hmet, fertdb_cbn(it)%cs
                if (eof < 0) exit
                fertdb_cbn(it)%manure_content%manure_name = trim(fertdb_cbn(it)%manure_content%manure_region)//trim(fertdb_cbn(it)%manure_content%manure_source)//"_"// &
                     trim(fertdb_cbn(it)%manure_content%manure_type)
                !-- Assign fertdb_cbn to fertdb for compatibility with existing code --- !
                fertdb(it) = fertdb_cbn(it)%base
              end do
            endif
          enddo
        endif
      
      db_mx%fertparm  = imax 
      
      close (107)
      return
      end subroutine fert_parm_read