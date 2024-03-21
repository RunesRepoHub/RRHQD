clear
source ~/RRHQD/Core/Core.sh
source ~/RRHQD/Core/ACS-Core.sh

hostname=$(hostname)
ip=$(hostname -I | cut -d' ' -f1)
script_name=$(basename "$0" .sh)

# Use dialog to create a more user-friendly menu
function show_dialog_menu() {
    dialog --clear \
           --backtitle "RRHQD (RunesRepoHub Quick Deploy) - ACS Automated Update Menu Running On $hostname ($ip)" \
           --title "ACS Automated Update Menu - $script_name" \
           --menu "Pick what you want to do:" 15 80 4 \
           1 "Setup Automated Update of All ACS Dockers With Cronjobs" \
           2 "Setup Automated Update of Frontend ACS Dockers With Cronjobs" \
           3 "Setup Automated Update of Only Movie Node ACS Dockers With Cronjobs" \
           4 "Setup Automated Update of Only Show Node ACS Dockers With Cronjobs" \
           5 "Setup Automated Update of Only Plex ACS Dockers With Cronjobs" \
           7 "Back To Main Menu" 2>"${INPUT}"

    menu_choice=$(<"${INPUT}")
    case $menu_choice in
        1)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$BACKGROUND/$ADD_AUTOMATED_DOCKER_UPDATE
            ;;
        2)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$BACKGROUND/$ADD_AUTOMATED_FRONTEND_UPDATE
            ;;
        3)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$BACKGROUND/$ADD_AUTOMATED_MOVIE_NODE
            ;;
        4)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$BACKGROUND/$ADD_AUTOMATED_SHOW_NODE
            ;;
        5)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$BACKGROUND/$ADD_AUTOMATED_PLEX_UPDATE
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