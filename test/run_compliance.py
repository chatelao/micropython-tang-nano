import subprocess
import time
import os
import sys
import json
import re

def main():
    # Paths are relative to the repository root
    repo_root = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
    # In CI, we clone it to src/lib/micropython
    micropython_tests_dir = os.path.join(repo_root, "src/lib/micropython/tests")
    # In some local checkouts it might be at the root
    if not os.path.exists(micropython_tests_dir):
        micropython_tests_dir = os.path.join(repo_root, "micropython_core/tests")

    bridge_script = os.path.abspath(os.path.join(repo_root, "test/socket_bridge.py"))
    resc_file = os.path.abspath(os.path.join(repo_root, "test/compliance.resc"))
    report_file = os.path.join(repo_root, "COMLIANCE_TESTS.md")

    print(f"Starting Renode with {resc_file}...")
    # Start Renode in the background
    # --plain to avoid ANSI escapes and --port -1 to disable telnet if possible, but standard is just background
    renode_proc = subprocess.Popen(["renode", resc_file, "--disable-xwt"], stdout=subprocess.PIPE, stderr=subprocess.PIPE)

    # Wait for Renode to start and port to be open
    time.sleep(10) # Give Renode enough time to start and open the socket

    # Command to run tests
    # run-tests.py will be executed from its own directory
    test_cmd = [
        sys.executable,
        "run-tests.py",
        "--target", "pyboard",
        "--device", f"exec:{sys.executable} {bridge_script} 127.0.0.1 12345",
        "-d", "basics", "micropython", "misc"
    ]

    print(f"Running compliance tests in {micropython_tests_dir}...")
    try:
        # result_dir defaults to 'results' relative to run-tests.py
        result = subprocess.run(test_cmd, cwd=micropython_tests_dir, capture_output=True, text=True)
        print(result.stdout)
        print(result.stderr, file=sys.stderr)

        # Parse results from stdout
        # Example output: "X tests performed (Y individual testcases)\nZ tests passed"
        passed_match = re.search(r"(\d+) tests passed", result.stdout)
        performed_match = re.search(r"(\d+) tests performed", result.stdout)

        passed_count = int(passed_match.group(1)) if passed_match else 0
        performed_count = int(performed_match.group(1)) if performed_match else 0

        # Read _results.json for failed tests
        results_json_path = os.path.join(micropython_tests_dir, "results/_results.json")
        failed_tests = []
        if os.path.exists(results_json_path):
            with open(results_json_path, "r") as f:
                res_data = json.load(f)
                failed_tests = res_data.get("failed_tests", [])

        failed_count = len(failed_tests)
        skipped_count = performed_count - passed_count - failed_count

        # Generate COMLIANCE_TESTS.md
        with open(report_file, "w") as f:
            f.write("# Compliance Test Report\n\n")
            f.write("## Summary\n\n")
            f.write(f"| Status | Count |\n")
            f.write(f"| --- | --- |\n")
            f.write(f"| **Performed** | {performed_count} |\n")
            f.write(f"| **Passed** | {passed_count} |\n")
            f.write(f"| **Failed** | {failed_count} |\n")
            f.write(f"| **Skipped** | {skipped_count} |\n\n")

            if failed_tests:
                f.write("## Failed Tests\n\n")
                for test in failed_tests:
                    f.write(f"- {test}\n")
            else:
                f.write("All tests passed!\n")

        print(f"Report generated: {report_file}")

    finally:
        print("Stopping Renode...")
        renode_proc.terminate()
        try:
            renode_proc.wait(timeout=5)
        except subprocess.TimeoutExpired:
            renode_proc.kill()

if __name__ == "__main__":
    main()
