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

### Quick Installer Support:

* Starship
* Tailscale VPN

### Docker support:

* Uptime-Kuma
* Vaultwarden
* Cloudflare Tunnel
* MediaCMS

### Dependencies folders:

* RRHQD
* RRHQD-Dockers

> Note: The Docker compose files and the docker volumes are stored in the "RRHQD-Dockers" folder (SO DONT DELETE IT, unless you know what you are doing). The "RRHQD" folder is the main folder for the script.

## How to use

Run the setup via the command below.

Follow the setup "guide" after.

When asked what branch do you want to use, select the branch you want to use. The default is the "Dev" branch. But if you want to use a stable branch, select "Prod".

If you want to the nightly updated code base, then use the "PoC" branch.

```
bash <(wget -qO- https://raw.githubusercontent.com/RunesRepoHub/RRHQD/Dev/Setup.sh)
```

### Custom Commands 

If you want to access the script again after exiting it use the command below.

```
main-menu
```