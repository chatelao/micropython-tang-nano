import os
import sys

def test_structure():
    expected_dirs = [
        'definitions',
        'documentation',
        'src',
        'test',
        '.github',
        'scripts'
    ]
    expected_files = [
        'README.md',
        'ROADMAP.md',
        'GEMINI.md',
        'Makefile'
    ]

    missing = []

    for d in expected_dirs:
        if not os.path.isdir(d):
            missing.append(f"Directory missing: {d}")

    for f in expected_files:
        if not os.path.isfile(f):
            missing.append(f"File missing: {f}")

    if missing:
        for m in missing:
            print(m)
        sys.exit(1)
    else:
        print("Project structure verification passed!")
        sys.exit(0)

if __name__ == "__main__":
    test_structure()
