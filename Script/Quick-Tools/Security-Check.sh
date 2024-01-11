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
  echo "Log file for security check will be saved as $LOG_FILE"
}

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
  echo "Installing necessary tools: ClamAV and Rkhunter"
  sudo apt-get update && sudo apt-get install clamav rkhunter -y
fi

# Create log directory if it doesn't exist
mkdir -p "$LOG_DIR"

# Update virus databases
echo "Updating ClamAV virus databases..."
sudo freshclam

# Start malware scan using ClamAV
echo "Scanning the system for malware..."
sudo clamscan --recursive --infected --remove --log="$MALWARE_SCAN_RESULTS" /

# Update Rkhunter's database
echo "Updating Rkhunter's database..."
sudo rkhunter --update

# Check the system with Rkhunter
echo "Checking the system for rootkits..."
sudo rkhunter --checkall --skip-keypress --report-warnings-only --logfile "$LOG_DIR/rkhunter_scan.log"

# Find and list unwanted files (e.g. temporary files, cache files, etc.)
echo "Searching for unwanted files..."
sudo find / -type f \( -name '*.tmp' -o -name '*.cache' \) -print > "$UNWANTED_FILES_RESULTS"

# Review unwanted files before removal
echo "Review the list of unwanted files at $UNWANTED_FILES_RESULTS"
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
