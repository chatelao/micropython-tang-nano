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

    # Initialize SPI status register to show Transmit Ready and Receive Ready
    # This prevents the driver from hanging in simulation when polling bits
    # in a Memory.MappedMemory region.
    Execute Command         sysbus WriteByte 0x40002208 0x60

    # Test machine.SPI (Hardware SPI)
    Write Line To Uart      from machine import SPI, Pin
    Write Line To Uart      spi = SPI(0, baudrate=1000000, polarity=0, phase=0)
    Write Line To Uart      print('SPI_OK:', spi)
    Wait For Line On Uart   SPI_OK: SPI(0, baudrate=1000000, polarity=0, phase=0, bits=8, firstbit=0)

    # Test SPI write
    Write Line To Uart      spi.write(b'\\x55\\xAA')
    Write Line To Uart      print('WRITE_OK')
    Wait For Line On Uart   WRITE_OK

    # Test SPI read (Memory.MappedMemory usually returns 0x00 by default)
    Write Line To Uart      print('READ:', spi.read(2))
    Wait For Line On Uart   READ: b'\\x00\\x00'

    # Test machine.SoftSPI
    Write Line To Uart      from machine import SoftSPI
    Write Line To Uart      sspi = SoftSPI(baudrate=100000, polarity=0, phase=0, sck=Pin(2), mosi=Pin(3), miso=Pin(4))
    Write Line To Uart      print('SOFTSPI_OK')
    Wait For Line On Uart   SOFTSPI_OK
    Write Line To Uart      sspi.write(b'\\x12')
    Write Line To Uart      print('SWRITE_OK')
    Wait For Line On Uart   SWRITE_OK
