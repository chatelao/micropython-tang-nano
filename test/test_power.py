import machine
import time

def test_idle():
    print("Testing machine.idle()...")
    machine.idle()
    print("ID"+"LE_OK")

def test_lightsleep(ms):
    print("Testing machine.lightsleep(%d)..." % ms)
    start = time.ticks_ms()
    machine.lightsleep(ms)
    end = time.ticks_ms()
    diff = time.ticks_diff(end, start)
    print("LS_OK:%d" % diff)

print("Power Management Test")
test_idle()
test_lightsleep(100)
test_lightsleep(500)
print("Test complete")
