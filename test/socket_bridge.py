import sys
import socket
import select
import time

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

    s.setblocking(0)

    while True:
        try:
            r, w, e = select.select([sys.stdin.buffer, s], [], [])
            if sys.stdin.buffer in r:
                data = sys.stdin.buffer.read1(1024)
                if data:
                    s.sendall(data)
            if s in r:
                data = s.recv(1024)
                if not data:
                    break
                sys.stdout.buffer.write(data)
                sys.stdout.buffer.flush()
        except (ConnectionResetError, BrokenPipeError):
            break
        except KeyboardInterrupt:
            break

if __name__ == "__main__":
    main()
