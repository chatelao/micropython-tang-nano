import machine
import time

# Pin Mapping:
# Pin 0 -> Internal GPIO 0 -> Physical Pin 10 (LED)
# Pin 1 -> Internal GPIO 1 -> Physical Pin 15 (Button 1)
# Pin 2 -> Internal GPIO 2 -> Physical Pin 14 (Button 2)

led = machine.Pin(0, machine.Pin.OUT)
btn1 = machine.Pin(1, machine.Pin.IN)
btn2 = machine.Pin(2, machine.Pin.IN)

print("Starting adaptive blink...")
print("- Normal speed: No buttons pressed")
print("- Fast speed: One button pressed")
print("- Very fast speed: Both buttons pressed")

while True:
    # Buttons on Tang Nano 4K are active-low (0 when pressed)
    b1_pressed = (btn1.value() == 0)
    b2_pressed = (btn2.value() == 0)

    if b1_pressed and b2_pressed:
        delay = 50   # Very fast
    elif b1_pressed or b2_pressed:
        delay = 200  # Fast
    else:
        delay = 500  # Normal

    led.on()
    time.sleep_ms(delay)
    led.off()
    time.sleep_ms(delay)
