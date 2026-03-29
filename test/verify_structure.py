import os
import sys

def test_structure():
    expected_dirs = [
        'definitions',
        'src',
        'src/fpga/bitstream',
        'test',
        'test/examples',
        'examples',
        'examples/blink',
        'examples/tt_echo',
        '.github'
    ]
    expected_files = [
        'README.md',
        'ROADMAP.md',
        'src/fpga/bitstream/tang_nano_4k_m3.fs',
        'FPGA_BRIDGE_USAGE.md',
        'GEMINI.md',
        'HOWTO_TINY_TAPEOUT.md',
        'test/examples/test_blink.robot',
        'test/examples/test_tt_echo.robot',
        'test/examples/test_neorv32.robot',
        'test/examples/test_serv.robot',
        'examples/blink/blink.py',
        'examples/tt_echo/tt_project.v',
        'examples/tt_echo/tt_echo.py'
    ]

    missing = []

    for d in expected_dirs:
        if not os.path.isdir(d):
            missing.append(f"Directory missing: {d}")

    for f in expected_files:
        if not os.path.isfile(f):
            missing.append(f"File missing: {f}")

    if missing:
        for m in missing:
            print(m)
        sys.exit(1)
    else:
        print("Project structure verification passed!")
        sys.exit(0)

if __name__ == "__main__":
    test_structure()
