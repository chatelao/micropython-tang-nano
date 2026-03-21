import subprocess
import time
import os
import sys
import socket

def wait_for_port(port, host='127.0.0.1', timeout=60, proc=None):
    start_time = time.time()
    while True:
        if proc and proc.poll() is not None:
            return False
        try:
            with socket.create_connection((host, port), timeout=1):
                return True
        except (ConnectionRefusedError, socket.timeout):
            if time.time() - start_time > timeout:
                return False
            time.sleep(1)

def run_compliance():
    root_dir = os.getcwd()

    # 1. Start Renode in background
    resc_path = os.path.abspath("test/compliance.resc")
    renode_log_path = os.path.abspath("renode_output.log")
    renode_log = open(renode_log_path, "w")

    # Use xvfb-run to ensure Renode can start its virtual display in headless environments
    # -a finds a free server number
    # Use --disable-gui to run in headless mode
    # Use -p to avoid escape codes in log
    # Use -e to execute the inclusion of the resc file
    renode_proc = subprocess.Popen(
        ["xvfb-run", "-a", "renode", "--disable-gui", "-p", "-e", f"include @{resc_path}"],
        stdout=renode_log,
        stderr=subprocess.STDOUT
    )

    print("Waiting for Renode to start and port 12345 to be available...")
    if not wait_for_port(12345, proc=renode_proc):
        print("Renode failed to start or port 12345 is not available after 60 seconds.")

        # Flush and close log to make sure we can read it
        renode_log.flush()
        renode_log.close()

        if os.path.exists(renode_log_path):
            with open(renode_log_path, "r") as f:
                print("--- Renode Output Log ---")
                print(f.read())
                print("-------------------------")

        if renode_proc.poll() is None:
            renode_proc.terminate()
        return False

    # 2. Run MicroPython tests
    # Select stable directories for the compliance report
    test_dirs = ["basics", "micropython", "import", "io", "misc"]

    micropython_dir = "src/lib/micropython"
    run_tests_py = os.path.abspath(f"{micropython_dir}/tests/run-tests.py")
    socket_bridge = os.path.abspath("test/socket_bridge.py")
    # Path to the Unix port build, which should be pre-built in CI
    micropython_bin = os.path.abspath(f"{micropython_dir}/ports/unix/build-standard/micropython")

    if not os.path.exists(micropython_bin):
        print(f"Error: MicroPython Unix port binary not found at {micropython_bin}")
        renode_proc.terminate()
        return False

    cmd = [
        "python3", run_tests_py,
        "--micropython", micropython_bin,
        "--device", f"exec:python3 {socket_bridge}",
        "-v"
    ] + test_dirs

    print(f"Running command: {' '.join(cmd)}")

    env = os.environ.copy()
    env["PYTHONPATH"] = f"{root_dir}/{micropython_dir}/tools"

    with open("compliance_output.log", "w") as log_file:
        proc = subprocess.Popen(
            cmd,
            cwd=f"{micropython_dir}/tests",
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            env=env,
            universal_newlines=True
        )

        with open(os.path.join(root_dir, "COMLIANCE_TESTS.md"), "w") as md_file:
            md_file.write("# MicroPython Compliance Test Results\n\n")
            md_file.write(f"Date: {time.strftime('%Y-%m-%d %H:%M:%S')}\n\n")
            md_file.write("## Summary\n\n")

            summary_lines = []

            for line in proc.stdout:
                sys.stdout.write(line)
                log_file.write(line)
                if any(x in line for x in ["tests performed", "passed", "failed", "skipped"]):
                    summary_lines.append(line.strip())

            proc.wait()

            for s_line in summary_lines:
                md_file.write(f"- {s_line}\n")

            md_file.write("\n## Details\n\n")
            md_file.write("See `compliance_output.log` for full details.\n")

    # 3. Cleanup
    renode_proc.terminate()
    try:
        renode_proc.wait(timeout=5)
    except subprocess.TimeoutExpired:
        renode_proc.kill()
    renode_log.close()

    return proc.returncode == 0

if __name__ == "__main__":
    if not run_compliance():
        # Exit with error to indicate failure in CI
        sys.exit(1)
    sys.exit(0)
