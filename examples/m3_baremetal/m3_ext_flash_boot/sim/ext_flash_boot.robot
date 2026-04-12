*** Settings ***
Suite Setup     Setup
Suite Teardown  Teardown
Resource        ${RENODEKEYWORDS}

*** Variables ***
${RESC}         ${CURDIR}/ext_flash_boot.resc
${REPL}         ${CURDIR}/../../../../test/tang_nano_4k.repl
${INT_BIN}      ${CURDIR}/../int_blink.bin
${EXT_BIN}      ${CURDIR}/../ext_blink.bin

*** Test Cases ***
Verify External Flash Boot Blink
    [Documentation]    Verifies that the M3 can boot from external flash and blink the LED.
    Execute Command         $repl = @${REPL}
    Execute Command         $int_bin = @${INT_BIN}
    Execute Command         $ext_bin = @${EXT_BIN}
    Execute Command         include @${RESC}

    Create Terminal Tester  sysbus.uart0

    # Attach an LED to GPIO 0 to ensure we get clear log messages
    Execute Command         machine LoadPlatformDescriptionFromString "led: Miscellaneous.LED @ gpio0 0"

    Create Log Tester       20

    Start Emulation

    # Wait for UART boot message
    Wait For Line On Uart   M3 External Flash Boot Example

    # The blinky example toggles the LED.
    # We wait for the LED state change log messages.
    Wait For Log Entry      led: State changed to True   timeout=20
    Wait For Log Entry      led: State changed to False  timeout=10
    Wait For Log Entry      led: State changed to True   timeout=10
