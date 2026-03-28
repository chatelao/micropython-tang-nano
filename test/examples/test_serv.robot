*** Settings ***
Suite Setup     Setup
Suite Teardown  Teardown
Test Setup      Reset Emulation
Resource        ${RENODEKEYWORDS}
Library         OperatingSystem
Resource        ${CURDIR}/../common.resource

*** Variables ***
${RESC_REL}         ${CURDIR}/../tang_nano_4k.resc
${REPL_REL}         ${CURDIR}/../tang_nano_4k.repl
${BIN_REL}          ${CURDIR}/../../src/ports/tang_nano_4k/build/firmware.elf
${UART}             sysbus.uart0
${EXAMPLE}          ${CURDIR}/../../examples/serv_riscv/serv_test.py

*** Test Cases ***
Verify SERV RISC-V Example
    [Documentation]    Verifies that the serv_test.py example works by sending it via Paste Mode and mocking the FPGA response.
    ${RESC}=                Normalize Path  ${RESC_REL}
    ${REPL}=                Normalize Path  ${REPL_REL}
    ${BIN}=                 Normalize Path  ${BIN_REL}
    Setup MicroPython       ${RESC}    ${REPL}    ${BIN}    ${UART}
    Start Emulation

    Wait For Line On Uart   MicroPython started on Tang Nano 4K
    Wait For Line On Uart   Tang Nano 4K with GW1NSR-LV4C

    # Wait for REPL to be ready
    Wait For Text On Uart   >>>

    # Enter Paste Mode (Ctrl-E)
    Write Char On Uart      \x05
    Wait For Text On Uart   paste mode; Ctrl-C to cancel, Ctrl-D to finish
    Wait For Text On Uart   ===

    # Send the script
    ${script}=    Get File    ${EXAMPLE}
    Write Line To Uart      ${script}

    # Finish Paste Mode and execute (Ctrl-D)
    Write Char On Uart      \x04

    # Mock the RISC-V core behavior in Renode
    # 1. Reset check: core expects REG_CTRL (0x40002D00) write.
    # 2. Program loading: script writes to IMEM_BASE (0x40002D40).
    # 3. Execution: core expects Enable bit in REG_CTRL.
    # 4. Halt and Result: core must set REG_STATUS (0x40002D04) bit 0 and write to REG_RESULT (0x40002D08).

    # We wait a moment for the script to start and then mock the status and result
    Sleep                   1s
    Execute Command         sysbus WriteDoubleWord 0x40002D08 42
    Execute Command         sysbus WriteDoubleWord 0x40002D04 1

    # Verify execution output
    Wait For Line On Uart    SERV RISC-V Core Test
    Wait For Line On Uart    SERV Halted. Result (a0): 42
    Wait For Line On Uart    TEST PASSED
