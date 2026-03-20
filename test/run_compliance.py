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
    # renode-test-action adds Renode to PATH
    # Redirect output to prevent pipe buffer exhaustion
    log_file = open("renode.log", "w")
    renode_proc = subprocess.Popen(["renode", "test/compliance.resc", "--no-gui"], stdout=log_file, stderr=log_file)

    # Wait for Renode to start and port 12345 to be open
    if not wait_for_port('localhost', 12345):
        print("Error: Renode terminal server failed to start on port 12345")
        os.kill(renode_proc.pid, signal.SIGTERM)
        sys.exit(1)

    # 3. Run MicroPython tests
    print("Running MicroPython compliance tests...")

    # We use pyboard.py to run tests via the socket bridge
    # Need to specify the target device for run-tests.py
    # From run-tests.py: test_instance can be exec:command
    socket_bridge_abs = os.path.abspath(os.path.join('test', 'socket_bridge.py'))
    target = f"exec:{sys.executable} {socket_bridge_abs}"

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

    # Official run-tests.py in this repo has -r for results dir
    cmd = [
        sys.executable, "run-tests.py",
        "-t", target, # Use absolute target
        "-r", os.path.abspath(result_dir),
    ] + test_dirs

    try:
        proc = subprocess.run(cmd, capture_output=True, text=True, cwd=tests_cwd)
        test_output = proc.stdout
        print(test_output)
        test_returncode = proc.returncode
    finally:
        # 4. Stop Renode
        print("Stopping Renode...")
        os.kill(renode_proc.pid, signal.SIGTERM)
        log_file.close()

    # 5. Generate report
    print("Generating COMLIANCE_TESTS.md report...")
    results_json = os.path.join(result_dir, "_results.json")

    report = "# MicroPython Compliance Test Report\n\n"
    report += f"Generated on: {time.strftime('%Y-%m-%d %H:%M:%S')}\n\n"

    all_passed = False
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
                if passed:
                    all_passed = True
    else:
        # Fallback to parsing stdout if JSON is not present
        import re
        report += "## Test Summary (Parsed from Output)\n\n"
        # run-tests.py output format: "pass  path/to/test.py" or "fail  path/to/test.py"
        # Also handles "skip  path/to/test.py" and "lrge  path/to/test.py"
        passed_matches = re.findall(r"^pass\s+.+", test_output, re.MULTILINE | re.IGNORECASE)
        failed_matches = re.findall(r"^fail\s+.+", test_output, re.MULTILINE | re.IGNORECASE)
        skipped_matches = re.findall(r"^(skip|lrge)\s+.+", test_output, re.MULTILINE | re.IGNORECASE)

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
        else:
            if passed_count > 0:
                all_passed = True

    with open("COMLIANCE_TESTS.md", "w") as f:
        f.write(report)

    print("Compliance report generated.")

    # Fail the script if tests failed or no tests were run
    if not all_passed or test_returncode != 0:
        print("Compliance tests FAILED.")
        sys.exit(1)

if __name__ == "__main__":
    run_compliance()
