# RAM Usage and Potential Expansion - Tang Nano 4K (GW1NSR-4C)

This document analyzes the current memory usage of the MicroPython port and evaluates the feasibility and benefits of utilizing additional memory regions: **FastRAM** and **External PSRAM**.

## 1. Current Memory Architecture

The GW1NSR-4C integrated Cortex-M3 "Hard Core" has a primary internal SRAM space of **22 KB** (mapped at `0x20000000`). This memory is physically implemented using the SoC's Block SRAM (BSRAM) resources.

### Current Allocation:
- **Stack**: 2 KB (at the top of SRAM: `0x20005000` - `0x200057FF`)
- **Data/BSS**: ~1-2 KB (statically allocated)
- **Heap**: ~18-19 KB (the remaining space for MicroPython objects)

## 2. FastRAM (Tightly Coupled Memory)

**Definition**: In many Cortex-M3 implementations, "FastRAM" refers to Tightly Coupled Memory (ITCM/DTCM) or the zero-wait-state internal SRAM.

### Findings for Tang Nano 4K:
- The internal **22 KB SRAM** at `0x20000000` *is* the "FastRAM". It is connected via the high-speed AHB-Lite bus and provides optimal performance for the CPU.
- **Status**: Already fully utilized. There are no additional hidden "FastRAM" pools within the M3 hard core itself.

## 3. External PSRAM (The High-Capacity Solution)

The Tang Nano 4K board includes an integrated **64 Mbit (8 MB) PSRAM** chip connected to the GW1NSR-4C.

### Potential Benefits:
- **Capacity**: 8 MB is **~360x larger** than the current 22 KB internal SRAM.
- **Accessibility**: The SoC includes a dedicated **PSRAM Memory Interface** reachable via the **AHB2 Master bus** (base `0xA0000000`).

### Current Implementation:
1. **FPGA Bitstream**: The PSRAM controller IP must be instantiated in the FPGA fabric and routed to the physical PSRAM pins.
2. **MicroPython Heap**: The MicroPython heap is already integrated as a split heap in `main.c`, utilizing the 8 MB region for extended object storage.

## 4. Summary and Implementation Status

| Region | Capacity | Performance | Helpfulness | Status |
| :--- | :--- | :--- | :--- | :--- |
| **FastRAM** (Internal) | 22 KB | Highest | Essential | **Implemented** (Stack, Data, Fast Heap) |
| **PSRAM** (External) | 8 MB | Lower | **Highest** | **Implemented** (Large Heap) |

### Conclusion:
- **FastRAM (Internal SRAM)**: Optimized for the stack and core heap.
- **PSRAM**: Successfully integrated as an extended heap, allowing for much larger Python scripts, framebuffers, and complex data structures.
