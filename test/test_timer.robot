*** Settings ***
Library         OperatingSystem
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

    Write Line To Uart      from machine import Timer
    Write Line To Uart      t = Timer(-1, period=1000, mode=Timer.PERIODIC, callback=lambda t:print("TICK_EVENT"))

    # Wait for periodic ticks with 10s timeout
    # Use TICK_EVENT to avoid matching the command echo
    Wait For Line On Uart   TICK_EVENT    timeout=10
    Wait For Line On Uart   TICK_EVENT    timeout=10
    Wait For Line On Uart   TICK_EVENT    timeout=10

    Write Line To Uart      t.deinit()

    Write Line To Uart      t2 = Timer(-1, period=500, mode=Timer.ONE_SHOT, callback=lambda t:print("FIRED_EVENT"))
    Wait For Line On Uart   FIRED_EVENT   timeout=10
