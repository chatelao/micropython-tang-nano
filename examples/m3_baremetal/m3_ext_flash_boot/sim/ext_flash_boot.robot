*** Settings ***
Suite Setup     Setup
Suite Teardown  Teardown
Resource        ${RENODEKEYWORDS}

*** Variables ***
${RESC}         ${CURDIR}/ext_flash_boot.resc
${UART}         sysbus.uart0

*** Test Cases ***
Verify External Flash Boot
    [Documentation]    Verifies the external flash boot example by checking UART output.
    Execute Command         $bin = @${CURDIR}/../firmware.elf
    Execute Command         include @${RESC}

    Create Terminal Tester  ${UART}
    Start Emulation

    # Check for UART output indicating code execution
    Wait For Line On Uart   LED ON
    Wait For Line On Uart   Res 1: 0x00001141
    Wait For Line On Uart   Res 2: 0x00002292

    Wait For Line On Uart   LED OFF
    Wait For Line On Uart   Res 1: 0x00001141
    Wait For Line On Uart   Res 2: 0x00002292

    Wait For Line On Uart   LED ON
    Wait For Line On Uart   Res 1: 0x00001141
    Wait For Line On Uart   Res 2: 0x00002292
