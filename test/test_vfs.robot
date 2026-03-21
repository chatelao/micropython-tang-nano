*** Settings ***
Suite Setup     Setup
Suite Teardown  Teardown
Resource        ${CURDIR}/tang_nano_4k.resc

*** Test Cases ***
Verify VFS Operations
    [Documentation]    Verifies that MicroPython can perform basic file operations on the simulated VFS.

    # Send the test script line by line
    ${script}=    Get File    ${CURDIR}/test_vfs.py
    ${lines}=     Evaluate    $script.splitlines()
    FOR    ${line}    IN    @{lines}
        Write Line To Uart    ${line}
        # Wait for the echo of the line to ensure synchronization
        Wait For Line On Uart    ${line}
    END

    # Run the test
    Write Line To Uart    test_vfs()

    # Wait for the success marker
    Wait For Line On Uart    VFS TEST PASSED

*** Keywords ***
Setup
    Execute Command    include @${CURDIR}/tang_nano_4k.resc
    Create Terminal Tester    ${UART}

Teardown
    Execute Command    q
