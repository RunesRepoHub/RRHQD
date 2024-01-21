#!/bin/bash

# Configuration for logging
LOG_DIR="$HOME/RRHQD/logs"
LOG_FILE="$LOG_DIR/security_check.log"  # Log file location for security checks

# Function to increment log file name for security checks
increment_log_file_name() {
  local log_file_base_name="security_check_run_"
  local log_file_extension=".log"
  local log_file_counter=1

  while [[ -f "$LOG_DIR/${log_file_base_name}${log_file_counter}${log_file_extension}" ]]; do
    ((log_file_counter++))
  done

  LOG_FILE="$LOG_DIR/${log_file_base_name}${log_file_counter}${log_file_extension}"
  dialog --title "Log File" --msgbox "Log file for security check will be saved as $LOG_FILE" 6 50
}

# Ensure the dialog package is installed
if ! command -v dialog &> /dev/null; then
    echo "Installing dialog package for better user interface..."
    sudo apt-get update && sudo apt-get install dialog -y
fi

# Create log directory if it doesn't exist
mkdir -p "$LOG_DIR"

# Increment log file name for this run
increment_log_file_name

# Redirect all output to the log file
exec > >(tee -a "$LOG_FILE") 2>&1

# Full system scan for malware and unwanted files
LOG_DIR="/var/log/security_scan"
LOG_FILE="$LOG_DIR/scan_results.log"
MALWARE_SCAN_RESULTS="$LOG_DIR/malware_scan.log"
UNWANTED_FILES_RESULTS="$LOG_DIR/unwanted_files.log"

# Ensure ClamAV and Rkhunter are installed
if ! command -v clamscan &> /dev/null || ! command -v rkhunter &> /dev/null; then
  dialog --title "Installation" --infobox "Installing necessary tools: ClamAV and Rkhunter" 5 50
  sudo apt-get update && sudo apt-get install clamav rkhunter -y
fi

# Create log directory if it doesn't exist
mkdir -p "$LOG_DIR"

# Update virus databases
dialog --title "Update" --infobox "Updating ClamAV virus databases..." 5 50
sudo freshclam

# Start malware scan using ClamAV
dialog --title "Malware Scan" --infobox "Scanning the system for malware..." 5 50
sudo clamscan --recursive --infected --remove --log="$MALWARE_SCAN_RESULTS" /

# Update Rkhunter's database
dialog --title "Update" --infobox "Updating Rkhunter's database..." 5 50
sudo rkhunter --update

# Check the system with Rkhunter
dialog --title "Rootkit Check" --infobox "Checking the system for rootkits..." 5 50
sudo rkhunter --checkall --skip-keypress --report-warnings-only --logfile "$LOG_DIR/rkhunter_scan.log"

# Find and list unwanted files (e.g. temporary files, cache files, etc.)
dialog --title "File Search" --infobox "Searching for unwanted files..." 5 50
sudo find / -type f \( -name '*.tmp' -o -name '*.cache' \) -print > "$UNWANTED_FILES_RESULTS"

# Review unwanted files before removal
dialog --title "Review Unwanted Files" --textbox "$UNWANTED_FILES_RESULTS" 20 80

# Uncomment the following line to automatically remove the found unwanted files after reviewing them
# sudo xargs rm < "$UNWANTED_FILES_RESULTS"

# Output results to a log file
{
  echo "Malware Scan Results:"
  cat "$MALWARE_SCAN_RESULTS"
  echo "Unwanted Files:"
  cat "$UNWANTED_FILES_RESULTS"
} > "$LOG_FILE"

dialog --title "Scan Complete" --msgbox "Full system scan complete. Review the results in $LOG_FILE" 6 50

