import os

def test_vfs():
    print("Testing VFS...")

    # List initial directory content
    print("Initial list:", os.listdir())

    # Create a file
    print("Creating test.txt...")
    with open("test.txt", "w") as f:
        f.write("Hello Tang Nano 4K!")

    # Verify file existence
    print("List after creation:", os.listdir())
    if "test.txt" not in os.listdir():
        print("FAILED: test.txt not found")
        return

    # Read back the file
    print("Reading back test.txt...")
    with open("test.txt", "r") as f:
        content = f.read()
        print("Content:", content)
        if content != "Hello Tang Nano 4K!":
            print("FAILED: Content mismatch")
            return

    # Delete the file
    print("Deleting test.txt...")
    os.remove("test.txt")

    # Verify deletion
    print("List after deletion:", os.listdir())
    if "test.txt" in os.listdir():
        print("FAILED: test.txt still exists")
        return

    print("VFS TEST PASSED")

if __name__ == "__main__":
    test_vfs()
