# MicroPython for Tang Nano 4K

## Goal
This project aims to port MicroPython to the "Sipeed Tang Nano 4K" FPGA development board.

For a comprehensive overview of the port, including hardware details, installation, and usage, see the [Tang Nano 4K MicroPython Port Guide](documentation/TANG_NANO_MICROPYTHON_GUIDE.md).

## Supported MicroPython Features
- **Core Modules**: `machine`, `time`/`utime`, `uos`, `io`.
- **Machine Module Peripherals**:
    - `Pin`: GPIO control (0-15) with hardware interrupt support.
    - `Timer`: Hardware timers for periodic or one-shot events.
    - `PWM`: Hardware-based Pulse Width Modulation.
    - `ADC`: 12-bit Analog-to-Digital Converter.
    - `I2C` / `SoftI2C`: Hardware and software I2C Master support.
    - `SPI` / `SoftSPI`: Hardware and software SPI Master support.
    - `RTC`: Real-Time Clock for date and time management.
    - `WDT`: Hardware Watchdog Timer.
    - `FPGABridge`: Low-level access to the 16-bit M3-to-FPGA GPIO bridge.
    - `Flash`: Block device interface for the onboard SPI Flash.
- **Filesystem**: LittleFS (LFS2) on external SPI Flash.
- **Runtime**: Garbage Collector, REPL over UART0.

## Unsupported Features
- **Floating-point**: No hardware or software floating-point support (`MICROPY_PY_BUILTINS_FLOAT=0`).
- **Math Module**: The `math` module is disabled to save flash space.
- **Asynchronous**: `asyncio` and `async`/`await` are currently not supported.
- **Connectivity**: No built-in network or Bluetooth stacks.
- **Big Integers**: Support for arbitrary-precision integers is disabled.

## Project Structure
- `/definitions` - Datasheets and Standards to be used.
- `/documentation` - Concepts and implementation progress for different areas (see the [External Flash Guide](documentation/EXTERNAL_FLASH_GUIDE.md)).
- `/src` - Source files for the MicroPython port.
- `/test` - Unit, System, and End-2-End test concepts and cases.
- `/.github` - Workflows for CI/CD.
- `ROADMAP.md` - Progress tracking and future steps.

## UART Configuration
The MicroPython REPL is accessible via the Cortex-M3 UART0 peripheral.

### Hardware Wiring
The UART0 signals are routed through the FPGA fabric to the following pins:
- **UART0 RX**: FPGA Pin 19 (IOB13B)
- **UART0 TX**: FPGA Pin 18 (IOB13A)

### Terminal Settings
Use a serial terminal with the following configuration:
- **Baud Rate**: 115200
- **Data Bits**: 8
- **Parity**: None
- **Stop Bits**: 1
- **Flow Control**: None (8N1)

## Progress
Update `ROADMAP.md` for the current status and upcoming tasks.
