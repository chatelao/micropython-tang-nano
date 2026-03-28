*** Settings ***
Suite Setup     Setup
Suite Teardown  Teardown
Test Setup      Reset Emulation
Resource        ${RENODEKEYWORDS}
Library         OperatingSystem

*** Variables ***
${RESC}         ${CURDIR}/../tang_nano_4k.resc
${UART}         sysbus.uart0
${EXAMPLE}      ${CURDIR}/../../examples/tt_echo/tt_echo.py

*** Test Cases ***
Verify Tiny Tapeout Echo Example
    [Documentation]    Verifies that the tt_echo.py example works by sending it to the REPL.
    Execute Command         include @${RESC}
    Execute Command         sysbus.cpu VectorTableOffset 0x60000000
    Execute Command         sysbus.cpu SP `sysbus ReadDoubleWord 0x60000000`
    Execute Command         sysbus.cpu PC `sysbus ReadDoubleWord 0x60000004`
    Create Terminal Tester  ${UART}
    Start Emulation

    Wait For Line On Uart   MicroPython started on Tang Nano 4K

    # Wait for REPL to be ready
    Wait For Line On Uart   >>>

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
