#!/bin/bash

source ~/RRHQD/Core/Core.sh

echo -e "${Green}Checking for existing reboot cron job...${NC}"

# Determine the current user for the cron job
current_user=$(whoami)

# Set the cron job entry for reboot
cronjob_entry="45 4 * * * $current_user /sbin/reboot"

# Function to add cron job entry
add_cron_job() {
    # Check the OS and adjust the crontab file path accordingly
    local crontab_file="/etc/crontab"
    if [[ -f "/etc/os-release" ]]; then
        . /etc/os-release
        case $ID in
            debian|ubuntu|kali|linuxmint|zorin)
                crontab_file="/etc/crontab"
                ;;
            *)
                echo -e "${Red}Unsupported OS: $ID. Aborting script.${NC}"
                exit 1
                ;;
        esac
    else
        echo -e "${Red}Cannot determine OS. Aborting script.${NC}"
        exit 1
    fi

    # Check if the reboot cron job already exists in the crontab file
    if grep -qF -- "$cronjob_entry" "$crontab_file"; then
        echo -e "${Red}Reboot cron job already exists in $crontab_file. Aborting script.${NC}"
        exit 1
    else
        # Add the reboot cron job to the crontab file
        echo "$cronjob_entry" >> "$crontab_file"
        echo -e "${Green}Reboot cron job added to $crontab_file successfully.${NC}"
    fi
}

# Call the function to add the cron job
add_cron_job

