#!/bin/bash

# Configuration for logging
LOG_DIR="$HOME/RRHQD/logs"
LOG_FILE="$LOG_DIR/cronjob_menu.log"  # Log file location for cronjob menu script

# Function to increment log file name for cronjob menu script
increment_log_file_name() {
  local log_file_base_name="cronjob_menu_run_"
  local log_file_extension=".log"
  local log_file_counter=1

  while [[ -f "$LOG_DIR/${log_file_base_name}${log_file_counter}${log_file_extension}" ]]; do
    ((log_file_counter++))
  done

  LOG_FILE="$LOG_DIR/${log_file_base_name}${log_file_counter}${log_file_extension}"
  echo "Log file for cronjob menu script will be saved as $LOG_FILE"
}

# Create log directory if it doesn't exist
mkdir -p "$LOG_DIR"

# Increment log file name for this run
increment_log_file_name

# Redirect all output to the log file
exec > >(tee -a "$LOG_FILE") 2>&1

clear
source ~/RRHQD/Core/Core.sh

script_name=$(basename "$0" .sh)

# Use dialog to create a more user-friendly menu
function show_dialog_menu() {
    dialog --clear \
           --backtitle "RRHQD (RunesRepoHub Quick Deploy)" \
           --title "Cronjob Menu - $script_name" \
           --menu "Pick what cronjob you want to add:" 15 60 4 \
           1 "Add a Nightly reboot at 4:45 am" \
           2 "Daily Midnight Update" \
           3 "Add a Reboot cron job for every Sunday at 00:00 am" \
           4 "Back To Main Menu" 2>"${INPUT}"

    menu_choice=$(<"${INPUT}")
    case $menu_choice in
        1)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$CRONJOB_FOLDER/$REBOOT_EVERY_NIGHT
            ;;
        2)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$CRONJOB_FOLDER/$UPDATE_DAILY_MIDNIGHT
            ;;
        3)
            bash $ROOT_FOLDER/$SCRIPT_FOLDER/$CRONJOB_FOLDER/$REBOOT_EVERY_SUNDAY
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

