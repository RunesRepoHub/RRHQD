# Setup a Ghost docker

## Set up instructions
Follow the setup these instructions to configure the system.


### Setting Environment Variables
!!! question "User Input for Docker Image" 

    * Prompts the user to input the Docker image for Ghost. If the user doesn't provide any input, it defaults to "ghost:latest".

!!! question "User Input for Container Name"

    * Prompts the user to input the name for the Ghost container. If no input is provided, it defaults to "ghost_blog".

!!! question "User Input for URL"

    * Prompts the user to input the url for Ghost. Cannot be skipped.

!!! question "User Input for Exposed Port"

    * Prompts the user to input the port on which Ghost should be exposed. Defaults to port 2368 if no input is provided.

!!! question "User Input for Data Path"

    * Prompts the user to input the path for Ghost data. Defaults to "./ghost/content" if no input is provided.

!!! question "User Input for MySQL Password"

    * Prompts the user to input the MySQL password. 

!!! question "User Input for MySQL Root Password"

    * Prompts the user to input the MySQL root password.

!!! question "User Input for MySQL Data Path"

    * Prompts the user to input the path for MySQL data. Defaults to "./ghost/mysql" if no input is provided. 