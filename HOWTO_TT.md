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

On the Tang Nano 4K, the ARM Cortex-M3 "Hard Core" communicates with the FPGA fabric via a 16-bit **GPIO Bridge**. This bridge is accessible in MicroPython via the `machine.FPGABridge` class.

### Recommended Signal Mapping

To accommodate the 24 TT signals (8 in, 8 out, 8 bidir) within a 16-bit bridge, we recommend the following mapping:

| Bridge Bit(s) | TT Signal(s) | Description |
| :--- | :--- | :--- |
| `[7:0]` | `ui_in` / `uo_out` | Multiplexed or shared data bus. |
| `[15:8]` | `uio_in` / `uio_out` | Bidirectional I/O bus. |

*Note on Control Signals:* The `machine.FPGABridge` provides only 16 bits of connectivity. Since a full TT interface (24 data/IO pins + 3 control pins) exceeds this, we recommend managing `ena`, `clk`, and `rst_n` directly in the FPGA wrapper:
*   **`clk`**: Should be connected to a hardware clock (e.g., the 27MHz crystal or M3 `HCLK`) for stability and speed.
*   **`rst_n`**: Typically tied to the system reset to ensure the module initializes on power-up.
*   **`ena`**: Can be tied to `1'b1` (always enabled) or controlled via a separate **APB2 Register** (see [M3_FPGA_INTEGRATIONS.md](M3_FPGA_INTEGRATIONS.md)) to save bridge bits.

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
    *   Enable **GPIO** (16-bit) for the `FPGABridge`.
    *   Enable **UART0** for the MicroPython REPL.
    *   Enable **AHB Master** (Expansion) to access the External Flash.
2.  **SPI Flash Interface (IPUG1015)**:
    *   **Protocol**: Single SPI.
    *   **Bus Interface**: `AHB`.
    *   **Memory Mapped**: Enabled (Base Address `0x60000000`).
    *   Connect this to the M3 AHB Master port.

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

## 5. FPGA Wrapper (Verilog)

The following wrapper demonstrates how to connect the M3 `Gowin_EMPU_M3` IP, the `tt_um_example` module, and the UART0 pins.

```verilog
module top (
    input  wire clk_27m,   // 27MHz Crystal
    input  wire rst_n,     // Reset Button
    output wire uart_tx,   // Pin 18
    input  wire uart_rx,   // Pin 19
    // SPI Flash Pins
    output wire spi_cs_n,  // Pin 36
    output wire spi_sclk,  // Pin 37
    output wire spi_mosi,  // Pin 38
    input  wire spi_miso   // Pin 39
);

    // M3 Bridge signals
    wire [15:0] m3_gpio_out;
    wire [15:0] m3_gpio_in;
    wire [15:0] m3_gpio_oe;

    // TT Module signals
    wire [7:0] ui_in;
    wire [7:0] uo_out;
    wire [7:0] uio_in;
    wire [7:0] uio_out;
    wire [7:0] uio_oe;

    // --- Signal Mapping ---

    // 1. Map Bridge [7:0] to ui_in / uo_out
    assign ui_in = m3_gpio_out[7:0];
    assign m3_gpio_in[7:0] = uo_out;

    // 2. Map Bridge [15:8] to uio
    assign uio_in = m3_gpio_out[15:8];
    assign m3_gpio_in[15:8] = uio_out;

    // --- TT Module Instantiation ---
    tt_um_example my_tt_design (
        .ui_in  (ui_in),
        .uo_out (uo_out),
        .uio_in (uio_in),
        .uio_out(uio_out),
        .uio_oe (uio_oe),
        .ena    (1'b1),     // Always enabled
        .clk    (clk_27m),  // Use 27MHz system clock
        .rst_n  (rst_n)
    );

    // --- M3 IP Instantiation ---
    Gowin_EMPU_M3 m3_inst (
        .GPIO(m3_gpio_in),
        .GPIO_OUT(m3_gpio_out),
        .GPIO_OUTEN(m3_gpio_oe),
        .UART0_TXD(uart_tx),
        .UART0_RXD(uart_rx),

        // AHB Expansion to SPI Flash IP
        .HADDR(m3_haddr),
        .HWDATA(m3_hwdata),
        .HRDATA(m3_hrdata),
        .HWRITE(m3_hwrite),
        .HSIZE(m3_hsize),
        .HBURST(m3_hburst),
        .HPROT(m3_hprot),
        .HTRANS(m3_htrans),
        .HMASTLOCK(m3_hmastlock),
        .HREADY(m3_hready),
        .HRESP(m3_hresp),
        .HSEL(m3_hsel),

        .RESET_N(rst_n),
        .CLK(clk_27m)
    );

    // --- SPI Flash IP Instantiation ---
    SPI_Flash_Interface_Top flash_inst (
        .haddr(m3_haddr),
        .hwdata(m3_hwdata),
        .hrdata(m3_hrdata),
        .hwrite(m3_hwrite),
        .hsize(m3_hsize),
        .hburst(m3_hburst),
        .hprot(m3_hprot),
        .htrans(m3_htrans),
        .hmastlock(m3_hmastlock),
        .hreadyin(m3_hready),
        .hreadyout(m3_hready),
        .hresp(m3_hresp),
        .hsel(m3_hsel),

        .clk(clk_27m),
        .rst_n(rst_n),

        // Physical SPI Pins
        .mspi_cs_n(spi_cs_n),
        .mspi_sclk(spi_sclk),
        .mspi_mosi(spi_mosi),
        .mspi_miso(spi_miso)
    );

    // AHB Master signals (internal wires)
    wire [31:0] m3_haddr, m3_hwdata, m3_hrdata;
    wire m3_hwrite, m3_hmastlock, m3_hready, m3_hresp, m3_hsel;
    wire [2:0] m3_hsize, m3_hburst;
    wire [3:0] m3_hprot;
    wire [1:0] m3_htrans;

endmodule
```

## 6. MicroPython Usage

Using the `machine.FPGABridge` class, you can interact with your TT design from MicroPython.

```python
import machine
import time

bridge = machine.FPGABridge()

# 1. Send data to ui_in (bits 0-7)
bridge.write(0x42)

# 2. Read data from uo_out (bits 0-7)
val = bridge.read() & 0xFF
print("Received from TT: 0x{:02x}".format(val))

# 3. Use Bidirectional UIO (bits 8-15)
# Set Bridge bits 8-15 as inputs to the M3 (output from FPGA)
# FPGA_GPIO_OUTENCLR is at 0x40010014
machine.mem32[0x40010014] = 0xFF00

uio_val = (bridge.read() >> 8) & 0xFF
print("UIO Input: 0x{:02x}".format(uio_val))
```

## 7. Compilation and Bitstream Generation

1.  **Synthesize**: Run Synthesis in Gowin EDA to check for RTL errors.
2.  **Floorplan**: Open the Floorplanner and verify that pins 18, 19, 36-39 are correctly assigned as per the table in Section 4.
3.  **Place & Route**: Run the "Place & Route" tool.
4.  **Bitstream**: Generate the `.fs` bitstream file.
5.  **Program**: Use the Gowin Programmer to load the `.fs` file into the FPGA (SRAM or Embedded Flash).

## 8. Verification

See `examples/tt_echo/` for a complete working example including Verilog and MicroPython scripts.
