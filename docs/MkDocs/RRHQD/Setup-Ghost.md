# Setup a Ghost docker

## Set up instructions
Follow the setup these instructions to configure the system.


### Setting Environment Variables
!!! question "Setting Environment Variables"

    * Prompts the user to input the Docker image for Ghost. If the user doesn't provide any input, it defaults to "ghost:latest".

    * Prompts the user to input the name for the Ghost container. If no input is provided, it defaults to "ghost_blog".

    * Prompts the user to input the url for Ghost. Cannot be skipped.

    * Prompts the user to input the port on which Ghost should be exposed. Defaults to port 2368 if no input is provided.

    * Prompts the user to input the path for Ghost data. Defaults to "./ghost/content" if no input is provided.

    * Prompts the user to input the MySQL password. 

    * Prompts the user to input the MySQL root password.

    * Prompts the user to input the path for MySQL data. Defaults to "./ghost/mysql" if no input is provided. 