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
${TEST_SCRIPT}  ${CURDIR}/../test_timer.py

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
    Wait For Text On Uart   >>>

    # Read the test script and write it to the REPL
    ${script}=              Get File  ${TEST_SCRIPT}
    ${lines}=               Evaluate  $script.splitlines()
    FOR  ${line}  IN  @{lines}
        Write Line To Uart  ${line}
        Wait For Text On Uart  >>>
    END

    Wait For Line On Uart   Testing machine.Timer...
    Wait For Line On Uart   Timer started. Waiting 3.5 seconds...

    # We expect 3 ticks in 3.5 seconds (at 1s, 2s, 3s)
    Wait For Line On Uart   Timer periodic tick
    Wait For Line On Uart   Timer periodic tick
    Wait For Line On Uart   Timer periodic tick

    Wait For Line On Uart   Deinitializing timer...
    Wait For Line On Uart   Testing one-shot timer (2 seconds)...

    Wait For Line On Uart   One-shot timer fired!
    Wait For Line On Uart   Test complete.
