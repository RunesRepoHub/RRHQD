# Setup a NTFY docker

## Set up instructions
Follow the setup these instructions to configure the system.

!!! question "User Input for Docker Image"

    * Prompts the user to input the Docker image for NTFY. If the user doesn't provide any input, it defaults to "binwiederhier/ntfy:latest".

!!! question "User Input for Container Name"

    * Prompts the user to input the name for the NTFY container. If no input is provided, it defaults to "ntfy-container".

!!! question "User Input for Exposed Port"

    * Prompts the user to input the port on which NTFY should be exposed. Defaults to port 8080 if no input is provided.

!!! question "User Input for Data Path"

    * Prompts the user to input the path for NTFY data. Defaults to "./Data/ntfy-data" if no input is provided.