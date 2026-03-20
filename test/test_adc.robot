*** Settings ***
Suite Setup     Setup
Suite Teardown  Teardown
Resource        ${CURDIR}/tang_nano_4k.resc

*** Test Cases ***
Verify ADC Read
    [Documentation]    Verifies that MicroPython can read values from the simulated ADC.

    # Set ADC DATA register (0x40002404) to a known value: 0x800 (half scale for 12-bit)
    # Expected read_u16() result: (0x800 << 4) | (0x800 >> 8) = 0x8000 | 0x08 = 0x8008 = 32776
    Execute Command    sysbus WriteDoubleWord 0x40002404 0x800

    Write Line To Uart    import machine
    Write Line To Uart    adc = machine.ADC(0)
    Write Line To Uart    print("VAL:" + str(adc.read_u16()))

    Wait For Line On Uart    VAL:32776

    # Set ADC DATA to max value: 0xFFF
    # Expected read_u16(): (0xFFF << 4) | (0xFFF >> 8) = 0xFFF0 | 0x0F = 0xFFFF = 65535
    Execute Command    sysbus WriteDoubleWord 0x40002404 0xFFF
    Write Line To Uart    print("VAL:" + str(adc.read_u16()))
    Wait For Line On Uart    VAL:65535

    # Set ADC DATA to 0
    Execute Command    sysbus WriteDoubleWord 0x40002404 0x0
    Write Line To Uart    print("VAL:" + str(adc.read_u16()))
    Wait For Line On Uart    VAL:0

*** Keywords ***
Setup
    Execute Command    include @${CURDIR}/tang_nano_4k.resc
    Create Terminal Tester    ${UART}

Teardown
    Execute Command    q
