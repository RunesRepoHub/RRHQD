#!/bin/bash

source ~/RRHQD/Core/Core.sh

# Display the menu options
function show_menu() {
    echo "Please select an option:"
    echo "1) Find a Installer"
    echo "2) Coming Soon"
    echo "3) Coming Soon"
    echo "4) Coming Soon"
    echo "5) Exit"
}

# Run the selected script
function run_script() {
    case $1 in
        1)
            ~/RRHQD/Script/Menu/Installers.sh
            ;;
        2)
            echo -e "Coming Soon"
            ;;
        3)
            echo -e "Coming Soon"
            ;;
        4)
            echo -e "Coming Soon"
            ;;
        5)
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
    read -p "Enter your choice [1-5]: " choice
    run_script $choice
done
