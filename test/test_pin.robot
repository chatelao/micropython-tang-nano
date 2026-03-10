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

    # Test Pin output
    Write Line To Uart      from machine import Pin
    Write Line To Uart      led = Pin(0, Pin.OUT)
    Write Line To Uart      led.value(1)
    Write Line To Uart      print('PIN0:', led.value())
    Wait For Line On Uart   PIN0: 1
    Write Line To Uart      led.off()
    Write Line To Uart      print('PIN0:', led.value())
    Wait For Line On Uart   PIN0: 0
    Write Line To Uart      led.on()
    Write Line To Uart      print('PIN0:', led.value())
    Wait For Line On Uart   PIN0: 1

    # Test Pin input
    Write Line To Uart      in_pin = Pin(1, Pin.IN)
    Write Line To Uart      print('PIN1:', in_pin.value())
    Wait For Line On Uart   PIN1: 0

    # Test Pin identification
    Write Line To Uart      print(led)
    Wait For Line On Uart   Pin(0)
