#!/bin/bash
# Test build.sh with custom Frappe branch
echo "Testing build.sh with custom Frappe branch"
echo "Expected: Frappe branch: version-14, Image name: serra/frappe, Image tag: v15"

# Execute build.sh with custom Frappe branch
../scripts/build.sh --frappe-branch version-14

# Check if the image exists
echo "Verifying image creation..."
docker image ls | grep "serra/frappe"
