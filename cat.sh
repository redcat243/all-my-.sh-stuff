#!/bin/bash

# Auto-resize to 91x24
printf '\033[8;24;91t'
echo -e "\033[0;32m" # Hacker Green

# Progress Bar Function
draw_progress() {
    local duration=$1
    local width=40
    for ((i=0; i<=100; i++)); do
        let "filled = i * width / 100"
        let "empty = width - filled"
        printf "\r\033[KLoading System Modules: ["
        printf "%${filled}s" | tr ' ' '#'
        printf "%${empty}s" | tr ' ' '-'
        printf "] %d%%" "$i"
        sleep "$(bc -l <<< "$duration / 100")"
    done
    echo -e "\n"
}

# Setup Database
mkdir -p ~/Desktop/cat.folder
touch ~/Desktop/cat.folder/passwords.txt

# --- LOGIN SYSTEM ---
while true; do
    clear
    echo "--- CAT.SH SECURE ACCESS ---"
    read -p "1) Sign In | 2) Sign Up: " auth
    if [ "$auth" == "2" ]; then
        read -p "New User: " nu; read -s -p "New Pass: " np
        echo "$nu:$np" >> ~/Desktop/cat.folder/passwords.txt
        echo -e "\nAccount Registered." && sleep 1
    elif [ "$auth" == "1" ]; then
        read -p "Username: " u; read -s -p "Password: " p
        if grep -q "^$u:$p$" ~/Desktop/cat.folder/passwords.txt; then
            echo -e "\nACCESS GRANTED."
            # The Loading Bar (Set to 5 seconds for startup)
            draw_progress 5
            break
        else
            echo -e "\nACCESS DENIED." && sleep 2
        fi
    fi
done

# --- 500 OPTIONS MENU ---
PAGE=1
while true; do
    clear
    START=$(( (PAGE - 1) * 10 + 1 ))
    END=$(( PAGE * 10 ))
    echo "--- CAT.SH TERMINAL (PAGE $PAGE/50) ---"

    for (( i=START; i<=END; i++ )); do
        case $i in
            1) echo "1) [SERVER] Start cat-server.sh (Uploads)";;
            2) echo "2) [LOCAL] Download from Remote cat-server";;
            3) echo "3) [PURGE] Delete Hack.sh (Muffin Protocol)";;
            4) echo "4) [SENSORS] Muffin Retrieval Protocol";;
            *) echo "$i) Hacking Module #$i";;
        esac
    done

    echo "-------------------------------------------------------------------------------------------"
    echo "N) Next Page | P) Previous Page | Q) Logout"
    read -p "Select Tool ($START-$END): " opt

    case $opt in
        [Nn]*) ((PAGE++)); [ $PAGE -gt 50 ] && PAGE=50 ;;
        [Pp]*) ((PAGE--)); [ $PAGE -lt 1 ] && PAGE=1 ;;
        [Qq]*) exec "$0" ;;
        1) # START SERVER
            echo "Starting Cat Server..."
            draw_progress 3
            python3 -m http.server 8000 &
            SERVER_PID=$!
            echo "Server Live on Port 8000. Press Enter to stop."
            read; kill $SERVER_PID ;;
        2) # DOWNLOAD
            read -p "Target IP: " tip
            read -p "Filename: " rfile
            draw_progress 10 # Wait for "connection"
            curl -o ~/Desktop/cat.folder/"$rfile" "http://$tip:8000/$rfile"
            say "Hacking Complete" ;;
        3|4|[0-9]*)
            if [[ $opt -le 500 ]]; then
                echo "Running Module $opt..."
                # 30-second ping/wait as requested
                draw_progress 30 
                ping -c 5 google.com # Short ping just to show activity
                say "Hacking Complete"
                read -p "Press Enter..."
            fi ;;
    esac
done

