# ACS (Automated Content System)

## Introduction

!!! bug "Important"

    ### Important

    This software is still in development.

    Please report bugs to [Github](https://github.com/RunesRepoHub/ACS/issues)

!!! important "ACSF (Automated Content System Full)"
    
    Redefining media server management, our user-friendly software combines a sleek interface with powerful automation. Ideal for users with robust servers, it effortlessly downloads movies, shows, and YouTube videos, while intuitively configuring and maintaining Plex, Ombi, Jackett, Sonarr, Radarr, Deluge, Tautulli, and Mikenye/YouTube-dl Docker containers. 

    ### Get a visual breakdown of the setup.

    ![Alt text](img/setup-breakdown.png)

## Enjoy

!!! Success "Enjoy the simplicity of organized folders and files, making setup and maintenance a breeze."

    Enjoy the simplicity of organized folders and files, making setup and maintenance a breeze. Elevate your media server experience with an innovative solution that seamlessly integrates ease of use with advanced capabilities.

## Warnings

!!! failure "Root User Required"

    ### Root User Required

    This software will only run as root. ***YOU CAN NOT RUN IT AS A NORMAL USER***.

??? danger "Docker is required"

    ### Docker is required

    Docker is required to run this software

    [Get Docker on Debian 12](https://linuxiac.com/how-to-install-docker-on-debian-12-bookworm/)

    [Get Docker on Debian 11](https://docs.docker.com/engine/install/debian/)

    [Get Docker on Ubuntu 20.04](https://docs.docker.com/engine/install/ubuntu/)


??? danger "Performence"

    ### Youtube-dl Performence

    The Youtube-dl has some issues when it comes to downloading.
    Mainly because of long playlists and/or multiple downloads running at ones.

    This will result in these errors. (And possible more)

    * Can cause a softlog error on proxmox when running it in an VM.

    * The longer the playlists the longer the download. (At download item 86 of 156 it takes 30 mins of 400mb of data, THIS is NOT a networking limit)

    * Can cause a bit of slow down on plex itself if configured to update library on every change dectected in the folder.

    