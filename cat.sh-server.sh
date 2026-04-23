#!/bin/bash
# cat-server.sh - The Receiver (Auto-Directory Setup)

# --- INITIALIZATION ---
# Create the hidden storage folder in the home directory
TARGET_DIR="$HOME/.cat.sh_files"
mkdir -p "$TARGET_DIR"
cd "$TARGET_DIR"

# Detect IP address (macOS and Linux compatible)
IP_ADDR=$(ipconfig getifaddr en0 2>/dev/null || hostname -I | awk '{print $1}')

clear
echo -e "\033[1;34m###########################################################"
echo "#                  CAT.SH DATA SERVER                     #"
echo "###########################################################\033[0m"
echo "Storage Location: $TARGET_DIR"
echo "Server IP:        $IP_ADDR"
echo "Server Port:      8000"
echo "-----------------------------------------------------------"
echo "Waiting for client connection..."

# Create Python Handler (Modern Python 3.13+ compatible)
cat << 'EOF' > web_server.py
import http.server
import os

class EnhancedHandler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        # Handle the file list request from the client
        if self.path == '/list':
            self.send_response(200)
            self.send_header('Content-type', 'text/plain')
            self.end_headers()
            # List files, excluding the script itself
            files = [f for f in os.listdir('.') if os.path.isfile(f) and f != 'web_server.py']
            self.wfile.write("\n".join(files).encode())
        else:
            # Handle standard file downloads
            super().do_GET()

    def do_POST(self):
        try:
            content_length = int(self.headers['Content-Length'])
            body = self.rfile.read(content_length)
            
            # Extract filename and content from multipart data
            header_end = body.find(b'\r\n\r\n')
            header = body[:header_end].decode('utf-8')
            
            if 'filename="' in header:
                filename = header.split('filename="')[1].split('"')[0]
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
            print(f"[!] Upload Error: {e}")
            self.send_response(500)
            self.end_headers()

if __name__ == '__main__':
    # Start the server on port 8000
    server = http.server.HTTPServer(('', 8000), EnhancedHandler)
    server.serve_forever()
EOF

# Launch the server
python3 web_server.py