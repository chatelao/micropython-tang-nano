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

    # Check if ticks are moving
    Write Line To Uart      import time
    Write Line To Uart      t1 = time.ticks_ms(); time.sleep_ms(100); t2 = time.ticks_ms(); print("TICKS" + "_STATUS:", "OK" if t2 > t1 else "STUCK")
    Wait For Line On Uart   TICKS_STATUS: OK

    Write Line To Uart      from machine import Timer
    Write Line To Uart      print("TMR" + "_IMPORT_OK")
    Wait For Line On Uart   TMR_IMPORT_OK

    Write Line To Uart      t = Timer(-1, period=1000, mode=Timer.PERIODIC, callback=lambda t:print("T" + "ICK_EVENT"))
    Write Line To Uart      print("TMR" + "_START_OK")
    Wait For Line On Uart   TMR_START_OK

    # Wait for periodic ticks with 10s timeout
    Wait For Line On Uart   TICK_EVENT    timeout=10
    Wait For Line On Uart   TICK_EVENT    timeout=10
    Wait For Line On Uart   TICK_EVENT    timeout=10

    Write Line To Uart      t.deinit()
    Write Line To Uart      print("TMR" + "_STOP_OK")
    Wait For Line On Uart   TMR_STOP_OK

    Write Line To Uart      t2 = Timer(-1, period=500, mode=Timer.ONE_SHOT, callback=lambda t:print("F" + "IRED_EVENT"))
    Write Line To Uart      print("TMR2" + "_START_OK")
    Wait For Line On Uart   TMR2_START_OK
    Wait For Line On Uart   FIRED_EVENT   timeout=10
