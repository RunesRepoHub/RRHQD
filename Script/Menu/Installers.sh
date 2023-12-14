#!/bin/bash
clear 
source ~/RRHQD/Core/Core.sh

# Display the menu options
function show_menu() {
    echo "Please select an option:"
    echo "1) Run Uptime-Kuma Installer"
    echo "2) Run Vaultwarden Installer"
    echo "3) Run Cloudflare Tunnel Installer"
    echo "4) Exit"
}

# Run the selected script
function run_script() {
    case $1 in
        1)
            bash ~/RRHQD/Script/Installers/Uptime-Kuma.sh
            ;;
        2)
            bash ~/RRHQD/Script/Installers/Vaultwarden.sh
            ;;
        3)
            ~/CnC/files/Installers/install-cloudflare-tunnel.sh
            ;;
        4)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid option. Please try again."
            ;;
    esac
}

# Main loop
while true; do
    show_menu
    read -p "Enter your choice [1-4]: " choice
    run_script $choice
done
