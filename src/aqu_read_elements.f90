!!@summary Read aquifer region definitions and element connectivity data for spatial aggregation and calibration
!!@description This subroutine reads aquifer region definition files that specify how individual aquifer objects
!! are grouped into larger regions for output reporting and calibration purposes. It processes two types of
!! region files: output regions (def_aqu) for spatial aggregation of results, and calibration regions
!! (def_aqu_reg) for parameter adjustment during calibration. The subroutine handles element counting,
!! memory allocation for region arrays, and establishes the connectivity between individual hydrologic
!! response units (HRUs) and aquifer regions. It also calculates area fractions and sets up data
!! structures for multi-scale aquifer analysis and calibration workflows.
!!@arguments
!! None - reads from global input file configuration and populates global aquifer region arrays
      subroutine aqu_read_elements
   
      use input_file_module
      use calibration_data_module
      use hydrograph_module
      use aquifer_module
      use maximum_data_module
      
      implicit none

      character (len=80) :: titldum = ""  !!none       | title line from region definition file
      character (len=80) :: header = ""   !!none       | header line describing file format
      integer :: eof = 0                  !!none       | end of file indicator for read operations
      integer :: imax = 0                 !!none       | maximum array index for memory allocation
      integer :: mcal = 0                 !!none       | counter for calibration regions
      logical :: i_exist                  !!none       | file existence check flag
      integer :: mreg = 0                 !!none       | total number of aquifer regions defined
      integer :: i = 0                    !!none       | region counter and loop index
      integer :: k = 0                    !!none       | temporary index for file reading operations
      integer :: nspu = 0                 !!none       | number of sub-units in current region
      integer :: isp = 0                  !!none       | sub-unit counter for element processing
      integer :: ielem1 = 0               !!none       | element identifier and counter
      integer :: ihru = 0                 !!none       | hydrologic response unit counter
      integer :: iaqu = 0                 !!none       | aquifer element counter within regions
      integer :: ireg = 0                 !!none       | region identifier counter
                
      !! Initialize counters and indices for file processing
      mreg = 0
      imax = 0
      mcal = 0
            
    !! Read aquifer output region definitions for spatial aggregation
    inquire (file=in_regs%def_aqu, exist=i_exist)
    if (i_exist .or. in_regs%def_aqu /= "null") then
      do
        !! Open aquifer region definition file
        open (107,file=in_regs%def_aqu)
        !! Read file header information
        read (107,*,iostat=eof) titldum
        if (eof < 0) exit
        !! Read total number of regions to be defined
        read (107,*,iostat=eof) mreg
        if (eof < 0) exit
        read (107,*,iostat=eof) header
        if (eof < 0) exit
        
        !! Allocate arrays for aquifer regions and their associated data structures
        allocate (acu_reg(0:mreg))
        allocate (acu_out(0:mreg))
        allocate (acu_cal(0:mreg))
        !! Allocate aquifer output arrays for all time scales
        !! allocate aquifer outputs for writing
        allocate (saqu_d(0:mreg))
        allocate (saqu_m(0:mreg))
        allocate (saqu_y(0:mreg))
        allocate (saqu_a(0:mreg))

      !! Process each aquifer output region definition
      do i = 1, mreg

        !! Read basic region information: index, name, area, and number of sub-units
        read (107,*,iostat=eof) k, acu_out(i)%name, acu_out(i)%area_ha, nspu        
        if (eof < 0) exit
        !! Process regions with specified sub-unit elements
        if (nspu > 0) then
          !! Allocate temporary array for element counting
          allocate (elem_cnt(nspu), source = 0)
          backspace (107)
          !! Re-read line with complete element list
          read (107,*,iostat=eof) k, acu_out(i)%name, acu_out(i)%area_ha, nspu, (elem_cnt(isp), isp = 1, nspu)
          if (eof < 0) exit

          !! Define unit elements and establish connectivity
          call define_unit_elements (nspu, ielem1)
          
          !! Allocate and populate element number arrays for the region
          allocate (acu_out(i)%num(ielem1), source = 0)
          acu_out(i)%num = defunit_num
          acu_out(i)%num_tot = ielem1
          deallocate (defunit_num)
        else
          !! Handle case where all HRUs are included in the region
          !!all hrus are in region 
          allocate (acu_out(i)%num(sp_ob%hru), source = 0)
          acu_out(i)%num_tot = sp_ob%hru
          !! Include all HRUs sequentially in the region
          do ihru = 1, sp_ob%hru
            acu_out(i)%num(ihru) = ihru
          end do      
        end if

      end do    !! Complete region processing loop: i = 1, mreg
      exit
         
      !! Store maximum number of output regions in database tracking
      db_mx%aqu_out = mreg
      end do 
      end if      

    !! Read aquifer calibration region definitions for parameter adjustment
    !! setting up regions for aquifer soft cal and/or output by type
    inquire (file=in_regs%def_aqu_reg, exist=i_exist)
    if (i_exist .or. in_regs%def_aqu_reg /= "null") then
      do
        !! Open aquifer calibration region definition file
        open (107,file=in_regs%def_aqu)
        !! Read file header information
        read (107,*,iostat=eof) titldum
        if (eof < 0) exit
        !! Read total number of calibration regions
        read (107,*,iostat=eof) mreg
        if (eof < 0) exit
        read (107,*,iostat=eof) header
        if (eof < 0) exit
      !! Process each aquifer calibration region definition
      do i = 1, mreg

        !! Read basic calibration region information
        read (107,*,iostat=eof) k, acu_reg(i)%name, acu_reg(i)%area_ha, nspu       
        if (eof < 0) exit
        !! Process calibration regions with specified sub-unit elements
        if (nspu > 0) then
          !! Allocate temporary array for element counting in calibration regions
          allocate (elem_cnt(nspu), source = 0)
          backspace (107)
          !! Re-read line with complete calibration element list
          read (107,*,iostat=eof) k, acu_reg(i)%name, acu_reg(i)%area_ha, nspu, (elem_cnt(isp), isp = 1, nspu)
          if (eof < 0) exit

          !! Define unit elements and establish connectivity for calibration regions
          call define_unit_elements (nspu, ielem1)
          
          !! Allocate and populate element number arrays for calibration region
          allocate (acu_reg(i)%num(ielem1), source = 0)
          acu_reg(i)%num = defunit_num
          acu_reg(i)%num_tot = ielem1
          deallocate (defunit_num)
        else
          !! Handle case where all aquifers are included in calibration region
          !!all hrus are in region 
          allocate (acu_reg(i)%num(sp_ob%hru), source = 0)
          acu_reg(i)%num_tot = sp_ob%hru
          !! Include all aquifers sequentially in the calibration region
          do iaqu = 1, sp_ob%aqu
            acu_reg(i)%num(ihru) = iaqu
          end do      
        end if

      end do    !! Complete calibration region processing loop: i = 1, mreg
      exit
                 
      !! Store maximum number of calibration regions in database tracking
      db_mx%aqu_reg = mreg
      
      end do 
      end if      

      !! Initialize calibration region data structures when regions are defined
      !! if no regions are input, don"t need elements
      if (mreg > 0) then
      
      !! Initialize calibration parameters and totals for each region
      do ireg = 1, mreg
        !! Initialize land use tracking variables for calibration regions
        acu_cal(ireg)%lum_ha_tot = 0.
        acu_cal(ireg)%lum_num_tot = 0
        acu_cal(ireg)%lum_ha_tot = 0.
        !! Note: Additional land use arrays are available but currently commented
        !allocate (region(ireg)%lum_ha_tot(db_mx%landuse))
        !allocate (region(ireg)%lum_num_tot(db_mx%landuse))
        !allocate (rwb_a(ireg)%lum(db_mx%landuse))
        !allocate (rnb_a(ireg)%lum(db_mx%landuse))
        !allocate (rls_a(ireg)%lum(db_mx%landuse))
        !allocate (rpw_a(ireg)%lum(db_mx%landuse))
      end do
      end if    !! Complete region initialization: mreg > 0
      
      !! Read detailed element data for landscape cataloging units
      !!read data for each element in all landscape cataloging units
      inquire (file=in_regs%ele_aqu, exist=i_exist)
      if (i_exist .or. in_regs%ele_aqu /= "null") then
      do
        !! Open aquifer element definition file
        open (107,file=in_regs%ele_aqu)
        !! Read file header information
        read (107,*,iostat=eof) titldum
        if (eof < 0) exit
        read (107,*,iostat=eof) header
        if (eof < 0) exit
        !! First pass: determine maximum element index for array allocation
        imax = 0
          do while (eof == 0)
              read (107,*,iostat=eof) i
              if (eof < 0) exit
              !! Track maximum element index
              imax = Max(i,imax)
          end do

        !! Allocate aquifer element array based on maximum index found
        allocate (acu_elem(imax))

        !! Reset file position for second reading pass
        rewind (107)
        !! Skip header lines again
        read (107,*,iostat=eof) titldum
        if (eof < 0) exit
        read (107,*,iostat=eof) header
        if (eof < 0) exit

        !! Store maximum element count in database tracking
        db_mx%aqu_elem = imax
        !! Second pass: read detailed element data
        do isp = 1, imax
          !! Read element index to determine position in array
          read (107,*,iostat=eof) i
          if (eof < 0) exit
          !! Backspace to re-read complete element data line
          backspace (107)
          !! Read complete element properties: name, type, fractions, etc.
          read (107,*,iostat=eof) k, acu_elem(i)%name, acu_elem(i)%obtyp, acu_elem(i)%obtypno,      &
                                    acu_elem(i)%bsn_frac, acu_elem(i)%ru_frac, acu_elem(i)%reg_frac
          if (eof < 0) exit
        end do
        exit
      end do
      end if
      
      !! Finalize region-element connectivity and calculate area fractions
      ! set hru number from element number and set hru areas in the region
      do ireg = 1, mreg
        !! Process each aquifer element in the current region
        do iaqu = 1, acu_reg(ireg)%num_tot      !elements have to be hru or hru_lte
          !! Get element identifier for current aquifer in region
          ielem1 = acu_reg(ireg)%num(iaqu)
          !! Convert element number to HRU number for calibration connectivity
          !switch %num from element number to hru number
          acu_cal(ireg)%num(iaqu) = acu_elem(ielem1)%obtypno
          !! Calculate HRU area within region based on fractions
          acu_cal(ireg)%hru_ha(iaqu) = acu_elem(ielem1)%ru_frac * acu_cal(ireg)%area_ha
        end do
      end do
      
      !! Close aquifer element file
      close (107)

      return
      end subroutine aqu_read_elements