# M3 External PSRAM Example

This example demonstrates how to initialize and use the external 8MB PSRAM (Pseudo-SRAM) on the Sipeed Tang Nano 4K (GW1NSR-4C) SoC. The PSRAM is mapped at 0xA0000000.

## Architecture

The diagram below illustrates the integration of the Cortex-M3 hard core with the FPGA fabric and the external PSRAM via the AHB-Lite expansion bus.

![PSRAM Architecture](https://www.plantuml.com/plantuml/proxy?src=https://raw.githubusercontent.com/chatelao/micropython-tang-nano/main/examples/m3_baremetal/m3_ext_psgram/architecture.puml)

## Memory Mapping

The following table details the memory-mapped regions for the PSRAM example:

| Region | Start Address | End Address | Size | Description |
| :--- | :--- | :--- | :--- | :--- |
| **Internal Flash** | `0x00000000` | `0x00007FFF` | 32KB | Bootloader and Vector Table |
| **Internal SRAM** | `0x20000000` | `0x200057FF` | 22KB | Stack and Fast Heap |
| **External PSRAM** | `0xA0000000` | `0xA07FFFFF` | 8MB | Primary Extended Heap |

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
