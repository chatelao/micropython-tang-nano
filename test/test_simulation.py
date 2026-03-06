import subprocess
import time
import sys

def run_test():
    resc_file = "test/tang_nano_4k.resc"
    # Renode command for portable version
    renode_bin = "renode"

    print(f"Starting Renode simulation with {resc_file}...")
    # We use --disable-xwt and --headless
    cmd = [renode_bin, "--headless", "--disable-xwt", "-e", f"s @{resc_file}"]

    process = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)

    start_time = time.time()
    timeout = 30
    found = False

    print("Monitoring output for MicroPython REPL prompt...")
    while time.time() - start_time < timeout:
        line = process.stdout.readline()
        if not line:
            break
        print(line, end='')
        if ">>>" in line:
            found = True
            print("\nSuccess: MicroPython REPL prompt found!")
            break

    process.terminate()
    if not found:
        print("\nFailure: MicroPython REPL prompt not found within timeout.")
    return found

if __name__ == "__main__":
    if not run_test():
        sys.exit(1)
