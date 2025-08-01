      module water_allocation_module
    
      use hydrograph_module, only : hyd_output
    
      implicit none
            
      real :: trans_m3 = 0.
      real :: dmd_m3 = 0.                   !m3     |demand
      character(len=16), dimension(:), allocatable :: trt_om_name    !treatment name in treatment.trt
      
      !! water source objects
      type water_source_objects
        integer :: num = 0                      !demand object number
        character (len=3) :: ob_typ = ""        !channel(cha), reservoir(res), aquifer(aqu), unlimited source(unl)
        integer :: ob_num = 0                   !number of the object type
        character (len=6) :: avail_typ = ""     !selecting how to determine available water - decision table (dtbl), recall file (rec), or monthly limit (mon)
        character (len=25) :: dtbl = ""         !decision table name to set water available
        character (len=25) :: rec = ""          !recall input file to set water available
        real, dimension (12) :: limit_mon = 0.  !min chan flow(m3/s), min res level(frac prinicpal), max aqu depth(m)
        integer :: rec_num = 0
        real :: div_vol = 0.
      end type water_source_objects

      !! demand source objects
      type demand_source_objects
        character (len=25) :: dtbl = ""         !decision table name to set fractions of each source (if used-not null)
        integer :: src_wal                      !sequential source number as listed in wallo object
        character (len=10) :: src_typ = ""      !source object type
        integer :: src_num = 0                  !number of the source object
        character (len=10) :: conv_typ = ""     !conveyance type - pipe or pump
        integer :: conv_num = 0                 !number of the conveyance object
        real :: frac = 0.                       !fraction of demand supplied by the source
        character (len=1) :: comp = ""          !compensate from source if other sources are limiting (y/n)
       end type demand_source_objects
        
      !! demand receiving objects
      type demand_receiving_objects
        character (len=25) :: dtbl = ""         !decision table name to set fractions of each source (if used-not null)
        character (len=10) :: rcv_typ = ""      !receiving object type
        integer :: rcv_num = 0                  !number of the receiving object
        character (len=10) :: conv_typ = ""     !conveyance type - pipe or pump
        integer :: conv_num = 0                 !number of the conveyance object
        real :: frac = 0.                       !fraction of demand supplied by the source
        character (len=1) :: comp = ""          !compensate if other receiving objects are at max capacity (y/n)
       end type demand_receiving_objects
        
      !! source output
      type source_output
        real :: demand = 0.                     !ha-m       !demand
        real :: withdr = 0.                     !ha-m       |amoount withdrawn from the source
        real :: unmet  = 0.                     !ha-m       |unmet demand
      end type source_output
      type (source_output) :: walloz
      
      !! water demand objects
      type water_demand_objects
        integer :: num = 0                      !demand object number
        character (len=10) :: ob_typ = ""       !hru, water treatment plant, industrial and dpmestic use
        integer :: ob_num = 0                   !number of the object type
        character (len=6) :: dmd_typ = ""       !selecting how to determine demand - decision table (dtbl), recall file (rec), or ave daily (ave_day)
        character (len=25) :: dmd_typ_name = "" !name of decision table or recall file
        real :: amount = 0.                     !m3 per day for urban objects and mm for hru
        character (len=2) :: right = ""         !water right (sr -senior or jr - junior right)
        integer :: src_num = 0                  !number of source objects
        integer :: rcv_num = 0                  !number of receiving objects
        integer :: rec_num = 0                  !number of recall file
        integer :: dtbl_num = 0                 !number of decision table
        character (len=10) :: dtl_src_fr = ""   !source object decision table - to condition fraction from each source
        type (demand_source_objects), dimension(:), allocatable :: src      !sequential source objects as listed in wallo object
        character (len=10) :: dtl_rcv_fr = ""   !receiving object decision table - to condition fraction to each receiving object
        type (demand_receiving_objects), dimension(:), allocatable :: rcv   !sequential source objects as listed in wallo object
        real :: unmet_m3 = 0.                   !m3     |unmet demand for the object
        real :: withdr_tot = 0.                 !m3     |total withdrawal of demand object from all sources
        real :: irr_eff = 0.                    !irrigation in-field efficiency
        real :: surq = 0.                       !surface runoff ratio
        type (hyd_output) :: hd
      end type water_demand_objects

      !water allocation
      type water_allocation
        character (len=25) :: name = ""         !name of the water allocation object
        character (len=25) :: rule_typ = ""     !rule type to allocate water
        integer :: src_obs = 0                  !number of source objects
        integer :: dmd_obs = 0                  !number of demand objects
        type (source_output) :: tot             !total demand, withdrawal and unmet for entire allocation object
        type (water_source_objects), dimension(:), allocatable :: src        !dimension by source objects
        type (water_demand_objects), dimension(:), allocatable :: dmd        !dimension by demand objects
      end type water_allocation
      type (water_allocation), dimension(:), allocatable :: wallo            !dimension by water allocation objects

      !! water_treatment_data
      type water_treatment_use_data
        character (len=25) :: name = ""         !name of the water treatment plant
        !character (len=25) :: init = ""         !name of the intitial concentrations in wtp storage
        real :: stor_mx                   !m3   !maximum storage in plant
        real :: lag_days                  !days !treatement time - lag outflow
        real :: loss_fr                         !water loss during treament
        character (len=25) :: org_min = ""      !sediment, carbon, and nutrients
        character (len=25) :: pests = ""        !pesticides - ppm
        character (len=25) :: paths = ""        !pathogens - cfu
        character (len=25) :: salts = ""        !salt ions - ppm
        character (len=25) :: constit = ""      !other constituents - ppm
        character (len=80) :: descrip = ""      !description
      end type water_treatment_use_data        
      type (water_treatment_use_data), dimension(:), allocatable :: wtp        
      type (water_treatment_use_data), dimension(:), allocatable :: wuse
      
      type aquifer_loss
        integer :: num                          !number of aquifers
        real :: aqu_num                         !aquifer number
        real :: frac                            !fraction of loss in specific aquifer
      end type aquifer_loss
      
      !! water_transfer_data
      type water_transfer_data
        character (len=25) :: name = ""         !name of the water treatment plant
        character (len=25) :: init = ""         !name of the intitial concentrations in wtp storage
        real :: stor_mx                   !m3   !maximum storage in plant
        real :: lag_days                  !days !treatement time - lag outflow
        real :: loss_fr                         !water loss during treament
        type (aquifer_loss), dimension(:), allocatable :: aqu_loss
      end type water_transfer_data
      type (water_transfer_data), dimension(:), allocatable :: wtow        
      type (water_transfer_data), dimension(:), allocatable :: pipe        
      type (water_transfer_data), dimension(:), allocatable :: canal
      
      !demand object output
      type demand_object_output
        real :: dmd_tot = 0.            !m3     |total demand of the demand object
        type (source_output), dimension(:), allocatable :: src
      end type demand_object_output
      
      !water allocation output
      type water_allocation_output
        type (demand_object_output), dimension(:), allocatable :: dmd
      end type water_allocation_output
      type (water_allocation_output), dimension(:), allocatable :: wallod_out     !dimension by demand objects
      type (water_allocation_output), dimension(:), allocatable :: wallom_out     !dimension by demand objects
      type (water_allocation_output), dimension(:), allocatable :: walloy_out     !dimension by demand objects
      type (water_allocation_output), dimension(:), allocatable :: walloa_out     !dimension by demand objects
      
      type wallo_header            
        character(len=6) :: day      =   "  jday"
        character(len=6) :: mo       =   "   mon"
        character(len=6) :: day_mo   =   " day "
        character(len=6) :: yrc      =   " yr  "
        character(len=8) :: idmd     =   " unit   "
        character(len=16) :: dmd_typ  =  "dmd_typ         "
        character(len=16) :: dmd_num =   "    dmd_num     "
        character(len=17) :: rcv_typ  =  "drcv_typ         "
        character(len=16) :: rcv_num =   "    rcv_num     "
        character(len=12) :: src1_obj =  "   src1_obj "
        character(len=12) :: src1_typ =  " src1_typ   "
        character(len=12)  :: src1_num = " src1_num   "
        character(len=15) :: dmd1  =     "    demand     "      !! ha-m     |demand - muni or irrigation       
        character(len=15) :: s1out  =   "src1_withdraw  "       !! ha-m     |withdrawal from source 1
        character(len=12) :: s1un =    "  src1_unmet"          !! ha-m     |unmet from source 1 
        character(len=12) :: src2_typ =  " src2_typ   "
        character(len=12)  :: src2_num = " src2_num   "
        character(len=15) :: dmd2  =     "    demand     "      !! ha-m     |demand - muni or irrigation       
        character(len=15) :: s2out  =   "src2_withdraw  "       !! ha-m     |withdrawal from source 2
        character(len=12) :: s2un =    "  src2_unmet"          !! ha-m     |unmet from source 2           
        character(len=12) :: src3_typ =  " src3_typ   "
        character(len=12)  :: src3_num = " src3_num   "
        character(len=15) :: dmd3  =     "    demand     "      !! ha-m     |demand - muni or irrigation       
        character(len=15) :: s3out  =   "src3_withdraw  "       !! ha-m     |withdrawal from source 3
        character(len=12) :: s3un =    "  src3_unmet"          !! ha-m     |unmet from source 3      

        end type wallo_header
      type (wallo_header) :: wallo_hdr

      type wallo_header_units         
        character (len=8) :: day      =  "        "
        character (len=8) :: mo       =  "        "
        character (len=8) :: day_mo   =  "        "
        character (len=8) :: yrc      =  "        "
        character (len=8) :: idmd     =  "        "
        character (len=16) :: dmd_typ  =  "                "
        character (len=16) :: dmd_num  =  "                "
        character (len=16) :: rcv_typ  =  "                "
        character (len=16) :: rcv_num  =  "                "
        character (len=12) :: src1_obj =  "            "
        character (len=12) :: src1_typ =  "            "
        character (len=8) :: src1_num =  "        "
        character (len=15) :: dmd1 =      "m^3            "            !! ha-m    |demand - muni or irrigation
        character (len=15) :: s1out =     "m^3            "            !! ha-m    |withdrawal from source 1       
        character (len=9) :: s1un =      "m^3      "                   !! ha-m    |unmet from source 1 
        character (len=15) :: src2_typ =  "               "
        character (len=15) :: src2_num =  "               "
        character (len=15) :: dmd2 =      "m^3            "        !! ha-m    |demand - muni or irrigation
        character (len=15) :: s2out =     "m^3            "        !! ha-m    |withdrawal from source 2       
        character (len=15) :: s2un =      "m^3            "        !! ha-m    |unmet from source 2        
        character (len=15) :: src3_typ =  "               "
        character (len=15) :: src3_num =  "               "
        character (len=15) :: dmd3 =      "m^3            "        !! ha-m    |demand - muni or irrigation
        character (len=15) :: s3out =     "m^3            "        !! ha-m    |withdrawal from source 3       
        character (len=15) :: s3un =      "m^3            "        !! ha-m    |unmet from source 3   

        end type wallo_header_units
      type (wallo_header_units) :: wallo_hdr_units 
      
      interface operator (+)
        module procedure wallout_add
      end interface

      interface operator (/)
        module procedure wallo_div_const
      end interface   

      contains

      !! routines for hydrograph module
      function wallout_add (wallo1, wallo2) result (wallo3)
        type (source_output), intent (in) :: wallo1
        type (source_output), intent (in) :: wallo2
        type (source_output) :: wallo3
        wallo3%demand = wallo1%demand + wallo2%demand
        wallo3%withdr = wallo1%withdr + wallo2%withdr
        wallo3%unmet = wallo1%unmet + wallo2%unmet
      end function wallout_add

      function wallo_div_const (wallo1, const) result (wallo2)
        type (source_output), intent (in) :: wallo1
        real, intent (in) :: const
        type (source_output) :: wallo2
        wallo2%demand = wallo1%demand / const
        wallo2%withdr = wallo1%withdr / const
        wallo2%unmet = wallo1%unmet / const
      end function wallo_div_const

      end module water_allocation_module