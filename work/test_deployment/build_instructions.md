# Building the Custom Docker Image

To build the custom Docker image for testing, run the following command from the `serra-frappe-deployment` directory:

```bash
./scripts/build.sh --image-name serra/frappe-test
```

This command will:

1. Build a Docker image with Frappe and the serra-vine-configurator app (defined in `apps.json`)
2. Tag the image with both a version tag (including date) and a main tag
3. The image will be named `serra/frappe-test:v15-YYYY-MM-DD` and `serra/frappe-test:v15`

## Expected Output

The build process will take some time (10-15 minutes) and will produce verbose output. The final output should indicate that the build was successful and provide instructions for using the image in your deployment.

## Verifying the Image

After the build is complete, you can verify that the image was created correctly by running:

```bash
docker images | grep serra/frappe-test
```

This should show two images with the same image ID:
- `serra/frappe-test:v15-YYYY-MM-DD`
- `serra/frappe-test:v15`

## Next Steps

After building the image, update the `.env` file to use this image:

```
CUSTOM_IMAGE=serra/frappe-test
CUSTOM_TAG=v15
PULL_POLICY=never
```

These values are already set in our test configuration file.
