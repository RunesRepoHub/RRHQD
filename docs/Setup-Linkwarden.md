# Setup a Linkwarden docker

## Set up instructions
Follow the setup these instructions to configure the system.


### Setting Environment Variables
!!! important "Setting Environment Variables"

    You'll be asked to provide three pieces of information:

    * NEXTAUTH_SECRET: A secret key for authentication.

    * NEXTAUTH_URL: The URL for authentication requests.

    * POSTGRES_PASSWORD: Password for the PostgreSQL database.

    ```
    Enter the NEXTAUTH_SECRET (it should look like ^7yTjn@G$j@KtLh9&@UdMpdfDZ):
    Enter the NEXTAUTH_URL (it should look like 'http://localhost:3000/api/v1/auth'):
    Enter the POSTGRES_PASSWORD:
    ```

### Validation
!!! important "Validation"

    * Make sure not to leave any field empty; otherwise, an error will be displayed.

    ```
    NEXTAUTH_SECRET is empty. Please enter a valid secret.
    ```

### Write to .env File
!!! important "Write to .env File"

    * If all values are provided, they will be stored in a .env file.

    ```
    NEXTAUTH_SECRET=<your_secret>
    NEXTAUTH_URL=<your_url>
    POSTGRES_PASSWORD=<your_password>
    ```

### Run Docker Compose
!!! important "Run Docker Compose"

    * The setup initiates Docker Compose to start the container in the background.

    ```
    docker compose up -d
    ```

### Check Container Status
!!! important "Check Container Status"

    * After starting, it checks if the Docker container is running successfully.
    bash

    ```
    The Docker container ghcr.io/linkwarden/linkwarden:latest has started successfully.
    ```

    * If there's an issue, an error message will advise you to check the logs for more details.
    sql

    ```
    Failed to start the Docker container ghcr.io/linkwarden/linkwarden:latest. Please check the logs for details.
    ```