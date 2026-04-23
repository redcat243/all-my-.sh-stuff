#!/bin/bash
printf '\033[8;24;91t'
echo -e "\033[0;32m"
clear
echo "--- CAT.SH DATA SERVER ---"
echo "Listening for connections on port 8000..."
echo "Your IP is: $(ipconfig getifaddr en0)"
mkdir -p ~/Desktop/cat.folder && cd ~/Desktop/cat.folder
python3 -m http.server 8000
