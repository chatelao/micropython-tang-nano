from machine import I2C
import time

def test_hw_i2c():
    print("Testing Hardware I2C...")
    # Initialize Hardware I2C (I2C 0 is mapped to hardware registers)
    try:
        i2c = I2C(freq=100000)
        print("Hardware I2C initialized")

        # Scan (In simulation with MappedMemory it will read all zeros/ones and likely return nothing or all)
        # But we want to see it doesn't crash
        print("Scanning I2C bus...")
        devices = i2c.scan()
        print("Scan complete, devices found:", devices)

        print("HW_I2C_OK")
    except Exception as e:
        print("HW_I2C_FAIL:", e)

if __name__ == "__main__":
    test_hw_i2c()
