# Setup a Checkmk docker

## Set up instructions:
Follow the setup these instructions to configure the system.

!!! question "User Input for Docker Image"

    * Prompts the user to input the Docker image for CheckMK. If the user doesn't provide any input, it defaults to "checkmk/check-mk-raw:latest."

!!! question "User Input for Container Name"

    * Prompts the user to input the name for the CheckMK container. If no input is provided, it defaults to "checkmk-container."

!!! question "User Input for Exposed Port"

    * Prompts the user to input the port on which CheckMK should be exposed. Defaults to port 8080 if no input is provided.

!!! question "User Input for Data Path"

    * Prompts the user to input the path for CheckMK data. Defaults to "./Data/checkmk-data" if no input is provided.

### Docker Compose File Generation
!!! important "Docker Compose File Generation"

    * Defines a subfolder for Docker compose files and creates it if it doesn't exist.

    * Generates a Docker compose file based on user inputs, specifying the CheckMK image, exposed port, and data volume.

### Inform User
!!! important "Inform User"

    * Informs the user about the location of the created Docker compose file.

### Check Docker Status
!!! important "Check Docker Status"

    * Checks if Docker is running, and if not, prompts the user to start Docker and rerun the script. The method of checking depends on the Linux distribution.

### Start Docker Container
!!! important "Start Docker Container"

    * Uses docker-compose to start the CheckMK container in detached mode (-d). It uses sudo if the OS is Ubuntu, Zorin, Linux Mint, or Kali.

### Check Container Start Status
!!! important "Check Container Start Status"

    * Checks if the Docker container has started successfully. If successful, it displays a success message with the container's name and login details. If not, it shows an error message and exits with an error code.