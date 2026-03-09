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
Verify SPI Implementation
    Execute Command         $repl = @${REPL}
    Execute Command         $bin = @${BIN}
    Execute Command         include @${RESC}
    Execute Command         sysbus.cpu VectorTableOffset 0x60000000
    Execute Command         sysbus.cpu SP `sysbus ReadDoubleWord 0x60000000`
    Execute Command         sysbus.cpu PC `sysbus ReadDoubleWord 0x60000004`
    Create Terminal Tester  ${UART}
    Start Emulation
    Wait For Line On Uart   MicroPython started on Tang Nano 4K

    # Test machine.SPI
    Write Line To Uart      from machine import SPI, Pin
    Write Line To Uart      spi = SPI(baudrate=1000000, sck=Pin(0), mosi=Pin(1), miso=Pin(2))
    Write Line To Uart      print('SPI_OK')
    Wait For Line On Uart   SPI_OK

    # Test machine.SoftSPI
    Write Line To Uart      from machine import SoftSPI
    Write Line To Uart      sspi = SoftSPI(baudrate=500000, sck=Pin(3), mosi=Pin(4), miso=Pin(5))
    Write Line To Uart      print('SOFTSPI_OK')
    Wait For Line On Uart   SOFTSPI_OK

    # Basic transfer test (miso not connected, so read should be 0 or 0xFF depending on pullup, here 0)
    Write Line To Uart      print('XFER:', sspi.read(4))
    Wait For Line On Uart   XFER: b'\\x00\\x00\\x00\\x00'
