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
Verify Pin Implementation
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

    # Test Pin output
    Write Line To Uart      from machine import Pin
    Wait For Text On Uart   >>>
    Write Line To Uart      led = Pin(0, Pin.OUT)
    Wait For Text On Uart   >>>
    Write Line To Uart      led.value(1)
    Wait For Text On Uart   >>>
    Write Line To Uart      print('PIN0:', led.value())
    Wait For Line On Uart   PIN0: 1
    Wait For Text On Uart   >>>
    Write Line To Uart      led.off()
    Wait For Text On Uart   >>>
    Write Line To Uart      print('PIN0:', led.value())
    Wait For Line On Uart   PIN0: 0
    Wait For Text On Uart   >>>
    Write Line To Uart      led.on()
    Wait For Text On Uart   >>>
    Write Line To Uart      print('PIN0:', led.value())
    Wait For Line On Uart   PIN0: 1
    Wait For Text On Uart   >>>

    # Test Pin input
    Write Line To Uart      in_pin = Pin(1, Pin.IN)
    Wait For Text On Uart   >>>
    Write Line To Uart      print('PIN1:', in_pin.value())
    Wait For Line On Uart   PIN1: 0
    Wait For Text On Uart   >>>

    # Test Pin identification
    Write Line To Uart      print(led)
    Wait For Line On Uart   Pin(0)
    Wait For Text On Uart   >>>
