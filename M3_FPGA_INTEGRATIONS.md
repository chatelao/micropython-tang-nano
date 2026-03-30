# M3-to-FPGA Integrations - Tang Nano 4K (GW1NSR-4C)

This document provides a comprehensive guide to the communication interfaces between the ARM Cortex-M3 "Hard Core" and the FPGA fabric in the Gowin GW1NSR-4C SoC.

## 1. System Architecture Overview

The GW1NSR-4C integrates a Cortex-M3 processor with the Gowin LittleBee FPGA fabric. A key architectural constraint is that the M3 core **does not have direct access to the chip's I/O blocks (IOBs)**. All communication with external pins (other than JTAG) must pass through the FPGA fabric.

### Bus Structure
- **AHB-Lite Bus**: The main high-performance system bus for the M3.
- **APB1 Bus**: Connects to the M3's internal hard-core peripherals (UART, Timers, etc.).
- **APB2 Bus**: A dedicated bus interface for user-defined peripherals implemented in the FPGA fabric.
- **AHB Expansion**: High-speed 128-bit ports for master/slave data exchange with the FPGA.

---

## 2. Integration Variants

### Variant 1: GPIO Bridge (Control-Oriented)
A 16-bit wide AHB peripheral where each bit is routed directly to the FPGA fabric. This is the simplest way to send control signals or read status flags.

**MicroPython Usage:**
```python
import machine
bridge = machine.FPGABridge()

# Write 16-bit value to FPGA
bridge.write(0xABCD)

# Read 16-bit value from FPGA
val = bridge.read()
```

**FPGA-Side Wiring:**
The M3's GPIO signals must be instantiated in your RTL. In Gowin EDA, these appear as the `GPIO` port of the `Gowin_EMPU_M3` IP core.
- `GPIO[15:0]`: Bi-directional signals.
- `GPIO_OUTEN[15:0]`: Direction control from M3.

---

### Variant 2: APB2 Expansion Slots (Register-Mapped) - (Default)
The M3 provides 12 slots of 256 bytes each on the APB2 bus. This allows you to implement custom register-mapped peripherals in the FPGA.

**Reference Video:** [Custom APB2 Peripherals on Tang Nano 4K](https://youtu.be/6wGrsRgHWBU)

**Register Map:**
| Slot | Base Address |
| :--- | :--- |
| Slot 1 | `0x40002400` |
| Slot 2 | `0x40002500` |
| ... | ... |
| Slot 12 | `0x40002F00` |

**MicroPython Usage:**
```python
import machine

# Write to Slot 1, Offset 0
machine.mem32[0x40002400] = 0x12345678

# Read from Slot 1, Offset 4
val = machine.mem32[0x40002404]
```

**Practical Example (SERV RISC-V):**
The SERV core is mapped to APB2 Slot 10 (`0x40002D00`) for control and results. See `examples/cpus/serv_riscv/` for details.

**FPGA-Side Wiring:**
Your RTL must implement an APB slave interface responding to the address range of the selected slot.

---

### Variant 3: Shared Memory (Data-Oriented)
Leverages the Dual-Port nature of the Block SRAM (BSRAM).
- **M3 Side**: Accessed as standard internal SRAM (starting at `0x20000000`).
- **FPGA Side**: Connected to Port B of the BSRAM.

**MicroPython Usage:**
```python
import machine

# Use a buffer in a known SRAM location
# Note: Ensure this region isn't used by the MicroPython heap/stack
addr = 0x20004000
machine.mem32[addr] = 0xDEADBEEF
```

---

### Variant 4: RISC-V Co-processor (Advanced)
By combining APB2 for control and shared PSRAM for data, you can integrate a RISC-V co-processor (like NEORV32) into your FPGA design.

**MicroPython Usage:**
```python
import machine

# 1. Load RISC-V code to shared PSRAM (AHB Expansion region)
machine.mem32[0xA0000000] = binary_data

# 2. Start RISC-V via APB2 Slot 1 (Control Register)
machine.mem32[0x40002400] = 0x00 # Release reset

# 3. Use APB2 Slot 1 as a mailbox
riscv_response = machine.mem32[0x40002404]
```

**FPGA-Side Wiring:**
The RISC-V core is instantiated as an AHB Master (for instruction/data access to PSRAM) and an APB Slave (for control/mailbox access from the M3).

---

### Variant 5: High-Speed AHB/DMA (Performance)
Uses the 128-bit wide AHB expansion ports (`INTEXP0` and `TARGEXP0`) for massive data transfers.

**MicroPython Usage:**
```python
import machine
dma = machine.FPGADMA()

# Transfer 1KB from SRAM to FPGA space (e.g., 0x40002C00)
# dma.transfer(source, destination, length)
dma.transfer(0x20001000, 0x40002C00, 1024)
```

---

## 3. Interrupts and Synchronization

The FPGA can trigger interrupts on the M3 via dedicated `USER_INT` lines.

| IRQ # | Name | Description |
| :--- | :--- | :--- |
| 1 | `USER_INT0` | FPGA-sourced User Interrupt 0 |
| 3 | `USER_INT1` | FPGA-sourced User Interrupt 1 |
| 4 | `USER_INT2` | FPGA-sourced User Interrupt 2 |
| 7 | `USER_INT3` | FPGA-sourced User Interrupt 3 |
| 13 | `USER_INT4` | FPGA-sourced User Interrupt 4 |
| 14 | `USER_INT5` | FPGA-sourced User Interrupt 5 |

Additionally, the `IntMonitor` signal allows the FPGA to observe M3 peripheral interrupts (UART, Timers) in real-time.

---

## 4. Hard-Core Peripheral Mapping

Even "hard" peripherals like UART0/1 and Timers have their signals routed through the FPGA fabric before reaching physical pins.

| Peripheral | Base Address | IRQ | Signal Route |
| :--- | :--- | :--- | :--- |
| UART0 | `0x40004000` | 0 | Typically pins 18(TX), 19(RX) |
| UART1 | `0x40005000` | 2 | FPGA-defined |
| Timer 0 | `0x40000000` | 8 | `EXTIN` from GPIO[1] |
| Timer 1 | `0x40001000` | 9 | `EXTIN` from GPIO[6] |

---

## 5. Wiring Quick Reference

To connect M3 signals to external pins in your FPGA project:

1. **Instantiate the M3 IP Core** in Gowin EDA.
2. **Assign Pins** in the Floorplanner or `.cst` file.
3. **Route signals** in Verilog/VHDL:
   ```verilog
   // Example: Routing UART0 to physical pins
   assign physical_pin_18 = m3_uart0_tx;
   assign m3_uart0_rx = physical_pin_19;

   // Example: Using GPIO Bridge to drive an LED
   assign led_pin = m3_gpio_out[0];
   ```
