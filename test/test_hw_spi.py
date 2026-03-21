# test_hw_spi.py
from machine import SPI, Pin
import time

def test_spi():
    print("Testing Hardware SPI...")

    # Initialize SPI
    # In simulation, we just want to see it doesn't crash and registers are accessed
    spi = SPI(0, baudrate=1000000, polarity=0, phase=0)
    print("SPI initialized:", spi)

    # Test write
    spi.write(b'\x55\xAA')
    print("SPI write done")

    # Test read
    data = spi.read(2)
    print("SPI read:", data)

    # Test readinto
    buf = bytearray(2)
    spi.readinto(buf)
    print("SPI readinto:", buf)

    # Test write_readinto
    write_buf = b'\x12\x34'
    read_buf = bytearray(2)
    spi.write_readinto(write_buf, read_buf)
    print("SPI write_readinto:", read_buf)

if __name__ == "__main__":
    test_spi()
