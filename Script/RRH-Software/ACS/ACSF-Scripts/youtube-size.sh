#!/bin/bash

SCRIPT_FILENAME=$(basename "$0")

LOG_DIR="$HOME/RRHQD/logs"
# Configuration
LOG_FILE="$LOG_DIR/"$SCRIPT_FILENAME"_install.log"  # Log file location

# Function to increment log file name
increment_log_file_name() {
  local log_file_base_name=""$SCRIPT_FILENAME"_install_run_"
  local log_file_extension=".log"
  local log_file_counter=1

  while [[ -f "$LOG_DIR/${log_file_base_name}${log_file_counter}${log_file_extension}" ]]; do
    ((log_file_counter++))
  done

  LOG_FILE="$LOG_DIR/${log_file_base_name}${log_file_counter}${log_file_extension}"
  echo "Log file will be saved as $LOG_FILE"
}

# Create log directory if it doesn't exist
mkdir -p "$LOG_DIR"

# Increment log file name for this run
increment_log_file_name

# Redirect all output to the log file
exec > >(tee -a "$LOG_FILE") 2>&1


source ~/RRHQD/Core/ACS-Core.sh


# Check if du and cut are installed
if ! command -v du &> /dev/null; then
    sudo apt-get install coreutils -y > /dev/null 2>&1
elif ! command -v cut &> /dev/null; then
    sudo apt-get install coreutils -y > /dev/null 2>&1
else
    dialog --backtitle "RRH-Software" --title "Status" \
           --msgbox "du and cut are already installed." 10 60
fi

SEARCH_PATH=~/plex/media/

# Calculate the total storage usage of the path
total_usage=$(du -sh ~/plex/media/ | cut -f1)

# Output the total storage usage using dialog
dialog --backtitle "RRH-Software" --title "Storage Usage" \
       --msgbox "Total storage usage of $SEARCH_PATH: $total_usage" 10 60

