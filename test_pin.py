import machine
import time

# Initialize Pin 0 as output
led = machine.Pin(0, machine.Pin.OUT)

print("Toggling Pin 0...")
for i in range(2):
    led.value(1)
    print("Pin 0 is ON")
    time.sleep(0.1)
    led.value(0)
    print("Pin 0 is OFF")
    time.sleep(0.1)

# Test input mode
in_pin = machine.Pin(1, machine.Pin.IN)
print("Pin 1 value:", in_pin.value())
