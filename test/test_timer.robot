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
    Wait For Line On Uart   >>>
    Write Line To Uart      import time
    Wait For Line On Uart   >>>
    Write Line To Uart      def cb(t): print('TICK_EVENT')
    Wait For Line On Uart   >>>
    Write Line To Uart      print('TICKS_START:', time.ticks_ms())
    Wait For Line On Uart   TICKS_START:

    # Create a periodic timer
    Write Line To Uart      tim = machine.Timer(0)
    Wait For Line On Uart   >>>
    Write Line To Uart      tim.init(period=500, mode=machine.Timer.PERIODIC, callback=cb)
    Wait For Line On Uart   >>>
    Write Line To Uart      print('START_SIGNAL')
    Wait For Line On Uart   START_SIGNAL

    # We expect 3 ticks
    Wait For Line On Uart   TICK_EVENT
    Wait For Line On Uart   TICK_EVENT
    Wait For Line On Uart   TICK_EVENT

    Write Line To Uart      tim.deinit()
    Wait For Line On Uart   >>>
    Write Line To Uart      print('TICKS_END:', time.ticks_ms())
    Wait For Line On Uart   TICKS_END:

    # Create a one-shot timer
    Write Line To Uart      print('ONESHOT_SIGNAL')
    Wait For Line On Uart   ONESHOT_SIGNAL
    Write Line To Uart      tim.init(period=500, mode=machine.Timer.ONE_SHOT, callback=cb)
    Wait For Line On Uart   >>>
    Wait For Line On Uart   TICK_EVENT

    Write Line To Uart      print('DONE_SIGNAL')
    Wait For Line On Uart   DONE_SIGNAL
