# Serra Frappe Deployment - Test Plan

This document outlines the test plan for the Serra Frappe deployment process. It covers the setup of a test environment, testing the GitHub Actions workflow for building the Docker image, testing the deploy and update scripts, and verifying that all services start correctly.

## Test Environment Setup

1. Create a test directory structure:
   ```
   work/test_deployment/
   ├── serra-frappe-deployment/    # Symbolic link to the repository
   └── config/                    # Test configuration
       └── .env                   # Test environment variables
   ```

2. Create a test configuration file:
   - Copy `env.example` to `work/test_deployment/config/.env`
   - Modify the configuration for testing purposes:
     - Change the image name to use the GitHub Container Registry image
     - Set a test database password
     - Change the HTTP port to 8090 to avoid conflicts
     - Set `PULL_POLICY=always` to ensure Docker always pulls the latest version of the image

3. Set up GitHub Actions workflow:
   - Create the `.github/workflows/docker-build.yml` file
   - Configure the workflow to build for the appropriate platform (linux/amd64)
   - Set up image publishing to GitHub Container Registry

## GitHub Actions Workflow Testing

1. Test manual workflow trigger:
   - Go to the GitHub repository
   - Navigate to the "Actions" tab
   - Select the "Build and Publish Docker Image" workflow
   - Click "Run workflow" with the default tag (v15)
   - Verify that the workflow runs successfully
   - Verify that the image is published to GitHub Container Registry

2. Test workflow trigger with custom tag:
   - Go to the GitHub repository
   - Navigate to the "Actions" tab
   - Select the "Build and Publish Docker Image" workflow
   - Click "Run workflow" and specify a custom tag
   - Verify that the workflow runs successfully
   - Verify that the image is published to GitHub Container Registry with the custom tag

3. Test automatic workflow trigger:
   - Make a change to the `apps.json` file
   - Push the change to the main branch
   - Verify that the workflow is triggered automatically
   - Verify that the image is published to GitHub Container Registry

4. Test pulling the image:
   ```bash
   docker pull ghcr.io/YOUR_GITHUB_USERNAME/frappe-test:v15
   ```
   - Verify that the image is pulled successfully

5. Test error handling:
   - Test with an invalid workflow configuration
   - Test with insufficient permissions to publish to GitHub Container Registry

## Deploy Script Testing

1. Test basic deployment:
   ```bash
   ./scripts/deploy.sh --env-file ../config/.env --project-name serra-frappe-test
   ```
   - Verify that the docker-compose.yml file is generated
   - Verify that the containers are started

2. Test deployment with HTTPS:
   ```bash
   ./scripts/deploy.sh --env-file ../config/.env --project-name serra-frappe-test --with-https
   ```
   - Verify that the HTTPS configuration is included in the docker-compose.yml file
   - Verify that the containers are started

3. Test deployment with proxy:
   ```bash
   ./scripts/deploy.sh --env-file ../config/.env --project-name serra-frappe-test --with-proxy
   ```
   - Verify that the proxy configuration is included in the docker-compose.yml file
   - Verify that the containers are started

4. Test deployment with both HTTPS and proxy:
   ```bash
   ./scripts/deploy.sh --env-file ../config/.env --project-name serra-frappe-test --with-https --with-proxy
   ```
   - Verify that both HTTPS and proxy configurations are included in the docker-compose.yml file
   - Verify that the containers are started

5. Test error handling:
   - Test with a non-existent environment file
   - Test with an invalid parameter

## Service Verification

1. Verify that all containers are running:
   ```bash
   docker compose --project-name serra-frappe-test ps
   ```
   - Verify that all containers are in the "running" state

2. Create a test site:
   ```bash
   docker compose --project-name serra-frappe-test exec backend bench new-site --mariadb-user-host-login-scope=% --admin-password test_password serra-test.localhost
   ```
   - Verify that the site is created successfully

3. Install the serra-vine-configurator app:
   ```bash
   docker compose --project-name serra-frappe-test exec backend bench --site serra-test.localhost install-app serra_vine_configurator
   ```
   - Verify that the app is installed successfully

4. Access the application:
   - http://serra-test.localhost:8090 (if using the default configuration)
   - https://serra-test.localhost:8443 (if using HTTPS)
   - Verify that the application is accessible and functioning correctly

## Update Script Testing

1. Test basic update:
   ```bash
   ./scripts/update.sh --env-file ../config/.env --project-name serra-frappe-test
   ```
   - Verify that the update process completes successfully
   - Verify that the containers are still running
   - Verify that the site is still accessible

2. Test update with skip options:
   ```bash
   ./scripts/update.sh --env-file ../config/.env --project-name serra-frappe-test --skip-pull --skip-build --skip-backup
   ```
   - Verify that the update process completes successfully
   - Verify that the containers are still running
   - Verify that the site is still accessible

3. Test update after a new image build:
   - Trigger a new image build in GitHub Actions
   - Run the update script without the `--skip-build` flag
   - Verify that the new image is pulled
   - Verify that the update process completes successfully
   - Verify that the containers are still running
   - Verify that the site is still accessible

4. Test error handling:
   - Test with a non-existent environment file
   - Test with an invalid parameter

## Cleanup

1. Stop and remove the containers:
   ```bash
   docker compose --project-name serra-frappe-test down
   ```
   - Verify that all containers are stopped and removed

2. Remove the pulled image:
   ```bash
   docker rmi ghcr.io/YOUR_GITHUB_USERNAME/frappe-test:v15
   ```
   - Verify that the image is removed

## Documentation

Based on the testing results, document the deployment process in detail, including:

1. Prerequisites
2. GitHub Actions workflow setup and usage
3. Installation steps
4. Configuration options
5. Common operations (create site, install app, etc.)
6. Troubleshooting
7. Update and rollback procedures
