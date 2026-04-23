#!/bin/bash

# Visual styling to match your original script
printf '\033[8;24;91t'
echo -e "\033[0;32m"
clear
echo "--- CAT.SH DATA SERVER (UPLOAD/DOWNLOAD) ---"

# 1. Setup the specific folder
TARGET_DIR="cat.sh files"
mkdir -p "$TARGET_DIR"
cd "$TARGET_DIR"

# 2. Identify the IP address
IP_ADDR=$(ipconfig getifaddr en0 2>/dev/null || hostname -I | awk '{print $1}')
echo "Listening for connections on port 8000..."
echo "Your IP is: $IP_ADDR"
echo "Files will be saved in: $(pwd)"
echo "--------------------------------------------"

# 3. Create a temporary Python handler that supports uploads
cat << 'EOF' > web_server.py
import http.server
import os
import cgi

class EnhancedHandler(http.server.SimpleHTTPRequestHandler):
    def do_POST(self):
        # Handles the file upload logic
        form = cgi.FieldStorage(
            fp=self.rfile,
            headers=self.headers,
            environ={'REQUEST_METHOD': 'POST'}
        )
        
        if 'file' in form:
            file_data = form['file']
            filename = os.path.basename(file_data.filename)
            with open(filename, 'wb') as f:
                f.write(file_data.file.read())
            
            self.send_response(200)
            self.end_headers()
            self.wfile.write(f"Successfully uploaded: {filename}".encode())
            print(f"\n[+] Received file: {filename}")
        else:
            self.send_response(400)
            self.end_headers()
            self.wfile.write(b"Upload failed: No file found in request.")

# Start the server
http.server.test(HandlerClass=EnhancedHandler, port=8000)
EOF

# 4. Run the server and clean up the temp file on exit
python3 web_server.py
rm web_server.py