#!/bin/bash

source ~/RRHQD/Core/Core.sh

# This script schedules a reboot at 4:45 am every day using systemd timers

# Check if the service and timer files already exist to avoid duplication
SERVICE_FILE="/etc/systemd/system/reboot-server.service"
TIMER_FILE="/etc/systemd/system/reboot-server.timer"

if [[ -f $SERVICE_FILE ]] && [[ -f $TIMER_FILE ]]; then
    echo "Service and Timer files already exist. Please check /etc/systemd/system/ for reboot-server.service and reboot-server.timer."
    exit 1
fi

# Create a systemd service unit file to reboot the server
echo "[Unit]
Description=Reboot the server at 4:45 AM

[Service]
Type=oneshot
ExecStart=/bin/systemctl reboot

[Install]
WantedBy=multi-user.target" > $SERVICE_FILE

# Create a systemd timer unit file to trigger the service
echo "[Unit]
Description=Trigger the server reboot service daily at 4:45 AM

[Timer]
OnCalendar=*-*-* 04:45:00
Persistent=true

[Install]
WantedBy=timers.target" > $TIMER_FILE

# Reload systemd to recognize new timer, enable and start it
systemctl daemon-reload
systemctl enable reboot-server.timer
systemctl start reboot-server.timer

