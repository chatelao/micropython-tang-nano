*** Settings ***
Suite Setup     Setup
Suite Teardown  Teardown
Test Setup      Reset Emulation
Resource        ${RENODEKEYWORDS}
Library         OperatingSystem
Resource        ${CURDIR}/../common.resource

*** Variables ***
${RESC_REL}         ${CURDIR}/../tang_nano_4k.resc
${REPL_REL}         ${CURDIR}/../tang_nano_4k.repl
${BIN_REL}          ${CURDIR}/../../src/ports/tang_nano_4k/build/firmware.elf
${UART}             sysbus.uart0
${EXAMPLE}          ${CURDIR}/../../examples/tt_echo/tt_echo.py

*** Test Cases ***
Verify Tiny Tapeout Echo Example
    [Documentation]    Verifies that the tt_echo.py example works by sending it via Paste Mode.
    ${RESC}=                Normalize Path  ${RESC_REL}
    ${REPL}=                Normalize Path  ${REPL_REL}
    ${BIN}=                 Normalize Path  ${BIN_REL}
    Setup MicroPython       ${RESC}    ${REPL}    ${BIN}    ${UART}
    Start Emulation

    Wait For Line On Uart   MicroPython started on Tang Nano 4K
    Wait For Line On Uart   Tang Nano 4K with GW1NSR-LV4C

    # Wait for REPL to be ready
    Sleep                   2s

    # Enter Paste Mode (Ctrl-E)
    Write Char On Uart      \x05
    Wait For Text On Uart   paste mode; Ctrl-C to cancel, Ctrl-D to finish
    Wait For Text On Uart   ===

    # Send the entire script
    ${script}=    Get File    ${EXAMPLE}
    Write Line To Uart      ${script}

    # Finish Paste Mode and execute (Ctrl-D)
    Write Char On Uart      \x04

    # Verify execution output
    Wait For Line On Uart    Tiny Tapeout Echo Test
    FOR    ${i}    IN RANGE    5
        Wait For Line On Uart    MATCH
    END
    Wait For Line On Uart    UIO value read from FPGA
    Wait For Line On Uart    Test Complete
