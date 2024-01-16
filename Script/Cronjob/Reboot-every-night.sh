#!/bin/bash

source ~/RRHQD/Core/Core.sh

# This script schedules a reboot at 4:45 am every day using systemd timers

SERVICE_FILE="/etc/systemd/system/reboot-server.service"
TIMER_FILE="/etc/systemd/system/reboot-server.timer"

create_systemd_service() {
    echo "[Unit]
Description=Reboot the server at 4:45 AM

[Service]
Type=oneshot
ExecStart=/bin/systemctl reboot

[Install]
WantedBy=multi-user.target" | sudo tee $SERVICE_FILE > /dev/null
}

create_systemd_timer() {
    echo "[Unit]
Description=Trigger the server reboot service daily at 4:45 AM

[Timer]
OnCalendar=*-*-* 04:45:00
Persistent=true

[Install]
WantedBy=timers.target" | sudo tee $TIMER_FILE > /dev/null
}

set_up_service_and_timer() {
    # Check if the service and timer files already exist to avoid duplication
    if [[ ! -f $SERVICE_FILE ]] && [[ ! -f $TIMER_FILE ]]; then
        create_systemd_service
        create_systemd_timer

        # Reload systemd to recognize new timer, enable and start it
        sudo systemctl daemon-reload
        sudo systemctl enable reboot-server.timer
        sudo systemctl start reboot-server.timer
        echo "Service and Timer have been created and started."
    else
        echo "Service and/or Timer files already exist. Please check /etc/systemd/system/ for reboot-server.service and reboot-server.timer."
        exit 1
    fi
}

# Call the setup function
set_up_service_and_timer

