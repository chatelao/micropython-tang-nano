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
        'examples/tiny-tapeouts',
        'examples/tiny-tapeouts/tt_echo',
        'examples/tiny-tapeouts/tt_vga_to_hdmi',
        'examples/cpus',
        'examples/cpus/neorv32',
        'examples/cpus/serv_riscv',
        '.github'
    ]
    expected_files = [
        'README.md',
        'ROADMAP.md',
        'src/fpga/bitstream/tang_nano_4k_m3.fs',
        'src/fpga/bitstream/tang_nano_4k_m3.md',
        'FPGA_BRIDGE_USAGE.md',
        'GEMINI.md',
        'HOWTO_TINY_TAPEOUT.md',
        'M3_FPGA_INTEGRATIONS.md',
        'M3_MICROPYTHON.md',
        'm3_subsystem.puml',
        'AUDIT.md',
        'COMPLIANCE_TESTS.md',
        'SERIAL_PORT_ACCESS.md',
        'TOOLCHAIN_SETUP.md',
        'test/examples/test_blink.robot',
        'test/examples/test_tt_echo.robot',
        'test/examples/test_neorv32.robot',
        'test/examples/test_serv.robot',
        'test/examples/test_tt_vga_hdmi.robot',
        'examples/blink/blink.py',
        'examples/tiny-tapeouts/tt_echo/tt_project.v',
        'examples/tiny-tapeouts/tt_echo/tt_echo.py',
        'examples/tiny-tapeouts/tt_echo/tt.py',
        'examples/tiny-tapeouts/tt_echo/TT_HELPERS.md',
        'examples/tiny-tapeouts/tt_echo/architecture.puml',
        'examples/tiny-tapeouts/tt_vga_to_hdmi/README.md',
        'examples/tiny-tapeouts/tt_vga_to_hdmi/architecture.puml',
        'examples/tiny-tapeouts/tt_vga_to_hdmi/tt_project.v',
        'examples/tiny-tapeouts/tt_vga_to_hdmi/tt_vga_hdmi.py',
        'examples/tiny-tapeouts/tt_vga_to_hdmi/tt_vga_hdmi_wrapper.v',
        'examples/tiny-tapeouts/tt_vga_to_hdmi/hdmi_encoder.v',
        'examples/tiny-tapeouts/tt_vga_to_hdmi/tt_vga_hdmi.cst',
        'examples/cpus/neorv32/neorv32.py',
        'examples/cpus/serv_riscv/serv_test.py',
        'generate_tt_docs.py'
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
