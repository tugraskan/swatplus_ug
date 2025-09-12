#!/usr/bin/env python3
"""
SWAT+ HRU Connectivity Analysis Tool

This script analyzes SWAT+ configuration files to understand HRU connectivity
and trace how burn effects in one HRU can affect downstream water yield.

Usage: python analyze_connectivity.py [path_to_swat_project]
"""

import os
import sys
import re
from pathlib import Path


class SWATPlusConnectivityAnalyzer:
    def __init__(self, project_path="."):
        self.project_path = Path(project_path)
        self.hru_data = {}
        self.routing_units = {}
        self.connectivity_map = {}
        
    def read_object_count(self):
        """Read object.cnt to understand the model structure."""
        obj_file = self.project_path / "object.cnt"
        if not obj_file.exists():
            print(f"Warning: {obj_file} not found")
            return None
            
        with open(obj_file, 'r') as f:
            lines = f.readlines()
            
        # Skip header lines and read data
        for line in lines[2:]:  # Skip title and header
            if line.strip():
                parts = line.split()
                if len(parts) >= 4:
                    name = parts[0]
                    total_objects = int(parts[2])
                    hru_count = int(parts[3])
                    rtu_count = int(parts[5])
                    
                    return {
                        'name': name,
                        'total_objects': total_objects, 
                        'hru_count': hru_count,
                        'routing_unit_count': rtu_count
                    }
        return None
        
    def read_hru_connections(self):
        """Read hru.con to get HRU basic information."""
        hru_file = self.project_path / "hru.con"
        if not hru_file.exists():
            print(f"Warning: {hru_file} not found")
            return
            
        with open(hru_file, 'r') as f:
            lines = f.readlines()
            
        # Skip header and read HRU data
        for i, line in enumerate(lines[2:], 1):  # Skip title and header
            if line.strip():
                parts = line.split()
                if len(parts) >= 8:
                    hru_id = int(parts[0])
                    hru_name = parts[1]
                    area = float(parts[3])
                    lat = float(parts[4])
                    lon = float(parts[5])
                    elev = float(parts[6])
                    
                    self.hru_data[hru_id] = {
                        'name': hru_name,
                        'area_ha': area,
                        'lat': lat,
                        'lon': lon,
                        'elevation': elev,
                        'connects_to': [],
                        'receives_from': []
                    }
                    
    def read_routing_units(self):
        """Read routing unit files to understand HRU groupings."""
        # Read routing unit definitions
        ru_def_file = self.project_path / "rout_unit.def"
        if ru_def_file.exists():
            with open(ru_def_file, 'r') as f:
                lines = f.readlines()
                
            for line in lines[2:]:  # Skip header
                if line.strip():
                    parts = line.split()
                    if len(parts) >= 4:
                        ru_id = int(parts[0])
                        ru_name = parts[1]
                        elem_total = int(parts[2])
                        
                        # Read element list
                        elements = []
                        for i in range(3, min(len(parts), 3 + elem_total)):
                            elements.append(int(parts[i]))
                            
                        self.routing_units[ru_id] = {
                            'name': ru_name,
                            'elements': elements,
                            'element_count': elem_total
                        }
                        
        # Read routing unit connections
        ru_con_file = self.project_path / "rout_unit.con"
        if ru_con_file.exists():
            with open(ru_con_file, 'r') as f:
                lines = f.readlines()
                
            for line in lines[2:]:  # Skip header
                if line.strip():
                    parts = line.split()
                    if len(parts) >= 12:
                        ru_id = int(parts[0])
                        out_total = int(parts[10])
                        
                        # Parse outlet connections
                        if ru_id in self.routing_units:
                            outlets = []
                            idx = 11
                            for i in range(out_total):
                                if idx + 2 < len(parts):
                                    obj_type = parts[idx]
                                    obj_id = int(parts[idx + 1])
                                    hyd_type = parts[idx + 2]
                                    outlets.append({
                                        'type': obj_type,
                                        'id': obj_id, 
                                        'hyd_type': hyd_type
                                    })
                                    idx += 4  # Skip fraction field
                            
                            self.routing_units[ru_id]['outlets'] = outlets
                            
    def build_connectivity_map(self):
        """Build a connectivity map showing flow paths."""
        # Map HRUs to their routing units
        hru_to_ru = {}
        for ru_id, ru_data in self.routing_units.items():
            for hru_id in ru_data.get('elements', []):
                if hru_id in self.hru_data:
                    hru_to_ru[hru_id] = ru_id
                    
        # Build connectivity based on routing unit connections
        for ru_id, ru_data in self.routing_units.items():
            outlets = ru_data.get('outlets', [])
            
            # Find HRUs in this routing unit
            source_hrus = ru_data.get('elements', [])
            
            for outlet in outlets:
                if outlet['type'] == 'sdc':  # Stream/channel connection
                    # This routing unit flows to a channel
                    for hru_id in source_hrus:
                        if hru_id in self.hru_data:
                            if 'downstream_channel' not in self.hru_data[hru_id]:
                                self.hru_data[hru_id]['downstream_channel'] = []
                            self.hru_data[hru_id]['downstream_channel'].append(outlet['id'])
                            
                elif outlet['type'] == 'aqu':  # Aquifer connection
                    for hru_id in source_hrus:
                        if hru_id in self.hru_data:
                            if 'downstream_aquifer' not in self.hru_data[hru_id]:
                                self.hru_data[hru_id]['downstream_aquifer'] = []
                            self.hru_data[hru_id]['downstream_aquifer'].append(outlet['id'])
                            
    def analyze_burn_impact_potential(self, burned_hru_id):
        """Analyze potential downstream impacts from a burn in specified HRU."""
        if burned_hru_id not in self.hru_data:
            print(f"HRU {burned_hru_id} not found in model")
            return
            
        print(f"\n=== BURN IMPACT ANALYSIS FOR HRU {burned_hru_id} ===")
        
        burned_hru = self.hru_data[burned_hru_id]
        print(f"Burned HRU: {burned_hru['name']}")
        print(f"Area: {burned_hru['area_ha']:.2f} ha")
        print(f"Elevation: {burned_hru['elevation']:.1f} m")
        
        # Find which routing unit this HRU belongs to
        hru_routing_unit = None
        for ru_id, ru_data in self.routing_units.items():
            if burned_hru_id in ru_data.get('elements', []):
                hru_routing_unit = ru_id
                break
                
        if hru_routing_unit:
            print(f"Routing Unit: {hru_routing_unit} ({self.routing_units[hru_routing_unit]['name']})")
            
            # List other HRUs in the same routing unit (directly affected)
            other_hrus = [hru for hru in self.routing_units[hru_routing_unit]['elements'] 
                         if hru != burned_hru_id and hru in self.hru_data]
            
            if other_hrus:
                print(f"\nHRUs in same routing unit (directly affected by increased runoff):")
                for hru_id in other_hrus:
                    hru = self.hru_data[hru_id]
                    print(f"  HRU {hru_id}: {hru['name']} ({hru['area_ha']:.2f} ha)")
                    
            # Show downstream connections
            outlets = self.routing_units[hru_routing_unit].get('outlets', [])
            if outlets:
                print(f"\nDownstream connections:")
                for outlet in outlets:
                    print(f"  → {outlet['type'].upper()} {outlet['id']} (flow type: {outlet['hyd_type']})")
                    
        # Check for direct HRU connections (if any)
        downstream_channels = burned_hru.get('downstream_channel', [])
        downstream_aquifers = burned_hru.get('downstream_aquifer', [])
        
        if downstream_channels:
            print(f"\nDirect channel connections: {downstream_channels}")
        if downstream_aquifers:
            print(f"Direct aquifer connections: {downstream_aquifers}")
            
        return {
            'burned_hru': burned_hru_id,
            'routing_unit': hru_routing_unit,
            'affected_hrus': other_hrus if hru_routing_unit else [],
            'downstream_channels': downstream_channels,
            'downstream_aquifers': downstream_aquifers
        }
        
    def print_summary(self):
        """Print a summary of the model connectivity."""
        obj_info = self.read_object_count()
        
        print("=== SWAT+ MODEL CONNECTIVITY SUMMARY ===")
        if obj_info:
            print(f"Project: {obj_info['name']}")
            print(f"Total Objects: {obj_info['total_objects']}")
            print(f"HRUs: {obj_info['hru_count']}")
            print(f"Routing Units: {obj_info['routing_unit_count']}")
            
        print(f"\nLoaded {len(self.hru_data)} HRUs")
        print(f"Loaded {len(self.routing_units)} Routing Units")
        
        # Show HRU summary
        if self.hru_data:
            total_area = sum(hru['area_ha'] for hru in self.hru_data.values())
            print(f"Total HRU Area: {total_area:.2f} ha")
            
            min_elev = min(hru['elevation'] for hru in self.hru_data.values())
            max_elev = max(hru['elevation'] for hru in self.hru_data.values())
            print(f"Elevation Range: {min_elev:.1f} - {max_elev:.1f} m")
            
        # Show routing unit summary
        print(f"\nRouting Unit Details:")
        for ru_id, ru_data in self.routing_units.items():
            elements = ru_data.get('elements', [])
            outlets = ru_data.get('outlets', [])
            print(f"  RU {ru_id}: {ru_data['name']} - {len(elements)} HRUs → {len(outlets)} outlets")
            
    def run_analysis(self):
        """Run complete connectivity analysis."""
        print("Reading SWAT+ configuration files...")
        
        self.read_hru_connections()
        self.read_routing_units()
        self.build_connectivity_map()
        
        self.print_summary()
        
        # Example burn analysis for first HRU
        if self.hru_data:
            first_hru = min(self.hru_data.keys())
            self.analyze_burn_impact_potential(first_hru)
            
        print("\n=== FILES TO CHECK FOR CONNECTIVITY ===")
        print("Configuration Files:")
        print("  - object.cnt: Model structure summary")
        print("  - hru.con: HRU basic properties")
        print("  - rout_unit.con: Routing unit connections")
        print("  - rout_unit.def: HRU groupings in routing units")
        print("  - ls_unit.ele: Landscape element definitions")
        print("\nSource Code Files:")
        print("  - src/hyd_connect.f90: Main connectivity setup")
        print("  - src/hru_control.f90: HRU flow routing")
        print("  - src/ru_control.f90: Routing unit aggregation")
        print("  - src/pl_burnop.f90: Burn operation effects")
        print("  - src/rls_routesurf.f90: Surface flow routing")


def main():
    """Main function."""
    if len(sys.argv) > 1:
        project_path = sys.argv[1]
    else:
        project_path = "."
        
    if not os.path.exists(project_path):
        print(f"Error: Path {project_path} does not exist")
        return 1
        
    analyzer = SWATPlusConnectivityAnalyzer(project_path)
    analyzer.run_analysis()
    
    return 0


if __name__ == "__main__":
    sys.exit(main())