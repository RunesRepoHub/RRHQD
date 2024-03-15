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

