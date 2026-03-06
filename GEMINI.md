# Project Goal
- Create a working MicroPython implementation for Tang Nano 4K.

# Planning & Progress tracking
- Keep an up to date file "ROADMAP.md" with the next 5 steps and all past steps having checkboxes.

# Project structure
- /definitions - Datasheets and Standards to be used, download and extract text, but don't extend
- /documentation - Keep "CONCEP_xxx.md" for different areas of work, mark the implementation progress within the concepts
- /src - Source files
- /test - Unit, System and End-2-End test concepts and cases to be executed after each change. Use QEMU to verify the binaries.
- /.github/workflows - For every push on every test the build
- /.github/workflows - For release tag publish the installer/binary
- HOWTO.md - Describe how to install MicroPython on the Tang Nano 4K
- README.md - Update overview of the product
