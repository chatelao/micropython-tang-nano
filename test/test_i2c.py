import machine
import time

print("Testing SoftI2C instantiation...")
try:
    scl = machine.Pin(0)
    sda = machine.Pin(1)
    i2c = machine.SoftI2C(scl=scl, sda=sda, freq=100000)
    print("SoftI2C object created successfully:", i2c)

    print("Scanning I2C bus...")
    devices = i2c.scan()
    print("Scan complete. Devices found:", devices)

except Exception as e:
    print("Error during SoftI2C test:", e)

print("I2C test script finished.")
