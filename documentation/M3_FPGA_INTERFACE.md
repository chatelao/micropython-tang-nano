# M3 to FPGA Interface Summary - Sipeed Tang Nano 4K

This document provides a comprehensive summary of the hardware interface between the ARM Cortex-M3 hard core and the Gowin FPGA fabric in the GW1NSR-LV4C SoC.

## 1. Bus Architecture

The system utilizes a multi-layered bus matrix to connect the Cortex-M3 processor with internal memory, standard peripherals, and the FPGA fabric.

### 1.1 AHB-Lite Bus
- **ICode Bus**: Used for fetching instructions and vectors from code space (Flash/SRAM).
- **DCode Bus**: Used for data loading/storage and debug access.
- **System Bus**: Used for system space access, data loading/storage, and debug.

### 1.2 AHB Extension Ports (FPGA Interconnect)
The SoC provides two primary AHB extension ports for high-speed communication with user-defined logic in the FPGA:
- **INTEXP0**: AHB Master extension port. Provides a 128-bit AHB bus interconnect to high-speed user peripherals implemented in the FPGA.
- **TARGEXP0**: AHB Target extension port.

### 1.3 APB Buses
- **APB1**: Connects to internal hard peripherals (Timer0, Timer1, UART0, UART1, Watchdog, RTC).
- **APB2**: Specifically designed for FPGA interconnect. It provides multiple master interfaces (APB2 Master 1 through 12) mapped to the `0x40002000` - `0x40002FFF` range. This allows the M3 core to control soft-core IPs (SPI, I2C, etc.) implemented in the FPGA fabric.

## 2. Peripheral Connectivity

### 2.1 UART Interface
- **UART0 & UART1**: Integrated hard cores. They connect directly to the FPGA fabric rather than external I/O pins. This allows the FPGA to route these signals to any physical pins or use them for internal communication.
- **Base Addresses**: UART0 (`0x40004000`), UART1 (`0x40005000`).

### 2.2 GPIO Interconnect
- **GPIO0**: A 16-bit general-purpose I/O block that interconnects the AHB bus with the FPGA fabric.
- **Function**: Allows the M3 core to drive or sample 16 signals within the FPGA logic. These can be mapped to physical pins via FPGA routing.
- **Base Address**: `0x40010000`.

### 2.3 Timers and Watchdog
- **Timer0 & Timer1**: 32-bit down-counters.
  - Timer0 `EXTIN` is hard-wired to `GPIO[1]`.
  - Timer1 `EXTIN` is hard-wired to `GPIO[6]`.
- **Watchdog**: Provides system reset capability upon software failure.

## 3. Interrupt Structure

The Nested Vector Interrupt Controller (NVIC) manages up to 32 interrupts, many of which facilitate M3-FPGA interaction.

### 3.1 User Interrupts
- **USER_INT0 to USER_INT5**: Six dedicated interrupt signals provided to the FPGA fabric. User logic in the FPGA can trigger these interrupts to signal the M3 core.

### 3.2 Interrupt Monitor
- The system provides an **Interrupt Monitor** signal to the FPGA fabric. This signal combines various internal interrupts (UART, Timers, Watchdog) to report the current run-time interrupt status of the microprocessor system back to the FPGA.

## 4. System Signals (FPGA to M3)

The FPGA fabric is responsible for providing critical system signals to the Cortex-M3 core:
- **Main Clock**: Provided by the FPGA's clocking resources (PLL or On-chip Oscillator).
- **Power-On Reset (POR)**: Generated within the FPGA.
- **System Reset**: Controlled by the FPGA logic.

## 5. Memory Mapping Summary

| Region | Address Range | Description |
| --- | --- | --- |
| **Code/Flash** | `0x00000000 - 0x00007FFF` | 32KB Internal Flash |
| **SRAM** | `0x20000000 - 0x20003FFF` | Up to 16KB Internal SRAM |
| **Peripherals (APB1)** | `0x40000000 - 0x4000FFFF` | Timers, UART, RTC, Watchdog |
| **FPGA Peripherals (APB2)** | `0x40002000 - 0x40002FFF` | APB2 Masters for FPGA Soft-cores |
| **GPIO (FPGA Interconnect)** | `0x40010000 - 0x40010FFF` | 16-bit AHB GPIO |
| **AHB Extension** | `0xA0000000 - 0xAFFFFFFF` | AHB2 Master for high-speed FPGA logic |
| **System Control** | `0xE0000000 - 0xEFFFFFFF` | NVIC, SysTick, Debug Components |

---
*Sources: GW1NSR Datasheet (DS861), IPUG931 Software Programming Reference Manual.*
