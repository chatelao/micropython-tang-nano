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
    # Using concatenation in print to ensure we wait for the interpreter's output, not the command echo
    Write Line To Uart      from machine import I2C, Pin; print("MOD_O" + "K")
    Wait For Line On Uart   MOD_OK
    Write Line To Uart      i2c = I2C(scl=Pin(0), sda=Pin(1), freq=100000); print("I2C_O" + "K")
    Wait For Line On Uart   I2C_OK

    # Test scan (should return empty list as no devices are attached)
    Write Line To Uart      print('SCAN:', i2c.scan())
    # Increase the timeout for scan operation in case it takes longer in simulation
    Wait For Line On Uart   SCAN: []    timeout=15

    # Test machine.SoftI2C
    Write Line To Uart      from machine import SoftI2C; print("SMOD_O" + "K")
    Wait For Line On Uart   SMOD_OK
    Write Line To Uart      si2c = SoftI2C(scl=Pin(2), sda=Pin(3)); print("SOFTI2C_O" + "K")
    Wait For Line On Uart   SOFTI2C_OK
    Write Line To Uart      print('SSCAN:', si2c.scan())
    Wait For Line On Uart   SSCAN: []    timeout=15
