import machine
import time

# Tiny Tapeout is mapped to APB2 Slot 1
TT_BASE  = 0x40002400
REG_DATA = TT_BASE + 0x00
REG_UIO  = TT_BASE + 0x04
REG_OE   = TT_BASE + 0x08
REG_CTRL = TT_BASE + 0x0C

print("Tiny Tapeout Echo Test (via APB2)")

# 1. Initialize: De-assert reset, Enable design
# CTRL: [0]=clk, [1]=rst_n, [2]=ena
machine.mem32[REG_CTRL] = 0x6 # rst_n=1, ena=1, clk=0
print("TT Module Initialized (Reset released, Enabled)")

# Test values
test_values = [0xAA, 0x55, 0x00, 0xFF, 0x12]

for val in test_values:
    # Write the 8-bit value to 'ui_in' via the DATA register
    machine.mem32[REG_DATA] = val

    # For synchronous designs, we would toggle the clock here:
    # machine.mem32[REG_CTRL] |= 0x1  # clk=1
    # machine.mem32[REG_CTRL] &= ~0x1 # clk=0

    # Read back the value from 'uo_out' via the DATA register
    # In this minimal echo design, 'uo_out' is connected back to 'ui_in'
    received = machine.mem32[REG_DATA] & 0xFF

    if received == val:
        print("Sent: 0x{:02X}, Received: 0x{:02X} - MATCH".format(val, received))
    else:
        print("Sent: 0x{:02X}, Received: 0x{:02X} - MISMATCH".format(val, received))

    time.sleep_ms(100)

# Demonstrate reading the UIO value from the FPGA
# In the minimal echo design, UIO is set to 0xAC and all bits are outputs (OE=0xFF)
uio_val = machine.mem32[REG_UIO] & 0xFF
uio_oe  = machine.mem32[REG_OE] & 0xFF

print("UIO Value: 0x{:02X}, UIO OE: 0x{:02X}".format(uio_val, uio_oe))

# Demonstrate manual clock control (slow debugging)
print("Toggling clock 5 times...")
for _ in range(5):
    machine.mem32[REG_CTRL] |= 0x1
    time.sleep_ms(50)
    machine.mem32[REG_CTRL] &= ~0x1
    time.sleep_ms(50)
print("Clock toggling complete")

print("Test Complete")
