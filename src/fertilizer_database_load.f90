subroutine fertilizer_constituent_init()

    use fertilizer_constituent_module
    use maximum_data_module
    use fertilizer_data_module
    implicit none

    ! Initialize the fertilizer-constituent system
    call initialize_fertilizer_constituent_system()

end subroutine fertilizer_constituent_init

subroutine initialize_fertilizer_constituent_system()
    use fertilizer_constituent_module
    implicit none

    ! System initialization with error handling
    
    ! 1. Load traditional or extended fertilizer database
    call load_fertilizer_database()
    
    ! 2. Load manure organic matter database  
    call load_manure_database()
    
    ! 3. Load constituent linkage tables
    call load_constituent_linkages()
    
    ! 4. Perform crosswalking and index computation
    call compute_fertilizer_manure_indices()
    
    ! 5. Validate data consistency
    call validate_fertilizer_constituent_data()
    
    ! 6. Build lookup tables for performance
    call build_lookup_tables()
end subroutine

subroutine load_fertilizer_database()
    use fertilizer_constituent_module
    use maximum_data_module
    use fertilizer_data_module
    implicit none

    logical :: i_exist_ext, i_exist_std
    character(len=80) :: header_line
    integer :: i, num_records
    
    ! Check for extended fertilizer file first
    inquire (file='fertilizer_ext.frt', exist=i_exist_ext)
    inquire (file='fertilizer.frt', exist=i_exist_std)
    
    if (i_exist_ext) then
        call load_extended_fertilizer_format()
        fertilizer_format = 'extended'
    else if (i_exist_std) then
        call load_standard_fertilizer_format()
        fertilizer_format = 'standard'
    else
        call error_exit("No fertilizer database file found (fertilizer.frt or fertilizer_ext.frt)")
    endif
end subroutine

subroutine load_extended_fertilizer_format()
    use fertilizer_constituent_module
    use maximum_data_module
    use fertilizer_data_module
    implicit none

    integer :: i, eof
    character(len=500) :: line
    
    ! Allocate extended fertilizer database
    if (.not. allocated(fertdb_ext)) then
        allocate(fertdb_ext(mx_ferts))
    endif
    
    open(unit=107, file='fertilizer_ext.frt', status='old')
    
    ! Skip header lines
    read(107, *) ! Skip comment line
    read(107, *) ! Skip column headers
    
    i = 0
    do
        read(107, '(a)', iostat=eof) line
        if (eof /= 0) exit
        
        i = i + 1
        if (i > mx_ferts) then
            call error_exit("Too many fertilizer records. Increase mx_ferts parameter")
        endif
        
        read(line, *) fertdb_ext(i)%fertnm, fertdb_ext(i)%fminn, fertdb_ext(i)%fminp, &
                      fertdb_ext(i)%forgn, fertdb_ext(i)%forgp, fertdb_ext(i)%fnh3n, &
                      fertdb_ext(i)%om_name, fertdb_ext(i)%pathogens, fertdb_ext(i)%description
        
        ! Clean up names
        fertdb_ext(i)%fertnm = trim(adjustl(fertdb_ext(i)%fertnm))
        fertdb_ext(i)%om_name = trim(adjustl(fertdb_ext(i)%om_name))
    enddo
    
    db_mx%fertparm = i
    close(107)
end subroutine

subroutine load_standard_fertilizer_format()
    use fertilizer_constituent_module
    use maximum_data_module
    use fertilizer_data_module
    implicit none

    integer :: i, eof
    character(len=500) :: line
    
    ! Allocate extended fertilizer database
    if (.not. allocated(fertdb_ext)) then
        allocate(fertdb_ext(mx_ferts))
    endif
    
    open(unit=107, file='fertilizer.frt', status='old')
    
    ! Skip header lines
    read(107, *) ! Skip comment line
    read(107, *) ! Skip column headers
    
    i = 0
    do
        read(107, '(a)', iostat=eof) line
        if (eof /= 0) exit
        
        i = i + 1
        if (i > mx_ferts) then
            call error_exit("Too many fertilizer records. Increase mx_ferts parameter")
        endif
        
        read(line, *) fertdb_ext(i)%fertnm, fertdb_ext(i)%fminn, fertdb_ext(i)%fminp, &
                      fertdb_ext(i)%forgn, fertdb_ext(i)%forgp, fertdb_ext(i)%fnh3n, &
                      fertdb_ext(i)%pathogens, fertdb_ext(i)%description
        
        ! Set om_name to null for standard format
        fertdb_ext(i)%om_name = "null"
        fertdb_ext(i)%fertnm = trim(adjustl(fertdb_ext(i)%fertnm))
    enddo
    
    db_mx%fertparm = i
    close(107)
end subroutine

subroutine load_manure_database()
    use fertilizer_constituent_module
    use maximum_data_module
    implicit none

    logical :: i_exist
    integer :: i, eof
    character(len=500) :: line
    
    inquire(file='manure_om.man', exist=i_exist)
    if (.not. i_exist) then
        db_mx%manureparm = 0
        return
    endif
    
    ! Allocate manure database
    if (.not. allocated(manure_om_db)) then
        allocate(manure_om_db(mx_manure))
    endif
    
    open(unit=108, file='manure_om.man', status='old')
    
    ! Skip header lines
    read(108, *) ! Skip comment line
    read(108, *) ! Skip column headers
    
    i = 0
    do
        read(108, '(a)', iostat=eof) line
        if (eof /= 0) exit
        
        i = i + 1
        if (i > mx_manure) then
            call error_exit("Too many manure records. Increase mx_manure parameter")
        endif
        
        read(line, *) manure_om_db(i)%name, manure_om_db(i)%region, &
                      manure_om_db(i)%source, manure_om_db(i)%typ, &
                      manure_om_db(i)%pct_moist, manure_om_db(i)%pct_solid, &
                      manure_om_db(i)%tot_c, manure_om_db(i)%tot_n, &
                      manure_om_db(i)%inorg_n, manure_om_db(i)%org_n, &
                      manure_om_db(i)%tot_p2o5, manure_om_db(i)%inorg_p2o5, &
                      manure_om_db(i)%org_p2o5
        
        ! Clean up names and calculate derived properties
        manure_om_db(i)%name = trim(adjustl(manure_om_db(i)%name))
        manure_om_db(i)%typ = trim(adjustl(manure_om_db(i)%typ))
        
        ! Calculate derived phosphorus values (P2O5 to P conversion: factor 0.436)
        manure_om_db(i)%inorg_p = manure_om_db(i)%inorg_p2o5 * 0.436
        manure_om_db(i)%org_p = manure_om_db(i)%org_p2o5 * 0.436
        
        ! Calculate total solids and water content
        manure_om_db(i)%solids = manure_om_db(i)%pct_solid
        manure_om_db(i)%water = manure_om_db(i)%pct_moist
    enddo
    
    db_mx%manureparm = i
    close(108)
end subroutine

subroutine validate_fertilizer_constituent_data()
    use fertilizer_constituent_module
    implicit none
    
    ! Basic validation routine - can be expanded as needed
    ! Currently just a placeholder for future validation logic
    return
end subroutine