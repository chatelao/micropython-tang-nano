# Tang Nano 4K Serial Port Access Guide

This document describes how to access the Cortex-M3 serial port on the Sipeed Tang Nano 4K board via the USB-C connector.

## Overview

The Tang Nano 4K features a GW1NSR-LV4C SoC with an integrated ARM Cortex-M3 core. It uses a Bouffalo Lab BL702 chip as a USB-to-JTAG/UART bridge. By default, the UART lines of the BL702 are disconnected from the FPGA pins to avoid interference with the HDMI interface.

## UART Pin Routing

The UART0 signals are routed through the FPGA fabric. The current configuration uses the following pins:

| Function | M3 Signal | FPGA Pin | Bank |
| :--- | :--- | :--- | :--- |
| **UART0 RX** | RXD | Pin 19 (IOB13B) | 3 |
| **UART0 TX** | TXD | Pin 18 (IOB13A) | 3 |

### Legacy Routing and Hardware Modifications

Previous versions of the firmware routed UART0 to Pins 34 and 35, which are internally connected to the BL702 bridge pads R11 and R12.

To enable serial communication over USB using the **legacy** pins (34/35), solder two bridges on the **bottom side** of the PCB:
1.  **R11**: Connects BL702 RX to FPGA Pin 35 (TX).
2.  **R12**: Connects BL702 TX to FPGA Pin 34 (RX).

**Note**: Using Header Pins 18 and 19 does not require any soldering.

## Software Configuration

### Cortex-M3 Peripheral
The MicroPython port and standard GW1NSR-4C designs use **UART0** for the system console.

*   **Base Address**: `0x40004000`
*   **Clock Frequency**: 27 MHz
*   **Default Baud Rate**: 115200

### Terminal Settings
When connecting to the board's serial port on your computer, use the following settings:

*   **Baud Rate**: `115200`
*   **Data Bits**: `8`
*   **Parity**: `None`
*   **Stop Bits**: `1`
*   **Flow Control**: `None`

## Important Considerations

*   **HDMI Conflict**: Pins 34 and 35 (used in legacy routing) are also used for HDMI signals (`HDMI_TX2`). The current routing to pins 18 and 19 avoids this conflict.
*   **Bitstream Routing**: Ensure your Gowin EDA project correctly routes the `UART0_TXD` and `UART0_RXD` signals of the Cortex-M3 "Hard Core" to pins 18 and 19 respectively in the Floor Planner (CST file).
