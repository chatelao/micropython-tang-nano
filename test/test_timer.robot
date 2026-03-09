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

    Write Line To Uart      import machine
    Write Line To Uart      import time
    Write Line To Uart      print("Testing machine.Timer...")
    Wait For Line On Uart   Testing machine.Timer...

    Write Line To Uart      tim = machine.Timer(0)
    Write Line To Uart      tim.init(period=1000, mode=machine.Timer.PERIODIC, callback=lambda t: print("Timer periodic tick"))
    Write Line To Uart      print("Timer started. Waiting 3.5 seconds...")
    Wait For Line On Uart   Timer started. Waiting 3.5 seconds...

    # We expect 3 ticks in 3.5 seconds (at 1s, 2s, 3s)
    Wait For Line On Uart   Timer periodic tick
    Wait For Line On Uart   Timer periodic tick
    Wait For Line On Uart   Timer periodic tick

    Write Line To Uart      print("Deinitializing timer...")
    Write Line To Uart      tim.deinit()
    Wait For Line On Uart   Deinitializing timer...

    Write Line To Uart      print("Testing one-shot timer (2 seconds)...")
    Write Line To Uart      tim.init(period=2000, mode=machine.Timer.ONE_SHOT, callback=lambda t: print("One-shot timer fired!"))
    Wait For Line On Uart   Testing one-shot timer (2 seconds)...

    Wait For Line On Uart   One-shot timer fired!
    Write Line To Uart      print("Test complete.")
    Wait For Line On Uart   Test complete.
