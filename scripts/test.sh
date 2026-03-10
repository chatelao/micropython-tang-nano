#!/bin/bash
set -e

# Run all .robot files in the test directory
# If renode-test is not in PATH, it will fail, which is expected for local run if not installed.
echo "Running Renode tests..."
if command -v renode-test &> /dev/null; then
    renode-test test/*.robot
else
    echo "renode-test not found in PATH. Please install Renode to run tests locally."
    exit 1
fi
