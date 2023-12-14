#!/bin/bash

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Docker is not installed. Aborting script."
    exit 1
fi

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo "Git is not installed. Aborting script."
    exit 1
fi

# Check if sudo is installed
if ! command -v sudo &> /dev/null; then
    echo "Sudo is not installed. Aborting script."
    exit 1
fi

# Check if curl is installed
if ! command -v curl &> /dev/null; then
    echo "Curl is not installed. Aborting script."
    exit 1
fi


# Define the GitHub repository URL
GITHUB_REPO_URL="https://github.com/RunesRepoHub/RRHQD.git"

# Ask the user for the branch they want to download
read -p "Enter the branch you want to clone: " branch
# Clone the specified branch from the GitHub repository
git clone --branch "$branch" $GITHUB_REPO_URL

sleep 3 

bash ~/RRHQD/Script/Menu/Main-Menu.sh

