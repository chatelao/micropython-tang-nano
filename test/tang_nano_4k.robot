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

Verify Hardware SPI Implementation
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
    Write Line To Uart      spi = SPI(baudrate=100000, sck=Pin(0), mosi=Pin(1), miso=Pin(2))
    Write Line To Uart      print('SPI_OK')
    Wait For Line On Uart   SPI_OK

    # Test transfer (should return 0x00 as it reads from an uninitialized Memory.MappedMemory)
    Write Line To Uart      res = spi.read(1)
    Write Line To Uart      print('READ_OK', res)
    Wait For Line On Uart   READ_OK b'\\x00'

    # Test machine.SoftSPI
    Write Line To Uart      from machine import SoftSPI
    Write Line To Uart      sspi = SoftSPI(baudrate=100000, sck=Pin(3), mosi=Pin(4), miso=Pin(5))
    Write Line To Uart      print('SOFTSPI_OK')
    Wait For Line On Uart   SOFTSPI_OK
    Write Line To Uart      res2 = sspi.read(1)
    Write Line To Uart      print('SREAD_OK', res2)
    Wait For Line On Uart   SREAD_OK b'\\x00'
