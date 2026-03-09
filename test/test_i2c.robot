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
Verify I2C Implementation
    Execute Command         $repl = @${REPL}
    Execute Command         $bin = @${BIN}
    Execute Command         include @${RESC}
    Execute Command         sysbus.cpu VectorTableOffset 0x60000000
    Execute Command         sysbus.cpu SP `sysbus ReadDoubleWord 0x60000000`
    Execute Command         sysbus.cpu PC `sysbus ReadDoubleWord 0x60000004`
    Create Terminal Tester  ${UART}
    Start Emulation
    Wait For Line On Uart   MicroPython started on Tang Nano 4K

    # Test machine.I2C
    Write Line To Uart      from machine import I2C, Pin
    Write Line To Uart      i2c = I2C(scl=Pin(0), sda=Pin(1), freq=100000)
    Write Line To Uart      print('I2C_OK')
    Wait For Line On Uart   I2C_OK

    # Test scan (should return empty list as no devices are attached)
    Write Line To Uart      print('SCAN:', i2c.scan())
    Wait For Line On Uart   SCAN: []

    # Test machine.SoftI2C
    Write Line To Uart      from machine import SoftI2C
    Write Line To Uart      si2c = SoftI2C(scl=Pin(2), sda=Pin(3))
    Write Line To Uart      print('SOFTI2C_OK')
    Wait For Line On Uart   SOFTI2C_OK
    Write Line To Uart      print('SSCAN:', si2c.scan())
    Wait For Line On Uart   SSCAN: []
