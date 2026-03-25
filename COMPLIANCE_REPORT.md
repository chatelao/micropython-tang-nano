# MicroPython Compliance Report

This document details the compliance testing process and the scope of the tests performed for the MicroPython port on the Tang Nano 4K (GW1NSR-LV4C).

## Test Suite Overview

Compliance is measured against the official MicroPython test suite, which is located in `src/lib/micropython/tests`. The suite includes several hundred tests across multiple categories to ensure that the port adheres to the expected behavior of the MicroPython runtime and its built-in modules.

### Categories Tested

The following test categories are included in the compliance testing process:

- **basics/**: Core Python language features, built-in types (integers, strings, lists, etc.), and control structures.
- **micropython/**: Specific MicroPython extensions and optimizations (e.g., garbage collection, internal memory management).
- **extmod/**: Standard MicroPython external modules such as `ujson`, `urandom`, `uheapq`, and `uzlib`.
- **io/**: Basic input/output operations and stream handling.
- **unicode/**: Correct handling of UTF-8 and Unicode strings.
- **stress/**: Tests to ensure stability under heavy load or memory constraints.

## Execution Infrastructure

The tests are executed in a simulated environment using **Renode**, providing a consistent and reproducible platform for functional verification.

- **Renode Simulation**: The Cortex-M3 core and its memory-mapped peripherals are simulated using the `.repl` and `.resc` files located in the `test/` directory.
- **Socket Bridge (`test/socket_bridge.py`)**: A custom Python script that bridges the standard input/output of the MicroPython test runner (`run-tests.py`) to the Renode TCP terminal server.
- **Test Runner (`test/run_compliance.py`)**: A wrapper script that automates the entire process, including:
  1. Starting the Renode simulation.
  2. Setting up the TCP terminal server.
  3. Invoking `run-tests.py` with the correct arguments to use the socket bridge as the device executor.
  4. Capturing the output and generating `COMPLIANCE_TESTS.md`.

## Test Exclusions

Certain categories of tests are explicitly excluded from the compliance suite due to hardware limitations or configuration choices for the Tang Nano 4K port:

- **float**: Floating-point support is disabled (`MICROPY_PY_BUILTINS_FLOAT=0`) to save flash and RAM. The GW1NSR-LV4C does not have a hardware FPU.
- **net**: Network-related modules (`usocket`, `network`) are not supported as the board lacks built-in Ethernet or Wi-Fi hardware.
- **inlineasm**: Inline assembly tests for architectures other than Thumb-2 (Cortex-M3) are naturally excluded.
- **multi_***: Multi-node or multi-board tests are not applicable to the single-board simulation environment.

## Result Reporting

The results of the compliance tests are summarized in `COMPLIANCE_TESTS.md`. This file contains the raw output from `run-tests.py`, listing the number of tests performed and the number of tests passed. The GitHub Actions CI/CD pipeline automatically runs these tests on every commit to ensure no regressions are introduced in the core MicroPython functionality.
