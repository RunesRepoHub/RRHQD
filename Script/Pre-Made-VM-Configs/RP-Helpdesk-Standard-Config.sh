source ~/RRHQD/Core/Core.sh

# Running the RP-Helpdesk Standard Config
echo -e "${Blue}Running the RP-Helpdesk Standard Config${NC}"

# Install fail2ban
echo -e "${Blue}Install fail2ban${NC}"

bash $ROOT_FOLDER/$SCRIPT_FOLDER/$QUICK_INSTALLERS_DIR/$FAIL2BAN

echo -e "${Green}Fail2ban installed successfully${NC}"

# Setup starship 

echo -e "${Blue}Setup starship${NC}"

bash $ROOT_FOLDER/$SCRIPT_FOLDER/$QUICK_INSTALLERS_DIR/$STARSHIP

echo -e "${Green}Starship installed successfully${NC}"

# Setup filezilla

echo -e "${Blue}Setup filezilla${NC}"

bash $ROOT_FOLDER/$SCRIPT_FOLDER/$QUICK_INSTALLERS_DIR/$FILEZILLA

echo -e "${Green}Filezilla installed successfully${NC}"

# setup cronjobs

echo -e "${Blue}Setup cronjobs${NC}"

bash $ROOT_FOLDER/$SCRIPT_FOLDER/$CRONJOB_FOLDER/$REBOOT_EVERY_NIGHT

bash $ROOT_FOLDER/$SCRIPT_FOLDER/$CRONJOB_FOLDER/$UPDATE_DAILY_MIDNIGHT

echo -e "${Green}Cronjobs installed successfully${NC}"
