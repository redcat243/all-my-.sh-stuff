#!/bin/bash

# 1. Resize and Stylize
printf '\033[8;24;91t'
echo -e "\033[0;32m"
clear

# 2. Setup Filesystem
mkdir -p ~/Desktop/cat.folder
DB_FILE=~/Desktop/cat.folder/passwords.txt
touch "$DB_FILE"

# --- LOGIN LOOP ---
while true; do
    clear
    echo "============================= CAT.SH SECURE TERMINAL ==============================="
    read -p "1) SIGN IN  |  2) SIGN UP  |  3) EXIT: " auth
    if [ "$auth" == "2" ]; then
        read -p "New User: " nu; read -s -p "New Pass: " np; echo "$nu:$np" >> "$DB_FILE"; sleep 1
    elif [ "$auth" == "1" ]; then
        read -p "User: " u; read -s -p "Pass: " p
        if grep -q "^$u:$p$" "$DB_FILE"; then
            # Startup Loading Bar
            for i in {1..100}; do printf "\rInitialising System... [%-20s] %d%%" $(printf "#%.0s" $(seq 1 $((i/5)))) $i; sleep 0.03; done
            break
        else echo -e "\nACCESS DENIED"; sleep 1; fi
    elif [ "$auth" == "3" ]; then exit 0; fi
done

# --- MAIN MENU ENGINE ---
PAGE=1
while true; do
    clear
    START=$(( (PAGE - 1) * 10 + 1 ))
    END=$(( PAGE * 10 ))
    echo "--- CAT.SH TOOLS HUB (Page $PAGE/50) ---"

    for (( i=START; i<=END; i++ )); do
        # Mapping 500 Unique Tool Names based on Ranges
        if [[ $i -le 50 ]]; then echo "$i) [SYSTEM] Check CPU Usage - Module $i"
        elif [[ $i -le 100 ]]; then echo "$i) [FILE] Backup Folder - Module $i"
        elif [[ $i -le 150 ]]; then echo "$i) [NET] Ping Local Server - Module $i"
        elif [[ $i -le 200 ]]; then echo "$i) [MEDIA] Convert Image - Module $i"
        elif [[ $i -le 300 ]]; then echo "$i) [WEB] Fetch Site Header - Module $i"
        elif [[ $i -le 400 ]]; then echo "$i) [MISC] Weather Report - Module $i"
        elif [[ $i -le 498 ]]; then echo "$i) [DEBUG] Test Terminal Sync - Module $i"
        elif [[ $i -eq 499 ]]; then echo "499) [UPLOAD] Send file to Central Server"
        elif [[ $i -eq 500 ]]; then echo "500) [DOWNLOAD] Pull file from Central Server"
        fi
    done

    echo "-------------------------------------------------------------------------------------------"
    echo "N: Next | P: Prev | Q: Logout"
    read -p "Selection ($START-$END): " opt

    case $opt in
        [Nn]*) ((PAGE++)); [ $PAGE -gt 50 ] && PAGE=50 ;;
        [Pp]*) ((PAGE--)); [ $PAGE -lt 1 ] && PAGE=1 ;;
        [Qq]*) exec "$0" ;;
        499) # UPLOAD LOGIC
            read -p "Target IP: " tip; read -p "File Path: " fp
            for i in {1..100}; do printf "\rUploading... [%-20s] %d%%" $(printf "#%.0s" $(seq 1 $((i/5)))) $i; sleep 0.3; done
            scp "$fp" "$tip:~/Desktop/cat.folder/" && say "Upload Complete" ;;
        500) # DOWNLOAD LOGIC
            read -p "Server IP: " sip; read -p "File Name: " fn
            for i in {1..100}; do printf "\rDownloading... [%-20s] %d%%" $(printf "#%.0s" $(seq 1 $((i/5)))) $i; sleep 0.3; done
            curl -o ~/Desktop/cat.folder/"$fn" "http://$sip:8000/$fn" && say "Download Complete" ;;
        [0-9]*)
            if [ "$opt" -le 500 ]; then
                # Standard 30-second delay for all options
                for i in {1..100}; do printf "\rProcessing Tool #$opt... [%-20s] %d%%" $(printf "#%.0s" $(seq 1 $((i/5)))) $i; sleep 0.3; done
                echo -e "\nTask #$opt executed successfully."
                read -p "Press Enter to return..."
            fi ;;
    esac
done


