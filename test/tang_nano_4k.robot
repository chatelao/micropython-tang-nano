*** Settings ***
Suite Setup     Setup
Suite Teardown  Teardown
Test Setup      Reset Emulation
Resource        ${RENODEKEYWORDS}

*** Variables ***
${RESC}         ${CURDIR}/tang_nano_4k.resc
${UART}         sysbus.uart0

*** Test Cases ***
Should Boot Successfully and Interaction with REPL
    Execute Command         include @${RESC}
    Create Terminal Tester  ${UART}
    Start Emulation
    Wait For Line On Uart   MicroPython started on Tang Nano 4K
    Wait For Line On Uart   >>>
    Write Line To Uart      print("Hello from external Flash")
    Wait For Line On Uart   Hello from external Flash
