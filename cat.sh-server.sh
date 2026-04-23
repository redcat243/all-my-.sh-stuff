#!/bin/bash
# cat-server.sh - The Receiver & Indexer

TARGET_DIR="$HOME/cat.sh_files"
mkdir -p "$TARGET_DIR"
cd "$TARGET_DIR"

IP_ADDR=$(ipconfig getifaddr en0 2>/dev/null || hostname -I | awk '{print $1}')
echo -e "\033[1;34m--- CAT.SH DATA SERVER ---\033[0m"
echo "IP: $IP_ADDR | Port: 8000"

cat << 'EOF' > web_server.py
import http.server
import os
import cgi

class EnhancedHandler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        # If client asks for /list, show them what files we have
        if self.path == '/list':
            self.send_response(200)
            self.send_header('Content-type', 'text/plain')
            self.end_headers()
            files = [f for f in os.listdir('.') if os.path.isfile(f) and f != 'web_server.py']
            self.wfile.write("\n".join(files).encode())
        else:
            # Otherwise, act like a normal file server (for downloading)
            super().do_GET()

    def do_POST(self):
        try:
            form = cgi.FieldStorage(fp=self.rfile, headers=self.headers, environ={'REQUEST_METHOD': 'POST'})
            if 'file' in form:
                file_data = form['file']
                filename = os.path.basename(file_data.filename)
                with open(filename, 'wb') as f:
                    f.write(file_data.file.read())
                self.send_response(200)
                self.end_headers()
                self.wfile.write(b"OK")
                print(f"[+] Received: {filename}")
        except Exception as e:
            print(f"Error: {e}")

if __name__ == '__main__':
    http.server.HTTPServer(('', 8000), EnhancedHandler).serve_forever()
EOF

python3 web_server.py