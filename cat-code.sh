#!/bin/bash
# cat-code - (Password Protected)

# --- INITIALIZATION ---
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

# --- AUTHENTICATION LAYER ---
while true; do
    clear
    echo "########################### CAT-CODE LOGIN ###########################"
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

# --- CONFIG ---
PROJECTS_DIR="$HOME/Desktop"
# Using full paths is safer for scripts
BASE_DIR="$(pwd)" 

# UI Colors
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

while true; do
    echo -e "${CYAN}------------------------------------------------${NC}"
    echo "CAT-CODE COMMANDER | User: $USER"
    echo "1) Open Project"
    echo "2) Start Server"
    echo "3) Start Hack.sh"
    echo "4) Start Loading Screen"
    echo "5) Start File Sharing script"
    echo "6) Exit"
    echo -e "${CYAN}------------------------------------------------${NC}"
    read -p "Selection >> " choice

    case $choice in
        1) 
            echo "--- Desktop Folders ---"
            ls -F "$PROJECTS_DIR" | grep /
            read -p "Folder Name: " p
            # Fixed: Removed the '.' and added a check for VS Code
            if [ -d "$PROJECTS_DIR/$p" ]; then
                open -a "Visual Studio Code" "$PROJECTS_DIR/$p"
            else
                echo -e "${RED}Folder not found.${NC}"
            fi 
            ;;
        2) 
            sudo screen -dmS cat_server bash "$BASE_DIR/cat.sh-server.sh"
            echo "Server started in background (screen)." 
            ;;
        3) 
            [ -f "./Hack.sh" ] && ./Hack.sh || echo -e "${RED}Hack.sh not found.${NC}" 
            ;;
        4) 
            [ -f "./Loading.sh" ] && ./Loading.sh || echo -e "${RED}Loading.sh not found.${NC}" 
            ;;
        5) 
            if [ -f "./cat.sh" ]; then
                # This sets the 'secret handshake' variable
                LAUNCHED_BY_CAT_CODE=true ./cat.sh 
            else
                echo -e "${RED}cat.sh not found.${NC}"
            fi 
            ;; 
            
        6) 
            exit 0 
            ;;
        *) 
            echo "Invalid choice" 
            ;;
    esac
done