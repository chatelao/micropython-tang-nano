import os
import sys

def test_structure():
    expected_dirs = [
        'definitions',
        'src',
        'src/fpga/bitstream',
        'test',
        'examples',
        'examples/blink',
        'examples/tt_echo',
        'test/examples',
        '.github'
    ]
    expected_files = [
        'README.md',
        'ROADMAP.md',
        'src/fpga/bitstream/tang_nano_4k_m3.fs',
        'GEMINI.md',
        'examples/blink/blink.py',
        'examples/tt_echo/tt_project.v',
        'examples/tt_echo/tt_echo.py',
        'test/examples/test_blink.robot',
        'test/examples/test_tt_echo.robot'
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
