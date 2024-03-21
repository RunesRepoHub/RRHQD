##########################################################################
#####  Set variables for RRHQD  # Core.sh # Made for @runesrepohub #####
########################## Made for @rune004 #############################
##########################################################################
##### Styles ######
Black='\e[0;30m'
DarkGray='\e[1;30m'
Red='\e[0;31m'
LightRed='\e[1;31m'
Green='\e[0;32m'
LightGreen='\e[1;32m'
BrownOrange='\e[0;33m'
Yellow='\e[1;33m'
Blue='\e[0;34m'
LightBlue='\e[1;34m'
Purple='\e[0;35m'
LightPurple='\e[1;35m'
Cyan='\e[0;36m'
LightCyan='\e[1;36m'
LightGray='\e[0;37m'
White='\e[1;37m'
NC='\e[0m'  # Reset to default
############################################################################

ROOT_FOLDER=~/RRHQD
SCRIPT_FOLDER=Script
INSTALLER_FOLDER=Installers
MENU_FOLDER=Menu
CRONJOB_FOLDER=Cronjob
LLAMA_GPT_FOLDER=llama-gpt
DOCKER_CNC_FOLDER=Docker-CnC
BACKGROUND=Background
QUICK_TOOLS_DIR=Quick-Tools
YOUTUBE_SCRIPTS_FOLDER=Youtube-Scripts
PRE_MADE_VM_CONFIGS_DIR=Pre-Made-VM-Configs
RRH_SOFTWARE_FOLDER=RRH-Software
ACS_FOLDER=ACS
ACS_SCRIPT_FOLDER=ACSF-Scripts
ACS_DOCKERS=Dockers

## Installers Scripts

CLOUDFLARE_TUNNEL="Cloudflare-Tunnel.sh"
MEDIACMS="MediaCMS.sh"
UPTIME_KUMA="Uptime-Kuma.sh"
VAULTWARDEN="Vaultwarden.sh"
NTFY="NTFY.sh"
N8N="N8N.sh"
POSTGRES="Postgres.sh"
MYSQL="MySQL.sh"
CHECKMK="CheckMK.sh"
LLAMA_GPT="Llama-GPT.sh"
PORTAINER="Portainer.sh"
DELUGE="Deluge.sh"
GHOST="Ghost.sh"
LINKWARDEN="Linkwarden.sh"
MEMOS="Memos.sh"
IT_TOOLS="It-tools.sh"
SONARR="Sonarr.sh"
RADARR="Radarr.sh"
OMBI="Ombi.sh"
JACKETT="Jackett.sh"

## Menu Scripts

DOCKER="Docker.sh"
MAIN_MENU="Main-Menu.sh"
QUICK_INSTALLERS_DIR="Quick-Installers"
QUICK_INSTALLERS="Quick-Installers.sh"
RRH_SOFTWARE="RRH-Software.sh"
CRONJOB="Cronjob.sh"
DOCKER_CNC="Docker-CnC.sh"
QUICK_TOOLS="Quick-Tools.sh"
YOUTUBE_SCRIPTS="Youtube-Script.sh"
PRE_MADE_VM_CONFIGS="Pre-Made-VM-Configs.sh"
ACS_MENU="ACS.sh"
ACS_UPDATE_MENU="ACS-Update-Menu.sh"


## Quick Installers Scripts

STARSHIP="Starship-Installer.sh"
TAILSCALE="Tailscale-Installer.sh"
FILEZILLA="Filezilla-Installer.sh"
FAIL2BAN="Fail2ban-Installer.sh"
ANSIBLE="Ansible-Installer.sh"
PYDIO="Pydio-Installer.sh"

## Cronjob Scripts

REBOOT_EVERY_NIGHT="Reboot-every-night.sh"
REBOOT_EVERY_SUNDAY="Reboot-every-sunday.sh"
UPDATE_DAILY_MIDNIGHT="Update-daily-midnight.sh"
CRONJOB_MANAGER="Cronjob-Manager.sh"
ADD_CRONMOINTER="Add-Cronmointer.sh"
ADD_WEBP_CONVERTER="Add-Webp-Converter.sh"
ADD_SHORT_CLEANUP="Add-Short-Cleanup.sh"

## Docker CnC Scripts

DOCKER_CLEANUP="Docker-Cleanup.sh"
DOCKER_STOP="Docker-Stop.sh"
DOCKER_START="Docker-Start.sh"
DOCKER_UPDATE="Docker-Update.sh"
DOCKER_RESET="Docker-Reset.sh"
DOCKER_REMOVE="Docker-Remove.sh"
DOCKER_EXPORT="Docker-Export.sh"
DOCKER_IMPORT="Docker-Import.sh"

## Background Jobs

SHORT_CLEANUP="Short-Cleanup.sh"
WEBP_TO_JPEG="Webp-to-JPEG.sh"

## RRH-Software

ACS_SETUP="setup.sh"

## Quick Tools Scripts

DISK_CHECK="Disk-Check.sh"
SECURITY_CHECK="Security-Check.sh"
VULNERABILITY_CHECK="Vulnerability-Check.sh"
FULL_SCAN_CHECK="Full-Scan-Check.sh"
MANUALLY_INSTALL_SOFTWARE_UPDATE="Manually-Install-Software-Update.sh"
DISK_CLEANUP="ACS-Cleanup.sh"


## Quick Scripts Scripts

YOUTUBE_DOWNLOAD="Youtube-Download.sh"
YOUTUBE_CHANNEL_DOWNLOAD="Youtube-Channel-Download.sh"
YOUTUBE_CHANNEL_AUTO="Youtube-Channel-Rescan.sh"
YOUTUBE_AUDIO_PLAYLIST="Youtube-Audio-Playlist.sh"
YOUTUBE_STOP_DOWNLOAD="Youtube-Stop-Download.sh"
YOUTUBE_CRONJOB_DOWNLOAD="Youtube-Cronjob-Download.sh"
WEBP_TO_JPEG_MANUEL="Webp-to-JPEG-Manual.sh"

## Pre-Made-VM-Configs

PRE_MADE_VM="RP-Helpdesk-Standard-Config.sh"


## Docker Installer Help Links

GHOST_HELPLINK="https://runesrepohub.github.io/RRHQD/MkDocs/RRHQD/Setup-Ghost.html"
CLOUDFLARE_HELPLINK="https://runesrepohub.github.io/RRHQD/MkDocs/RRHQD/Setup-Cloudflare.html"
CHECKMK_HELPLINK="https://runesrepohub.github.io/RRHQD/MkDocs/RRHQD/Setup-Checkmk.html"
DELUGE_HELPLINK="https://runesrepohub.github.io/RRHQD/MkDocs/RRHQD/Setup-Deluge.html"
LINKWARDEN_HELPLINK="https://runesrepohub.github.io/RRHQD/MkDocs/RRHQD/Setup-Linkwarden.html"
IT_TOOLS_HELPLINK="https://runesrepohub.github.io/RRHQD/MkDocs/RRHQD/Setup-It-tools.html"
JACKETT_HELPLINK="https://runesrepohub.github.io/RRHQD/MkDocs/RRHQD/Setup-Jackett.html"
LLAMA_GPT_HELPLINK="https://runesrepohub.github.io/RRHQD/MkDocs/RRHQD/Setup-Llama-GPT.html"
MEMOS_HELPLINK="https://runesrepohub.github.io/RRHQD/MkDocs/RRHQD/Setup-Memos.html"
MYSQL_HELPLINK="https://runesrepohub.github.io/RRHQD/MkDocs/RRHQD/Setup-MySQL.html"
N8N_HELPLINK="https://runesrepohub.github.io/RRHQD/MkDocs/RRHQD/Setup-N8N.html"
NTFY_HELPLINK="https://runesrepohub.github.io/RRHQD/MkDocs/RRHQD/Setup-NTFY.html"
OMBI_HELPLINK="https://runesrepohub.github.io/RRHQD/MkDocs/RRHQD/Setup-Ombi.html"
PORTAINER_HELPLINK="https://runesrepohub.github.io/RRHQD/MkDocs/RRHQD/Setup-Portainer.html"
POSTGRES_HELPLINK="https://runesrepohub.github.io/RRHQD/MkDocs/RRHQD/Setup-Postgres.html"
RADARR_HELPLINK="https://runesrepohub.github.io/RRHQD/MkDocs/RRHQD/Setup-Radarr.html"
SONARR_HELPLINK="https://runesrepohub.github.io/RRHQD/MkDocs/RRHQD/Setup-Sonarr.html"
UPTIME_KUMA_HELPLINK="https://runesrepohub.github.io/RRHQD/MkDocs/RRHQD/Setup-Uptime-Kuma.html"
VAULTWARDEN_HELPLINK="https://runesrepohub.github.io/RRHQD/MkDocs/RRHQD/Setup-Vaultwarden.html"