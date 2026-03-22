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
Verify WDT Implementation
    Execute Command         $repl = @${REPL}
    Execute Command         $bin = @${BIN}
    Execute Command         include @${RESC}
    Execute Command         sysbus.cpu VectorTableOffset 0x60000000
    Execute Command         sysbus.cpu SP `sysbus ReadDoubleWord 0x60000000`
    Execute Command         sysbus.cpu PC `sysbus ReadDoubleWord 0x60000004`
    Create Terminal Tester  ${UART}
    Start Emulation
    Wait For Line On Uart   MicroPython started on Tang Nano 4K

    # Test machine.WDT
    Write Line To Uart      from machine import WDT
    Write Line To Uart      wdt = WDT(timeout=5000)
    Write Line To Uart      print('WDT_OK')
    Wait For Line On Uart   WDT_OK

    # Test feed
    Write Line To Uart      wdt.feed()
    Write Line To Uart      print('FEED_OK')
    Wait For Line On Uart   FEED_OK

    # Verify WDT registers in simulation memory
    # LOAD register at 0x40008000
    # 5000ms * 27000 = 135,000,000 = 0x080BEFC0
    ${load_val}=            Execute Command  sysbus ReadDoubleWord 0x40008000
    Should Contain          ${load_val}      0x080BEFC0

    # CTRL register at 0x40008008 should be 3
    ${ctrl_val}=            Execute Command  sysbus ReadDoubleWord 0x40008008
    Should Contain          ${ctrl_val}      0x00000003
