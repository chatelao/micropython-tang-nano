try:
    import uos as os
except ImportError:
    import os
import machine

# Get the Flash block device
bdev = machine.Flash()

# Check if mounted by trying to list /
try:
    print("Files in /:", os.listdir("/"))
except OSError:
    print("Filesystem not found, formatting...")
    os.VfsLfs2.mkfs(bdev)
    os.mount(bdev, "/")
    print("Formatted and mounted.")

# File I/O test
filename = "/test.txt"
test_data = "Hello Tang Nano 4K VFS!"

print("Writing to file...")
with open(filename, "w") as f:
    f.write(test_data)

print("Reading from file...")
with open(filename, "r") as f:
    read_data = f.read()

if read_data == test_data:
    print("VFS_TEST: OK")
else:
    print("VFS_TEST: FAIL (Read data mismatch)")

print("Directory listing:", os.listdir("/"))

print("Renaming file...")
os.rename("/test.txt", "/test_renamed.txt")
print("New listing:", os.listdir("/"))

print("Deleting file...")
os.remove("/test_renamed.txt")
print("Final listing:", os.listdir("/"))

print("VFS_DONE")
