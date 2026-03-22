import subprocess
import os
import sys
import time
import socket

def wait_for_port(port, timeout=60):
    start_time = time.time()
    while True:
        try:
            with socket.create_connection(("127.0.0.1", port), timeout=1):
                return True
        except (ConnectionRefusedError, socket.timeout):
            if time.time() - start_time > timeout:
                return False
            time.sleep(1)

def run_compliance(attach=False):
    renode_proc = None
    root_dir = os.getcwd()

    # 1. Build Reference Unix Port if not exists
    unix_port_dir = os.path.join(root_dir, "src/lib/micropython/ports/unix")
    unix_bin = os.path.join(unix_port_dir, "build-standard/micropython")
    if not os.path.exists(unix_bin):
        print("Building Reference MicroPython Unix port...")
        subprocess.run(["make", "-C", unix_port_dir, "aarch64=0", "MICROPY_PY_SSL=0", "MICROPY_PY_BTREE=0", "FROZEN_MANIFEST=", "-j"], check=True)

    if not attach:
        # Start Renode in the background
        resc_path = os.path.join(root_dir, "test/compliance.resc")
        if not os.path.exists("src/ports/tang_nano_4k/build/firmware.elf"):
             print("Firmware not found, build it first.")
             sys.exit(1)

        # In CI, we use xvfb-run for Renode if needed, but for local run, 'renode' should suffice
        renode_cmd = ["renode", "--disable-gui", "-e", f"include @{resc_path}"]
        print(f"Starting Renode: {' '.join(renode_cmd)}")
        renode_proc = subprocess.Popen(renode_cmd, stdout=open("renode_output.log", "w"), stderr=subprocess.STDOUT)

        if not wait_for_port(12345):
            print("Renode failed to start terminal server on port 12345")
            renode_proc.kill()
            sys.exit(1)

    # Run micropython tests
    test_dir = os.path.join(root_dir, "src/lib/micropython/tests")
    run_tests_py = os.path.join(test_dir, "run-tests.py")

    # Use socket_bridge.py as the device executor
    bridge_script = os.path.join(root_dir, "test/socket_bridge.py")
    device_cmd = f"python3 {bridge_script}"

    # Run tests from the test directory
    print(f"Running tests in {test_dir}...")
    cmd = [
        "python3", "run-tests.py",
        "-t", f"exec:{device_cmd}",
        "-d", "basics", "micropython", "float"
    ]

    with open(os.path.join(root_dir, "compliance_output.log"), "w") as out:
        result = subprocess.run(cmd, stdout=out, stderr=subprocess.STDOUT, text=True, cwd=test_dir)

    # Generate COMLIANCE_TESTS.md (sic)
    with open(os.path.join(root_dir, "COMLIANCE_TESTS.md"), "w") as f:
        f.write("# MicroPython Compliance Test Results\n\n")
        f.write("```\n")
        with open(os.path.join(root_dir, "compliance_output.log"), "r") as log:
            f.write(log.read())
        f.write("\n```\n")

    if renode_proc:
        renode_proc.kill()

    if result.returncode != 0:
        print("Some tests failed. Check COMLIANCE_TESTS.md for details.")
    else:
        print("All tests passed.")

if __name__ == "__main__":
    attach = "--attach" in sys.argv
    run_compliance(attach=attach)
