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

    # Test Pin initialization and blinking via direct REPL commands
    # This avoids the complexities of script injection/Paste Mode in simulation
    Write Line To Uart      from machine import Pin
    Wait For Line On Uart   >>>

    Write Line To Uart      import time
    Wait For Line On Uart   >>>

    Write Line To Uart      led = Pin(0, Pin.OUT)
    Wait For Line On Uart   >>>

    Write Line To Uart      print("START_BLINK")
    Wait For Line On Uart   START_BLINK

    FOR    ${INDEX}    IN RANGE    5
        Write Line To Uart  led.on(); print("ON")
        Wait For Line On Uart   ON
        Write Line To Uart  time.sleep_ms(100)
        Wait For Line On Uart   >>>

        Write Line To Uart  led.off(); print("OFF")
        Wait For Line On Uart   OFF
        Write Line To Uart  time.sleep_ms(100)
        Wait For Line On Uart   >>>
    END

    Write Line To Uart      print("BLINK_DONE")
    Wait For Line On Uart   BLINK_DONE
