#!/bin/bash
# cat.sh - Client

# --- INITIALIZATION ---
# Create the folder on the current user's desktop
mkdir -p /Users/$USER/Desktop/cat.folder
DB="/Users/$USER/Desktop/cat.folder/passwords.txt"
touch "$DB"

# UI Setup
printf '\033[8;24;91t'
echo -e "\033[0;32m"
clear

meow() {
    if command -v say >/dev/null; then say "meow"; 
    elif command -v spd-say >/dev/null; then spd-say "meow"; 
    else echo -e "\a"; fi
}

get_ip() {
    local REAL_IP=$(ipconfig getifaddr en0 2>/dev/null || ipconfig getifaddr en1 2>/dev/null)
    [ -z "$REAL_IP" ] && REAL_IP="127.0.0.1"
    
    read -p "Server IP (ENTER for $REAL_IP): " mip
    if [ -n "$mip" ]; then echo "$mip"; else echo "$REAL_IP"; fi
}

# --- MAIN HUB ---
while true; do
    clear
    echo "######################### CAT.SH FILE HUB #########################"
    echo "Current User: $USER"
    echo "1) Upload File"
    echo "2) Download File"
    echo "3) Exit"
    read -p ">> " choice
    
    case $choice in
        1)
            IP=$(get_ip)
            read -p "File path: " FILE
            # Expand tilde if user types ~/Desktop...
            FILE="${FILE/#\~/$HOME}"
            if [ -f "$FILE" ]; then
                if curl -F "file=@$FILE" "http://$IP:8000/"; then 
                    echo -e "\n[MEOW! UPLOADED]"; meow
                fi
            else
                echo "Error: File not found."
            fi
            sleep 2 ;;
        2)
            IP=$(get_ip)
            echo -e "\n--- SERVER FILES ---"
            curl -s "http://$IP:8000/list"
            read -p "Filename: " DFILE
            if [ -n "$DFILE" ]; then
                if curl -fO "http://$IP:8000/$DFILE"; then 
                    echo -e "\n[MEOW! DOWNLOADED]"; meow
                fi
            fi
            sleep 2 ;;
        3) exit 0 ;;
    esac
done