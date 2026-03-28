# Project Goal
- Create a working MicroPython implementation for Tang Nano 4K.

# Planning & Progress tracking
- Keep an up to date file `ROADMAP.md` with the next 5 steps and all past steps having checkboxes.

# Project structure
- `/` - Keep root directory clean with relevant `.md` files: `AUDIT.md`, `COMPLIANCE_TESTS.md`, `GEMINI.md`, `M3_FPGA_INTEGRATIONS.md`, `M3_MICROPYTHON.md`, `README.md`, `ROADMAP.md`, `SERIAL_PORT_ACCESS.md`, `TOOLCHAIN_SETUP.md`.
- `/definitions` - Datasheets and Standards to be used, download and convert to `.md` on first time read
- `/examples` - Example MicroPython scripts and FPGA projects.
- `/test` - Unit, System and End-2-End test concepts and cases to be executed after each change. Use Renode to verify the binaries.
- `/src` - Source files, only accepted if working and covered by tests
- `/.github/workflows` - For release tag publish the installer/binary
- `README.md` - Update overview of the product
