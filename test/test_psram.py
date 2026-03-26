import gc
import machine

def test_psram():
    print("Testing PSRAM allocation...")

    # Check initial memory status
    gc.collect()
    free_start = gc.mem_free()
    alloc_start = gc.mem_alloc()
    print("Initial - Free: %d, Alloc: %d" % (free_start, alloc_start))

    # The internal SRAM heap is ~20KB.
    # Let's allocate something much larger than that to force usage of PSRAM.
    # 1MB allocation
    try:
        size = 1024 * 1024
        buf = bytearray(size)
        print("Allocated 1MB buffer")

        # Verify we can write and read back
        for i in range(100):
            buf[i] = i

        for i in range(100):
            if buf[i] != i:
                print("Verification failed at index %d" % i)
                return False

        print("Verification successful")

        gc.collect()
        free_after = gc.mem_free()
        alloc_after = gc.mem_alloc()
        print("After 1MB - Free: %d, Alloc: %d" % (free_after, alloc_after))

        if alloc_after < size:
            print("Allocation size mismatch!")
            return False

    except MemoryError:
        print("MemoryError: Could not allocate 1MB. PSRAM might not be working.")
        return False

    return True

if __name__ == "__main__":
    if test_psram():
        print("PSRAM_OK")
    else:
        print("PSRAM_FAIL")
