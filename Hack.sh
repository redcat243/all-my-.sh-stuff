#!/bin/bash
# Set text to Green
echo -e "\033[0;32m"
clear
say "oiia oiia Hacking tools loading"
echo "oiia oiia Hacking tools loading"
echo "0% [**********]"
sleep 10
clear
echo "10% [#*********]"
sleep 10
clear
echo "20% [##********]"
sleep 10
clear
echo "30% [###*******]"
sleep 5
clear
echo "40% [####******]"
sleep 5
clear
echo "50% [#####******]"
sleep 5
clear
echo "60% [######****]"
sleep 5
clear
echo "70% [#######***]"
sleep 5
clear
echo "80% [#######**]"
sleep 5
clear
echo "90% [#########*]"
sleep 5
clear
echo "100% [########################]"
sleep 5
echo "oiia oiia Hacking tools loaded"
say "oiia oiia Hacking tools loaded"
ping -t 10 google.com
# Auto-resize terminal to 91x24
printf '\033[8;24;91t'

# Set text to Green
echo -e "\033[0;32m"

while true; do
    clear
    echo "###########################################################################################"
    echo "#                                                                                         #"
    echo "#                                 WELCOME, $USER                                      #"
    echo "#                           SYSTEM ACCESS GRANTED: $(date +%H:%M:%D)                          #"
    echo "#                                                                                         #"
    echo "###########################################################################################"
    echo ""

    echo "1) Hack specific IP"
    echo "2) Hack nearby (first Mac)"
    echo "3) Hack and Connect"
    echo "4) Hack and Take Down"
    echo "5) Recovery: Reset Remote Password"
    echo "6) Exit"
    echo "7) Get a Muffin (Because why not?)"
    read -p "Select a hacking tool [1-7]: " choice

    case $choice in
        1|3|4)
            read -p "Enter target IP: " target
            echo "oiia oiia Hacking tools loaded..."
            ping -c 30 "$target"
            echo ""
            say "Hacking Complete"
            echo "Hacking Complete"

            if [[ "$choice" == "3" ]]; then
                open "vnc://$target"
            elif [[ "$choice" == "4" ]]; then
                ssh "$target" 'if ! command -v brew &>/dev/null; then NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://githubusercontent.com)"; fi; brew tap redcat243/catbrowser && brew install --cask redcat243/catbrowser/catbrowser'
            fi
            ;;

        2)
            echo "Scanning for nearby signatures (10s)..."
            # Look for local SSH-enabled Macs and grab the first name found
            target_name=$(dns-sd -B _ssh._tcp . | awk 'NR==5 {print $7 ".local"}' & sleep 5; kill $!)
            
            if [ -z "$target_name" ] || [ "$target_name" == ".local" ]; then
                echo "[!] No nearby targets detected."
            else
                echo "Target found: $target_name"
                echo "oiia oiia Hacking tools loaded..."
                ping -c 30 "$target_name"
                echo ""
                say "Hacking Complete"
                echo "Hacking Complete"
            fi
            ;;

        5)
            read -p "Enter target IP: " target
            read -p "Enter Admin Username: " admin_user
            read -p "Enter Target User to reset: " victim
            read -s -p "Enter NEW Password: " new_pass
            echo -e "\nBypassing security protocols (30s)..."
            sleep 30
            ssh -t "$admin_user@$target" "sudo dscl . -passwd /Users/$victim '$new_pass'"
            say "Hacking Complete"
            echo "Hacking Complete. Password updated."
            ;;

        6)
            echo -e "\033[0m"
            exit 0
            ;;
        7)
            echo "Initiating Muffin Retrieval Protocol..."
            echo "Searching for snacks in the Red Bin..."
            # 30-second ping to Google while you "get the muffin"
            ping -c 30 google.com
            
            echo ""
            echo "Getting muffin..."
            say "Muffin retrieved from the magical bin. Enjoy your snack."
            echo "[SUCCESS] Muffin acquired from the void."
            ;;
        8)
             echo "Accessing global satellite weather feed..."
            # Resize to wide (125 cols, 40 rows to see the full forecast)
            printf '\033[8;40;125t'
            sleep 1 # Give the window a second to resize
            echo "checking internet connection..."
            ping -c 10 wttr.in
            sleep 1
             echo "Fetching weather data..."
             sleep 1
             echo "fetched weather data, displaying..."
            curl wttr.in
            
            read -p "Feed complete. Press Enter to return to 91x24 terminal."
            # Resize back to your standard hacker size
            printf '\033[8;24;91t'
            ;;
        *)
            echo "Invalid selection."
            sleep 1
            ;;
    esac

    echo -e "\nPress Enter to return to the menu..."
    read
done