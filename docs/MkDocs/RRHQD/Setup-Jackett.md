# Setup a Jackett Docker

## Set up instructions
Follow the setup these instructions to configure the system.

!!! question "User Input for Docker Image"

    * Prompts the user to input the Docker image for Jackett. If the user doesn't provide any input, it defaults to "linuxserver/jackett:latest".

!!! question "User Input for Container Name"

    * Prompts the user to input the name for the Jackett container. If no input is provided, it defaults to "jackett-container".

!!! question "User Input for Exposed Port"

    * Prompts the user to input the port on which Jackett should be exposed. Defaults to port 9117 if no input is provided.

!!! question "User Input for Data Path"

    * Prompts the user to input the path for Jackett data. Defaults to "./Data/jackett-data" if no input is provided.