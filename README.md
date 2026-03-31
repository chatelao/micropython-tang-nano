# MicroPython for Tang Nano 4K

## Goal
This project aims to port MicroPython to the "Sipeed Tang Nano 4K" FPGA development board.

For a comprehensive overview of the port, including hardware details, installation, and usage, see the [Tang Nano 4K MicroPython Port Guide](M3_MICROPYTHON.md).

## Supported MicroPython Features

| Module / Feature | Description |
| :--- | :--- |
| **Core Modules** | `machine`, `time`/`utime`, `uos`, `io` |
| **Pin** | GPIO control (0-15) with hardware interrupt support |
| **Timer** | Hardware timers for periodic or one-shot events |
| **PWM** | Hardware-based Pulse Width Modulation |
| **ADC** | 12-bit Analog-to-Digital Converter |
| **I2C / SoftI2C** | Hardware and software I2C Master support |
| **SPI / SoftSPI** | Hardware and software SPI Master support |
| **RTC** | Real-Time Clock for date and time management |
| **WDT** | Hardware Watchdog Timer |
| **FPGABridge** | Low-level access to the 16-bit M3-to-FPGA GPIO bridge (See [FPGA_BRIDGE_USAGE.md](FPGA_BRIDGE_USAGE.md)) |
| **NEORV32** | Integration example for the NEORV32 RISC-V co-processor (See `examples/cpus/neorv32/`) |
| **SERV RISC-V** | Example of running a RISC-V core in the FPGA fabric (See `examples/cpus/serv_riscv/`) |
| **Flash** | Block device interface for the onboard SPI Flash |
| **Filesystem** | LittleFS (LFS2) on external SPI Flash |
| **Runtime** | Garbage Collector, REPL over UART0 |

## Unsupported Features

| Feature | Status / Reason |
| :--- | :--- |
| **Floating-point** | No hardware or software support (`MICROPY_PY_BUILTINS_FLOAT=0`) |
| **Math Module** | Disabled to save flash space |
| **Asynchronous** | `asyncio` and `async`/`await` are currently not supported |
| **Connectivity** | No built-in network or Bluetooth stacks |
| **Big Integers** | Arbitrary-precision integer support is disabled |

## Memory Layout

### Memory Regions (System Memory Map)

| Region - Role | Capacity | Base Address | Binary | MicroPython Usage |
| :--- | :--- | :--- | :--- | :--- |
| **FPGA Cfg. Flash**     | ~200 KB  | -            | `bitstream.fs`     | SoC Internal Config Flash (Instant-on)       |
| **M3 Int. Boot-Flash**  |   32 KB* | `0x00000000` | `firmware_int.bin` | Vector Table & Reset Handler                 |
| **M3 Internal SRAM**    |   22 KB  | `0x20000000` | -                  | Stack (2KB) & Fast Heap (~18KB)              |
| **M3 APB2 Devices** |   16 B   | `0x40002400` | -                  | TT Wrapper, Slot (1/12): TT Control and Data |
| **M3 Ext. Run-Flash**   |    4 MB  | `0x60000000` | `firmware_ext.bin` | SPI Flash Access (XIP) & VFS                 |
| **M3 Ext. PSRAM**       |    8 MB  | `0xA0000000` | -                  | Primary Heap (External PSRAM)                |

*\* Note: Internal Flash address space is 128 KB, but physical hardware on Tang Nano 4K is limited to 32 KB.*

### Component Locations in Memory

| Component | Location / Address | Description |
| :--- | :--- | :--- |
| **MicroPython Part 1** | `0x00000000` | Essential boot code and interrupt vectors (Internal Flash) |
| **MicroPython Part 2** | `0x60000000` | Bulk of MicroPython runtime, bytecode interpreter, and frozen modules (External SPI Flash XIP) |
| **APB2 Peripherals** | `0x40002400` - `0x40002FFF` | Peripherals implemented in the FPGA fabric (12 slots of 256 bytes each) |
| **SPI Flash Access** | `0x60000000` | Memory-mapped AHB Expansion interface for Execute-In-Place (XIP) |
| **Tiny Tapeout Wrapper** | **APB2 Slot 1** (`0x40002400`) | Bridge between the Cortex-M3 and Tiny Tapeout module pins |
| **Tiny Tapeout Logic** | `0x40002400` / `0x4000240C` | User logic control via `DATA` and `CTRL` registers |

## Project Structure

| Path | Description |
| :--- | :--- |
| `/definitions` | Datasheets and Standards to be used |
| `/examples` | Example MicroPython scripts and FPGA projects |
| `/src` | Source files for the MicroPython port |
| `/test` | Unit, System, and End-2-End test concepts and cases |
| `/.github` | Workflows for CI/CD |
| `AUDIT.md` | Comprehensive project audit report |
| `COMPLIANCE_TESTS.md` | MicroPython compliance testing results |
| `FPGA_BRIDGE_USAGE.md` | Guide on using MicroPython to interact with the FPGA |
| `GEMINI.md` | Project goal and structural guidelines |
| `HOWTO_TINY_TAPEOUT.md` | Guide to loading and testing Tiny Tapeout modules |
| `M3_FPGA_INTEGRATIONS.md` | Guide to communication interfaces between M3 and FPGA |
| `M3_MICROPYTHON.md` | Supported MicroPython features and port guide |
| `ROADMAP.md` | Progress tracking and future steps |
| `SERIAL_PORT_ACCESS.md` | Guide to accessing the Cortex-M3 serial port |
| [`TOOLCHAIN_SETUP.md`](TOOLCHAIN_SETUP.md) | Instructions for setting up the toolchains |

## UART Configuration
The MicroPython REPL is accessible via the Cortex-M3 UART0 peripheral.

### Hardware Wiring

| Signal | FPGA Pin | Description |
| :--- | :--- | :--- |
| **UART0 RX** | 19 (IOB13B) | Receive data input |
| **UART0 TX** | 18 (IOB13A) | Transmit data output |

### Terminal Settings

| Parameter | Value |
| :--- | :--- |
| **Baud Rate** | 115200 |
| **Data Bits** | 8 |
| **Parity** | None |
| **Stop Bits** | 1 |
| **Flow Control** | None (8N1) |

For detailed serial port instructions, see [SERIAL_PORT_ACCESS.md](SERIAL_PORT_ACCESS.md).

## Pinout Tang Nano 4K

### Onboard Peripherals

| Component | Pin | Bank | Logic |
| :--- | :--- | :--- | :--- |
| **LED** | 10 | 0 | Active-low |
| **Button 1 (S1)** | 15 | 3 | Active-high |
| **Button 2 (S2)** | 14 | 3 | Active-high |
| **System Clock** | 45 | 1 | 27 MHz Crystal |

### HDMI Interface (TMDS)

| Signal | Pin (+) | Pin (-) | Bank |
| :--- | :--- | :--- | :--- |
| **TMDS Lane 0** (Blue) | 30 | 29 | 2 |
| **TMDS Lane 1** (Green) | 32 | 31 | 2 |
| **TMDS Lane 2** (Red) | 35 | 34 | 2 |
| **TMDS Clock** | 28 | 27 | 2 |

### System & Programming

| Function | Pins | Bank | Description |
| :--- | :--- | :--- | :--- |
| **JTAG** | 3, 4, 6, 7, 8 | 0 | TDI, TDO, TMS, TCK, JTAGSEL_N |
| **SPI Flash** | 1, 2, 47, 48 | 0/1 | MCLK, MCS, MISO, MOSI |
| **UART0 (REPL)** | 18 (TX), 19 (RX) | 3 | Debug Console |

### Available Header Pins

| Bank | Pins |
| :--- | :--- |
| **Bank 0** | 9 (DONE) |
| **Bank 1** | 39, 40, 41, 42, 43, 44, 46 |
| **Bank 2** | 33 |
| **Bank 3** | 13, 16, 17, 20, 21, 22, 23 |

*Note: JTAG and Flash pins should be avoided for general use to maintain programmability.*

## IP Core Configuration (Gowin EDA)

Setting up the SoC subsystem on the Tang Nano 4K requires specific IP core configurations in Gowin EDA:

| Feature / IP Core | Configuration / Notes |
| :--- | :--- |
| **Cortex-M3 (Gowin_EMPU_M3)** | Enable APB and AHB expansion to allow the M3 to communicate with logic and memory in the FPGA fabric |
| **APB2 Expansion** | Each slot (256 bytes) is mapped starting at `0x40002400` |
| **External PSRAM** | Requires the `PSRAM Memory Interface` IP (Model: W955D8MBYA) mapped to `0xA0000000` |
| **External SPI Flash (XIP)** | Requires the `SPI Flash Interface` IP mapped to `0x60000000` |

For step-by-step instructions and pin constraints, see the **[M3-FPGA Integration Guide](M3_FPGA_INTEGRATIONS.md#3-apb2-expansion-slots)**.

### Installation with Gowin Programmer

| Step | Description | Details / Parameters |
| :--- | :--- | :--- |
| 1 | **Build** | Compile firmware with `SPLIT_FLASH=1` |
| 2 | **Flash FPGA Bitstream** | Flash the `.fs` file containing the SPI Flash Interface IP |
| 3 | **Flash Internal Flash** | Access Mode: `MCU Mode`<br>Operation: `Flash Erase, Program, Verify`<br>File: `build/firmware_int.bin` |
| 4 | **Flash External Flash** | Access Mode: `External Flash Mode`<br>Operation: `exFlash Erase, Program, Verify`<br>File: `build/firmware_ext.bin`<br>Address: `0x000000` (Mapped to `0x60000000`) |

For more details on M3-FPGA integration, see [M3_FPGA_INTEGRATIONS.md](M3_FPGA_INTEGRATIONS.md).

## Progress
Update `ROADMAP.md` for the current status and upcoming tasks.
