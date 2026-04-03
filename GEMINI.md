# Project Goal
- Create a working MicroPython implementation for Tang Nano 4K.

# Default Architecture
- **Flash**: "Split Flash" architecture is the default. Internal Flash (`0x00000000`) is used for the vector table and reset handler, while External SPI Flash (`0xA0000000`) stores the MicroPython runtime and filesystem.
- **RAM**: 8MB External PSRAM (`0x60000000`) is the default primary heap for MicroPython, utilizing the `MICROPY_GC_SPLIT_HEAP` configuration.
- **FPGA Bridge**: APB2 Expansion Slots (Variant 2 in `M3_FPGA_INTEGRATIONS.md`) are the default method for M3-to-FPGA communication, providing register-mapped access.

# Planning & Progress tracking
- Keep an up to date file `ROADMAP.md` with the next 5 steps and all past steps having checkboxes.
- Feature-specific roadmaps: `examples/tiny-tapeouts/tt_vga_to_hdmi/ROADMAP_VGA_HDMI.md`.

# Project structure
- `/` - Keep root directory clean with relevant `.md` files: `AUDIT.md`, `COMPLIANCE_TESTS.md`, `GEMINI.md`, `HOWTO_TINY_TAPEOUT.md`, `M3_FPGA_INTEGRATIONS.md`, `M3_MICROPYTHON.md`, `README.md`, `ROADMAP.md`, `SERIAL_PORT_ACCESS.md`, `TOOLCHAIN_SETUP.md`.
- `/definitions` - Datasheets and Standards to be used, download and convert to `.md` on first time read.
- `/examples` - Example MicroPython scripts and FPGA projects.
- `/test` - Unit, System and End-2-End test concepts and cases to be executed after each change. Use Renode to verify the binaries.
- `/src` - Source files, only accepted if working and covered by tests.
- `/.github/workflows` - For release tag publish the installer/binary.
- `README.md` - Update overview of the product.
