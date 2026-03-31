import json
import sys
import re

def fix_json(filepath):
    with open(filepath, 'r') as f:
        data = json.load(f)

    # 1. First, rename the module definition itself if it exists
    if 'modules' in data:
        if 'Gowin_EMPU_M3' in data['modules']:
            m3_mod = data['modules'].pop('Gowin_EMPU_M3')

            # Rename ports in the module definition
            new_ports = {}
            for port_name, port_data in m3_mod.get('ports', {}).items():
                new_port_name = port_name
                if port_name == 'SYS_CLK':
                    new_port_name = 'MSSCLK'
                new_port_name = new_port_name.replace(' ', '').replace('[', '').replace(']', '').replace('.', '')
                new_ports[new_port_name] = port_data
            m3_mod['ports'] = new_ports

            data['modules']['EMCU'] = m3_mod

    # 2. Then rename all cell instances and their connections
    for module_name, module_data in data.get('modules', {}).items():
        for cell_name, cell_data in module_data.get('cells', {}).items():
            if cell_data.get('type') == 'Gowin_EMPU_M3':
                # Rename type to EMCU for nextpnr
                cell_data['type'] = 'EMCU'

                # Fix port names in connections
                new_connections = {}
                for port_name, port_bits in cell_data.get('connections', {}).items():
                    new_port_name = port_name

                    # SYS_CLK -> MSSCLK
                    if port_name == 'SYS_CLK':
                        new_port_name = 'MSSCLK'

                    # Flatten port name (remove spaces, brackets, dots)
                    new_port_name = new_port_name.replace(' ', '').replace('[', '').replace(']', '').replace('.', '')

                    new_connections[new_port_name] = port_bits

                cell_data['connections'] = new_connections

    with open(filepath, 'w') as f:
        json.dump(data, f, indent=4)

if __name__ == '__main__':
    fix_json(sys.argv[1])
