# FPGA Bridge Usage - Tang Nano 4K (GW1NSR-4C)

This document provides a detailed guide on using MicroPython to interact with the FPGA fabric on the Sipeed Tang Nano 4K.

## 1. GPIO Bridge (machine.FPGABridge)

The `machine.FPGABridge` class provides low-level access to a 16-bit bi-directional bus between the Cortex-M3 and the FPGA fabric.

### Initialization
```python
import machine
bridge = machine.FPGABridge()
```

### Writing to the FPGA
Writing a 16-bit value to the bridge:
```python
bridge.write(0xABCD)
```

### Reading from the FPGA
Reading a 16-bit value from the bridge:
```python
val = bridge.read()
print("Value from FPGA: 0x{:04x}".format(val))
```

### Direction Control
By default, all bits are configured as outputs from the M3 to the FPGA. To read data *from* the FPGA, you must set the corresponding bits as inputs by clearing their output enable bits in the `FPGA_GPIO_OUTENCLR` register.

| Register | Address | Description |
| :--- | :--- | :--- |
| `FPGA_GPIO_OUTENSET` | `0x40010010` | Set bits as outputs (1 = Output) |
| `FPGA_GPIO_OUTENCLR` | `0x40010014` | Clear bits to inputs (1 = Input) |

**Example: Configuring bits [15:8] as inputs:**
```python
# Clear output enable for bits [15:8]
machine.mem32[0x40010014] = 0xFF00

# Read 16-bit value (bits 8-15 now reflect FPGA signals)
val = bridge.read()
uio_val = (val >> 8) & 0xFF
```

---

## 2. FPGA DMA (machine.FPGADMA)

For high-speed data transfers between the M3's SRAM and the FPGA fabric, use the `machine.FPGADMA` class.

### Usage
```python
import machine

dma = machine.FPGADMA()
src_addr = 0x20001000  # Example SRAM address
dest_addr = 0x40002C00 # Example FPGA APB2 Slot address
length = 1024          # Number of bytes

# Perform transfer
dma.transfer(src_addr, dest_addr, length)
```

The `transfer` method accepts both integer addresses and buffer-compatible objects (e.g., `bytearray`).

---

## 3. APB2 Expansion Slots

The Cortex-M3 provides 12 slots on the APB2 bus, each 256 bytes wide, for custom register-mapped peripherals in the FPGA.

| Slot | Base Address |
| :--- | :--- |
| Slot 1 | `0x40002400` |
| Slot 2 | `0x40002500` |
| ... | ... |
| Slot 12 | `0x40002F00` |

### MicroPython Access
You can use `machine.mem32`, `machine.mem16`, or `machine.mem8` to access these slots.

```python
import machine

# Write to Slot 1, Offset 0
machine.mem32[0x40002400] = 0x12345678

# Read from Slot 1, Offset 4
val = machine.mem32[0x40002404]
```

---

## 4. FPGA Interrupts (USER_INT)

The FPGA can trigger interrupts on the M3 using dedicated `USER_INT` lines. These are mapped to specific IRQ numbers in the M3's NVIC.

| IRQ # | Name |
| :--- | :--- |
| 1 | `USER_INT0` |
| 3 | `USER_INT1` |
| 4 | `USER_INT2` |
| 7 | `USER_INT3` |
| 13 | `USER_INT4` |
| 14 | `USER_INT5` |

### Handling Interrupts in MicroPython
Currently, `machine.Pin` is the primary way to handle interrupts. To use `USER_INT` lines, they must be routed to a GPIO pin that supports interrupts in the FPGA fabric, or handled via low-level `machine.mem32` access to the NVIC registers (advanced).

---

## 5. Implementation Summary

- **Address Range**: `0x40010000` (GPIO Bridge), `0x40002400` - `0x40002FFF` (APB2).
- **Signal Mapping**: Refer to [M3_FPGA_INTEGRATIONS.md](M3_FPGA_INTEGRATIONS.md) for RTL wiring details.
- **Tiny Tapeout**: Refer to [HOWTO_TINY_TAPEOUT.md](HOWTO_TINY_TAPEOUT.md) for specific mapping to Tiny Tapeout modules.
