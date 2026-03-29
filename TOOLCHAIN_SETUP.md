# Toolchain Setup Guide

This guide describes how to set up the necessary toolchains for developing, compiling, and flashing MicroPython and FPGA bitstreams for the Tang Nano 4K (GW1NSR-4C).

## 1. ARM GNU Toolchain (MicroPython Firmware)

The MicroPython port for the Cortex-M3 requires the ARM GNU Toolchain.

### Recommended Version
- **Version**: `10.3-2021.10` (arm-none-eabi)
- **Download**: [ARM Developer Website](https://developer.arm.com/downloads/-/gnu-rm)

### Installation (Ubuntu/Debian)
```bash
sudo apt-get update
sudo apt-get install gcc-arm-none-eabi libnewlib-arm-none-eabi build-essential
```

### Verification
```bash
arm-none-eabi-gcc --version
```

---

## 2. FPGA Toolchains (Bitstream Generation)

You have two options for generating the FPGA bitstream (`.fs` file).

### Option A: Official Gowin EDA (Recommended)
The official IDE provided by Gowin Semiconductor.

- **Download**: [Gowin Download Center](https://www.gowinsemi.com/en/support/download_eda/) (Requires registration).
- **Includes**: Synthesis, Place & Route, and the Gowin Programmer.

### Option B: Open-Source (Project Apicula)
A fully open-source toolchain for Gowin FPGAs.

- **Tools**:
    - **Apycula**: Documentation and bitstream tools (`pip install apycula`).
    - **Yosys**: Verilog synthesis.
    - **nextpnr-himbaechel**: Universal Place & Route tool.

#### Installation
```bash
# Install Apycula
pip install apycula

# Install Yosys and nextpnr (Example for Ubuntu)
sudo apt install yosys
# For nextpnr-himbaechel, you may need to build from source or use a pre-built nightly.
```

---

## 3. Flashing Tools

### openfpgaflasher
An open-source tool for flashing Gowin FPGAs and the Tang Nano 4K.

- **Installation**:
  ```bash
  pip install openfpgaflasher
  ```

- **Usage (Unified Flash)**:
  ```bash
  openfpgaflasher -b bitstream.fs -m firmware_int.bin -e firmware_ext.bin
  ```

---

## 4. MicroPython Build Dependencies

To compile MicroPython, you must first build the `mpy-cross` compiler:

```bash
# Build mpy-cross (one-time)
make -C src/lib/micropython/mpy-cross

# Build Tang Nano 4K port
make -C src/ports/tang_nano_4k/
```

Additional Python dependencies for tests and scripts:
```bash
pip install psutil robotframework==6.1 pyyaml
```
