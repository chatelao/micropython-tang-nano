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

## Memory Layout

### Memory Regions
| Region | Capacity | Base Address | Role | MicroPython Usage |
| :--- | :--- | :--- | :--- | :--- |
| **Internal SRAM** | 22 KB | `0x20000000` | Fast RAM | Stack (2KB), Static Data, Fast Heap (~18KB) |
| **External PSRAM** | 8 MB | `0xA0000000` | Large RAM | Extended Heap |
| **Internal Flash** | 32 KB* | `0x00000000` | Boot Flash | Vectors, Bootloader, Init |
| **External Flash** | 4 MB | `0x60000000` | Main Storage | Runtime Code, ROData, VFS (LittleFS) |

*\* Note: Internal Flash address space is 128 KB, but physical hardware is limited to 32 KB.*

### Filesystem (LittleFS2) Configuration
| Mode | FS Offset | FS Size | Description |
| :--- | :--- | :--- | :--- |
| **Standard** | `0x100000` | ~3 MB | 1 MB offset to avoid firmware overlap |
| **SPLIT_FLASH** | `0x40000` | ~3.75 MB | 256 KB offset for firmware in external flash |

### Implementation Notes
- **Bus Access**: Memory-mapped access to PSRAM (`0xA0000000`) and External Flash (`0x60000000`) requires specific IP cores (Gowin PSRAM and SPI Flash Interface) to be present in the FPGA bitstream.
- **Heap Management**: MicroPython is configured with `MICROPY_GC_SPLIT_HEAP=1` to manage the two distinct RAM regions.

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

## Split Flash Installation
The Tang Nano 4K has only 32KB of internal code flash, which is insufficient for a full MicroPython build (~125KB). To solve this, we use a **Split Flash** architecture:

| Region | Address | Binary | Description |
| :--- | :--- | :--- | :--- |
| **Internal Flash** | `0x00000000` | `firmware_int.bin` | Vector table & Reset Handler (32KB) |
| **External Flash** | `0x60000000` | `firmware_ext.bin` | MicroPython Runtime & Code (1MB) |

### IP Core Configuration (Gowin EDA)
To access the external flash at `0x60000000`, you must instantiate the **SPI Flash Interface** IP in your Gowin project:
1.  **IP Generator**: Select `SPI Flash Interface`.
2.  **Configuration**:
    *   **Protocol**: Single SPI (Standard).
    *   **Bus Interface**: `AHB` (required for XIP).
    *   **Memory Mapped**: Enable `Memory Mapped Mode`.
    *   **Base Address**: Set to `0x60000000` in the AHB expansion configuration.
3.  **M3 Connection**: Connect the IP core to the Cortex-M3 **AHB Master** port (typically via the AHB Expansion interface).
4.  **Pin Constraints**: Map the SPI signals to the following pins:
    *   `CS_N`: Pin 36
    *   `SCLK`: Pin 37
    *   `MOSI`: Pin 38
    *   `MISO`: Pin 39

### Installation with Gowin Programmer
1.  **Build** the firmware with `SPLIT_FLASH=1`.
2.  **Flash FPGA Bitstream**: Flash your `.fs` file containing the SPI Flash Interface IP.
3.  **Flash Internal Flash**:
    *   Access Mode: `MCU Mode`
    *   Operation: `Flash Erase, Program, Verify`
    *   File: `build/firmware_int.bin`
4.  **Flash External Flash**:
    *   Access Mode: `External Flash Mode`
    *   Operation: `exFlash Erase, Program, Verify`
    *   File: `build/firmware_ext.bin`
    *   Address: `0x000000` (The M3 sees this at `0x60000000`)

For detailed instructions, see the [Tang Nano 4K MicroPython Port Guide](documentation/TANG_NANO_MICROPYTHON_GUIDE.md).

## Progress
Update `ROADMAP.md` for the current status and upcoming tasks.
