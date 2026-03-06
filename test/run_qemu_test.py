import subprocess
import time
import sys
import os
import select

def run_qemu_test():
    elf_file = "src/ports/tang_nano_4k/build/firmware.elf"
    if not os.path.exists(elf_file):
        print(f"Error: ELF file not found at {elf_file}")
        return False

    qemu_cmd = [
        "qemu-system-arm",
        "-M", "mps2-an385",
        "-cpu", "cortex-m3",
        "-kernel", elf_file,
        "-nographic",
        "-monitor", "none",
        "-serial", "stdio"
    ]

    print(f"Starting QEMU with command: {' '.join(qemu_cmd)}")
    # Use unbuffered output
    process = subprocess.Popen(qemu_cmd, stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, bufsize=0)

    start_time = time.time()
    timeout = 15
    output = b""

    try:
        while time.time() - start_time < timeout:
            r, _, _ = select.select([process.stdout], [], [], 0.1)
            if r:
                chunk = process.stdout.read(1024)
                if chunk:
                    output += chunk
                    sys.stdout.buffer.write(chunk)
                    sys.stdout.buffer.flush()

                    if b">>>" in output or (b">" in output and b"MicroPython" in output):
                        print("\nREPL prompt detected!")
                        return True

            if process.poll() is not None:
                print("\nQEMU process exited early.")
                break
    except Exception as e:
        print(f"\nError during QEMU execution: {e}")
    finally:
        process.terminate()
        try:
            process.wait(timeout=2)
        except subprocess.TimeoutExpired:
            process.kill()

    print("\nTimeout or process ended without detecting REPL prompt.")
    print("Full output captured so far:")
    print(output)
    return False

if __name__ == "__main__":
    if run_qemu_test():
        print("Test PASSED")
        sys.exit(0)
    else:
        print("Test FAILED")
        sys.exit(1)
