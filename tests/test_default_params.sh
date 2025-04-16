#!/bin/bash
# Test build.sh with default parameters
echo "Testing build.sh with default parameters"
echo "Expected: Frappe branch: version-15, Image name: serra/frappe, Image tag: v15"

# Execute build.sh with default parameters
../scripts/build.sh

# Check if the image exists
echo "Verifying image creation..."
docker image ls | grep "serra/frappe"
