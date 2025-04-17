# Deploying the Application

After building the Docker image with GitHub Actions and pulling it to your local machine, you can deploy the application using the `deploy.sh` script. This document provides instructions for testing the deployment process.

## Prerequisites

Before deploying, ensure that:

1. You have triggered the GitHub Actions workflow to build the Docker image
2. You have pulled the image to your local machine:
   ```bash
   docker pull ghcr.io/YOUR_GITHUB_USERNAME/frappe-test:v15
   ```
3. You have updated the `.env` file to use this image:
   ```
   CUSTOM_IMAGE=ghcr.io/YOUR_GITHUB_USERNAME/frappe-test
   CUSTOM_TAG=v15
   PULL_POLICY=always
   ```

## Basic Deployment

To deploy the application with the default configuration, run the following command from the `serra-frappe-deployment` directory:

```bash
./scripts/deploy.sh --env-file ../config/.env --project-name serra-frappe-test
```

This command will:

1. Generate a `docker-compose.yml` file based on the configuration in the `.env` file
2. Start the containers using Docker Compose

## Testing Different Deployment Options

The `deploy.sh` script supports several options that can be tested:

### With HTTPS

To deploy with HTTPS support:

```bash
./scripts/deploy.sh --env-file ../config/.env --project-name serra-frappe-test --with-https
```

Note: For testing purposes, you may need to uncomment and set the `LETSENCRYPT_EMAIL` variable in the `.env` file.

### With Proxy

To deploy with Traefik proxy instead of direct port publishing:

```bash
./scripts/deploy.sh --env-file ../config/.env --project-name serra-frappe-test --with-proxy
```

### With Both HTTPS and Proxy

To deploy with both HTTPS and Traefik proxy:

```bash
./scripts/deploy.sh --env-file ../config/.env --project-name serra-frappe-test --with-https --with-proxy
```

## Verifying the Deployment

After deploying, you can verify that the containers are running:

```bash
docker compose --project-name serra-frappe-test ps
```

This should show all containers in the "running" state.

## Creating a Test Site

After the deployment is complete, you can create a test site and install the serra-vine-configurator app:

```bash
docker compose --project-name serra-frappe-test exec backend bench new-site --mariadb-user-host-login-scope=% --admin-password test_password serra-test.localhost

docker compose --project-name serra-frappe-test exec backend bench --site serra-test.localhost install-app serra_vine_configurator
```

## Accessing the Application

The application should be accessible at:

- http://serra-test.localhost:8090 (if using the default configuration)
- https://serra-test.localhost:8443 (if using HTTPS)

Note: You may need to add an entry to your `/etc/hosts` file to map `serra-test.localhost` to `127.0.0.1`.
