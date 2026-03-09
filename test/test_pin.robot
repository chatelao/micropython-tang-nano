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
Should Verify Pin Functionality
    Execute Command         $repl = @${REPL}
    Execute Command         $bin = @${BIN}
    Execute Command         include @${RESC}
    Execute Command         sysbus.cpu VectorTableOffset 0x60000000
    Execute Command         sysbus.cpu SP `sysbus ReadDoubleWord 0x60000000`
    Execute Command         sysbus.cpu PC `sysbus ReadDoubleWord 0x60000004`
    Create Terminal Tester  ${UART}
    Start Emulation

    Wait For Line On Uart   MicroPython started on Tang Nano 4K

    Write Line To Uart      from machine import Pin
    Write Line To Uart      led = Pin(0, Pin.OUT)
    Write Line To Uart      print("TOGGLE_START")
    Wait For Line On Uart   TOGGLE_START

    Write Line To Uart      led.value(1)
    Write Line To Uart      print("PIN_ON")
    Wait For Line On Uart   PIN_ON

    Write Line To Uart      led.value(0)
    Write Line To Uart      print("PIN_OFF")
    Wait For Line On Uart   PIN_OFF

    Write Line To Uart      in_pin = Pin(1, Pin.IN)
    Write Line To Uart      print("PIN_VAL:", in_pin.value())
    Wait For Line On Uart   PIN_VAL: 0
