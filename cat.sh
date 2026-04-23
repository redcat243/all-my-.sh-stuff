#!/bin/bash

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

while true; do
    clear
    echo "########################### CAT.SH LOGIN ###########################"
    echo "1) Sign In"
    echo "2) Sign Up"
    echo "3) Exit"
    read -p ">> " auth_choice

    if [ "$auth_choice" == "2" ]; then
        read -p "New Username: " nu
        read -s -p "New Password: " np
        echo "$nu:$np" >> "$DB"
        echo -e "\n[ACCOUNT CREATED]"
        sleep 1
    elif [ "$auth_choice" == "1" ]; then
        read -p "Username: " u
        read -s -p "Password: " p
        # Checks if the username:password pair exists in the DB file
        if grep -q "^$u:$p$" "$DB"; then
            echo -e "\n[ACCESS GRANTED]"
            break
        else
            echo -e "\n[ACCESS DENIED]"
            sleep 1
        fi
    elif [ "$auth_choice" == "3" ]; then
        exit 0
    fi
done

# --- MAIN HUB (Only reached if break occurs above) ---
while true; do
    clear
    echo "######################### CAT.SH FILE HUB #########################"
    echo "User: $USER"
    echo "1) Upload File"
    echo "2) Download File"
    echo "3) Exit"
    read -p ">> " choice
    
    case $choice in
        1)
            IP=$(get_ip)
            read -p "File path: " FILE
            FILE="${FILE/#\~/$HOME}" # Handle tilde
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
            echo -e "------------------------\n"
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