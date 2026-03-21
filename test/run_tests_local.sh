#!/bin/bash
# test/run_tests_local.sh

# This script runs the full CI/CD test suite locally.
# It requires 'renode', 'renode-test', and the ARM GNU Toolchain to be installed.

set -e

# Get the directory of the script and the repo root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "Building components..."

# 1. Build mpy-cross
echo "Building mpy-cross..."
make -C "$REPO_ROOT/src/lib/micropython/mpy-cross"

# 2. Build the simulation firmware
echo "Building firmware (Simulation variant)..."
make -C "$REPO_ROOT/src/ports/tang_nano_4k/" SIMULATION=1

# 3. Build MicroPython Unix port (as a reference for compliance tests)
echo "Building MicroPython Unix port..."
make -C "$REPO_ROOT/src/lib/micropython/ports/unix" aarch64=0 MICROPY_PY_SSL=0 MICROPY_PY_BTREE=0 FROZEN_MANIFEST=

# 4. Run Renode functional and compliance tests
echo "Running Renode and compliance tests..."
# We use renode-test to run the consolidated .robot file
# Note: renode-test might need RENODEKEYWORDS variable in some environments
renode-test "$REPO_ROOT/test/tang_nano_4k.robot"

echo "Tests complete. Results are in COMLIANCE_TESTS.md and Robot Framework reports."
