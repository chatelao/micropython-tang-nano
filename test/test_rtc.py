import machine
import time

rtc = machine.RTC()
# Set to 2024-01-01 12:00:00 (Monday)
# (year, month, day, weekday, hour, minute, second, subseconds)
rtc.datetime((2024, 1, 1, 1, 12, 0, 0, 0))
print("RTC set")

# Read it back
dt = rtc.datetime()
print("RTC datetime:", dt)

# Wait a bit (in simulation we might need to manually advance the clock if we want to see it change,
# but here we just check if it was set correctly)
# In Renode Memory.MappedMemory won't auto-increment unless we write to it from outside.
