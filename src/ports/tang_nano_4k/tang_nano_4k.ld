/* tang_nano_4k.ld */
ENTRY(Reset_Handler)

MEMORY
{
    INT_FLASH (rx) : ORIGIN = INT_FLASH_ORIGIN, LENGTH = INT_FLASH_LENGTH
    EXT_FLASH (rx) : ORIGIN = EXT_FLASH_ORIGIN, LENGTH = EXT_FLASH_LENGTH
    SRAM (rwx)      : ORIGIN = 0x20000000, LENGTH = 22K
}

STACK_SIZE = 2K;

SECTIONS
{
    .int_text :
    {
        . = ALIGN(256);
        KEEP(*(.isr_vector))
        *(.text.Reset_Handler)
        /* Place main and startup code in internal flash */
        *main.o(.text*)
        . = ALIGN(4);
    } > INT_FLASH

    .text :
    {
        *(.text*)
        *(.rodata*)
        *(.init)
        *(.fini)

        . = ALIGN(4);
        *(.ARM.exidx*)
        _etext = .;
    } > MAIN_FLASH

    .data : AT (LOADADDR(.text) + SIZEOF(.text))
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
}
