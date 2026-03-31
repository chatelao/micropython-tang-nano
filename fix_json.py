import json
import sys
import re

def fix_json(filepath):
    with open(filepath, 'r') as f:
        data = json.load(f)

    for module_name, module_data in data.get('modules', {}).items():
        for cell_name, cell_data in module_data.get('cells', {}).items():
            if cell_data.get('type') == 'Gowin_EMPU_M3':
                # 1. Rename type to EMCU for nextpnr
                cell_data['type'] = 'EMCU'

                # 2. Fix port names
                new_connections = {}
                for port_name, port_bits in cell_data.get('connections', {}).items():
                    new_port_name = port_name

                    # SYS_CLK -> MSSCLK
                    if port_name == 'SYS_CLK':
                        new_port_name = 'MSSCLK'

                    # nextpnr-gowin expects GPIOOUTEN9 instead of GPIOOUTEN [9]
                    # Yosys splitnets -ports generates names like GPIOOUTEN.9 or similar
                    # but here we handle brackets just in case.
                    new_port_name = new_port_name.replace(' ', '').replace('[', '').replace(']', '')

                    new_connections[new_port_name] = port_bits

                cell_data['connections'] = new_connections

    with open(filepath, 'w') as f:
        json.dump(data, f, indent=4)

if __name__ == '__main__':
    fix_json(sys.argv[1])
