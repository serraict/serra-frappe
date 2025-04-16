# Build Script Test Suite

This directory contains a comprehensive test suite for verifying the functionality of the `build.sh` script, which builds a custom Docker image with Frappe and the serra-vine-configurator app.

## Test Scripts

The test suite includes the following scripts:

1. **test_default_params.sh**: Tests the build script with default parameters
   - Verifies image name: serra/frappe
   - Verifies tag: v15-{current_date}

2. **test_custom_branch.sh**: Tests the build script with a custom Frappe branch
   - Uses --frappe-branch parameter to specify version-14

3. **test_custom_image_name.sh**: Tests the build script with a custom image name
   - Uses --image-name parameter to specify custom/frappe-test

4. **test_custom_image_tag.sh**: Tests the build script with a custom image tag
   - Uses --image-tag parameter to specify test-tag

5. **test_invalid_param.sh**: Tests error handling with invalid parameters
   - Verifies the script exits with an error when given an invalid parameter

6. **test_missing_apps_json.sh**: Tests error handling with missing apps.json
   - Temporarily renames apps.json and verifies the script exits with an error

7. **test_image_verification.sh**: Verifies image creation and functionality
   - Checks both tags exist (version tag and main tag)
   - Creates a test container to verify functionality
   - Verifies bench commands work
   - Checks app list includes serra-vine-configurator

8. **run_all_tests.sh**: Script to run all tests
   - Provides option to skip actual Docker builds for faster testing

## Usage

To run all tests:

```bash
cd work/tests
./run_all_tests.sh
```

To run a specific test:

```bash
cd work/tests
./test_default_params.sh
```

## Test Results

The test suite has verified that:

1. The build script executes without errors with both default and custom parameters
2. The Docker image is created successfully with the correct tags
3. Both Frappe and serra-vine-configurator are present in the image
4. Basic functionality tests pass

## Issues Encountered and Fixes

1. Needed to remove frappe from apps.json, as it was already packaged with the container.
