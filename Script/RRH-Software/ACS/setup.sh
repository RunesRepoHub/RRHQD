#!/bin/bash

source ~/RRHQD/Core/Core.sh

# Check if sudo is installed
echo -e "${Purple}Check if sudo is installed${NC}"
if ! command -v sudo &> /dev/null; then
    echo -e "${Red}Sudo is not installed.${NC}"
    echo -e "${Yellow}Installing sudo...${NC}"
    apt-get install sudo -y > /dev/null 2>&1
    echo -e "${Green}Sudo has been installed${NC}"
else
    echo -e "${Green}Sudo is already installed.${NC}"
fi 

# Check if curl is installed
echo -e "${Purple}Check if curl is installed${NC}"
if ! command -v curl &> /dev/null; then
    echo -e "${Red}Curl is not installed.${NC}"
    echo -e "${Yellow}Installing curl...${NC}"
    sudo apt-get install curl -y > /dev/null 2>&1
    echo -e "${Green}Curl has been installed${NC}"
else
    echo -e "${Green}Curl is already installed.${NC}"
fi

# Check if git is installed
if ! command -v git &> /dev/null; then
    # Install git
    echo "Git is not installed. Installing..."
    sudo apt-get update
    sudo apt-get install -y git
    echo "Git installation completed."
fi

# Detect the distribution name from /etc/os-release
OS_DISTRO=$(grep '^NAME=' /etc/os-release | cut -d '=' -f 2 | tr -d '"')

# Kali Linux specific Docker CE installation
if [ "$OS_DISTRO" = "Kali GNU/Linux" ]; then
    echo "Detected Kali Linux. Installing Docker CE..."
    sudo apt-get update
    sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian buster stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io
    sudo systemctl enable docker --now
    echo "Docker CE has been installed and started on Kali Linux."
fi

if [ "$OS_DISTRO" != "Kali GNU/Linux" ]; then
    # Check if Docker is installed and install it if not
    if ! command -v docker &> /dev/null; then
        echo "Docker is not installed. Attempting to install Docker..."
        curl -fsSL https://get.docker.com -o get-docker.sh
        sh get-docker.sh
        if ! command -v docker &> /dev/null; then
            echo "Failed to install Docker. Aborting script."
            exit 1
        fi
        echo "Docker has been successfully installed."
    fi
fi


# Check if the folder already exists
set -e
if [ -d ~/ACS ]; then
    echo -e "${Yellow}ACS folder already exists.${NC}"
    exit 0
else
    echo "${Yellow}Folder does not exist. Continuing the script.${NC}"
fi


chmod +x ~/RRHQD/Core/ACS-Core.sh
source ~/RRHQD/Core/ACS-Core.sh

# Start clean
clear 

# Check if docker, docker cli, containerd.io, and docker-buildx-plugin are installed
if ! command -v docker &> /dev/null; then
    echo -e "${Red}Error code: 5 (Not installed)${NC}"
    echo -e "${Red}Install Docker and Docker-CLI before running ACS.${NC}"
    echo -e "${Red}Aborting installation.${NC}"
    exit 1
fi

# Install needed tools for installation script to work
echo -e "${Purple}Setting up ACS...${NC}"
echo -e "${Yellow}Run apt-get update${NC}"
sudo apt-get update > /dev/null 2>&1
echo -e "${Yellow}Run apt-get upgrade -y${NC}"
sudo apt-get upgrade -y > /dev/null 2>&1

# Check if docker images are downloaded
echo -e "${Purple}Downloading docker images${NC}"
images=("mikenye/youtube-dl" "plexinc/pms-docker" "lscr.io/linuxserver/jackett:latest" "lscr.io/linuxserver/radarr:latest" "lscr.io/linuxserver/sonarr:latest" "lscr.io/linuxserver/tautulli:latest" "lscr.io/linuxserver/deluge:latest" "lscr.io/linuxserver/ombi:latest") 
for image in "${images[@]}"; do
    if ! docker image inspect "$image" &> /dev/null; then
        echo -e "${Yellow}Downloading${NC} ${Blue}$image...${NC}"
        sudo docker pull "$image" > /dev/null 2>&1
        echo -e "${Blue}$image${NC} ${Green}has been downloaded.${NC}"
    else
        echo -e "${LightBlue}$image${NC} ${Green}is already downloaded.${NC}"
    fi
done

# Check if ~/plex/media, ~/plex/transcode, and ~/plex/plex/database exist
echo -e "${Purple}Making folders for plex. media, transcode, and library...${NC}"
if [ ! -d $YOUTUBE ] || [ ! -d $TRANSCODE ] || [ ! -d $LIBRARY ] || [ ! -d $JACKETT ] || [ ! -d $RADARR ] || [ ! -d $MOVIES ] || [ ! -d $SONARR ] || [ ! -d $SHOWS ] || [ ! -d $MEDIA_DOWNLOAD ] || [ ! -d $TAUTALLI ] || [ ! -d $DELUGE ] || [ ! -d $OMBI ] || [ ! -d $DOWNLOAD_COMPLETED ]; then
    # Create the folders if they don't exist
    mkdir -p $YOUTUBE $TRANSCODE $LIBRARY $JACKETT $RADARR $MOVIES $SONARR $SHOWS $MEDIA_DOWNLOAD $TAUTALLI $DELUGE $OMBI $DOWNLOAD_COMPLETED
else
    echo -e "${Red}Folders already exist.${NC}"
    echo -e "${Red}The installation might fail due to this error${NC}"
fi
echo -e "${Green}Folders created${NC}"

sudo chmod 777 $MOVIES
sudo chmod 777 $SHOWS
sudo chmod 777 $MEDIA_DOWNLOAD
sudo chmod 777 $DOWNLOAD_COMPLETED

# Take user input and save it to a file
echo -e "${Purple}Enter the maximum number of containers to run for the youtube downloader${NC}"
echo -e "${Yellow}These containers are used to download videos${NC}"
read -p "Max Containers: " userInput
echo "$userInput" > $CONTAINER_MAX_FILE

sleep 2


echo -e "${Purple}Please choose an option:${NC}"
echo -e "1) Deploy only Plex"
echo -e "2) Deploy full system"
read -p "Enter your choice (1 or 2): " deployment_choice

case $deployment_choice in
    1)
        echo -e "${Purple}Setting up Plex only...${NC}"
        if ! sudo docker ps --filter "name=plex" --format '{{.Names}}' | grep -q "plex"; then
            bash ~/RRHQD/RRH-Software/ACS/ACSF-Scripts/setup-only-plex.sh
            echo -e "${Green}Plex setup completed${NC}"
        else
            echo -e "${Green}Plex docker is already running${NC}"
        fi

        ;;
    2)
        echo -e "${Purple}Setting up full system...${NC}"
        if ! sudo docker ps --filter "name=plex" --format '{{.Names}}' | grep -q "plex"; then
            bash ~/RRHQD/RRH-Software/ACS/ACSF-Scripts/setup-plex.sh
            echo -e "${Green}Plex setup completed${NC}"
        else
            echo -e "${Green}Plex docker is already running${NC}"
        fi
        ;;
    *)
        echo -e "${Red}Invalid option selected. Please enter 1 or 2.${NC}"
        ;;
esac



# Add alias
echo -e "${Purple}Setup cronjob and alias${NC}"
# Add aliases to the shell configuration file

bash $ROOT_FOLDER/$ALIASES

# Add the cronjob
cron_job_exists() {
    local cron_command="$1"
    grep -qF "$cron_command" /etc/crontab
}

add_cron_job() {
    local cron_command="$1"
    echo "$cron_command" | sudo tee -a /etc/crontab >/dev/null
    echo "Cron job added: $cron_command"
}

# Check if cron jobs have already been added, if not, add them
automated_check_job="$CRON_TIMER root bash $ROOT_FOLDER/$AUTOMATED_CHECK"
reboot_job="45 4 * * * root /sbin/reboot"

if ! cron_job_exists "$automated_check_job"; then
    add_cron_job "$automated_check_job"
fi

if ! cron_job_exists "$reboot_job"; then
    add_cron_job "$reboot_job"
fi
echo -e "${Green}Cron job completed${NC}"

echo 
echo -e "${Green}Installation completed${NC}"
echo -e "${Yellow}In order for the custom commands to load run 'source ~/.bashrc'${NC}"
echo -e "${BrownOrange}Find all custom commands here https://runesrepohub.github.io/ACS/commands.html${NC}"