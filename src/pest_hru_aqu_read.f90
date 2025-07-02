      subroutine pest_hru_aqu_read
    
      use constituent_mass_module
      use input_file_module
      use maximum_data_module
      use fert_constituent_file_module
 
      implicit none 
        
      character (len=80) :: titldum = ""
      character (len=80) :: header = ""
      integer :: eof = 0
      integer :: imax = 0
      integer :: ipest = 0
      integer :: ipesti = 0
      logical :: i_exist              !none       |check to determine if file exists

      eof = 0
      
      !read all export coefficient data
      inquire (file=in_init%pest_soil, exist=i_exist)
      if (i_exist .or. in_init%pest_soil /= "null") then
        do
          open (107,file=in_init%pest_soil)
          read (107,*,iostat=eof) titldum
          if (eof < 0) exit
          imax = 0
          do while (eof == 0)
            read (107,*,iostat=eof) header
            if (eof < 0) exit
            read (107,*,iostat=eof) titldum     !name
            if (eof < 0) exit
            do ipest = 1, cs_db%num_pests
              read (107,*,iostat=eof) titldum
              if (eof < 0) exit
            end do
            imax = imax + 1
          end do
          
          db_mx%pest_ini = imax
          
          allocate (pest_soil_ini(imax))
          allocate (cs_pest_solsor(cs_db%num_pests))
          
          do ipest = 1, imax
            allocate (pest_soil_ini(ipest)%soil(cs_db%num_pests), source = 0.)
            allocate (pest_soil_ini(ipest)%plt(cs_db%num_pests), source = 0.)
          end do
          
          rewind (107)
          read (107,*,iostat=eof) titldum
          if (eof < 0) exit
          read (107,*,iostat=eof) header
          if (eof < 0) exit
          
          do ipesti = 1, imax
            read (107,*,iostat=eof) pest_soil_ini(ipesti)%name
            do ipest = 1, cs_db%num_pests
              read (107,*,iostat=eof) titldum, pest_soil_ini(ipesti)%soil(ipest), &
                                            pest_soil_ini(ipesti)%plt(ipest)
              if (eof < 0) exit
            end do
          end do
          close (107)
          exit
        end do
      end if
      

      call fert_constituent_file_read('pest.man', imax, cs_db%num_pests, pest_fert_soil_ini)

      !--- we assume that this new file uses the same number of cs_db%num_pests
      !--- as above and imax
      inquire (file= 'pest.man', exist=i_exist)
      allocate (pest_fert_soil_ini(imax))
      do
          open (107,file= 'pest.man')
          do ipest = 1, imax
            allocate (pest_fert_soil_ini(ipest)%soil(cs_db%num_pests), source = 0.)
          enddo
            if (i_exist) then
                read (107,*,iostat=eof) titldum
                if (eof < 0) exit
                read (107,*,iostat=eof) header
                if (eof < 0) exit
          
                do ipesti = 1, imax
                    read (107,*,iostat=eof) pest_fert_soil_ini(ipesti)%name
                    do ipest = 1, cs_db%num_pests
                        read (107,*,iostat=eof) titldum, pest_fert_soil_ini(ipesti)%soil(ipest)
                        if (eof < 0) exit
                    end do
                end do
                close (107)
                exit
            endif
        enddo

      
      return
      end subroutine pest_hru_aqu_read