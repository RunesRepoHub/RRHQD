# Source Code Description

Get a better understanding of the source code by reading below.

![Alt text](img/folder-structure.png)

## System.

??? abstract "Setup.sh"

    ### Setup.sh

    This script streamlines the setup of the Auto-YT-DL application with a comprehensive set of actions. It defines color variables for terminal output, sets the app version, and ensures a clean environment. Checking for necessary dependencies like Docker, sudo, and curl, the script installs and configures them as needed. 

    It downloads Docker images, shell scripts from GitHub, and establishes essential folders with proper permissions. User interaction is facilitated through prompts for configuration settings, including the maximum number of containers for YouTube downloading. 

    The script automates Plex setup, adds aliases and cron jobs, and concludes with a user-friendly completion message and instructions for utilizing custom commands. This user interface-centric approach enhances both functionality and ease of maintenance.

??? abstract "Setup-plex.sh"

    ### Setup-plex.sh

    This script orchestrates the setup and configuration of various Docker services, ensuring a streamlined and automated deployment. Key functionalities include:

    1. Environment Configuration:

        * Sets IP address and time zone variables.

    2. Docker Network Management:

        * Checks for the existence of the "my_plex_network" Docker network and creates it if absent.

    3. Plex Service Setup:

        * Checks if a Docker container named "plex" is running and skips Plex claim if it is.

        * Prompts the user for the Plex claim if the container is not running.

        * Utilizes the plexinc/pms-docker image to run the Plex service.

    5. Other Docker Services:

        * Deploys several services (jackett, radarr, sonarr, tautulli, deluge, ombi) using Docker containers.

        * Configures each service with specific settings, volumes, and network configurations.

        * Sets services to restart always, ensuring automatic startup upon system restart.

    This comprehensive script not only establishes a functional media server environment but also ensures the resilience of services through automatic restart configurations. The user interaction for Plex claim adds a layer of customization to suit individual preferences. 

## User interaction.

??? note "Download.sh"

    ### Download.sh

    The script efficiently manages the mikenye/youtube-dl Docker image, first checking for its presence and displaying a corresponding message if it exists. If the image is not already downloaded, the script utilizes the "docker pull" command to fetch the mikenye/youtube-dl Docker image. 

    A confirmation message is then displayed, informing the user that the image has been successfully downloaded. This ensures that the latest version of the image is readily available for use in the Auto-YT-DL application, enhancing the script's functionality and user communication.

??? note "Uninstall.sh"

    ### Uninstall.sh

    This user-interactive script facilitates the management of the Plex media folder based on user preferences. After prompting the user to choose between keeping or deleting the Plex media folder, the script dynamically adjusts its actions accordingly:

    1. Keep Plex Media Folder Option:

        * Stops and removes Docker containers with the mikenye/youtube-dl image.

        * Stops and removes Docker containers for jackett, radarr, sonarr, tautulli, deluge, and ombi.

        * Removes the my_plex_network Docker network.

        * Clears all folders and files associated with the Auto-YT-DL application except for the Plex media folder.

        * Removes the line from the crontab file that runs the automated-check.sh script.

    2. Delete Plex Media Folder Option (In addition to the above):

        * Removes the Plex media folder.

    3. Invalid Response Handling:

        * Displays an error message for invalid responses, guiding the user to provide a valid input.

    This modular and responsive design ensures that the script caters to user preferences while maintaining clarity and control over the automated cleanup process.

??? note "Update.sh"

    ### Update.sh

    This script enhances maintainability and functionality through the following steps:

    1. Environment Configuration:

        * Sets the "Dev" variable to "Production" and exports it as an environment variable.

    2. Updating "download-update.sh" Script:

        * Removes the existing "download-update.sh" file.

        * Downloads the latest version from a GitHub repository, dynamically selecting the version based on the value of the "Dev" variable.

    3. User Notification:

        * Displays a message notifying the user that the "download-update.sh" script has been updated.

    4. Executing Updated Script:

        * Runs the updated "download-update.sh" script using the "bash" command.

    This sequence of actions ensures that the script is always utilizing the latest version of the "download-update.sh" script from the specified GitHub repository, enhancing efficiency and adaptability in response to potential updates or changes.

??? success "Add-url-list.sh"

    ### Add-url-list.sh

    This script facilitates the management of YouTube playlist URLs with user interaction and file handling. The process unfolds as follows:

    1. User Interaction:

        * Displays a message instructing the user to enter YouTube playlist URLs, prompting them to separate URLs with spaces.

    2. File Checks and Creation:

        * Checks if "url_file.txt" and "archive_url_file.txt" exist in the "~/plex/media" directory.

        * Creates these files if they do not exist.

    3. Reading Existing URLs:

        * Reads existing URLs from the "url_file.txt" file.

    4. User Input Processing:

        * Loops over each URL entered by the user.

    5. URL Validation:

        * Checks if the URL already exists in the "url_file.txt" file using the grep command.

        * If the URL already exists, prompts the user to input another link and calls the "add-url-list.sh" script.

    6. URL Handling:

        * If the URL does not exist, appends the new URL to both "url_file.txt" and "archive_url_file.txt" files.

        * Calls the "download.sh" script.

    This script provides a user-friendly way to manage and download YouTube playlist URLs, preventing duplicates and maintaining a record of URLs for future reference in the "archive_url_file.txt" file.

??? warning "Docker-stop.sh"

    ### Docker-stop.sh

    This script efficiently stops all containers running the "mikenye/youtube-dl" image with the following steps:

    1. User Notification:

        * Displays a message indicating that it is stopping all "mikenye/youtube-dl" containers.

    2. Retrieving Container IDs:

        * Uses the docker ps command with appropriate filters to retrieve the IDs of containers running the "mikenye/youtube-dl" image.

    3. Container Stopping:

        * Iterates over each container ID.

        * Sends a stop command to each container using the docker stop command.

    This systematic approach ensures the graceful termination of all containers associated with the "mikenye/youtube-dl" image, facilitating efficient management and control.

??? warning "Stop-remove.sh"

    ### Stop-remove.shell

    This script orchestrates the efficient shutdown and removal of specified Docker containers and networks. The process unfolds as follows:

    1. Stopping and Removing "mikenye/youtube-dl" Containers:

        * Iterates over container IDs running the "mikenye/youtube-dl" image.

        * Sends a stop command to each container using the docker stop command.

        * Removes each container using the docker rm command.

        * Displays a message confirming the successful stopping and removal of all "mikenye/youtube-dl" containers.

    2. Stopping and Removing Other Containers:

        * Stops and removes Docker containers for plex, jackett, radarr, sonarr, tautulli, deluge, and ombi.

        * Displays a message indicating the successful stopping and removal of these specified containers.

    3. Removing Docker Network:

        * Removes the Docker network "my_plex_network" using the docker network rm command.

        * Displays a message indicating the successful removal of the network.

    This script provides a systematic and user-friendly approach to shutting down and cleaning up Docker containers and networks associated with specified images, enhancing the manageability and reliability of the environment.