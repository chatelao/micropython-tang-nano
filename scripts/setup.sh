#!/bin/bash
set -e

# Install ARM GNU Toolchain if not present
if ! command -v arm-none-eabi-gcc &> /dev/null; then
    echo "ARM GNU Toolchain not found. Installing..."
    if [ "$CI" = "true" ] || [ "$EUID" -ne 0 ]; then
        sudo apt-get update
        sudo apt-get install -y gcc-arm-none-eabi binutils-arm-none-eabi libnewlib-arm-none-eabi
    else
        apt-get update
        apt-get install -y gcc-arm-none-eabi binutils-arm-none-eabi libnewlib-arm-none-eabi
    fi
else
    echo "ARM GNU Toolchain is already installed."
fi

# Clone MicroPython core if not present
if [ ! -f "src/lib/micropython/README.md" ]; then
    echo "Cloning MicroPython core..."
    # Remove directory if it exists but is empty/incomplete
    rm -rf src/lib/micropython
    git clone --depth 1 --branch v1.24.1 https://github.com/micropython/micropython.git src/lib/micropython
else
    echo "MicroPython core already exists."
fi
