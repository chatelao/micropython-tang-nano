# Gowin SPI Flash Interface (With External Flash) IP Guide

This guide describes the features, register mapping, and operation of the Gowin SPI Flash Interface IP used in the Tang Nano 4K (GW1NSR-4C). This IP acts as a master controller for interacting with external SPI Flash devices.

## 1. Overview

The SPI Flash Interface IP provides a generic command interface for accessing SPI Flash chips. It supports both register-based read/write operations and high-performance memory-mapped read access.

### Features
- **Bus Interfaces**: Supports both AHB and APB bus configurations.
- **SPI Modes**: Supports Normal, Dual, and Quad SPI interfaces.
- **Access Modes**:
    - **Register Mode**: Manual control via command, address, and data registers.
    - **Memory-Mapped Mode**: Read-only access where Flash data is mapped directly into the CPU address space.
- **Configurable Timing**: Adjustable SPI clock (SCLK) frequency and FIFO depths.

---

## 2. Register Map

Registers are accessible via the AHB or APB bus at the following offsets from the IP base address.

| Offset | Register | Description |
| :--- | :--- | :--- |
| `0x10` | `TransFmt` | SPI Transfer Format (Address length, Data length, LSB/MSB) |
| `0x20` | `TransCtrl` | SPI Transfer Control (Enable Cmd/Addr, Transfer Mode, Dual/Quad) |
| `0x24` | `Cmd` | SPI Command Register |
| `0x28` | `Addr` | SPI Address Register |
| `0x2C` | `Data` | SPI Data Register (FIFO Interface) |
| `0x30` | `Ctrl` | SPI Control (Resets for FIFO and SPI core) |
| `0x34` | `Status` | SPI Status (FIFO levels, Active flag) |
| `0x38` | `IntrEn` | SPI Interrupt Enable |
| `0x3C` | `IntrSt` | SPI Interrupt Status |
| `0x40` | `Timing` | SPI Interface Timing (Clock Divider) |
| `0x7C` | `Config` | IP Configuration (Read-only FIFO depths) |

### Key Register Details

#### SPI Transfer Control (`0x20`)
Used to define the structure of the next SPI transaction.
- **CmdEn (Bit 30)**: Enable command segment.
- **AddrEn (Bit 29)**: Enable address segment.
- **TransMode (Bits 27:24)**:
    - `0x1`: Write-only
    - `0x2`: Read-only
    - `0x7`: No data (Cmd/Addr only)
    - `0x9`: Dummy then Read
- **DualQuad (Bits 23:22)**: `0x0`=Single, `0x1`=Dual, `0x2`=Quad.

---

## 3. Flash Command Summary

Common commands for the W25Q64DW (and compatible) SPI Flash:

| Command | Opcode | Description |
| :--- | :--- | :--- |
| Write Enable | `0x06` | Enable writes/erases |
| Read Status 1 | `0x05` | Read Status Register 1 |
| Read Data | `0x03` | Read data at 3-byte address |
| Page Program | `0x02` | Program up to 256 bytes |
| Sector Erase | `0x20` | Erase 4KB sector |
| Block Erase | `0xD8` | Erase 64KB block |
| JEDEC ID | `0x9F` | Read Manufacturer and Device ID |

---

## 4. Operation Flows

### 4.1 Read Data (03H)
1. **Reset RX FIFO**: Set `Ctrl` (0x30) to `0x02`.
2. **Configure Transfer**: Set `TransCtrl` (0x20) with:
    - `CmdEn=1`, `AddrEn=1`, `TransMode=0x2` (Read-only).
    - `RdTranCnt` = (number of bytes - 1).
3. **Set Address**: Write the 24-bit Flash address to `Addr` (0x28).
4. **Start Transaction**: Write `0x03` to `Cmd` (0x24).
5. **Read Data**: Read from `Data` (0x2C) once the status indicates data is available.

### 4.2 Sector Erase (20H)
1. **Write Enable**:
    - Set `TransCtrl` to `0x47000000` (`CmdEn=1`, `TransMode=NoData`).
    - Write `0x06` to `Cmd`.
2. **Execute Erase**:
    - Set `TransCtrl` to `0x67000000` (`CmdEn=1`, `AddrEn=1`, `TransMode=NoData`).
    - Write target address to `Addr`.
    - Write `0x20` to `Cmd`.
3. **Wait for Completion**: Monitor the `SPIActive` bit in `Status` (0x34) or use the `EndInt` interrupt.

### 4.3 Page Program (02H)
1. **Write Enable**: Send `0x06` (as in Sector Erase).
2. **Load Data**: Write data bytes to the `Data` (0x2C) FIFO.
3. **Configure Transfer**:
    - Set `TransCtrl` to `0x61000000` (`CmdEn=1`, `AddrEn=1`, `TransMode=Write-only`).
    - Set `WrTranCnt` to (number of bytes - 1).
4. **Set Address and Start**:
    - Write target address to `Addr`.
    - Write `0x02` to `Cmd`.

---

## 5. Hardware Constraints (Tang Nano 4K)

On the Tang Nano 4K, the external SPI Flash is typically connected to the following pins (via FPGA fabric):
- **CS_N**: Pin 36
- **SCLK**: Pin 37
- **MOSI/IO0**: Pin 38
- **MISO/IO1**: Pin 39
- **WP_N/IO2**: Pin 40
- **HOLD_N/IO3**: Pin 41

*Note: Pin numbers refer to the physical package pins. The M3 core interacts with these through the SPI Flash Interface IP logic instantiated in the FPGA bitstream.*
