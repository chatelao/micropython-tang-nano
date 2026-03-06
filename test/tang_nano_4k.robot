*** Settings ***
Suite Setup     Setup
Suite Teardown  Teardown
Test Setup      Reset Emulation
Resource        ${RENODEKEYWORDS}

*** Variables ***
${RESC}         ${CURDIR}/tang_nano_4k.resc
${UART}         sysbus.uart0

*** Test Cases ***
Should Boot Successfully
    Execute Command         $bin = @src/ports/tang_nano_4k/build/firmware.elf
    Execute Command         include @${RESC}
    Create Terminal Tester  ${UART}
    Start Emulation
    Wait For Line On Uart   MicroPython started on Tang Nano 4K
