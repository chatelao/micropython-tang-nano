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
    renode_bin = "renode"
    if "RENODE_ROOT" in os.environ:
        potential_bin = os.path.join(os.environ["RENODE_ROOT"], "renode")
        if os.path.exists(potential_bin):
            renode_bin = potential_bin

    renode_proc = subprocess.Popen([renode_bin, resc_file, "--disable-xwt"], stdout=subprocess.PIPE, stderr=subprocess.PIPE)

    # Wait for Renode to start and port to be open
    time.sleep(10) # Give Renode enough time to start and open the socket

    test_dirs = ["basics", "micropython", "misc"]
    total_performed = 0
    total_passed = 0
    all_failed_tests = []

    try:
        for test_dir in test_dirs:
            print(f"Running compliance tests in {test_dir}...")
            test_cmd = [
                sys.executable,
                "run-tests.py",
                "-j", "1", # Force single job to avoid UART port conflict
                "--target", "pyboard",
                "--device", f"exec:{sys.executable} {bridge_script} 127.0.0.1 12345",
                "-d", test_dir
            ]

            try:
                # result_dir defaults to 'results' relative to run-tests.py
                result = subprocess.run(test_cmd, cwd=micropython_tests_dir, capture_output=True, text=True, timeout=600) # 10 min timeout per block
                print(result.stdout)

                # Parse results from stdout
                passed_match = re.search(r"(\d+) tests passed", result.stdout)
                performed_match = re.search(r"(\d+) tests performed", result.stdout)

                passed_count = int(passed_match.group(1)) if passed_match else 0
                performed_count = int(performed_match.group(1)) if performed_match else 0

                total_passed += passed_count
                total_performed += performed_count

                # Read _results.json for failed tests
                results_json_path = os.path.join(micropython_tests_dir, "results/_results.json")
                if os.path.exists(results_json_path):
                    with open(results_json_path, "r") as f:
                        res_data = json.load(f)
                        all_failed_tests.extend(res_data.get("failed_tests", []))

                # Clean up results for next block
                if os.path.exists(results_json_path):
                    os.remove(results_json_path)

            except subprocess.TimeoutExpired:
                print(f"Tests in {test_dir} timed out!")
                all_failed_tests.append(f"{test_dir} (TIMED OUT)")
            except Exception as e:
                print(f"Error running tests in {test_dir}: {e}")
                all_failed_tests.append(f"{test_dir} (ERROR: {e})")

        failed_count = len(all_failed_tests)
        skipped_count = total_performed - total_passed - failed_count

        # Generate COMLIANCE_TESTS.md
        with open(report_file, "w") as f:
            f.write("# Compliance Test Report\n\n")
            f.write("## Summary\n\n")
            f.write(f"| Status | Count |\n")
            f.write(f"| --- | --- |\n")
            f.write(f"| **Performed** | {total_performed} |\n")
            f.write(f"| **Passed** | {total_passed} |\n")
            f.write(f"| **Failed** | {failed_count} |\n")
            f.write(f"| **Skipped** | {skipped_count} |\n\n")

            if all_failed_tests:
                f.write("## Failed Tests\n\n")
                for test in all_failed_tests:
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
