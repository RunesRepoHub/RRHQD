#!/bin/bash

LOG_DIR="$HOME/ACSS/logs"
# Configuration
LOG_FILE="$LOG_DIR/youtube_size.log"  # Log file location for youtube-size script

# Function to increment log file name
increment_log_file_name() {
  local log_file_base_name="youtube_size_run_"
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

source ~/ACS/ACSF-Scripts/Core.sh

# Usage: ./calculate_storage_usage.sh /path/to/directory

# Check if du and cut are installed
if ! command -v du &> /dev/null; then
    echo "du (Disk Usage) is not installed. Please install it to proceed."
    exit 1
fi

if ! command -v cut &> /dev/null; then
    echo "cut is not installed. Please install it to proceed."
    exit 1
fi

# Check if the path is provided
if [ -z "$1" ]; then
    echo "Please provide a path to calculate storage usage."
    exit 1
fi

# Assign the path to a variable
SEARCH_PATH="$1"

# Calculate the total storage usage of the path
total_usage=$(du -sh "$SEARCH_PATH" | cut -f1)

# Output the total storage usage
echo "Total storage usage of $SEARCH_PATH: $total_usage"

