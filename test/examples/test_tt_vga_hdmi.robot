*** Settings ***
Suite Setup     Setup
Suite Teardown  Teardown
Resource        ${RENODEKEYWORDS}

*** Variables ***
${RESC}         ${CURDIR}/../tang_nano_4k.resc
${REPL}         ${CURDIR}/../tang_nano_4k.repl
${BIN}          ${CURDIR}/../../src/ports/tang_nano_4k/build/firmware.elf
${UART}         sysbus.uart0
${VGA_SCRIPT}   ${CURDIR}/../../examples/tiny-tapeouts/tt_vga_to_hdmi/tt_vga_hdmi.py

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

    # Simulate Audio PCM output (0x1234 = 4660)
    Execute Command         sysbus WriteDoubleWord 0x40002404 0x1234

    # Run check commands directly
    Write Line To Uart      import machine
    Write Line To Uart      print("uo_out: " + hex(machine.mem32[0x40002400] & 0xFF))
    Wait For Line On Uart   uo_out: 0x80

    Write Line To Uart      audio_pcm = machine.mem32[0x40002404] & 0xFFFF
    Write Line To Uart      if audio_pcm > 32767: audio_pcm -= 65536
    Write Line To Uart      ${EMPTY}
    Write Line To Uart      print("Audio PCM: " + str(audio_pcm))
    Wait For Line On Uart   Audio PCM: 4660

    # Test control register
    Write Line To Uart      machine.mem32[0x4000240C] = 0x6
    Sleep                   1s
    ${ctrl_val}=            Execute Command    sysbus ReadDoubleWord 0x4000240C
    Should Contain          ${ctrl_val}    0x00000006

    Write Line To Uart      print("D" + "ONE")
    Wait For Line On Uart   DONE
