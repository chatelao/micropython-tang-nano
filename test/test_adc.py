import machine
import time

def test_adc():
    print("Testing ADC...")

    # Initialize ADC on channel 0
    adc = machine.ADC(0)
    print(adc)

    # Read value
    val = adc.read_u16()
    print("ADC value:", val)

    # Try different channel
    adc3 = machine.ADC(3)
    print(adc3)
    print("ADC3 value:", adc3.read_u16())

    # Test with Pin object
    p = machine.Pin(1)
    adcp = machine.ADC(p)
    print("ADC from Pin(1):", adcp)

    print("ADC test complete")

if __name__ == "__main__":
    test_adc()
