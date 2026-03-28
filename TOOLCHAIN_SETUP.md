# Toolchain Setup for Tang Nano 4K

To cross-compile MicroPython for the ARM Cortex-M3 core on the Tang Nano 4K, the ARM GNU Toolchain is required.

## Installation

On Debian-based systems (like Ubuntu), the toolchain can be installed using `apt-get`:

```bash
sudo apt-get update
sudo apt-get install -y gcc-arm-none-eabi binutils-arm-none-eabi libnewlib-arm-none-eabi
```

## Verification

To verify the installation, run the following command:

```bash
arm-none-eabi-gcc --version
```

It should output the version information of the installed GCC compiler.

## Usage

This toolchain provides the necessary compiler (`arm-none-eabi-gcc`), linker (`arm-none-eabi-ld`), and other utilities (like `arm-none-eabi-objcopy`) to build firmware for the ARM Cortex-M3 core integrated in the Gowin GW1NSR-LV4C FPGA.
