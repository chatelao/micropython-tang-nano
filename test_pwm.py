from machine import PWM, Pin
import time

print("Testing PWM...")

# Initialize PWM on Pin 0
pwm0 = PWM(Pin(0))
print("PWM on Pin 0:", pwm0)

# Set frequency
pwm0.freq(2000)
print("Frequency set to 2000:", pwm0.freq())

# Set duty cycle
pwm0.duty(256) # 25% duty cycle
print("Duty cycle set to 256:", pwm0.duty())

# Re-init with parameters
pwm0.init(freq=500, duty=512)
print("PWM after init(freq=500, duty=512):", pwm0)

# Test multiple PWMs
pwm1 = PWM(1)
pwm1.init(freq=1000, duty=100)
print("PWM on Pin 1:", pwm1)

# Deinit
pwm0.deinit()
pwm1.deinit()
print("PWM deinitialized")
