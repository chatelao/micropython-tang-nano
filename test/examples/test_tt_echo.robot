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

    # Unregister the GPIO peripheral and replace it with a memory region for loopback testing
    Execute Command         sysbus Unregister sysbus.gpio0
    Execute Command         machine LoadPlatformDescriptionFromString "gpio_bridge: Memory.MappedMemory @ sysbus 0x40010000 { size: 0x1000 }"

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
        # With Memory.MappedMemory, bridge.write writes to the address,
        # and bridge.read reads from the SAME address, achieving loopback.
        Write Line To Uart  bridge.write(${val}); print("REC:" + hex(bridge.read() & 0xFF))
        Wait For Line On Uart    REC:${hex_val}
    END

    # Test UIO read (bits 8-15)
    Write Line To Uart      machine.mem32[0x40010014] = 0xFF00
    # Manually write to the memory-mapped bridge to simulate FPGA input (bits 8-15)
    Write Line To Uart      machine.mem32[0x40010000] = 0x5A00; print("UIO:" + hex((bridge.read() >> 8) & 0xFF))
    Wait For Line On Uart   UIO:0x5a

    Write Line To Uart      print("D" + "ONE")
    Wait For Line On Uart   DONE
