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
${EXAMPLE}          ${CURDIR}/../../examples/neorv32/neorv32.py

*** Test Cases ***
Verify NEORV32 RISC-V Example
    [Documentation]    Verifies that the neorv32.py example works by sending it via Paste Mode and mocking the FPGA response.
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
    # We modify the script to not loop forever in the test
    ${script_mod}=    Evaluate    $script.replace('while True:', 'for _ in range(1):')
    Write Line To Uart      ${script_mod}

    # Finish Paste Mode and execute (Ctrl-D)
    Write Char On Uart      \x04

    # Mock the RISC-V response in the mailbox before the script reads it
    # Slot 1 Mailbox In is at 0x40002404
    Execute Command         sysbus WriteDoubleWord 0x40002404 0xCAFEBABE

    # Verify execution output
    Wait For Line On Uart    NEORV32 Co-processor Integration Example
    Wait For Line On Uart    NEORV32 Response: 0xCAFEBABE
    Wait For Line On Uart    Example Complete
