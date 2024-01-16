#!/bin/bash

source ~/RRHQD/Core/Core.sh

# This script emulates a reboot at 4:45 am every day without using cron or systemd

# Path to the reboot script
REBOOT_SCRIPT="/usr/local/bin/daily_reboot.sh"

# Create a reboot script
cat << 'EOF' | sudo tee "$REBOOT_SCRIPT" > /dev/null
#!/bin/bash
# Script to reboot the server
/bin/systemctl reboot
EOF

# Make the reboot script executable
sudo chmod +x "$REBOOT_SCRIPT"

# Add the script to the root user's crontab
# Note: We are using an infinite loop with a sleep delay to emulate a daily schedule
cat << 'EOF' | sudo tee /etc/init.d/daily_reboot > /dev/null
#!/bin/bash
### BEGIN INIT INFO
# Provides:          daily_reboot
# Required-Start:    $all
# Required-Stop:     
# Default-Start:     2 3 4 5
# Default-Stop:      
# Short-Description: Daily reboot job
### END INIT INFO

case "$1" in
    start)
        while true; do
            # Get the current hour and minute
            current_time=$(date +%H:%M)

            # Check if the current time is 04:45
            if [ "$current_time" = "04:45" ]; then
                "$REBOOT_SCRIPT"
            fi

            # Sleep for 60 seconds before checking again
            sleep 60
        done
        ;;
    stop)
        echo "Stopping daily reboot job is not supported."
        ;;
    *)
        echo "Usage: /etc/init.d/daily_reboot {start|stop}"
        exit 1
        ;;
esac
EOF

# Make the init script executable
sudo chmod +x /etc/init.d/daily_reboot

# Add the init script to the default runlevels
sudo update-rc.d daily_reboot defaults

# Start the daily reboot job
sudo /etc/init.d/daily_reboot start

echo "Daily reboot job has been created and started."

