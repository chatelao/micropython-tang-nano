# M3 External Flash Boot Example

This example demonstrates how to configure the Cortex-M3 on the Tang Nano 4K to boot from external SPI Flash. This uses the XIP (eXecute In Place) feature, mapping the flash memory to the 0xA0000000 address range (the standard AHB expansion window for the GW1NS-4C).

## Documentation

### Architecture & Signals

![M3 to External Flash XIP](https://www.plantuml.com/plantuml/proxy?src=https://raw.githubusercontent.com/chatelao/micropython-tang-nano/main/examples/m3_baremetal/m3_ext_flash_boot/docs/flash_xip_signals.puml)

### Technical Reference

The following technical documents are available for reference:

| Document | Description | Location |
| :--- | :--- | :--- |
| Gowin SPI Flash Interface (With External Flash) IP User Guide. | IP guide for AHB-mapped SPI Flash (XIP) controller. | [IPUG1015](docs/IPUG1015-1.1E_Gowin%20SPI%20Flash%20Interface%20(With%20External%20Flash)%20IP%20User%20Guide.pdf) |
| Gowin_EMPU(GW1NS-4C) Software Programming Reference Manual. | Primary reference for M3 register mapping and SoC peripherals. | [IPUG931](../docs/IPUG931-2.1E_Gowin_EMPU(GW1NS-4C)%20Software%20Programming%20Reference%20Manual.pdf) |
| GW1NSR Datasheet. | Hardware datasheet for the GW1NSR-4C SoC. | [DS861E](../docs/GW1NSR_DATASHEET_DS861E.pdf) |
| Gowin_EMPU M3 IP User Guide. | IP guide EMPU M3 core. | [IPUG944E](../docs/IPUG944E.pdf) |

## How to Build

Run `make` in this directory to generate the bitstream and firmware.
