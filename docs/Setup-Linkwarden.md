# Setup a Linkwarden docker

## Set up instructions:
Follow the setup these instructions to configure the system.

### Nextauth secret:
NEXTAUTH_SECRET should look like `^7yTjn@G$j@KtLh9&@UdMpdfDZ`and this step cannot be skipped.

### Nextauth URL:
NEXTAUTH_URL should look like `http://localhost:3000/api/v1/auth` 
It can also be a FQDN or IP if FQDN then `https://yourdomain.com/api/v1/auth` and no ports. But still add `/api/v1/aut`
This step cannot be skipped.


### Postgres password:
POSTGRES_PASSWORD should be set to a strong password
This step cannot be skipped.