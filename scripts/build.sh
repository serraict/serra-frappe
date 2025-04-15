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
    --help)
      echo "Usage: $0 [options]"
      echo "Options:"
      echo "  --frappe-branch BRANCH    Frappe branch to use (default: version-15)"
      echo "  --image-name NAME         Docker image name (default: serra/frappe)"
      echo "  --image-tag TAG           Docker image tag (default: v15)"
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
APPS_JSON_BASE64=$(base64 -w 0 "$REPO_ROOT/apps.json")

# Build the image
echo "Building Docker image..."
docker build \
  --build-arg=FRAPPE_PATH="$FRAPPE_PATH" \
  --build-arg=FRAPPE_BRANCH="$FRAPPE_BRANCH" \
  --build-arg=APPS_JSON_BASE64="$APPS_JSON_BASE64" \
  --tag="${IMAGE_NAME}:${VERSION_TAG}" \
  --file="$REPO_ROOT/frappe_docker/images/layered/Containerfile" \
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
