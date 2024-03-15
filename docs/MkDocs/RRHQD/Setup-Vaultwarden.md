# Setup a Vaultwarden docker

## Set up instructions
Follow the setup these instructions to configure the system.

!!! question "User Input for Docker Image"

    * Prompts the user to input the Docker image for Vaultwarden. If the user doesn't provide any input, it defaults to "vaultwarden/server:latest."

!!! question "User Input for Container Name"

    * Prompts the user to input the name for the Vaultwarden container. If no input is provided, it defaults to "vaultwarden."

!!! question "User Input for Exposed Port"

    * Prompts the user to input the port on which Vaultwarden should be exposed. Defaults to port 80 if no input is provided.

!!! question "User Input for Data Path"

    * Prompts the user to input the path for Vaultwarden data. Defaults to "./Data/vw-data" if no input is provided.

!!! question "User Input for Admin Token"

    * Prompts the user to input the admin token for Vaultwarden. (CANNOT BE SKIPPED)

!!! question "User Input for Allowed Signups"

    * Prompts the user to pick if signups should be allowed. (CANNOT BE SKIPPED)

!!! question "User Input for Enabled or Disabled WEBSOCKETS"

    * Prompts the user to pick if websockets should be enabled. (CANNOT BE SKIPPED)