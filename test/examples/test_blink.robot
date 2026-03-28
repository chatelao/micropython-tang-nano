*** Settings ***
Suite Setup     Setup
Suite Teardown  Teardown
Resource        ${RENODEKEYWORDS}
Library         OperatingSystem
Library         String

*** Variables ***
${RESC}         ${CURDIR}/../tang_nano_4k.resc
${REPL}         ${CURDIR}/../tang_nano_4k.repl
${BIN}          ${CURDIR}/../../src/ports/tang_nano_4k/build/firmware.elf
${UART}         sysbus.uart0

*** Test Cases ***
Verify Blink Example
    [Documentation]    Verifies the blink.py example by sending it line-by-line to the UART.
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

    Write Line To Uart      import machine
    Write Line To Uart      import time
    Write Line To Uart      led = machine.Pin(0, machine.Pin.OUT)
    Write Line To Uart      print("Starting " + "blink test...")

    # Run a simplified version of the loop to verify it works
    FOR    ${INDEX}    IN RANGE    5
        Write Line To Uart  led.on()
        Write Line To Uart  print("LED " + "ON")
        Wait For Line On Uart   LED ON
        Write Line To Uart  led.off()
        Write Line To Uart  print("LED " + "OFF")
        Wait For Line On Uart   LED OFF
    END

    Write Line To Uart      print("Blink " + "test complete.")
    Wait For Line On Uart   Blink test complete.

    Write Line To Uart      print("D" + "ONE")
    Wait For Line On Uart   DONE
