# Audit Report: MicroPython for Tang Nano 4K (GW1NSR-LV4C)

## 1. Executive Summary

This audit evaluates the current state of the MicroPython port for the Sipeed Tang Nano 4K, which features the Gowin GW1NSR-LV4C SoC (ARM Cortex-M3 + FPGA fabric).

The port is **feature-complete** according to its established roadmap, providing robust hardware abstraction for all primary SoC peripherals. It is characterized by extreme resource optimization to fit within the 128KB Code Flash and 22KB SRAM limits of the target device. Stability is high, with comprehensive automated testing in the Renode simulation environment.

## 2. Feature Matrix

| Feature | Category | Status | Implementation Detail |
| :--- | :--- | :--- | :--- |
| **Core REPL** | System | Complete | UART0 (115200 8N1) |
| **GPIO (Pin)** | Peripheral | Complete | 16 pins, IRQ support, Input/Output/Open-Drain (Soft) |
| **Timer** | Peripheral | Complete | 2x CMSDK Timers, periodic/one-shot |
| **PWM** | Peripheral | Complete | Hardware-backed, software-triggered |
| **ADC** | Peripheral | Complete | 12-bit Analog-to-Digital conversion |
| **I2C** | Peripheral | Complete | Hardware Master and Software (Bit-bang) |
| **SPI** | Peripheral | Complete | Hardware Master and Software (Bit-bang) |
| **RTC** | Peripheral | Complete | Real-Time Clock with `datetime` support |
| **WDT** | Peripheral | Complete | Hardware Watchdog with system reset |
| **Flash / VFS** | Storage | Complete | LittleFS on External SPI Flash (3MB user space) |
| **Power Mgmt** | System | Complete | `lightsleep`, `deepsleep`, `reset`, `wfi` |
| **FPGA Bridge** | Specialized | Complete | 16-bit dedicated M3-to-FPGA GPIO bridge |
| **DMA** | Specialized | Complete | DMA support for FPGA-M3 data transfers |

## 3. Architecture and Optimization Review

### 3.1 Memory Layout
The port utilizes a custom linker script (`tang_nano_4k.ld`) to maximize available resources:
*   **Flash**: 128KB (Hardware) / 4MB (Simulation). Firmware currently occupies ~106KB.
*   **SRAM**: 22KB total.
    *   **Stack**: 2KB (placed at top of SRAM).
    *   **Heap**: ~20KB (dynamic allocation for MicroPython objects).

### 3.2 Code Optimization
To fit the MicroPython runtime into 128KB:
*   `MICROPY_CONFIG_ROM_LEVEL_MINIMUM` is enabled.
*   Floating-point (`MICROPY_PY_BUILTINS_FLOAT`) and Math module are disabled.
*   LTO-like optimizations: `-ffunction-sections`, `-fdata-sections`, and `--gc-sections`.
*   Architecture filtering in `Makefile` to remove irrelevant core objects (e.g., x86/MIPS emitters).

### 3.3 Hardware Abstraction
The port follows standard MicroPython conventions, using `modmachine.c` as the entry point for the `machine` module and implementing peripheral-specific logic in dedicated C files (e.g., `pin.c`, `spi.c`). It leverages `shared/timeutils` for RTC operations and `extmod/vfs_lfs` for filesystem support.

## 4. Testing and Compliance Analysis

### 4.1 Functional Testing
The project employs **Renode** for system-level simulation.
*   **Robot Framework**: `test/tang_nano_4k.robot` provides automated verification for all peripherals.
*   **Stability**: 100% pass rate for functional tests in the current environment.

### 4.2 MicroPython Compliance
Compliance testing is tracked in `COMPLIANCE_TESTS.md`.
*   **Total Tests**: 237 performed.
*   **Passed**: 224 (94.5%).
*   **Failed**: 13.
*   **Analysis of Failures**: Most failures relate to advanced Python features (`super()` with multiple inheritance, assignment expressions) that were likely omitted by the minimal ROM level or require more SRAM than currently available.
*   **Raw REPL**: Some instability was noted during high-speed compliance runs, resulting in "raw REPL failed" errors.

## 5. Recommendations

1.  **Heap Management**: With only ~20KB of heap, memory fragmentation is a risk for long-running scripts. Users should be encouraged to use `gc.collect()` proactively.
2.  **Raw REPL Stability**: Investigate the timing of the raw REPL handshake in `main.c` and `uart.c` to improve the reliability of automated test runners.
3.  **FPGA Integration**: Provide standardized Verilog/VHDL templates for the FPGA side of the `FPGABridge` and `FPGADMA` to lower the barrier for hardware acceleration.
4.  **Math Module**: If flash space permits after further optimization, consider a "Math" variant that enables basic integer-based math functions or a limited float implementation.

## 6. Conclusion
The Tang Nano 4K MicroPython port is a high-quality, resource-efficient implementation that successfully bridges the gap between MicroPython's ease of use and the unique FPGA-SoC architecture of the GW1NSR-4C. It is ready for production use in embedded control and hardware prototyping applications.
