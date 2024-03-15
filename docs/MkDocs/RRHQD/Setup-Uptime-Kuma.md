# Setup a Uptime Kuma docker

## Set up instructions
Follow the setup these instructions to configure the system.

!!! question "User Input for Docker Image"

    * Prompts the user to input the Docker image for Uptime Kuma. If the user doesn't provide any input, it defaults to "louislam/uptime-kuma:1".

!!! question "User Input for Container Name"

    * Prompts the user to input the name for the Uptime Kuma container. If no input is provided, it defaults to "uptime-kuma-container".

!!! question "User Input for Exposed Port"

    * Prompts the user to input the port on which Uptime Kuma should be exposed. Defaults to port 3001 if no input is provided.

!!! question "User Input for Data Path"

    * Prompts the user to input the path for Uptime Kuma data. Defaults to "./Data/kuma-data" if no input is provided.