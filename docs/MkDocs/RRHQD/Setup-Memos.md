# Setup a Memos Docker

## Set up instructions
Follow the setup these instructions to configure the system.

!!! question "User Input for Container Name"

    * Prompts the user to input the name for the Memos container. If no input is provided, it defaults to "memos".

!!! question "User Input for Docker Image"

    * Prompts the user to input the Docker image for Memos. If the user doesn't provide any input, it defaults to "neosmemo/memos:stable".

!!! question "User Input for Data Path"

    * Prompts the user to input the path for Memos data. Defaults to "~/.memos/" if no input is provided.

!!! question "User Input for Exposed Port"

    * Prompts the user to input the port on which Memos should be exposed. Defaults to port 3000 if no input is provided.