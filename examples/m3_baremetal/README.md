# Cortex-M3 Baremetal Examples

This directory contains baremetal C examples for the ARM Cortex-M3 "Hard Core" on the Sipeed Tang Nano 4K (GW1NSR-4C). These examples demonstrate how to interact with the FPGA fabric, PSRAM, and Flash without a high-level operating system or the MicroPython runtime.

## 1. Examples Overview

| Example | Description |
| :--- | :--- |
| `m3_blink_led_btn2` | Basic GPIO interaction: Blink the onboard LED based on Button S2 state. |
| `m3_ext_flash_boot` | Demonstrates booting from external SPI Flash (XIP). |
| `m3_ext_psgram` | Shows how to initialize and use the external 8MB PSRAM. |

## 2. Architecture

This section provides a visual overview of the M3 subsystem and its integration with external peripherals.

### 2.1. System-Level Architecture
The diagram below shows the high-level integration of the Cortex-M3 hard core with the FPGA fabric and internal/external memories.

![M3-FPGA Subsystem Architecture](https://www.plantuml.com/plantuml/proxy?src=https://raw.githubusercontent.com/chatelao/micropython-tang-nano/main/m3_subsystem.puml)

### 2.2. Module-Specific Architectures

| Integration | Description | Architecture Diagram |
| :--- | :--- | :--- |
| **External PSRAM** | AHB-Lite expansion for the 8MB PSRAM SiP. | ![PSRAM Architecture](https://www.plantuml.com/plantuml/proxy?src=https://raw.githubusercontent.com/chatelao/micropython-tang-nano/main/examples/m3_baremetal/m3_ext_psgram/architecture.puml) |
| **External Flash (XIP)** | Booting from external SPI Flash using the XIP controller. | ![Flash XIP Architecture](https://www.plantuml.com/plantuml/proxy?src=https://raw.githubusercontent.com/chatelao/micropython-tang-nano/main/examples/m3_baremetal/m3_ext_flash_boot/docs/flash_xip_signals.puml) |

## 3. Documentation

The following technical documents are available in the `docs/` folder for reference:

### 3.1. General Documentation

| Document | Description |
| :--- | :--- |
| [IPUG931-2.1E_Gowin_EMPU(GW1NS-4C) Software Programming Reference Manual.pdf](docs/IPUG931-2.1E_Gowin_EMPU(GW1NS-4C)%20Software%20Programming%20Reference%20Manual.pdf) | Primary reference for M3 register mapping and SoC peripherals. |
| [GW1NSR_DATASHEET_DS861E.pdf](docs/GW1NSR_DATASHEET_DS861E.pdf) | Hardware datasheet for the GW1NSR-4C SoC. |
| [Tang Nano 4K - Sipeed Wiki.pdf](docs/Tang%20Nano%204K%20-%20Sipeed%20Wiki.pdf) | Board-level overview and pinout from Sipeed. |
| [Tang nano 4K.pdf](docs/Tang%20nano%204K.pdf) | Additional board reference. |
| [UG292-1.0E_GW1NS_GW1NSR_GW1NSE_GW1NSER series Schematic Manual.pdf](docs/UG292-1.0E_GW1NS_GW1NSR_GW1NSE_GW1NSER%20series%20of%20FPGA%20Products%20Schematic%20Manual.pdf) | FPGA product schematic reference manual. |

### 3.2. IP core documentation

| Document | Description | Location |
| :--- | :--- | :--- |
| IP guide EMPU M3 core. | M3 register mapping and SoC peripherals. | [IPUG944E](docs/IPUG944E.pdf) |
| IP guide PSRAM core. | PSRAM initialization and timing. | [IPUG525E](m3_ext_psgram/docs/IPUG525E-PSRAM-User-Guide.pdf) |
| IP guide AHB-mapped SPI Flash (XIP) controller. | External Flash XIP configuration. | [IPUG1015](m3_ext_flash_boot/docs/IPUG1015-1.1E_Gowin%20SPI%20Flash%20Interface%20(With%20External%20Flash)%20IP%20User%20Guide.pdf) |

## 4. Getting Started

To build these examples, you need the `arm-none-eabi-gcc` toolchain installed. Refer to [TOOLCHAIN_SETUP.md](../../TOOLCHAIN_SETUP.md) for detailed instructions.

### Build and Deployment
Each example directory contains its own `Makefile`. To build an example:
```bash
cd m3_blink_led_btn2
make
```
This will generate the FPGA bitstream (`.fs`) and the MCU firmware (`.bin`). Use `openfpgaflasher` to deploy the results to your Tang Nano 4K.
