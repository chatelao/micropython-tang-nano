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
${TEST_SCRIPT}  ${CURDIR}/test_timer.py

*** Test Cases ***
Should Run Timer Test
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

    # Read the test script and write it to the REPL line by line
    ${script}=              Get File  ${TEST_SCRIPT}
    ${lines}=               Evaluate  $script.splitlines()
    FOR    ${line}    IN    @{lines}
        Write Line To Uart  ${line}
    END

    # Exit paste mode
    Execute Command         ${UART} WriteChar 4

    Wait For Line On Uart   Testing machine.Timer...
    Wait For Line On Uart   Timer started. Waiting 3500 ms...

    # We expect 3 ticks in 3500 ms (at 1s, 2s, 3s)
    # Using a loop with a small timeout to handle potential synchronization variations
    FOR    ${INDEX}    IN RANGE    3
        Wait For Line On Uart   Timer periodic tick    timeout=5
    END

    Wait For Line On Uart   Deinitializing timer...
    Wait For Line On Uart   Testing one-shot timer (2000 ms)...

    Wait For Line On Uart   One-shot timer fired!
    Wait For Line On Uart   Test complete.
