# A small HTTPS proxy that writes down every host R connects to, then passes the
# traffic through untouched. It proves which servers the student's line needs.
#
#   python3 -I log-hosts-proxy.py <hosts-log> <port-file>
#
# It writes the port it chose to <port-file>. It cannot read the traffic, which
# stays encrypted. A request that is not HTTPS is logged and refused.
import socket
import sys
import threading

hosts_log, port_file = sys.argv[1], sys.argv[2]
lock = threading.Lock()


def log(line):
    with lock:
        with open(hosts_log, "a") as handle:
            handle.write(line + "\n")


def pump(source, target):
    try:
        while True:
            data = source.recv(65536)
            if not data:
                break
            target.sendall(data)
    except OSError:
        pass
    finally:
        for end in (source, target):
            try:
                end.shutdown(socket.SHUT_RDWR)
            except OSError:
                pass


def handle(client):
    head = b""
    while b"\r\n\r\n" not in head:
        chunk = client.recv(4096)
        if not chunk:
            client.close()
            return
        head += chunk
    method, target = head.split(b"\r\n", 1)[0].decode().split()[:2]
    if method != "CONNECT":
        log("REFUSED " + method + " " + target)
        client.sendall(b"HTTP/1.1 405 Method Not Allowed\r\n\r\n")
        client.close()
        return
    host, port = target.rsplit(":", 1)
    log(host)
    try:
        upstream = socket.create_connection((host, int(port)), timeout=30)
    except OSError:
        log("FAILED " + host)
        client.sendall(b"HTTP/1.1 502 Bad Gateway\r\n\r\n")
        client.close()
        return
    client.sendall(b"HTTP/1.1 200 Connection established\r\n\r\n")
    threading.Thread(target=pump, args=(client, upstream), daemon=True).start()
    threading.Thread(target=pump, args=(upstream, client), daemon=True).start()


server = socket.socket()
server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
server.bind(("127.0.0.1", 0))
server.listen(32)
with open(port_file, "w") as port_handle:
    port_handle.write(str(server.getsockname()[1]))
while True:
    connection, _ = server.accept()
    threading.Thread(target=handle, args=(connection,), daemon=True).start()
