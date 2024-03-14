# Requirements ACSF
## Automated Content System Full
### Supported Platforms
![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white) ![Debian](https://img.shields.io/badge/Debian-D70A53?style=for-the-badge&logo=debian&logoColor=white) 

### Made With
![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white) ![GitHub Actions](https://img.shields.io/badge/github%20actions-%232671E5.svg?style=for-the-badge&logo=githubactions&logoColor=white) ![Github Pages](https://img.shields.io/badge/github%20pages-121013?style=for-the-badge&logo=github&logoColor=white)

## Youtube-dl Performence

!!! danger "Performence"

    The Youtube-dl has some issues when it comes to downloading.
    Mainly because of long playlists and/or multiple downloads running at ones.

    This will result in these errors. (And possible more)

    * Can cause a softlog error on proxmox when running it in an VM.

    * The longer the playlists the longer the download. (At download item 86 of 156 it takes 30 mins of 400mb of data, THIS is NOT a networking limit)

    * Can cause a bit of slow down on plex itself if configured to update library on every change dectected in the folder.

### Requriements 
!!! question "Requirements"

    **OS Supported:**

    * Debian 12 CLI "Server"(Tested) 
    * Debian 11 CLI "Server"(Tested)
    * Ubuntu 22.04 Server (Tested - Requires user modification to run)
    * Zorin 16.3 Core (Tested - Requires user modification to run) 
    * Kali Linux 2023.3 (Tested - Requires user modification to run)

    ***Root was installed on all tested OS and is required***

    **User**

    * Username: root (NOT OPTIONAL)
    * Set new password for the root user
    * Enable SSH for root (Optional used for remote access)
    * Change to the root user with `su - root`

    **Docker**

    * Install Docker + Docker-cli on the server.

    **Server**

    * Need to have ~/.bashrc for custom commands
    * Need to have bash installed
    * Need to have a working internet connection
    * Need to be a Debian based server
    * Need to be up to date with the OS (apt-get update + apt-get upgrade)
    * Should have a FTP/SFTP on the server. (Optional)
    
    **Hardware**

    * CPU : 4 cores
    * Memory : 8GB
    * Hard Disk : 100GB

    **Youbtube-dl**

    **Recommended**

    * Use 3 youtube-dl containers with 8gb of RAM for each server.
    * Use 5 youtube-dl containers with 16gb of RAM for each server.

