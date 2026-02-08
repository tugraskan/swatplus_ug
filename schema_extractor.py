#!/usr/bin/env python3
"""
Schema extraction tool for SWAT+ input files.
Parses Fortran source code to extract file schemas and update CSV documentation.
"""

import os
import re
import csv
import json
from typing import Dict, List, Tuple, Optional
from dataclasses import dataclass, field, asdict
from collections import defaultdict


@dataclass
class FieldSchema:
    """Represents a field in an input file schema."""
    file_name: str
    line_in_file: int
    position_in_file: int
    swat_code_type: str
    variable_name: str
    description: str
    units: str
    data_type: str
    decimal_places: str
    code_file: str
    code_line_start: int
    code_line_end: int
    code_snippet: str
    confidence: str = "high"
    notes: str = ""


@dataclass
class Evidence:
    """Evidence for a change to the CSV."""
    action: str  # unchanged, updated, added, removed, info
    schema_key: str
    swat_file: str
    line_in_file: int
    position_in_file: int
    swat_code_type: str
    variable_name: str
    field_changed: str = ""
    old_value: str = ""
    new_value: str = ""
    confidence: str = "high"
    code_file: str = ""
    code_line_start: int = 0
    code_line_end: int = 0
    code_snippet: str = ""
    doc_source: str = ""
    notes: str = ""


@dataclass
class FileSummary:
    """Summary of changes for a file."""
    swat_file: str
    baseline_rows: int = 0
    updated_rows: int = 0
    extracted_rows: int = 0
    added: int = 0
    removed: int = 0
    updated: int = 0
    unchanged: int = 0
    warnings: str = ""


class FortranParser:
    """Parse Fortran source files to extract schema information."""
    
    def __init__(self, src_dir: str):
        self.src_dir = src_dir
        self.type_definitions = {}
        self.file_readers = {}
        
    def extract_type_definition(self, module_file: str, type_name: str) -> Dict[str, Dict]:
        """Extract type definition from a Fortran module file."""
        fields = {}
        
        if not os.path.exists(module_file):
            return fields
            
        with open(module_file, 'r', encoding='utf-8', errors='ignore') as f:
            content = f.read()
        
        # Find type definition
        type_pattern = rf'type\s+{type_name}\s*$(.*?)end\s+type\s+{type_name}'
        match = re.search(type_pattern, content, re.MULTILINE | re.DOTALL | re.IGNORECASE)
        
        if not match:
            return fields
        
        type_body = match.group(1)
        
        # Extract field declarations
        lines = type_body.split('\n')
        for i, line in enumerate(lines):
            # Remove comments
            comment_pos = line.find('!')
            if comment_pos >= 0:
                comment = line[comment_pos+1:].strip()
                line = line[:comment_pos]
            else:
                comment = ""
            
            line = line.strip()
            if not line:
                continue
            
            # Parse field declaration: type :: name = default
            field_match = re.match(r'(character|integer|real|logical|double\s+precision)\s*(\([^)]+\))?\s*::\s*(\w+)', 
                                  line, re.IGNORECASE)
            if field_match:
                ftype = field_match.group(1).strip().lower()
                type_spec = field_match.group(2) or ""
                fname = field_match.group(3)
                
                # Parse units and description from comment
                units = ""
                desc = ""
                if comment:
                    # Format is typically: !unit |description
                    parts = comment.split('|', 1)
                    if len(parts) == 2:
                        units = parts[0].strip()
                        desc = parts[1].strip()
                    else:
                        desc = comment.strip()
                
                # Map Fortran type to spreadsheet type
                if 'character' in ftype:
                    dtype = 'string'
                elif 'integer' in ftype:
                    dtype = 'integer'
                elif 'real' in ftype or 'double' in ftype:
                    dtype = 'numeric'
                elif 'logical' in ftype:
                    dtype = 'boolean'
                else:
                    dtype = ftype
                
                fields[fname] = {
                    'fortran_type': ftype + type_spec,
                    'data_type': dtype,
                    'units': units,
                    'description': desc
                }
        
        return fields
    
    def find_read_subroutine(self, filename: str) -> Optional[Tuple[str, int, int, str]]:
        """Find the subroutine that reads a specific file."""
        # Map filename to likely subroutine names
        file_to_sub = {
            'time.sim': 'time_read.f90',
            'hru.con': 'hru_read.f90',
            'plant.ini': 'readpcom.f90',
            'hyd-sed-lte.cha': 'sd_hydsed_read.f90'
        }
        
        sub_file = file_to_sub.get(filename)
        if not sub_file:
            return None
        
        full_path = os.path.join(self.src_dir, sub_file)
        if not os.path.exists(full_path):
            return None
        
        with open(full_path, 'r', encoding='utf-8', errors='ignore') as f:
            lines = f.readlines()
        
        # Find the main read statements
        start_line = 0
        end_line = len(lines)
        content = ''.join(lines)
        
        return (full_path, start_line, end_line, content)
    
    def extract_schema_time_sim(self) -> List[FieldSchema]:
        """Extract schema for time.sim file."""
        schemas = []
        
        # From time_read.f90 analysis:
        # Line 3: read time%day_start, time%yrc_start, time%day_end, time%yrc_end, time%step
        
        # Get type definition for time
        time_module = os.path.join(self.src_dir, 'time_module.f90')
        fields = self.extract_type_definition(time_module, 'time_current')
        
        read_file = os.path.join(self.src_dir, 'time_read.f90')
        
        # Hardcoded based on analysis of time_read.f90 line 28
        var_list = [
            ('day_start', 1),
            ('yrc_start', 2),
            ('day_end', 3),
            ('yrc_end', 4),
            ('step', 5)
        ]
        
        for var_name, pos in var_list:
            field_info = fields.get(var_name, {})
            
            schema = FieldSchema(
                file_name='time.sim',
                line_in_file=3,
                position_in_file=pos,
                swat_code_type='time',
                variable_name=var_name,
                description=field_info.get('description', ''),
                units=field_info.get('units', 'none'),
                data_type=field_info.get('data_type', 'integer'),
                decimal_places='',
                code_file='time_read.f90',
                code_line_start=28,
                code_line_end=28,
                code_snippet='read (107,*,iostat=eof) time%day_start, time%yrc_start, time%day_end, time%yrc_end, time%step',
                confidence='high'
            )
            schemas.append(schema)
        
        return schemas
    
    def extract_schema_hru_con(self) -> List[FieldSchema]:
        """Extract schema for hru.con file."""
        schemas = []
        
        # From hyd_read_connect.f90 analysis:
        # Line 220-221: read num, name, gis_id, area_ha, lat, long, elev, props, wst_c, constit, props2, ruleset, src_tot
        # This is the generic connection file reader used for hru.con
        
        read_file = os.path.join(self.src_dir, 'hyd_read_connect.f90')
        
        # Connection file variables (line 220-221 in hyd_read_connect.f90)
        con_vars = [
            ('num', 1, 'integer', 'HRU number'),
            ('name', 2, 'string', 'HRU name'),
            ('gis_id', 3, 'string', 'HRU GIS id'),
            ('area_ha', 4, 'numeric', 'HRU area'),
            ('lat', 5, 'numeric', 'Latitude'),
            ('long', 6, 'numeric', 'Longitude'),
            ('elev', 7, 'numeric', 'Elevation'),
            ('props', 8, 'string', 'HRU properties pointer'),
            ('wst_c', 9, 'string', 'Weather station pointer'),
            ('constit', 10, 'string', 'Constituent pointer'),
            ('props2', 11, 'string', 'Properties 2 pointer'),
            ('ruleset', 12, 'string', 'Ruleset pointer'),
            ('src_tot', 13, 'integer', 'Total number of sources')
        ]
        
        for var_name, pos, dtype, desc in con_vars:
            schema = FieldSchema(
                file_name='hru.con',
                line_in_file=3,  # After title and header
                position_in_file=pos,
                swat_code_type='ob',
                variable_name=var_name,
                description=desc,
                units='',
                data_type=dtype,
                decimal_places='',
                code_file='hyd_read_connect.f90',
                code_line_start=220,
                code_line_end=221,
                code_snippet='read (107,*,iostat=eof) ob(i)%num, ob(i)%name, ob(i)%gis_id, ob(i)%area_ha, ob(i)%lat, ob(i)%long, ...',
                confidence='high'
            )
            schemas.append(schema)
        
        return schemas
    
    def extract_schema_plant_ini(self) -> List[FieldSchema]:
        """Extract schema for plant.ini file."""
        schemas = []
        
        # From readpcom.f90 analysis:
        # Line 62: read name, plants_com, rot_yr_ini
        # Then for each plant: read cpnm, igro, lai, bioms, phuacc, pop, fr_yrmat, rsdin
        
        read_file = os.path.join(self.src_dir, 'readpcom.f90')
        
        # Header line
        header_vars = [
            ('name', 1, 'string', 'Plant community name'),
            ('plants_com', 2, 'integer', 'Number of plants in community'),
            ('rot_yr_ini', 3, 'integer', 'Initial rotation year')
        ]
        
        for var_name, pos, dtype, desc in header_vars:
            schema = FieldSchema(
                file_name='plant.ini',
                line_in_file=3,  # After title and header
                position_in_file=pos,
                swat_code_type='pcomdb',
                variable_name=var_name,
                description=desc,
                units='',
                data_type=dtype,
                decimal_places='',
                code_file='readpcom.f90',
                code_line_start=62,
                code_line_end=62,
                code_snippet='read (113,*,iostat=eof)  pcomdb(icom)%name, pcomdb(icom)%plants_com, pcomdb(icom)%rot_yr_ini',
                confidence='high'
            )
            schemas.append(schema)
        
        # Plant detail lines
        plant_vars = [
            ('cpnm', 1, 'string', 'Plant name'),
            ('igro', 2, 'integer', 'Land cover status code'),
            ('lai', 3, 'numeric', 'Initial leaf area index'),
            ('bioms', 4, 'numeric', 'Initial biomass'),
            ('phuacc', 5, 'numeric', 'Initial accumulated heat units'),
            ('pop', 6, 'numeric', 'Initial plant population'),
            ('fr_yrmat', 7, 'numeric', 'Fraction of years to maturity'),
            ('rsdin', 8, 'numeric', 'Initial residue')
        ]
        
        for var_name, pos, dtype, desc in plant_vars:
            schema = FieldSchema(
                file_name='plant.ini',
                line_in_file=4,  # Plant detail lines
                position_in_file=pos,
                swat_code_type='pcomdb%pl',
                variable_name=var_name,
                description=desc,
                units='',
                data_type=dtype,
                decimal_places='',
                code_file='readpcom.f90',
                code_line_start=68,
                code_line_end=70,
                code_snippet='read (113,*,iostat=eof) pcomdb(icom)%pl(iplt)%cpnm, pcomdb(icom)%pl(iplt)%igro, ...',
                confidence='high'
            )
            schemas.append(schema)
        
        return schemas
    
    def extract_schema_hyd_sed_lte(self) -> List[FieldSchema]:
        """Extract schema for hyd-sed-lte.cha file."""
        schemas = []
        
        # From sd_hydsed_read.f90 analysis:
        # Line 61: read (1,*,iostat=eof) sd_chd(idb)
        # This reads the entire sd_chd structure
        
        # Get type definition for sd_chd
        module_file = os.path.join(self.src_dir, 'sd_channel_module.f90')
        fields = self.extract_type_definition(module_file, 'swatdeg_hydsed_data')
        
        read_file = os.path.join(self.src_dir, 'sd_hydsed_read.f90')
        
        # Order based on type definition - ALL 23 fields
        var_order = [
            'name', 'order', 'chw', 'chd', 'chs', 'chl', 'chn', 'chk',
            'bank_exp', 'cov', 'sinu', 'vcr_coef', 'd50', 'ch_clay',
            'carbon', 'ch_bd', 'chss', 'bankfull_flo', 'fps', 'fpn',
            'n_conc', 'p_conc', 'p_bio'  # Added: nitrogen and phosphorus concentration fields
        ]
        
        for pos, var_name in enumerate(var_order, start=1):
            field_info = fields.get(var_name, {})
            
            schema = FieldSchema(
                file_name='hyd-sed-lte.cha',
                line_in_file=3,  # Data lines after title and header
                position_in_file=pos,
                swat_code_type='sd_chd',
                variable_name=var_name,
                description=field_info.get('description', ''),
                units=field_info.get('units', ''),
                data_type=field_info.get('data_type', 'numeric'),
                decimal_places='',
                code_file='sd_hydsed_read.f90',
                code_line_start=61,
                code_line_end=61,
                code_snippet='read (1,*,iostat=eof) sd_chd(idb)',
                confidence='high'
            )
            schemas.append(schema)
        
        return schemas
    
    def extract_all_schemas(self) -> List[FieldSchema]:
        """Extract schemas for all pilot files."""
        all_schemas = []
        
        all_schemas.extend(self.extract_schema_time_sim())
        all_schemas.extend(self.extract_schema_hru_con())
        all_schemas.extend(self.extract_schema_plant_ini())
        all_schemas.extend(self.extract_schema_hyd_sed_lte())
        
        return all_schemas


class CSVUpdater:
    """Update the baseline CSV with extracted schema."""
    
    def __init__(self, baseline_csv: str):
        self.baseline_csv = baseline_csv
        self.baseline_data = []
        self.header = []
        self.load_baseline()
        
    def load_baseline(self):
        """Load the baseline CSV."""
        with open(self.baseline_csv, 'r', encoding='utf-8') as f:
            reader = csv.reader(f)
            self.header = next(reader)
            self.baseline_data = list(reader)
    
    def create_schema_key(self, row: Dict) -> str:
        """Create a unique key for matching."""
        swat_file = row.get('SWAT_File', '')
        line = row.get('Line_in_file', '')
        pos = row.get('Position_in_File', '')
        return f"{swat_file}|{line}|{pos}"
    
    def is_wildcard_row(self, row: Dict) -> bool:
        """Check if row has wildcard (*) in Line_in_file or Position_in_File."""
        line = row.get('Line_in_file', '')
        pos = row.get('Position_in_File', '')
        return line == '*' or pos == '*'
    
    def is_description_only_change(self, changes: List[str]) -> bool:
        """Check if only description/units changed (not structural fields)."""
        if not changes:
            return False
        
        # Structural fields that matter
        structural_fields = {
            'Line_in_file', 'Position_in_File', 
            'SWAT_Code_Variable_Name', 'Data_Type', 
            'Number_Decimal_Places'
        }
        
        # Check if any structural field changed
        for change in changes:
            if change in structural_fields:
                return False
        
        # Only non-structural changes (Description, Units)
        return True
    
    def find_matching_baseline_row(self, baseline_dict: Dict, schema: FieldSchema) -> Optional[Dict]:
        """Find matching baseline row, handling wildcards."""
        # Try exact match first
        exact_key = f"{schema.file_name}|{schema.line_in_file}|{schema.position_in_file}"
        if exact_key in baseline_dict:
            return baseline_dict[exact_key]
        
        # Try wildcard match: file|*|position
        wildcard_key = f"{schema.file_name}|*|{schema.position_in_file}"
        if wildcard_key in baseline_dict:
            return baseline_dict[wildcard_key]
        
        return None
    
    def update_csv(self, schemas: List[FieldSchema]) -> Tuple[List[Dict], List[Evidence], Dict[str, FileSummary]]:
        """Update CSV with extracted schemas."""
        
        # Convert baseline to dict for easier manipulation
        baseline_dict = {}
        for row in self.baseline_data:
            row_dict = dict(zip(self.header, row))
            key = self.create_schema_key(row_dict)
            baseline_dict[key] = row_dict
        
        # Track evidence and summaries
        evidence_list = []
        file_summaries = {}
        
        # Group schemas by file
        schemas_by_file = defaultdict(list)
        for schema in schemas:
            schemas_by_file[schema.file_name].append(schema)
            if schema.file_name not in file_summaries:
                file_summaries[schema.file_name] = FileSummary(swat_file=schema.file_name)
            file_summaries[schema.file_name].extracted_rows += 1
        
        # Count baseline rows per file
        for row_dict in baseline_dict.values():
            swat_file = row_dict.get('SWAT_File', '')
            if swat_file in schemas_by_file:
                file_summaries[swat_file].baseline_rows += 1
        
        # Process each schema
        updated_baseline = {}
        matched_baseline_keys = set()  # Track which baseline rows we've matched
        
        for schema in schemas:
            key = f"{schema.file_name}|{schema.line_in_file}|{schema.position_in_file}"
            
            # Try to find matching baseline row (handles wildcards)
            baseline_row = self.find_matching_baseline_row(baseline_dict, schema)
            
            if baseline_row:
                # Update existing row
                row_dict = baseline_row.copy()
                baseline_key = self.create_schema_key(baseline_row)
                matched_baseline_keys.add(baseline_key)
                
                changes = []
                
                # Update only specified columns
                # NOTE: Swat_code_type is NOT updated - it's just the component name and should remain from baseline
                
                # For Line_in_file: keep wildcard (*) if baseline has it, otherwise update
                baseline_line = baseline_row.get('Line_in_file', '')
                if baseline_line != '*' and baseline_line != str(schema.line_in_file):
                    changes.append('Line_in_file')
                    row_dict['Line_in_file'] = str(schema.line_in_file)
                # If baseline has *, keep it (don't update)
                
                if row_dict.get('Position_in_File', '') != str(schema.position_in_file):
                    changes.append('Position_in_File')
                    row_dict['Position_in_File'] = str(schema.position_in_file)
                
                # Swat_code_type is intentionally NOT updated per requirements
                # It represents component name and should remain as-is from baseline
                
                if row_dict.get('SWAT_Code_Variable_Name', '') != schema.variable_name:
                    changes.append('SWAT_Code_Variable_Name')
                    row_dict['SWAT_Code_Variable_Name'] = schema.variable_name
                
                if schema.description and row_dict.get('Description', '') != schema.description:
                    changes.append('Description')
                    row_dict['Description'] = schema.description
                
                if schema.units and row_dict.get('Units', '') != schema.units:
                    changes.append('Units')
                    row_dict['Units'] = schema.units
                
                if row_dict.get('Data_Type', '') != schema.data_type:
                    changes.append('Data_Type')
                    row_dict['Data_Type'] = schema.data_type
                
                if schema.decimal_places and row_dict.get('Number_Decimal_Places', '') != schema.decimal_places:
                    changes.append('Number_Decimal_Places')
                    row_dict['Number_Decimal_Places'] = schema.decimal_places
                
                updated_baseline[key] = row_dict
                
                if changes:
                    # Check if only description/units changed (non-structural)
                    if self.is_description_only_change(changes):
                        # Don't update master CSV for description-only changes
                        # Report as informational only
                        file_summaries[schema.file_name].unchanged += 1
                        evidence = Evidence(
                            action='info',
                            schema_key=key,
                            swat_file=schema.file_name,
                            line_in_file=schema.line_in_file,
                            position_in_file=schema.position_in_file,
                            swat_code_type=schema.swat_code_type,
                            variable_name=schema.variable_name,
                            field_changed=','.join(changes),
                            confidence=schema.confidence,
                            code_file=schema.code_file,
                            code_line_start=schema.code_line_start,
                            code_line_end=schema.code_line_end,
                            code_snippet=schema.code_snippet,
                            notes='description change only; not applied'
                        )
                        evidence_list.append(evidence)
                        # Revert the description/units changes - keep baseline values
                        for change in changes:
                            if change in ['Description', 'Units']:
                                row_dict[change] = baseline_row.get(change, '')
                    else:
                        # Structural fields changed - this is a real update
                        file_summaries[schema.file_name].updated += 1
                        evidence = Evidence(
                            action='updated',
                            schema_key=key,
                            swat_file=schema.file_name,
                            line_in_file=schema.line_in_file,
                            position_in_file=schema.position_in_file,
                            swat_code_type=schema.swat_code_type,
                            variable_name=schema.variable_name,
                            field_changed=','.join(changes),
                            confidence=schema.confidence,
                            code_file=schema.code_file,
                            code_line_start=schema.code_line_start,
                            code_line_end=schema.code_line_end,
                            code_snippet=schema.code_snippet
                        )
                        evidence_list.append(evidence)
                else:
                    file_summaries[schema.file_name].unchanged += 1
                    evidence = Evidence(
                        action='unchanged',
                        schema_key=key,
                        swat_file=schema.file_name,
                        line_in_file=schema.line_in_file,
                        position_in_file=schema.position_in_file,
                        swat_code_type=schema.swat_code_type,
                        variable_name=schema.variable_name,
                        confidence=schema.confidence,
                        code_file=schema.code_file,
                        code_line_start=schema.code_line_start,
                        code_line_end=schema.code_line_end,
                        code_snippet=schema.code_snippet
                    )
                    evidence_list.append(evidence)
            else:
                # Add new row - copy from similar row if possible
                template_row = None
                for existing_key, existing_row in baseline_dict.items():
                    if existing_row.get('SWAT_File') == schema.file_name:
                        template_row = existing_row.copy()
                        break
                
                if template_row:
                    new_row = template_row.copy()
                else:
                    new_row = {col: '' for col in self.header}
                
                # Update with schema data
                # NOTE: Swat_code_type is NOT updated - keep from template/baseline
                new_row['SWAT_File'] = schema.file_name
                new_row['Line_in_file'] = str(schema.line_in_file)
                new_row['Position_in_File'] = str(schema.position_in_file)
                # new_row['Swat_code type'] = schema.swat_code_type  # Do NOT update - keep baseline value
                new_row['SWAT_Code_Variable_Name'] = schema.variable_name
                new_row['Description'] = schema.description
                new_row['Units'] = schema.units
                new_row['Data_Type'] = schema.data_type
                new_row['Number_Decimal_Places'] = schema.decimal_places
                
                updated_baseline[key] = new_row
                file_summaries[schema.file_name].added += 1
                
                evidence = Evidence(
                    action='added',
                    schema_key=key,
                    swat_file=schema.file_name,
                    line_in_file=schema.line_in_file,
                    position_in_file=schema.position_in_file,
                    swat_code_type=schema.swat_code_type,
                    variable_name=schema.variable_name,
                    confidence=schema.confidence,
                    code_file=schema.code_file,
                    code_line_start=schema.code_line_start,
                    code_line_end=schema.code_line_end,
                    code_snippet=schema.code_snippet,
                    notes='New schema element added from code'
                )
                evidence_list.append(evidence)
        
        # Check for removed rows
        for key, row_dict in baseline_dict.items():
            swat_file = row_dict.get('SWAT_File', '')
            
            # Only process rows for files we're handling
            if swat_file not in schemas_by_file:
                # Keep rows for files not in pilot
                updated_baseline[key] = row_dict
                continue
            
            # If row wasn't matched to any extracted schema
            if key not in matched_baseline_keys:
                # Check if this is a wildcard row
                if self.is_wildcard_row(row_dict):
                    # Wildcard rows are logical/metadata - never remove them
                    # Keep them unchanged
                    updated_baseline[key] = row_dict
                    
                    # Parse line and position for evidence
                    line_str = row_dict.get('Line_in_file', '*')
                    pos_str = row_dict.get('Position_in_File', '*')
                    try:
                        line_val = int(line_str) if line_str != '*' else 0
                    except ValueError:
                        line_val = 0
                    try:
                        pos_val = int(pos_str) if pos_str != '*' else 0
                    except ValueError:
                        pos_val = 0
                    
                    evidence = Evidence(
                        action='unchanged',
                        schema_key=key,
                        swat_file=swat_file,
                        line_in_file=line_val,
                        position_in_file=pos_val,
                        swat_code_type=row_dict.get('Swat_code type', ''),
                        variable_name=row_dict.get('SWAT_Code_Variable_Name', ''),
                        notes='wildcard row; keep even if not mapped to read structure'
                    )
                    evidence_list.append(evidence)
                else:
                    # Only remove if BOTH Line_in_file AND Position_in_File are real numbers
                    # This row exists in baseline but not in extracted schema
                    file_summaries[swat_file].removed += 1
                    
                    # Parse line and position
                    try:
                        line_val = int(row_dict.get('Line_in_file', '0') or 0)
                    except ValueError:
                        line_val = 0
                    try:
                        pos_val = int(row_dict.get('Position_in_File', '0') or 0)
                    except ValueError:
                        pos_val = 0
                    
                    evidence = Evidence(
                        action='removed',
                        schema_key=key,
                        swat_file=swat_file,
                        line_in_file=line_val,
                        position_in_file=pos_val,
                        swat_code_type=row_dict.get('Swat_code type', ''),
                        variable_name=row_dict.get('SWAT_Code_Variable_Name', ''),
                        notes='Not found in current code'
                    )
                    evidence_list.append(evidence)
        
        # Update row counts
        for fname, summary in file_summaries.items():
            summary.updated_rows = summary.baseline_rows - summary.removed + summary.added
        
        # Convert back to list
        updated_rows = list(updated_baseline.values())
        
        return updated_rows, evidence_list, dict(file_summaries)
    
    def write_updated_csv(self, output_path: str, updated_rows: List[Dict]):
        """Write updated CSV."""
        with open(output_path, 'w', newline='', encoding='utf-8') as f:
            writer = csv.DictWriter(f, fieldnames=self.header)
            writer.writeheader()
            writer.writerows(updated_rows)
    
    def write_evidence_csv(self, output_path: str, evidence_list: List[Evidence]):
        """Write evidence CSV."""
        with open(output_path, 'w', newline='', encoding='utf-8') as f:
            if evidence_list:
                writer = csv.DictWriter(f, fieldnames=list(asdict(evidence_list[0]).keys()))
                writer.writeheader()
                for ev in evidence_list:
                    writer.writerow(asdict(ev))
    
    def write_summary_csv(self, output_path: str, summaries: Dict[str, FileSummary]):
        """Write file summary CSV."""
        with open(output_path, 'w', newline='', encoding='utf-8') as f:
            if summaries:
                writer = csv.DictWriter(f, fieldnames=list(asdict(list(summaries.values())[0]).keys()))
                writer.writeheader()
                for summary in summaries.values():
                    writer.writerow(asdict(summary))
    
    def write_schema_ndjson(self, output_path: str, schemas: List[FieldSchema]):
        """Write extracted schema as NDJSON."""
        with open(output_path, 'w', encoding='utf-8') as f:
            for schema in schemas:
                json.dump(asdict(schema), f)
                f.write('\n')


def main():
    """Main execution."""
    base_dir = '/home/runner/work/swatplus_ug/swatplus_ug'
    src_dir = os.path.join(base_dir, 'src')
    baseline_csv = os.path.join(base_dir, 'Rev_61_0_nbs_inputs_master_full.csv')
    
    print("=" * 80)
    print("SWAT+ Schema Extraction and CSV Update Tool")
    print("=" * 80)
    print()
    
    # Extract schemas
    print("Step 1: Extracting schemas from Fortran source...")
    parser = FortranParser(src_dir)
    schemas = parser.extract_all_schemas()
    print(f"  Extracted {len(schemas)} schema elements")
    
    # Group by file for reporting
    by_file = defaultdict(list)
    for s in schemas:
        by_file[s.file_name].append(s)
    
    for fname, slist in sorted(by_file.items()):
        print(f"    {fname}: {len(slist)} elements")
    print()
    
    # Update CSV
    print("Step 2: Updating CSV...")
    updater = CSVUpdater(baseline_csv)
    updated_rows, evidence, summaries = updater.update_csv(schemas)
    print(f"  Total rows in updated CSV: {len(updated_rows)}")
    print()
    
    # Write outputs
    print("Step 3: Writing outputs...")
    
    output_csv = os.path.join(base_dir, 'updated_inputs.csv')
    updater.write_updated_csv(output_csv, updated_rows)
    print(f"  ✓ Updated CSV: {output_csv}")
    
    evidence_csv = os.path.join(base_dir, 'evidence_rows.csv')
    updater.write_evidence_csv(evidence_csv, evidence)
    print(f"  ✓ Evidence CSV: {evidence_csv}")
    
    summary_csv = os.path.join(base_dir, 'per_file_summary.csv')
    updater.write_summary_csv(summary_csv, summaries)
    print(f"  ✓ Summary CSV: {summary_csv}")
    
    schema_json = os.path.join(base_dir, 'extracted_schema.ndjson')
    updater.write_schema_ndjson(schema_json, schemas)
    print(f"  ✓ Schema NDJSON: {schema_json}")
    print()
    
    # Print summaries
    print("=" * 80)
    print("File Summaries")
    print("=" * 80)
    for fname in sorted(summaries.keys()):
        s = summaries[fname]
        print(f"\n{fname}:")
        print(f"  Baseline rows: {s.baseline_rows}")
        print(f"  Extracted rows: {s.extracted_rows}")
        print(f"  Updated rows: {s.updated_rows}")
        print(f"  Changes:")
        print(f"    Added: {s.added}")
        print(f"    Updated: {s.updated}")
        print(f"    Removed: {s.removed}")
        print(f"    Unchanged: {s.unchanged}")
    
    print("\n" + "=" * 80)
    print("Done!")
    print("=" * 80)


if __name__ == '__main__':
    main()
