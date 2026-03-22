# Roadmap

Next steps for the MicroPython for Tang Nano 4K project:

## In Progress / Planned
- [x] 20. Implement Hardware SPI Master support.
- [x] 21. Implement Watchdog Timer (WDT) support.
- [x] 22. Implement Real-Time Clock (RTC) support.
- [x] 23. Implement Power Management (Sleep/Deep Sleep modes).
- [ ] 24. Optimization: Increase heap size and optimize SRAM usage.

## Completed Milestones
- [x] 1. Initialize project structure and documentation.
- [x] 2. Research and document target hardware specifications.
- [x] 3. Set up MicroPython cross-compilation toolchain for the target architecture.
- [x] 4. Implement minimal MicroPython port with UART REPL.
- [x] 5. Document detailed memory map for Cortex-M3.
- [x] 6. Document peripheral register mapping.
- [x] 7. Integrate MicroPython core and generate required headers (QSTRs, version, etc.).
- [x] 8. Resolve compilation issues in `main.c`, `mphalport.c`, and `uart.c`.
- [x] 9. Successfully link the firmware and generate `firmware.bin` (Verified for simulation).
- [x] 10. Implement GitHub Actions for build and release CI/CD.
- [x] 11. Implement basic GPIO and LED control (Machine.Pin class).
- [x] 12. Implement timer and delay using Cortex-M3 SysTick (Machine.Timer class).
- [x] 13. Implement PWM support (Machine.PWM class).
- [x] 14. Implement SoftI2C support (Machine.I2C and Machine.SoftI2C classes).
- [x] 15. Implement SPI support (Machine.SPI and Machine.SoftSPI classes).
- [x] 16. Implement ADC support (Machine.ADC class).
- [x] 17. Implement Virtual File System (VFS) and Flash storage support.
- [x] 18. Implement Hardware Interrupts for GPIO.
- [x] 19. Implement Hardware I2C Master support.
