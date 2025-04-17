# Updating the Deployment

After deploying the application, you can test the update process using the `update.sh` script. This document provides instructions for testing the update process with our GitHub Actions-based approach.

## Basic Update

To update the deployment with the default configuration, run the following command from the `serra-frappe-deployment` directory:

```bash
./scripts/update.sh --env-file ../config/.env --project-name serra-frappe-test
```

This command will:

1. Pull the latest changes from git
2. Pull the latest image from GitHub Container Registry
3. Backup all sites
4. Update the containers
5. Migrate all sites

## Testing Different Update Options

The `update.sh` script supports several options that can be tested:

### Skip Pulling Latest Changes

To update without pulling the latest changes from git:

```bash
./scripts/update.sh --env-file ../config/.env --project-name serra-frappe-test --skip-pull
```

### Skip Pulling Latest Image

To update without pulling the latest image from the registry:

```bash
./scripts/update.sh --env-file ../config/.env --project-name serra-frappe-test --skip-build
```

Note: With our GitHub Actions approach, we're not building locally, but the `--skip-build` flag is still used to skip pulling the latest image from the registry.

### Skip Backing Up Sites

To update without backing up sites:

```bash
./scripts/update.sh --env-file ../config/.env --project-name serra-frappe-test --skip-backup
```

### Combining Options

You can combine multiple options:

```bash
./scripts/update.sh --env-file ../config/.env --project-name serra-frappe-test --skip-pull --skip-build
```

## Triggering a New Image Build

If you need to test with a new image version:

1. Go to your GitHub repository
2. Navigate to the "Actions" tab
3. Select the "Build and Publish Docker Image" workflow
4. Click "Run workflow" and use the default tag (v15) or specify a custom tag
5. Click "Run workflow" to start the build
6. Once the build is complete, run the update script without the `--skip-build` flag to pull the new image

## Verifying the Update

After updating, you can verify that the containers are running:

```bash
docker compose --project-name serra-frappe-test ps
```

This should show all containers in the "running" state.

You can also verify that the site is still accessible and that the serra-vine-configurator app is still installed:

```bash
docker compose --project-name serra-frappe-test exec backend bench --site serra-test.localhost list-apps
```

This should show the serra-vine-configurator app in the list of installed apps.
