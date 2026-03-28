# MicroPython Feature Support - Tang Nano 4K (Cortex-M3)

This document lists the MicroPython features and modules supported by the ARM Cortex-M3 "Hard Core" on the Gowin GW1NSR-4C SoC. Features are categorized based on whether they rely on dedicated hardware blocks ("Hard") or are implemented entirely in the MicroPython software layer ("Soft").

## Supported Features Matrix

| Feature | Category | Description |
| :--- | :--- | :--- |
| **UART REPL** | Hard | Interactive Python prompt via UART0 (typically Pins 18/19). |
| **GPIO (machine.Pin)** | Hard | Native digital Input, Output, and Open-Drain control. |
| **Hardware Interrupts**| Hard | Edge-triggered interrupts on GPIO pins. |
| **Timer (machine.Timer)**| Hard | Precise periodic and one-shot timing via CMSDK hardware timers. |
| **PWM (machine.PWM)** | Hard | Pulse Width Modulation implemented via hardware timers. |
| **ADC (machine.ADC)** | Hard | 12-bit Analog-to-Digital conversion for sensor interfacing. |
| **I2C (machine.I2C)** | Hard | Hardware-backed I2C Master controller. |
| **SoftI2C** | Soft | Bit-banged I2C protocol support on any GPIO pair. |
| **SPI (machine.SPI)** | Hard | Hardware-backed SPI Master controller. |
| **SoftSPI** | Soft | Bit-banged SPI protocol support on any GPIO trio. |
| **RTC (machine.RTC)** | Hard | Real-Time Clock for calendar and alarm functionality. |
| **WDT (machine.WDT)** | Hard | Hardware Watchdog Timer to prevent system lockups. |
| **VFS (LittleFS2)** | Soft | Virtual File System support using LittleFS2 on external SPI Flash. |
| **Power Management** | Hard | System `lightsleep`, `deepsleep`, and `reset` functionality. |
| **FPGA Bridge** | Hard | Dedicated 16-bit bi-directional communication bridge to FPGA fabric. |
| **FPGA DMA** | Hard | High-speed Direct Memory Access between M3 and FPGA. |
| **Floating Point** | Soft | Software-emulated single-precision floating point arithmetic. |
| **Big Integers** | Soft | Arbitrary-precision integer support via `MPZ` library. |
| **Collections** | Soft | Support for `namedtuple` and basic `deque`. |
| **Struct Module** | Soft | Packing and unpacking of binary data. |
| **GC (Garbage Coll.)** | Soft | Automatic heap management and object lifecycle tracking. |

## Feature Notes

- **Hard Features**: These utilize the physical peripheral blocks integrated into the GW1NSR-4C's Cortex-M3 subsystem. They offer higher performance and lower CPU overhead.
- **Soft Features**: These are implemented via MicroPython's core software or "bit-banging" techniques. While flexible (e.g., SoftI2C can use any pins), they consume more CPU cycles than their hardware counterparts.
- **FPGA Integration**: Features like the `FPGABridge` and `FPGADMA` are unique to this SoC, allowing MicroPython to interact directly with custom logic implemented in the FPGA fabric.

## Potential / Optional Features (Currently Disabled)

These features are supported by the MicroPython core but are currently disabled to fit the firmware within the 128KB Code Flash limit.

> **Note**: The 128KB limit refers to the architectural address space for instruction memory (Code Flash) on the GW1NSR-4C. While the core can address 128KB, the physical internal flash on the chip is limited to 32KB, requiring a [Split Flash architecture](README.md#split-flash-installation) for full builds.

They can be enabled by modifying `mpconfigport.h` or the `Makefile` if additional space is reclaimed.

| Feature | Compilation Flag | Description |
| :--- | :--- | :--- |
| **Math Module** | `MICROPY_PY_MATH=1` | Standard math functions (`sin`, `cos`, `sqrt`, etc.). |
| **Complex Numbers** | `MICROPY_PY_BUILTINS_COMPLEX=1` | Support for the `complex` type and associated arithmetic. |
| **Built-in Help** | `MICROPY_PY_BUILTINS_HELP=1` | Enables the interactive `help()` system in the REPL. |
| **Asyncio Support** | `MICROPY_PY_ASYNCIO=1` | Lightweight cooperative multitasking via `asyncio`. |
| **JSON Module** | `MICROPY_PY_JSON=1` | Parsing and serializing JSON data (`ujson`). |
| **Regex Module** | `MICROPY_PY_RE=1` | Regular expression support (`ure`). |
| **Heapq Module** | `MICROPY_PY_HEAPQ=1` | Min-priority queue algorithm implementation. |
| **Hashlib Module** | `MICROPY_PY_HASHLIB=1` | Common hashing algorithms (SHA256, etc.). |
| **Binascii Module** | `MICROPY_PY_BINASCII=1` | Conversions between binary and various ASCII-encodings. |
| **Random Module** | `MICROPY_PY_RANDOM=1` | Pseudo-random number generation. |
| **Select Module** | `MICROPY_PY_SELECT=1` | Wait for events on a set of streams. |
| **Framebuf Module** | `MICROPY_PY_FRAMEBUF=1` | Simple frame buffer implementation for displays. |
| **Uctypes Module** | `MICROPY_PY_UCTYPES=1` | Access binary data structures in a structured way. |
| **Deflate Module** | `MICROPY_PY_DEFLATE=1` | DEFLATE compression/decompression support. |
| **String Methods** | `MICROPY_PY_BUILTINS_STR_COUNT=1` | Adds `count`, `partition`, `splitlines` to the `str` class. |
| **Advanced Built-ins**| `MICROPY_PY_BUILTINS_ENUMERATE=1` | Adds `enumerate`, `filter`, `reversed`, `min`, `max`, and `property`. |
| **Frozen Set** | `MICROPY_PY_BUILTINS_FROZENSET=1` | Support for immutable `frozenset` objects. |
| **Detailed Errors** | `MICROPY_ERROR_REPORTING=3` | Provides verbose exception messages (DETAILED). |
| **Computed Gotos** | `MICROPY_OPT_COMPUTED_GOTO=1` | VM optimization using jump tables (requires GCC). |
| **Source Lines** | `MICROPY_ENABLE_SOURCE_LINE=1` | Includes source line numbers in tracebacks. |
