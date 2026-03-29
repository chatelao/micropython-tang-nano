# Tiny Tapeout (TT) on Tang Nano 4K

This guide describes how to load and test a Tiny Tapeout module on the Tang Nano 4K (GW1NSR-4C) using MicroPython.

## 1. Tiny Tapeout Interface Overview

A standard Tiny Tapeout module (e.g., `tt_um_example`) provides the following 8-bit ports:

*   `ui_in [7:0]`: Dedicated inputs to the design.
*   `uo_out [7:0]`: Dedicated outputs from the design.
*   `uio_in [7:0]`: Bidirectional pins (input path).
*   `uio_out [7:0]`: Bidirectional pins (output path).
*   `uio_oe [7:0]`: Output enable for bidirectional pins (1 = output, 0 = input).
*   `ena`: Enable signal (high when the design is active).
*   `clk`: Clock signal.
*   `rst_n`: Active-low reset.

## 2. Mapping to Tang Nano 4K

On the Tang Nano 4K, we recommend using an **APB2 Expansion Slot** to communicate with the Tiny Tapeout module. This allows for independent control of the clock, reset, and enable signals from MicroPython, enabling "slow debugging" (manual clock stepping).

### Recommended Interface: APB2 Slot 1 (`0x40002400`)

| Register Offset | Name | Bits | Description |
| :--- | :--- | :--- | :--- |
| `0x00` | `DATA` | `[7:0]` | **W**: `ui_in`, **R**: `uo_out` |
| `0x04` | `UIO_DATA` | `[7:0]` | **W**: `uio_in`, **R**: `uio_out` |
| `0x08` | `UIO_OE` | `[7:0]` | **R**: `uio_oe` (driven by TT module) |
| `0x0C` | `CTRL` | `[2:0]` | `[0]=clk`, `[1]=rst_n` (active-low), `[2]=ena` |

## 3. Firmware Installation (Split Flash)

The Tang Nano 4K has only 32KB of internal code flash, which is insufficient for the full MicroPython runtime (~125KB). You **must** use the Split Flash architecture.

| Component | Binary | Flash Type | Target Address |
| :--- | :--- | :--- | :--- |
| **Bootloader/Vectors** | `firmware_int.bin` | Internal Flash | `0x00000000` |
| **MicroPython Runtime** | `firmware_ext.bin` | External SPI Flash | `0x000000` (Mapped to `0x60000000`) |

### Installation with Gowin Programmer
1.  **Flash Internal Flash**:
    *   Access Mode: `MCU Mode`
    *   Operation: `Flash Erase, Program, Verify`
    *   File: `build/firmware_int.bin`
2.  **Flash External Flash**:
    *   Access Mode: `External Flash Mode`
    *   Operation: `exFlash Erase, Program, Verify`
    *   File: `build/firmware_ext.bin`
    *   Address: `0x000000`

## 4. Gowin EDA Project Setup

To enable M3-to-FPGA communication and serial console access, your Gowin project must include specific IP cores and routing.

### IP Core Configuration
1.  **Gowin_EMPU_M3**:
    *   Enable **APB2 Expansion** (for Slot 1 access).
    *   Enable **UART0** for the MicroPython REPL.
    *   Enable **AHB Master** (Expansion) to access the External Flash.
2.  **SPI Flash Interface (IPUG1015)**:
    *   **Protocol**: Single SPI.
    *   **Bus Interface**: `AHB`.
    *   **Memory Mapped**: Enabled (Base Address `0x60000000`).

### Physical Pin Routing (CST File)
Route the UART0 and SPI signals to the following physical pins:

| Signal | FPGA Pin | Description |
| :--- | :--- | :--- |
| **UART0 TX** | Pin 18 | MicroPython REPL Output |
| **UART0 RX** | Pin 19 | MicroPython REPL Input |
| **SPI CS_N** | Pin 36 | External Flash Chip Select |
| **SPI SCLK** | Pin 37 | External Flash Clock |
| **SPI MOSI** | Pin 38 | External Flash Data Out |
| **SPI MISO** | Pin 39 | External Flash Data In |
| **TT ui_in[7:0]** | Pins 28-35 | Mirror of TT inputs |
| **TT uo_out[7:0]** | Pins 20-23, 27, 40-42 | TT dedicated outputs |
| **TT uio[7:0]** | Pins 13-17, 43-44, 46 | Bidirectional IOs |
| **TT ena** | Pin 1 | TT Enable |
| **TT clk** | Pin 2 | TT Clock |
| **TT rst_n** | Pin 48 | TT Reset (Active Low) |

## 5. FPGA Top-Level and Wrapper (Verilog)

The following `tt_m3_wrapper` connects the M3 `Gowin_EMPU_M3` IP to a TT module and exposes the signals to the ports.

```verilog
module tt_m3_wrapper (
    // ... APB2 Ports ...
    output wire [7:0] tt_ui_in,
    output wire [7:0] tt_uo_out,
    input  wire [7:0] tt_uio_in,
    output wire [7:0] tt_uio_out,
    output wire [7:0] tt_uio_oe,
    output wire       tt_ena,
    output wire       tt_clk,
    output wire       tt_rst_n
);
    // ... Logic ...
endmodule
```

## 6. MicroPython Usage

Interacting with the TT design via APB2:

```python
import machine
import time

TT_BASE = 0x40002400
REG_DATA = TT_BASE + 0x00
REG_CTRL = TT_BASE + 0x0C

# 1. Initialize: De-assert reset, Enable design
machine.mem32[REG_CTRL] = 0x6 # rst_n=1, ena=1, clk=0

# 2. Send data to ui_in
machine.mem32[REG_DATA] = 0x42

# 3. Toggle clock for synchronous designs
machine.mem32[REG_CTRL] |= 0x1 # clk=1
machine.mem32[REG_CTRL] &= ~0x1 # clk=0

# 4. Read data from uo_out
val = machine.mem32[REG_DATA] & 0xFF
print("Received from TT: 0x{:02x}".format(val))
```

## 7. Compilation and Bitstream Generation

1.  **Synthesize**: Run Synthesis in Gowin EDA.
2.  **Floorplan**: Verify pins 18, 19, 36-39.
3.  **Place & Route**: Run the "Place & Route" tool.
4.  **Bitstream**: Generate the `.fs` bitstream file.
5.  **Program**: Load the `.fs` file into the FPGA.

## 8. Flashing with openfpgaflasher

As an alternative to the official Gowin Programmer, you can use the open-source `openfpgaflasher` tool. This is particularly useful for Linux and macOS users as it allows flashing both the FPGA bitstream and the MicroPython firmware (internal and external) in a single step.

### Installation

The tool is written in Python and can be installed via pip:

```bash
pip install openfpgaflasher
```

### Prerequisites

*   **Python 3.6+**
*   **pyusb**: Usually installed automatically with the tool.
*   **Linux Users**: You may need to add udev rules for the onboard BL702 debugger. Create a file `/etc/udev/rules.d/99-tangnano.rules` with the following content:
    ```text
    ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6010", MODE="0666", GROUP="plugdev"
    ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="05dc", MODE="0666", GROUP="plugdev"
    ```

### Usage: Flashing Everything

To flash the FPGA bitstream, the internal MCU firmware, and the external flash firmware simultaneously, use the following command:

```bash
openfpgaflasher -b <bitstream.fs> -m <firmware_int.bin> -e <firmware_ext.bin>
```

**Example from the project root:**
```bash
openfpgaflasher examples/tt_echo/tt_echo.fs -m src/ports/tang_nano_4k/build/firmware_int.bin -e src/ports/tang_nano_4k/build/firmware_ext.bin
```

## 8. Verification

See `examples/tt_echo/` for a complete working example.
