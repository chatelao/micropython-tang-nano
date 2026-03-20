import sys
import socket
import select

def main():
    if len(sys.argv) < 3:
        print(f"Usage: {sys.argv[0]} <host> <port>", file=sys.stderr)
        sys.exit(1)

    host = sys.argv[1]
    port = int(sys.argv[2])

    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    try:
        s.connect((host, port))
    except Exception as e:
        print(f"Connection failed: {e}", file=sys.stderr)
        sys.exit(1)

    # Disable blocking for stdin and socket
    s.setblocking(False)

    try:
        while True:
            # Use select to wait for data on stdin or socket
            readable, _, exceptional = select.select([sys.stdin.buffer, s], [], [sys.stdin.buffer, s])

            if exceptional:
                break

            for r in readable:
                if r is sys.stdin.buffer:
                    data = sys.stdin.buffer.read(4096)
                    if not data:
                        return # EOF on stdin
                    s.sendall(data)
                elif r is s:
                    data = s.recv(4096)
                    if not data:
                        return # Connection closed
                    sys.stdout.buffer.write(data)
                    sys.stdout.buffer.flush()
    except KeyboardInterrupt:
        pass
    finally:
        s.close()

if __name__ == "__main__":
    main()
