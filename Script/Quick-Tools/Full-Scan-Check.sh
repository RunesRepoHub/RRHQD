#!/bin/bash

# Check if Python and pip are installed, install if not
if ! command -v python3 &> /dev/null; then
    echo "Python is not installed. Attempting to install Python..."
    sudo apt-get update && sudo apt-get install -y python3
fi

if ! command -v pip3 &> /dev/null; then
    echo "pip is not installed. Attempting to install pip..."
    sudo apt-get update && sudo apt-get install -y python3-pip
fi

# Clone theHarvester repository
git clone https://github.com/laramies/theHarvester
cd theHarvester

# Install dependencies based on the environment
if [ "$ENVIRONMENT" == "development" ]; then
    python3 -m pip install -r requirements/dev.txt
else
    python3 -m pip install -r requirements/base.txt
fi

# Display help for the theHarvester tool
python3 theHarvester.py -h

# Full Security Check Script

# Configuration for logging
LOG_DIR="/var/log/security_scan"
LOG_FILE="$LOG_DIR/full_security_scan.log"
OPENVAS_RESULTS="$LOG_DIR/openvas_scan.log"
BURP_SUITE_RESULTS="$LOG_DIR/burp_suite_scan.log"
W3AF_RESULTS="$LOG_DIR/w3af_scan.log"
WASP_ZAP_RESULTS="$LOG_DIR/wasp_zap_scan.log"
NMAP_RESULTS="$LOG_DIR/nmap_scan.log"
MASSCAN_RESULTS="$LOG_DIR/masscan_scan.log"
OSINT_RESULTS="$LOG_DIR/osint_scan.log"
UNICORNSCAN_RESULTS="$LOG_DIR/unicornscan_scan.log"
DNSRECON_RESULTS="$LOG_DIR/dnsrecon_scan.log"

# Function to check for tool installation and install if not present
ensure_tool_installed() {
    if ! command -v "$1" &> /dev/null; then
        echo "$1 is not installed. Attempting to install."
        sudo apt-get install -y "$1" || {
            echo "Failed to install $1. Please install it manually."
            exit 1
        }
    fi
}

# Ensure each tool's installation
ensure_tool_installed nmap
ensure_tool_installed masscan
ensure_tool_installed dnsrecon

# Create log directory if it doesn't exist
mkdir -p "$LOG_DIR"

echo "Starting Nmap scan..."
nmap -v -A -T4 > "$NMAP_RESULTS"

echo "Starting Masscan scan..."
masscan -p0-65535 --max-rate 1000 > "$MASSCAN_RESULTS"

echo "Performing OSINT (Open Source Intelligence)..."
theharvester > "$OSINT_RESULTS"

echo "Starting Unicornscan..."
unicornscan -mT -Iv > "$UNICORNSCAN_RESULTS"

echo "Starting DNSrecon scan..."
dnsrecon -d example.com > "$DNSRECON_RESULTS" # Replace example.com with the intended domain

# Combine all results into one log file
{
    echo "Nmap Scan Results:"
    cat "$NMAP_RESULTS"
    echo "Masscan Scan Results:"
    cat "$MASSCAN_RESULTS"
    echo "OSINT Results:"
    cat "$OSINT_RESULTS"
    echo "DNSrecon Results:"
    cat "$DNSRECON_RESULTS"
} > "$LOG_FILE"

echo "Full security scan complete. Review the results in $LOG_FILE"
