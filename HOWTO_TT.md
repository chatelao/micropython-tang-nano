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

## 5. FPGA Wrapper (Verilog)

The following wrapper demonstrates how to connect the M3 `Gowin_EMPU_M3` IP to a TT module via the APB2 bus.

```verilog
module top (
    input  wire clk_27m,
    input  wire rst_n,
    output wire uart_tx,
    input  wire uart_rx,
    // SPI Flash Pins
    output wire spi_cs_n,
    output wire spi_sclk,
    output wire spi_mosi,
    input  wire spi_miso
);

    // APB2 Slot 1 Signals (0x40002400)
    wire [7:0]  paddr;
    wire        psel, penable, pwrite;
    wire [31:0] pwdata;
    reg  [31:0] prdata;
    wire        pready = 1'b1;

    // Registers (W)
    reg [7:0] ui_in;
    reg [7:0] uio_in;
    reg [2:0] ctrl; // [0]=clk, [1]=rst_n (active-low), [2]=ena

    // Wires from TT module (R)
    wire [7:0] uo_out, uio_out, uio_oe;

    always @(posedge clk_27m or negedge rst_n) begin
        if (!rst_n) begin
            ui_in  <= 8'h0;
            uio_in <= 8'h0;
            ctrl   <= 3'h0; // Reset active (rst_n=0), Ena=0, Clk=0
        end else if (psel && penable && pwrite) begin
            case (paddr[3:0])
                4'h0: ui_in  <= pwdata[7:0];
                4'h4: uio_in <= pwdata[7:0];
                4'hC: ctrl   <= pwdata[2:0];
            endcase
        end
    end

    always @(*) begin
        case (paddr[3:0])
            4'h0: prdata = {24'h0, uo_out};
            4'h4: prdata = {24'h0, uio_out};
            4'h8: prdata = {24'h0, uio_oe};
            4'hC: prdata = {29'h0, ctrl};
            default: prdata = 32'h0;
        endcase
    end

    // --- TT Module Instantiation ---
    tt_um_example my_tt_design (
        .ui_in  (ui_in),
        .uo_out (uo_out),
        .uio_in (uio_in),
        .uio_out(uio_out),
        .uio_oe (uio_oe),
        .ena    (ctrl[2]),
        .clk    (ctrl[0]),
        .rst_n  (ctrl[1])
    );

    // --- M3 IP Instantiation ---
    Gowin_EMPU_M3 m3_inst (
        // APB2 Slot 1
        .PSEL1(psel),
        .PENABLE1(penable),
        .PWRITE1(pwrite),
        .PADDR1(paddr),
        .PWDATA1(pwdata),
        .PRDATA1(prdata),
        .PREADY1(pready),

        .UART0_TXD(uart_tx),
        .UART0_RXD(uart_rx),
        .RESET_N(rst_n),
        .CLK(clk_27m),
        // ... (AHB Expansion for Flash) ...
    );
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

## 8. Verification

See `examples/tt_echo/` for a complete working example.
