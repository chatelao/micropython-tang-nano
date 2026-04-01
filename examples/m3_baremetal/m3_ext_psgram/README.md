# M3 External PSRAM Example

This example demonstrates how to initialize and use the external 8MB PSRAM (Pseudo-SRAM) on the Sipeed Tang Nano 4K (GW1NSR-4C) SoC. The PSRAM is mapped at 0xA0000000.

## Memory Mapping

- **PSRAM Range**: `0xA0000000` to `0xA07FFFFF` (8MB)

## Documentation

The following technical documents are available for reference:

| Document | Description | Location |
| :--- | :--- | :--- |
| Gowin - EMPU M3 IP User Guide. | IP guide EMPU M3 core. | [IPUG944E](../docs/IPUG944E.pdf) |
| Gowin - PSRAM IP User Guide. | IP guide for Gowin PSRAM core. | [IPUG525E](docs/IPUG525E-PSRAM-User-Guide.pdf) |
| Gowin - EMPU(GW1NS-4C) Software Programming Reference Manual. | Primary reference for M3 register mapping and SoC peripherals. | [IPUG931](../docs/IPUG931-2.1E_Gowin_EMPU(GW1NS-4C)%20Software%20Programming%20Reference%20Manual.pdf) |
| Gowin - GW1NSR Datasheet. | Hardware datasheet for the GW1NSR-4C SoC. | [DS861E](../docs/GW1NSR_DATASHEET_DS861E.pdf) |

## How to Build

Run `make` in this directory to generate the bitstream and firmware.
