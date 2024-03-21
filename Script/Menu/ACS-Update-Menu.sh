clear
source ~/RRHQD/Core/Core.sh
source ~/RRHQD/Core/ACS-Core.sh

hostname=$(hostname)
ip=$(hostname -I | cut -d' ' -f1)
script_name=$(basename "$0" .sh)

# Use dialog to create a more user-friendly menu
function show_dialog_menu() {
    dialog --clear \
           --backtitle "RRHQD (RunesRepoHub Quick Deploy) - ACS Update Menu Running On $hostname ($ip)" \
           --title "ACS Update Menu - $script_name" \
           --menu "Pick what you want to do:" 15 60 4 \
           1 "Update All ACS Dockers" \
           2 "Update Frontend ACS Dockers" \
           3 "Update Only Movie Node ACS Dockers" \
           4 "Update Only Show Node ACS Dockers" \
           5 "Update Only Plex ACS Dockers" \
           7 "Back To Main Menu" 2>"${INPUT}"

    menu_choice=$(<"${INPUT}")
    case $menu_choice in
        1)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$RRH_SOFTWARE_FOLDER/$ACS_FOLDER/$ACS_SCRIPT_FOLDER/$DOCKER_UPDATE
            ;;
        2)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$RRH_SOFTWARE_FOLDER/$ACS_FOLDER/$ACS_SCRIPT_FOLDER/$DOCKER_UPDATE_FRONTEND
            ;;
        3)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$RRH_SOFTWARE_FOLDER/$ACS_FOLDER/$ACS_SCRIPT_FOLDER/$DOCKER_UPDATE_MOVIE
            ;;
        4)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$RRH_SOFTWARE_FOLDER/$ACS_FOLDER/$ACS_SCRIPT_FOLDER/$DOCKER_UPDATE_SHOW
            ;;
        5)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$RRH_SOFTWARE_FOLDER/$ACS_FOLDER/$ACS_SCRIPT_FOLDER/$DOCKER_UPDATE_PLEX_ONLY
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