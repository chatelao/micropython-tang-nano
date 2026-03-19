import machine
import time

print("Testing machine.Timer...")

# Create a periodic timer that prints a message every 1 second
tim = machine.Timer(0)
tim.init(period=1000, mode=machine.Timer.PERIODIC, callback=lambda t: print("Timer periodic tick"))

print("Timer started. Waiting 3500 ms...")
time.sleep_ms(3500)

print("Deinitializing timer...")
tim.deinit()

# Create a one-shot timer
print("Testing one-shot timer (2000 ms)...")
tim.init(period=2000, mode=machine.Timer.ONE_SHOT, callback=lambda t: print("One-shot timer fired!"))

time.sleep_ms(3000)

print("Testing slot reuse...")
for i in range(10):
    t = machine.Timer(-1)
    t.init(period=100, callback=lambda x: None)
    t.deinit()
print("Slot reuse test passed.")

print("Test complete.")
