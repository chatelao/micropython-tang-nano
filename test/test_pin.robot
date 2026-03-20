*** Settings ***
Suite Setup     Setup
Suite Teardown  Teardown
Test Setup      Reset Emulation
Resource        ${RENODEKEYWORDS}

*** Variables ***
${RESC}         ${CURDIR}/tang_nano_4k.resc
${REPL}         ${CURDIR}/tang_nano_4k.repl
${BIN}          ${CURDIR}/../src/ports/tang_nano_4k/build/firmware.elf
${UART}         sysbus.uart0
${TEST_SCRIPT}  ${CURDIR}/test_pin.py

*** Test Cases ***
Verify GPIO Pin Functionality
    Execute Command         $repl = @${REPL}
    Execute Command         $bin = @${BIN}
    Execute Command         include @${RESC}
    Execute Command         sysbus.cpu VectorTableOffset 0x60000000
    Execute Command         sysbus.cpu SP `sysbus ReadDoubleWord 0x60000000`
    Execute Command         sysbus.cpu PC `sysbus ReadDoubleWord 0x60000004`
    Create Terminal Tester  ${UART}
    Start Emulation

    Wait For Line On Uart   MicroPython started on Tang Nano 4K

    # Send the test script line by line and wait for it to be echoed
    ${script}=              Get File  ${TEST_SCRIPT}
    ${lines}=               Evaluate  $script.splitlines()
    FOR    ${line}    IN    @{lines}
        Write Line To Uart  ${line}
        Wait For Line On Uart  ${line}
    END

    Wait For Line On Uart   Toggling Pin 0...
    FOR    ${INDEX}    IN RANGE    10
        Wait For Line On Uart   Pin 0 is ON
        Wait For Line On Uart   Pin 0 is OFF
    END

    Wait For Line On Uart   Pin 1 value: 0
