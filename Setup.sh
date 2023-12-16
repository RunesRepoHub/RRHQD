#!/bin/bash

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

check_and_install() {
    local pkg=$1
    local install_script=$2
    if ! command -v "$pkg" &> /dev/null; then
        echo "$pkg is not installed. Attempting to install $pkg..."
        if [ -n "$install_script" ]; then
            curl -fsSL "$install_script" -o get-$pkg.sh
            sh get-$pkg.sh
            if ! command -v "$pkg" &> /dev/null; then
                echo "Failed to install $pkg. Aborting script."
                exit 1
            fi
            echo "$pkg has been successfully installed."
        else
            echo "$pkg is not installed. Aborting script."
            exit 1
        fi
    fi
}

# Check if git is installed
check_and_install "git"

# Check if sudo is installed
check_and_install "sudo"

# Check if curl is installed
check_and_install "curl"

# Check if Docker is installed and install it if not
check_and_install "docker" "https://get.docker.com"


# Define the GitHub repository URL
GITHUB_REPO_URL="https://github.com/RunesRepoHub/RRHQD.git"

# Ask the user for the branch they want to download
read -p "Enter the branch you want to clone: " branch
# Clone the specified branch from the GitHub repository
git clone --branch "$branch" $GITHUB_REPO_URL

sleep 3 

bash ~/RRHQD/Script/Menu/Main-Menu.sh

# Add alias for the Main Menu
echo 'alias main-menu="bash ~/RRHQD/Script/Menu/Main-Menu.sh"' >> ~/.bashrc
