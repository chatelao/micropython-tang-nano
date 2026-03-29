import sys
import os
import inspect
from unittest.mock import MagicMock

# Mock 'machine' module (since it's a MicroPython-specific C module)
sys.modules['machine'] = MagicMock()

# Find the absolute path to the repository root
repo_root = os.path.dirname(os.path.abspath(__file__))

# Add the directory containing tt.py to sys.path
tt_path = os.path.join(repo_root, 'examples/tt_echo')
sys.path.append(tt_path)

try:
    import tt

    docs_content = "# Tiny Tapeout Helper Library (`tt.py`) Documentation\n\n"
    docs_content += "This library provides a simplified interface for interacting with Tiny Tapeout designs via the APB2 bus (Slot 1).\n\n"

    docs_content += "## Functions\n\n"
    docs_content += "| Function | Description |\n"
    docs_content += "| --- | --- |\n"

    # List of functions in the order we want to display them
    functions = [
        'tt_init',
        'set_clock',
        'set_ui',
        'set_uio',
        'set_uoe',
        'get_uo',
        'get_uio',
        'get_uoe',
        'send'
    ]

    for name in functions:
        if hasattr(tt, name):
            obj = getattr(tt, name)
            sig = inspect.signature(obj)
            doc = inspect.getdoc(obj) or "No documentation available."
            # Clean up the docstring for Markdown table compatibility
            doc = doc.replace('\n', ' ').replace('|', '\\|')
            docs_content += f"| `tt.{name}{sig}` | {doc} |\n"

    # Ensure output directory exists (it should be examples/tt_echo)
    output_path = os.path.join(tt_path, 'TT_HELPERS.md')
    with open(output_path, 'w') as f:
        f.write(docs_content)

    print(f"Documentation generated successfully in {output_path}")

except Exception as e:
    print(f"Error generating documentation: {e}")
    sys.exit(1)
