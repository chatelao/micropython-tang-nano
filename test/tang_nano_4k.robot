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
Should Boot Successfully and Interaction with REPL
    Execute Command         $repl = @${REPL}
    Execute Command         $bin = @${BIN}
    Execute Command         include @${RESC}
    # For booting from external flash, we need to set VTOR, SP and PC manually in Renode
    Execute Command         sysbus.cpu VectorTableOffset 0x60000000
    Execute Command         sysbus.cpu SP `sysbus ReadDoubleWord 0x60000000`
    Execute Command         sysbus.cpu PC `sysbus ReadDoubleWord 0x60000004`
    Create Terminal Tester  ${UART}
    Start Emulation
    Wait For Line On Uart   MicroPython started on Tang Nano 4K
    Wait For Line On Uart   Tang Nano 4K with GW1NSR-LV4C
    Write Line To Uart      print("Hello from external Flash")
    Wait For Line On Uart   Hello from external Flash

Verify Hardware SPI
    Write Line To Uart      from machine import SPI, Pin
    Write Line To Uart      spi = SPI(0, baudrate=1000000)
    Write Line To Uart      print('SPI:', spi)
    Wait For Line On Uart   SPI: SPI(0, baudrate=1000000, polarity=0, phase=0, bits=8, firstbit=0)
    Write Line To Uart      spi.write(b'\\x55\\xAA')
    Write Line To Uart      print('WRITE_DONE')
    Wait For Line On Uart   WRITE_DONE
