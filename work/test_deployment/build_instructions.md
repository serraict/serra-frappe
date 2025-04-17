# Building the Custom Docker Image with GitHub Actions

Instead of building the Docker image locally, we'll use GitHub Actions to build and publish the image to avoid platform mismatch issues. This approach ensures consistent builds and proper platform targeting.

## GitHub Actions Workflow

We've created a GitHub Actions workflow file at `.github/workflows/docker-build.yml` that will:

1. Build a Docker image with Frappe and the serra-vine-configurator app (defined in `apps.json`)
2. Build specifically for the linux/amd64 platform to avoid compatibility issues
3. Tag the image with both a version tag (including date) and a main tag
4. Push the image to GitHub Container Registry (ghcr.io)

## How the Build Works

The workflow uses our `scripts/build.sh` script to build the Docker image. This script:

1. Uses the Containerfile from `frappe_docker/images/layered/Containerfile`
2. Passes the `apps.json` file as a base64-encoded argument
3. Sets various build arguments like Frappe branch, image name, etc.
4. Builds the image for the linux/amd64 platform

The `apps.json` file defines the custom apps to include in the image. In our case, it includes the serra-vine-configurator app:

```json
[
  {
    "url": "https://github.com/serraict/serra-vine-configurator",
    "branch": "main"
  }
]
```

## Triggering the Build

You can trigger the build in two ways:

1. **Manually**: Go to the Actions tab in your GitHub repository and select the "Build and Publish Docker Image" workflow. Click "Run workflow" and optionally specify a custom tag.

2. **Automatically**: The workflow will automatically run when changes are pushed to the main branch that affect `apps.json`, `scripts/build.sh`, `frappe_docker/images/layered/Containerfile`, or the workflow file itself.

## Expected Output

The build process will take some time (10-15 minutes) and you can monitor the progress in the GitHub Actions tab. The final output should indicate that the build was successful and the image was pushed to the GitHub Container Registry.

## Pulling the Image

After the image is built and published, pull it to your local machine:

```bash
docker pull ghcr.io/serraict/frappe-test:v15
```

## Verifying the Image

After pulling the image, you can verify that it was downloaded correctly by running:

```bash
docker images | grep frappe-test
```

This should show the image you just pulled from GitHub Container Registry.

## Updating the .env File

Update the `.env` file to use this image:

```
CUSTOM_IMAGE=ghcr.io/serraict/frappe-test
CUSTOM_TAG=v15
PULL_POLICY=always
```

Note that we've changed `PULL_POLICY` to `always` to ensure Docker always pulls the latest version of the image.

## Next Steps

After pulling the image, proceed with the deployment testing as described in the deployment instructions.
