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
${TEST_I2C}     ${CURDIR}/test_i2c.py

*** Test Cases ***
Verify SoftI2C Instantiation and Scan
    Execute Command         $repl = @${REPL}
    Execute Command         $bin = @${BIN}
    Execute Command         include @${RESC}
    Execute Command         sysbus.cpu VectorTableOffset 0x60000000
    Execute Command         sysbus.cpu SP `sysbus ReadDoubleWord 0x60000000`
    Execute Command         sysbus.cpu PC `sysbus ReadDoubleWord 0x60000004`
    Create Terminal Tester  ${UART}
    Start Emulation

    # Wait for REPL prompt
    Wait For Text On Uart    >>>

    # Send the test script line by line or as a block if the REPL supports it.
    # For simplicity, we'll send it as a block of code.
    ${script}=    Get File    ${TEST_I2C}
    Write Line To Uart      ${script}

    Wait For Line On Uart   Testing SoftI2C instantiation...
    Wait For Line On Uart   SoftI2C object created successfully: SoftI2C(scl=Pin(0), sda=Pin(1), freq=100000)
    Wait For Line On Uart   Scanning I2C bus...
    Wait For Line On Uart   Scan complete. Devices found: []
    Wait For Line On Uart   I2C test script finished.
