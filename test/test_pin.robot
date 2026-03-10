*** Settings ***
Suite Setup     Setup
Suite Teardown  Teardown
Test Setup      Reset Emulation
Resource        ${RENODEKEYWORDS}
Library         OperatingSystem
Library         String

*** Variables ***
${RESC}         ${CURDIR}/tang_nano_4k.resc
${REPL}         ${CURDIR}/tang_nano_4k.repl
${BIN}          ${CURDIR}/../src/ports/tang_nano_4k/build/firmware.elf
${UART}         sysbus.uart0
${TEST_SCRIPT}  ${CURDIR}/../test_pin.py

*** Test Cases ***
Should Run Pin Test
    Execute Command         $repl = @${REPL}
    Execute Command         $bin = @${BIN}
    Execute Command         include @${RESC}
    Execute Command         sysbus.cpu VectorTableOffset 0x60000000
    Execute Command         sysbus.cpu SP `sysbus ReadDoubleWord 0x60000000`
    Execute Command         sysbus.cpu PC `sysbus ReadDoubleWord 0x60000004`
    Create Terminal Tester  ${UART}
    Start Emulation

    Wait For Line On Uart   MicroPython started on Tang Nano 4K

    # Enter paste mode
    Execute Command         ${UART} WriteChar 5

    # Read the test script and write it to the REPL line-by-line
    ${script}=              Get File  ${TEST_SCRIPT}
    @{lines}=               Split String To Lines  ${script}
    FOR  ${line}  IN  @{lines}
        Write Line To Uart      ${line}
    ENDFOR

    # Exit paste mode and execute
    Execute Command         ${UART} WriteChar 4

    Wait For Line On Uart   Toggling Pin 0...
    Wait For Line On Uart   Pin 0 is ON
    Wait For Line On Uart   Pin 0 is OFF
    Wait For Line On Uart   Pin 1 value: 0
