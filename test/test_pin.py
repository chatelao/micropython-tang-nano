import machine
import time

# Initialize Pin 0 as output
led = machine.Pin(0, machine.Pin.OUT)

print("Toggling Pin 0...")
for i in range(10):
    led.value(1)
    print("Pin 0 is ON")
    time.sleep_ms(500)
    led.value(0)
    print("Pin 0 is OFF")
    time.sleep_ms(500)

# Test input mode
in_pin = machine.Pin(1, machine.Pin.IN)
print("Pin 1 value:", in_pin.value())
