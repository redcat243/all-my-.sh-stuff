#!/bin/bash
# cat-server.sh

mkdir -p ~/Desktop/cat.sh_files
cd ~/Desktop/cat.sh_files

# Mac-specific IP detection
IP_ADDR=$(ipconfig getifaddr en0 2>/dev/null || ipconfig getifaddr en1 2>/dev/null)

echo -e "\033[1;34m--- CAT.SH SERVER ACTIVE ---\033[0m"
echo "IP: $IP_ADDR | Port: 8000"

cat << 'EOF' > web_server.py
import http.server
import os
import socket

class EnhancedHandler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/list':
            self.send_response(200)
            self.send_header('Content-type', 'text/plain')
            self.end_headers()
            files = [f for f in os.listdir('.') if os.path.isfile(f) and f != 'web_server.py']
            self.wfile.write("\n".join(files).encode())
        else:
            super().do_GET()

    def do_POST(self):
        try:
            content_length = int(self.headers['Content-Length'])
            body = self.rfile.read(content_length)
            boundary = self.headers['Content-Type'].split("boundary=")[1].encode()
            parts = body.split(boundary)
            for part in parts:
                if b'filename="' in part:
                    filename = part.split(b'filename="')[1].split(b'"')[0].decode()
                    content = part.split(b'\r\n\r\n')[1].rsplit(b'\r\n', 1)[0]
                    with open(filename, 'wb') as f:
                        f.write(content)
                    self.send_response(200)
                    self.end_headers()
                    self.wfile.write(b"OK")
                    print(f"Meow! Received: {filename}")
                    return
        except Exception as e:
            print(f"Error: {e}")
            self.send_response(500)
            self.end_headers()

if __name__ == '__main__':
    # Force IPv4 to prevent the '127.0.0.1' failure
    server = http.server.HTTPServer(('0.0.0.0', 8000), EnhancedHandler)
    server.serve_forever()
EOF

python3 -u web_server.py