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
# We use renode-test to run the .robot files
# The --variable RENODEKEYWORDS points to the standard Renode Robot library
# In a local installation, this is usually provided by the renode-test wrapper.

renode-test test/tang_nano_4k.robot
renode-test test/test_blink.robot

echo "Tests complete."
