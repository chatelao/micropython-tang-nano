# Project Goal
- Create a working MicroPython implementation for Tang Nano 4K.

# Planning & Progress tracking
- Keep an up to date file "ROADMAP.md" with the next 5 steps and all past steps having checkboxes.

# Project structure
- / - Keep only GEMINI.md, README.md and ROADMAP.md in the root directory
- /definitions - Datasheets and Standards to be used, download and convert to ".md" on first time read
- /documentation - Keep "CONCEPT_xxx.md" for different areas of work, mark the implementation progress within the concepts
- /src - Source files
- /test - Unit, System and End-2-End test concepts and cases to be executed after each change. Use Renode to verify the binaries.
- /.github/workflows - For every push on every test the build
- /.github/workflows - For release tag publish the installer/binary
- HOWTO.md - Describe how to install MicroPython on the Tang Nano 4K
- README.md - Update overview of the product
