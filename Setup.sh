#!/bin/bash

apt-get install sudo -y > /dev/null 2>&1

# Function to check and install missing packages
check_and_install() {
    local package=$1
    if ! command -v "$package" &> /dev/null; then
        echo "$package is not installed. Attempting to install $package..."
        sudo apt-get update && sudo apt-get install -y "$package"
        if ! command -v "$package" &> /dev/null; then
            echo "Failed to install $package. Aborting script."
            exit 1
        fi
        echo "$package has been successfully installed."
    else
        echo "$package is already installed."
    fi
}

# Check and install git if necessary
check_and_install git

# Check and install curl if necessary
check_and_install curl


# Kali Linux specific Docker CE installation
if [ "$OS_DISTRO" = "kali" ]; then
    echo "Detected Kali Linux. Installing Docker CE..."
    sudo apt-get update
    sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian buster stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io
    sudo systemctl enable docker --now
    echo "Docker CE has been installed and started on Kali Linux."
else
    echo "This section is for Kali Linux only. Skipping Docker CE installation for other distributions."
fi


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

# Function to safely execute commands with sudo if not running as root
execute() {
    if [ "$(id -u)" -ne 0 ]; then
        sudo "$@"
    else
        "$@"
    fi
}

# Install dialog package if not already installed
execute apt-get install dialog -y > /dev/null 2>&1

# Download dialog.txt from the GitHub repository into the ROOT_FOLDER
execute curl -fsSL -o "$ROOT_FOLDER/dialog.txt" "https://raw.githubusercontent.com/RunesRepoHub/RRHQD/Dev/dialog.txt"

# Create or overwrite the .dialogrc configuration file in the user's home directory
execute cp "$ROOT_FOLDER/dialog.txt" "${HOME}/.dialogrc"

# Define the GitHub repository URL
GITHUB_REPO_URL="https://github.com/RunesRepoHub/RRHQD.git"

# Ask the user for the branch they want to download
read -p "Enter the branch you want to clone or pull: " branch

# Check if the repository directory already exists
REPO_DIR=$(basename "$GITHUB_REPO_URL" .git)
if [ -d "$REPO_DIR" ]; then
    echo "Directory $REPO_DIR already exists. Attempting to pull the specified branch."
    cd "$REPO_DIR"
    git fetch
    git checkout "$branch"
    git pull origin "$branch"
else
    echo "Cloning the specified branch from the GitHub repository."
    git clone --branch "$branch" "$GITHUB_REPO_URL"
fi

cd ~/RRHQD

# Configure git to only allow fast-forward pulls
git config --global pull.ff only

cd ..

# Check if the alias 'qd' already exists in .bashrc
if grep -q "alias qd=" ~/.bashrc; then
    echo "The alias 'qd' already exists. Would you like to pick a new alias name? (yes/no)"
    read -p "Enter yes or no: " user_choice
    if [[ $user_choice == "yes" ]]; then
        echo "Please enter a new alias name:"
        read -p "New alias name: " new_alias
        # Add the new alias to .bashrc
        echo "alias $new_alias=\"bash ~/RRHQD/Script/Menu/Main-Menu.sh\"" >> ~/.bashrc
    fi
else
    # Add the alias 'qd' to .bashrc
    echo "alias qd=\"bash ~/RRHQD/Script/Menu/Main-Menu.sh\"" >> ~/.bashrc
fi

# Check if the alias 'qd' already exists in .bash_aliases
if grep -q "alias qd=" ~/.bash_aliases; then
    echo "The alias 'qd' already exists in .bash_aliases. Please choose another name."
else
    # Add the alias 'qd' to .bash_aliases
    echo "Adding alias 'qd' to .bash_aliases"
    echo "alias qd=\"bash ~/RRHQD/Script/Menu/Main-Menu.sh\"" >> ~/.bash_aliases
fi

# Source the .bash_aliases to make the new alias available
if [ -f ~/.bash_aliases ]; then
    source ~/.bash_aliases
fi

sleep 3 

bash ~/RRHQD/Script/Menu/Main-Menu.sh


