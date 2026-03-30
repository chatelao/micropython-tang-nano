# M3-FPGA Integration Guide - Tang Nano 4K (GW1NSR-4C)

This document describes the communication interfaces between the ARM Cortex-M3 "Hard Core" and the FPGA fabric on the Sipeed Tang Nano 4K.

## 1. Overview

The GW1NSR-4C provides several dedicated paths for the Cortex-M3 to interact with logic implemented in the FPGA:

1.  **GPIO Bridge**: A 16-bit bi-directional bus connected to the M3's GPIO peripheral.
2.  **APB2 Expansion Slots**: 12 register-mapped slots (256 bytes each) on the APB2 bus.
3.  **AHB Expansion**: High-speed 32-bit bus for memory-mapped peripherals (e.g., PSRAM, SPI Flash).
4.  **FPGA Interrupts**: 6 dedicated interrupt lines from the FPGA to the M3 NVIC.

## 2. GPIO Bridge (16-bit)

The GPIO Bridge is the simplest way to pass signals between the M3 and the FPGA. It is mapped to the M3's native GPIO0 peripheral.

| Register | Address | Description |
| :--- | :--- | :--- |
| `DATA` | `0x40010000` | 16-bit data value (Read/Write) |
| `OUTENSET` | `0x40010010` | Set bits as outputs (1 = Output) |
| `OUTENCLR` | `0x40010014` | Clear bits to inputs (1 = Input) |

### RTL Wiring (Verilog)
In your top-level Verilog, the signals are typically mapped as follows:
- `GPIO[15:0]` on the Cortex-M3 IP core connects to your custom logic.

## 3. APB2 Expansion Slots

The APB2 bus is used for register-mapped communication. Each slot provides a 256-byte address range.

| Slot | Base Address | Default Usage in Examples |
| :--- | :--- | :--- |
| Slot 1 | `0x40002400` | Tiny Tapeout (TT) Wrapper |
| Slot 2 | `0x40002500` | NEORV32 RISC-V Bridge |
| Slot 3 | `0x40002600` | SERV RISC-V Bridge |
| ... | ... | ... |
| Slot 12 | `0x40002F00` | User Defined |

## 4. AHB Expansion (XIP & PSRAM)

The AHB bus is used for high-bandwidth peripherals.

| Range | Usage | IP Core Required |
| :--- | :--- | :--- |
| `0x60000000` - `0x6FFFFFFF` | External SPI Flash (XIP) | Gowin SPI Flash Interface |
| `0xA0000000` - `0xA07FFFFF` | External PSRAM (8MB) | Gowin PSRAM Controller |

## 5. FPGA Interrupts (NVIC)

Custom logic in the FPGA can trigger interrupts on the Cortex-M3.

| IRQ # | Name | Description |
| :--- | :--- | :--- |
| 1 | `USER_INT0` | FPGA User Interrupt 0 |
| 3 | `USER_INT1` | FPGA User Interrupt 1 |
| 4 | `USER_INT2` | FPGA User Interrupt 2 |
| 7 | `USER_INT3` | FPGA User Interrupt 3 |
| 11 | `USER_INT4` | FPGA User Interrupt 4 |
| 14 | `USER_INT5` | FPGA User Interrupt 5 |

For MicroPython usage details, see [FPGA_BRIDGE_USAGE.md](FPGA_BRIDGE_USAGE.md).
