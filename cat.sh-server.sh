#!/bin/bash
# cat-server.sh - Modern Receiver (No CGI required)

TARGET_DIR="$HOME/cat.sh_files"
mkdir -p "$TARGET_DIR"
cd "$TARGET_DIR"

IP_ADDR=$(ipconfig getifaddr en0 2>/dev/null || hostname -I | awk '{print $1}')
echo -e "\033[1;34m--- CAT.SH DATA SERVER (V2) ---\033[0m"
echo "IP: $IP_ADDR | Port: 8000"

cat << 'EOF' > web_server.py
import http.server
import os

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
        content_length = int(self.headers['Content-Length'])
        body = self.rfile.read(content_length)
        
        # Simple logic to extract filename and content from multipart/form-data
        try:
            header_end = body.find(b'\r\n\r\n')
            header = body[:header_end].decode('utf-8')
            
            if 'filename="' in header:
                filename = header.split('filename="')[1].split('"')[0]
                # Extract the actual file content (removing boundaries)
                content = body[header_end+4:]
                footer_start = content.rfind(b'\r\n--')
                content = content[:footer_start]
                
                with open(filename, 'wb') as f:
                    f.write(content)
                
                self.send_response(200)
                self.end_headers()
                self.wfile.write(b"OK")
                print(f"[+] Received: {filename}")
        except Exception as e:
            print(f"Error: {e}")
            self.send_response(500)
            self.end_headers()

if __name__ == '__main__':
    http.server.HTTPServer(('', 8000), EnhancedHandler).serve_forever()
EOF

python3 web_server.py