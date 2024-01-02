# RRHQD
RunesRepoHub Quick Deploy this script has been made to make it easy to deploy the most used docker, software and other installers that we use.

### Current Versions:

1. Dev = Development branch (Very unstable)
2. PoC = Proof of concept (Nightly Updates)
3. Prod = Production (Stable branch)

### RunesRepoHub Software Support:

* ACS (Automated Content System)
* CnC-WebGUI (Command And Control)
* CnC-Agent (Command And Control)
* EWD (Easy Web Development)

### Quick Installer Support:

* Starship - A minimalistic, powerful, and extremely customizable prompt for any shell
* Tailscale VPN - A private network that makes securing your online activity and managing your devices easy
* Filezilla - A free software, cross-platform FTP application that supports FTP, SFTP, and FTPS
* Fail2Ban - An intrusion prevention software framework that protects computer servers from brute-force attacks
* Ansible - A radically simple IT automation tool

* Docker (is auto installed) - A set of platform as a service products that use OS-level virtualization to deliver software in packages called containers

### Docker Support:

- Uptime-Kuma - A fancy self-hosted monitoring tool
- Vaultwarden - An unofficial Bitwarden compatible server
- Cloudflare Tunnel - Securely connect your network to the Internet
- MediaCMS - A modern, fully featured open source video and media CMS
- CheckMK - A unified monitoring and alerting system
- MySQL - The world's most popular open source database
- NTFY - A simple and powerful notification service
- Postgres - The world's most popular open source database
- N8N - A workflow automation platform
- llama-GPT - A modern, open source chat bot.

### Dependencies folders:

* RRHQD
* RRHQD-Dockers

> Note: The Docker compose files and the docker volumes are stored in the "RRHQD-Dockers" folder (SO DONT DELETE IT, unless you know what you are doing). The "RRHQD" folder is the main folder for the script.

## How to use

Run the setup via the command below.

Follow the setup "guide" after.

When asked what branch do you want to use, select the branch you want to use. If you want to use a stable branch, select "Prod".

If you want to the nightly updated code base, then use the "PoC" branch.

***Don't use the Dev branch***

```
bash <(wget -qO- https://raw.githubusercontent.com/RunesRepoHub/RRHQD/Prod/Setup.sh)
```

### Custom Commands 

If you want to access the script again after exiting it use the command below.

```
main-menu
```
