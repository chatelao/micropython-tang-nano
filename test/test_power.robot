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

*** Test Cases ***
Verify Power Management
    [Documentation]    Verifies that MicroPython can perform idle and lightsleep operations.

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

    # Wait for REPL to be ready
    Sleep                   2s

    Write Line To Uart      import machine; print("MOD_O" + "K")
    Wait For Line On Uart   MOD_OK

    Write Line To Uart      import time; print("TIME_O" + "K")
    Wait For Line On Uart   TIME_OK

    # Test machine.idle()
    Write Line To Uart      machine.idle(); print("ID" + "LE_OK")
    Wait For Line On Uart   IDLE_OK

    # Test machine.lightsleep(100)
    Write Line To Uart      start = time.ticks_ms(); machine.lightsleep(100); end = time.ticks_ms(); print("LS_OK:" + str(time.ticks_diff(end, start)))
    # Regex to match values between 90 and 150 to account for simulation timing
    Wait For Line On Uart    LS_OK:([9][0-9]|[1][0-4][0-9]|150)    timeout=10

    # Test machine.lightsleep(500)
    Write Line To Uart      start = time.ticks_ms(); machine.lightsleep(500); end = time.ticks_ms(); print("LS_OK:" + str(time.ticks_diff(end, start)))
    # Regex to match values between 450 and 650
    Wait For Line On Uart    LS_OK:([4-6][0-9][0-9])    timeout=10
