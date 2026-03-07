# Tang Nano 4K Serial Port Access Guide

This document describes how to access the Cortex-M3 serial port on the Sipeed Tang Nano 4K board via the USB-C connector.

## Overview

The Tang Nano 4K features a GW1NSR-LV4C SoC with an integrated ARM Cortex-M3 core. It uses a Bouffalo Lab BL702 chip as a USB-to-JTAG/UART bridge. By default, the UART lines of the BL702 are disconnected from the FPGA pins to avoid interference with the HDMI interface.

## Hardware Modification (Soldering)

To enable serial communication over USB, you must solder two bridges on the **bottom side** of the PCB.

1.  Locate pads **R11** and **R12** near the BL702 chip.
2.  **R11**: Solder a bridge (0Ω resistor or solder blob) to connect the BL702 RX to FPGA Pin 35.
3.  **R12**: Solder a bridge (0Ω resistor or solder blob) to connect the BL702 TX to FPGA Pin 34.

| Component | Function | M3 Signal | FPGA Pin |
| :--- | :--- | :--- | :--- |
| **R11** | UART TX | UART0 TX | Pin 35 (IOR2A) |
| **R12** | UART RX | UART0 RX | Pin 34 (IOR2B) |

## Software Configuration

### Cortex-M3 Peripheral
The MicroPython port and standard GW1NSR-4C designs use **UART0** for the system console.

*   **Base Address**: `0x40000000`
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

*   **HDMI Conflict**: Pins 34 and 35 are also used for HDMI signals (`HDMI_TX2`). If your FPGA bitstream uses both HDMI and the Cortex-M3 UART0 on these pins, you may experience interference or failure of one or both interfaces.
*   **Bitstream Routing**: Ensure your Gowin EDA project correctly routes the `UART0_TXD` and `UART0_RXD` signals of the Cortex-M3 "Hard Core" to pins 35 and 34 respectively in the Floor Planner (CST file).
