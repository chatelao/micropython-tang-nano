# M3 External Flash Boot Example

This example demonstrates how to configure the Cortex-M3 on the Tang Nano 4K to boot from external SPI Flash. This uses the XIP (eXecute In Place) feature, mapping the flash memory to the 0x60000000 address range.

## Documentation

### Architecture & Signals

![M3 to External Flash XIP](https://www.plantuml.com/plantuml/proxy?src=https://raw.githubusercontent.com/chatelao/micropython-tang-nano/main/examples/m3_baremetal/m3_ext_flash_boot/docs/flash_xip_signals.puml)

### Technical Reference

The following technical documents are available for reference:

| Document | Description | Location |
| :--- | :--- | :--- |
| Gowin SPI Flash Interface (With External Flash) IP User Guide. | IP guide for AHB-mapped SPI Flash (XIP) controller. | [IPUG1015](docs/IPUG1015-1.1E_Gowin%20SPI%20Flash%20Interface%20(With%20External%20Flash)%20IP%20User%20Guide.pdf) |
| Gowin_EMPU(GW1NS-4C) Software Programming Reference Manual. | Primary reference for M3 register mapping and SoC peripherals. | [IPUG931](../docs/IPUG931-2.1E_Gowin_EMPU(GW1NS-4C)%20Software%20Programming%20Reference%20Manual.pdf) |
| GW1NSR Datasheet. | Hardware datasheet for the GW1NSR-4C SoC. | [DS861E](../docs/GW1NSR_DATASHEET_DS861E.pdf) |
| Gowin_EMPU M3 IP User Guide. | IP guide EMPU M3 core. | [IPUG944E](../docs/IPUG944E.pdf) |

## How to Build

Run `make` in this directory to generate the bitstream and firmware.

## Advanced Integration: AHB-based Bank Switching & Overlays

For applications requiring more than the default 64KB XIP window, a bank-switching approach using the AHB expansion bus can be implemented. This involves a hardware bank register in the FPGA fabric and software "trampolines" to manage transitions between flash pages.

### C-Code Trampoline (Wrapper)

This code must be executed from the internal SRAM of the Cortex-M3 to avoid instruction fetch conflicts during bank switching.

```c
#include <stdint.h>

/* Physical address of the Custom AHB Bank Register in your FPGA fabric */
#define HW_BANK_REG ((volatile uint32_t*)0x40000000)

/* Declaration of the actual target function in XIP Flash */
extern void __real_target_func(void);

/* Ensure the trampoline is placed in SRAM */
__attribute__((section(".sram_text")))
void __wrap_target_func(void) {
    /* 1. Disable interrupts to prevent HardFaults during the transition */
    asm volatile("cpsid i" : : : "memory");

    /* 2. Save current bank state */
    uint32_t old_bank = *HW_BANK_REG;

    /* 3. Switch to the new bank (e.g., Page 1) */
    *HW_BANK_REG = 1;

    /* 4. Mandatory pipeline and bus synchronization */
    __asm__ volatile("dsb\n\tisb" : : : "memory");

    /* 5. Execute the target function in the paged 64KB window */
    __real_target_func();

    /* 6. Restore original bank state */
    *HW_BANK_REG = old_bank;

    /* 7. Re-synchronize hardware */
    __asm__ volatile("dsb\n\tisb" : : : "memory");

    /* 8. Re-enable interrupts */
    __asm__ volatile("cpsie i" : : : "memory");
}
```
*Source: ARMv7-M Architecture Reference Manual, Chapter A3.8.3 (Memory Barriers) and B5.2.3 (CPS Instruction).*

### Compiler / Linker Flags (Makefile)

To use the wrapper, add the `--wrap` flag to your `LDFLAGS`.

```makefile
# Add this to your LDFLAGS in the Makefile
LDFLAGS += -Wl,--wrap=target_func
```
*Source: GNU Binutils / Linker (ld) Manual, Chapter 2.1 "Command Line Options".*

### Linker Script Configuration (LD)

Define the overlapping XIP pages in the `SECTIONS` area of your linker script.

```ld
/* Definition of overlapping XIP pages */
OVERLAY 0x60000000 : NOCROSSREFS
{
    .page_1 { *(.page_1_code) }
    .page_2 { *(.page_2_code) }
    /* Add more pages as needed */
} > EXT_FLASH AT> FLASH_ROM
```
*Note: `FLASH_ROM` must be defined in your `MEMORY` block as the physical storage region in SPI Flash.*
*Source: GNU Binutils / Linker (ld) Manual, Chapter 3.6.8.4 "Overlay Description".*

### Critical Reflection

*   **Build System Integration:** Using `-Wl,--wrap` is specific to GNU `ld`. If your project migrates to a different build system (e.g., CMake), ensure these flags are translated correctly (e.g., `target_link_options`). Manual wrapping of many functions can also lead to code bloat.
*   **Memory Overlaps:** Careless use of `OVERLAY` can lead to LMA/VMA overlap errors if the base address (e.g., `0x60000000`) is already occupied by other `.text` sections. Always verify the memory map to ensure standard libraries and paged code do not collide in Flash.
*   **Hardware Dependencies:** The dummy address `0x40000000` for `HW_BANK_REG` must be explicitly implemented in your RTL design. Accessing an unmapped address on the AHB bus will trigger a `BusFault`. This approach is only valid if the FPGA fabric provides the corresponding AHB-to-Flash-Bank logic.
