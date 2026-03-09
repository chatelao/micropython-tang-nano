import machine
import time

led = machine.Pin(0, machine.Pin.OUT)

print("Starting blink test...")
for i in range(5):
    led.on()
    print("LED ON")
    time.sleep(0.5)
    led.off()
    print("LED OFF")
    time.sleep(0.5)

print("Blink test complete.")
