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
        KEEP(*(.isr_vector))
        *(.text*)
        *(.rodata*)
        *(.init)
        *(.fini)
        _etext = .;
    } > FLASH

    .data : AT (_etext)
    {
        _sdata = .;
        *(.data*)
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

    .stack (NOLOAD) :
    {
        . = ALIGN(8);
        _sstack = .;
        . = . + STACK_SIZE;
        _estack = .;
    } > SRAM

    _sheap = _ebss;
    _eheap = _sstack;
}
