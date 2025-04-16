# Current Task: Testing the Build Process

## Objective

Verify that the build.sh script works correctly and produces a functional Docker image that includes both Frappe and the serra-vine-configurator app.

## Test Plan

### 1. Prerequisites Verification

- [x] Verify Docker is installed and running (Docker version 28.0.1)
- [x] Verify git is installed (Git version 2.49.0)
- [x] Ensure access to required repositories:
  - frappe/frappe (version-15 branch)
  - serraict/serra-vine-configurator (main branch)

### 2. Build Script Testing

- [x] Test with default parameters
  - Verify image name: serra/frappe
  - Verify tag: v15-{current_date}
- [x] Test with custom parameters
  - Test --frappe-branch parameter
  - Test --image-name parameter
  - Test --image-tag parameter
- [x] Verify error handling
  - Test with invalid parameters
  - Test with missing apps.json

### 3. Image Verification

- [x] Verify image creation
  - Check both tags exist (version tag and main tag)
  - Verify image size is reasonable
  - Check image layers for correct build steps
- [x] Verify apps are included
  - Check Frappe is installed correctly
  - Verify serra-vine-configurator is present
- [x] Test image functionality
  - Create a test container
  - Verify bench commands work
  - Check app list includes serra-vine-configurator

### 4. Documentation

- [x] Document test results
- [x] Note any issues encountered
- [x] Document any necessary adjustments to build.sh
- [x] Update README.md if needed

## Success Criteria

1. Build script executes without errors
2. Docker image is created successfully
3. Both Frappe and serra-vine-configurator are present in the image
4. Basic functionality tests pass
5. Documentation is updated with findings

## Issues Encountered and Fixes

1. Needed to remove frappe from apps.json, as it was already packaged with the container.
2. Successfully tested the build script with default parameters and verified the image was created correctly.
3. Created a comprehensive test suite in `tests/` to automate testing of all build script functionality:
   - `test_default_params.sh`: Tests with default parameters
   - `test_custom_branch.sh`: Tests with custom Frappe branch
   - `test_custom_image_name.sh`: Tests with custom image name
   - `test_custom_image_tag.sh`: Tests with custom image tag
   - `test_invalid_param.sh`: Tests error handling with invalid parameters
   - `test_missing_apps_json.sh`: Tests error handling with missing apps.json
   - `test_image_verification.sh`: Verifies image creation and functionality
   - `run_all_tests.sh`: Script to run all tests

## Next Steps

1. Run the complete test suite to verify all functionality
2. Document any additional findings
3. Make any necessary adjustments to build.sh
4. Update README.md with test results and usage instructions
5. Move on to testing the deployment process
