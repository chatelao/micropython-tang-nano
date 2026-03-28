import machine
import time

# Create a bridge object to communicate with the FPGA
bridge = machine.FPGABridge()

print("Tiny Tapeout Echo Test")

# Test values
test_values = [0xAA, 0x55, 0x00, 0xFF, 0x12]

for val in test_values:
    # Write the 8-bit value to the FPGA via the GPIO bridge
    # In a real Tiny Tapeout design on Tang Nano 4K, these bits would be
    # routed to the 'ui_in' pins of the design.
    bridge.write(val)

    # Read back the value from the FPGA
    # In this minimal echo design, 'uo_out' is connected back to the bridge
    # so we should read the same value back.
    received = bridge.read() & 0xFF

    if received == val:
        print("Sent: 0x{:02X}, Received: 0x{:02X} - MATCH".format(val, received))
    else:
        print("Sent: 0x{:02X}, Received: 0x{:02X} - MISMATCH".format(val, received))

    time.sleep_ms(100)

print("Test Complete")
