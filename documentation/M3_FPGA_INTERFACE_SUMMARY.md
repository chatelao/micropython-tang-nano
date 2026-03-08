# M3 to FPGA Interface Summary - Tang Nano 4K (GW1NSR-4C)

This document provides a comprehensive summary of the hardware interface between the ARM Cortex-M3 "Hard Core" and the FPGA fabric in the Gowin GW1NSR-4C SoC used on the Sipeed Tang Nano 4K.

## 1. System Architecture Overview

The GW1NSR-4C integrates a Cortex-M3 processor with the Gowin LittleBee FPGA fabric. A key architectural constraint is that the M3 core **does not have direct access to the chip's I/O blocks (IOBs)**. All communication with external pins (other than JTAG) must pass through the FPGA fabric.

### Bus Structure
- **AHB-Lite Bus**: The main high-performance system bus.
- **AHB-to-APB Bridge**: Interfaces the AHB-Lite bus to peripherals.
- **APB1 Bus**: Connects to the M3's internal hard-core peripherals.
- **APB2 Bus**: A dedicated bus interface for user-defined peripherals implemented in the FPGA fabric.

## 2. Data and Peripheral Interfaces

### 2.1 AHB Expansion Ports (High-Speed)
The SoC provides two 128-bit wide AHB expansion ports for high-bandwidth data exchange:
- **INTEXP0 (Master)**: Allows the Cortex-M3 to act as a bus master to user logic in the FPGA.
- **TARGEXP0 (Slave)**: Allows user logic in the FPGA to act as a master and access the M3's internal memory space (e.g., SRAM).

### 2.2 GPIO Bridge (AHB Interface)
A 16-bit GPIO block connects the AHB bus to the FPGA fabric. This allows the M3 to control logic signals that can be routed to physical pins via FPGA routing.
- **Base Address**: `0x40010000`
- **Register Offsets**:
  - `DATA` (0x00): Data value of the 16 pins.
  - `DATAOUT` (0x04): Data output register.
  - `OUTENSET` (0x10) / `OUTENCLR` (0x14): Output enable control.
  - `ALTFUNCSET` (0x18) / `ALTFUNCCLR` (0x1C): Alternate function selection.
  - `INTENSET` (0x20) / `INTENCLR` (0x24): Interrupt enable control.

### 2.3 Hard-Core Peripherals (APB1)
While these are "hard" peripherals, their I/O signals are routed to the FPGA fabric rather than directly to pins:
- **UART0 & UART1**: TX/RX signals are connected directly to the FPGA fabric.
- **Timer0 & Timer1**: 32-bit down-counters. `EXTIN` signals for these timers are hard-wired to GPIO[1] and GPIO[6] respectively.
- **Watchdog**: 32-bit down-counter for system recovery.

### 2.4 APB2 User Interface
The **APB2 bus** provides a standard interface for custom register-mapped peripherals in the FPGA.

## 3. Interrupts and Synchronization

### 3.1 NVIC IRQ Assignments
The following interrupts are available to the M3, many of which are sourced from or interact with the FPGA:

| IRQ # | Vector | Name | Description |
| :--- | :--- | :--- | :--- |
| 0 | 0x40 | UART0_Handler | UART0 RX/TX Interrupt |
| 1 | 0x44 | USER_INT0 | **FPGA-sourced User Interrupt 0** |
| 2 | 0x48 | UART1_Handler | UART1 RX/TX Interrupt |
| 3 | 0x4C | USER_INT1 | **FPGA-sourced User Interrupt 1** |
| 4 | 0x50 | USER_INT2 | **FPGA-sourced User Interrupt 2** |
| 6 | 0x58 | PORT0_COMB | Combined GPIO Interrupt |
| 7 | 0x5C | USER_INT3 | **FPGA-sourced User Interrupt 3** |
| 8 | 0x60 | TIMER0_Handler | Timer0 Interrupt |
| 9 | 0x64 | TIMER1_Handler | Timer1 Interrupt |
| 13 | 0x74 | USER_INT4 | **FPGA-sourced User Interrupt 4** |
| 14 | 0x78 | USER_INT5 | **FPGA-sourced User Interrupt 5** |

### 3.2 IntMonitor
The M3 provides an `IntMonitor` signal to the FPGA fabric. This reports the real-time status of internal M3 peripheral interrupts (UARTs, Timers, Watchdog, GPIO) to the FPGA logic, allowing the FPGA to react to M3 peripheral events without software intervention.

## 4. Clock and Reset Control

The FPGA fabric is the "master" of system health for the M3 core:
- **HCLK (Main Clock)**: Provided by the FPGA (usually from a PLL or the internal 250MHz OSC). On the Tang Nano 4K MicroPython port, this is typically configured at **27 MHz**.
- **Power-On Reset (POR)**: Generated/controlled by FPGA logic.
- **System Reset**: Triggered by FPGA logic to reset the M3 subsystem.

## 5. Debug and Trace

- **JTAG-DAP**: The M3 debug interface (JTAG) is accessible via the FPGA's JTAG pins, multiplexed through the FPGA fabric.
- **TPIU (Trace Port Interface Unit)**: Provides trace data to the FPGA fabric for debugging.
