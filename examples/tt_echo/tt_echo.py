import time
import tt

print("Tiny Tapeout Echo Test (via APB2)")

# 1. Initialize: De-assert reset, Enable design
tt.tt_init()
print("TT Module Initialized (Reset released, Enabled)")

# Test values
test_values = [0xAA, 0x55, 0x00, 0xFF, 0x12]

for val in test_values:
    # Use the helper send() to write the 8-bit value to 'ui_in'
    # and toggle the clock for synchronous designs.
    # Returns the 'uo_out' value after the clock pulse.
    received = tt.send(val)

    if received == val:
        print("Sent: 0x{:02X}, Received: 0x{:02X} - MATCH".format(val, received))
    else:
        print("Sent: 0x{:02X}, Received: 0x{:02X} - MISMATCH".format(val, received))

    time.sleep_ms(100)

# Demonstrate reading the UIO value from the FPGA
# In the minimal echo design, UIO is set to 0xAC and all bits are outputs (OE=0xFF)
uio_val = tt.get_uio()
uio_oe  = tt.get_uoe()

print("UIO Value: 0x{:02X}, UIO OE: 0x{:02X}".format(uio_val, uio_oe))

# Demonstrate manual clock control (slow debugging)
print("Toggling clock 5 times...")
for _ in range(5):
    tt.set_clock(True)
    time.sleep_ms(50)
    tt.set_clock(False)
    time.sleep_ms(50)
print("Clock toggling complete")

print("Test Complete")
