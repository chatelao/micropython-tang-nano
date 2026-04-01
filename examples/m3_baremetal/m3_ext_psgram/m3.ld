/* m3.ld */
ENTRY(Reset_Handler)

MEMORY
{
    ROM       (rx)  : ORIGIN = 0x00000000, LENGTH = 32K
    SRAM      (rwx) : ORIGIN = 0x20000000, LENGTH = 22K
    PSRAM     (rwx) : ORIGIN = 0xA0000000, LENGTH = 8M
}

STACK_SIZE = 2K;

SECTIONS
{
    /* .isr_vector always at 0x00000000 */
    .isr_vector :
    {
        . = ALIGN(256);
        KEEP(*(.isr_vector))
        *(.boot*)
    } > ROM

    /* .text section */
    .text :
    {
        . = ALIGN(4);
        *(.text*)
        *(.rodata*)
        _etext = .;
    } > ROM

    /* Secure Gateway stubs */
    .gnu.sgstubs : ALIGN(1024)
    {
        *(.gnu.sgstubs*)
    } > ROM

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

    /* Extended PSRAM section */
    .psram (NOLOAD) :
    {
        . = ALIGN(4);
        *(.psram*)
    } > PSRAM

    .stack (NOLOAD) :
    {
        . = ALIGN(8);
        . = . + STACK_SIZE;
        _estack = .;
    } > SRAM
}
