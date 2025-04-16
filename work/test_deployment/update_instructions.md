# Updating the Deployment

After deploying the application, you can test the update process using the `update.sh` script. This document provides instructions for testing the update process.

## Basic Update

To update the deployment with the default configuration, run the following command from the `serra-frappe-deployment` directory:

```bash
./scripts/update.sh --env-file ../config/.env --project-name serra-frappe-test
```

This command will:

1. Pull the latest changes from git
2. Build a new image
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

### Skip Building New Image

To update without building a new image:

```bash
./scripts/update.sh --env-file ../config/.env --project-name serra-frappe-test --skip-build
```

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
