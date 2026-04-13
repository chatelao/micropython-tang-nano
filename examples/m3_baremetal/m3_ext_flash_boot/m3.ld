/* m3.ld */
ENTRY(Reset_Handler)

MEMORY
{
    INT_FLASH (rx)  : ORIGIN = 0x00000000, LENGTH = 32K
    EXT_FLASH (rx)  : ORIGIN = 0x60000000, LENGTH = 8M
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
        *(EXCLUDE_FILE (*paged_code.o) .text*)
        *(.rodata*)
        . = ALIGN(4);
    } > MAIN_FLASH

    /*
     * Automatic mapping test: place the paged_code object
     * at a high memory address (4MB offset)
     */
    .far_code 0x60400000 :
    {
        . = ALIGN(4);
        *paged_code.o(.text*)
        . = ALIGN(4);
    } > EXT_FLASH

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
