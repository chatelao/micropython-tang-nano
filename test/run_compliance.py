#!/usr/bin/env python3
# test/run_compliance.py

import os
import subprocess
import time
import signal
import sys
import json

def wait_for_port(host, port, timeout=30):
    start_time = time.time()
    import socket
    while time.time() - start_time < timeout:
        try:
            with socket.create_connection((host, port), timeout=1):
                return True
        except (OSError, ConnectionRefusedError):
            time.sleep(0.5)
    return False

def run_compliance():
    # 1. Build firmware (Optional: check if already exists)
    firmware = "src/ports/tang_nano_4k/build/firmware.elf"
    if not os.path.exists(firmware):
        print("Building firmware...")
        subprocess.run(["make", "-C", "src/ports/tang_nano_4k/", "SIMULATION=1"], check=True)
    else:
        print(f"Using existing firmware: {firmware}")

    # 2. Start Renode in background
    print("Starting Renode...")
    renode_proc = subprocess.Popen(["renode", "test/compliance.resc", "--no-gui"], stdout=subprocess.PIPE, stderr=subprocess.PIPE)

    # Wait for Renode to start and port 12345 to be open
    if not wait_for_port('localhost', 12345):
        print("Error: Renode terminal server failed to start on port 12345")
        os.kill(renode_proc.pid, signal.SIGTERM)
        sys.exit(1)

    # 3. Run MicroPython tests
    print("Running MicroPython compliance tests...")
    test_env = os.environ.copy()
    test_env["MICROPY_MICROPYTHON"] = "src/ports/tang_nano_4k/build/firmware.elf"

    # We use pyboard.py to run tests via the socket bridge
    # Need to specify the target device for run-tests.py
    # From run-tests.py: test_instance can be exec:command
    socket_bridge_cmd = f"python3 {os.path.join('test', 'socket_bridge.py')}"
    target = f"exec:{socket_bridge_cmd}"

    # Official run-tests.py path
    run_tests_py = "src/lib/micropython/tests/run-tests.py"

    # We run a subset of tests to save time in CI, or all if desired
    # For now, let's run basics, micropython, and float
    test_dirs = ["basics", "micropython", "float", "extmod"]

    result_dir = "test_results"
    os.makedirs(result_dir, exist_ok=True)

    # Change current working directory to the tests folder
    # to let run-tests.py find the tests correctly
    tests_cwd = os.path.dirname(run_tests_py)
    # Adjust target path since it will be relative to tests_cwd
    socket_bridge_rel = os.path.relpath(os.path.join(os.getcwd(), 'test', 'socket_bridge.py'), tests_cwd)
    target_rel = f"exec:python3 {socket_bridge_rel}"

    cmd = [
        sys.executable, "run-tests.py",
        "-t", target_rel,
        "-r", os.path.abspath(result_dir),
    ] + test_dirs

    try:
        proc = subprocess.run(cmd, capture_output=True, text=True, cwd=tests_cwd)
        test_output = proc.stdout
        print(test_output)
    except Exception as e:
        print(f"Error running tests: {e}")
        test_output = f"Error: {e}"

    # 4. Stop Renode
    print("Stopping Renode...")
    os.kill(renode_proc.pid, signal.SIGTERM)

    # 5. Generate report
    print("Generating COMLIANCE_TESTS.md report...")
    results_json = os.path.join(result_dir, "_results.json")

    report = "# MicroPython Compliance Test Report\n\n"
    report += f"Generated on: {time.strftime('%Y-%m-%d %H:%M:%S')}\n\n"

    if os.path.exists(results_json):
        with open(results_json, "r") as f:
            data = json.load(f)
            results = data.get("results", [])

            passed = [r for r in results if r[1] == "pass"]
            failed = [r for r in results if r[1] == "fail"]
            skipped = [r for r in results if r[1] == "skip"]

            report += "## Summary\n\n"
            report += f"- **Passed:** {len(passed)}\n"
            report += f"- **Failed:** {len(failed)}\n"
            report += f"- **Skipped:** {len(skipped)}\n"
            report += f"- **Total:** {len(results)}\n\n"

            if failed:
                report += "## Failed Tests\n\n"
                for f_test in failed:
                    report += f"- {f_test[0]}\n"
                report += "\n"
    else:
        # Fallback to parsing stdout if JSON is not present (though run-tests.py should create it with -r)
        import re
        report += "## Test Summary (Parsed from Output)\n\n"
        # Match "pass  path/to/test.py" or "FAIL  path/to/test.py"
        # Using regex to avoid false positives in paths or messages
        passed_matches = re.findall(r"^pass\s+\S+", test_output, re.MULTILINE)
        failed_matches = re.findall(r"^FAIL\s+\S+", test_output, re.MULTILINE)
        skipped_matches = re.findall(r"^skip\s+\S+", test_output, re.MULTILINE)

        passed_count = len(passed_matches)
        failed_count = len(failed_matches)
        skipped_count = len(skipped_matches)

        report += f"- **Passed:** {passed_count}\n"
        report += f"- **Failed:** {failed_count}\n"
        report += f"- **Skipped:** {skipped_count}\n\n"

        if failed_count > 0:
            report += "## Failed Tests\n\n"
            for line in failed_matches:
                report += f"- {line.strip()}\n"
            report += "\n"

    with open("COMLIANCE_TESTS.md", "w") as f:
        f.write(report)

    print("Compliance report generated.")

if __name__ == "__main__":
    run_compliance()
