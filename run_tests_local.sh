#!/bin/bash
# run_tests_local.sh

# This script attempts to run Renode tests locally.
# It requires 'renode' and 'renode-test' to be installed and in the PATH.

set -e

# 1. Build the firmware
echo "Building firmware..."
make -C src/ports/tang_nano_4k/ SIMULATION=1

# 2. Run Renode tests
echo "Running Renode tests..."
# We use renode-test to run all the .robot files in the test/ directory
renode-test test/*.robot

echo "Tests complete."
