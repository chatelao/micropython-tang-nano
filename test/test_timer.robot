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

    # Send the test script in paste mode (Ctrl-E / Ctrl-D)
    Execute Command         ${UART} WriteChar 5
    ${script}=              Get File  ${TEST_SCRIPT}
    ${lines}=               Evaluate  $script.splitlines()
    FOR    ${line}    IN    @{lines}
        Write Line To Uart  ${line}
        # Short sleep to prevent character loss in Renode UART RX
        Sleep               50ms
    END
    Execute Command         ${UART} WriteChar 4

    # Wait for the script to finish loading and execute
    Wait For Line On Uart   SCRIPT_LOADED    timeout=10

    Wait For Line On Uart   Testing machine.Timer...
    Wait For Line On Uart   Timer started. Waiting 3500ms...

    # We expect 3 ticks in 3.5 seconds (at 1s, 2s, 3s)
    Wait For Line On Uart   Timer periodic tick
    Wait For Line On Uart   Timer periodic tick
    Wait For Line On Uart   Timer periodic tick

    Wait For Line On Uart   Deinitializing timer...
    Wait For Line On Uart   Testing one-shot timer (2000ms)...

    Wait For Line On Uart   One-shot timer fired!
    Wait For Line On Uart   Slot reuse test passed.
    Wait For Line On Uart   Test complete.
