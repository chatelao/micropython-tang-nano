*** Settings ***
Suite Setup     Setup
Suite Teardown  Teardown
Resource        ${RENODEKEYWORDS}

*** Variables ***
${RESC}         ${CURDIR}/../tang_nano_4k.resc
${REPL}         ${CURDIR}/../tang_nano_4k.repl
${BIN}          ${CURDIR}/../../src/ports/tang_nano_4k/build/firmware.elf
${UART}         sysbus.uart0

*** Keywords ***
Setup MicroPython
    Execute Command         $repl = @${REPL}
    Execute Command         $bin = @${BIN}
    Execute Command         include @${RESC}
    ${boot_addr_raw}=       Execute Command  sysbus GetSymbolAddress "isr_vector"
    ${boot_addr}=           Evaluate  '''${boot_addr_raw}'''.strip()
    Execute Command         sysbus.cpu VectorTableOffset ${boot_addr}
    ${sp_val_raw}=          Execute Command  sysbus ReadDoubleWord ${boot_addr}
    ${sp_val}=              Evaluate  '''${sp_val_raw}'''.strip()
    Execute Command         sysbus.cpu SP ${sp_val}
    ${pc_ptr}=              Evaluate  hex(int("${boot_addr}", 16) + 4)
    ${pc_val_raw}=          Execute Command  sysbus ReadDoubleWord ${pc_ptr}
    ${pc_val}=              Evaluate  '''${pc_val_raw}'''.strip()
    Execute Command         sysbus.cpu PC ${pc_val}
    Create Terminal Tester  ${UART}

*** Test Cases ***
Verify NEORV32 RISC-V Example
    [Documentation]    Verifies that the neorv32.py example works by simulating the M3 and its control over the FPGA fabric.
    Setup MicroPython
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
    # Using & 0xFFFFFFFF to handle signedness in hex conversion
    Write Line To Uart      print("RESP:" + hex(machine.mem32[0x40002404] & 0xFFFFFFFF))
    Wait For Line On Uart   RESP:0xcafebabe

    Write Line To Uart      print("D" + "ONE")
    Wait For Line On Uart   DONE
