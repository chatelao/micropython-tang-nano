# Tiny Tapeout Echo Example

This example demonstrates a minimal integration of a Tiny Tapeout (TT) module into the Tang Nano 4K (GW1NSR-4C) SoC. It uses an APB2 expansion slot to allow MicroPython to communicate with the TT module.

## End-to-End Integration Diagram

![End-to-End Integration](http://www.plantuml.com/plantuml/proxy?cache=no&src=https://raw.githubusercontent.com/chatelao/micropython-tang-nano/main/examples/tt_echo/architecture.puml)

## Example Files

- `tt_echo.py`: The MicroPython script that initializes the TT module and performs an echo test by writing to `ui_in` and reading from `uo_out`.
- `tt_wrapper.v`: A Verilog wrapper that implements an APB2 slave and maps its registers to the Tiny Tapeout signal interface.
- `tt_project.v`: A simple Tiny Tapeout compatible module that echoes `ui_in` to `uo_out` and sets a fixed value for `uio_out`.

## How it Works

1.  **MicroPython** runs on the **Cortex-M3** hard core.
2.  The script `tt_echo.py` uses `machine.mem32` to access the **APB2 Slot 1** base address (`0x40002400`).
3.  The **FPGA Fabric** contains an APB2 slave (`tt_wrapper.v`) that translates these memory accesses into signals for the **TT Project**.
4.  **Slow Debugging**: By toggling the `clk` bit in the `CTRL` register from MicroPython, you can manually step the clock of the TT module.

For detailed instructions on how to set up the Gowin EDA project and flash the firmware, see the [HOWTO_TINY_TAPEOUT.md](../../HOWTO_TINY_TAPEOUT.md) guide in the root directory.
