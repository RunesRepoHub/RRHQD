# Setup a Deluge Docker

## Set up instructions:
Follow the setup these instructions to configure the system.

# User Input for Docker Image:
!!! important "Docker Image"

    * The script prompts the user to input the Docker image for Deluge. If no input is provided, it defaults to "lscr.io/linuxserver/deluge:latest".

# User Input for Container Name:
!!! important "Container Name"

    * The user is asked to enter a name for the Docker container. If no input is given, it defaults to "deluge-container".

# User Input for Deluge Root Folder and Download Folder:
!!! important "Folders"

    * The script requests the Deluge root folder and download folder. If skipped, default settings (./Data/config for Deluge root folder and ./Data/downloads for the download folder) are used.

# Docker Compose File Generation:
!!! important "Docker Compose Generation"

    * It sets up a subfolder for Docker Compose files (./RRHQD-Dockers/Deluge) and creates a Docker Compose file (docker-compose-$CONTAINER_NAME.yml).

# Docker Compose File Content:
!!! important "Docker Compose Content"

    * The content is generated dynamically using a heredoc. It includes specifications for the Docker Compose version, Deluge service settings (image, container name, network mode, environment variables, volume mappings, ports, and restart policy).

# Folder Creation:
!!! important "Folder Creation"

    * The script ensures the existence of the subfolder for Docker Compose files, creating it if necessary.

# Inform User and Start Container:
!!! important "Inform User and Start Container"

    * The user is informed that the Docker Compose file for Deluge has been created. The script attempts to start the Deluge container using docker compose -f $COMPOSE_FILE up -d.

# Check Container Status:
!!! important "Check Container Status"

    * After the attempt to start the container, it checks if the Docker container has started successfully by querying Docker for the container's ID.

# User Notification:
!!! important "User Notification"

    * If the container started successfully, a success message is displayed using dialog. Otherwise, an error message is shown, and the script exits with an error code.

