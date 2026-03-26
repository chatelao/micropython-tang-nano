/* tang_nano_4k.ld */
ENTRY(Reset_Handler)

MEMORY
{
    INT_FLASH (rx) : ORIGIN = FLASH_ORIGIN, LENGTH = FLASH_LENGTH
    EXT_FLASH (rx) : ORIGIN = 0x60000000, LENGTH = 256K
    SRAM (rwx) : ORIGIN = 0x20000000, LENGTH = 22K
    PSRAM (rwx) : ORIGIN = 0xA0000000, LENGTH = 8M
}

INCLUDE regions.ld

STACK_SIZE = 2K;

SECTIONS
{
    .isr_vector :
    {
        . = ALIGN(256);
        KEEP(*(.isr_vector))
        *(.boot*)
    } > INT_FLASH

    .text :
    {
        . = ALIGN(4);
        *(.text*)
        *(.rodata*)
        *(.init)
        *(.fini)

        . = ALIGN(4);
        *(.ARM.exidx*)
        _etext = .;
    } > MAIN_FLASH

    .data : AT (_etext)
    {
        . = ALIGN(4);
        _sdata = .;
        *(.data*)
        . = ALIGN(4);
        _edata = .;
    } > SRAM

    .bss :
    {
        . = ALIGN(4);
        _sbss = .;
        *(.bss*)
        *(COMMON)
        . = ALIGN(4);
        _ebss = .;
        end = .;
    } > SRAM

    /* Use all remaining space for heap between .bss and .stack */
    .heap (NOLOAD) :
    {
        . = ALIGN(8);
        _sheap = .;
        . = ORIGIN(SRAM) + LENGTH(SRAM) - STACK_SIZE;
        _eheap = .;
    } > SRAM

    .stack (NOLOAD) :
    {
        . = ALIGN(8);
        _sstack = .;
        . = ORIGIN(SRAM) + LENGTH(SRAM);
        _estack = .;
    } > SRAM

    .psram_heap (NOLOAD) :
    {
        . = ALIGN(8);
        _spsram_heap = .;
        . = ORIGIN(PSRAM) + LENGTH(PSRAM);
        _epsram_heap = .;
    } > PSRAM
}
