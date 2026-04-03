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

## Flash Paging (Bank Switching) & Trampolines

For applications requiring more than the default 64KB XIP window, a paging (bank-switching) approach using the AHB expansion bus can be implemented. This involves a hardware bank register in the FPGA fabric and software "trampolines" to manage transitions between flash pages.

### Solid C-Code Trampoline (Wrapper)

The trampoline **must** be executed from internal SRAM to avoid instruction fetch conflicts (I-Bus lockup) while the Flash controller is switching banks. This implementation preserves interrupt state and handles function arguments/return values.

```c
#include <stdint.h>

/* Physical address of the Custom AHB Bank Register in your FPGA fabric */
#define HW_BANK_REG ((volatile uint32_t*)0x40000000)

/* Ensure the trampoline is placed in SRAM (mapped via .data or .ramfunc) */
__attribute__((section(".data"), noinline))
uint32_t __wrap_paged_function(uint32_t arg1, uint32_t arg2) {
    extern uint32_t __real_paged_function(uint32_t, uint32_t);

    /* 1. Save and disable interrupts to prevent HardFaults during transition */
    uint32_t pri = __get_PRIMASK();
    __disable_irq();

    /* 2. Save current bank and switch to the target page (e.g., Page 2) */
    uint32_t old_bank = *HW_BANK_REG;
    *HW_BANK_REG = 2;

    /* 3. Mandatory synchronization barriers for memory and pipeline */
    __asm volatile("dsb" : : : "memory");
    __asm volatile("isb" : : : "memory");

    /* 4. Execute the actual function in the paged flash window */
    uint32_t result = __real_paged_function(arg1, arg2);

    /* 5. Restore original bank state */
    *HW_BANK_REG = old_bank;

    /* 6. Re-synchronize hardware after restoration */
    __asm volatile("dsb" : : : "memory");
    __asm volatile("isb" : : : "memory");

    /* 7. Restore interrupt state */
    __set_PRIMASK(pri);

    return result;
}

/* Helper macros for ARM CMSDK/HAL style access if not using <cmsis_gcc.h> */
static inline uint32_t __get_PRIMASK(void) {
    uint32_t result;
    __asm volatile ("mrs %0, primask" : "=r" (result) :: "memory");
    return result;
}
static inline void __set_PRIMASK(uint32_t pri) {
    __asm volatile ("msr primask, %0" : : "r" (pri) : "memory");
}
static inline void __disable_irq(void) {
    __asm volatile ("cpsid i" : : : "memory");
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
