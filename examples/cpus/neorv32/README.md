# Running NEORV32 RISC-V on Tang Nano 4K

This example demonstrates how to integrate the [NEORV32](https://github.com/stnolting/neorv32) RISC-V processor as a co-processor alongside the ARM Cortex-M3 on the Tang Nano 4K.

## 1. Architecture Overview

The GW1NSR-4C SoC provides several ways for the M3 and FPGA fabric to communicate. For this example, we use:

1.  **APB2 Slot 1 (0x40002400)**: Used as a control and status interface for the NEORV32 core (Reset, Start, and simple mailbox).
2.  **Shared PSRAM (0xA0000000)**: Used to store the RISC-V program and data. Both the M3 and NEORV32 have access to this memory.

## 2. FPGA Implementation

The provided `neorv32_wrapper.v` (template) shows how to connect the NEORV32 to the M3's buses.

- The NEORV32's **Instruction Bus** and **Data Bus** are connected to the PSRAM via the AHB Expansion interface.
- A small **APB Slave** is implemented in Slot 1 to allow the M3 to control the NEORV32's reset line.

## 3. Software Flow

1.  **M3 Initialized**: MicroPython starts on the Cortex-M3.
2.  **Load RISC-V Binary**: The MicroPython script `neorv32.py` reads a pre-compiled RISC-V `.bin` file and writes it to the PSRAM starting at `0xA0000000`.
3.  **Start RISC-V**: The M3 writes to the control register (Slot 1) to release the NEORV32 from reset.
4.  **RISC-V Execution**: The NEORV32 starts executing from PSRAM.
5.  **Mailbox Communication**: The M3 and NEORV32 communicate by writing values to specific memory locations or the APB mailbox.

## 4. Usage

```python
import machine
import time

# 1. Write RISC-V program to PSRAM
# (Assuming 'riscv_prog.bin' is on the filesystem)
with open('riscv_prog.bin', 'rb') as f:
    prog = f.read()
    # Write to PSRAM base address
    machine.mem32[0xA0000000] = prog

# 2. Start the NEORV32 core
# Slot 1 Register 0: Bit 0 = Reset (1: Reset, 0: Run)
machine.mem32[0x40002400] = 0

# 3. Read mailbox
while True:
    val = machine.mem32[0x40002404]
    print("NEORV32 Mailbox: 0x{:08X}".format(val))
    time.sleep(1)
```

## 5. Deployment Notes

- Ensure your FPGA bitstream includes the NEORV32 core and the appropriate bus bridge.
- The RISC-V code must be compiled for the RV32IMAC (or similar) architecture supported by your NEORV32 configuration.
- Shared memory access must be managed carefully to avoid bus contention.
