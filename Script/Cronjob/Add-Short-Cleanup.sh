#!/bin/bash

source ~/RRHQD/Core/Core.sh

chmod +x $ROOT_FOLDER/$SCRIPT_FOLDER/$BACKGROUND/$SHORT_CLEANUP

if grep -q "$ROOT_FOLDER/$SCRIPT_FOLDER/$BACKGROUND/$SHORT_CLEANUP" /etc/crontab; then
    dialog --msgbox "Cronjob already exists in /etc/crontab. Aborting script." 6 50
    exit 1
fi

(crontab -l ; echo "*/20 * * * * root bash $ROOT_FOLDER/$SCRIPT_FOLDER/$BACKGROUND/$SHORT_CLEANUP") | sort - | uniq - | sudo tee -a /etc/crontab >/dev/null


if grep -q "$ROOT_FOLDER/$SCRIPT_FOLDER/$BACKGROUND/$SHORT_CLEANUP" /etc/crontab; then
    dialog --msgbox "Cronjob added to /etc/crontab successfully." 6 50
else
    dialog --msgbox "Failed to add cronjob to /etc/crontab." 6 50
fi

