# Tiny Tapeout VGA to HDMI Example

This example demonstrates how to adapt a Tiny Tapeout (TT) VGA project to output video via the HDMI connector on the Tang Nano 4K.

## Architecture

![Architecture](https://www.plantuml.com/plantuml/proxy?src=https://raw.githubusercontent.com/chatelao/micropython-tang-nano/main/examples/tiny-tapeouts/tt_vga_to_hdmi/architecture.puml)

The integration follows this data path:
1.  **MicroPython (Cortex-M3)**: Controls the Tiny Tapeout module (reset, enable) via the APB2 bus.
2.  **TT Wrapper**: Provides the APB2 interface, handles clocking (via PLL), and hosts the Tiny Tapeout module.
3.  **TT VGA Project**: Generates digital VGA signals (RGB, HSync, VSync, Blank).
4.  **HDMI/DVI Encoder**: Converts the VGA signals into TMDS signals using a 10x serialization clock.
5.  **HDMI Connector**: Physical output to a monitor.

## Signal Mapping (uo_out)

This example uses the following pinout for `uo_out` (matching `tt_project.v`):

| Bit | Signal | Description |
| :--- | :--- | :--- |
| 7 | VSYNC | Vertical Sync |
| 6 | HSYNC | Horizontal Sync |
| 5 | BLANK | Video Blanking (Active High) |
| 4 | B1    | Blue (Bit 1) |
| 3 | B0    | Blue (Bit 0) |
| 2 | G1    | Green (Bit 1) |
| 1 | R1    | Red (Bit 1) |
| 0 | R0    | Red (Bit 0) |

## Clocking Requirements

For a standard 640x480 @ 60Hz resolution, the following clocks are required:
- **Pixel Clock**: 25.175 MHz (Used by the TT module and TMDS encoder).
- **Serial Clock**: 251.75 MHz (10x Pixel Clock, used for TMDS bit serialization).

In the provided example `tt_vga_hdmi_wrapper.v`, placeholders for these clocks are included. On physical hardware, you MUST use the Gowin **rPLL** primitive to generate these from the 27MHz on-board crystal. The provided Verilog ties them to the input clock temporarily to avoid synthesis warnings about undriven wires.

## Example Files

- `tt_vga_hdmi.py`: MicroPython script to enable the TT module and monitor status.
- `tt_vga_hdmi_wrapper.v`: Top-level Verilog wrapper integrating APB2, TT module, and HDMI encoder.
- `tt_project.v`: A placeholder for your Tiny Tapeout VGA project (Pattern Generator).
- `hdmi_encoder.v`: Verilog module for TMDS encoding and 10x serialization.
- `tt_vga_hdmi.cst`: Physical constraints for Tang Nano 4K HDMI pins.

## How to Use

1.  **Replace `tt_project.v`**: Put your Tiny Tapeout VGA source code here.
2.  **Clocking**: Configure a Gowin rPLL to generate the 25.175 MHz and 251.75 MHz clocks.
3.  **Build & Flash**: Use Gowin EDA to generate the bitstream and `openfpgaflasher` to deploy it alongside the MicroPython firmware.
4.  **Run**: Execute `tt_vga_hdmi.py` in the MicroPython REPL to enable the module.
