clear
source ~/RRHQD/Core/Core.sh
source ~/RRHQD/Core/ACS-Core.sh

hostname=$(hostname)
ip=$(hostname -I | cut -d' ' -f1)
script_name=$(basename "$0" .sh)

if [ ! -d "$HOME/ACS-Dockers" ]; then
    chmod +x ~/RRHQD/Script/RRH-Software/ACS/setup.sh
    bash ~/RRHQD/Script/RRH-Software/ACS/setup.sh
    exit 1
fi

# Use dialog to create a more user-friendly menu
function show_dialog_menu() {
    dialog --clear \
           --backtitle "RRHQD (RunesRepoHub Quick Deploy) - ACS Menu Running On $hostname ($ip)" \
           --title "ACS Menu - $script_name" \
           --menu "Pick what you want to do:" 15 60 4 \
           1 "Youtube Download Scripts" \
           2 "Start All ACS Dockers" \
           3 "Stop All ACS Dockers" \
           4 "Stop and Remove All ACS Dockers" \
           5 "Uninstall All ACS" \
           6 "Usage" \
           7 "Update All ACS Dockers" \
           8 "Automate The Update of All ACS Dockers" \
           9 "Back To Main Menu" 2>"${INPUT}"

    menu_choice=$(<"${INPUT}")
    case $menu_choice in
        1)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$MENU_FOLDER/$YOUTUBE_SCRIPTS
            ;;
        2)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$RRH_SOFTWARE_FOLDER/$ACS_FOLDER/$ACS_SCRIPT_FOLDER/$START
            ;;
        3)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$RRH_SOFTWARE_FOLDER/$ACS_FOLDER/$ACS_SCRIPT_FOLDER/$STOP
            ;;
        4)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$RRH_SOFTWARE_FOLDER/$ACS_FOLDER/$ACS_SCRIPT_FOLDER/$STOP_REMOVE
            ;;
        5)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$RRH_SOFTWARE_FOLDER/$ACS_FOLDER/$ACS_SCRIPT_FOLDER/$UNINSTALL
            ;;
        6)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$RRH_SOFTWARE_FOLDER/$ACS_FOLDER/$ACS_SCRIPT_FOLDER/$USAGE
            ;;
        7)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$MENU_FOLDER/$ACS_UPDATE_MENU
            ;;
        *)
            exit 0
            ;;
    esac
}

# Define the input file for dialog selections
INPUT=/tmp/menu.sh.$$

# Ensure the temp file is removed upon script termination
trap "rm -f $INPUT" 0 1 2 5 15

# Main loop
while true; do
    show_dialog_menu
done