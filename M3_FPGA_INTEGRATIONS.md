# M3-FPGA Integration Guide - Tang Nano 4K (GW1NSR-4C)

This document describes the communication interfaces between the ARM Cortex-M3 "Hard Core" and the FPGA fabric on the Sipeed Tang Nano 4K.

![M3 Subsystem Architecture](https://www.plantuml.com/plantuml/proxy?src=https://raw.githubusercontent.com/chatelao/micropython-tang-nano/main/m3_subsystem.puml)

## 1. Overview

The GW1NSR-4C provides several dedicated paths for the Cortex-M3 to interact with logic implemented in the FPGA:

1.  **GPIO Bridge**: A 16-bit bi-directional bus connected to the M3's GPIO peripheral.
2.  **APB2 Expansion Slots**: 12 register-mapped slots (256 bytes each) on the APB2 bus.
3.  **AHB Expansion**: High-speed 32-bit bus for memory-mapped peripherals (e.g., PSRAM, SPI Flash).
4.  **FPGA Interrupts**: 6 dedicated interrupt lines from the FPGA to the M3 NVIC.

## 2. GPIO Bridge (16-bit)

The GPIO Bridge is the simplest way to pass signals between the M3 and the FPGA. It is mapped to the M3's native GPIO0 peripheral.

| Register | Address | Description |
| :--- | :--- | :--- |
| `DATA` | `0x40010000` | 16-bit data value (Read/Write) |
| `OUTENSET` | `0x40010010` | Set bits as outputs (1 = Output) |
| `OUTENCLR` | `0x40010014` | Clear bits to inputs (1 = Input) |

### RTL Wiring (Verilog)
In your top-level Verilog, the signals are typically mapped as follows:
- `GPIO[15:0]` on the Cortex-M3 IP core connects to your custom logic.

## 3. APB2 Expansion Slots

The APB2 bus is the primary method for register-mapped communication between the M3 and custom FPGA IPs. The SoC provides 12 dedicated "slots," each with a 256-byte address range.

### 3.1 IP Core Configuration (Gowin EDA)
To use the APB2 expansion, you must enable it in the **Gowin_EMPU_M3** IP core configuration:
1.  **IP Generator**: Select `Gowin_EMPU_M3`.
2.  **Configuration Tab**:
    *   **Enable APB Expansion**: Set to `Enable`.
    *   This will expose the `APB_PSEL`, `APB_PENABLE`, `APB_PADDR`, `APB_PWRITE`, `APB_PWDATA`, `APB_PRDATA`, and `APB_PREADY` ports on the M3 IP core.
3.  **Address Decoding**: The M3 uses the `PSEL` signal to indicate which slot is being accessed. You must implement a simple decoder if using multiple slots, or use the provided `PSELx` signals if the IP core version supports individual slot selects.

### 3.2 Slot Mapping
Think of these slots as pre-allocated memory windows. When you implement a peripheral in the FPGA (e.g., a motor controller or a display driver), you can map its internal registers to one of these slots. From MicroPython, you can then interact with your hardware by reading/writing to the corresponding memory address.

| Slot | Base Address | M3 Address Range | Default Usage in Examples |
| :--- | :--- | :--- | :--- |
| Slot 1 | `0x40002400` | `0x40002400 - 0x400024FF` | **Tiny Tapeout (TT) Wrapper** |
| Slot 2 | `0x40002500` | `0x40002500 - 0x400025FF` | **NEORV32 Bridge** |
| Slot 3 | `0x40002600` | `0x40002600 - 0x400026FF` | **SERV Bridge** |
| Slots 4-12 | `0x40002700`+ | `0x40002700 - 0x40002FFF` | Available for custom User IPs |

### MicroPython Example
```python
import machine
# Write to a register in Slot 4
machine.mem32[0x40002700] = 0xAABBCCDD
# Read back from a register in Slot 4
val = machine.mem32[0x40002704]
```

## 4. AHB Expansion (XIP & PSRAM)

The AHB bus is used for high-bandwidth peripherals like PSRAM and External SPI Flash (XIP).

### 4.1 PSRAM Memory Interface (AHB)
To use the 8MB external PSRAM, instantiate the **PSRAM Memory Interface** IP:
1.  **IP Generator**: Select `PSRAM Memory Interface`.
2.  **Configuration**:
    *   **Memory Model**: `W955D8MBYA` (for Tang Nano 4K).
    *   **Memory Clock**: `166 MHz` (Max).
    *   **DQ Width**: `16` (2CH mode is often used for full performance).
    *   **Bus Interface**: `AHB` (required for M3 mapping at 0xA0000000).
3.  **M3 Connection**: Enable **AHB Expansion** in the `Gowin_EMPU_M3` core and connect it to the PSRAM IP at `0x60000000`.

### 4.2 External Flash Interface (XIP)
To access the external flash at `0xA0000000` for MicroPython code execution:
1.  **IP Generator**: Select `SPI Flash Interface`.
2.  **Configuration**:
    *   **Protocol**: `Single SPI` (Standard).
    *   **Bus Interface**: `AHB` (required for XIP).
    *   **Memory Mapped**: Enable `Memory Mapped Mode`.
    *   **Base Address**: Set to `0xA0000000`.
3.  **Pin Constraints**: Map the SPI signals to the following hardware pins:
    *   `CS_N`: Pin 36
    *   `SCLK`: Pin 37
    *   `MOSI`: Pin 38
    *   `MISO`: Pin 39

| Range | Usage | IP Core Required |
| :--- | :--- | :--- |
| `0x60000000` - `0x607FFFFF` | External PSRAM (8MB) | Gowin PSRAM Controller |
| `0xA0000000` - `0xAFFFFFFF` | External SPI Flash (XIP) | Gowin SPI Flash Interface |

## 5. FPGA Interrupts (NVIC)

Custom logic in the FPGA can trigger interrupts on the Cortex-M3.

| IRQ # | Name | Description |
| :--- | :--- | :--- |
| 1 | `USER_INT0` | FPGA User Interrupt 0 |
| 3 | `USER_INT1` | FPGA User Interrupt 1 |
| 4 | `USER_INT2` | FPGA User Interrupt 2 |
| 7 | `USER_INT3` | FPGA User Interrupt 3 |
| 11 | `USER_INT4` | FPGA User Interrupt 4 |
| 14 | `USER_INT5` | FPGA User Interrupt 5 |

For MicroPython usage details, see [FPGA_BRIDGE_USAGE.md](FPGA_BRIDGE_USAGE.md).
