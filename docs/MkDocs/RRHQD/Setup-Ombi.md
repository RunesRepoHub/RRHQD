# Setup a Ombi docker

## Set up instructions
Follow the setup these instructions to configure the system.

!!! question "User Input for Docker Image"

    * Prompts the user to input the Docker image for Ombi. If the user doesn't provide any input, it defaults to "linuxserver/ombi:latest".

!!! question "User Input for Container Name"

    * Prompts the user to input the name for the Ombi container. If no input is provided, it defaults to "ombi-container".

!!! question "User Input for Exposed Port"

    * Prompts the user to input the port on which Ombi should be exposed. Defaults to port 3579 if no input is provided.

!!! question "User Input for Data Path"

    * Prompts the user to input the path for Ombi data. Defaults to "./Data/ombi-data" if no input is provided.