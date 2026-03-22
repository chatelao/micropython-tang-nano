import machine
import time

def test_power():
    print("Testing machine.idle()...")
    machine.idle()
    print("machine.idle() returned.")

    print("Testing machine.lightsleep(100)...")
    start = time.ticks_ms()
    machine.lightsleep(100)
    end = time.ticks_ms()
    diff = time.ticks_diff(end, start)
    print("lightsleep(100) took", diff, "ms")
    if diff >= 100:
        print("lightsleep(100) OK")
    else:
        print("lightsleep(100) FAILED (too short)")

    print("Testing machine.deepsleep(100)...")
    start = time.ticks_ms()
    machine.deepsleep(100)
    end = time.ticks_ms()
    diff = time.ticks_diff(end, start)
    print("deepsleep(100) took", diff, "ms")
    if diff >= 100:
        print("deepsleep(100) OK")
    else:
        print("deepsleep(100) FAILED (too short)")

    print("Testing machine.lightsleep() without args...")
    # This might hang in simulation if there are no interrupts.
    # But SysTick should be firing every 1ms.
    machine.lightsleep()
    print("lightsleep() returned.")

if __name__ == "__main__":
    test_power()
