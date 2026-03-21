import machine
import time

def test_pin_irq():
    print("Testing Pin IRQ...")

    # We'll use Pin 0 as an example.
    # In Renode simulation, we can trigger this by setting the pin value
    # from the "outside" (the tester).
    p0 = machine.Pin(0, machine.Pin.IN)

    irq_count = 0
    def handler(pin):
        nonlocal irq_count
        irq_count += 1
        print("IRQ triggered on pin", pin)

    p0.irq(handler=handler, trigger=machine.Pin.IRQ_RISING)

    print("WAITING FOR IRQ")

    # The Robot Framework test will trigger the IRQ here by changing Pin 0 state
    # We wait for a bit
    start = time.ticks_ms()
    while irq_count == 0 and time.ticks_diff(time.ticks_ms(), start) < 5000:
        time.sleep_ms(100)

    if irq_count > 0:
        print("PIN IRQ TEST PASSED")
    else:
        print("PIN IRQ TEST FAILED: Timeout waiting for IRQ")

if __name__ == "__main__":
    test_pin_irq()
