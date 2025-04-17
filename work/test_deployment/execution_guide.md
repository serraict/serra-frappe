# Executing the Test Plan

This guide will walk you through the steps to execute the test plan for the Serra Frappe deployment. Following these steps will help you fully meet the objective of testing the deployment process.

## Prerequisites

Before starting, ensure you have:

1. Docker and Docker Compose installed
2. Git installed
3. Sufficient disk space (at least 10GB free)
4. No other services running on ports 8090 and 8443
5. Access to GitHub and permissions to run GitHub Actions in your repository

## Step 1: Build the Docker Image with GitHub Actions

Instead of building the Docker image locally, we'll use GitHub Actions to build and publish the image to avoid platform mismatch issues.

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

3. Monitor the build progress in the GitHub Actions tab. This will take some time (10-15 minutes).

4. Once the build is complete, pull the image to your local machine:
   ```bash
   docker pull ghcr.io/YOUR_GITHUB_USERNAME/frappe-test:v15
   ```
   Replace `YOUR_GITHUB_USERNAME` with your actual GitHub username or organization name.

5. Verify the image was pulled correctly:
   ```bash
   docker images | grep frappe-test
   ```

6. Update the .env file to use this image:
   ```bash
   # Navigate to the test_deployment directory
   cd work/test_deployment

   # Update the .env file
   sed -i 's/CUSTOM_IMAGE=serra\/frappe-test/CUSTOM_IMAGE=ghcr.io\/YOUR_GITHUB_USERNAME\/frappe-test/' config/.env
   sed -i 's/PULL_POLICY=never/PULL_POLICY=always/' config/.env
   ```
   Replace `YOUR_GITHUB_USERNAME` with your actual GitHub username or organization name.

7. Document any issues encountered in the work/doing.md file.

## Step 2: Test the deploy.sh Script

1. Deploy the application with the default configuration:
   ```bash
   ./serra-frappe-deployment/scripts/deploy.sh --env-file "$(pwd)/config/.env" --project-name serra-frappe-test
   ```

2. Verify that the docker-compose.yml file is generated and the containers are started:
   ```bash
   docker compose --project-name serra-frappe-test ps
   ```

3. All containers should be in the "running" state.

4. Document any issues encountered in the work/doing.md file.

## Step 3: Verify Services

1. Check that all containers are running:
   ```bash
   docker compose --project-name serra-frappe-test ps
   ```

2. Create a test site:
   ```bash
   docker compose --project-name serra-frappe-test exec backend bench new-site --mariadb-user-host-login-scope=% --admin-password test_password serra-test.localhost
   ```

3. Install the serra-vine-configurator app:
   ```bash
   docker compose --project-name serra-frappe-test exec backend bench --site serra-test.localhost install-app serra_vine_configurator
   ```

4. Add an entry to your hosts file to map serra-test.localhost to 127.0.0.1:
   ```bash
   # Add to /etc/hosts (requires sudo)
   sudo sh -c 'echo "127.0.0.1 serra-test.localhost" >> /etc/hosts'
   ```

5. Access the application in your browser:
   - http://serra-test.localhost:8090

6. Verify that the application is accessible and functioning correctly.

7. Document any issues encountered in the work/doing.md file.

## Step 4: Test the update.sh Script

1. Test the update process:
   ```bash
   ./serra-frappe-deployment/scripts/update.sh --env-file config/.env --project-name serra-frappe-test
   ```
   Note: We've removed the `--skip-pull` flag to ensure the latest image is pulled from the registry.

2. Verify that the update process completes successfully:
   ```bash
   docker compose --project-name serra-frappe-test ps
   ```

3. All containers should still be in the "running" state.

4. Verify that the site is still accessible:
   - http://serra-test.localhost:8090

5. Document any issues encountered in the work/doing.md file.

## Step 5: Test Different Deployment Options

1. Stop the current deployment:
   ```bash
   docker compose --project-name serra-frappe-test down
   ```

2. Deploy with HTTPS:
   ```bash
   ./serra-frappe-deployment/scripts/deploy.sh --env-file config/.env --project-name serra-frappe-test --with-https
   ```

3. Verify that the containers are started:
   ```bash
   docker compose --project-name serra-frappe-test ps
   ```

4. Stop the deployment:
   ```bash
   docker compose --project-name serra-frappe-test down
   ```

5. Deploy with proxy:
   ```bash
   ./serra-frappe-deployment/scripts/deploy.sh --env-file config/.env --project-name serra-frappe-test --with-proxy
   ```

6. Verify that the containers are started:
   ```bash
   docker compose --project-name serra-frappe-test ps
   ```

7. Stop the deployment:
   ```bash
   docker compose --project-name serra-frappe-test down
   ```

8. Document any issues encountered in the work/doing.md file.

## Step 6: Clean Up

1. Stop and remove the containers:
   ```bash
   docker compose --project-name serra-frappe-test down
   ```

2. Remove the pulled image:
   ```bash
   docker rmi ghcr.io/YOUR_GITHUB_USERNAME/frappe-test:v15
   ```
   Replace `YOUR_GITHUB_USERNAME` with your actual GitHub username or organization name.

3. Remove the hosts file entry:
   ```bash
   sudo sed -i '/serra-test.localhost/d' /etc/hosts
   ```

## Step 7: Update Documentation

1. Update the work/doing.md file with any issues encountered and their solutions.

2. Update the deployment documentation based on your experience.

3. Commit your changes:
   ```bash
   cd ../..
   git add work/doing.md work/test_deployment/ .github/
   git commit -m "Update documentation and add GitHub Actions workflow"
   ```

## Conclusion

By following these steps, you will have fully tested the Serra Frappe deployment process using a Docker image built with GitHub Actions, and documented any issues encountered. This approach avoids platform mismatch issues and provides a more production-like workflow.
