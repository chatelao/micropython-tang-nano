import machine
import time

# NEORV32 RISC-V Co-processor Example
# This script demonstrates how the ARM Cortex-M3 (Hard Core) can control
# and communicate with a NEORV32 RISC-V core implemented in the FPGA fabric.

# 1. Configuration
# APB2 Slot 1: Control & Status Registers
# 0x40002400: Control Register (Bit 0: Reset, 1: Halt)
# 0x40002404: Mailbox Register (M3 Read-only, NEORV32 Write-only)
# 0x40002408: Mailbox Register (M3 Write-only, NEORV32 Read-only)
NEORV32_CTRL    = 0x40002400
NEORV32_MBX_IN  = 0x40002404  # Input to M3 from RISC-V
NEORV32_MBX_OUT = 0x40002408  # Output from M3 to RISC-V

# Shared Memory (PSRAM)
# The RISC-V core's instruction and data buses are connected to the PSRAM.
# We'll use the base of the PSRAM to load the RISC-V program.
RISCV_BASE = 0xA0000000

print("NEORV32 Co-processor Integration Example")

# 2. Halt the RISC-V core before loading code
print("Halting NEORV32...")
machine.mem32[NEORV32_CTRL] = 0x01

# 3. Load a simple RISC-V program into PSRAM
# In a real application, you would read this from a file.
# For this example, we'll write a mock program (simulating 'riscv_prog.bin').
print("Loading RISC-V program into PSRAM...")
# Mock binary data for a simple RISC-V loop
# (Typically, you would use: with open('riscv_prog.bin', 'rb') as f: ...)
mock_binary = [0xDEADBEEF, 0x12345678, 0x87654321, 0x00000000]
for i, word in enumerate(mock_binary):
    machine.mem32[RISCV_BASE + (i * 4)] = word

# 4. Release the RISC-V core from reset
print("Starting NEORV32...")
machine.mem32[NEORV32_CTRL] = 0x00

# 5. Communication Loop
print("Monitoring Mailbox (Ctrl+C to stop)...")
try:
    count = 0
    while True:
        # Send a heartbeat/command to the RISC-V core
        machine.mem32[NEORV32_MBX_OUT] = count

        # Read the response from the RISC-V mailbox
        # In this example's logic, the RISC-V core would process our command
        # and write a response to its mailbox register.
        response = machine.mem32[NEORV32_MBX_IN]

        print("M3 Heartbeat: {:d} | NEORV32 Response: 0x{:08X}".format(count, response))

        count += 1
        time.sleep(2)
except KeyboardInterrupt:
    print("\nStopping Example...")
    # Halt the core on exit
    machine.mem32[NEORV32_CTRL] = 0x01

print("Example Complete")
