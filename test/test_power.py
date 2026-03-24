import machine
import time

def test_idle():
    print("Testing machine.idle()...")
    machine.idle()
    print("machine.idle() returned.")

def test_lightsleep(ms):
    print("Testing machine.lightsleep(%d)..." % ms)
    start = time.ticks_ms()
    machine.lightsleep(ms)
    end = time.ticks_ms()
    diff = time.ticks_diff(end, start)
    print("Slept for %d ms" % diff)
    if diff >= 90: # Allow some jitter in simulation
        print("PASS")
    else:
        print("FAIL: Slept for too little time")

def test_deepsleep(ms):
    print("Testing machine.deepsleep(%d)..." % ms)
    print("WARNING: This will cause a system reset!")
    # No point in measuring time here as we won't return
    machine.deepsleep(ms)
    print("FAIL: deepsleep returned (should have reset)")

test_idle()
test_lightsleep(100)
# test_deepsleep is usually tested in automated robot scripts
# because it resets the environment.
# test_deepsleep(100)
