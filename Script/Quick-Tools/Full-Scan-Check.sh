#!/bin/bash

# Check if Python and pip are installed
if command -v python3 &> /dev/null && command -v pip3 &> /dev/null; then
    echo "Python and pip are installed."
else
    echo "Error: Python and/or pip are not installed."
    exit 1
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
ensure_tool_installed unicornscan
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
    echo "OpenVAS Scan Results:"
    cat "$OPENVAS_RESULTS"
    echo "Burp Suite Scan Results:"
    cat "$BURP_SUITE_RESULTS"
    echo "w3af Scan Results:"
    cat "$W3AF_RESULTS"
    echo "OWASP ZAP Scan Results:"
    cat "$WASP_ZAP_RESULTS"
    echo "Nmap Scan Results:"
    cat "$NMAP_RESULTS"
    echo "Masscan Scan Results:"
    cat "$MASSCAN_RESULTS"
    echo "OSINT Results:"
    cat "$OSINT_RESULTS"
    echo "Unicornscan Results:"
    cat "$UNICORNSCAN_RESULTS"
    echo "DNSrecon Results:"
    cat "$DNSRECON_RESULTS"
} > "$LOG_FILE"

echo "Full security scan complete. Review the results in $LOG_FILE"
