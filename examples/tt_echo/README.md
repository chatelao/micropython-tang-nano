# Tiny Tapeout Echo Example

This example demonstrates a minimal integration of a Tiny Tapeout (TT) module into the Tang Nano 4K (GW1NSR-4C) SoC. It uses an APB2 expansion slot to allow MicroPython to communicate with the TT module.

## End-to-End Integration Diagram

```puml
@startuml CONTEXT_DIAGRAM
!include https://raw.githubusercontent.com/plantuml-stdlib/C4-PlantUML/master/C4_Component.puml

LAYOUT_WITH_LEGEND()

Person(user, "User", "Interaction via Serial Terminal")

System_Boundary(tn4k, "Tang Nano 4K (GW1NSR-4C)") {
    Component(bl702, "BL702", "USB-to-UART Bridge", "Handles USB communication and JTAG/UART bridging")

    Container_Boundary(m3_subsystem, "Cortex-M3 Subsystem") {
        Component(m3, "Cortex-M3 Hard Core", "ARMv7-M", "Executes the MicroPython runtime")
        Component(micropython, "MicroPython", "Software", "Provides REPL and high-level hardware control")
    }

    Container_Boundary(fpga_fabric, "FPGA Fabric") {
        Component(apb2_bus, "APB2 Slot 1", "Bus Interface", "Memory-mapped I/O at 0x40002400")

        Container_Boundary(tt_logic, "Tiny Tapeout Wrapper") {
            Component(tt_wrapper, "tt_wrapper.v", "Verilog", "Bridges APB2 to TT signals (ui_in, uo_out, etc.)")
            Component(tt_project, "tt_project.v", "Verilog (TT)", "The actual Tiny Tapeout user module")
        }
    }
}

Rel(user, bl702, "USB / Serial", "115200 8N1")
Rel(bl702, m3, "UART0", "TX/RX Pins 18/19")
Rel(micropython, m3, "Runs on")
Rel_D(m3, apb2_bus, "MMIO", "APB2 Protocol")
Rel_D(apb2_bus, tt_wrapper, "Signal Mapping")
Rel_D(tt_wrapper, tt_project, "TT Interface", "ui_in, uo_out, clk, rst_n, ena")

@enduml
```

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
