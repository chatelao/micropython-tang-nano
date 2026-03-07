# Roadmap

Next steps for the MicroPython for Tang Nano 4K project:

- [ ] 13. Implement PWM support (Machine.PWM class).
- [ ] 14. Implement I2C support (Machine.I2C class) using the hardware I2C master core.
- [ ] 15. Implement SPI support (Machine.SPI class) using the hardware SPI master core.
- [ ] 16. Support User Flash access (Machine.Flash class) for GW1NSR-4 devices.
- [ ] 17. Implement hardware floating point support and optimize for performance.

## Past Steps
- [x] 1. Initialize project structure and documentation.
- [x] 2. Research and document target hardware specifications.
- [x] 3. Set up MicroPython cross-compilation toolchain for the target architecture.
- [x] 4. Implement minimal MicroPython port with UART REPL (Initial structure and UART driver).
- [x] 5. Document detailed memory map for Cortex-M3.
- [x] 6. Document peripheral register mapping.
- [x] 7. Integrate MicroPython core and generate required headers (QSTRs, version, etc.).
- [x] 8. Resolve compilation issues in `main.c`, `mphalport.c`, and `uart.c`.
- [x] 9. Successfully link the firmware and generate `firmware.bin` (Verified for simulation).
- [x] 10. Implement GitHub Actions for build and release CI/CD.
- [x] 11. Implement basic GPIO and LED control (Machine.Pin class).
- [x] 12. Implement timer and delay using Cortex-M3 SysTick (Machine.Timer class).
- [x] 13. Document the interface from the M3 core to the FPGA fabric.
- [x] Initial setup and project organization.
- [x] Install ARM GNU Toolchain and clone MicroPython core.
- [x] Create port-specific configuration and header stubs.
