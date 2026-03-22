# Hardware Specifications Concept - Tang Nano 4K

This document outlines the hardware specifications for the Sipeed Tang Nano 4K development board, based on the Gowin GW1NSR-LV4C FPGA.

## Core Components
- **FPGA Chip**: Gowin GW1NSR-LV4C
- **Integrated MCU**: ARM Cortex-M3 (Hardcore)
- **Logic Units (LUT4)**: 4608
- **Registers**: 3456

## Memory
- **Block SRAM**: 180K bits
- **User Flash (Internal)**: 256K bits (32KB)
- **External Flash**: 32Mbit (4MB) SPI NOR Flash (Default)

## Connectivity and Interfaces
- **USB-JTAG**: Onboard debugger for bitstream burning and MCU debugging.
- **HDMI Interface**: Multiplexed as IO and routed to pin headers.
- **Camera Interface**: Supported via DVP interface.
- **User I/O**: 44 pins across 4 banks.

## Memory Map (Cortex-M3)
- **ITCM/Flash (Internal)**: 0x00000000 - 0x00007FFF (32KB)
- **SRAM**: 0x20000000 - 0x200057FF (22KB)
- **External Flash (via SPI)**: Not directly memory-mapped, accessible via SPI controller.
- **Peripherals**: 0x40000000 - 0x4001FFFF

## Peripheral Register Mapping
### Peripheral Base Addresses
| Peripheral | Base Address |
| --- | --- |
| Timer 0 | 0x40000000 |
| Timer 1 | 0x40001000 |
| UART 0 | 0x40004000 |
| UART 1 | 0x40005000 |
| RTC | 0x40006000 |
| Watchdog | 0x40008000 |
| GPIO | 0x40010000 |
| SYSCON | 0x4001F000 |

### UART0 (Base: 0x40004000)
| Register | Offset | Description |
| --- | --- | --- |
| DATA | 0x00 | Data register (R/W) |
| STATE | 0x04 | Status register (R/W) |
| CTRL | 0x08 | Control register (R/W) |
| INTSTATUS | 0x0C | Interrupt status (R/W) |
| BAUDDIV | 0x10 | Baudrate divider (R/W) |

## Implementation Status
- [x] Research target hardware specifications.
- [x] Document basic specifications.
- [x] Detailed memory map for Cortex-M3.
- [x] Peripheral register mapping.
- [x] Implement SoftI2C support.

## Silicon-to-Metal Interconnection Matrix

This matrix defines the interconnection points between the hard-core silicon (Cortex-M3 subsystem) and the metal-programmable FPGA fabric and resources.

| Silicon Area \ Metal Area | Logic Fabric | BSRAM | DSP | PLL | Bank 0 | Bank 1 | Bank 2 | Bank 3 |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **Cortex-M3 Core** | X | | | | | | | |
| **Internal SRAM** | X | | | | | | | |
| **Internal Flash** | X | | | | | | | |
| **UART 0 / 1** | X | | | | | | | |
| **Timer 0 / 1** | X | | | | | | | |
| **I2C 0 / SPI 0** | X | | | | | | | |
| **ADC IP** | X | | | | | | | |
| **GPIO Bridge** | X | | | | | | | |
| **NVIC (IRQs)** | X | | | | | | | |
| **SYSCON** | X | | | | | | | |

*Note: 'X' indicates a direct electrical or bus-level interface between the silicon hard-core and the programmable metal/logic fabric. Peripherals in silicon route their I/O signals through the logic fabric to reach physical I/O banks.*
