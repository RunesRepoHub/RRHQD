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


# Add alias for the Main Menu
echo 'alias main-menu="bash ~/RRHQD/Script/Menu/Main-Menu.sh"' >> ~/.bashrc

sleep 3 

bash ~/RRHQD/Script/Menu/Main-Menu.sh


