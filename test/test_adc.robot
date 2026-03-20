*** Settings ***
Suite Setup     Setup
Suite Teardown  Teardown
Test Setup      Reset Emulation
Resource        ${RENODEKEYWORDS}

*** Variables ***
${RESC}         ${CURDIR}/tang_nano_4k.resc
${REPL}         ${CURDIR}/tang_nano_4k.repl
${BIN}          ${CURDIR}/../src/ports/tang_nano_4k/build/firmware.elf
${UART}         sysbus.uart0

*** Test Cases ***
Verify ADC Read
    [Documentation]    Verifies that MicroPython can read values from the simulated ADC.
    Execute Command    $repl = @${REPL}
    Execute Command    $bin = @${BIN}
    Execute Command    include @${RESC}
    Execute Command    sysbus.cpu VectorTableOffset 0x60000000
    Execute Command    sysbus.cpu SP `sysbus ReadDoubleWord 0x60000000`
    Execute Command    sysbus.cpu PC `sysbus ReadDoubleWord 0x60000004`
    Create Terminal Tester    ${UART}
    Start Emulation

    Wait For Line On Uart   MicroPython started on Tang Nano 4K

    # Set ADC DATA register (0x40002404) to a known value: 0x800 (half scale for 12-bit)
    # Expected read_u16() result: (0x800 << 4) | (0x800 >> 8) = 0x8000 | 0x08 = 0x8008 = 32776
    Execute Command    sysbus WriteDoubleWord 0x40002404 0x800

    Write Line To Uart    import machine; print("MOD_O" + "K")
    Wait For Line On Uart    MOD_OK
    Write Line To Uart    adc = machine.ADC(0); print("ADC_INI" + "T")
    Wait For Line On Uart    ADC_INIT
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
