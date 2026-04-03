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

    # Check if LED (GPIO 0) toggles
    # By default, Renode logs GPIO changes at Info level (2).
    Execute Command         logLevel 2 gpio0
    Create Log Tester       0

    Start Emulation

    # The blinky example toggles the LED.
    Wait For Log Entry      "gpio0: Setting pin 0 to True"   timeout=5
    Wait For Log Entry      "gpio0: Setting pin 0 to False"  timeout=5
    Wait For Log Entry      "gpio0: Setting pin 0 to True"   timeout=5
