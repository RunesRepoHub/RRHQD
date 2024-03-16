# Setup a Postgres docker

## Set up instructions
Follow the setup these instructions to configure the system.

!!! question "User Input for Docker Image"

    * Prompts the user to input the Docker image for Postgres. If the user doesn't provide any input, it defaults to "postgres:latest".

!!! question "User Input for Container Name"

    * Prompts the user to input the name for the Postgres container. If no input is provided, it defaults to "postgres-container".

!!! question "User Input for Exposed Port"

    * Prompts the user to input the port on which Postgres should be exposed. Defaults to port 5432 if no input is provided.

!!! question "User Input for Database User"

    * Prompts the user to input the username for the Postgres database. Defaults to "postgres" if no input is provided.

!!! question "User Input for Database Password"

    * Prompts the user to input the password for the Postgres database. (CANNOT BE SKIPPED!)

!!! question "User Input for Database Name"

    * Prompts the user to input the name for the Postgres database. Defaults to "postgres" if no input is provided.

!!! question "User Input for Data Path"

    * Prompts the user to input the path for Postgres data. Defaults to "./postgres-data" if no input is provided.