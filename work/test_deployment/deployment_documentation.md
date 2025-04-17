# Serra Frappe Deployment Documentation

This document provides detailed instructions for deploying and managing Serra's Frappe applications using the serra-frappe-deployment repository.

## Prerequisites

Before deploying, ensure you have the following:

1. **Docker and Docker Compose**
   - Docker Engine 20.10.0 or later
   - Docker Compose V2 or later

2. **Git**
   - Git 2.25.0 or later

3. **System Requirements**
   - Minimum 4GB RAM
   - 2 CPU cores
   - 20GB free disk space

4. **Network Requirements**
   - Ports 80 and 443 available (for production)
   - Ports 8080 and 8443 available (for testing)

5. **GitHub Access**
   - Access to GitHub and permissions to run GitHub Actions in your repository
   - Permissions to publish to GitHub Container Registry

## Installation

### 1. Clone the Repository

```bash
# Create a directory for the deployment
mkdir -p ~/serra-frappe

# Clone the repository
cd ~/serra-frappe
git clone https://github.com/serraict/serra-frappe-deployment
cd serra-frappe-deployment

# Initialize and update submodules
git submodule update --init --recursive
```

### 2. Create Configuration

```bash
# Create configuration directory
mkdir -p ../config

# Copy example configuration
cp env.example ../config/.env

# Edit the configuration
nano ../config/.env
```

Important configuration options to set:

- `DB_PASSWORD`: Set a secure password for the database
- `SITES`: Set the site name(s)
- `HTTP_PUBLISH_PORT` and `HTTPS_PUBLISH_PORT`: Set the ports to publish
- `CUSTOM_IMAGE`: Set to your GitHub Container Registry image
- `PULL_POLICY`: Set to "always" to ensure Docker always pulls the latest version

### 3. Build the Custom Image with GitHub Actions

Instead of building the image locally, we use GitHub Actions to build and publish the image to GitHub Container Registry:

1. Ensure the GitHub Actions workflow file is in place:
   ```bash
   ls -la .github/workflows/docker-build.yml
   ```

2. Trigger the GitHub Actions workflow:
   - Go to your GitHub repository
   - Navigate to the "Actions" tab
   - Select the "Build and Publish Docker Image" workflow
   - Click "Run workflow" and use the default tag (v15) or specify a custom tag
   - Click "Run workflow" to start the build

3. Monitor the build progress in the GitHub Actions tab.

4. Once the build is complete, pull the image to your local machine:
   ```bash
   docker pull ghcr.io/YOUR_GITHUB_USERNAME/frappe-test:v15
   ```
   Replace `YOUR_GITHUB_USERNAME` with your actual GitHub username or organization name.

### 4. Deploy the Application

```bash
# Deploy with default configuration
./scripts/deploy.sh

# Or deploy with custom configuration
./scripts/deploy.sh --env-file ../config/.env
./scripts/deploy.sh --project-name custom-project-name
./scripts/deploy.sh --with-https
./scripts/deploy.sh --with-proxy
```

### 5. Create a Site and Install Apps

```bash
# Create a new site
docker compose --project-name serra-frappe exec backend bench new-site \
  --mariadb-user-host-login-scope=% \
  --admin-password your_secure_password \
  your-site.localhost

# Install the serra-vine-configurator app
docker compose --project-name serra-frappe exec backend bench \
  --site your-site.localhost install-app serra_vine_configurator
```

## Configuration Options

### Environment Variables

The `.env` file contains all configuration options for the deployment. Here are the key options:

#### Frappe/ERPNext Version

```
FRAPPE_VERSION=v15
```

#### Custom Image Configuration

```
CUSTOM_IMAGE=ghcr.io/YOUR_GITHUB_USERNAME/frappe-test
CUSTOM_TAG=v15
PULL_POLICY=always
```

Replace `YOUR_GITHUB_USERNAME` with your actual GitHub username or organization name.

#### Database Configuration

```
DB_PASSWORD=your_secure_password
DB_HOST=mariadb-database
DB_PORT=3306
```

#### Redis Configuration

```
REDIS_CACHE=redis-cache:6379
REDIS_QUEUE=redis-queue:6379
```

#### Site Configuration

```
SITES=`your-site.localhost`
FRAPPE_SITE_NAME_HEADER=$$host
```

#### Proxy Configuration

```
HTTP_PUBLISH_PORT=80
HTTPS_PUBLISH_PORT=443
```

#### HTTPS Configuration

```
LETSENCRYPT_EMAIL=admin@example.com
```

#### Resource Limits

```
BACKEND_CPUS=1
BACKEND_MEMORY=4g
FRONTEND_CPUS=1
FRONTEND_MEMORY=2g
```

### Deployment Options

The `deploy.sh` script supports several options:

- `--env-file FILE`: Path to environment file (default: ../config/.env)
- `--project-name NAME`: Docker Compose project name (default: serra-frappe)
- `--with-https`: Enable HTTPS with Let's Encrypt
- `--with-proxy`: Use Traefik proxy instead of direct port publishing

## Common Operations

### Updating the Deployment

```bash
# Update with default configuration
./scripts/update.sh

# Or update with custom configuration
./scripts/update.sh --env-file ../config/.env
./scripts/update.sh --project-name custom-project-name
./scripts/update.sh --skip-pull
./scripts/update.sh --skip-build
./scripts/update.sh --skip-backup
```

Note: With our GitHub Actions approach, the `--skip-build` flag is used to skip pulling the latest image from the registry.

### Triggering a New Image Build

If you need to update the Docker image:

1. Go to your GitHub repository
2. Navigate to the "Actions" tab
3. Select the "Build and Publish Docker Image" workflow
4. Click "Run workflow" and use the default tag (v15) or specify a custom tag
5. Click "Run workflow" to start the build
6. Once the build is complete, run the update script without the `--skip-build` flag to pull the new image

### Backing Up Sites

```bash
# Backup all sites
docker compose --project-name serra-frappe exec backend bench --site all backup

# Backup a specific site
docker compose --project-name serra-frappe exec backend bench --site your-site.localhost backup
```

### Restoring a Backup

```bash
# Copy the backup file to the container
docker cp /path/to/backup.sql serra-frappe-backend:/tmp/

# Restore the backup
docker compose --project-name serra-frappe exec backend bench --site your-site.localhost restore /tmp/backup.sql
```

### Managing Sites

```bash
# List all sites
docker compose --project-name serra-frappe exec backend bench --site all list-apps

# Create a new site
docker compose --project-name serra-frappe exec backend bench new-site \
  --mariadb-user-host-login-scope=% \
  --admin-password your_secure_password \
  new-site.localhost

# Install an app
docker compose --project-name serra-frappe exec backend bench \
  --site your-site.localhost install-app app_name

# Uninstall an app
docker compose --project-name serra-frappe exec backend bench \
  --site your-site.localhost uninstall-app app_name

# Migrate a site
docker compose --project-name serra-frappe exec backend bench \
  --site your-site.localhost migrate
```

## Troubleshooting

### Container Issues

If containers fail to start:

1. Check the logs:
   ```bash
   docker compose --project-name serra-frappe logs
   ```

2. Check container status:
   ```bash
   docker compose --project-name serra-frappe ps
   ```

3. Restart containers:
   ```bash
   docker compose --project-name serra-frappe down
   docker compose --project-name serra-frappe up -d
   ```

### GitHub Actions Issues

If the GitHub Actions workflow fails:

1. Check the workflow logs in the GitHub Actions tab
2. Ensure you have the necessary permissions to publish to GitHub Container Registry
3. Verify that the workflow file is correctly configured
4. Check for any errors in the build process

### Database Issues

If you encounter database connection issues:

1. Check database container status:
   ```bash
   docker compose --project-name serra-frappe logs mariadb-database
   ```

2. Reset database password:
   ```bash
   docker compose --project-name serra-frappe exec mariadb-database mysql -u root -p
   # Enter the password from your .env file
   ALTER USER 'root'@'%' IDENTIFIED BY 'new_password';
   # Update the password in your .env file
   ```

### Site Access Issues

If you cannot access your site:

1. Check site configuration:
   ```bash
   docker compose --project-name serra-frappe exec backend bench --site your-site.localhost show-config
   ```

2. Check site status:
   ```bash
   docker compose --project-name serra-frappe exec backend bench --site your-site.localhost enable-scheduler
   docker compose --project-name serra-frappe exec backend bench --site your-site.localhost clear-cache
   ```

3. Add host entry to your local machine:
   ```bash
   # Add to /etc/hosts
   127.0.0.1 your-site.localhost
   ```

## Maintenance

### Updating Frappe

To update to a new version of Frappe:

1. Update the `FRAPPE_VERSION` in your `.env` file
2. Update the GitHub Actions workflow to use the new version
3. Trigger a new build in GitHub Actions
4. Run the update script:
   ```bash
   ./scripts/update.sh
   ```

### Cleaning Up

To remove old images and containers:

```bash
# Remove unused containers
docker container prune

# Remove unused images
docker image prune

# Remove unused volumes
docker volume prune
```

## Security Considerations

1. **Database Password**: Use a strong, unique password for the database
2. **Admin Password**: Use a strong, unique password for the admin account
3. **HTTPS**: Enable HTTPS in production environments
4. **Firewall**: Configure a firewall to restrict access to only necessary ports
5. **Regular Updates**: Keep the system updated with the latest security patches
6. **GitHub Secrets**: Ensure that your GitHub repository is properly secured, especially if using secrets for authentication
7. **Container Registry Access**: Restrict access to your GitHub Container Registry to only authorized users
