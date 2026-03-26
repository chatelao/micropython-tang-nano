# RAM Usage Plan - Tang Nano 4K (GW1NSR-4C)

This document defines the formal usage plan for the various memory regions available on the Tang Nano 4K when running MicroPython.

## 1. Internal SRAM (22 KB)

- **Region**: `0x20000000 - 0x200057FF`
- **Role**: Primary Heap, Stack, and Static Data.
- **MicroPython Usage**:
    - **Stack**: 2 KB (at the top of SRAM: `0x20005800 - 0x20005FFF`).
    - **Data/BSS**: Statically allocated data.
    - **Primary Heap**: Initialized via `gc_init()`. This is the most efficient memory for object allocation.

## 2. External PSRAM (8 MB)

- **Region**:
    - **Hardware**: `0xA0000000 - 0xA07FFFFF`
    - **Simulation**: `0x10000000 - 0x107FFFFF`
- **Role**: Extended Heap.
- **MicroPython Usage**:
    - **Extended Heap**: Initialized via `gc_add()`.
    - Provides ~8 MB of additional space for large Python objects, framebuffers, and complex data structures.
    - Note: Access to PSRAM is slower than internal SRAM due to bus latency and FPGA-to-PSRAM timing.

## 3. Fabric RAM (FSRAM)

- **Region**: FPGA-defined (usually via APB2 or AHB expansion).
- **Role**: Specialized Communication and Buffering.
- **MicroPython Usage**:
    - Reserved for high-speed M3-to-FPGA data exchange.
    - Not included in the general MicroPython heap to avoid FPGA resource exhaustion.
    - Accessed via `machine.mem32` or specialized bridge drivers.

## 4. Summary Table

| Region | Capacity | Base (HW) | Base (Sim) | Usage |
| :--- | :--- | :--- | :--- | :--- |
| **Internal SRAM** | 22 KB | `0x20000000` | `0x20000000` | Stack, Static Data, Primary Heap |
| **External PSRAM** | 8 MB | `0xA0000000` | `0x10000000` | Extended Heap |
| **Fabric RAM** | ~1-9 KB | FPGA Defined | `0x10010000` | FPGA Communication (Reserved) |

## 5. Implementation Notes

- PSRAM must be enabled in the FPGA bitstream and the controller initialized (if applicable) before `gc_add()` is called.
- In the simulation environment (Renode), the `fpga_ram` peripheral is used to model the PSRAM at `0x10000000`.
