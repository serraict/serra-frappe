#!/bin/bash
# Test build.sh with custom image name
echo "Testing build.sh with custom image name"
echo "Expected: Frappe branch: version-15, Image name: custom/frappe-test, Image tag: v15"

# Execute build.sh with custom image name
../../scripts/build.sh --image-name custom/frappe-test

# Check if the image exists
echo "Verifying image creation..."
docker image ls | grep "custom/frappe-test"
