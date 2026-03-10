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

    # Wait for REPL to settle
    Sleep                   2s

    Write Line To Uart      from machine import Pin; print("MOD" + "_OK")
    Wait For Line On Uart   MOD_OK

    Write Line To Uart      import time; print("TIME" + "_OK")
    Wait For Line On Uart   TIME_OK

    Write Line To Uart      led = Pin(0, Pin.OUT); print("PIN" + "_OK")
    Wait For Line On Uart   PIN_OK

    FOR    ${INDEX}    IN RANGE    3
        Write Line To Uart  led.on(); print("LED_O" + "N")
        Wait For Line On Uart   LED_ON
        Write Line To Uart  time.sleep_ms(100); print("S" + "LEPT")
        Wait For Line On Uart   SLEPT
        Write Line To Uart  led.off(); print("LED_OF" + "F")
        Wait For Line On Uart   LED_OFF
        Write Line To Uart  time.sleep_ms(100); print("S" + "LEPT")
        Wait For Line On Uart   SLEPT
    END

    Write Line To Uart      print("TEST" + "_DONE")
    Wait For Line On Uart   TEST_DONE
