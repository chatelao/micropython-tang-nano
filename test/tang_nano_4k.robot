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

    # Ensure we start from the reset handler
    Execute Command           cpu PC `sysbus GetSymbolAddress "Reset_Handler"`

    Create Terminal Tester    ${UART}

    Start Emulation

    # Check for the MicroPython banner and REPL prompt
    Wait For Line On Uart     MicroPython started on Tang Nano 4K
    Wait For Line On Uart     >>>
