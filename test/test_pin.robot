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
Verify Pin Interface
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

    # Test Output
    Write Line To Uart      from machine import Pin
    Write Line To Uart      p0 = Pin(0, Pin.OUT)
    Write Line To Uart      p0.on(); print("P0_ON")
    Wait For Line On Uart   P0_ON
    Write Line To Uart      p0.off(); print("P0_OFF")
    Wait For Line On Uart   P0_OFF
    Write Line To Uart      p0.value(1); print("P0_VAL_1")
    Wait For Line On Uart   P0_VAL_1
    Write Line To Uart      print("P0_STATE:", p0.value())
    Wait For Line On Uart   P0_STATE: 1

    # Test Input
    Write Line To Uart      p1 = Pin(1, Pin.IN)
    Write Line To Uart      print("P1_VAL:", p1.value())
    Wait For Line On Uart   P1_VAL: 0
