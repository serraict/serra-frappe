# GitHub Actions Setup for Docker Image Building

This document describes how to set up and use GitHub Actions to build Docker images for the Serra Frappe deployment.

## Overview

We use GitHub Actions to build Docker images for our deployment to ensure consistent builds across different environments. This approach solves platform mismatch issues that can occur when building locally on ARM-based Macs and deploying to AMD64 servers.

## Workflow File

The GitHub Actions workflow is defined in `.github/workflows/docker-build.yml`. This workflow:

1. Checks out the repository with submodules
2. Sets up Docker Buildx
3. Logs in to GitHub Container Registry
4. Builds the Docker image using our `scripts/build.sh` script
5. Pushes the built image to GitHub Container Registry

## Workflow Triggers

The workflow can be triggered in two ways:

1. **Manually**: Using the GitHub Actions UI or the `gh` CLI tool
2. **Automatically**: When changes are pushed to the `main` branch that affect:
   - `apps.json`
   - `scripts/build.sh`
   - `frappe_docker/images/layered/Containerfile`
   - `.github/workflows/docker-build.yml`

## Workflow Inputs

When triggering the workflow manually, you can provide the following inputs:

- **tag**: The image tag (default: `v15`)
- **frappe_branch**: The Frappe branch to use (default: `version-15`)

## Image Tags

The workflow builds and pushes two tags for each image:

1. **Versioned tag**: `ghcr.io/serraict/frappe-test:<tag>-<date>` (e.g., `ghcr.io/serraict/frappe-test:v15-2025-04-17`)
2. **Latest tag**: `ghcr.io/serraict/frappe-test:<tag>` (e.g., `ghcr.io/serraict/frappe-test:v15`)

## How to Trigger the Workflow Manually

### Using the GitHub UI

1. Go to the GitHub repository
2. Click on the "Actions" tab
3. Select the "Build and Publish Docker Image" workflow
4. Click on "Run workflow"
5. Optionally, provide custom values for the inputs
6. Click "Run workflow"

### Using the GitHub CLI

```bash
# Trigger with default values
gh workflow run "Build and Publish Docker Image" --ref main

# Trigger with custom values
gh workflow run "Build and Publish Docker Image" --ref main -f tag=v14 -f frappe_branch=version-14
```

## How to Use the Built Images

To use the images built by GitHub Actions:

1. Update your `.env` file with the following settings:
   ```
   CUSTOM_IMAGE=ghcr.io/serraict/frappe-test
   CUSTOM_TAG=v15
   ```

2. Pull the image:
   ```bash
   docker pull ghcr.io/serraict/frappe-test:v15
   ```

3. Run the deployment script:
   ```bash
   ./scripts/deploy.sh
   ```

## Troubleshooting

### Viewing Workflow Runs

To view the status and logs of workflow runs:

```bash
# List recent workflow runs
gh run list -L 5

# View details of a specific run
gh run view <run-id>

# View logs of a specific job
gh run view --log --job=<job-id>
```

### Common Issues

1. **Authentication Issues**: Ensure that the GitHub token has the necessary permissions to push to the GitHub Container Registry.

2. **Build Failures**: Check the logs for any build errors. Common issues include:
   - Missing dependencies
   - Syntax errors in the Containerfile
   - Issues with the build.sh script

3. **Push Failures**: If the build succeeds but the push fails, check:
   - Network connectivity
   - GitHub Container Registry permissions
   - Image size (very large images may time out during push)

## Best Practices

1. **Test Locally First**: Before pushing changes that trigger the workflow, test the build script locally to catch any issues early.

2. **Use Specific Tags**: When deploying to production, use versioned tags (e.g., `v15-2025-04-17`) rather than the latest tag to ensure reproducibility.

3. **Monitor Workflow Runs**: Regularly check the status of workflow runs to catch any issues early.

4. **Update Documentation**: Keep this documentation up to date as the workflow evolves.
