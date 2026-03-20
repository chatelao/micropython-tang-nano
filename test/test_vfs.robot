*** Settings ***
Suite Setup     Setup
Suite Teardown  Teardown
Resource        ${RENODEKEYWORDS}
Library         OperatingSystem

*** Variables ***
${UART}         sysbus.uart0
${RESC}         ${CURDIR}/tang_nano_4k.resc
${REPL}         ${CURDIR}/tang_nano_4k.repl
${BIN}          ${CURDIR}/../src/ports/tang_nano_4k/build/firmware.elf

*** Test Cases ***
Verify VFS Functionality
    [Documentation]    Verifies that MicroPython can perform file I/O operations on the simulated external flash.

    # Wait for the boot banner
    Wait For Line On Uart    MicroPython started on Tang Nano 4K

    # Read the test script
    ${script}=    Get File    ${CURDIR}/test_vfs.py
    ${lines}=     Evaluate    $script.splitlines()

    # Enter paste mode (Ctrl-E)
    Execute Command    ${UART} WriteChar 5

    # Send script line by line
    FOR    ${line}    IN    @{lines}
        Write Line To Uart    ${line}
    END

    # Exit paste mode (Ctrl-D) and wait for execution
    Execute Command    ${UART} WriteChar 4

    # Wait for results
    Wait For Line On Uart    VFS_TEST: OK
    Wait For Line On Uart    VFS_DONE

*** Keywords ***
Setup
    Execute Command         $repl = @${REPL}
    Execute Command         $bin = @${BIN}
    Execute Command         include @${RESC}
    # For booting from external flash, we need to set VTOR, SP and PC manually in Renode
    Execute Command         sysbus.cpu VectorTableOffset 0x60000000
    Execute Command         sysbus.cpu SP `sysbus ReadDoubleWord 0x60000000`
    Execute Command         sysbus.cpu PC `sysbus ReadDoubleWord 0x60000004`
    Create Terminal Tester  ${UART}
    Start Emulation

Teardown
    Execute Command    q
