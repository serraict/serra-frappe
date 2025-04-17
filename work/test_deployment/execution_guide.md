# Executing the Test Plan

This guide will walk you through the steps to execute the test plan for the Serra Frappe deployment. Following these steps will help you fully meet the objective of testing the deployment process.

## Prerequisites

Before starting, ensure you have:

1. Docker and Docker Compose installed
2. Git installed
3. Sufficient disk space (at least 10GB free)
4. No other services running on ports 8090 and 8443

## Step 1: Test the build.sh Script

1. Open a terminal and navigate to the test_deployment directory:

   ```bash
   cd work/test_deployment
   ```

2. Run the build script with the custom image name and platform:

   ```bash
   ./serra-frappe-deployment/scripts/build.sh --image-name serra/frappe-test --platform linux/amd64
   ```

   Note: If you're on an ARM-based Mac (M1/M2/M3), you might need to use `--platform linux/arm64` instead.

   **Platform Compatibility Note**:
   - On ARM-based Macs, building for linux/amd64 might be slow or problematic due to emulation.
   - If you build for linux/arm64 but encounter deployment issues, you have two options:

     a) Modify the .env file to specify the platform:
     ```bash
     echo "DOCKER_DEFAULT_PLATFORM=linux/arm64" >> config/.env
     ```

     b) Use Docker's platform flag in the deployment command:
     ```bash
     DOCKER_DEFAULT_PLATFORM=linux/arm64 ./serra-frappe-deployment/scripts/deploy.sh --env-file "$(pwd)/config/.env" --project-name serra-frappe-test
     ```

3. This will take some time (10-15 minutes). Once complete, verify the image was created:

   ```bash
   docker images | grep serra/frappe-test
   ```

4. You should see two images with the same image ID:
   - `serra/frappe-test:v15-YYYY-MM-DD`
   - `serra/frappe-test:v15`

5. Document any issues encountered in the work/doing.md file.

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
   ./serra-frappe-deployment/scripts/update.sh --env-file config/.env --project-name serra-frappe-test --skip-pull --skip-build
   ```

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

2. Remove the test images:
   ```bash
   docker rmi serra/frappe-test:v15 serra/frappe-test:v15-$(date -u +"%Y-%m-%d")
   ```

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
   git add work/doing.md work/test_deployment/
   git commit -m "Update documentation based on test results"
   ```

## Conclusion

By following these steps, you will have fully tested the Serra Frappe deployment process and documented any issues encountered. This will help ensure that the deployment process is reliable and well-documented for future use.
