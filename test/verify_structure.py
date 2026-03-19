import os
import sys

def test_structure():
    expected_dirs = [
        'definitions',
        'documentation',
        'src',
        'test',
        '.github'
    ]
    expected_files = [
        'README.md',
        'ROADMAP.md',
        'GEMINI.md',
        '.gitignore',
        '.gitmodules'
    ]

    # Files that should NOT be in the root directory (only directories and specific files allowed)
    # This is a strict check based on GEMINI.md
    root_items = os.listdir('.')
    root_files = [f for f in root_items if os.path.isfile(f)]

    missing = []
    extra = []

    for d in expected_dirs:
        if not os.path.isdir(d):
            missing.append(f"Directory missing: {d}")

    for f in expected_files:
        if not os.path.isfile(f):
            missing.append(f"File missing: {f}")

    for f in root_files:
        if f not in expected_files:
            extra.append(f"Extra file in root: {f}")

    if missing or extra:
        for m in missing:
            print(m)
        for e in extra:
            print(e)
        sys.exit(1)
    else:
        print("Project structure verification passed!")
        sys.exit(0)

if __name__ == "__main__":
    test_structure()
