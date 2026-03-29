*** Settings ***
Suite Setup     Setup
Suite Teardown  Teardown
Resource        ${RENODEKEYWORDS}

*** Variables ***
${RESC}         ${CURDIR}/../tang_nano_4k.resc
${REPL}         ${CURDIR}/../tang_nano_4k.repl
${BIN}          ${CURDIR}/../../src/ports/tang_nano_4k/build/firmware.elf
${UART}         sysbus.uart0
${VGA_SCRIPT}   ${CURDIR}/../../examples/tt_vga_to_hdmi/tt_vga_hdmi.py

*** Test Cases ***
Verify Tiny Tapeout VGA to HDMI Example (via APB2)
    [Documentation]    Verifies that the tt_vga_hdmi.py example can access the FPGA registers in Renode.
    Execute Command         $repl = @${REPL}
    Execute Command         $bin = @${BIN}
    Execute Command         include @${RESC}

    # Register the APB2 Slot 1 as a memory region for testing
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

    # Simulate TT module output by writing to the memory-mapped register
    # uo_out = 0x80 (VSYNC=1, HSYNC=0, others=0)
    Execute Command         sysbus WriteDoubleWord 0x40002400 0x80

    # Use Paste Mode to run the script
    Write Char To Uart      \x05
    Wait For Line On Uart   paste mode; Ctrl-C to cancel, Ctrl-D to finish

    ${script}=              OperatingSystem.Get File          ${VGA_SCRIPT}
    Write Line To Uart      ${script}

    Write Char To Uart      \x04

    Wait For Line On Uart   Enabling Tiny Tapeout module...
    Wait For Line On Uart   TT module enabled.
    Wait For Line On Uart   uo_out: 0x80
    Wait For Line On Uart   VSYNC: 1
    Wait For Line On Uart   HSYNC: 0

    # Check CTRL register write (0x4000240C)
    # The script writes 0x6 to enable_tt
    ${ctrl_val}=            Execute Command    sysbus ReadDoubleWord 0x4000240C
    Should Contain          ${ctrl_val}    0x00000006

    Write Line To Uart      print("D" + "ONE")
    Wait For Line On Uart   DONE
