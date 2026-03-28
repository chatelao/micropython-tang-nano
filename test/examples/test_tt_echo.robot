*** Settings ***
Suite Setup     Setup
Suite Teardown  Teardown
Test Setup      Reset Emulation
Resource        ${RENODEKEYWORDS}
Library         OperatingSystem

*** Variables ***
${RESC}         ${CURDIR}/../tang_nano_4k.resc
${REPL}         ${CURDIR}/../tang_nano_4k.repl
${BIN}          ${CURDIR}/../../src/ports/tang_nano_4k/build/firmware.elf
${UART}         sysbus.uart0
${EXAMPLE}      ${CURDIR}/../../examples/tt_echo/tt_echo.py

*** Keywords ***
Setup MicroPython
    Execute Command         $repl = @${REPL}
    Execute Command         $bin = @${BIN}
    Execute Command         include @${RESC}
    ${boot_addr_raw}=       Execute Command  sysbus GetSymbolAddress "isr_vector"
    ${boot_addr}=           Evaluate  '''${boot_addr_raw}'''.strip()
    Log                     Boot Addr: ${boot_addr}
    # For booting, we need to set VTOR, SP and PC manually in Renode
    Execute Command         sysbus.cpu VectorTableOffset ${boot_addr}
    ${sp_val_raw}=          Execute Command  sysbus ReadDoubleWord ${boot_addr}
    ${sp_val}=              Evaluate  '''${sp_val_raw}'''.strip()
    Log                     SP Val: ${sp_val}
    Execute Command         sysbus.cpu SP ${sp_val}
    ${pc_ptr}=              Evaluate  hex(int("${boot_addr}", 16) + 4)
    ${pc_val_raw}=          Execute Command  sysbus ReadDoubleWord ${pc_ptr}
    ${pc_val}=              Evaluate  '''${pc_val_raw}'''.strip()
    Log                     PC Val: ${pc_val}
    Execute Command         sysbus.cpu PC ${pc_val}
    Create Terminal Tester  ${UART}

*** Test Cases ***
Verify Tiny Tapeout Echo Example
    [Documentation]    Verifies that the tt_echo.py example works by sending it to the REPL.
    Setup MicroPython
    Start Emulation

    Wait For Line On Uart   MicroPython started on Tang Nano 4K
    Wait For Line On Uart   Tang Nano 4K with GW1NSR-LV4C

    # Wait for REPL to be ready
    Sleep                   2s

    # Load and send example script line by line
    ${script}=    Get File    ${EXAMPLE}
    ${lines}=     Evaluate    $script.splitlines()
    FOR    ${line}    IN    @{lines}
        Write Line To Uart    ${line}
        Wait For Line On Uart    ${line}
    END

    # Send an extra newline to ensure the last block (if any) executes
    Write Line To Uart      ${EMPTY}

    # Verify execution output
    Wait For Line On Uart    Tiny Tapeout Echo Test
    FOR    ${i}    IN RANGE    5
        Wait For Line On Uart    MATCH
    END
    Wait For Line On Uart    UIO value read from FPGA
    Wait For Line On Uart    Test Complete
