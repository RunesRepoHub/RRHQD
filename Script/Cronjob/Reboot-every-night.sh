#!/bin/bash

source ~/RRHQD/Core/Core.sh

#!/bin/bash

# Install AT command scheduler
apt install at

# Define the reboot command without using systemd or cronjob/crontab
reboot_command="/sbin/shutdown -r +5"

# Determine the OS distribution
os_distro=$(grep '^ID=' /etc/os-release | cut -d '=' -f 2 | tr -d '"')

# Check if the current OS is one of the target distributions
case "$os_distro" in
  kali|ubuntu|debian|zorin|linuxmint)
    # Schedule the reboot using at command
    $reboot_command | at 04:45
    ;;
  *)
    echo "This script does not support the current OS: $os_distro"
    exit 1
    ;;
esac
