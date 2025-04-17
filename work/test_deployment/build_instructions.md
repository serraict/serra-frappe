# Building the Custom Docker Image with GitHub Actions

Instead of building the Docker image locally, we'll use GitHub Actions to build and publish the image to avoid platform mismatch issues. This approach ensures consistent builds and proper platform targeting.

## GitHub Actions Workflow

We've created a GitHub Actions workflow file at `.github/workflows/docker-build.yml` that will:

1. Build a Docker image with Frappe and the serra-vine-configurator app (defined in `apps.json`)
2. Build specifically for the linux/amd64 platform to avoid compatibility issues
3. Tag the image with both a version tag (including date) and a main tag
4. Push the image to GitHub Container Registry (ghcr.io)

## Triggering the Build

You can trigger the build in two ways:

1. **Manually**: Go to the Actions tab in your GitHub repository and select the "Build and Publish Docker Image" workflow. Click "Run workflow" and optionally specify a custom tag.

2. **Automatically**: The workflow will automatically run when changes are pushed to the main branch that affect `apps.json`, `Dockerfile`, or the workflow file itself.

## Expected Output

The build process will take some time (10-15 minutes) and you can monitor the progress in the GitHub Actions tab. The final output should indicate that the build was successful and the image was pushed to the GitHub Container Registry.

## Pulling the Image

After the image is built and published, pull it to your local machine:

```bash
docker pull ghcr.io/YOUR_GITHUB_USERNAME/frappe-test:v15
```

Replace `YOUR_GITHUB_USERNAME` with your actual GitHub username or organization name.

## Verifying the Image

After pulling the image, you can verify that it was downloaded correctly by running:

```bash
docker images | grep frappe-test
```

This should show the image you just pulled from GitHub Container Registry.

## Updating the .env File

Update the `.env` file to use this image:

```
CUSTOM_IMAGE=ghcr.io/YOUR_GITHUB_USERNAME/frappe-test
CUSTOM_TAG=v15
PULL_POLICY=always
```

Note that we've changed `PULL_POLICY` to `always` to ensure Docker always pulls the latest version of the image.

## Next Steps

After pulling the image, proceed with the deployment testing as described in the deployment instructions.
