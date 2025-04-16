#!/bin/bash
# Test build.sh with custom image tag
echo "Testing build.sh with custom image tag"
echo "Expected: Frappe branch: version-15, Image name: serra/frappe, Image tag: test-tag"

# Execute build.sh with custom image tag
../scripts/build.sh --image-tag test-tag

# Check if the image exists
echo "Verifying image creation..."
docker image ls | grep "serra/frappe"
