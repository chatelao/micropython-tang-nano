# M3 Blink LED Button Example

This example demonstrates basic GPIO interaction with the Cortex-M3 hard core on the Tang Nano 4K. It blinks the onboard LED (GPIO0) and doubles the blink rate when Button S1 (GPIO1) is pressed. Button S2 (GPIO2) is mapped to the hardware Reset (`reset_n`) and cannot be used as a GPIO input in this configuration.

## Hardware Mapping

| Peripheral | Pin | GPIO | Polarity | Description |
| :--- | :--- | :--- | :--- | :--- |
| LED | 10 | GPIO0 | Active-High | Blinks at default rate (500k cycles) |
| Button S1 | 15 | GPIO1 | Active-Low | Doubles blink rate when pressed (250k cycles) |
| Button S2 | 14 | GPIO2 | Active-Low | **Hardware Reset** (`reset_n`) |

## Documentation

The following technical documents are available in the `../docs/` folder for reference:

| Document | Description |
| :--- | :--- |
| [IPUG931-2.1E_Gowin_EMPU(GW1NS-4C) Software Programming Reference Manual.pdf](../docs/IPUG931-2.1E_Gowin_EMPU(GW1NS-4C)%20Software%20Programming%20Reference%20Manual.pdf) | Primary reference for M3 register mapping and SoC peripherals. |
| [GW1NSR_DATASHEET_DS861E.pdf](../docs/GW1NSR_DATASHEET_DS861E.pdf) | Hardware datasheet for the GW1NSR-4C SoC. |
| [IPUG944E.pdf](../docs/IPUG944E.pdf) | IP guide EMPU M3 core. |
| [Tang Nano 4K - Sipeed Wiki.pdf](../docs/Tang%20Nano%204K%20-%20Sipeed%20Wiki.pdf) | Board-level overview and pinout from Sipeed. |

## How to Build

Run `make` in this directory to generate the bitstream and firmware.
