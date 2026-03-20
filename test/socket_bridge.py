#!/usr/bin/env python3
# test/socket_bridge.py

import socket
import sys
import threading
import time

# Bridge between stdin/stdout and a TCP socket on port 12345
# Used by pyboard.py --device "exec:python3 test/socket_bridge.py"

def socket_to_stdout(s):
    try:
        while True:
            data = s.recv(1024)
            if not data:
                break
            sys.stdout.buffer.write(data)
            sys.stdout.buffer.flush()
    except:
        pass

def stdin_to_socket(s):
    try:
        while True:
            # Use read1 to avoid blocking until the full buffer is filled
            data = sys.stdin.buffer.read1(1024)
            if not data:
                break
            s.sendall(data)
    except:
        pass

def main():
    host = 'localhost'
    port = 12345

    # Wait for the server to be ready
    max_retries = 30
    s = None
    for i in range(max_retries):
        try:
            s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            s.connect((host, port))
            break
        except ConnectionRefusedError:
            time.sleep(1)
            if i == max_retries - 1:
                sys.stderr.write(f"Failed to connect to {host}:{port}\n")
                sys.exit(1)
            continue

    t1 = threading.Thread(target=socket_to_stdout, args=(s,), daemon=True)
    t1.start()

    stdin_to_socket(s)
    s.close()

if __name__ == "__main__":
    main()
