#!/bin/bash

source ~/RRHQD/Core/Core.sh

cron_job_exists() {
    local cron_command="$1"
    grep -qF "$cron_command" /etc/crontab
}

add_cron_job() {
    local cron_command="$1"
    echo "$cron_command" | sudo tee -a /etc/crontab >/dev/null
    echo "Cron job added: $cron_command"
}

reboot_job="45 4 * * * root /sbin/reboot"

if cron_job_exists "$reboot_job"; then
    echo "Reboot cron job already exists in /etc/crontab. Aborting script."
    exit 1
else
    add_cron_job "$reboot_job"
    echo "Reboot cron job added to /etc/crontab successfully."
    exit 0
fi

