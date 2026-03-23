# MicroPython for Tang Nano 4K

## Goal
This project aims to port MicroPython to the "Sipeed Tang Nano 4K" FPGA development board.

For a comprehensive overview of the port, including hardware details, installation, and usage, see the [Tang Nano 4K MicroPython Port Guide](documentation/TANG_NANO_MICROPYTHON_GUIDE.md).

## Project Structure
- `/definitions` - Datasheets and Standards to be used.
- `/documentation` - Concepts and implementation progress for different areas.
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
