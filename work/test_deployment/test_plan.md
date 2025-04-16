# Serra Frappe Deployment - Test Plan

This document outlines the test plan for the Serra Frappe deployment process. It covers the setup of a test environment, testing the build, deploy, and update scripts, and verifying that all services start correctly.

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
     - Change the image name to `serra/frappe-test`
     - Set a test database password
     - Change the HTTP port to 8090 to avoid conflicts

## Build Script Testing

1. Test building with default parameters:
   ```bash
   cd work/test_deployment/serra-frappe-deployment
   ./scripts/build.sh
   ```
   - Verify that the image is created with the default name and tag

2. Test building with custom parameters:
   ```bash
   ./scripts/build.sh --image-name serra/frappe-test
   ```
   - Verify that the image is created with the custom name

3. Test building with a custom Frappe branch:
   ```bash
   ./scripts/build.sh --frappe-branch version-14
   ```
   - Verify that the image is created with the custom branch

4. Test building with a custom image tag:
   ```bash
   ./scripts/build.sh --image-tag test-tag
   ```
   - Verify that the image is created with the custom tag

5. Test error handling:
   - Test with an invalid parameter
   - Test with a missing apps.json file

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

3. Test error handling:
   - Test with a non-existent environment file
   - Test with an invalid parameter

## Cleanup

1. Stop and remove the containers:
   ```bash
   docker compose --project-name serra-frappe-test down
   ```
   - Verify that all containers are stopped and removed

2. Remove the test images:
   ```bash
   docker rmi serra/frappe-test:v15 serra/frappe-test:v15-YYYY-MM-DD
   ```
   - Verify that the images are removed

## Documentation

Based on the testing results, document the deployment process in detail, including:

1. Prerequisites
2. Installation steps
3. Configuration options
4. Common operations (create site, install app, etc.)
5. Troubleshooting
6. Update and rollback procedures
