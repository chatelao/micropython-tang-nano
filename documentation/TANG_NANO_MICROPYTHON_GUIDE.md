# Tang Nano 4K MicroPython Port Guide

This guide provides a comprehensive overview of the MicroPython port for the Sipeed Tang Nano 4K, including its hardware-specific features, the installation process, and usage instructions.

## 1. Tang Nano 4K Specific Elements

### Hardware Overview
The Sipeed Tang Nano 4K is based on the **Gowin GW1NSR-LV4C** SoC, which uniquely integrates a **hard-core ARM Cortex-M3 processor** with an FPGA fabric.

*   **CPU**: ARM Cortex-M3 (Hard Core)
*   **Clock Speed**: 27 MHz (sourced from the FPGA fabric)
*   **Internal Flash (ITCM)**: 32 KB (at `0x00000000`)
*   **SRAM**: 22 KB (at `0x20000000`)
*   **External SPI Flash**: 4 MB (accessible via SPI)
*   **UART0 (REPL)**: 115200 baud, 8N1 (mapped to FPGA pins 34 and 35)

### Supported `machine` Module Peripherals
The port implements the standard MicroPython `machine` module with hardware-specific optimizations for the GW1NSR-4C:

| Class | Description |
| :--- | :--- |
| `Pin` | GPIO control (0-15) with hardware interrupt support. |
| `Timer` | Hardware timers (0 and 1) for periodic or one-shot events. |
| `PWM` | Hardware-based Pulse Width Modulation on supported pins. |
| `ADC` | 12-bit Analog-to-Digital Converter support. |
| `I2C` / `SoftI2C` | Hardware I2C Master and bit-banged software I2C support. |
| `SPI` / `SoftSPI` | Hardware SPI Master and bit-banged software SPI support. |
| `RTC` | Real-Time Clock for date and time management. |
| `WDT` | Hardware Watchdog Timer for system reliability. |
| `Flash` | Block device interface for the onboard SPI Flash. See the [External Flash Guide](EXTERNAL_FLASH_GUIDE.md) for IP details. |

### Memory and Filesystem
MicroPython on the Tang Nano 4K utilizes the 22 KB internal SRAM as the primary heap and the **8 MB external PSRAM** as an extended heap.

#### PSRAM IP Core Configuration (Gowin EDA)
To enable the 8 MB PSRAM heap expansion, your FPGA bitstream must include the **Gowin PSRAM Memory Interface** IP (e.g., W955D8MBYA) with the following settings:
- **Bus Interface**: AHB
- **Mode**: Memory Mapped
- **Base Address**: 0xA0000000 (AHB2 Master range)
- **Data Width**: 16-bit
MicroPython uses a **LittleFS (LFS2)** filesystem on the external SPI Flash, allowing you to store Python scripts and data files.
*   **Flash Offset**: The filesystem starts at a 1 MB offset to avoid overwriting the FPGA bitstream.
*   **Size**: 3 MB of space is available for the user filesystem.

---

## 2. Installation Process

### Prerequisites
To build the firmware, you need the **ARM GNU Toolchain**. On Debian/Ubuntu:

```bash
sudo apt-get update
sudo apt-get install -y gcc-arm-none-eabi binutils-arm-none-eabi libnewlib-arm-none-eabi
```

### 1. Download/Clone the Project
Clone the repository including submodules:

```bash
git clone --recursive https://github.com/your-repo/micropython-tang-nano-4k.git
cd micropython-tang-nano-4k
```

### 2. Build `mpy-cross`
The MicroPython cross-compiler is required to build the port:

```bash
make -C src/lib/micropython/mpy-cross
```

### 3. Build the Firmware
Compile the Tang Nano 4K specific firmware. There are two main variants:

**Hardware Variant (for the actual board):**
```bash
make -C src/ports/tang_nano_4k/ BUILD=build_hw
```
Generates `firmware.bin` in `src/ports/tang_nano_4k/build_hw/`.

**Simulation Variant (for Renode):**
```bash
make -C src/ports/tang_nano_4k/ SIMULATION=1
```
Generates `firmware.bin` in `src/ports/tang_nano_4k/build/`.

### 4. Flashing the FPGA Bitstream (Essential)
Before the M3 core can interact with the external pins, you must flash the FPGA bitstream. This bitstream routes the M3's internal signals (UART, GPIO, etc.) to the physical pins of the Tang Nano 4K.

1.  In **Gowin Programmer**, select **Access Mode**: `SRAM Mode` (for testing) or `Embedded Flash Mode` (for permanent storage).
2.  Select the `tang_nano_4k_m3.fs` bitstream file from the release or `src/fpga/bitstream/`.
3.  Click **Run**.

### 5. Flashing the MicroPython Firmware (Split Flash Mode)
If you built the firmware with `SPLIT_FLASH=1`, follow these steps:

#### IP Core Configuration (Gowin EDA)
Before flashing, ensure your FPGA bitstream includes the **SPI Flash Interface** IP:
- **Bus Interface**: AHB
- **Mode**: Memory Mapped
- **Base Address**: 0x60000000 (XIP range)

#### Flashing Internal Flash
1.  In **Gowin Programmer**, select **Access Mode**: `MCU Mode`.
2.  Select **Operation**: `Flash Erase, Program, Verify`.
3.  Select the `firmware_int.bin` file.
4.  Click **Run**.

#### Flashing External Flash
1.  In **Gowin Programmer**, select **Access Mode**: `External Flash Mode`.
2.  Select **Operation**: `exFlash Erase, Program, Verify`.
3.  Select the `firmware_ext.bin` file.
4.  Set **Address**: `0x000000`.
5.  Click **Run**.

---

## 3. Usage and REPL

### Hardware Modifications
To access the MicroPython REPL via the USB-C connector (using the onboard BL702 bridge), you **must** solder two bridges on the bottom of the PCB:
*   **R11**: Connects BL702 RX to FPGA Pin 35 (M3 TX).
*   **R12**: Connects BL702 TX to FPGA Pin 34 (M3 RX).

### Accessing the REPL
Connect to the board using a serial terminal (e.g., `screen`, `minicom`, `PuTTY`) with the following settings:
*   **Baud Rate**: `115200`
*   **Data Bits**: `8`
*   **Parity**: `None`
*   **Stop Bits**: `1`
*   **Flow Control**: `None`

### Basic Commands
Once connected, you will see the MicroPython prompt:

```python
import machine
import time

# Toggle an LED (connected to Pin 0 via FPGA routing)
led = machine.Pin(0, machine.Pin.OUT)
while True:
    led.value(not led.value())
    time.sleep_ms(500)
```
