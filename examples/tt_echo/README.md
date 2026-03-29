# Tiny Tapeout Echo Example

This example demonstrates a minimal integration of a Tiny Tapeout (TT) module into the Tang Nano 4K (GW1NSR-4C) SoC. It uses an APB2 expansion slot to allow MicroPython to communicate with the TT module.

## End-to-End Integration Diagram

![End-to-End Integration](http://www.plantuml.com/plantuml/proxy?cache=no&src=https://raw.githubusercontent.com/chatelao/micropython-tang-nano/main/examples/tt_echo/architecture.puml)

## Example Files

- `tt_echo.py`: The MicroPython script that initializes the TT module and performs an echo test by writing to `ui_in` and reading from `uo_out`.
- `tt_wrapper.v`: A Verilog wrapper that implements an APB2 slave and maps its registers to the Tiny Tapeout signal interface.
- `tt_project.v`: A simple Tiny Tapeout compatible module that echoes `ui_in` to `uo_out` and sets a fixed value for `uio_out`.

## Register Map

The TT module is mapped to **APB2 Slot 1** (Base Address: `0x40002400`).

| Register | Offset | Address | Access | Description |
| :--- | :--- | :--- | :--- | :--- |
| `DATA` | `0x00` | `0x40002400` | RW | Write: `ui_in` / Read: `uo_out` |
| `UIO_DATA` | `0x04` | `0x40002404` | RW | Write: `uio_in` / Read: `uio_out` |
| `UIO_OE` | `0x08` | `0x40002408` | RO | Read: `uio_oe` (8-bit) |
| `CTRL` | `0x0C` | `0x4000240C` | RW | Control: [0]=clk, [1]=rst_n, [2]=ena |

## Register Bitfields

### `DATA` Register (Offset: `0x00`)
```wavedrom
{ "reg": [
  {"name": "ui_in (W) / uo_out (R)", "bits": 8},
  {"bits": 24}
], "config": {"bits": 32}}
```

### `UIO_DATA` Register (Offset: `0x04`)
```wavedrom
{ "reg": [
  {"name": "uio_in (W) / uio_out (R)", "bits": 8},
  {"bits": 24}
], "config": {"bits": 32}}
```

### `UIO_OE` Register (Offset: `0x08`)
```wavedrom
{ "reg": [
  {"name": "uio_oe (R)", "bits": 8},
  {"bits": 24}
], "config": {"bits": 32}}
```

### `CTRL` Register (Offset: `0x0C`)
```wavedrom
{ "reg": [
  {"name": "clk", "bits": 1},
  {"name": "rst_n", "bits": 1},
  {"name": "ena", "bits": 1},
  {"bits": 29}
], "config": {"bits": 32}}
```

## How it Works

1.  **MicroPython** runs on the **Cortex-M3** hard core.
2.  The script `tt_echo.py` uses `machine.mem32` to access the **APB2 Slot 1** base address (`0x40002400`).
3.  The **FPGA Fabric** contains an APB2 slave (`tt_wrapper.v`) that translates these memory accesses into signals for the **TT Project**.
4.  **Slow Debugging**: By toggling the `clk` bit in the `CTRL` register from MicroPython, you can manually step the clock of the TT module.

For detailed instructions on how to set up the Gowin EDA project and flash the firmware, see the [HOWTO_TINY_TAPEOUT.md](../../HOWTO_TINY_TAPEOUT.md) guide in the root directory.
