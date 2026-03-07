/* qemu.ld - for mps2-an385 machine */
MEMORY
{
    FLASH (rx) : ORIGIN = 0x00000000, LENGTH = 4M
    SRAM (rwx) : ORIGIN = 0x21000000, LENGTH = 4M
}

STACK_SIZE = 8K;

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
        _sbss = .;
        *(.bss*)
        *(COMMON)
        _ebss = .;
        _end = .;
        end = .;
    } > SRAM

    .stack :
    {
        . = ALIGN(8);
        . = . + STACK_SIZE;
        _estack = .;
    } > SRAM
}
