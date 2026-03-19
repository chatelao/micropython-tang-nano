# HOWTO: Build and Deploy MicroPython for Tang Nano 4K

## Prerequisites
- ARM GNU Toolchain (`arm-none-eabi-gcc`, etc.)
- `make`
- (Optional) Renode for simulation

## Building the Firmware

1. Clone the repository (if you haven't already).
2. The MicroPython core should be cloned into `src/lib/micropython`. If it's not there, you can clone it:
   ```bash
   git clone --depth 1 --branch v1.24.1 https://github.com/micropython/micropython.git src/lib/micropython
   ```
3. Build `mpy-cross`:
   ```bash
   make -C src/lib/micropython/mpy-cross
   ```
4. Build the Tang Nano 4K port:
   ```bash
   # For real hardware (32KB internal flash)
   make -C src/ports/tang_nano_4k/

   # For Renode simulation (4MB external flash)
   make -C src/ports/tang_nano_4k/ SIMULATION=1
   ```
5. The resulting firmware files will be in `src/ports/tang_nano_4k/build/`:
   - `firmware.elf`: ELF file with debug symbols
   - `firmware.bin`: Binary file for flashing

## Deploying to Tang Nano 4K

To deploy the `firmware.bin` to the Tang Nano 4K, you typically use the Gowin Programmer.

1. Connect your Tang Nano 4K to your computer via USB.
2. Open the Gowin Programmer.
3. Select the `GW1NSR-LV4C` device.
4. Set the programming mode to "Embedded Flash Mode" for internal flash or "External Flash Mode" if using the external flash.
5. Select the `firmware.bin` file.
6. Click "Program".

## Running Tests

To run the tests in Renode:
```bash
./scripts/run_tests_local.sh
```
(Requires Renode to be installed and in your PATH).
