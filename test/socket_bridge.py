import sys
import socket
import select
import time
import os
import fcntl

def main():
    host = '127.0.0.1'
    port = 12345

    # Try to connect a few times as Renode might be starting up
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    connected = False
    for _ in range(60):
        try:
            s.connect((host, port))
            connected = True
            break
        except Exception:
            time.sleep(1)

    if not connected:
        sys.exit(1)

    s.setblocking(False)
    # Set stdin to non-blocking
    fd = sys.stdin.fileno()
    fl = fcntl.fcntl(fd, fcntl.F_GETFL)
    fcntl.fcntl(fd, fcntl.F_SETFL, fl | os.O_NONBLOCK)

    inputs = [fd, s]

    while inputs:
        try:
            r, w, e = select.select(inputs, [], [])
            if fd in r:
                try:
                    data = os.read(fd, 1024)
                    if data:
                        s.sendall(data)
                    else:
                        # EOF on stdin
                        inputs.remove(fd)
                        # We might need to send Ctrl-D (EOF for MicroPython REPL)
                        # but run-tests.py usually does that explicitly in the script if needed,
                        # or it expects the connection to stay open for output.
                except OSError:
                    inputs.remove(fd)

            if s in r:
                data = s.recv(1024)
                if not data:
                    # Connection closed by Renode
                    break
                sys.stdout.buffer.write(data)
                sys.stdout.buffer.flush()
        except (ConnectionResetError, BrokenPipeError, EOFError):
            break
        except KeyboardInterrupt:
            break

if __name__ == "__main__":
    main()
