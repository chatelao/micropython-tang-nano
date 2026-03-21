*** Settings ***
Suite Setup     Setup
Suite Teardown  Teardown
Resource        ${CURDIR}/tang_nano_4k.resc

*** Test Cases ***
Verify GPIO Interrupt
    [Documentation]    Verifies that GPIO interrupts work by triggering an interrupt from the simulation.

    # Send the test script line by line
    ${script}=    Get File    ${CURDIR}/test_pin_irq.py
    ${lines}=     Evaluate    $script.splitlines()
    FOR    ${line}    IN    @{lines}
        Write Line To Uart    ${line}
        # Wait for the echo of the line to ensure synchronization
        Wait For Line On Uart    ${line}
    END

    # Run the test
    Write Line To Uart    test_pin_irq()
    Wait For Line On Uart    WAITING FOR IRQ

    # Trigger the IRQ on Pin 0
    Execute Command    gpio0 WritePin 0 True
    # Wait for the success marker
    Wait For Line On Uart    PIN IRQ TEST PASSED

*** Keywords ***
Setup
    Execute Command    include @${CURDIR}/tang_nano_4k.resc
    Create Terminal Tester    ${UART}

Teardown
    Execute Command    q
