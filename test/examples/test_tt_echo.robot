*** Settings ***
Suite Setup     Setup
Suite Teardown  Teardown
Resource        ${RENODEKEYWORDS}

*** Variables ***
${RESC}         ${CURDIR}/../tang_nano_4k.resc
${REPL}         ${CURDIR}/../tang_nano_4k.repl
${BIN}          ${CURDIR}/../../src/ports/tang_nano_4k/build/firmware.elf
${UART}         sysbus.uart0

*** Test Cases ***
Verify Tiny Tapeout Echo Example
    [Documentation]    Verifies that the tt_echo.py example works by simulating the FPGA echo in Renode.
    Execute Command         $repl = @${REPL}
    Execute Command         $bin = @${BIN}
    Execute Command         include @${RESC}
    Execute Command         sysbus.cpu VectorTableOffset 0x60000000
    Execute Command         sysbus.cpu SP `sysbus ReadDoubleWord 0x60000000`
    Execute Command         sysbus.cpu PC `sysbus ReadDoubleWord 0x60000004`
    Create Terminal Tester  ${UART}
    Start Emulation

    Wait For Line On Uart   MicroPython started on Tang Nano 4K
    Wait For Line On Uart   Tang Nano 4K with GW1NSR-LV4C

    # Wait for REPL to be ready
    Sleep                   2s

    Write Line To Uart      import machine; bridge = machine.FPGABridge(); print("MOD_O" + "K")
    Wait For Line On Uart   MOD_OK

    # Test values
    # AA (170), 55 (85), 00 (0), FF (255), 12 (18)
    FOR    ${val}    IN    170  85  0  255  18
        ${hex_val}=         Evaluate    hex(${val})
        Write Line To Uart  bridge.write(${val}); print("REC:" + hex(bridge.read() & 0xFF))
        Wait For Line On Uart    REC:${hex_val}
    END

    # Test UIO read (bits 8-15)
    # Default should be 0x00 in simulation
    Write Line To Uart      machine.mem32[0x40010014] = 0xFF00
    Write Line To Uart      print("UIO:" + hex((bridge.read() >> 8) & 0xFF))
    Wait For Line On Uart   UIO:0x0

    Write Line To Uart      print("D" + "ONE")
    Wait For Line On Uart   DONE
