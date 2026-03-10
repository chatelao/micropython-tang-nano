#!/bin/bash
set -e

echo "Building mpy-cross..."
make -C src/lib/micropython/mpy-cross

echo "Building Tang Nano 4K port (Simulation variant)..."
make -C src/ports/tang_nano_4k/ SIMULATION=1
