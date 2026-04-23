#!/bin/bash
# cat.sh - File Transfer Client (with File Listing)

# UI Setup
printf '\033[8;24;91t'
echo -e "\033[0;32m"
clear

mkdir -p ~/Desktop/cat.folder
DB=~/Desktop/cat.folder/passwords.txt
touch "$DB"

meow() {
    if command -v say >/dev/null; then say "meow"; 
    elif command -v spd-say >/dev/null; then spd-say "meow"; 
    else echo -e "\a"; fi
}

# --- AUTHENTICATION ---
while true; do
    clear
    echo "########################### CAT.SH LOGIN ###########################"
    echo "1) Sign In  2) Sign Up  3) Exit"
    read -p ">> " auth_choice
    if [ "$auth_choice" == "2" ]; then
        read -p "User: " nu; read -s -p "Pass: " np; echo "$nu:$np" >> "$DB"; echo -e "\n[DONE]"; sleep 1
    elif [ "$auth_choice" == "1" ]; then
        read -p "User: " u; read -s -p "Pass: " p
        if grep -q "^$u:$p$" "$DB"; then break; else echo -e "\n[DENIED]"; sleep 1; fi
    elif [ "$auth_choice" == "3" ]; then exit 0; fi
done

# --- SCANNER ---
find_server() {
    local PORT=8000
    local SUBNET=$(ipconfig getifaddr en0 2>/dev/null | cut -d. -f1-3 || hostname -I | awk '{print $1}' | cut -d. -f1-3)
    for i in {1..254}; do
        (timeout 0.1 bash -c "echo > /dev/tcp/$SUBNET.$i/$PORT" 2>/dev/null && echo "$SUBNET.$i") & 
    done | head -n 1 > .server_ip
    wait
    cat .server_ip && rm .server_ip
}

# --- MAIN HUB ---
while true; do
    clear
    echo "######################### CAT.SH FILE HUB #########################"
    echo "1) Upload File"
    echo "2) Download File (View Server Files)"
    echo "3) Exit"
    read -p ">> " choice

    case $choice in
        1)
            IP=$(find_server)
            if [ -z "$IP" ]; then echo "No server found."; sleep 2; continue; fi
            read -p "File path to upload: " FILE
            if [ -f "$FILE" ]; then
                if curl -F "file=@$FILE" "http://$IP:8000/"; then echo "[UPLOADED]"; meow; fi
            fi
            sleep 2 ;;
        2)
            IP=$(find_server)
            if [ -z "$IP" ]; then echo "No server found."; sleep 2; continue; fi
            
            echo -e "\n--- FILES ON SERVER ---"
            # Fetches the file list from the Python server
            curl -s "http://$IP:8000/list"
            echo -e "------------------------\n"
            
            read -p "Enter filename to download: " DFILE
            if [ ! -z "$DFILE" ]; then
                if curl -fO "http://$IP:8000/$DFILE"; then echo "[DOWNLOADED]"; meow; fi
            fi
            sleep 2 ;;
        3) exit 0 ;;
    esac
done
