# Concept: SPLIT_FLASH for Tang Nano 4K

This document describes the "SPLIT_FLASH" architecture designed to overcome the 32KB internal instruction flash limitation of the Gowin GW1NSR-LV4C SoC when running the MicroPython runtime.

## 1. Motivation
The GW1NSR-LV4C integrated Cortex-M3 has only 32KB of internal flash (ITCM) available for instructions at address `0x00000000`. A standard MicroPython build with core features typically exceeds 100KB, making it impossible to fit entirely within the internal flash.

The "SPLIT_FLASH" approach utilizes a small "stub" in the internal flash to initialize the system and then jumps to the main MicroPython runtime located in external SPI Flash, which is made accessible to the CPU via an AHB-to-SPI bridge IP-core in the FPGA fabric.

## 2. Hardware Architecture
- **Internal Flash (32KB)**: Located at `0x00000000`. Used for:
    - Interrupt Vector Table (IVT)
    - Reset Handler and low-level initialization.
    - SPI AHB Bridge initialization (if required).
    - Critical time-sensitive code (optional).
- **External Flash (2MBit / 256KB used)**: Accessible via the **SPI AHB IP-Core** mapped at `0x60000000`. Used for:
    - Main MicroPython `.text` (code) section.
    - MicroPython `.rodata` (read-only data) section.
- **SRAM (22KB)**: Located at `0x20000000`. Used for:
    - `.data` and `.bss` sections.
    - MicroPython Heap and Stack.

## 3. Memory Mapping (SPLIT_FLASH=1)

| Region | Start Address | Size | Description |
| :--- | :--- | :--- | :--- |
| **INT_FLASH** | 0x00000000 | 32 KB | Bootloader, Vectors, Init |
| **EXT_FLASH** | 0x60000000 | 256 KB | MicroPython Runtime (Code/ROData) |
| **SRAM** | 0x20000000 | 22 KB | RAM, Heap, Stack |

## 4. Implementation Details

### 4.1 Linker Script (`tang_nano_4k.ld`)
The linker script is modified to define two separate flash regions.
```ld
MEMORY
{
    INT_FLASH (rx) : ORIGIN = 0x00000000, LENGTH = 32K
    EXT_FLASH (rx) : ORIGIN = 0x60000000, LENGTH = 256K
    SRAM (rwx)      : ORIGIN = 0x20000000, LENGTH = 22K
}
```

### 4.2 Code Distribution
- `.isr_vector` is explicitly placed in `INT_FLASH`.
- `Reset_Handler` and `main.c` (partially) are placed in `INT_FLASH`.
- All other object files (MicroPython core, etc.) are directed to `EXT_FLASH`.

### 4.3 SPI AHB IP-Core
The FPGA fabric must contain an AHB-to-SPI Bridge that maps the external SPI NOR flash to the AHB bus address `0x60000000`. This allows the Cortex-M3 to execute code directly from external flash (XIP - eXecute In Place).

## 5. Performance Considerations
- **Internal Flash**: Fast access, zero wait states.
- **External Flash**: Slower access due to SPI protocol overhead. Execution speed will be reduced. Performance can be improved by using Quad-SPI (QSPI) if supported by the IP-Core and FPGA routing.
