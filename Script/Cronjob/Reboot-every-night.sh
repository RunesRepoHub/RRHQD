#!/bin/bash

source ~/RRHQD/Core/Core.sh

# This script schedules a reboot at 4:45 am every day using the systemd timers instead of cron

# Create a systemd service unit file to reboot the server
cat << EOF > /etc/systemd/system/reboot-server.service
[Unit]
Description=Reboot the server at 4:45 AM

[Service]
Type=oneshot
ExecStart=/sbin/reboot

[Install]
WantedBy=multi-user.target
EOF

# Create a systemd timer unit file to trigger the service
cat << EOF > /etc/systemd/system/reboot-server.timer
[Unit]
Description=Trigger the server reboot service daily at 4:45 AM

[Timer]
OnCalendar=*-*-* 04:45:00
Persistent=true

[Install]
WantedBy=timers.target
EOF

# Reload systemd to recognize new timer and enable it
systemctl daemon-reload
systemctl enable reboot-server.timer
systemctl start reboot-server.timer
