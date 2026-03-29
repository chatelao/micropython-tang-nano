# Tiny Tapeout (TT) on Tang Nano 4K: Quick Start Guide

This guide provides the shortest path to porting your Tiny Tapeout module to the Tang Nano 4K (GW1NSR-4C) and running it with MicroPython.

## 1. Quick Start: Porting your TT Project

The fastest way to get started is to use the existing `tt_echo` example as a template.

### Step 1: Duplicate the Example
Copy the `examples/tt_echo` directory to a new folder for your project:
```bash
cp -r examples/tt_echo examples/my_tt_project
```

### Step 2: Copy your Verilog Code
1.  **Replace the project code**: Overwrite `examples/my_tt_project/tt_project.v` with your own Tiny Tapeout module's Verilog source code.
2.  **Update the wrapper**: Open `examples/my_tt_project/tt_wrapper.v` and update the module instantiation at the bottom of the file (e.g., change `tt_um_minimal_echo` to your module name).

### Step 3: Compile Everything
1.  **MicroPython Firmware**:
    ```bash
    # Build cross-compiler (once)
    make -C src/lib/micropython/mpy-cross
    # Build Tang Nano 4K firmware
    make -C src/ports/tang_nano_4k/
    ```
2.  **FPGA Bitstream**:
    - **Option A: Official Gowin EDA**
        - Open Gowin EDA and create a new project.
        - Add `tt_wrapper.v` and `tt_project.v` to the project.
        - Run "Place & Route" to generate the `.fs` bitstream.
    - **Option B: Open-Source (Project Apicula)**
        - Use Yosys for synthesis: `yosys -p "synth_gowin -json project.json" tt_wrapper.v tt_project.v`.
        - Use nextpnr for P&R: `nextpnr-himbaechel --json project.json --write project_pnr.json --device GW1NSR-LV4CQN48PC7/I6 --family GW1NS-4`.
        - Use gowin_pack for bitstream: `gowin_pack -d GW1NS-4 -o bitstream.fs project_pnr.json`.
        *Note: Requires `apycula`, `yosys`, and `nextpnr-himbaechel` to be installed.*

### Step 4: Install Everything
Use `openfpgaflasher` to load the bitstream and MicroPython firmware in one command:
```bash
openfpgaflasher -b path/to/your_bitstream.fs \
                -m src/ports/tang_nano_4k/build/firmware_int.bin \
                -e src/ports/tang_nano_4k/build/firmware_ext.bin
```

### Step 5: Simulation and Debugging
To test your design in simulation before hardware deployment:
1.  **Duplicate the test**: `cp test/examples/test_tt_echo.robot test/examples/test_my_tt_project.robot`.
2.  **Run Simulation**:
    ```bash
    renode-test test/examples/test_my_tt_project.robot
    ```

---

## 2. UART Console Alternatives (Pins 18/19)

You have two alternatives to connect the Cortex-M3 UART0 (routed to Pins 18/19 by default):

*   **External FTDI Port**: Connect an external 3.3V USB-to-Serial adapter to Pins 18 (TX) and 19 (RX). This requires no hardware modification.
*   **Onboard BL702 UART Pins**: Connect Pins 18/19 to the onboard BL702 bridge to use the USB-C cable for the console.
    *Note: This may require soldering bridges R11/R12 and routing UART0 to Pins 34/35 in the FPGA for direct connection.*

---

## 3. Open-Source FPGA Toolchain (Alternative)

For an entirely open-source workflow without Gowin EDA, you can use **Project Apicula**, **Yosys**, and **nextpnr-himbaechel** to generate the bitstream.

### Synthesis (Yosys)
```bash
yosys -p "read_verilog examples/my_tt_project/tt_wrapper.v examples/my_tt_project/tt_project.v; synth_gowin -json tt_project.json"
```

### Place & Route (nextpnr-himbaechel)
```bash
nextpnr-himbaechel --json tt_project.json \
                   --write tt_pnr.json \
                   --device GW1NSR-LV4CQN48PC7/I6 \
                   --vopt family=GW1NS-4 \
                   --vopt cst=examples/my_tt_project/tt_echo.cst
```

### Pack (gowin_pack)
```bash
gowin_pack -d GW1NS-4 -o tt_project.fs tt_pnr.json
```

---

## 4. Advanced Details & Reference

### Tiny Tapeout Interface Mapping
The standard TT interface is mapped to the M3 via **APB2 Slot 1** (`0x40002400`).

| Register | Address | Description |
| :--- | :--- | :--- |
| `CTRL` | `0x4000240C` | `[0]=clk`, `[1]=rst_n`, `[2]=ena` |
| `DATA` | `0x40002400` | **Write**: `ui_in`, **Read**: `uo_out` |
| `UIO_DATA` | `0x40002404` | **Write**: `uio_in`, **Read**: `uio_out` |
| `UIO_OE` | `0x40002408` | **Read**: `uio_oe` (from TT module) |

### MicroPython Interaction Example
```python
import machine
TT_CTRL = 0x4000240C
TT_DATA = 0x40002400

# Release reset and enable
machine.mem32[TT_CTRL] = 0x6

# Write data to ui_in
machine.mem32[TT_DATA] = 0xAB

# Read result from uo_out
print(hex(machine.mem32[TT_DATA] & 0xFF))
```

### Physical Pin Routing (CST File)
Ensure your Gowin Floor Planner (CST) matches these pins:
| Signal | FPGA Pin |
| :--- | :--- |
| **UART0 TX** | Pin 18 (or 35 for BL702) |
| **UART0 RX** | Pin 19 (or 34 for BL702) |
| **SPI CS_N** | Pin 36 |
| **SPI SCLK** | Pin 37 |
| **SPI MOSI** | Pin 38 |
| **SPI MISO** | Pin 39 |

### Firmware Architecture (Split Flash)
- `firmware_int.bin`: Bootloader/Vectors (Internal Flash at `0x0`).
- `firmware_ext.bin`: MicroPython Runtime (External SPI Flash at `0x60000000`).
