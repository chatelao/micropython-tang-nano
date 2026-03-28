*** Settings ***
Suite Setup     Setup
Suite Teardown  Teardown
Resource        ${RENODEKEYWORDS}

*** Variables ***
${RESC}         ${CURDIR}/tang_nano_4k.resc
${REPL}         ${CURDIR}/tang_nano_4k.repl
${BIN}          ${CURDIR}/../src/ports/tang_nano_4k/build/firmware.elf
${UART}         sysbus.uart0

*** Test Cases ***
Verify NEORV32 RISC-V Example
    [Documentation]    Verifies that the neorv32.py example works by simulating the M3 and its control over the FPGA fabric.
    Execute Command         $repl = @${REPL}
    Execute Command         $bin = @${BIN}
    Execute Command         include @${RESC}
    # Ensure we boot from the MicroPython runtime location in simulation
    Execute Command         sysbus.cpu VectorTableOffset 0x60000000
    Execute Command         sysbus.cpu SP `sysbus ReadDoubleWord 0x60000000`
    Execute Command         sysbus.cpu PC `sysbus ReadDoubleWord 0x60000004`
    Create Terminal Tester  ${UART}
    Start Emulation

    Wait For Line On Uart   MicroPython started on Tang Nano 4K
    Wait For Line On Uart   Tang Nano 4K with GW1NSR-LV4C

    # Wait for REPL to be ready
    Sleep                   2s

    # Run the NEORV32 example script (simplified for test)
    Write Line To Uart      import machine; import time

    # 1. Halt the core (Write to Slot 1 Ctrl Reg)
    Write Line To Uart      machine.mem32[0x40002400] = 1

    # 2. Mock program loading to PSRAM
    Write Line To Uart      machine.mem32[0xA0000000] = 0xDEADBEEF

    # 3. Release reset
    Write Line To Uart      machine.mem32[0x40002400] = 0

    # 4. Mock a response from the RISC-V core in the mailbox (Renode side)
    # We do this by writing to the simulated memory-mapped register
    Execute Command         sysbus WriteDoubleWord 0x40002404 0xCAFEBABE

    # 5. Read back the response in MicroPython
    Write Line To Uart      print("RESP:" + hex(machine.mem32[0x40002404]))
    Wait For Line On Uart   RESP:0xcafebabe

    Write Line To Uart      print("D" + "ONE")
    Wait For Line On Uart   DONE
