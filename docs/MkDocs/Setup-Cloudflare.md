# Setup a Cloudflare Tunnel Docker

## Set up instructions
Follow the setup these instructions to configure the system.

### Detecting OS and Setting Sudo
!!! important "Detecting OS and Setting Sudo"

    * The script starts by determining the operating system to adjust command prefixes accordingly. If the OS is Ubuntu, Kali, Linux Mint, or Zorin, it sets USE_SUDO to "sudo".

### Creating Appdata Directory and Setting Permissions
!!! important "Creating Appdata Directory and Setting Permissions"

    * A directory, /mnt/user/appdata/cloudflared/, is created, and its permissions are set to 777. This directory seems to be a storage location for Cloudflared configurations.

### Running Cloudflare Tunnel Login Command
!!! important "Running Cloudflare Tunnel Login Command"

    * The script runs a Docker command to log in to the Cloudflare Tunnel, interacting with the /mnt/user/appdata/cloudflared/ directory.

### Creating a Cloudflare Tunnel
!!! important "Creating a Cloudflare Tunnel"

    * Another Docker command is used to create a Cloudflare tunnel. The configuration is stored in the same directory, and the tunnel is named based on user input.

### Configuring Cloudflare Tunnel for Website(s)
!!! important "Configuring Cloudflare Tunnel for Website(s)"

    * The script prompts the user for information about the website(s) they want to host via the Cloudflare Tunnel. It asks for the number of sites, tunnel UUID, protocol (http/https), reverse proxy IP, port, and domain.

    * Based on the number of sites, it generates a configuration file (config.yml) in the /mnt/user/appdata/cloudflared/ directory.

### Starting the Cloudflare Tunnel
!!! important "Starting the Cloudflare Tunnel"

    * The script concludes by starting the Cloudflare tunnel in detached mode, utilizing the configuration provided by the user.

    * Additionally, for cases where the user wants to host multiple sites, the script uses dialog to display a message box instructing them to manually configure the generated config.yml file for additional sites.