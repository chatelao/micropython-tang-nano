# Cortex-M3 to FPGA Interface Summary - Tang Nano 4K

This document provides a comprehensive summary of the interface between the integrated ARM Cortex-M3 hard core and the GW1NSR-LV4C FPGA fabric on the Sipeed Tang Nano 4K.

## 1. Overview
The GW1NSR-LV4C is a System-on-Chip (SoC) that integrates a 32-bit ARM Cortex-M3 RISC core with FPGA logic. The core operates at a maximum frequency of 80 MHz (27 MHz default in current MicroPython port). The interface allows for high-speed data transfer, peripheral control, and interrupt handling between the processor and the programmable logic.

## 2. Bus Architecture
The Cortex-M3 interacts with the FPGA and internal resources through a multi-layered bus system:

*   **ICode Bus**: 32-bit AHB-Lite for instruction fetching from code space.
*   **DCode Bus**: 32-bit AHB-Lite for data loading/storage and debug access.
*   **System Bus**: 32-bit AHB-Lite for system space access and data transfer.
*   **APB Buses (APB1 & APB2)**: For peripheral control. APB1 manages timers, UARTs, and the watchdog. APB2 connects directly to the FPGA fabric.

### AHB Extension Ports
Two 128-bit AHB extension ports facilitate high-speed communication with user-defined logic in the FPGA:
*   **INTEXP0 (Master)**: Allows the M3 to act as a master to FPGA peripherals.
*   **TARGEXP0 (Slave)**: Allows FPGA logic to act as a master to M3 resources.

## 3. Peripheral Interface

### GPIO Block (Base: 0x40010000)
A 16-bit GPIO interface connects the AHB bus directly to the FPGA fabric.
*   **Function**: Allows the M3 to toggle signals or read status from FPGA logic.
*   **Features**: Programmable interrupts, bit masking, and alternate function switching.
*   **Registers**: DATA (0x00), DATAOUT (0x04), OUTENSET (0x10), OUTENCLR (0x14), ALTFUNCSET (0x18), ALTFUNCCLR (0x1C).

### UART0 & UART1 (Base: 0x40004000, 0x40005000)
Both UART peripherals connect directly to the FPGA fabric.
*   **UART0**: Typically used for the system console (REPL).
*   **Physical Mapping**: On the Tang Nano 4K, UART0 TX/RX are routed to FPGA Pins 35 and 34 (requires soldering bridges R11 and R12 for USB-C access).

### Timers & Watchdog (Base: 0x40000000, 0x40001000, 0x40008000)
*   **Timer0/1**: 32-bit down-counters. `EXTIN` signals (enable/clock) are hard-wired to `GPIO[1]` (Timer0) and `GPIO[6]` (Timer1).
*   **Watchdog**: 32-bit down-counter used for system reset/recovery upon software failure.

## 4. Interrupt Handling
The Nested Vector Interrupt Controller (NVIC) supports up to 26 interrupts, including 6 user-defined interrupts from the FPGA.

| IRQ | Name | Source |
| :--- | :--- | :--- |
| 0 | UART0_Handler | UART0 receive/transmit |
| 1 | USER_INT0_Handler | User interrupt 0 |
| 2 | UART1_Handler | UART1 receive/transmit |
| 3 | USER_INT1_Handler | User interrupt 1 |
| 4 | USER_INT2_Handler | User interrupt 2 |
| 6 | PORT0_COMB_Handler | Combined GPIO0 interrupt |
| 7 | USER_INT3_Handler | User interrupt 3 |
| 8 | TIMER0_Handler | Timer0 interrupt |
| 9 | TIMER1_Handler | Timer1 interrupt |

**IntMonitor Signal**: A combined signal reports the status of GPIO and APB1 peripheral interrupts back to the FPGA fabric in real-time.

## 5. Clock and Reset
The FPGA fabric is responsible for providing the primary clock and reset signals to the M3 core:
*   **Main Clock**: Typically sourced from an FPGA PLL or the on-chip oscillator (OSC).
*   **Power-On Reset**: Initial reset signal provided by the FPGA.
*   **System Reset**: Controlled by the FPGA logic or the M3 watchdog.

## 6. Debug Access Port (DAP)
The M3 includes a DAP with JTAG and TPIU interfaces, both of which interface with the FPGA fabric for debugging and trace capabilities.
