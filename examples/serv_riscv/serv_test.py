import machine
import time

# SERV is mapped to APB2 Slot 10
SERV_BASE = 0x40002D00
REG_CTRL   = SERV_BASE + 0x00
REG_STATUS = SERV_BASE + 0x04
REG_RESULT = SERV_BASE + 0x08
IMEM_BASE  = SERV_BASE + 0x40

print("SERV RISC-V Core Test")

# 1. Reset the core
machine.mem32[REG_CTRL] = 0x01
print("SERV Core Reset")

# 2. Load a simple RISC-V program into instruction memory
# This program performs:
#   addi a0, zero, 42  (0x02a00513)
#   ebreak             (0x00100073)
program = [
    0x02a00513, # addi a0, x0, 42
    0x00100073  # ebreak (halts the simulation core)
]

print("Loading RISC-V program...")
for i, instr in enumerate(program):
    machine.mem32[IMEM_BASE + (i * 4)] = instr

# 3. Start the core
print("Starting SERV core...")
machine.mem32[REG_CTRL] = 0x02 # Clear Reset, Set Enable

# 4. Wait for the core to halt
timeout = 100
halted = False
while timeout > 0:
    status = machine.mem32[REG_STATUS]
    if status & 0x01:
        halted = True
        break
    time.sleep_ms(10)
    timeout -= 1

if halted:
    # 5. Read the result from RISC-V 'a0' register
    result = machine.mem32[REG_RESULT]
    print("SERV Halted. Result (a0): {}".format(result))
    if result == 42:
        print("TEST PASSED")
    else:
        print("TEST FAILED: Unexpected result")
else:
    print("TEST FAILED: Timeout waiting for SERV to halt")
