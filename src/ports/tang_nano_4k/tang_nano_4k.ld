/* tang_nano_4k.ld */
ENTRY(Reset_Handler)

MEMORY
{
    FLASH (rx) : ORIGIN = 0x00000000, LENGTH = 32K
    SRAM (rwx) : ORIGIN = 0x20000000, LENGTH = 22K
}

STACK_SIZE = 2K;

SECTIONS
{
    .text :
    {
        . = ALIGN(4);
        KEEP(*(.isr_vector))
        *(.text*)
        *(.rodata*)
        *(.init)
        *(.fini)
        . = ALIGN(4);
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
        _sbss = .;
        *(.bss*)
        *(COMMON)
        _ebss = .;
    } > SRAM

    .stack :
    {
        . = ALIGN(8);
        . = . + STACK_SIZE;
        _estack = .;
    } > SRAM
}
