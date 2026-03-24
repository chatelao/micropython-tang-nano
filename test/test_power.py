import machine
import time

def test_systick():
    print("Verifying SysTick...")
    t1 = time.ticks_ms()
    time.sleep_ms(50)
    t2 = time.ticks_ms()
    diff = time.ticks_diff(t2, t1)
    print("TICK" + "_CHECK:%d" % diff)
    if diff >= 40:
        print("PASS")
    else:
        print("FAIL: SysTick not advancing correctly")

def test_idle():
    print("Testing machine.idle()...")
    machine.idle()
    print("ID" + "LE_OK")

def test_lightsleep(ms):
    print("Testing machine.lightsleep(%d)..." % ms)
    start = time.ticks_ms()
    machine.lightsleep(ms)
    end = time.ticks_ms()
    diff = time.ticks_diff(end, start)
    print("LS" + "_OK:%d" % diff)
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

def test_reset():
    print("Testing machine.reset()...")
    machine.reset()
    print("FAIL: reset returned (should have reset)")

test_systick()
test_idle()
test_lightsleep(100)
# test_deepsleep and test_reset are usually tested in automated robot scripts
# because they reset the environment.
# test_deepsleep(50)
# test_reset()
