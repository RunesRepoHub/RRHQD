# Setup a Sonarr docker

## Set up instructions
Follow the setup these instructions to configure the system.

!!! question "User Input for Docker Image"

    * Prompts the user to input the Docker image for Sonarr. If the user doesn't provide any input, it defaults to "linuxserver/sonarr:latest".

!!! question "User Input for Container Name"

    * Prompts the user to input the name for the Sonarr container. If no input is provided, it defaults to "sonarr-container".

!!! question "User Input for Exposed Port"

    * Prompts the user to input the port on which Sonarr should be exposed. Defaults to port 8989 if no input is provided.

!!! question "User Input for Data Path"

    * Prompts the user to input the path for Sonarr data. Defaults to "./Data/sonarr-data" if no input is provided.