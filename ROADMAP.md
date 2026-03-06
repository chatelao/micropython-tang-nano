# Roadmap

Next steps for the MicroPython for Tang Nano 4K project:

- [ ] 4. Integrate MicroPython core and generate required headers (QSTRs, version, etc.).
- [ ] 5. Resolve compilation issues in `main.c`, `mphalport.c`, and `uart.c`.
- [ ] 6. Successfully link the firmware and generate `firmware.bin`.
- [ ] 7. Implement basic GPIO and LED control (Machine.Pin class).
- [ ] 8. Implement timer and delay using Cortex-M3 SysTick (Machine.Timer class).
- [ ] 9. Implement basic machine module with UART class.
- [ ] 10. Research and document external flash interface for MicroPython filesystem.

## Past Steps
- [x] 1. Initialize project structure and documentation.
- [x] 2. Research and document target hardware specifications.
- [x] 3. Set up MicroPython cross-compilation toolchain for the target architecture.
- [x] 4. Implement minimal MicroPython port with UART REPL (Initial structure and UART driver).
- [x] 5. Document detailed memory map for Cortex-M3.
- [x] 6. Document peripheral register mapping.
- [x] Initial setup and project organization.
- [x] Install ARM GNU Toolchain and clone MicroPython core.
- [x] Create port-specific configuration and header stubs.
