# Tang Nano 4K M3 Bitstream (GW1NSR-4C)

This bitstream routes the ARM Cortex-M3 "Hard Core" signals to the physical pins of the Tang Nano 4K and implements the SoC infrastructure.

## 1. System Features (GW1NSR-4C)
- **Processor**: 32-bit ARM Cortex-M3.
- **Clock**: Supports up to 80 MHz operation.
- **Memory**:
  - Instruction Flash: 32 KB.
  - Instruction/Data SRAM: Up to 16 KB (Block SRAM).
  - External Expansion: AHB and APB2 buses.

## 2. Memory Mapping

| Standard Peripheral | Base Address | Description |
| :--- | :--- | :--- |
| FLASH | `0x00000000` | 32 KB Instruction Flash |
| SRAM | `0x20000000` | 2 KB, 4 KB, 8 KB or 16 KB |
| TIMER0 | `0x40000000` | Timer 0 |
| TIMER1 | `0x40001000` | Timer 1 |
| I2C | `0x40002000` | I2C Master |
| SPI | `0x40002200` | SPI Master |
| UART0 | `0x40004000` | UART0 (Hard Core) |
| UART1 | `0x40005000` | UART1 (Hard Core) |
| RTC | `0x40006000` | Real-time clock |
| WatchDog | `0x40008000` | Watchdog |
| GPIO0 | `0x40010000` | 16-bit GPIO Interface |
| SYSCON | `0x4001F000` | System Control |
| AHB Expansion | `0x60000000` | AHB Expansion (e.g., PSRAM) |
| AHB2 Master | `0xA0000000` | AHB Expansion (e.g., SPI Flash XIP) |

### APB2 Expansion Slots (FPGA Peripherals)
Used for user-defined peripherals in the FPGA fabric.

| Slot | Base Address |
| :--- | :--- |
| APB2 Master 1 | `0x40002400` |
| APB2 Master 2 | `0x40002500` |
| APB2 Master 3 | `0x40002600` |
| APB2 Master 4 | `0x40002700` |
| APB2 Master 5 | `0x40002800` |
| APB2 Master 6 | `0x40002900` |
| APB2 Master 7 | `0x40002A00` |
| APB2 Master 8 | `0x40002B00` |
| APB2 Master 9 | `0x40002C00` |
| APB2 Master 10 | `0x40002D00` |
| APB2 Master 11 | `0x40002E00` |
| APB2 Master 12 | `0x40002F00` |

## 3. Interrupt Vector Table (NVIC)

| IRQ # | Name | Description |
| :--- | :--- | :--- |
| 0 | `UART0_Handler` | UART 0 RX and TX |
| 1 | `USER_INT0_Handler` | FPGA User Interrupt 0 |
| 2 | `UART1_Handler` | UART 1 RX and TX |
| 3 | `USER_INT1_Handler` | FPGA User Interrupt 1 |
| 4 | `USER_INT2_Handler` | FPGA User Interrupt 2 |
| 5 | `RTC_Handler` | Real-time Clock |
| 6 | `PORT0_COMB_Handler` | GPIO Port 0 Combined |
| 7 | `USER_INT3_Handler` | FPGA User Interrupt 3 |
| 8 | `TIMER0_Handler` | Timer 0 |
| 9 | `TIMER1_Handler` | Timer 1 |
| 11 | `USER_INT4_Handler` | FPGA User Interrupt 4 |
| 12 | `UARTOVF_Handler` | UART 0, 1 Overflow |
| 14 | `USER_INT5_Handler` | FPGA User Interrupt 5 |

---
*Source: Gowin IPUG931-2.1E, DS861E-1.8E*
