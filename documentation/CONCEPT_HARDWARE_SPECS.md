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
- **Peripherals**: 0x40000000

## Peripheral Register Mapping
### UART0 (Base: 0x40000000)
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
- [ ] Implement SoftI2C support.
- [ ] Implement SPI support.
- [ ] Implement ADC support.
- [ ] Implement Virtual File System (VFS).
- [ ] Implement Hardware Interrupts (GPIO).
