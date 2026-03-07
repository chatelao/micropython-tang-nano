# CI/CD Issues Summary

## Current Status
The GitHub Action for building and testing the Tang Nano 4K firmware in Renode is encountering failures during the execution of the Robot Framework tests.

## Identified Causes

### 1. Renode Path Resolution
In Renode script files (`.resc`), paths prefixed with `@` are resolved. There was confusion whether these paths are resolved relative to the script file's directory or the Renode process's working directory.
- **Observation**: When using `@tang_nano_4k.repl` inside `test/tang_nano_4k.resc`, Renode reported it could not find `test/tang_nano_4k.repl`. This suggests that Renode was prefixing the relative path with the script's directory again, or the working directory was inconsistent.
- **Attempted Fix**: Switched back to `@test/tang_nano_4k.repl` assuming the paths should be relative to the project root.

### 2. MicroPython Build Constraints
The Tang Nano 4K (GW1NSR-LV4C) has only 32KB of User Flash for the Cortex-M3.
- **Issue**: The default MicroPython build exceeds this limit ("FLASH overflowed by 33648 bytes").
- **Solution**: Aggressively reduced features (disabled compiler, REPL helper, float, math, and standard files) to fit within 32KB. The resulting binary is ~31.2KB.

### 3. Verification Signal
With the REPL disabled to save space, the Robot test cannot wait for a REPL prompt.
- **Solution**: Added a explicit boot message `printf("MicroPython started on Tang Nano 4K\n");` in `main.c` to provide a detectable signal for the Robot test.

## Possible Future Solutions
1. **Dynamic Paths**: Use variables in the Robot test to pass absolute paths to the `.resc` file to avoid resolution issues.
2. **Selective Feature Re-enabling**: If more flash space is recovered (e.g., through LTO or better compression), re-enable the REPL helper for better interactive testing.
3. **Dedicated Mocking**: Improve the FPGA mocking in Renode to include more Gowin-specific peripherals as they are implemented.
