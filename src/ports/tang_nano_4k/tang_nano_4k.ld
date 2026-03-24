/* tang_nano_4k.ld */
ENTRY(Reset_Handler)

MEMORY
{
    FLASH (rx) : ORIGIN = FLASH_ORIGIN, LENGTH = FLASH_LENGTH
    SRAM (rwx) : ORIGIN = 0x20000000, LENGTH = 22K
}

STACK_SIZE = 2K;

SECTIONS
{
    .text :
    {
        . = ALIGN(256);
        KEEP(*(.isr_vector))
        *(.text*)
        *(.rodata*)
        *(.init)
        *(.fini)

        . = ALIGN(4);
        *(.ARM.exidx*)
        _etext = .;
    } > FLASH

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
}
