# Toolchain Setup Guide

This document provides instructions for setting up the necessary toolchains for the MicroPython for Tang Nano 4K project.

## 1. ARM GNU Toolchain

The MicroPython firmware for the Cortex-M3 is compiled using the ARM GNU Toolchain.

### Recommended Version
- **Version**: 10.3-2021.10
- **Triple**: `arm-none-eabi-`

### Installation (Ubuntu/Debian)
```bash
sudo apt update
sudo apt install gcc-arm-none-eabi binutils-arm-none-eabi gdb-arm-none-eabi libnewlib-arm-none-eabi
```

For the exact 10.3-2021.10 version, download from the [ARM Developer website](https://developer.arm.com/tools-and-software/open-source-software/developer-tools/gnu-toolchain/gnu-rm/downloads) and add the `bin` directory to your `PATH`.

---

## 2. Open-Source FPGA Toolchain (Gowin)

For an entirely open-source workflow, you can use **Project Apicula**, **Yosys**, and **nextpnr-himbaechel** to generate bitstreams for the Tang Nano 4K (GW1NSR-4C).

### Prerequisites
Ensure you have Python 3 and `pip` installed.

### Installation Steps

1.  **Project Apicula**: Provides the documentation and bitstream tools.
    ```bash
    pip install apycula
    ```

2.  **Yosys**: For Verilog synthesis.
    ```bash
    # Follow instructions at https://github.com/YosysHQ/yosys
    sudo apt install yosys
    ```

3.  **nextpnr-himbaechel**: The place-and-route tool supporting Gowin devices.
    ```bash
    # Follow instructions at https://github.com/YosysHQ/nextpnr
    # Ensure you build with -DARCH=gowin
    ```

### Usage Overview

To generate a bitstream (`.fs`):

1.  **Synthesis**:
    ```bash
    yosys -p "read_verilog top.v; synth_gowin -json top.json"
    ```

2.  **Place & Route**:
    ```bash
    nextpnr-himbaechel --json top.json \
                       --write top_pnr.json \
                       --device GW1NSR-LV4CQN48PC7/I6 \
                       --vopt family=GW1NS-4 \
                       --vopt cst=pins.cst
    ```

3.  **Pack**:
    ```bash
    gowin_pack -d GW1NS-4 -o bitstream.fs top_pnr.json
    ```

---

## 3. Flashing Tools

### openfpgaflasher
The project uses `openfpgaflasher` for unified flashing of the FPGA bitstream and MCU firmware.

```bash
pip install openfpgaflasher
```

Usage:
```bash
openfpgaflasher -b bitstream.fs -m firmware_int.bin -e firmware_ext.bin
```

---

## 4. Renode Simulation

To run the integration tests, you need Renode installed.

- **Installation**: Follow instructions at [renode.io](https://renode.io/).
- **Robot Framework**:
  ```bash
  pip install robotframework==6.1 psutil pyyaml
  ```
