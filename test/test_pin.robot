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
Verify Pin Input and Output
    Execute Command         $repl = @${REPL}
    Execute Command         $bin = @${BIN}
    Execute Command         include @${RESC}
    Execute Command         sysbus.cpu VectorTableOffset 0x60000000
    Execute Command         sysbus.cpu SP `sysbus ReadDoubleWord 0x60000000`
    Execute Command         sysbus.cpu PC `sysbus ReadDoubleWord 0x60000004`
    Create Terminal Tester  ${UART}
    Start Emulation

    Wait For Line On Uart   MicroPython started on Tang Nano 4K

    # Test Pin Output
    Write Line To Uart      from machine import Pin
    Write Line To Uart      p0 = Pin(0, Pin.OUT)
    Write Line To Uart      p0.on(); print("P0_VAL:", p0.value())
    Wait For Line On Uart   P0_VAL: 1
    Write Line To Uart      p0.off(); print("P0_VAL:", p0.value())
    Wait For Line On Uart   P0_VAL: 0

    # Test Pin Input (Pin 1)
    Write Line To Uart      p1 = Pin(1, Pin.IN)

    # Set Pin 1 High in Renode
    Execute Command         sysbus.gpio0 WriteDoubleWord 0x00 0x0002
    Write Line To Uart      print("P1_VAL:", p1.value())
    Wait For Line On Uart   P1_VAL: 1

    # Set Pin 1 Low in Renode
    Execute Command         sysbus.gpio0 WriteDoubleWord 0x00 0x0000
    Write Line To Uart      print("P1_VAL:", p1.value())
    Wait For Line On Uart   P1_VAL: 0
