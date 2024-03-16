# Setup a Radarr docker

## Set up instructions
Follow the setup these instructions to configure the system.

!!! question "User Input for Docker Image"

    * Prompts the user to input the Docker image for Radarr. If the user doesn't provide any input, it defaults to "linuxserver/radarr:latest".

!!! question "User Input for Container Name"

    * Prompts the user to input the name for the Radarr container. If no input is provided, it defaults to "radarr-container".

!!! question "User Input for Exposed Port"

    * Prompts the user to input the port on which Radarr should be exposed. Defaults to port 7878 if no input is provided.

!!! question "User Input for Data Path"

    * Prompts the user to input the path for Radarr data. Defaults to "./Data/radarr-data" if no input is provided.