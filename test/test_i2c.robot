*** Settings ***
Library         OperatingSystem
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
Verify SoftI2C Instantiation and Scan
    Execute Command         $repl = @${REPL}
    Execute Command         $bin = @${BIN}
    Execute Command         include @${RESC}
    Execute Command         sysbus.cpu VectorTableOffset 0x60000000
    Execute Command         sysbus.cpu SP `sysbus ReadDoubleWord 0x60000000`
    Execute Command         sysbus.cpu PC `sysbus ReadDoubleWord 0x60000004`
    Create Terminal Tester  ${UART}
    Start Emulation

    Wait For Line On Uart   MicroPython started on Tang Nano 4K

    Write Line To Uart      import machine
    Write Line To Uart      print("IMP" + "ORT_MACHINE_OK")
    Wait For Line On Uart   IMPORT_MACHINE_OK

    Write Line To Uart      i2c = machine.SoftI2C(scl=machine.Pin(0), sda=machine.Pin(1), freq=100000)
    Write Line To Uart      print("I2C" + "_OBJECT_CREATED")
    Wait For Line On Uart   I2C_OBJECT_CREATED

    Write Line To Uart      print("SC" + "AN_RESULT:", i2c.scan())
    Wait For Line On Uart   SCAN_RESULT: []
