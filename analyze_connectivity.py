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
                    if len(parts) >= 5:
                        ru_id = int(parts[0])
                        ru_name = parts[1]
                        elem_total = int(parts[2])
                        
                        # Handle HRU ranges (format: start_hru -end_hru)
                        elements = []
                        if elem_total > 0 and len(parts) >= 5:
                            hru_start = int(parts[3])
                            hru_end_str = parts[4]
                            
                            # Handle negative numbers (range format)
                            if hru_end_str.startswith('-'):
                                hru_end = int(hru_end_str[1:])  # Remove minus sign
                                # Generate range of HRU IDs
                                for hru_id in range(hru_start, hru_end + 1):
                                    elements.append(hru_id)
                            else:
                                # Single HRU or different format
                                elements.append(hru_start)
                                if len(parts) > 4:
                                    elements.append(int(hru_end_str))
                            
                        self.routing_units[ru_id] = {
                            'name': ru_name,
                            'elements': elements,
                            'element_count': len(elements),
                            'hru_range': f"{hru_start}-{hru_end}" if 'hru_end' in locals() else str(hru_start)
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
        
    def analyze_specific_hru_connectivity(self, target_hru_id):
        """Analyze connectivity for a specific HRU (e.g., HRU 3895)."""
        if target_hru_id not in self.hru_data:
            print(f"HRU {target_hru_id} not found in model")
            return
            
        print(f"\n=== DETAILED CONNECTIVITY ANALYSIS FOR HRU {target_hru_id} ===")
        
        target_hru = self.hru_data[target_hru_id]
        print(f"HRU Details:")
        print(f"  Name: {target_hru['name']}")
        print(f"  Area: {target_hru['area_ha']:.5f} ha")
        print(f"  Coordinates: {target_hru['lat']:.5f}°N, {target_hru['lon']:.5f}°W")
        print(f"  Elevation: {target_hru['elevation']:.1f} m")
        
        # Find which routing unit this HRU belongs to
        hru_routing_unit = None
        for ru_id, ru_data in self.routing_units.items():
            if target_hru_id in ru_data.get('elements', []):
                hru_routing_unit = ru_id
                break
                
        if hru_routing_unit:
            ru_info = self.routing_units[hru_routing_unit]
            print(f"\nRouting Unit Assignment:")
            print(f"  Routing Unit: {hru_routing_unit} ({ru_info['name']})")
            print(f"  HRU Range: {ru_info.get('hru_range', 'N/A')}")
            print(f"  Total HRUs in RU: {len(ru_info['elements'])}")
            print(f"  All HRUs: {ru_info['elements']}")
            
            # Show upstream HRUs in the same routing unit (potential sources of flow)
            upstream_hrus = []
            for hru_id in ru_info['elements']:
                if hru_id != target_hru_id and hru_id in self.hru_data:
                    other_hru = self.hru_data[hru_id]
                    if other_hru['elevation'] > target_hru['elevation']:
                        upstream_hrus.append((hru_id, other_hru))
                        
            if upstream_hrus:
                print(f"\nUpstream HRUs (same routing unit, higher elevation):")
                upstream_hrus.sort(key=lambda x: x[1]['elevation'], reverse=True)
                for hru_id, hru_data in upstream_hrus:
                    elev_diff = hru_data['elevation'] - target_hru['elevation']
                    print(f"  HRU {hru_id}: {hru_data['area_ha']:.3f} ha at {hru_data['elevation']:.1f}m (+{elev_diff:.1f}m higher)")
                    
            # Show how burns in upstream HRUs would affect this HRU
            if upstream_hrus:
                print(f"\nBurn Impact Analysis:")
                print(f"  - Burns in any of the {len(upstream_hrus)} upstream HRUs would increase curve numbers")
                print(f"  - Increased surface runoff would flow to HRU {target_hru_id}")
                print(f"  - Especially significant burns in larger upstream HRUs:")
                large_upstream = [(hid, hdata) for hid, hdata in upstream_hrus if hdata['area_ha'] > 1.0]
                for hru_id, hru_data in large_upstream[:5]:  # Show top 5 largest
                    print(f"    → HRU {hru_id}: {hru_data['area_ha']:.3f} ha")
                    
        return {
            'target_hru': target_hru_id,
            'routing_unit': hru_routing_unit,
            'upstream_hrus': [h[0] for h in upstream_hrus] if 'upstream_hrus' in locals() else [],
            'hru_details': target_hru
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
    if len(sys.argv) > 1 and sys.argv[1] in ['--help', '-h', 'help']:
        print(__doc__)
        print("\nUsage Examples:")
        print("  python analyze_connectivity.py                    # Analyze current directory")
        print("  python analyze_connectivity.py data/Osu_1hru     # Analyze specific project")
        print("  python analyze_connectivity.py /path/to/swat/project")
        return 0
        
    if len(sys.argv) > 1:
        project_path = sys.argv[1]
    else:
        project_path = "."
        
    if not os.path.exists(project_path):
        print(f"Error: Path {project_path} does not exist")
        print("Use 'python analyze_connectivity.py --help' for usage information")
        return 1
        
    analyzer = SWATPlusConnectivityAnalyzer(project_path)
    analyzer.run_analysis()
    
    return 0


if __name__ == "__main__":
    sys.exit(main())