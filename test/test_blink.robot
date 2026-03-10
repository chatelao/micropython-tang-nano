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
${TEST_SCRIPT}  ${CURDIR}/../blink.py

*** Test Cases ***
Should Blink Pin 0
    Execute Command         $repl = @${REPL}
    Execute Command         $bin = @${BIN}
    Execute Command         include @${RESC}
    Execute Command         sysbus.cpu VectorTableOffset 0x60000000
    Execute Command         sysbus.cpu SP `sysbus ReadDoubleWord 0x60000000`
    Execute Command         sysbus.cpu PC `sysbus ReadDoubleWord 0x60000004`
    Create Terminal Tester  ${UART}
    Start Emulation

    Wait For Line On Uart   MicroPython started on Tang Nano 4K
    Wait For Line On Uart   Tang Nano 4K with GW1NSR-LV4C

    Sleep                   1s

    # Enter Paste Mode (Ctrl-E)
    Execute Command         ${UART} WriteChar 5
    Wait For Line On Uart   paste mode

    # Send the test script
    ${script}=              Get File  ${TEST_SCRIPT}
    Write Line To Uart      ${script}

    # Execute Paste Mode (Ctrl-D)
    Execute Command         ${UART} WriteChar 4

    Wait For Line On Uart   Starting blink test...    timeout=15

    FOR    ${INDEX}    IN RANGE    5
        Wait For Line On Uart   LED ON    timeout=10
        Wait For Line On Uart   LED OFF    timeout=10
    END

    Wait For Line On Uart   Blink test complete.    timeout=10
