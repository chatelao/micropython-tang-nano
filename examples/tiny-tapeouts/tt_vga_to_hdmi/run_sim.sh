#!/bin/bash
# run_sim.sh: Runs the Icarus Verilog simulation for the HDMI packetizer.

set -e

# Change to the example directory
cd "$(dirname "$0")"

echo "Compiling HDMI Packetizer and Testbench..."
# Compile the packetizer and its testbench
# Note: We don't need terc4_encoder or others if we are only testing the packetizer logic.
iverilog -o sim_out tb_hdmi_packetizer.v hdmi_packetizer.v

echo "Running Simulation..."
# Run the simulation and check for PASS
vvp sim_out | tee sim_log.txt

if grep -q "ALL TESTS PASSED SUCCESSFULLY!" sim_log.txt; then
    echo "Verification SUCCESS: HDMI Packetizer is protocol compliant."
    exit 0
else
    echo "Verification FAILURE: One or more tests failed. Check sim_log.txt."
    exit 1
fi
