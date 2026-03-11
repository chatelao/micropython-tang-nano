/* tang_nano_4k.ld */
ENTRY(Reset_Handler)

MEMORY
{
    FLASH (rx) : ORIGIN = FLASH_ORIGIN, LENGTH = FLASH_LENGTH
    SRAM (rwx) : ORIGIN = 0x20000000, LENGTH = 22K
}

STACK_SIZE = 2K;
HEAP_SIZE = 12K;

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

    .heap (NOLOAD) :
    {
        . = ALIGN(4);
        _sheap = .;
        . = . + HEAP_SIZE;
        . = ALIGN(4);
        _eheap = .;
    } > SRAM

    .stack (NOLOAD) :
    {
        . = ALIGN(8);
        *(.stack*)
        . = . + STACK_SIZE;
        _estack = .;
    } > SRAM
}
