#!/bin/bash

source ~/RRHQD/Core/Core.sh

chmod +x $ROOT_FOLDER/$SCRIPT_FOLDER/$BACKGROUND/$WEBP_TO_JPEG

(crontab -l ; echo ) | sort - | uniq - | sudo tee -a /etc/crontab >/dev/null

cron_job_exists() {
    local cron_command="$1"
    grep -qF "$cron_command" /etc/crontab
}

add_cron_job() {
    local cron_command="$1"
    echo "$cron_command" | sudo tee -a /etc/crontab >/dev/null
    dialog --title "Cron Job Added" --msgbox "Cron job added: $cron_command" 6 50
}

reboot_job="*/20 * * * * root bash $ROOT_FOLDER/$SCRIPT_FOLDER/$BACKGROUND/$WEBP_TO_JPEG"

if cron_job_exists "$reboot_job"; then
    dialog --msgbox "Reboot cron job already exists in /etc/crontab. Aborting script." 6 50
    exit 1
else
    add_cron_job "$reboot_job"
    dialog --msgbox "Reboot cron job added to /etc/crontab successfully." 6 50
    exit 0
fi