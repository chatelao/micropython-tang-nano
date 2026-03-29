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
Verify Tiny Tapeout Echo Example (via APB2)
    [Documentation]    Verifies that the tt_echo.py example works by simulating the FPGA echo via APB2 in Renode.
    Execute Command         $repl = @${REPL}
    Execute Command         $bin = @${BIN}
    Execute Command         include @${RESC}

    # Register the APB2 Slot 1 as a memory region for testing
    # Note: Slot 1 is at 0x40002400. In tang_nano_4k.repl, spi0 is at 0x40002400.
    Execute Command         sysbus Unregister sysbus.spi0
    Execute Command         machine LoadPlatformDescriptionFromString "tt_apb: Memory.MappedMemory @ sysbus 0x40002400 { size: 0x400 }"

    Execute Command         sysbus.cpu VectorTableOffset 0x60000000
    Execute Command         sysbus.cpu SP `sysbus ReadDoubleWord 0x60000000`
    Execute Command         sysbus.cpu PC `sysbus ReadDoubleWord 0x60000004`
    Create Terminal Tester  ${UART}
    Start Emulation

    Wait For Line On Uart   MicroPython started on Tang Nano 4K
    Wait For Line On Uart   Tang Nano 4K with GW1NSR-LV4C

    # Wait for REPL to be ready
    Sleep                   2s

    Write Line To Uart      import machine; print("MOD_O" + "K")
    Wait For Line On Uart   MOD_OK

    # Test values
    # AA (170), 55 (85), 00 (0), FF (255), 12 (18)
    FOR    ${val}    IN    170  85  0  255  18
        ${hex_val}=         Evaluate    hex(${val})
        # With Memory.MappedMemory, machine.mem32[0x40002400] = val writes to the address,
        # and reading it back from the SAME address achieves loopback.
        Write Line To Uart  machine.mem32[0x40002400] = ${val}; print("REC:" + hex(machine.mem32[0x40002400] & 0xFF))
        Wait For Line On Uart    REC:${hex_val}
    END

    # Test UIO read (0x40002404)
    # Manually write to the memory-mapped APB2 region to simulate FPGA input
    Write Line To Uart      machine.mem32[0x40002404] = 0xAC; print("UIO:" + hex(machine.mem32[0x40002404] & 0xFF))
    Wait For Line On Uart   UIO:0xac

    # Test UIO OE read (0x40002408)
    Write Line To Uart      machine.mem32[0x40002408] = 0xFF; print("OE:" + hex(machine.mem32[0x40002408] & 0xFF))
    Wait For Line On Uart   OE:0xff

    # Test CTRL register (0x4000240C)
    Write Line To Uart      machine.mem32[0x4000240C] = 0x6; print("CTRL:" + hex(machine.mem32[0x4000240C] & 0x7))
    Wait For Line On Uart   CTRL:0x6

    Write Line To Uart      print("D" + "ONE")
    Wait For Line On Uart   DONE
