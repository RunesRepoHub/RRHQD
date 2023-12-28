#!/bin/bash
clear 
source ~/RRHQD/Core/Core.sh

script_name=$(basename "$0" .sh)

# Display the initial messages and menu options
function render_welcome_and_menu() {
    echo -e "${Green}Welcome To RRHQD (RunesRepoHub Quick Deploy)${NC}"
    echo -e "${Blue}Current Script: $script_name${NC}"
    echo

    echo -e "${Yellow}Run the Tailscale Installer${NC}"
    echo -e "${Green}This will easily and quickly install Tailscale.${NC}"
    echo

    echo -e "${Yellow}Run the Starship Installer${NC}"
    echo -e "${Green}This will easily and quickly install Starship.${NC}"
    echo
}

# Display the menu options
function show_menu() {
    echo "Please select an option:"
    echo "1) Run the Tailscale Installer"
    echo "2) Run the Starship Installer"
    echo "3) Run the Filezilla Installer"
    echo "4) Exit"
}

# Run the selected script
function run_script() {
    case $1 in
        1)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$QUICK_INSTALLERS_DIR/$TAILSCALE
            ;;
        2)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$QUICK_INSTALLERS_DIR/$STARSHIP
            sleep 1
            source ~/.bashrc
            ;;
        3)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$QUICK_INSTALLERS_DIR/$FILEZILLA
            ;;
        4)
            echo -e "${Red}Exiting...${NC}"
            clear
            exit 0
            ;;
        *)
            echo -e "${Red}Invalid option. Please try again.${NC}"
            ;;
    esac
}

# Main loop
while true; do
    render_welcome_and_menu
    show_menu
    read -p "Enter your choice [1-4]: " choice
    run_script $choice
done
