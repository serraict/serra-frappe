#!/bin/bash
set -e

# Change to the repository root directory
cd "$(dirname "$0")/.."
REPO_ROOT=$(pwd)

# Default values
FRAPPE_PATH="https://github.com/frappe/frappe"
FRAPPE_BRANCH="version-15"
IMAGE_NAME="serra/frappe"
IMAGE_TAG="v15"
BUILD_DATE=$(date -u +"%Y-%m-%d")
VERSION_TAG="${IMAGE_TAG}-${BUILD_DATE}"
PLATFORM="linux/amd64"

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --frappe-branch)
      FRAPPE_BRANCH="$2"
      shift 2
      ;;
    --image-name)
      IMAGE_NAME="$2"
      shift 2
      ;;
    --image-tag)
      IMAGE_TAG="$2"
      VERSION_TAG="${IMAGE_TAG}-${BUILD_DATE}"
      shift 2
      ;;
    --platform)
      PLATFORM="$2"
      shift 2
      ;;
    --help)
      echo "Usage: $0 [options]"
      echo "Options:"
      echo "  --frappe-branch BRANCH    Frappe branch to use (default: version-15)"
      echo "  --image-name NAME         Docker image name (default: serra/frappe)"
      echo "  --image-tag TAG           Docker image tag (default: v15)"
      echo "  --platform PLATFORM       Docker build platform (default: linux/amd64)"
      echo "  --help                    Show this help message"
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
done

echo "Building custom Frappe image with serra-vine-configurator"
echo "========================================================"
echo "Frappe branch: $FRAPPE_BRANCH"
echo "Image name: $IMAGE_NAME"
echo "Image tag: $IMAGE_TAG"
echo "Version tag: $VERSION_TAG"
echo

# Generate base64 encoded apps.json
# Check if we're on macOS or Linux and use appropriate base64 options
if [[ "$OSTYPE" == "darwin"* ]]; then
  # macOS
  APPS_JSON_BASE64=$(base64 -i "$REPO_ROOT/apps.json")
else
  # Linux
  APPS_JSON_BASE64=$(base64 -w 0 "$REPO_ROOT/apps.json")
fi

# Verify apps.json exists
if [ ! -f "$REPO_ROOT/apps.json" ]; then
  echo "Error: apps.json not found at $REPO_ROOT/apps.json"
  exit 1
fi
echo "Using apps.json from $REPO_ROOT/apps.json"
echo

# Build the image with reduced verbosity
echo "Building Docker image..."
echo "Platform: $PLATFORM"
docker build \
  --build-arg=FRAPPE_PATH="$FRAPPE_PATH" \
  --build-arg=FRAPPE_BRANCH="$FRAPPE_BRANCH" \
  --build-arg=APPS_JSON_BASE64="$APPS_JSON_BASE64" \
  --tag="${IMAGE_NAME}:${VERSION_TAG}" \
  --file="$REPO_ROOT/frappe_docker/images/layered/Containerfile" \
  --platform="$PLATFORM" \
  --progress=auto \
  "$REPO_ROOT"

# Tag the image with the main tag
docker tag "${IMAGE_NAME}:${VERSION_TAG}" "${IMAGE_NAME}:${IMAGE_TAG}"

echo
echo "Build completed successfully!"
echo "Image: ${IMAGE_NAME}:${VERSION_TAG}"
echo "Also tagged as: ${IMAGE_NAME}:${IMAGE_TAG}"
echo
echo "To use this image, set the following in your .env file:"
echo "CUSTOM_IMAGE=${IMAGE_NAME}"
echo "CUSTOM_TAG=${IMAGE_TAG}"
echo "PULL_POLICY=never"
