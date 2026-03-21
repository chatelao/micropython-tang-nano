*** Settings ***
Suite Setup     Setup
Suite Teardown  Teardown
Test Setup      Reset Emulation
Resource        ${RENODEKEYWORDS}
Library         Process

*** Variables ***
${RESC}         ${CURDIR}/tang_nano_4k.resc
${REPL}         ${CURDIR}/tang_nano_4k.repl
${BIN}          ${CURDIR}/../src/ports/tang_nano_4k/build/firmware.elf
${UART}         sysbus.uart0

*** Test Cases ***
Should Boot Successfully and Interaction with REPL
    Init Renode
    Create Terminal Tester  ${UART}
    Start Emulation
    Wait For Line On Uart   MicroPython started on Tang Nano 4K
    Wait For Line On Uart   Tang Nano 4K with GW1NSR-LV4C
    Write Line To Uart      print("Hello from external Flash")
    Wait For Line On Uart   Hello from external Flash

Should Blink Pin 0
    Init Renode
    Create Terminal Tester  ${UART}
    Start Emulation

    Wait For Line On Uart   MicroPython started on Tang Nano 4K
    Wait For Line On Uart   Tang Nano 4K with GW1NSR-LV4C

    # Wait for REPL to be ready
    Sleep                   2s

    Write Line To Uart      from machine import Pin; print("MOD_O" + "K")
    Wait For Line On Uart   MOD_OK

    Write Line To Uart      import time; print("TIME_O" + "K")
    Wait For Line On Uart   TIME_OK

    Write Line To Uart      led = Pin(0, Pin.OUT); print("PIN_O" + "K")
    Wait For Line On Uart   PIN_OK

    FOR    ${INDEX}    IN RANGE    3
        Write Line To Uart  led.on(); print("L_O" + "N")
        Wait For Line On Uart   L_ON
        Write Line To Uart  time.sleep_ms(10); print("S_1")
        Wait For Line On Uart   S_1
        Write Line To Uart  led.off(); print("L_OF" + "F")
        Wait For Line On Uart   L_OFF
        Write Line To Uart  time.sleep_ms(10); print("S_2")
        Wait For Line On Uart   S_2
    END

    Write Line To Uart      print("D" + "ONE")
    Wait For Line On Uart   DONE

Run MicroPython Compliance Suite
    Init Renode
    # Expose UART0 via TCP Terminal Server for compliance tests
    Execute Command         emulation CreateTcpTerminalServer 12345 "server1"
    Execute Command         connector Connect sysbus.uart0 server1
    Start Emulation
    # Wait for REPL to be ready before starting compliance tests
    Create Terminal Tester  ${UART}
    Wait For Line On Uart   Tang Nano 4K with GW1NSR-LV4C

    # Run the compliance script in attach mode
    ${result} =             Run Process    python3    ${CURDIR}/run_compliance.py    --attach    cwd=${CURDIR}/..    stdout=STDOUT    stderr=STDOUT
    Log                     ${result.stdout}
    Should Be Equal As Integers    ${result.rc}    0

*** Keywords ***
Init Renode
    Execute Command         $repl = @${REPL}
    Execute Command         $bin = @${BIN}
    Execute Command         include @${RESC}
    # For booting from external flash, we need to set VTOR, SP and PC manually in Renode
    Execute Command         sysbus.cpu VectorTableOffset 0x60000000
    Execute Command         sysbus.cpu SP `sysbus ReadDoubleWord 0x60000000`
    Execute Command         sysbus.cpu PC `sysbus ReadDoubleWord 0x60000004`
