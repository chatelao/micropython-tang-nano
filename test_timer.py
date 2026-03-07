import machine
import time

print("Testing machine.Timer...")

# Create a periodic timer that prints a message every 1 second
tim = machine.Timer(0)
tim.init(period=1000, mode=machine.Timer.PERIODIC, callback=lambda t: print("Timer periodic tick"))

print("Timer started. Waiting 3.5 seconds...")
time.sleep(3.5)

print("Deinitializing timer...")
tim.deinit()

# Create a one-shot timer
print("Testing one-shot timer (2 seconds)...")
tim.init(period=2000, mode=machine.Timer.ONE_SHOT, callback=lambda t: print("One-shot timer fired!"))

time.sleep(3)
print("Test complete.")
