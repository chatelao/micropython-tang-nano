# Proposal: M3-to-FPGA Bridge Integration - Tang Nano 4K

This document proposes three variants for integrating communication between the ARM Cortex-M3 (Hard Core) and the FPGA fabric on the Gowin GW1NSR-4C.

## Variant 1: Register-Mapped Bridge (Control-Oriented)

This variant utilizes the built-in 16-bit GPIO AHB bridge and the 12 available APB2 peripheral slots. It is best suited for low-latency control signals, status flags, and simple peripheral management.

### Architecture
- **GPIO Bridge (0x40010000)**: A 16-bit wide AHB peripheral where each bit is routed directly to the FPGA fabric.
- **APB2 Slots (0x40002400 - 0x40002F00)**: 12 slots of 256 bytes each, mapped to the APB2 bus.

### MicroPython API Proposal
```python
import machine

# Using the 16-bit GPIO bridge
bridge = machine.FPGABridge()
bridge.write(0xABCD)
val = bridge.read()

# Using APB2 custom registers (Slot 1 at 0x40002400)
reg = machine.FPGARegister(slot=1)
reg.write(0, 0x12345678) # Write to offset 0
```

---

## Variant 2: Shared Memory Buffer (Data-Oriented)

This variant leverages the Dual-Port nature of the Block SRAM (BSRAM). In the GW1NSR-4C, BSRAMs have two independent ports (ADA/DIA/CLKA and ADB/DIB/CLKB).

### Architecture
- **M3 Side (Port A)**: Accessed as standard internal SRAM (mapped at 0x20000000).
- **FPGA Side (Port B)**: The FPGA logic is connected to Port B signals (ADB, DIB, etc.), allowing asynchronous access to the same memory cells.
- **Synchronization**: Uses `USER_INTn` IRQs to signal data readiness between the M3 and FPGA.

### MicroPython API Proposal
```python
import machine

# Access a specific region of SRAM shared with FPGA
shared_mem = machine.SharedRAM(address=0x20004000, size=2048)
shared_mem.write_buf(b"Data for FPGA")

# Signal FPGA via a USER_INT or GPIO bit
bridge.set_bit(0)
```

---

## Variant 3: High-Speed AHB Expansion (Performance-Oriented)

This variant uses the 128-bit wide AHB expansion ports (INTEXP0 and TARGEXP0) and optionally the Cortex-M3 DMA capabilities for massive data transfers.

### Architecture
- **INTEXP0 (Master)**: M3 initiates 128-bit wide bursts to FPGA-side memory or logic.
- **TARGEXP0 (Slave)**: FPGA initiates bursts into M3's internal SRAM.
- **DMA**: Uses a DMA controller in the FPGA fabric (or M3's internal one if available via TARGEXP) to offload the CPU during large transfers.

### MicroPython API Proposal
```python
import machine

# High-speed DMA transfer to FPGA space (mapped via AHB2 Master at 0xA0000000)
dma = machine.FPGADMA()
dma.transfer(src=my_buffer, dest=0xA0000000, size=16384)
```

---

## Comparison Summary

| Feature | Variant 1 (Register) | Variant 2 (Shared RAM) | Variant 3 (AHB/DMA) |
| :--- | :--- | :--- | :--- |
| **Throughput** | Low (32-bit APB) | Medium (32-bit AHB) | High (128-bit AHB) |
| **Complexity** | Simple | Moderate | High |
| **Best Use Case** | LEDs, Switches, Reset | Framebuffers, FFT data | Video processing, AI |
| **Latency** | Lowest | Moderate | Higher (Setup overhead) |
