# RAM Usage Plan - Tang Nano 4K (GW1NSR-4C)

This document defines the formal usage plan for the various memory regions available on the Tang Nano 4K when running MicroPython.

## 1. Internal SRAM (22 KB)

- **Region**: `0x20000000 - 0x200057FF`
- **Role**: Primary Heap, Stack, and Static Data.
- **MicroPython Usage**:
    - **Stack**: 2 KB (at the top of SRAM: `0x20005000 - 0x200057FF`).
    - **Data/BSS**: Statically allocated data.
    - **Primary Heap**: Initialized via `gc_init()`. This is the most efficient memory for object allocation.

## 2. External PSRAM (8 MB)

- **Region**:
    - **Hardware/Simulation**: `0xA0000000 - 0xA07FFFFF`
- **Role**: Extended Heap.
- **MicroPython Usage**:
    - **Extended Heap**: Initialized via `gc_add()`.
    - Provides ~8 MB of additional space for large Python objects, framebuffers, and complex data structures.
    - Note: Access to PSRAM is slower than internal SRAM due to bus latency and FPGA-to-PSRAM timing.

## 3. Summary Table

| Region | Capacity | Base Address | Usage |
| :--- | :--- | :--- | :--- |
| **Internal SRAM** | 22 KB | `0x20000000` | Stack, Static Data, Primary Heap |
| **External PSRAM** | 8 MB | `0xA0000000` | Extended Heap |

## 4. Implementation Notes

- **PSRAM Configuration**: To utilize the PSRAM in hardware, the **Gowin PSRAM Memory Interface** IP (W955D8MBYA) must be instantiated in the FPGA bitstream. It should be configured for **Memory Mapped Mode** (AHB interface) and mapped to the base address `0xA0000000`.
- In the simulation environment (Renode), the `fpga_ram` peripheral is used to model the PSRAM at `0xA0000000`.
