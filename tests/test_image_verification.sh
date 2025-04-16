#!/bin/bash
# Test image verification
echo "Testing image verification"

# Check if the image exists
echo "Verifying image creation..."
docker image ls | grep "serra/frappe"

# Check if both tags exist
echo "Verifying tags..."
VERSION_TAG=$(docker image ls | grep "serra/frappe" | grep -v "v15$" | awk '{print $2}')
MAIN_TAG=$(docker image ls | grep "serra/frappe:v15$" | awk '{print $2}')

if [ -n "$VERSION_TAG" ] && [ -n "$MAIN_TAG" ]; then
  echo "Test passed: Both version tag and main tag exist"
else
  echo "Test failed: One or both tags are missing"
  echo "Version tag: $VERSION_TAG"
  echo "Main tag: $MAIN_TAG"
fi

# Create a test container to verify functionality
echo "Creating test container to verify functionality..."
CONTAINER_ID=$(docker run -d --rm serra/frappe:v15 bash -c "cd /home/frappe/frappe-bench && bench --version && bench list-apps")

# Get container logs
echo "Container logs:"
docker logs $CONTAINER_ID

# Check if serra-vine-configurator is in the app list
APP_LIST=$(docker logs $CONTAINER_ID | grep -A 10 "bench list-apps")
if echo "$APP_LIST" | grep -q "serra-vine-configurator"; then
  echo "Test passed: serra-vine-configurator is present in the app list"
else
  echo "Test failed: serra-vine-configurator is not in the app list"
fi

# Stop the container
docker stop $CONTAINER_ID
