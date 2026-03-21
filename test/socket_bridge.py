import socket
import sys
import select

def main():
    host = '127.0.0.1'
    port = 12345

    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    try:
        s.connect((host, port))
    except ConnectionRefusedError:
        print(f"Failed to connect to {host}:{port}")
        sys.exit(1)

    while True:
        r, w, e = select.select([s, sys.stdin], [], [])
        for sock in r:
            if sock is s:
                data = s.recv(1024)
                if not data:
                    return
                sys.stdout.buffer.write(data)
                sys.stdout.buffer.flush()
            else:
                # Use read1 to be as non-blocking as possible and read whatever is available
                data = sys.stdin.buffer.read1()
                if not data:
                    return
                s.sendall(data)

if __name__ == "__main__":
    main()
