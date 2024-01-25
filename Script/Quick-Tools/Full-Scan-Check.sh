#!/bin/bash

# Full Security Check Script

# Configuration for logging
LOG_DIR="/var/log/security_scan"
LOG_FILE="$LOG_DIR/full_security_scan.log"
NMAP_RESULTS="$LOG_DIR/nmap_scan.log"
MASSCAN_RESULTS="$LOG_DIR/masscan_scan.log"

# Function to check for tool installation and install if not present
ensure_tool_installed() {
    if ! command -v "$1" &> /dev/null; then
        dialog --title "Installation Required" --msgbox "$1 is not installed. Attempting to install." 6 50
        sudo apt-get install -y "$1" || {
            dialog --title "Installation Failed" --msgbox "Failed to install $1. Please install it manually." 6 50
            exit 1
        }
    fi
}

# Ensure each tool's installation
ensure_tool_installed nmap
ensure_tool_installed masscan

# Create log directory if it doesn't exist
mkdir -p "$LOG_DIR"

dialog --title "Scanning" --infobox "Starting Nmap scan..." 3 50
nmap -v -A -T4 192.168.1.0/24 > "$NMAP_RESULTS"

dialog --title "Scanning" --infobox "Starting Masscan scan..." 3 50
masscan -p0-65535 --max-rate 30000 --range 192.168.1.1-192.168.1.254 > "$MASSCAN_RESULTS"

# Combine all results into one log file
{
    echo "Nmap Scan Results:"
    cat "$NMAP_RESULTS"
    echo "Masscan Scan Results:"
    cat "$MASSCAN_RESULTS"
} > "$LOG_FILE"

dialog --title "Scan Complete" --msgbox "Full security scan complete. Review the results in $LOG_FILE" 6 50

