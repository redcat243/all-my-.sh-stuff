#!/bin/bash
# cat-server.sh
printf '\033[8;24;91t'
echo -e "\033[0;32m"
clear
echo "--- CAT.SH SERVER CORE ---"
mkdir -p ~/Desktop/cat.folder
cd ~/Desktop/cat.folder

echo "Server starting on port 8000..."
echo "IP Address: $(ipconfig getifaddr en0)"
# Starts a server that allows file browsing and downloading
python3 -m http.server 8000
