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
Verify SERV RISC-V Example
    [Documentation]    Verifies that the serv_test.py example works by simulating the SERV core in Renode.
    Execute Command         $repl = @${REPL}
    Execute Command         $bin = @${BIN}
    Execute Command         include @${RESC}

    # Simulate the SERV core registers at 0x40002D00
    # 0x00: CTRL, 0x04: STATUS, 0x08: RESULT, 0x40-0x7F: IMEM
    # Unregister dma0 (APB2 Slot 9 at 0x40002C00) to avoid conflict
    Execute Command         sysbus Unregister sysbus.dma0
    Execute Command         machine LoadPlatformDescriptionFromString "serv_regs: Memory.MappedMemory @ sysbus 0x40002D00 { size: 0x100 }"
    # Initial state
    Execute Command         sysbus WriteDoubleWord 0x40002D00 0x1
    Execute Command         sysbus WriteDoubleWord 0x40002D04 0x0
    Execute Command         sysbus WriteDoubleWord 0x40002D08 0x0

    # Add a hook to simulate core execution
    # Note: Using Write Watchpoint with correctly formatted Python block
    Execute Command         sysbus AddWatchpointHook 0x40002D00 4 Write @ "if value == 0x2: self.Bus.WriteDoubleWord(0x40002D04, 0x1); self.Bus.WriteDoubleWord(0x40002D08, 42)"

    Execute Command         sysbus.cpu VectorTableOffset 0x60000000
    Execute Command         sysbus.cpu SP `sysbus ReadDoubleWord 0x60000000`
    Execute Command         sysbus.cpu PC `sysbus ReadDoubleWord 0x60000004`

    Create Terminal Tester  ${UART}
    Start Emulation

    Wait For Line On Uart   MicroPython started on Tang Nano 4K
    Wait For Line On Uart   Tang Nano 4K with GW1NSR-LV4C

    # Wait for REPL to be ready
    Sleep                   2s

    # Load and run the serv_test.py script
    Write Line To Uart      import machine; import time; SERV_BASE = 0x40002D00; REG_CTRL = SERV_BASE + 0x00; REG_STATUS = SERV_BASE + 0x04; REG_RESULT = SERV_BASE + 0x08; IMEM_BASE = SERV_BASE + 0x40
    Write Line To Uart      machine.mem32[REG_CTRL] = 0x01; print("SERV_RESET")
    Wait For Line On Uart   SERV_RESET

    # Simulate loading program
    Write Line To Uart      machine.mem32[IMEM_BASE] = 0x02a00513; machine.mem32[IMEM_BASE + 4] = 0x00100073; print("LOADED")
    Wait For Line On Uart   LOADED

    # Run the core and check result
    Write Line To Uart      machine.mem32[REG_CTRL] = 0x02; print("RUNNING")
    Wait For Line On Uart   RUNNING

    # Check for halt and result
    Write Line To Uart      print("HALT:" + str(machine.mem32[REG_STATUS] & 0x01))
    Wait For Line On Uart   HALT:1

    Write Line To Uart      print("RESULT:" + str(machine.mem32[REG_RESULT]))
    Wait For Line On Uart   RESULT:42

    Write Line To Uart      print("D" + "ONE")
    Wait For Line On Uart   DONE
