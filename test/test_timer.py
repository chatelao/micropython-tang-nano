import machine
import time

print("Testing machine.Ti" + "mer...")

# Create a periodic timer that prints a message every 1 second
tim = machine.Timer(0)
tim.init(period=1000, mode=machine.Timer.PERIODIC, callback=lambda t: print("Timer periodic ti" + "ck"))

print("Timer started. Waiting 3500ms...")
time.sleep_ms(3500)

print("Deinitializing ti" + "mer...")
tim.deinit()

# Create a one-shot timer
print("Testing one-shot timer (2000ms)...")
tim.init(period=2000, mode=machine.Timer.ONE_SHOT, callback=lambda t: print("One-shot timer fi" + "red!"))

time.sleep_ms(3000)

print("Testing slot reuse...")
for i in range(10):
    t = machine.Timer(-1)
    t.init(period=100, callback=lambda x: None)
    t.deinit()
print("Slot reuse test pas" + "sed.")

print("Test compl" + "ete.")
