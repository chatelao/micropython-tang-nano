# Project Goal
- Create a working MicroPython implementation for Tang Nano 4K.

# Planning & Progress tracking
- Keep an up to date file "ROADMAP.md" with the next 5 steps and all past steps having checkboxes.

# Structure
/ - Keep only GEMINI.md, README.md and ROADMAP.md in the root directory
/specifications: Original and converted '.md' datasheets and standards.
/documentation: Keep "CONCEPT_xxx.md" for different areas of work, mark the implementation progress within the concepts
/test: Unit, System and End-2-End test concepts and cases to be executed after each change. Use Renode to verify the binaries.
/src: Source files, only accepted if working and covered by tests
/.github/workflows: For every push on every test the build
/.github/workflows: For release tag publish the installer/binary
/HOWTO.md: Describe how to install MicroPython on the Tang Nano 4K
/README.md: Update overview of the product
