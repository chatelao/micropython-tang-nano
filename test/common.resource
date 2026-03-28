*** Settings ***
Resource        ${RENODEKEYWORDS}

*** Keywords ***
Setup MicroPython
    [Arguments]    ${RESC}    ${REPL}    ${BIN}    ${UART}
    Execute Command         $repl = @${REPL}
    Execute Command         $bin = @${BIN}
    Execute Command         include @${RESC}
    ${boot_addr_raw}=       Execute Command  sysbus GetSymbolAddress "isr_vector"
    ${boot_addr}=           Evaluate  '''${boot_addr_raw}'''.strip()
    Log                     Boot Addr: ${boot_addr}
    # For booting, we need to set VTOR, SP and PC manually in Renode
    Execute Command         sysbus.cpu VectorTableOffset ${boot_addr}
    ${sp_val_raw}=          Execute Command  sysbus ReadDoubleWord ${boot_addr}
    ${sp_val}=              Evaluate  '''${sp_val_raw}'''.strip()
    Log                     SP Val: ${sp_val}
    Execute Command         sysbus.cpu SP ${sp_val}
    ${pc_ptr}=              Evaluate  hex(int("${boot_addr}", 16) + 4)
    ${pc_val_raw}=          Execute Command  sysbus ReadDoubleWord ${pc_ptr}
    ${pc_val}=              Evaluate  '''${pc_val_raw}'''.strip()
    Log                     PC Val: ${pc_val}
    Execute Command         sysbus.cpu PC ${pc_val}
    Create Terminal Tester  ${UART}
