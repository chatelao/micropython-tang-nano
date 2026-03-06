# Hardware Specifications Concept - Tang Nano 4K

This document outlines the hardware specifications for the Sipeed Tang Nano 4K development board, based on the Gowin GW1NSR-LV4C FPGA.

## Core Components
- **FPGA Chip**: Gowin GW1NSR-LV4C
- **Integrated MCU**: ARM Cortex-M3 (Hardcore)
- **Logic Units (LUT4)**: 4608
- **Registers**: 3456

## Memory
- **Block SRAM**: 180K bits
- **User Flash**: 256K bits

## Connectivity and Interfaces
- **USB-JTAG**: Onboard debugger for bitstream burning and MCU debugging.
- **HDMI Interface**: Multiplexed as IO and routed to pin headers.
- **Camera Interface**: Supported via DVP interface.
- **User I/O**: 44 pins across 4 banks.

## Implementation Status
- [x] Research target hardware specifications.
- [x] Document basic specifications.
- [ ] Detailed memory map for Cortex-M3.
- [ ] Peripheral register mapping.
