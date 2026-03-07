*** Settings ***
Suite Setup                   Setup
Suite Teardown                Teardown
Test Setup                    Reset Emulation
Resource                      ${RENODEKEYWORDS}

*** Variables ***
${UART}                       sysbus.uart0
${REPL}                       ${CURDIR}/tang_nano_4k.repl
${BIN}                        ${CURDIR}/../src/ports/tang_nano_4k/build/firmware.elf

*** Test Cases ***
Should Boot To MicroPython REPL
    Execute Command           mach create
    Execute Command           machine LoadPlatformDescription @${REPL}
    Execute Command           sysbus LoadELF @${BIN}

    # Set VTOR to the start of FLASH
    Execute Command           sysbus.cpu SetVectorTableOffset 0x60000000

    # Set PC to Reset_Handler
    Execute Command           sysbus.cpu PC `sysbus GetSymbolAddress "Reset_Handler"`

    # Set SP to the top of stack
    Execute Command           sysbus.cpu SP `sysbus ReadDoubleWord 0x60000000`

    Create Terminal Tester    ${UART}    timeout=10

    Start Emulation

    # Check for the MicroPython banner and REPL prompt
    Wait For Line On Uart     MicroPython started on Tang Nano 4K
    Wait For Line On Uart     >>>
