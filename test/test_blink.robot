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
Should Blink Pin 0
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

    Write Line To Uart      from machine import Pin; print("M" + "OK")
    Wait For Line On Uart   MOK

    Write Line To Uart      import time; print("T" + "OK")
    Wait For Line On Uart   TOK

    Write Line To Uart      led = Pin(0, Pin.OUT); print("P" + "OK")
    Wait For Line On Uart   POK

    FOR    ${INDEX}    IN RANGE    3
        Write Line To Uart  led.on(); print("L" + "ON")
        Wait For Line On Uart   LON
        Write Line To Uart  print("S"); time.sleep_ms(50); print("E")
        Wait For Line On Uart   S
        Wait For Line On Uart   E
        Write Line To Uart  led.off(); print("L" + "OFF")
        Wait For Line On Uart   LOFF
        Write Line To Uart  print("S"); time.sleep_ms(50); print("E")
        Wait For Line On Uart   S
        Wait For Line On Uart   E
    END

    Write Line To Uart      print("D" + "ONE")
    Wait For Line On Uart   DONE
