/* m3.ld */
ENTRY(Reset_Handler)

MEMORY
{
    INT_FLASH (rx)  : ORIGIN = 0x00000000, LENGTH = 32K
    EXT_FLASH (rx)  : ORIGIN = 0x60000000, LENGTH = 1M
    SRAM      (rwx) : ORIGIN = 0x20000000, LENGTH = 22K
}

REGION_ALIAS("MAIN_FLASH", EXT_FLASH);

STACK_SIZE = 2K;

SECTIONS
{
    /* .isr_vector always in internal flash at 0x00000000 */
    .isr_vector :
    {
        . = ALIGN(256);
        KEEP(*(.isr_vector))
        *(.boot*)
    } > INT_FLASH

    /* .text can be in either internal or external flash */
    .text :
    {
        . = ALIGN(4);
        *(.text.main)
        *(.text.delay)
        *(.text.uart_print)
        *(.text*)
        *(.rodata*)
        . = ALIGN(4);
    } > MAIN_FLASH

    /*
     * Definition of overlapping XIP pages (Banks 1 and 2).
     * VMA is 0x60008000 for both, but LMA is at 64KB boundaries in Flash.
     */
    .page_1 0x60008000 : AT(0x60018000)
    {
        *(.page_1_code)
    }

    .page_2 0x60008000 : AT(0x60028000)
    {
        *(.page_2_code)
    }

    .ARM.exidx :
    {
        *(.ARM.exidx*)
        _etext = .;
    } > MAIN_FLASH

    .data : AT (_etext)
    {
        . = ALIGN(4);
        _sdata = .;
        *(.data*)
        *(.ramfunc*)
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

    .stack (NOLOAD) :
    {
        . = ALIGN(8);
        . = . + STACK_SIZE;
        _estack = .;
    } > SRAM
}
