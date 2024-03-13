clear
source ~/RRHQD/Core/Core.sh

hostname=$(hostname)
ip=$(hostname -I | cut -d' ' -f1)
script_name=$(basename "$0" .sh)

# Use dialog to create a more user-friendly menu
function show_dialog_menu() {
    dialog --clear \
           --backtitle "RRHQD (RunesRepoHub Quick Deploy) - ACS Menu Running On $hostname ($ip)" \
           --title "ACS Menu - $script_name" \
           --menu "Pick what you want to do:" 15 60 4 \
           1 "Start All ACS Dockers" \
           2 "Stop All ACS Dockers" \
           3 "Stop and Remove All ACS Dockers" \
           4 "Uninstall All ACS" \
           5 "Usage" \
           6 "Update All ACS Dockers" \
           7 "Back To Main Menu" 2>"${INPUT}"

    menu_choice=$(<"${INPUT}")
    case $menu_choice in
        1)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$RRH_SOFTWARE_FOLDER/$ACS_FOLDER/$ACS_SCRIPT_FOLDER/$START
            ;;
        2)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$RRH_SOFTWARE_FOLDER/$ACS_FOLDER/$ACS_SCRIPT_FOLDER/$STOP
            ;;
        3)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$RRH_SOFTWARE_FOLDER/$ACS_FOLDER/$ACS_SCRIPT_FOLDER/$STOP_REMOVE
            ;;
        4)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$RRH_SOFTWARE_FOLDER/$ACS_FOLDER/$ACS_SCRIPT_FOLDER/$UNINSTALL
            ;;
        5)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$RRH_SOFTWARE_FOLDER/$ACS_FOLDER/$ACS_SCRIPT_FOLDER/$USAGE
            ;;
        6)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$RRH_SOFTWARE_FOLDER/$ACS_FOLDER/$ACS_SCRIPT_FOLDER/$START
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