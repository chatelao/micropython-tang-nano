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

## 3. FPGA Wrapper (Verilog)

You must instantiate your TT module and connect it to the `Gowin_EMPU_M3` IP core in your Gowin EDA project.

```verilog
// Example wrapper connecting TT module to M3 GPIO Bridge
module tt_m3_wrapper (
    input wire clk,
    input wire rst_n
);
    // M3 Bridge signals from Gowin_EMPU_M3 IP
    wire [15:0] m3_gpio_out;
    wire [15:0] m3_gpio_in;
    wire [15:0] m3_gpio_oe; // 1 = Output from M3 to FPGA

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
    // Note: uio_oe from the TT module can be used to drive physical pins
    // or internal logic, but the M3 controls its own bridge direction.

    // --- TT Module Instantiation ---
    tt_um_example my_tt_design (
        .ui_in  (ui_in),
        .uo_out (uo_out),
        .uio_in (uio_in),
        .uio_out(uio_out),
        .uio_oe (uio_oe),
        .ena    (1'b1),
        .clk    (clk),
        .rst_n  (rst_n)
    );

    // --- M3 IP Instantiation ---
    Gowin_EMPU_M3 your_m3_inst (
        .GPIO(m3_gpio_in),           // Input to M3
        .GPIO_OUT(m3_gpio_out),      // Output from M3
        .GPIO_OUTEN(m3_gpio_oe),     // Output Enable from M3
        // ... other ports ...
    );

endmodule
```

## 4. MicroPython Usage

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

## 5. Deployment Notes

*   **Internal Flash Limit**: The Tang Nano 4K has only 32KB of internal code flash. Standard MicroPython builds will not fit.
*   **Split Flash Architecture**: Ensure you are using a firmware build with `SPLIT_FLASH=1`. This places the MicroPython runtime in the external SPI Flash, leaving the 32KB internal flash for the bootloader and vector table.
*   **Verification**: See `examples/tt_echo/` for a complete working example including Verilog and MicroPython scripts.
