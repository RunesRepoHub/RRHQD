#!/bin/bash
clear
source ~/RRHQD/Core/Core.sh

script_name=$(basename "$0" .sh)

# Display the initial messages and menu options
function render_welcome_and_menu() {
    echo -e "${Green}Welcome To RRHQD (RunesRepoHub Quick Deploy)${NC}"
    echo -e "${Blue}Current Script: $script_name${NC}"
    echo

    echo -e "${Yellow}Add a Nightly reboot at 4:45 am${NC}"
    echo -e "${Green}This will easily and quickly add a nightly reboot at 4:45 am cronjob.${NC}"
    echo

    echo -e "${Yellow}Add a update cron job at midnight${NC}"
    echo -e "${Green}This will easily and quickly add a nightly update cronjob.${NC}"
    echo

    echo
}

# Display the menu options
function show_menu() {
    echo "Please select an option:"
    echo "1) Add a Nightly reboot at 4:45 am"
    echo "2) Daily Midnight Update"
    echo "3) Coming Soon"
    echo "4) Exit"
}

# Run the selected script
function run_script() {
    case $1 in
        1)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$CRONJOB_FOLDER/$REBOOT_EVERY_NIGHT
            ;;
        2)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$CRONJOB_FOLDER/$UPDATE_DAILY_MIDNIGHT
            ;;
        3)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$CRONJOB_FOLDER/
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

